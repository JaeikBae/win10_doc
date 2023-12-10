docker stop win10-in-docker
docker run --name win10-in-docker \
            -p 5900:5900 \
            --privileged \
            -v /lib/modules:/lib/modules \
            -v /dev:/dev \
            -v ./Win10_22H2_English_x64v1.iso:/home/arch/win10_x64.iso 	\
            -v ./win10_hdd.img:/home/arch/win10_hdd.img \
            --rm -e DISPLAY=:1 \
            -v /tmp/.X11-unix:/tmp/.X11-unix \
            win10 
sleep 3
vncviewer 127.0.0.1:5900