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
