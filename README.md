# Docker Komodo

This is a Docker container that runs the Komodo ARM emulator. Komodo is an
ancient piece of software, so getting it to run on modern systems is a pain. I
made this container so that I could "run" Komodo on macOS without having to use
a whole VM. While I couldn't get a native ARM64 build working (the window never
opens), it still runs really well as an x86_64 container, even on M1 Macs.

**The below documentation is intended for macOS.**

# Setup

For this to work, you'll need Docker and some kind of X server. If you do not
already have a working Docker install, download and setup [Docker
Desktop](https://www.docker.com/products/docker-desktop) before continuing.
You'll also need [XQuartz](https://www.xquartz.org/).

In XQuartz, make sure you have "Allow connections from network clients" enabled.
You may need to reboot for this setting to take effect.

# Usage

Just download [Komodo.command](Komodo.command) (click the "Raw" button and
Command+S to save) and put it in /Applications. You may have to make it
executable with the command `chmod +x /Applications/Komodo.command`. From there,
you can start the script like a normal application (Finder, Launchpad etc). If
Docker is not currently running, you will see a lot of repeated errors since the
script basically spams the `docker run` command until the container starts
properly.

Your home directory will be accessible from Komodo in /data.

# Notes

If you're on Linux, you should probably use [this
AppImage](https://github.com/Cactric/komodo-appimage/releases/latest) instead,
it'll be easier than using Docker.

This container uses Debian Bullseye Slim since it's a small image and we don't
really need much more. The image builds gtk+ and glib with some patches from the
AUR packages, and builds Komodo with some of the fixes and patches detailed in
[this
guide](https://www.notion.so/How-you-can-install-Komodo-On-Ubuntu-ad42cd90a31042efb24e9659631e7c67).
As I said at the start of this README, I can't get it displaying on arm64 for
some reason, so this image is amd64 only.