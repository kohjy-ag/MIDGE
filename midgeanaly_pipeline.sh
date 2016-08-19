#!/bin/bash
##To be run within analysis directory where files should be stored

reference=$1		#ha_centroids_MOTUadded.fa fullpath
cluster_level=$2	#proportion at which clustering occurs eg. 0.90
fasta=$3		#../../DATA/NANOPORE/N030/N030_2D/N030.fa
type=$4			#2D failed all
out_dir=$5		#output dir

cluster_prefix=`echo $cluster_level*100 | bc | xargs printf "%.*f\n" 0`		#converts 0.90 to 90

mkdir -p $out_dir

if [ ! -f $out_dir/ha_${type}_midge_MOTUadded.bam.bam ];
then
	#aligning data with haplotype reference and 3 MOTU sequences
	echo "/mnt/software/stow/graphmap-0.3.0-1d16f07/bin/graphmap align -t 10 -r $reference -d $fasta | samtools view -Sub - | samtools sort - $out_dir/ha_${type}_midge_MOTUadded.bam"
	/mnt/software/stow/graphmap-0.3.0-1d16f07/bin/graphmap align -t 10 -r $reference -d $fasta | samtools view -Sub - | samtools sort - $out_dir/ha_${type}_midge_MOTUadded.bam
fi

mp="ha_mapprofile_MOTUadded.txt"	#hardcoded
if [ ! -f $out_dir/$mp ];
then
	#Get mapping profile, number of reads annotated
	echo "samtools view $out_dir/ha_${type}_midge_MOTUadded.bam.bam | cut -f3 | sort | uniq -c | sed 's/cp45932minion_usr_motu3_4seq/MOTU3:MOTU3:MOTU3/g' | awk -F\"[[:space:]]+|:\" \"{print $2,$4}\" | sed \"1 s/\(^.*$\)/\1Unmapped/\" > $out_dir/$mp"
	samtools view $out_dir/ha_${type}_midge_MOTUadded.bam.bam | cut -f3 | sort | uniq -c | sed 's/cp45932minion_usr_motu3_4seq/MOTU3:MOTU3:MOTU3/g' | awk -F"[[:space:]]+|:" '{print $2,$4}' | sed "1 s/\(^.*$\)/\1Unmapped/" > $out_dir/$mp
fi
sort -k 1nr,1nr $out_dir/$mp > $out_dir/${mp}.sorted	#sort in order of abundance
grep -v Unmapped $out_dir/${mp}.sorted > $out_dir/${mp}.sorted_tmp		#exclude Unmapped

hist_pdf="histogram_annot_proportion_MOTUadded.pdf"
if [ ! -f $out_dir/$hist_pdf ];
then
	#To get hist of reads annotated
	echo "Rscript /home/bertrandd/PROJECT_LINK/OPERA_LG/MIDGE_TMP/SCRIPT/histogram_annot.R $out_dir/$hist_pdf $cluster_prefix $out_dir"
	Rscript /home/bertrandd/PROJECT_LINK/OPERA_LG/MIDGE_TMP/SCRIPT/histogram_annot.R $out_dir/$hist_pdf $cluster_prefix $out_dir
fi

