# Docker Komodo

This is a Docker container that runs the Komodo ARM emulator. Komodo is an ancient piece of software, so getting it to run on modern systems is a pain. I made this container so that I could "run" Komodo on macOS without having to use a whole VM. While I couldn't get a native ARM64 build working (the window never opens), it still runs really well as an x86_64 container, even on M1 Macs.

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

This container uses Debian Bullseye Slim since it's a small image and we don't really need much more. The image builds gtk+ and glib with some patches from the AUR packages, and builds Komodo with some of the fixes and patches detailed in [this guide](https://www.notion.so/How-you-can-install-Komodo-On-Ubuntu-ad42cd90a31042efb24e9659631e7c67). As I said at the start of this README, I can't get it displaying on arm64 for some reason, so this image is amd64 only.