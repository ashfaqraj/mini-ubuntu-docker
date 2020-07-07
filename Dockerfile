FROM alpine:latest as initial_alpine_layer

LABEL maintainer="raj.ashfaq@gmail.com"
LABEL build_date="2020-07-07"

RUN apk add --no-cache bash curl tzdata xz

# environment
ENV REL=bionic
ENV ARCH=amd64

# grab base tarball
RUN mkdir /ubuntu_core && \
    curl -o /ubuntu-${REL}-core.tar.gz -L https://partner-images.canonical.com/core/${REL}/current/ubuntu-${REL}-core-cloudimg-${ARCH}-root.tar.gz && \
    tar xf /ubuntu-${REL}-core.tar.gz -C /ubuntu_core && \
    rm -rf /ubuntu-${REL}-core.tar.gz

# create new layer from scratch for core ubuntu
FROM scratch

COPY --from=initial_alpine_layer /ubuntu_core/ /

ARG REL=bionic

COPY sources.list /etc/apt/

RUN sed -i "s/codename/${REL}/g" /etc/apt/sources.list

CMD ["tail", "-f", "/dev/null"]
