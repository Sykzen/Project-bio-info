import json
import os
import hashlib
import urllib.request
f=open("md5.json")
url = 'https://pypi.org/project/wget/'

d=json.load(f)

class DownloadAndInit:
    def __init__(self,urldata,urlgenome):
        self.urlData = urldata
        self.urlGenome=urlgenome
    def downloadDependencies(self):
        for i in ["ERR2299966","ERR2299967","ERR2299968","ERR2299969","ERR2299970","ERR2299971","ERR2299972","ERR2299973","ERR2299974","ERR2299975","ERR2299976","ERR2299977","ERR2299978","ERR2299979","ERR2299980","ERR2299981","ERR2299982","ERR2299983","ERR2299984","ERR2299985","ERR2299986","ERR2299987","ERR2299988","ERR2300252","ERR2300253","ERR2300254"]:
            runaccession="python enaBrowserTools/python3/enaDataGet.py -f fastq -d data " +i
            os.system(runaccession)
            
        
    def downloadData(self):
        requests.get(self.url)
        urllib.request.urlretrieve(self.urlData)
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


etude.downloadGenomeReference("")
etude.checkmd5()
