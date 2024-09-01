######################################################################################
#
# Box describes the box resource that will be instantiated by the hypervisor along
# with an optional provision script. A box version from one supplier may not have
# the same things pre-installed as the same OS version from another, so the provision
# script will align to the most provisioned box.
#
######################################################################################

class Box
  @name
  @provision

  def initialize(name, provision)
    @name = name
    @provision = provision
  end

  def box
    @name
  end

  def provision_script
    @provision
  end

  def needs_provision?
    @provision != ""
  end
end

######################################################################################
#
# Hypervisor is an abstraction for the type of virtualization running on the host.
# - ARM machines = VMware
# - Intel machines = VirtualBox
#
######################################################################################
class Hypervisor
  @@node = nil
  @@workdir = File.dirname(__FILE__)
  @yq_version = "v4.44.2"

  # Create Hypervisor support for the current VM node
  def self.get(node:)
    @@node = node

    if OS.arm?
      yield VMware.new
    end

    yield VirtualBox.new
  end

  # Deploy the VM with given index
  def deploy(vm:, network:, index:)
    self.set_spec cpu: vm[:cpu], memory: vm[:memory]
    self.network network: network, index: index
    self.set_hostname hostname: vm[:name]
    if vm[:box].needs_provision?
      @@node.vm.provision "box-alignment", type: "shell", inline: vm[:box].provision_script
    end
    if vm.key?(:packages)
      # If there are packages to install in guest, install them
      self.provision_script vm[:packages].join(","), script: "package_install.sh"
    end
    if vm.key?(:ports)
      if network[:network_type] == "NAT"
        # If port fowards defined and networking is NAT
        vm[:ports].each do |portspec|
          p = portspec.split(":", -1)
          if p.length < 2
            puts "WARNING: Invalid port forward #{portspec}. Ignored."
          else
            self.port_forward host: p[0], guest: p[1]
          end
        end
      else
        puts "Port Forward rules ignored for BRIDGE network. They are unnecessary."
      end
    end
  end

  def network(network:, index:)
    typ = network[:network_type]
    if not(typ == "NAT" or typ == "BRIDGE")
      raise Exception.new "Invalid network type #{typ}. Must be NAT or BRIDGE"
    end
    if typ == "BRIDGE" and !self.can_bridge?
      puts "WARNING: Hypervisor does not support BRIDGE. Falling back to NAT"
      network[:network_type] = "NAT"
      typ = "NAT"
    end
    if typ == "NAT"
      @@node.vm.network :private_network, ip: network[:private_network] + "#{network[:ip_start] + index}"
    else
      b = self.bridge_adapter
      if b == ""
        @@node.vm.network :public_network
      else
        @@node.vm.network :public_network, bridge: self.bridge_adapter
      end
    end
    h = Host.get
    self.provision_script network[:private_network], network[:network_type], h.gateway_addresses, script: "setup_host.sh"
  end

  # Run a shell script from distro specific directort
  def provision_script(*args, script:)
    s = ""
    if File.exists?(File.join(@@workdir, "linux", script))
      s = File.join(@@workdir, "linux", script)
    else
      raise Exception.new "Provisioner script not found: #{script}"
    end
    if args.length() > 0
      @@node.vm.provision script, type: "shell", path: s do |prov|
        prov.args = args
      end
    else
      @@node.vm.provision script, type: "shell", path: s
    end
  end

  # Return a working CentOS (or equivalent) box image for the current architecture
  def self.centos()
    if OS.arm?
      script = <<~EOF
        # Install EPEL
        dnf config-manager --set-enabled crb
        dnf install -y epel-release epel-next-release
        # Install YQ
        echo "Installing yq..."
        curl -sLo yq https://github.com/mikefarah/yq/releases/download/#{@yq_version}/yq_linux_arm64
          chmod +x yq
          mv yq /usr/bin/yq
      EOF
      return Box.new "bento/centos-stream-9-arm64", script
    end
    script = <<~EOF
      # Install YQ
      echo "Installing yq..."
      curl -sLo yq https://github.com/mikefarah/yq/releases/download/#{@yq_version}/yq_linux_amd64
        chmod +x yq
        mv yq /usr/bin/yq
    EOF
    return Box.new "boxomatic/centos-stream-9", script
  end

  def self.ubuntu()
    arch = OS.arm? ? "arm64" : "amd64"
    script = <<~EOF
      # Install JQ/YQ
      export DEBIAN_FRONTEND=noninteractive
      apt-get update
      apt-get install -y jq
      echo "Installing yq..."
      curl -sLo yq https://github.com/mikefarah/yq/releases/download/#{@yq_version}/yq_linux_#{arch}
        chmod +x yq
        mv yq /usr/bin/yq
    EOF
    if OS.arm?
      return Box.new "bento/ubuntu-22.04-arm64", script
    end
    return Box.new "ubuntu/jammy64", script
  end

  def can_bridge?
    true
  end

  def bridge_adapter
    ""
  end

  private

  # Port forward the given guest port to given port on host
  def port_forward(guest:, host:)
    @@node.vm.network "forwarded_port", guest: guest, host: host
  end
end

class VMware < Hypervisor
  # TODO - work out bridging
  def set_hostname(hostname:)
    @@node.vm.provision "set-hostname", type: "shell", inline: "sudo hostnamectl set-hostname #{hostname}"
  end

  def set_spec(cpu:, memory:)
    @@node.vm.provider "vmware_desktop" do |v|
      v.vmx["numvcpus"] = "#{cpu}"
      v.vmx["memsize"] = "#{memory}"
    end
  end
end

class VirtualBox < Hypervisor
  include Powershell

  def set_hostname(hostname:)
    @@node.vm.hostname = hostname
    # virtualbox UI name
    @@node.vm.provider "virtualbox" do |v|
      v.name = hostname
    end
  end

  def set_spec(cpu:, memory:)
    @@node.vm.provider "virtualbox" do |v|
      v.cpus = cpu
      v.memory = memory
    end
  end

  def can_bridge?
    # TODO linux one day
    not OS.linux?
  end

  def bridge_adapter
    if OS.windows?
      return self.powershell("Get-NetRoute -DestinationPrefix 0.0.0.0/0 | Get-NetAdapter | Select-Object -ExpandProperty InterfaceDescription")
    elsif OS.intel_mac?
      sh = <<~SHEL
        iface=$(netstat -rn -f inet | grep '^default' | sort | head -1 | awk '{print $4}')
        interface=$(VBoxManage list bridgedifs | awk '/^Name:/ { print }' | sed -e 's/^Name:[ ]*\(.*\)/\1/' | grep $iface)
        echo -n $interface
      SHEL
      return %x{ #{sh} }.chomp()
    else
      return ""
    end
  end
end

class DetectionError < RuntimeError
end
