FROM alpine:latest

# install curl and jq
RUN apk add --no-cache curl jq

# Download and install speedtest-cli
RUN curl -sLo speedtest-cli "https://install.speedtest.net/app/cli/ookla-speedtest-1.0.0-x86_64-linux.tgz" \
    && tar -xvf speedtest-cli \
    && mv speedtest /usr/local/bin/speedtest \
    && chmod +x /usr/local/bin/speedtest \
    && rm speedtest-cli

# Copy script to container
COPY run-speedtest.sh /run-speedtest.sh

# Make script executable
RUN chmod +x /run-speedtest.sh

# run script
CMD ["/run-speedtest.sh"]
