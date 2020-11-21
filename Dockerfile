FROM sconecuratedimages/apps:python-3.7.3-alpine3.10 as base
#FROM jfloff/alpine-python as base
# as base

RUN apk add -U --no-cache python3-dev py3-pip build-base postgresql-dev gcc musl-dev openssl-dev libffi-dev

COPY ./app /app

WORKDIR /app

RUN pip3 install -r requirements.txt

FROM sconecuratedimages/apps:python-3.7.3-alpine3.10 as intermediate

ENV SCONE_MODE=AUTO
ENV SCONE_LOG=7

COPY --from=base / rootvol/

RUN rm -rf rootvol/dev \
           rootvol/proc \
           rootvol/media \
           rootvol/mnt \
           rootvol/usr/share/X11 \
           rootvol/usr/share/terminfo \
           rootvol/usr/include/c++/ \
           rootvol/usr/lib/tcl8.6 \
           rootvol/usr/lib/gcc \
           rootvol/sys \
           rootvol/usr/include/c++

RUN mkdir -p rootvol/app

RUN scone fspf create fspf.pb

RUN scone fspf addr fspf.pb / --not-protected --kernel /

RUN scone fspf addr fspf.pb /app --encrypted --kernel /app && \
    scone fspf addf fspf.pb /app rootvol/app-plain rootvol/app && \
    rm -rf rootvol/app-plain

RUN scone fspf addr fspf.pb /usr --authenticated --kernel /usr && \
    scone fspf addf fspf.pb /usr rootvol/usr /usr

RUN scone fspf addr fspf.pb /lib --authenticated --kernel /lib && \
    scone fspf addf fspf.pb /lib rootvol/lib /lib

RUN scone fspf encrypt fspf.pb

FROM sconecuratedimages/apps:python-3.7.3-alpine3.10

COPY --from=intermediate /fspf.pb /app/fspf.pb

COPY --from=intermediate rootvol /

WORKDIR /app

ENV SCONE_HEAP=1G
ENV SCONE_STACK=8M
ENV SCONE_ALLOW_DLOPEN=1
ENV SCONE_ALPINE=1
ENV SCONE_VERSION=1

EXPOSE 8080
