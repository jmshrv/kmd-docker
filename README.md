# Docker Komodo

This is a Docker container that runs the Komodo ARM emulator. Komodo is an ancient piece of software, so getting it to run on modern systems is a pain. I made this container so that I could "run" Komodo on macOS without having to use a whole VM. While I couldn't get a native ARM64 build working, it still runs really well as an x86_64 container, even on M1 Macs.

# Usage

(I'm assuming you have Docker already working and set up)

1. If on Mac, start XQuartz (make sure you have "Allow connections from network clients" enabled)
2. Run `xhost +localhost`
3. Run `docker run -v $HOME:/data -e DISPLAY=host.docker.internal:0 unicornsonlsd/kmd`
    * `-v $HOME:/data` mounts `$HOME` to `/data` in the container. If you want to access a different directory in Komodo, change this mount.
    * `-e DISPLAY=host.docker.internal:0` sets the Display to the host's X server.

To access your files, navigate to `/data` in Komodo's file selector.

# Notes

If you're on Linux, you should probably use [this AppImage](https://github.com/Cactric/komodo-appimage/releases/latest) instead, it'll be easier than using Docker.

This container uses Debian Bullseye Slim since it's a small image and we don't really need much more. The image brings in a precompiled Komodo and extracts it to the right paths. This image used to actually compile Komodo, but I had some weird issue where `SWI 1` inputs would be doubled. I'd rather compile it in the image, but this approach works and gives a smaller image (I was using Fedora before since it has gtk+ and glib in the repos). I was also trying to compile Komodo so that I could make this container work natively on ARM, but Komodo doesn't start when compiled for ARM for some reason.

`komodo-1.5.tar` was created by the University of Nottingham for installing on Ubuntu.