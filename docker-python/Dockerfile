FROM python:3.8-alpine AS build

RUN apk upgrade --no-cache
RUN apk add --no-cache rust cargo openssl-dev libffi-dev py3-pip python3 samba-client samba-common-tools yaml-dev
RUN python3 -m ensurepip --upgrade && python3 -m pip install pex~=2.1.47
RUN mkdir /source

COPY requirements.txt /source

RUN pex -r /source/requirements.txt -o /source/pex_wrapper

FROM python:3.8-alpine as final
RUN apk upgrade --no-cache
RUN apk add --no-cache samba-client samba-common-tools

RUN mkdir -p /enum4linux-ng \
    && useradd -D enum4linux-ng \
    && chown -R enum4linux-ng:enum4linux-ng /enum4linux-ng
COPY . /enum4linux-ng
COPY --from=build /source /enum4linux-ng/
USER enum4linux-ng
WORKDIR /enum4linux-ng
ENTRYPOINT ["/enum4linux-ng/pex_wrapper", "enum4linux-ng.py"]
