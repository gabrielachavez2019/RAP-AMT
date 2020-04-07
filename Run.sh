#To unzip fastaq.gz files
gunzip *.fastq.gz

#Pair end remove adapters, low quality and N bases sliding window and less than 36b long
java -jar ../Downloads/Trimmomatic-0.38/trimmomatic-0.38.jar PE -phred33 T0-a_1.fastq T0-a_2.fastq output_forward_paired.fastq output_forward_unpaired.fastq output_reverse_paired.fastq output_reverse_unpaired.fastq ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36

#Concatenate pairead reads on one file
cat T1-a_1.fastq T1-a_2.fastq >> T1-a.fastq

#Trimming 3-end adapter
cutadapt -a AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATCT  -o trimmed_Lib1.fastq Lib1.fastq

#Mapping Reads
tophat2 --no-novel-indels PAN_index trimmed_Lib1.fastq 

##Maping Reads in mars 
tophat -o output -G ../KSHV.gff --read-edit-dist 2 --read-gap-length 2 --read-mismatches 2 --read-realign-edit-dist 1 --library-type fr-unstranded ../KSHV ../../trimmed_T0-a.fastq

#Rename the file with the reads mapped to PAN
cp tophat_out/accepted_hits.bam mapped_trimmed_T0-a.bam
cp tophat_out/unmapped.bam unmapped_trimmed_T3-s.bam

#To separate the unmmaped_to_PAN_reads
cp tophat_out/unmapped.bam unmapped_trimmed_T0-a.bam

#Convert BAM to SAM 
samtools view -h -o Lib01.sam tophat_out/accepted_hits.bam
samtools view -h -o mapped_trimmed_T3-s.sam mapped_trimmed_T3-s.bam

######################### You can also use: 
#Quality Stats and checks FastQC 0.11.3
fastqc --nogroup -t 2 --extract input -o output 2>&1 | tee input.log;

#Quality check and filtering ngsqctoolkit 2.3.3
perl PATH/IlluQC_PRLL.pl -c 4 -t 2 -s 20 -l 70 -pe input.R1 input.R2 N A -o output &> input.R2.ngs.log;

#Spliced Alignment tophat2 2.0.12
tophat2 -p 4 -o output -G PATH/hg19_transcripts.gtf --transcriptome-index PATH/hg19_refseq_transcriptome --read-edit-dist 2 --read-gap-length 2 --read-mismatches 2 --read-realign-edit-dist 1 --library-type fr-unstranded --min-intron-length 50 --max-intron-length 300000 PATH/hg19 input.unpair

if [ 1 -ne 0 ] ; then
php /gss/gss_work/EPIGE_prod/GITS_STUFF/master/production/classes/shell/set_status.php 65413[1].node001 answers error
exit 1
fi;

tail -n+2 PATH/junctions.bed | bed_to_juncs > PATH/new_list.juncs

#Transcript assembly and abundance estimation  Cufflinks 2.2.1
#Get counts using cufflinks
cufflinks -o output --frag-bias-correct dirhg19.fa --multi-read-correct -G dirhg19_transcripts.gtf --compatible-hits-norm --library-type fr-unstranded --max-bundle-frags 500000 -p 8 -q PATH/accepted_hits.bam

#Highly efficient and accurate read summarization program  FeatureCounts 1.5
#Output: counts, featureCounts, featureCounts.summary
#Results parsing RatParser 1.0
#Out: metrics and pdf

#How to build indexes in bowtie:
# create bowtie2 index database (database name: hs19)
bowtie2-build human_genome.fna hs19 
#Index all the genome at the same time
bowtie2-build CHR_*/hs_ref_GRCh38.p12_chr*.fa  hs19

#To map reads against transcriptome
#tophat2 -o output -G Homo_sapiens/GFF/ref_GRCh38.p12_top_level.gff3 --transcriptome-index Homo_sapiens/RNA/ --read-edit-dist 2 --read-gap-length 2 --read-mismatches 2 --read-realign-edit-dist 1 --library-type fr-unstranded --min-intron-length 50 --max-intron-length 300000 ../rna_hs19 ../trimmed_T0-a.fastq
#tophat2 -o output -G Homo_sapiens/GFF/ref_GRCh38.p12_top_level.gff3 --transcriptome-index Homo_sapiens/RNA/ --read-edit-dist 2 --read-gap-length 2 --read-mismatches 2 --read-realign-edit-dist 1 --library-type fr-unstranded --min-intron-length 50 --max-intron-length 300000 ../rna_hs19 ../trimmed_{i}fastq

tophat2 -o output -G GCF_000001405.38_GRCh38.p12_genomic.gff --transcriptome-index Homo_sapiens/RNA/ --read-edit-dist 2 --read-gap-length 2 --read-mismatches 2 --read-realign-edit-dist 1 --library-type fr-unstranded --min-intron-length 50 --max-intron-length 300000 GCF_000001405.38_GRCh38.p12_genomic ../trimmed_T0-a.fastq
