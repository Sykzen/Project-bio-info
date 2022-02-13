#FROM python:3.9-alpine3.14
FROM ubuntu:18.04
RUN apt-get update && \
      apt-get -y install sudo 
RUN sudo apt-get -y install \
    git \
    python3 \
    wget \
    make \
    libz-dev \
    gcc

RUN mkdir /home/Project

WORKDIR /home/Project
RUN git clone https://github.com/Sykzen/Project-bio-info.git /home/Project
RUN sudo apt-get -y install openjdk-8-jdk
#cd /home/Project/Project-bio-info

#RUN cd Project-bio-info
RUN git clone https://github.com/lh3/bwa.git

RUN cd bwa;make
#Downloadedtools , sammtools 1.9 ,BCFTools , vcftools
RUN wget https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2
RUN wget https://github.com/samtools/bcftools/releases/download/1.9/bcftools-1.9.tar.bz2
RUN sudo apt-get install -y vcftools
RUN sudo apt install bedtools
#RUN sudo apt -y -8 -37 install picard-tools
RUN sudo apt -y --no-install-recommends install picard-tools 

#Dezip BCFTools,samtools
RUN tar -vxjf bcftools-1.9.tar.bz2
#RUN cd bcftools;make
RUN tar -vxjf samtools-1.9.tar.bz2
#RUN cd samtools;make
#Donwload GATK4.2.5.0
RUN wget https://github.com/broadinstitute/gatk/releases/download/4.2.5.0/gatk-4.2.5.0.zip
EXPOSE 5000
CMD python3 init.py


#RUN exec bash


