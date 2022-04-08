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
    nano \
    libncurses5-dev \
    libbz2-dev \
    liblzma-dev
#------------------------------------Full Installation----------------------------------------------------------------------------------------------------

RUN git clone https://github.com/Sykzen/Project-bio-info.git /home/Project
WORKDIR /home/Project
RUN ["python3","init.py"]
RUN sudo apt-get -y install openjdk-8-jdk
RUN git clone https://github.com/lh3/bwa.git
RUN cd bwa;make
#------------------------------Download , samtools 1.9 ,BCFTools , vcftools----------------------------------------------
RUN wget https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2
RUN wget https://github.com/samtools/bcftools/releases/download/1.9/bcftools-1.9.tar.bz2
RUN sudo apt-get install -y vcftools
RUN sudo apt install bedtools
RUN sudo apt -y --no-install-recommends install picard-tools 
#-----Dezip BCFTools,samtools
RUN tar -vxjf bcftools-1.9.tar.bz2
RUN tar -vxjf samtools-1.9.tar.bz2
#----Configure Samtools------
WORKDIR /home/Project/samtools-1.9
RUN ./configure
RUN make 
WORKDIR /home/Project
#GATK 4.1.4.0
RUN wget https://github.com/broadinstitute/gatk/releases/download/4.1.4.0/gatk-4.1.4.0.zip
RUN unzip gatk-4.1.4.0.zip
WORKDIR /home/Project/gatk-4.1.4.0
RUN java -jar gatk-package-4.1.4.0-local.jar
RUN alias python='/usr/bin/python3'
RUN sudo ln -s /usr/bin/python3 /usr/bin/python
WORKDIR /home/Project
#Cclean
RUN rm -r gatk-4.1.4.0.zip
RUN rm -r S288C_reference_genome_Current_Release.tgz
RUN rm -r samtools-1.9.tar.bz2
RUN rm -r bcftools-1.9.tar.bz2
#-------------------Export Algo to Path --------------------------------------------
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

RUN for COUNTER in $(seq 66 88); do ./bwa mem -R '@RG\tID:ID\tSM:SAMPLE_NAME\tPL:illumina\tPU:PU\tLB:LB' S288C_reference_sequence_R64-3-1_20210421.fsa ERR22999${COUNTER}_1.fastq.gz ERR22999${COUNTER}_2.fastq.gz | gzip -3 > ERR22999${COUNTER}.sam.gz;done
#Process bwa sur les single end
RUN for COUNTER in $(seq 2 4); do ./bwa mem -R '@RG\tID:ID\tSM:SAMPLE_NAME\tPL:illumina\tPU:PU\tLB:LB' S288C_reference_sequence_R64-3-1_20210421.fsa ERR230025${COUNTER}.fastq.gz | gzip -3 > ERR230025${COUNTER}.sam.gz;done
#Clean 2
RUN for fastgz in *.fastq.gz;do rm -r -f $fastgz;done
#unzip
RUN for samfile in *.sam.gz; do gunzip -f $samfile;done
#-------------------------------------------Begin sort/view/faixa/index with samtools----------------------------------------------------------------------------------------------------
#sort
RUN for tosort in *.sam;do samtools sort ${tosort} > sorted_${tosort};done
#view change from sam to bam
RUN for toview in sorted_*.sam;do samtools view -S -b ${toview} > ${toview%%.*}.bam;done
#Supprimer les fichiers sam
RUN for todel in *.sam;do rm -r -f $todel;done
#Markdupliacte on bam
RUN for Mark in sorted*.bam;do  gatk MarkDuplicatesSpark -I ${Mark} -O Marked_${Mark};done
#faidx the genom reference
RUN mv S288C_reference_sequence_R64-3-1_20210421.fsa S288C_reference_sequence_R64-3-1_20210421.fasta
RUN samtools faidx S288C_reference_sequence_R64-3-1_20210421.fasta
#export with flagstat
RUN for flagst in Marked_*.bam;do samtools flagstat  ${flagst} > flagstated_${flagst%%.*}.txt;done

#---------------------------------------------------------------------------
RUN gatk CreateSequenceDictionary -R S288C_reference_sequence_R64-3-1_20210421.fasta
RUN for haplo in Marked_*.bam;do gatk HaplotypeCaller -R S288C_reference_sequence_R64-3-1_20210421.fasta -I ${haplo} -O Haplotyped_${haplo%%.*}.g.vcf.gz -ERC GVCF;done
RUN for gencover in Marked_*.bam;do bedtools genomecov -ibam ${gencover} -bga > genomecov_${gencover%%.*}.txt;done
#RUN for toindex in Marked_*.bam;do samtools index ${toindex};done
#RUN tab='   ';for gvcf_file in *g.vcf; do echo -e {gvcf_file}${tab}${gvcf_file}.gz>>concatenated_gcf.sample_map; done
#ftp.sra.ebi.ac.uk/vol1/fastq/ERR229/008/ERR2299978/ERR2299978_1.fastq.gz