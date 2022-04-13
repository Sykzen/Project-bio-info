import json
import os
import hashlib
import urllib.request
import tarfile
import gzip
import shutil
total, used, free = shutil.disk_usage("/")
free=free // (2**30)

f=json.load(open("filereport.json"))
class Init:
    def __init__(self):
        pass
    def downloadData(self,data):
        """Fonction pour telecharger les donnees
        requirements:
            OS: Linux (avoir wget)
        """
        if free >30:#gb
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
        else:
            print("Vous n'avez pas plus de 30GB dans votre Disque Dur")
            raise Exception("Not enough Space")   
    def checkmd5_windows():
        for i,j in zip(os.listdir(),d):
            for e,k in enumerate(os.listdir("data/"+j["run_accession"])):
                original_md5=j["fastq_md5"].split(";")[e]
                with open("data/"+str(i)+"/"+str(k),"rb") as f:
                    bytes = f.read()
                    if hashlib.md5(bytes).hexdigest()!=original_md5:
                        return False
                
        return True
    def checkmd5_Linux_alpine(self):
        for fastqgz in os.listdir():
            if fastqgz[-3:]=="gz":
                for runaccession in f:
                    if runaccession["run_accession"]==fastqgz[:-3]:
                        if runaccession["fastq_md5"]==hashlib.md5(open(fastqgz,"rb").read()).hexdigest():
                            pass            
                        else:
                            return False
        

t=Init()
#download full 26 data from PROJ
t.downloadData(f)
#check the MD5
t.checkmd5_Linux_alpine()
print("fichier telechargé")