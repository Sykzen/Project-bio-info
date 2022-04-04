import json
import os
import hashlib
import urllib.request
import tarfile
import gzip

f=json.load(open("filereport.json"))

#d=json.load(f)

class Init:
    def __init__(self):
        pass
    def downloadData(self,data):
        
        link=[i["fastq_ftp"].split(";")[0]  for i in data if len(i["fastq_ftp"].split(";"))==2] +[i["fastq_ftp"].split(";")[1]  for i in data if len(i["fastq_ftp"].split(";"))==2]+ [i["fastq_ftp"].split(";")[0]  for i in data if len(i["fastq_ftp"].split(";"))==1]
        name_dir=[i.split("/")[-1] for i in link]
        print(all(os.path.exists(i) for i in name_dir))
        while not all(os.path.exists(i) for i in name_dir): #tant qu'il sont pas telecharger on recommence le processus
            for e,i in enumerate(link):
                if os.path.exists(name_dir[e]):
                    pass
                else:
                    cmd="wget "+ i
                    os.system(cmd)  #on telecharge les fichiers      
            break
    def downloadtest(self):
        for i in ["ftp.sra.ebi.ac.uk/vol1/fastq/ERR229/007/ERR2299977/ERR2299977_1.fastq.gz","ftp.sra.ebi.ac.uk/vol1/fastq/ERR229/008/ERR2299978/ERR2299978_2.fastq.gz","ftp.sra.ebi.ac.uk/vol1/fastq/ERR230/004/ERR2300254/ERR2300254.fastq.gz"]:
            os.system("wget "+i)
    def downloadDataX(self,link):
        FinalUrl="wget "+link
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
        for i,j in zip(os.listdir(),d):
            for e,k in enumerate(os.listdir("data/"+j["run_accession"])):
                original_md5=j["fastq_md5"].split(";")[e]
                with open("data/"+str(i)+"/"+str(k),"rb") as f:
                    bytes = f.read()
                    if hashlib.md5(bytes).hexdigest()!=original_md5:
                        return False
                
        return True


t=Init()
#download full 26 data from PROJ
t.downloadtest()
#check the MD5
#t.checkmd5()
#download Genome Reference
e=0
while not os.path.exists("S288C_reference_genome_Current_Release.tgz"):
    e+=1
    t.downloadDataX("http://sgd-archive.yeastgenome.org/sequence/S288C_reference/genome_releases/S288C_reference_genome_Current_Release.tgz")
    print("loop "+e)
#dezip genome reference Racine
t.dezipeTgzX("S288C_reference_genome_Current_Release.tgz")
#dezip genome reference utulisé
t.dezipeGzX("S288C_reference_genome_R64-3-1_20210421/S288C_reference_sequence_R64-3-1_20210421.fsa.gz")

print(" r u looping forever? ")