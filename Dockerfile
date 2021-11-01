FROM amd64/debian:bullseye-slim

RUN apt update && apt install -y libx11-6 && rm -rf /var/lib/apt/lists/*

COPY ./dependencies/komodo-1.5.tar .
RUN tar xvpf komodo-1.5.tar -C /
RUN rm komodo-1.5.tar

CMD [ "kmd", "-e"]