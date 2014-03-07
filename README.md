# A virtual build environment for NUnit

This repository contains a virtual build environment for [NUnit](https://github.com/nunit/), running on [Vagrant](http://www.vagrantup.com/).

It consists of two virtual machines, one running Ubuntu Linux and the other running Windows Server 2008 R2.
Together they can build most flavors currently available for NUnit. 

The build environment is based on [TeamCity 8](http://www.jetbrains.com/teamcity/), installed in the free, professional edition.

### Requirements

- [VirtualBox](https://www.virtualbox.org/)
- VirtualBox Extensions
- [Vagrant](http://www.vagrantup.com/)
- [vagrant-windows](https://github.com/WinRb/vagrant-windows) plugin `vagrant plugin install vagrant-windows`

You'll also need some spare memory on your machine and plenty of bandwidth and time for the initial bootstrap.

## Installation

This has been tested on a Windows 7 host, in theory it might work just as well on non-Windows machines but it hasn't been tested.

1. `git clone https://github.com/simoneb/nunit-ci.git && cd nunit-ci`
- `git submodule update --init`
- `vagrant up server`. The first time it will take a while, wait until provisioning is complete then:
- Browse to [audrey.xip.io](http://audrey.xip.io) (yes, that's your local VM) and complete the installation and configuration. Default options are good, you just need to create a user.
- `vagrant up windows_agent`. The first time it will download the box, which is huge, import it and then install many dependencies. Wait until provisioning is complete then logoff and logon with the `vagrant/vagrant` account to start the agent.
> Do not reboot a machine managed by Vagrant from within the machine because at startup it will not re-mount the shared folders it needs to work properly. Only use Vagrant commands like `vagrant halt` or `vagrant reload`.
- Browse to the server UI and authorize the agent in the [Agents](http://audrey.xip.io/agents.html?tab=unauthorizedAgents) tab. The Windows agent will take a while to be active the first time because it will need to upgrade.

## Using

Once the environment is bootstrapped it can be managed using the Vagrant command line tools. Server and agents are configured to start automatically so you can _suspend_ or _halt_ the machines to your liking. You won't probably need to do much else besides using the Web interface to manage the builds.

The TeamCity configuration is stored in the repository, this means that after bootstrap the environment is ready to be used. You'll be sharing only the configuration of the projects with other people (build configurations, VCS roots, ...) but data, like builds history, artifacts, logs and so on remains on your disk.

#### Supported platforms and frameworks

- Windows .NET 2.0, 3.5, 4.0, 4.5_.1_
- Windows mono 2.0, 3.5, 4.0
- Linux mono 2.0, 3.5, 4.0
- .NET Compact Framework 2.0, 3.5
- Silverlight 5.0