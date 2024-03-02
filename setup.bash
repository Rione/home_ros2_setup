#!/bin/bash
set -e
#SPDX-FileCopyrightText: 2022 Ryuichi Ueda ryuichiueda@gmail.com
#SPDX-License-Identifier: BSD-3-Clause

UBUNTU_VER=$(lsb_release -sc)
ROS_VER=humble

[ "$UBUNTU_VER" != "jammy" ] &&
    { echo "Please use Ubuntu 22.04 to run this script. Aborting..."; exit 1; }

apt list --installed 2>/dev/null | grep -q "ros-${ROS_VER}" &&
    { echo "ROS packages are already installed. Aborting..."; exit 1; }

sudo apt update
sudo apt install -y curl gnupg2
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

echo "deb [ signed-by=/usr/share/keyrings/ros-archive-keyring.gpg arch=amd64,arm64] http://packages.ros.org/ros2/ubuntu ${UBUNTU_VER} main" |
sudo tee /etc/apt/sources.list.d/ros2-latest.list

#sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F42ED6FBAB17C654
sudo apt update
sudo apt install -y ros-${ROS_VER}-desktop python3-colcon-common-extensions python3-rosdep python3-argcomplete

sudo rm -f /etc/ros/rosdep/sources.list.d/20-default.list
sudo rosdep init
sudo rosdep fix-permissions

# echo "source /opt/ros/${ROS_VER}/setup.bash" >> ~/.bashrc

rosdep update

sudo apt install -y direnv

printf 'source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash
source /usr/share/colcon_cd/function/colcon_cd.sh
eval "$(direnv hook bash)"\n' >> ~/.bashrc

echo '***INSTRUCTION*****************'
echo '* do the following command    *'
echo '* $ source ~/.bashrc          *'
echo '*******************************'
