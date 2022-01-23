import json
import os
import hashlib
f=open("md5.json")
d=json.load(f)

def checkmd5():
    for i,j in zip(os.listdir("data"),d):
        for e,k in enumerate(os.listdir("data/"+j["run_accession"])):
            original_md5=j["fastq_md5"].split(";")[e]
            with open("data/"+str(i)+"/"+str(k),"rb") as f:
                bytes = f.read()
                if hashlib.md5(bytes).hexdigest()!=original_md5:
                    return False
                
    return True

