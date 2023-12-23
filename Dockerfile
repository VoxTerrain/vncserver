# Use the official Ubuntu image as the base image
FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update the package repository and install necessary tools
RUN apt-get update && \
    apt-get install -y \
    sudo \
    wget \
    gnupg

# Install RustDesk
RUN wget https://rustdesk.com/deb/rustdesk-amd64.deb && \
    dpkg -i rustdesk-amd64.deb

# Clean up unnecessary files
RUN rm rustdesk-amd64.deb && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a user with sudo privileges (you can customize the username and password)
RUN useradd -m user && \
    echo "user:user" | chpasswd && \
    usermod -aG sudo user

# Set up sudo without a password prompt for the user
RUN echo "user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to the created user
USER user

# Expose the default RustDesk port
EXPOSE 6666

# Start RustDesk
CMD ["rustdesk"]
