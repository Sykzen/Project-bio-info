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



WORKDIR /home/Project

RUN sudo apt-get -y install openjdk-8-jdk
RUN git clone https://github.com/Sykzen/Project-bio-info.git /home/Project
#cd /home/Project/Project-bio-info

#RUN cd Project-bio-info
RUN git clone https://github.com/lh3/bwa.git

RUN cd bwa;make
#Downloadedtools , samtools 1.9 ,BCFTools , vcftools
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
#4.1.4.0
RUN wget https://github.com/broadinstitute/gatk/releases/download/4.1.4.0/gatk-4.1.4.0.zip
#EXPOSE 5000
#RUN wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR229/006/ERR2299966/ERR2299966_2.fastq.gz
#RUN wget ftp.sra.ebi.ac.uk/vol1/fastq/ERR229/006/ERR2299966/ERR2299966_1.fastq.gz
#RUN wget http://sgd-archive.yeastgenome.org/sequence/S288C_reference/genome_releases/S288C_reference_genome_Current_Release.tgz
RUN unzip gatk-4.1.4.0.zip
#clean
RUN rm -r gatk-4.1.4.0.zip
RUN rm -r samtools-1.9.tar.bz2
RUN ["python3","init.py"] 
RUN rm -r bcftools-1.9.tar.bz2

RUN mv S288C_reference_sequence_R64-3-1_20210421.fsa bwa
RUN for fastqfile in *.fastq.gz; do mv $fastqfile bwa;done
RUN mv S288C_reference_genome_R64-3-1_20210421 bwa 
RUN rm -r S288C_reference_genome_Current_Release.tgz
WORKDIR /home/Project/bwa
RUN ./bwa index S288C_reference_sequence_R64-3-1_20210421.fsa
#Process bwa sur les paired end
RUN ./bwa mem -R '@RG\tID:ID\tSM:SAMPLE_NAME\tPL:illumina\tPU:PU\tLB:LB' S288C_reference_sequence_R64-3-1_20210421.fsa ERR2299977_1.fastq.gz ERR2299978_2.fastq.gz | gzip -3 > ERR2299978.sam.gz;done
#Process bwa sur les single end
RUN ./bwa mem -R '@RG\tID:ID\tSM:SAMPLE_NAME\tPL:illumina\tPU:PU\tLB:LB' S288C_reference_sequence_R64-3-1_20210421.fsa ERR2300254.fastq.gz | gzip -3 > ERR2300254.sam.gz;done
# unzip puis moove les fichiers fastq.gz dans le dossier gatk et samtools
RUN mv S288C_reference_sequence_R64-3-1_20210421.fsa ../samtools-1.9/
RUN for fastgz in *.fastq.gz;do rm -r -f $fastgz;done
RUN for samfile in *.sam.gz; do gunzip -f $samfile;done
RUN for samfile in *.sam; do mv $samfile ../gatk-4.1.4.0;done
#Manipulations sur le dossier gatk
WORKDIR /home/Project/gatk-4.1.4.0
RUN java -jar gatk-package-4.1.4.0-local.jar
RUN alias python='/usr/bin/python3'
RUN sudo ln -s /usr/bin/python3 /usr/bin/python
#Début des Mark duplicate sur les fichiers sam dans le dossier gatk
RUN for Mark in *.sam;do  ./gatk MarkDuplicatesSpark -I ${Mark} -O Marked_${Mark};done
RUN for markedsam in Marked_*.sam;do mv $markedsam ../samtools-1.9;done
RUN sudo apt-get -y install libncurses5-dev
RUN sudo apt-get -y install libbz2-dev
RUN sudo apt-get -y install liblzma-dev
WORKDIR /home/Project/samtools-1.9
RUN ./configure
RUN make
RUN for flagst in *.sam;do ./samtools flagstat  ${flagst} > flagstated_${flagst}.txt;done
RUN for flastated in flagstated_*.txt;do mv $flastated ..;done

# Continue exec Haplotypecaller

#rename fsa en fasta
RUN mv S288C_reference_sequence_R64-3-1_20210421.fsa S288C_reference_sequence_R64-3-1_20210421.fasta
#prepare le fichier fasta
RUN ./samtools faidx S288C_reference_sequence_R64-3-1_20210421.fasta
#rename les sam en bam
RUN for mvtobam in *.sam;do mv ${mvtobam} ${mvtobam}.bam;done
#sort bam
RUN for tosort in *.bam;do ./samtools sort ${tosort} > sorted_${tosort};done

#RUN for tosort in *.bam;do ./samtools view -bh -F 4 -q 30 ${tosort} sorted_${tosort};done
#index bam
RUN for toindex in sorted_*.bam;do ./samtools index ${toindex};done
#move les fichiers vers gatk
RUN for sorted_bam in sorted_*.bam;do mv ${sorted_bam} ../gatk-4.1.4.0/;done
RUN for sorted_bam in sorted_*.bam.bai;do mv ${sorted_bam} ../gatk-4.1.4.0/;done
RUN mv S288C_reference_sequence_R64-3-1_20210421.fasta ../gatk-4.1.4.0/
RUN mv S288C_reference_sequence_R64-3-1_20210421.fasta.fai ../gatk-4.1.4.0/
WORKDIR /home/Project/gatk-4.1.4.0
RUN ./gatk CreateSequenceDictionary -R S288C_reference_sequence_R64-3-1_20210421.fasta
RUN for haplo in sorted_*.bam;do ./gatk HaplotypeCaller -R S288C_reference_sequence_R64-3-1_20210421.fasta -I ${haplo} -O haplotyped_${haplo}.g.vcf.gz -ERC GVCF;done
RUN for gvdcfgz in *.g.vcf.gz;do gunzip -f ${gvdcfgz} ;done
RUN for gencover in sorted*.bam;do bedtools genomecov -ibam ${gencover} -bga > genomecov_${gencover}.txt;done
RUN tab='   ';for gvcf_file in *g.vcf; do echo -e {gvcf_file}${tab}${gvcf_file}.gz>>concatenated_gcf.sample_map; done
#----------------------------------------------