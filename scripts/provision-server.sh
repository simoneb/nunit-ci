#!/bin/sh

TEAMCITY_PACKAGE=TeamCity-8.1a.tar.gz

# prerequisites for the add-apt-repository command
sudo apt-get install python-software-properties -y
sudo apt-get install software-properties-common -y

# required to install a recent mono version
sudo add-apt-repository ppa:directhex/monoxide

sudo apt-get update -y
sudo apt-get install openjdk-7-jre-headless -y
sudo apt-get install mono-devel -y

if [ ! -f /vagrant/downloads/${TEAMCITY_PACKAGE} ]; then
  echo "TeamCity package $TEAMCITY_PACKAGE not found, downloading"
  wget -P /vagrant/downloads http://download.jetbrains.com/teamcity/${TEAMCITY_PACKAGE}
fi

if [ -d TeamCity ]; then
  echo "Stopping TeamCity server"
  TeamCity/bin/teamcity-server.sh stop
  echo "Stopping TeamCity agent"
  TeamCity/buildAgent/bin/agent.sh stop force
  echo "Removing existing TeamCity installation"
  rm -rf TeamCity
fi

echo "Unpacking TeamCity"
tar -xzf /vagrant/downloads/${TEAMCITY_PACKAGE}

echo "Changing server port from 8111 to 80"
sed -i.bak -e s/8111/80/g TeamCity/conf/server.xml

echo "Replacing agent configuration file"
cp /vagrant/config/buildAgent.linux.properties TeamCity/buildAgent/conf/buildAgent.properties

echo "Configuring server and agent to startup automatically at boot"
cat > /etc/init.d/teamcity <<EOF
#! /bin/sh
export TEAMCITY_DATA_PATH="/vagrant/TeamCityData"
/home/vagrant/TeamCity/bin/runAll.sh start
EOF

chmod +x /etc/init.d/teamcity
sudo update-rc.d -f teamcity defaults

echo "Starting TeamCity"
/etc/init.d/teamcity