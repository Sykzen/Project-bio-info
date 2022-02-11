#FROM python:3.9-alpine3.14
FROM ubuntu:18.04
RUN apt-get update && \
      apt-get -y install sudo
RUN sudo apt-get -y install git
RUN sudo apt-get -y install python3
RUN sudo apt-get install wget
RUN mkdir /home/Project
WORKDIR /home/Project
#cd /home/Project/Project-bio-info
RUN git clone https://github.com/Sykzen/Project-bio-info.git /home/Project
#RUN cd Project-bio-info
RUN git clone https://github.com/lh3/bwa.git
RUN wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR164/ERR164407/ERR164407.fastq.gz

#CMD python3 init.py


#RUN exec bash
#RUN conda activate ProjectBio
#RUN mkdir /home/ProjectBioInfo && cd $_


