sudo docker stop win10-in-docker
sudo docker run --name win10-in-docker \
	    --network=host \
            --privileged \
            -v /lib/modules:/lib/modules \
            -v /dev:/dev \
            -v $PWD/win10.iso:/home/arch/win10_x64.iso 	\
            -v $PWD/win10_hdd.img:/home/arch/win10_hdd.img \
            --rm -d \
            win10
