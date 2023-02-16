FROM ubuntu:latest
ENV LANG C.UTF-8
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    gcc \
    git \
    libblosc-dev \
    libblosc1 \
    libcurl4 \
    libegl1-mesa \
    libgles2-mesa \
    libjpeg-turbo8 \
    libpng16-16 \
    libtinyxml2.6.2v5 \
    python3.10 \
    python3-setuptools \
    unzip \
    python3-dev \
    openjdk-11-jdk-headless \
    g++ \
    python3-opencv
RUN curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
RUN python3 /tmp/get-pip.py
RUN wget https://github.com/glencoesoftware/bioformats2raw/releases/download/v0.6.0/bioformats2raw-0.6.0.zip -O /tmp/bioformats2raw.zip
RUN unzip /tmp/bioformats2raw*.zip -d /opt
RUN rm -rf /tmp/bioformats2raw*
RUN ln -s /opt/bioformats2raw*/bin/bioformats2raw /usr/bin/bioformats2raw
RUN wget https://github.com/glencoesoftware/raw2ometiff/releases/download/v0.4.0/raw2ometiff-0.4.0.zip -O /tmp/raw2ometiff.zip
RUN unzip /tmp/raw2ometiff*.zip -d /opt
RUN rm -rf /tmp/raw2ometiff*
RUN ln -s /opt/raw2ometiff*/bin/raw2ometiff /usr/bin/raw2ometiff
RUN wget http://downloads.openmicroscopy.org/latest/bio-formats5.6/artifacts/bftools.zip -O /tmp/bftools.zip
RUN unzip /tmp/bftools.zip -d /opt
RUN rm -rf /tmp/bftools
RUN ln -s /opt/bftools /usr/bin/bftools
ENV PATH="$PATH:/usr/bin/bftools"

COPY bin/twostep.sh /twostep.sh
COPY bin/convert_scn.sh /convert_scn.sh
COPY bin/clean_ome.py /clean_ome.py
RUN pip install ome-types
RUN ln -s /usr/bin/python3 /usr/bin/python & \
    ln -s /usr/bin/pip3 /usr/bin/pip