# An ova file is a complete archive with all of the information to create a VirtualBox VM included inside it. You would use the command:

# vboxmanage import test.ova

# This will create the VM in your default VM location, with the same settings as the original VM. 

# To change the VM name you'd use:

# vboxmanage import test.ova --vsys 0 --vmname <name>


# From virtualbox manual (http://www.virtualbox.org/manual)

# Suggested VM base folder "/home/klaus/VirtualBox VMs"
# (change with "--vsys 0 --basefolder <path>")

# Number of CPUs: 1
# (change with "--vsys 0 --cpus <n>")

# Guest memory: 956 MB
# (change with "--vsys 0 --memory <MB>")

