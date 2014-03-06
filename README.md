## A complete build environment for NUnit

This repository contains a complete build environment for NUnit, running on vagrant. 

It consists of two virtual machines, a Ubuntu Linux host and a Windows Server 2008 R2 host.
The build environment is based on [TeamCity](http://www.jetbrains.com/teamcity/).
The Linux machine runs the server and one agent, whereas the Windows machine runs another agent.

### Requirements

- [VirtualBox](https://www.virtualbox.org/)
- VirtualBox Extensions
- [Vagrant](http://www.vagrantup.com/)
- [vagrant-windows](https://github.com/WinRb/vagrant-windows) vagrant plugin (`vagrant plugin install vagrant-windows`)

...plus some spare RAM, lots of bandwidth and time for the initial bootstrap.

### Installation

- Clone this repository and CD into the clone location
- Pull git submodules: `git submodule update --init`
- Run `varant up server`. The first time the server is bootstrapped it will download lots of stuff, be sure to have a fast internet connection, subsequent boots will require much less data and will be much quicker
- Browse to the [server UI](http://192.168.30.10:8111) and complete installation and configuration of the TeamCity server (default options are good)
- Run `vagrant up windows_agent`. The first time it will download the box, which is huge, import it and then install many dependencies. Wait until provisioning is complete then logoff and logon with the `vagrant/vagrant` account to start the agent
- Browse to the server UI and authorize the agents in the [Agents](http://192.168.30.10:8111/agents.html?tab=unauthorizedAgents) tab
- The Windows agent will take a while to be active the first time because it will need to upgrade