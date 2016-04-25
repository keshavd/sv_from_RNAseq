# PROGRAM NAME: VCF_processing.pl
# AUTHOR:       Keshav Dial
# USE:          This program will read in VCF file containing SV information from NA12878
                and write the SV type plus gene into a text file, given the string "SVTYPE=".

use strict;
use warnings;

#	OPENS UP "test.vcf" GENOME VCF FILE

open my $gene_vcf, "<", "test.vcf" or die "can't open test vcf file";

my @vcf_lines = <$gene_vcf>;
chomp @vcf_lines;

#	CLEANS VCF FILE
my $i = 0;
my @cleaned_vcf;
my $length = scalar @vcf_lines;
foreach (@vcf_lines){
	$i++;
	if ($_ =~ /#CHROM/){
		@cleaned_vcf = splice(@vcf_lines, $i, $length);
	}
}


#	STORES EACH GENE ID BY SV TYPE INDICATED
my %SV_hash;
foreach (@cleaned_vcf){
	if ($_ =~ m/SVTYPE=(.*?);/){
		my @keys = keys %SV_hash;

		if (grep {/$1/} @keys){
			push (@{$SV_hash{$1}}, $_);
		}else{
			$SV_hash{$1} = [];
			push (@{$SV_hash{$1}}, $_);
		}
	}
}

#	PRINTS GENE ID AND SVTYPE TO SV.txt FILE
foreach my $key (keys %SV_hash){
	open my $outfile, ">>", "SV.txt" or die "cannot write to file";
	foreach my $gene_info (@{$SV_hash{$key}}){
		my @split_gene_info = split /\t/, $gene_info;
		print $outfile $split_gene_info[2], ", $key\n";
	}
}
