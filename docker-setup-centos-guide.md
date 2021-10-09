**Uninstall old versions**

Older versions of Docker were called docker or docker-engine. If these are installed, uninstall them, along with associated dependencies.

```
sudo yum remove docker \
    docker-client \
    docker-client-latest \
    docker-common \
    docker-latest \
    docker-latest-logrotate \
    docker-logrotate \
    docker-engine
```

**Set up the repository**

Install the yum-utils package (which provides the yum-config-manager utility) and set up the stable repository.

```
sudo yum install -y yum-utils
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
```

**Install Docker Engine**

Install the latest version of Docker Engine and containerd, or go to the next step to install a specific version:

```
sudo yum install docker-ce docker-ce-cli containerd.io
```

**Start Docker**

```
sudo systemctl enable docker
sudo systemctl start docker
```

**Install Docker Compose**

```
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

```
sudo chmod +x /usr/local/bin/docker-compose
```

```
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```
