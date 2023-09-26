FROM alpine:3.17

RUN apk add --no-cache bash jq python3 py3-pip
RUN pip3 install --upgrade pip
RUN pip3 install pygments

WORKDIR /opt/representer
COPY . .
ENTRYPOINT ["/opt/representer/bin/run.sh"]
