import json
import os
import hashlib
import urllib.request
import tarfile
import gzip
import shutil

f=json.load(open("filereport.json"))
class Init:
    def __init__(self):
        pass
    def downloadDataX(self,link):
        """Fonction pour telecharger les donnees"""
        FinalUrl="wget "+link
        os.system(FinalUrl)
    def dezipeTgzX(self,link):
        """Fonction pour dezipper les fichiers tar"""
        tar=tarfile.open(link,"r:gz")
        tar.extractall()
        tar.close
    def dezipeGzX(self,link):
        """Fonction pour dezipper les fichiers gz"""
        a = gzip.open(link, 'rb')
        file_content = a.read()
        
        with open(link, "wb") as out:
            out.truncate(1024 * 1024  )
            out.write(file_content)
            out.close()
        a.close()
t=Init()
e=0
while not os.path.exists("S288C_reference_genome_Current_Release.tgz"):
    e+=1
    t.downloadDataX("http://sgd-archive.yeastgenome.org/sequence/S288C_reference/genome_releases/S288C_reference_genome_Current_Release.tgz")
    print("loop number "+str(e))
#dezip genome reference Racine
t.dezipeTgzX("S288C_reference_genome_Current_Release.tgz")
print("dezipe genome reference")
#dezip genome reference utulisé
t.dezipeGzX("S288C_reference_genome_R64-3-1_20210421/S288C_reference_sequence_R64-3-1_20210421.fsa.gz")
print("dezipe genome reference/S288C_reference_sequence_R64-3-1_20210421.fsa.gz")
print(" End ")
