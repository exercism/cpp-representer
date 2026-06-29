FROM alpine:3.23.5@sha256:fd791d74b68913cbb027c6546007b3f0d3bc45125f797758156952bc2d6daf40

RUN apk add --no-cache bash jq python3 py3-pip
RUN pip3 install --break-system-packages --upgrade pip & pip3 install --break-system-packages pygments

WORKDIR /opt/representer
COPY . .
ENTRYPOINT ["/opt/representer/bin/run.sh"]
