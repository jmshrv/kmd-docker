# FROM debian:bullseye-slim as builder

# WORKDIR /


# COPY ./dependencies/glib-1.2.10.tar.gz ./glib-1.2.10.tar.gz
# COPY ./dependencies/gtk+-1.2.10.tar.gz ./gtk+-1.2.10.tar.gz
# COPY ./dependencies/kmd.tar.gz ./kmd.tar.gz
# COPY ./dependencies/libglib1.2-dev_1.2.10-19build1_armel.deb ./libglib1.2-dev_1.2.10-19build1_armel.deb
# COPY ./dependencies/libglib1.2ldbl_1.2.10-19build1_armel.deb ./libglib1.2ldbl_1.2.10-19build1_armel.deb
# COPY ./dependencies/glib1.2_1.2.10-4.dsc ./glib1.2/glib1.2_1.2.10-4.dsc
# COPY ./dependencies/glib1.2_1.2.10-19.diff.gz ./glib1.2/glib1.2_1.2.10-19.diff.gz
# COPY ./dependencies/sources.tar ./sources.tar

# RUN apt update && apt upgrade -y
# RUN apt install -y libx11-dev libxi-dev libxext-dev libxt-dev libxrandr-dev build-essential dpkg-dev devscripts autotools-dev

# RUN tar xvf sources.tar

# WORKDIR /sources/glib1.2-1.2.10

# RUN debuild -b -uc -us

# # WORKDIR /glib1.2

# # RUN tar xzvf glib1.2_1.2.10.orig.tar.gz
# # RUN debuild -b -uc -us

# # RUN tar xzvf glib-1.2.10.tar.gz
# # RUN tar xzvf gtk+-1.2.10.tar.gz
# # RUN tar xzvf kmd.tar.gz

# # WORKDIR /glib-1.2.10

# # RUN rm config.sub
# # COPY ./dependencies/config.sub .

# # COPY ./dependencies/gstrfuncs.diff .
# # RUN patch gstrfuncs.c < gstrfuncs.diff

# # RUN CFLAGS='-z muldefs' ./configure --host=$(dpkg --print-architecture)-linux
# # RUN make
# # RUN make install

# # RUN export LD_LIBRARY_PATH=/usr/local/include/glib-1.2

# # CMD [ "ls", "/usr/local/include"]

# # WORKDIR /
# # RUN dpkg --add-architecture armel
# # RUN dpkg -i libglib1.2*

# # WORKDIR /gtk+-1.2.10

# # RUN rm config.sub
# # COPY ./dependencies/config.sub .

# # RUN ./configure --host=$(dpkg --print-architecture)-linux
# # RUN make
# # RUN make install

FROM amd64/fedora:34 as builder

COPY ./dependencies/kmd.tar.gz /kmd.tar.gz

RUN dnf install -y glib glib-devel gtk+ gtk+-devel make automake gcc gcc-c++

RUN tar xzvf kmd.tar.gz

WORKDIR /KMD-1.5.0

COPY ./dependencies/config.sub /KMD-1.5.0/config.sub

RUN ./configure --build=amd64-linux
RUN sed -i 's/LDFLAGS =/LDFLAGS = -z muldefs/' /KMD-1.5.0/src/Makefile
RUN make
RUN make install

WORKDIR /

COPY ./dependencies/aasm.c ./aasm.c
COPY ./dependencies/mnemonics ./mnemonics
COPY ./dependencies/kmd_compile ./usr/local/bin/kmd_compile

RUN gcc -O2 -o aasm aasm.c
RUN cp aasm mnemonics /usr/local/bin

RUN chmod +x /usr/local/bin/*

FROM amd64/fedora:34

COPY --from=builder /usr/local/bin /usr/local/bin

RUN dnf install -y glib gtk+

RUN export KMD_HOME=/usr/local/bin

CMD [ "kmd", "-e" ]
