##########################################################################
#
# Host is an abstraction for the host system we are building VMs on.
#
##########################################################################
class Host
  CPU_NAME = 0
  CPU_COUNT = 1
  RAM = 2
  OS_NAME = 3
  HV_EXISTS = 4

  @@specs = nil

  def self.get()
    if OS.apple_silicon?
      return AppleSiliconHost.new
    elsif OS.mac?
      return IntelMacHost.new
    elsif OS.windows?
      return WindowsHost.new
    elsif OS.linux_arm?
      return ArmLinuxHost.new
    elsif OS.linux?
      return IntelLinuxHost.new
    else
      raise DetectionError.new "FATAL - Cannot determine your operating system"
    end
  end

  def get_system_name()
    return ""
  end

  def gateway_addresses()
    ""
  end
end

class WindowsHost < Host
  include Powershell

  def physical_ram_gb()
    if not @@specs
      self.get_sysinfo()
    end
    return @@specs[RAM].to_i
  end

  def cpu_count()
    if not @@specs
      self.get_sysinfo()
    end
    return @@specs[CPU_COUNT].to_i
  end

  def cpu_name()
    if not @@specs
      self.get_sysinfo()
    end
    return @@specs[CPU_NAME]
  end

  def os_name()
    if not @@specs
      self.get_sysinfo()
    end
    return @@specs[OS_NAME]
  end

  def hypervisor_name()
    return "VirtualBox"
  end

  def hypervisor_exists?
    if not @@specs
      self.get_sysinfo()
    end
    @@specs[HV_EXISTS] == "1"
  end

  private

  def get_sysinfo()
    ps = <<~PS
      $p = Get-CimInstance Win32_Processor | Select-Object NumberOfLogicalProcessors, Name
      $m = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB
      $o = (Get-CimInstance Win32_OperatingSystem | select -ExpandProperty Name).split('|') | Select-Object -First 1
      $hv = 0
      try {
        $d = Get-ItemProperty hklm:Software/Oracle/VirtualBox -PSProperty InstallDir -ErrorAction Stop
        if (Test-Path (Join-Path $d.InstallDir vboxmanage.exe)) {
          $hv = 1
        }
      }
      catch {}
      Write-Host "$($p.Name)/$($p.NumberOfLogicalProcessors)/$m/$o/$hv"
    PS
    @@specs = self.powershell(ps).split("/")
  end
end

class MacHost < Host
  def physical_ram_gb()
    if not @@specs
      self.get_sysinfo()
    end
    return @@specs[RAM].to_i / 1073741824
  end

  def cpu_count()
    if not @@specs
      self.get_sysinfo()
    end
    return @@specs[CPU_COUNT].to_i
  end

  def cpu_name()
    if not @@specs
      self.get_sysinfo()
    end
    return @@specs[CPU_NAME]
  end

  def os_name()
    if not @@specs
      self.get_sysinfo()
    end
    return @@specs[OS_NAME]
  end

  def get_system_name()
    return "Mac"
  end

  def gateway_addresses()
    cmd = "netstat -rn -f inet | egrep '^default.*UGS' | awk '{print $2}' | xargs echo | tr ' ' ','"
    %x{ #{cmd} }.chomp()
  end

  private

  def get_sysinfo()
    sh = <<~SHEL
      pc=$(sysctl -n "hw.ncpu")
      m=$(sysctl -n "hw.memsize")
      pn=$(sysctl -n "machdep.cpu.brand_string")
      os_name=$(awk '/SOFTWARE LICENSE AGREEMENT FOR macOS/' '/System/Library/CoreServices/Setup Assistant.app/Contents/Resources/en.lproj/OSXSoftwareLicense.rtf'  | awk -F 'macOS ' '{print $NF}' | awk '{print substr($0, 0, length($0)-1)}')
      os_ver=$(sw_vers | awk '/ProductVersion/ { print $2 }')
      echo "${pn}/${pc}/${m}/${os_name} ${os_ver}"
    SHEL
    @@specs = %x{ #{sh} }.chomp().split("/")
  end
end

class IntelMacHost < MacHost
  def hypervisor_name()
    return "VirtualBox"
  end

  def hypervisor_exists?
    Dir.exists?("/Applications/VirtualBox.app")
  end
end

class AppleSiliconHost < MacHost
  def hypervisor_name()
    return "VMware Fusion"
  end

  def hypervisor_exists?
    Dir.exists?("/Applications/VMware Fusion.app")
  end
end

class LinuxHost < Host
  def physical_ram_gb()
    if not @@specs
      self.get_sysinfo()
    end
    return @@specs[RAM].to_i / 1048576
  end

  def cpu_count()
    if not @@specs
      self.get_sysinfo()
    end
    return @@specs[CPU_COUNT].to_i
  end

  def cpu_name()
    if not @@specs
      self.get_sysinfo()
    end
    return @@specs[CPU_NAME]
  end

  def os_name()
    if not @@specs
      self.get_sysinfo()
    end
    return @@specs[OS_NAME]
  end

  private

  def get_sysinfo
    sh = <<~SHEL
      m=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
      pc=$(nproc)
      pn=$(cat /proc/cpuinfo | grep "model name" | uniq | cut -d ':' -f 2 | sed "s/^[ ]*//")
      o=$(source /etc/os-release && echo -n "$NAME $VERSION")
      echo "${pn}/${pc}/${m}/${o}"
    SHEL
    @@specs = %x{ #{sh} }.chomp().split("/")
  end
end

class IntelLinuxHost < LinuxHost
  def hypervisor_name()
    return "VirtualBox"
  end

  def hypervisor_exists?
    sh = <<~SHEL
      if command -v VBoxManage > /dev/null
      then
        echo -n "1"
      else
        echo -n "0"
      fi
    SHEL
    %x{ #{sh} }.chomp() == "1"
  end

  def get_system_name()
    return "Intel"
  end
end

class ArmLinuxHost < LinuxHost
  def hypervisor_name()
    return "VMware Workstation"
  end

  def hypervisor_exists?
    sh = <<~SHEL
      if command -v vmrun > /dev/null
      then
        echo -n "1"
      else
        echo -n "0"
      fi
    SHEL
    %x{ #{sh} }.chomp() == "1"
  end

  def get_system_name()
    return "ARM"
  end
end
