FROM ubuntu:18.04
RUN apt-get update && \
    apt-get -y install sudo 
RUN sudo apt-get -y install \
    git \
    python3 \
    wget \
    make \
    libz-dev \
    gcc \
    unzip \
    nano
#------------------------------------Full Installation----------------------------------------------------------------------------------------------------
RUN git clone https://github.com/Sykzen/Project-bio-info.git /home/Project
WORKDIR /home/Project
RUN sudo apt-get -y install openjdk-8-jdk
RUN git clone https://github.com/lh3/bwa.git
RUN cd bwa;make
#Download , samtools 1.9 ,BCFTools , vcftools
RUN wget https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2
RUN wget https://github.com/samtools/bcftools/releases/download/1.9/bcftools-1.9.tar.bz2
RUN sudo apt-get install -y vcftools
RUN sudo apt install bedtools
RUN sudo apt -y --no-install-recommends install picard-tools 
#Dezip BCFTools,samtools
RUN tar -vxjf bcftools-1.9.tar.bz2
RUN tar -vxjf samtools-1.9.tar.bz2
#GATK 4.1.4.0
RUN wget https://github.com/broadinstitute/gatk/releases/download/4.1.4.0/gatk-4.1.4.0.zip
RUN unzip gatk-4.1.4.0.zip
RUN ["python3","init.py"]
#Cclean
RUN rm -r gatk-4.1.4.0.zip
RUN rm -r S288C_reference_genome_Current_Release.tgz
RUN rm -r samtools-1.9.tar.bz2
RUN rm -r bcftools-1.9.tar.bz2
#Add to path
ENV PATH="/home/Project/gatk-4.1.4.0:${PATH}"
#ENV PATH=$PATH:/home/Project/gatk-4.1.4.0
ENV PATH="/home/Project/bwa:${PATH}"
#ENV  PATH=$PATH:/home/Project/bwa
ENV PATH="/home/Project/samtools-1.9:${PATH}"
#ENV PATH=$PATH:/home/Project/samtools-1.9
ENV PATH="/home/Project/bcftools-1.9:${PATH}"
#ENV  PATH=$PATH:/home/Project/bcftools-1.9


#------------------------------------- End Full Installation----------------------------------------------------------------------------------------------------
#-------------------------------------Begin Index with bwa algorithm ----------------------------------------------------------------------------------------------------
RUN bwa index S288C_reference_sequence_R64-3-1_20210421.fsa


