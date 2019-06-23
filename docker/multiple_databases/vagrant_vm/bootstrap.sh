# https://adhoctuts.com/run-mulitple-databases-in-single-machine-using-docker-vagrant/

yum update && yum upgrade

## install docker, https://docs.docker.com/install/linux/docker-ce/centos/
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
				  
sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
  
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
	
sudo yum-config-manager --enable docker-ce-nightly

sudo yum install -y docker-ce docker-ce-cli containerd.io

sudo systemctl start docker
sudo systemctl enable docker

## install docker-compose, https://docs.docker.com/compose/install/
yum install -y curl
sudo curl -L "https://github.com/docker/compose/releases/download/1.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

## install additional utilities
yum install nano tree -y
