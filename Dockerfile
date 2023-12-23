# Use the official Ubuntu image as the base image
FROM ubuntu:latest

# Set environment variables to avoid interactive installation prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && \
    apt-get install -y \
    sudo \
    x11vnc \
    xvfb \
    fluxbox \
    wget \
    net-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set up root access with password 'root'
RUN useradd -ms /bin/bash user && \
    echo 'user:root' | chpasswd && \
    adduser user sudo

# Set up VNC server
USER user
WORKDIR /home/user

# Download noVNC for accessing VNC server through a web browser
RUN wget -qO- https://github.com/novnc/noVNC/archive/master.tar.gz | tar xz --strip 1 && \
    wget -qO- https://github.com/novnc/websockify/archive/master.tar.gz | tar xz --strip 1 && \
    chmod +x -v noVNC/utils/*.sh

# Expose VNC port
EXPOSE 5900

# Set up entry point
CMD ["bash", "-c", "x11vnc -forever -usepw -create"]
