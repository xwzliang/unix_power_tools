# An ova file is a complete archive with all of the information to create a VirtualBox VM included inside it. You would use the command:

vboxmanage import <ova file>

# This will create the VM in your default VM location, with the same settings as the original VM. 

# To change the VM name you'd use:

vboxmanage import <ova-file> --vsys 0 --vmname <name>


# From virtualbox manual (http://www.virtualbox.org/manual)

# Suggested VM base folder "/home/klaus/VirtualBox VMs"
# (change with "--vsys 0 --basefolder <path>")

# Number of CPUs: 1
# (change with "--vsys 0 --cpus <n>")

# Guest memory: 956 MB
# (change with "--vsys 0 --memory <MB>")


# To start a VM, run

vboxmanage startvm <name or UUID>

# You can optionally specify a --type parameter to control how the VM is started. Using --type gui will show it via the host GUI; using --type headless means you’ll need to interact over the network (typically via SSH). To emulate Vagrant/Docker Machine-like behavior, you’d use --type headless.

# To control running vm:

vboxmanage controlvm <subcommand>

# for most other operations. Valid <subcommands> related to VM state operations include pause, resume, reset, poweroff, and savestate

# To unregister (remove) a stopped VM

vboxmanage unregister <name or UUID>

# Keep in mind this does not delete the VM’s files. To delete the files, add the --delete flag to the command.


# Viewing and Modifying the Configuration of a Stopped VM

# To view the information about a VM, run

vboxmanage showvminfo <name or UUID>

# To change the configuration of a stopped VM, you’ll use the modifyvm
# To change the name of a VM, use

vboxmanage modifyvm <name or UUID> --name <new name>

# Note that you wouldn’t want to do this for Vagrant- or Docker Machine-managed VirtualBox VMs, as you would likely break the relationship between the VM and Vagrant/Docker Machine.

# To change the amount of RAM assigned to a VM, use

vboxmanage modifyvm <name or UUID> --memory <RAM in MB>

# To change the number of virtual CPUs assigned to a VM, use

vboxmanage modifyvm <name or UUID> --cpus <number>
