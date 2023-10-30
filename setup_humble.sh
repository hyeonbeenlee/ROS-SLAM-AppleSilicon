# HOW TO USE:
# After clean install of Ubuntu 20.04 Server on VMWare Fusion running on MacOSX,
# cd && mkdir Git && cd Git
# git clone https://github.com/hyeonbeenlee/AppleSilicon-ROS-SLAM.git
# cd AppleSilicon-ROS-SLAM && bash setup.sh
# sudo reboot
# Then, connect to Remote Desktop to {VM's internal IP}:3389
# {VM's internal IP} can be checked by running 'ifconfig'

# Authorize
# Modify "hyeonbeen" to your username
# Modify "hyeonbeen" to your username
sudo usermod -aG sudo hyeonbeen
sudo -- sh -c "echo "hyeonbeen" | sudo -S chmod 777 /home"
sudo -- sh -c "echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers"
# Modify "hyeonbeen" to your username
# Modify "hyeonbeen" to your username


# Install apps
# Modify apt mirrors if necessary
# Modify apt mirrors if necessary
sudo sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
sudo sed -i 's/security.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
sudo sed -i 's/ports.ubuntu.com/ftp.lanet.kr/g' /etc/apt/sources.list
# Modify apt mirrors if necessary
# Modify apt mirrors if necessary
sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install vim git wget curl tmux net-tools openssh-server x11-apps open-vm-tools open-vm-tools-desktop -y
sudo apt-get install fonts-nanum fonts-nanum-coding fonts-nanum-extra -y


# Setup SSH
sudo ssh-keygen -A
mkdir /var/run/sshd
sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo service sshd restart


# Install XRDP
sudo DEBIAN_FRONTEND=noninteractive apt-get install xrdp xfce4 xfce4-session terminator -y
sudo sed -i 's/#AllowRootLogin=false/AllowRootLogin=true/' /etc/xrdp/sesman.ini
sudo systemctl enable xrdp
sudo adduser xrdp ssl-cert
echo xfce4-session >~/.xsession
sudo sed -i 's/exec \/bin\/sh \/etc\/X11\/Xsession//g' /etc/xrdp/startwm.sh
sudo -- sh -c "echo unset DBUS_SESSION_BUS_ADDRESS >>/etc/xrdp/startwm.sh"
sudo -- sh -c "echo unset XDG_RUNTIME_DIR >>/etc/xrdp/startwm.sh"
sudo -- sh -c "echo . $HOME/.profile >>/etc/xrdp/startwm.sh"
sudo -- sh -c "echo exec /bin/sh /etc/X11/Xsession >>/etc/xrdp/startwm.sh"
sudo systemctl restart xrdp
sudo service xrdp restart


# Install firefox
sudo DEBIAN_FRONTEND=noninteractive apt-get install firefox -y


# Install VSCode
sudo DEBIAN_FRONTEND=noninteractive apt-get install wget gpg -y
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo rm -f packages.microsoft.gpg
sudo DEBIAN_FRONTEND=noninteractive apt install apt-transport-https -y
sudo apt update
sudo DEBIAN_FRONTEND=noninteractive apt install code -y


# ROS-Humble installation
sudo apt update && sudo apt install locales -y
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8
sudo apt install software-properties-common -y
sudo add-apt-repository universe
sudo apt update && sudo apt install curl -y
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
sudo apt update && sudo apt upgrade -y
sudo apt install ros-humble-desktop -y
echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
source ~/.bashrc
# ROS Turtlebot3
sudo apt install ros-humble-gazebo-* -y
sudo apt install ros-humble-cartographer -y
sudo apt install ros-humble-cartographer-ros -y
sudo apt install ros-humble-navigation2 -y
sudo apt install ros-humble-nav2-bringup -y
mkdir -p ~/turtlebot3_ws/src
cd ~/turtlebot3_ws/src/
git clone -b humble-devel https://github.com/ROBOTIS-GIT/DynamixelSDK.git
git clone -b humble-devel https://github.com/ROBOTIS-GIT/turtlebot3_msgs.git
git clone -b humble-devel https://github.com/ROBOTIS-GIT/turtlebot3.git
cd ~/turtlebot3_ws
colcon build --symlink-install
echo 'source ~/turtlebot3_ws/install/setup.bash' >> ~/.bashrc
echo 'export ROS_DOMAIN_ID=30 #TURTLEBOT3' >> ~/.bashrc
source ~/.bashrc
cd ~/turtlebot3_ws/src/
git clone -b humble-devel https://github.com/ROBOTIS-GIT/turtlebot3_simulations.git
cd ~/turtlebot3_ws && colcon build --symlink-install
echo "export TURTLEBOT3_MODEL=waffle_pi" >> ~/.bashrc

# Install miniconda
# mkdir -p ~/miniconda3
# wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh -O ~/miniconda3/miniconda.sh
# bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
# rm -rf ~/miniconda3/miniconda.sh
# ~/miniconda3/bin/conda init bash


# Clean and reboot
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get clean && sudo rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
sudo reboot