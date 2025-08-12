# Use the official Ubuntu 24.04 image as the base
FROM ubuntu:24.04

# Set a working directory inside the container
WORKDIR /app

# Install necessary tools: build-essential for g++ and make, and bash for shell scripts
# RUN apt-get update && \
#     apt-get install -y build-essential bash cmake make gcc g++ wget git && \
#     rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y build-essential bash cmake make gcc g++ wget git && \
    # Add a symbolic link for 'make' to /usr/local/bin to ensure CMake can find it.
    # The '|| true' prevents the build from failing if the link already exists.
    ln -sf /usr/bin/make /usr/local/bin/make || true && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://apt.devkitpro.org/install-devkitpro-pacman
RUN chmod +x ./install-devkitpro-pacman
RUN sed -i 's/^apt-get update$/apt-get update -y/' install-devkitpro-pacman
RUN sed -i 's/^apt-get install devkitpro-pacman$/apt-get install -y devkitpro-pacman/' install-devkitpro-pacman
RUN ./install-devkitpro-pacman

RUN ln -s /proc/mounts /etc/mtab
RUN dkp-pacman --noconfirm -Syu wiiu-dev

ENV DEVKITPRO=/opt/devkitpro
ENV DEVKITARM=/opt/devkitpro/devkitARM
ENV DEVKITPPC=/opt/devkitpro/devkitPPC

RUN git clone https://github.com/sahlberg/libsmb2
RUN cd libsmb2 && make -f Makefile.platform wiiu_install

# Copy the script to compile and run (entrypoint.sh) into the container
# This script will be responsible for copying and executing your input files
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Make the entrypoint script executable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the entrypoint for the container.
# When the container runs, it will execute this script.
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]