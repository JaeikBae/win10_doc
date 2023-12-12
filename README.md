# win10 in docker

Run headless container. Connect via VNC.

This repository is originally forked from [m1k1o/win10-in-docker](
	https://github.com/m1k1o/win10-in-docker) and modified to run on my environment.

## Before you start

You must have enabled KVM on the host. 

```sh
sudo systemctl enable libvirtd.service
sudo systemctl enable virtlogd.service
sudo modprobe kvm_intel
```

### Download Windows 10 ISO image

Get official [Windows 10 ISO image](https://www.microsoft.com/en-us/software-download/windows10) from official source.

### Create HDD

Create HDD image, where system will be installed. Choose custom disk size.

```sh
sudo docker build -t win10-hdd -f hdd.Dockerfile .
sudo docker run --rm -v $PWD:/data win10-hdd
```

## Build and run container

```sh
sudo docker build -t win10 .
sudo run.sh
```

## Connect via VNC

- On linux
```sh
vncviewer \<ip-address>:5900
```

- On windows
```sh
run 'vncviewer' and enter '<ip-adress>:5900'
```

