#Mapping against KSHV genome 
#Run it from each T2-a directory for example here (inside of KSHV directory)
tophat -o output -G ../KSHV.gff --read-edit-dist 2 --read-gap-length 2 --read-mismatches 2 --read-realign-edit-dist 1 --library-type fr-unstranded ../KSHV ../../trimmed_T2-a.fastq
