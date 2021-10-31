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

This container uses Fedora because it's pretty much the only Distro that still includes glib and gtk+ in its repos. I have no idea why they do, but I'm not complaining. I'd rather use something like Debian since the image is a bit slimmer, but then I'd have to go through the hassle of compiling glib and gtk+.