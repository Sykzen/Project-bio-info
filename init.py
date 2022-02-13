import json
import os
import hashlib
import urllib.request
import tarfile
import gzip
import shutil

f=json.load(open("filereport.json"))

#d=json.load(f)

class Init:
    def __init__(self):
        pass
    def downloadData(self,data,indeks):
        link=[i["fastq_ftp"].split(";")[0]  for i in data if len(i["fastq_ftp"].split(";"))==2] +[i["fastq_ftp"].split(";")[1]  for i in data if len(i["fastq_ftp"].split(";"))==2]+ [i["fastq_ftp"].split(";")[0]  for i in data if len(i["fastq_ftp"].split(";"))==1]
        #for i in link
        for i in [link[i] for i in indeks]:
            cmd="wget "+ i
            os.system(cmd)            
    def downloadDataX(self,link):
        FinalUrl="wget "+link
        print(FinalUrl)
        os.system(FinalUrl)
    def dezipeTgzX(self,link):
        tar=tarfile.open(link,"r:gz")
        tar.extractall()
        tar.close
    def dezipeGzX(self,link):
        a = gzip.open(link, 'rb')
        file_content = a.read()
        
        with open("S288C_reference_sequence_R64-3-1_20210421.fsa", "wb") as out:
            out.truncate(1024 * 1024  )
            out.write(file_content)
            out.close()
        a.close()
    def downloadGenomeReference(urlgenome):
        self.ulrGenome
        urllib.request.urlretrieve(self.urlGenome)
    def checkmd5():
        for i,j in zip(os.listdir("data"),d):
            for e,k in enumerate(os.listdir("data/"+j["run_accession"])):
                original_md5=j["fastq_md5"].split(";")[e]
                with open("data/"+str(i)+"/"+str(k),"rb") as f:
                    bytes = f.read()
                    if hashlib.md5(bytes).hexdigest()!=original_md5:
                        return False
                
        return True


t=Init()
#download full 26 data from PROJ
t.downloadData(f,[0,23])
#check the MD5
# t.checkmd5()
#download Genome Reference
t.downloadDataX("http://sgd-archive.yeastgenome.org/sequence/S288C_reference/genome_releases/S288C_reference_genome_Current_Release.tgz")
#dezip genome reference Racine
t.dezipeTgzX("gn.tgz")
#dezip genome reference utulisé
t.dezipeGzX("S288C_reference_genome_R64-3-1_20210421/S288C_reference_sequence_R64-3-1_20210421.fsa.gz")
