#!/usr/bin/perl        

my $dna = $ARGV[0];

# reverse the DNA sequence
my $revcomp = reverse($dna);
	
# complement the reversed DNA sequence
$revcomp =~ tr/ACGTacgt/TGCAtgca/;
print $revcomp."\n";

