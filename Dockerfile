FROM ubuntu:19.10

ARG DISPLAY=:0

ENV DEBIAN_FRONTEND noninteractive

#USER root
ENV DISPLAY ${DISPLAY}

ENV WINEPREFIX /home/wineuser/.wine
ENV WINEARCH win32

RUN   mkdir /tmp/.X11-unix && \
    chmod 1777 /tmp/.X11-unix
VOLUME /tmp/.X11-unix/ #:/tmp/.X11-unix/

RUN dpkg --add-architecture i386 && apt update && apt install -y --no-install-recommends \
	xvfb \
	xauth \
	x11-utils \
	x11-xserver-utils \
	wine \
	wine32 \
	winetricks \
	ca-certificates \
	cabextract \
	&& \
	apt-get autoremove -y --purge software-properties-common && \
	apt-get autoremove -y --purge && \
	apt-get clean -y && \
	rm -rf /home/wine/.cache && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


RUN winetricks -q dotnet40 
#RUN su -p -c 'winetricks -q vcrun6 vcrun6sp6 && wineserver --wait'
RUN winetricks -q vcrun6 
RUN winetricks -q vcrun6sp6
RUN useradd -m -s /bin/bash wineuser


COPY install-vcrun6.sh .
COPY ./kindle_installer /tmp/

# install the installer's dependencies
RUN bash install-vcrun6.sh

USER wineuser
