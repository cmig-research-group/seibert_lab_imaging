#!/usr/bin/perl

# Decompress directory of JPEG-compressed DICOM files  
# Usage: $ perl dcmDecompress.pl <DICOM_file_identifier> <path_to_directory>

use warnings;
use strict;

my $dcm_ID = $ARGV[0];
my $path = $ARGV[1];

print "Decompressing DICOMs...\n\n";
decompress_dicoms( $path, $dcm_ID );


####################################
# Function for decompressing DICOMs
####################################
sub decompress_dicoms {

	my $path = shift;
	my $dcm_ID = shift;
	
	opendir(DIR, $path) || die "Error: Could not open $path: $! \n\n";
	
	my @things = readdir(DIR);
	closedir(DIR);
	
	foreach my $thing (@things) { 
		
		# Throw away . and .. directories
		if ($thing eq '.' or $thing eq '..') {
			next;
		}
		
		my $thing_path = $path . '/' . $thing;

		# Recursively access directories
		if (-d $thing_path) {
			decompress_dicoms( $thing_path, $dcm_ID );
		} 
		# If file is DICOM, decompress it
		elsif ($thing =~ /$dcm_ID/i) {
			my $cmd = 'dcmdjpeg ' . '"' . $thing_path . '"' .  ' ' . '"' . $thing_path . '"';
			system($cmd);
 		}
		# If file is not a DICOM, skip it
		else {
			print "$thing not recognized as DICOM; skipping... \n";
		}
		
	}
} 
