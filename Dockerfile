FROM debian

RUN dpkg --add-architecture i386 && \
    apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y wine qemu-kvm xz-utils dbus-x11 curl firefox-esr gnome-system-monitor mate-system-monitor git xfce4 xfce4-terminal tightvncserver wget && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/novnc/noVNC/archive/refs/tags/v1.2.0.tar.gz && \
    tar -xvf v1.2.0.tar.gz && \
    rm v1.2.0.tar.gz

RUN mkdir $HOME/.vnc && \
    echo 'password' | vncpasswd -f > $HOME/.vnc/passwd && \
    echo '#!/bin/bash\nstartxfce4 &' > $HOME/.vnc/xstartup && \
    chmod 600 $HOME/.vnc/passwd

RUN echo '#!/bin/bash\n' > /start.sh && \
    echo 'vncserver :1 -geometry 1280x800 -depth 24 && tail -F /root/.vnc/*.log' >> /start.sh && \
    chmod +x /start.sh

EXPOSE 5901
CMD ["/start.sh"]
