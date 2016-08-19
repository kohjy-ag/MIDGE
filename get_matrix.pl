#!/usr/bin/perl
use warnings "all";

my ($data_dir) = @ARGV;

opendir(DIR, $data_dir);
@all_file = readdir(DIR);
close(DIR);

my %tag_info = ();
my %tag_sum_read = ();
my %species_list = ();

foreach $file (@all_file){
    
    next if(index($file, "profile") == -1 || index($file, "unknown") != -1 );
    print STDERR " *** $file\n";
    #
    @tmp = split(/\./, $file);
    $tag_name = $tmp[0];
    #my %map = ();
    $tag_info{$tag_name} = {};
    $tag_sum_read{$tag_name} = 0;
    #
    open(FILE, "$data_dir/$file");
    while(<FILE>){
	chop $_;
	@line = split(/\s+/, $_);
	
	#print STDERR " ***@line\n";<STDIN>;

	$spe = $line[2];
	
	
	$spe = "UN_MAPPED" if($spe eq "*");
	$spe = "MOTU3" if($spe eq "cp45932minion_usr_motu3_4seq");
	if(index($spe, ":") != -1){
	    @tmp = split(/\:/, $spe);
	    $spe = $tmp[1];
	}
	#
	
	$read_count = $line[1];
	
	#print STDERR " *** $read_count $spe\n";<STDIN>;
	#
	$species_list{$spe} = 1;
	#
	$tag_info{$tag_name}->{$spe} = $read_count;
	$tag_sum_read{$tag_name} += $read_count;
    }
}

@spcies_order = ("UN_MAPPED",
		 "Tanytarsus_oscillans",	
		 "Tanytarsus_formosanus",	
		 "MOTU3", 	
		 "Polypedilum_s.s.",	
		 "Paratanytarsus_sp.",
		 "Cladotanytarsus_sp.",	
		 "Ablabesmyia_2segpalp",	
		 "Zavrelimyia_sp.2",	
		 "Tanytarsus_sp.",
		 "Benthalia_dissidens",	
		 "Harnischia_tenuitubercula",	
		 "Parachironomus_sp.",	
		 "Chironomus_javanus",	
		 "Polypedilum_nodosum",	
		 "Cricotopus_sp.",
		 "Polypedilum_leei",	
		 "Nanocladius_sp.",	
		 "Chironomus_circumdatus",
		 "Dicrotendipes_sp.");


print join("\t", @spcies_order)."\n";
foreach $tag_name (keys %tag_info){
    print $tag_name;
    foreach $spe (@spcies_order){
	$read_count = 0;
	$read_count = $tag_info{$tag_name}->{$spe} if(exists $tag_info{$tag_name}->{$spe});
	#print "\t".$read_count;
	print "\t".$read_count/$tag_sum_read{$tag_name};
    }
    print "\n";
}
