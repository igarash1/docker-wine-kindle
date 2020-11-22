FROM ubuntu:19.10

ARG USER_NAME=wine

ARG DISPLAY=:0
ENV DISPLAY ${DISPLAY}

RUN useradd -u 1001 -d /home/$USER_NAME -m -s /bin/bash $USER_NAME
ENV HOME /home/$USER_NAME
ENV WINEPREFIX /home/$USER_NAME/.wine
ENV WINEARCH win32

ENV WINEDEBUG -all

ENV DEBIAN_FRONTEND noninteractive

RUN mkdir /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix
VOLUME /tmp/.X11-unix/

RUN dpkg --add-architecture i386 && apt update && apt install -y --no-install-recommends \
	xvfb \
    xz-utils \
	wine \
    wine32 \
	winetricks \
	ca-certificates \
	cabextract \
	&& \
	apt-get autoremove -y --purge software-properties-common && \
	apt-get clean -y

# comment the cjk installation command if you don't read Chinese/Japanese/Korean books.
RUN su -p -l $USER_NAME -c 'xvfb-run -a winetricks -q dotnet40'  && \
    su -p -l $USER_NAME -c 'xvfb-run -a winetricks -q vcrun6'  && \
    su -p -l $USER_NAME -c 'xvfb-run -a winetricks -q vcrun6sp6' && \
    su -p -l $USER_NAME -c 'xvfb-run -a winetricks -q cjkfonts' && \
    su -p -l $USER_NAME -c 'xvfb-run -a winetricks -q kindle'

RUN	rm -rf /home/$USER_NAME/.cache && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

USER $USER_NAME
#RUN chown $USER_NAME:$USER_NAME /home/wine
#RUN usermod -u 1001 /home/wine