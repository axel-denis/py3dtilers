# References
# - ifcopenshell part :
# https://github.com/IfcOpenShell/IfcOpenShell/blob/v0.7.0/Dockerfile

FROM ubuntu:focal

ARG CHANNEL
ENV CHANNEL=${CHANNEL:-latest}
RUN apt-get update \
    && apt-get install -y \
    vim \
    ssh \
    sudo \
    wget \
    software-properties-common ;\
    rm -rf /var/lib/apt/lists/*

RUN useradd --user-group --create-home --shell /bin/bash IfcOpenShell ;\
    echo "IfcOpenShell ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers


ENV DEBIAN_FRONTEND=noninteractive
RUN echo "deb http://archive.ubuntu.com/ubuntu focal-proposed main restricted" |  tee -a /etc/apt/sources.list; \
    echo "deb http://archive.ubuntu.com/ubuntu focal-proposed universe" |  tee -a /etc/apt/sources.list; \
    echo "deb http://archive.ubuntu.com/ubuntu focal-proposed multiverse" |  tee -a /etc/apt/sources.list; \
    apt-get -qq update; \
    apt-get -y install tzdata dos2unix rsync; \
    apt-get -y install python3 libxml2 libpython3.8 \
                    libboost-all-dev \
                    libocct-foundation-dev libocct-modeling-algorithms-dev libocct-modeling-data-dev \
                    libocct-ocaf-dev libocct-visualization-dev libocct-data-exchange-dev \
                    libhdf5-serial-dev python3-pytest ; \
    rm -rf /var/lib/apt/lists/* ;

COPY . /home/IfcOpenShell/
RUN ls -lrtR /home/IfcOpenShell

RUN dpkg -i /home/IfcOpenShell/*.deb

USER IfcOpenShell

FROM python:3.9-buster

WORKDIR /app
COPY . /app
RUN https_proxy=http://10.10.127.22:3128/ set -ex
RUN https_proxy=http://10.10.127.22:3128/ pip install --upgrade pip
RUN https_proxy=http://10.10.127.22:3128/ pip install -e .
# CMD ["https_proxy=http://10.10.127.22:3128/", "pip", "install", "-e", "."]

#clear; sudo docker build -t fork .; sudo docker run --rm -v /home/adenis/Desktop/fork_py3dtylers/:/py3dtilers -t fork
# https_proxy=http://10.10.127.22:3128/ pip install -e .

#clear; sudo docker build -t fork:latest .; sudo docker run -v /home/adenis/Desktop/rust-pipeline1/lod_generator/output:/mnt/data -v /home/adenis/Desktop/fork_py3dtylers/:/mnt/fork -it fork /bin/bash


#clear; sudo docker build -t fork:latest .; sudo docker run -v /home/adenis/Desktop/rust-pipeline1/lod_generator/output:/mnt/data -v /home/adenis/Desktop/fork_py3dtylers/:/mnt/fork -it fork /bin/bash

# sudo docker exec -it obj-tiler bash

# sudo docker run -v /home/adenis/Desktop/rust-pipeline1/lod_generator/output:/mnt/data -v /home/adenis/Desktop/fork_py3dtylers/:/mnt/fork -it fork /bin/bash
