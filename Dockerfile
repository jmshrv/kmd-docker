FROM amd64/debian:bullseye-slim as builder

RUN apt update && apt install -y build-essential libx11-dev libxi-dev libxext-dev libxt-dev libxrandr-dev dh-autoreconf

COPY ./dependencies/glib ./glib
COPY ./dependencies/gtk ./gtk
COPY ./dependencies/kmd.tar.gz ./kmd.tar.gz

WORKDIR /glib

RUN tar xzvf glib-1.2.10.tar.gz

WORKDIR /glib/glib-1.2.10

RUN patch -Np1 -i "../gcc340.patch"
RUN patch -Np0 -i "../aclocal-fixes.patch"
RUN patch -Np1 -i "../glib1-autotools.patch"
RUN sed -i -e 's/ifdef[[:space:]]*__OPTIMIZE__/if 0/' glib.h
RUN rm acinclude.m4

RUN  autoreconf --force --install

RUN CFLAGS="-Wno-format-security -pthread" ./configure
RUN make
RUN make check
RUN make install
RUN ldconfig

WORKDIR /gtk

RUN tar xzvf gtk+-1.2.10.tar.gz

WORKDIR /gtk/gtk+-1.2.10

RUN cp /usr/share/libtool/build-aux/config.guess .
RUN cp /usr/share/libtool/build-aux/config.sub .
RUN patch -p0 -i "../aclocal-fixes.patch"
RUN sed -i "/ac_cpp=/s/\$CPPFLAGS/\$CPPFLAGS -O2/" configure

RUN CFLAGS="-Wno-format-security" ./configure --with-xinput=xfree
RUN make
RUN make install
RUN ldconfig

WORKDIR /

RUN tar xzvf kmd.tar.gz

WORKDIR /KMD-1.5.0

COPY ./dependencies/double-character.patch /KMD-1.5.0/
RUN patch -p0 -i double-character.patch

RUN cp /usr/share/libtool/build-aux/config.guess .
RUN cp /usr/share/libtool/build-aux/config.sub .

RUN CFLAGS="-z muldefs" ./configure
RUN make
RUN make install

WORKDIR /
COPY ./dependencies/aasm.c ./aasm.c
COPY ./dependencies/mnemonics ./mnemonics

RUN gcc -O2 -o aasm aasm.c
RUN cp aasm mnemonics /usr/local/bin

COPY ./dependencies/kmd_compile /usr/local/bin/kmd_compile
RUN chmod +x /usr/local/bin/kmd_compile

FROM amd64/debian:bullseye-slim


RUN apt update && apt install -y libx11-6 libxi-dev && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/ /usr/local/

RUN ldconfig

RUN export KMD_HOME=/usr/local/bin

RUN chmod +x /usr/local/bin/gtk-config 

WORKDIR /usr/local/bin/

RUN ./gtk-config gtk

WORKDIR /

CMD ["kmd", "-e"]
