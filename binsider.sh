# Copyright 2023 Elijah Gordon (NitrixXero) <nitrixxero@gmail.com>

# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

VERSION="1.0"
AUTHOR="Elijah Gordon"

show_version() {
    echo "Script Version: $VERSION"
    echo "Author: $AUTHOR"
}

show_help() {
    echo "Usage: $(basename "$0") [-hicmdunlkagfsteDAPv]"
    echo "Options:"
    echo "  -h, --help             Show this help message and exit."
    echo "  -v, --version          Show script version and exit."
    echo "  -i, --hostname         Show hostname."
    echo "  -c, --os               Show operating system and version."
    echo "  -m, --cpu              Show CPU information."
    echo "  -d, --memory           Show total memory and swap memory."
    echo "  -u, --disk             Show disk usage."
    echo "  -n, --network          Show network interfaces."
    echo "  -l, --users            Show current users."
    echo "  -k, --uptime           Show system uptime."
    echo "  -a, --load             Show system load average."
    echo "  -g, --gpu              Show GPU information (if available)."
    echo "  -f, --filesystem       Show mounted filesystems."
    echo "  -s, --services         Show active services."
    echo "  -t, --temperature      Show system temperature (if available)."
    echo "  -D, --disk-space       Show system disk space usage."
    echo "  -A, --packages         Show available packages."
    echo "  --arch                 Show system architecture."
    echo "  --cpu-cache            Show CPU cache information."
    echo "  --memory-usage         Show memory usage by processes."
    echo "  --disk-space-by-dir    Show disk space usage by directories (Top 10 largest)."
    echo "  --network-stats        Show network statistics."
    echo "  --startup-time         Show system startup time."
    echo "  --bios-version         Show BIOS/UEFI version (if available)."
    echo "  --active-connections   Show active network connections."
}

show_hostname() {
    echo "Hostname: $(hostname)"
}

show_os_info() {
    echo "Operating System: $(uname -s)"
    echo "OS Version: $(uname -r)"
    echo "Distribution Info: $(lsb_release -ds)"
}

show_cpu_info() {
    echo "CPU Information:"
    lscpu
}

show_memory_info() {
    echo "Total Memory: $(free -h | awk '/^Mem:/ {print $2}')"
    echo "Swap Memory: $(free -h | awk '/^Swap:/ {print $2}')"
}

show_disk_usage() {
    echo "Disk Usage:"
    df -h
}

show_active_network_connections() {
    echo "Active Network Connections:"
    netstat -tuln
}

show_bios_version() {
    if command -v dmidecode >/dev/null 2>&1; then
        echo "BIOS/UEFI Version:"
        dmidecode -t bios | grep -i "version\|release date"
    else
        echo "BIOS/UEFI version information is not available (dmidecode command not found)."
    fi
}

show_startup_time() {
    echo "System Startup Time:"
    who -b
}

show_network_statistics() {
    echo "Network Statistics:"
    netstat -s | grep -i "error\|drop"
}

show_memory_usage_by_processes() {
    echo "Memory Usage by Processes:"
    ps -eo pid,user,%mem,cmd --sort=-%mem | head -n 11
}

show_disk_space_usage_by_directories() {
    echo "Disk Space Usage by Directories (Top 10 Largest):"
    du -h / 2>/dev/null | sort -rh | head -n 11
}

show_system_architecture() {
    echo "System Architecture:"
    uname -m
    echo "CPU Endianness:"
    lscpu | grep "Byte Order"
}

show_cpu_cache() {
    echo "CPU Cache Information:"
    lscpu | grep -i "cache"
}

show_network_interfaces() {
    echo "Network Interfaces:"
    ip -br address
}

show_current_users() {
    echo "Current Users:"
    who
}

show_uptime() {
    echo "Uptime:"
    uptime
}

show_load_average() {
    echo "Load Average:"
    cat /proc/loadavg
}

show_kernel_version() {
    echo "Kernel Version: $(uname -v)"
}

show_available_disk_space() {
    echo "Available Disk Space:"
    df -h --output=source,fstype,avail
}

show_system_temperature() {
    if command -v sensors >/dev/null 2>&1; then
        echo "System Temperature:"
        sensors
    else
        echo "System temperature information is not available (sensors command not found)."
    fi
}

show_gpu_info() {
    if command -v lspci >/dev/null 2>&1; then
        echo "GPU Information:"
        lspci | grep -i vga
    else
        echo "GPU information is not available (lspci command not found)."
    fi
}

show_mounted_filesystems() {
    echo "Mounted Filesystems:"
    mount | column -t
}

show_active_services() {
    if command -v systemctl >/dev/null 2>&1; then
        echo "Active Services:"
        systemctl list-units --type=service --state=running
    else
        echo "Systemd is not available (systemctl command not found)."
    fi
}

show_system_disk_space() {
    echo "System Disk Space Usage:"
    du -h / | sort -h
}

show_available_packages() {
    if command -v dpkg >/dev/null 2>&1; then
        echo "Available Packages (Debian/Ubuntu):"
        dpkg --list
    elif command -v rpm >/dev/null 2>&1; then
        echo "Available Packages (RPM-based):"
        rpm -qa
    else
        echo "Package information is not available (dpkg/rpm commands not found)."
    fi
}

main() {
    echo "System Information:"
    echo "-------------------"

    if [ $# -eq 0 ]; then
        show_help
        exit 1
    fi

    while [ "$#" -gt 0 ]; do
        case $1 in
            -h|--help) show_help ;;  
            -i|--hostname) show_hostname ;;
            -c|--os) show_os_info ;;
            -m|--cpu) show_cpu_info ;;
            -d|--memory) show_memory_info ;;
            -u|--disk) show_disk_usage ;;
            -n|--network) show_network_interfaces ;;
            -l|--users) show_current_users ;;
            -k|--uptime) show_uptime ;;
            -a|--load) show_load_average ;;
            -g|--gpu) show_gpu_info ;;
            -f|--filesystem) show_mounted_filesystems ;;
            -s|--services) show_active_services ;;
            -t|--temperature) show_system_temperature ;;
            -D|--disk-space) show_system_disk_space ;;
            -A|--packages) show_available_packages ;;
            -v|--version) show_version ;; 
            --arch) show_system_architecture ;;
            --cpu-cache) show_cpu_cache ;;
            --memory-usage) show_memory_usage_by_processes ;;
            --disk-space-by-dir) show_disk_space_usage_by_directories ;;
            --network-stats) show_network_statistics ;;
            --startup-time) show_startup_time ;;
            --bios-version) show_bios_version ;;
            --active-connections) show_active_network_connections ;;
            *) echo "Invalid option. Use '$(basename "$0") --help' for usage information." >&2
               exit 1 ;;
        esac
        shift
    done
}

main "$@"
