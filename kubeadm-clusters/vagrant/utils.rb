################################################################
#
# Everything in here is for multi-platform support
# Handles differences between Windows, Intel Mac, AS Mac etc.
#
# Do not edit unless you _really_ know what you are doing!
#
################################################################

require "base64"

# Operating system detection
module OS
  def OS.windows?
    (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  end

  def OS.mac?
    (/darwin/ =~ RUBY_PLATFORM) != nil
  end

  def OS.apple_silicon?
    RUBY_PLATFORM == "arm64-darwin"
  end

  def OS.intel_mac?
    OS.mac? and not OS.apple_silicon?
  end

  def OS.unix?
    !OS.windows?
  end

  def OS.linux_arm?
    RUBY_PLATFORM == "aarch64_linux"
  end

  def OS.linux?
    OS.unix? and not OS.mac?
  end

  def OS.arm?
    OS.apple_silicon? || OS.linux_arm?
  end
end

# Mixin module to provide powershell execution for Host and Hypervisor
module Powershell
  def powershell(cmd)
    encoded_cmd = Base64.strict_encode64(cmd.encode("utf-16le"))
    return %x{powershell.exe -EncodedCommand #{encoded_cmd}}.chomp()
  end
end

# Prints text with box delimiters left and right
def b_puts(str, width = 71)
  padding = width - 4 - str.length
  if padding < 1
    padding = 1
  end
  pad = " " * padding
  puts "│ #{str}#{pad} │"
end

def show_system_info(trigger, host)
  begin #
    puts "┌─────────────────────────────────────────────────────────────────────┐"
    #b_puts("")
    b_puts("If raising a question on our forums, please include the contents")
    b_puts("of this box with your question. It will help us to identify issues")
    b_puts("with your system.")
    b_puts("")
    b_puts("Detecting your hardware...")
    b_puts("- System: #{host.os_name()}")
    b_puts("- CPU:    #{host.cpu_name()} (#{host.cpu_count()} cores)")
    b_puts("- RAM:    #{host.physical_ram_gb()} GB")
    if !host.hypervisor_exists?
      raise DetectionError.new "FATAL - Missing #{host.hypervisor_name()}. Please install it first."
    end
  rescue DetectionError => e
    b_puts("#{e}")
    trigger.abort = true
    raise
  ensure
    #b_puts("")
    puts "└─────────────────────────────────────────────────────────────────────┘"
  end
end

def validate_configuration(trigger, host, vms)
  requested_ram = 0
  vms.each do |vm|
    requested_ram += vm[:memory]
  end
  if (requested_ram / 1024) > host.physical_ram_gb - 2
    puts <<~EOT
           Total RAM requested by VMs is more than your machine can provide!
           Either reduce the memory requirement of the VMs or have fewer VMs

         EOT
    trigger.abort = true
    raise Exception.new "Invalid configuration. See messages above\n\n"
  end
end

require "tmpdir"

def post_provision(env)
  # Build hosts file fragment
  puts "--> Harvesting machine IPs"
  hosts = ""
  env.active_machines.each do |active_machine|
    vm_name = active_machine[0].to_s
    ip = %x{ vagrant ssh -c primary-ip #{vm_name} }.chomp()
    hosts << ip << " " << vm_name << "\n"
  end
  # Adjust hosts file
  hosts_tmp = File.join(File.dirname(__FILE__), "hosts.tmp")
  File.open(hosts_tmp, "w") { |file| file.write(hosts) }
  env.active_machines.each do |active_machine|
    vm_name = active_machine[0].to_s
    puts "--> Setting hosts file: #{vm_name}"
    %x{ vagrant ssh -c 'sudo /opt/vagrant/update-hosts.sh' #{vm_name}}
  end
  puts ""
  puts hosts
  File.delete hosts_tmp
end
