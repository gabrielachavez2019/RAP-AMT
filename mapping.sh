#!/bin/bash

for i in $(ls *.fastq); do
	echo  $i
	#mkdir human_$i
	cd human_$i
	echo Mapping $i...
	$tophat -o output_$i -G ../KSHV/KSHV.gff --read-edit-dist 2 --read-gap-length 2 --read-mismatches 2 --read-realign-edit-dist 1 --library-type fr-unstranded ../KSHV/ ../$i
	cd ../
done


#tophat2 --no-novel-indels PAN_index trimmed_Lib1.fastq 
#tophat -o output -G ../KSHV.gff --read-edit-dist 2 --read-gap-length 2 --read-mismatches 2 --read-realign-edit-dist 1 --library-type fr-unstranded ../KSHV ../../trimmed_T0-a.fastq
#cp tophat_out/accepted_hits.bam mapped_trimmed_T0-a.bam
#cp tophat_out/unmapped.bam unmapped_trimmed_T3-s.bam
#cp tophat_out/unmapped.bam unmapped_trimmed_T0-a.bam
#samtools view -h -o Lib01.sam tophat_out/accepted_hits.bam
#Spliced Alignment tophat2 2.0.12
#tophat2 -p 4 -o output -G PATH/hg19_transcripts.gtf --transcriptome-index PATH/hg19_refseq_transcriptome --read-edit-dist 2 --read-gap-length 2 --read-mismatches 2 --read-realign-edit-dist 1 --library-type fr-unstranded --min-intron-length 50 --max-intron-length 300000 PATH/hg19 input.unpair
#tophat2 -o output -G Homo_sapiens/GFF/ref_GRCh38.p12_top_level.gff3 --transcriptome-index Homo_sapiens/RNA/ --read-edit-dist 2 --read-gap-length 2 --read-mismatches 2 --read-realign-edit-dist 1 --library-type fr-unstranded --min-intron-length 50 --max-intron-length 300000 ../rna_hs19 ../trimmed_T0-a.fastq
#tophat2 -o output -G Homo_sapiens/GFF/ref_GRCh38.p12_top_level.gff3 --transcriptome-index Homo_sapiens/RNA/ --read-edit-dist 2 --read-gap-length 2 --read-mismatches 2 --read-realign-edit-dist 1 --library-type fr-unstranded --min-intron-length 50 --max-intron-length 300000 ../rna_hs19 ../trimmed_{i}fastq
#tophat2 -o output -G GCF_000001405.38_GRCh38.p12_genomic.gff --transcriptome-index Homo_sapiens/RNA/ --read-edit-dist 2 --read-gap-length 2 --read-mismatches 2 --read-realign-edit-dist 1 --library-type fr-unstranded --min-intron-length 50 --max-intron-length 300000 GCF_000001405.38_GRCh38.p12_genomic ../trimmed_T0-a.fastq
