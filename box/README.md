## Creating a base vagrant box

This folder contains the script to create a base vagrant box to run the Windows Server 2008 VM. As a user your would not normally need to do this.
The scripts to be run on the host are written in Powershell, therefore it is assumed that the host is a Windows machine.

### Procedure

1. Execute the Powershell script `create-virtualbox-vm.ps1` passing the path to the VHD file, the machine will boot in VirtualBox
2. Login as Administrator and complete the configuration
3. Install the VirtualBox Guest Addition and let it reboot
4. Install any necessary software that you don't want or can't provision later with vagrant
4. Run the following command on the shell of the guest machine, the machine will restart when completed: 
   `@powershell -NoProfile -ExecutionPolicy unrestricted -Command "iex ((new-object net.webclient).DownloadString('https://gist.github.com/tvjames/6750255/raw/33f3a553663b6b6ace77f1eb11ee23d4c58449fd/vagrant_prepare.ps1'))"`
5. Activate Windows: `cscript C:\windows\system32\slmgr.vbs -ato`
6. Reset password expiry for Administrator
7. Shutdown the machine
8. Execute `create-vagrant-box.ps1` on the host machine to package and add box to vagrant, it will take a while