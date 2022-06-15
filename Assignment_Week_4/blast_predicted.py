# -*- coding: utf-8 -*-
# derived from here: https://www.tutorialspoint.com/biopython/biopython_overview_of_blast.htm
from Bio.Blast import NCBIWWW
from Bio.Blast import NCBIXML
#from Bio import SeqIO 
import pandas as pd
import re
samplesize = 3
def start_blast():
    acc_df = pd.read_csv("DeepNovo-DIA/oc/testing_oc.feature.csv.deepnovo_denovo.accuracy", 
                header=0, sep="\t")
    selection = acc_df["predicted_sequence"].sample(n=samplesize, random_state=42)
    selection = [re.sub(r'\(.*?\)', '', x) for x in selection]
    selection = [re.sub(r',', '', x) for x in selection]
    search_fasta = ""
    for i in range(samplesize):
        search_fasta += ">sequence {} \n{}\n".format(i, selection[i])
    print("selected fasta sequences:\n" + search_fasta)
    print("start BLAST...")
    result_handle = NCBIWWW.qblast("blastp", "nr", search_fasta)
    print("finished BLAST, saving...")
    with open('results_predicted.xml', 'w') as save_file: 
        blast_results = result_handle.read() 
        save_file.write(blast_results)

def read_blast():
    for record in NCBIXML.parse(open("results_predicted.xml")): 
        if record.alignments: 
            print("\n") 
            print("query: %s" % record.query[:100]) 
            counter=0
            for align in record.alignments: 
                for hsp in align.hsps: 
                    print("match: %s " % align.hit_def[:100])
                    print("E value: %s " % hsp.expect)
                    if counter > 4:
                        break
                    counter+=1
                if counter > 4:
                        break

if __name__ == "__main__":
    start_blast_flag = True
    read_blast_flag = True
    if start_blast_flag:
        start_blast()
    if read_blast_flag:
        read_blast()