#!/usr/bin/perl
#ClamAV database to Scalpel.conf converter
#This script is a hack and hardcodes a lot of stuff, it is mostly only ever going to be used by me
#If anybody wants to waste their time with this script and has questions: no.axiom@gmail.com
use warnings;
use strict;

my $inputfile = "main.db";  #main.db is the database file from ClamAV, you need to extract the .db file manually
my @hivs;			#big array of virus definitions
my $i;				#incrementer
my $scal;			#A line of a scalpel definition to parse around with
my $name;			#Name of the "Virus"
my $sig;			#Hex encoded signature of "Virus"
my $sigcount;			#Amount of signatures found

open IN, $inputfile or die "The file has to actually exist, try again $!\n";	#input filehandle is IN
#open OUT, ">$outputfile" or die "You don't have permissions to write that file $!\n"; #output is OVEROUT

$i = 0;
while (<IN>) {
	$hivs[$i] = $_;		#Build up array of virus signatures from definition file
	$i++;
}


$i = 0;
$sigcount = @hivs;		#Get the amount of signatures for the below loop

while ($i ne $sigcount) {
$scal = $hivs[$i];		#Grab "Virus" signature to parse as a Scalpel line

if (($scal) && ($scal =~ /(.+)=(.+)/)) {	#Capture the pieces before and after "=" (name and sig)
	$name = $1;				#Store the name
	$sig = $2;				#Store the sig
	$name =~ s/\W//g;			#Get rid of all non-alphanumeric
	$sig =~ s/(\w\w)/\\x$1/g;		#Reformat Hex encoding to fit Scalpels format
	print "$name\ty\t1\t$sig\n";		#Print the peices out in scalpel order and format
	$i++					#Next sig
}
}
