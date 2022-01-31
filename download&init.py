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


etude=DownloadAndInit("https://www.ebi.ac.uk/ena/browser/api/xml/PRJEB24932?download=true").downloadData()
etude.downloadGenomeReference("")
etude.checkmd5()
