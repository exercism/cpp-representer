FROM alpine:3.23.4@sha256:5b10f432ef3da1b8d4c7eb6c487f2f5a8f096bc91145e68878dd4a5019afde11

RUN apk add --no-cache bash jq python3 py3-pip
RUN pip3 install --break-system-packages --upgrade pip & pip3 install --break-system-packages pygments

WORKDIR /opt/representer
COPY . .
ENTRYPOINT ["/opt/representer/bin/run.sh"]
