FROM ubuntu:noble

ENV PB_VERSION=0.28.0

RUN apt update && apt install -y unzip ca-certificates && \
    mkdir -p /opt/apps/pb && \
    rm -rf /var/lib/apt/lists/*

ADD https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip /tmp/pb.zip
RUN unzip /tmp/pb.zip -d /opt/apps/pb

RUN useradd -m -s /bin/bash pb && \
    chmod +x /opt/apps/pb/pocketbase && \
    chown -R pb:pb /opt/apps/pb && \
    rm /tmp/pb.zip

# RUN chmod +x /opt/apps/pb/pocketbase

# uncomment to copy the local pb_migrations dir into the image
COPY ./pb_migrations /opt/apps/pb/pb_migrations

# uncomment to copy the local pb_hooks dir into the image
COPY ./pb_hooks /opt/apps/pb/pb_hooks

USER pb

EXPOSE 8080

VOLUME [ "/opt/apps/pb/pb_data" ]

# start PocketBase
CMD ["/opt/apps/pb/pocketbase", "serve", "--http=0.0.0.0:8080"]
