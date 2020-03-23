sudo apt-get update

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
	

export DOCKER_EE_VERSION=19.03

curl -fsSL "${DOCKER_EE_URL}/ubuntu/gpg" | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=$(dpkg --print-architecture)] $DOCKER_EE_URL/ubuntu \
   $(lsb_release -cs) \
   stable-$DOCKER_EE_VERSION"
   
   
sudo apt-get update   

sudo apt-get install -y docker-ee docker-ee-cli containerd.io

# config docker master to use non-privelenge user
# https://docs.docker.com/install/linux/linux-postinstall/

sudo groupadd docker
#sudo usermod -aG docker $USER
sudo usermod -aG docker vagrant

sudo systemctl enable docker


 sudo usermod -a -G sudo jenkins

sudo apt-get install docker-compose
