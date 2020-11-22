#!/bin/sh
USER_NAME=wine
echo "You can run Kindle as follows:\n\n\$ wine '/home/$USER_NAME/.wine/drive_c/Program Files/Amazon/Kindle/Kindle.exe'\n"

sudo docker run -e DISPLAY \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v $PWD/$USER_NAME:/home/$USER_NAME　\
        --ipc="host" \
        -it kindle_wine \
        bash

#        