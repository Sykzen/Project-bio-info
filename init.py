import json
import os
import hashlib
import urllib.request
f=json.load(open("filereport.json"))

#d=json.load(f)

class Init:
    def __init__(self):
        pass
    def downloadData(self,data):
        link=[i["fastq_ftp"].split(";")[0]  for i in data if len(i["fastq_ftp"].split(";"))==1] + [i["fastq_ftp"].split(";")[1]  for i in data if len(i["fastq_ftp"].split(";"))==2]
        for i in link:
            cmd="wget "+ i
            os.system(cmd)            
    def downloadDataX(self,link):
        FinalUrl="wget "+link
        os.system(FinalUrl)
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
#t.downloadData(f)
t.downloadX("http://sgd-archive.yeastgenome.org/sequence/S288C_reference/genome_releases/S288C_reference_genome_Current_Release.tgz")
