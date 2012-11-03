#!usr/bin/perl
use strict;

my $ref_file = "./songs.txt";

if (!( -e $ref_file )) {
   die ( "\nERROR : songs.txt file not found in current directory.\n\n" );
}

open (FILE, $ref_file); 

my @file_contents = <FILE>;

foreach my $line ( @file_contents ) {

   chomp($line);

   print "Downloading songs from ".$line."\n";

   `mkdir -p $line`;

   `perl downloader.pl $line`;

   `mv *.mp3 $line`;
}
