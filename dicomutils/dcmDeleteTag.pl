#!/usr/bin/perl

# Delete DICOM tag for every DICOM file in a directory. 
# Usage: $ perl dcmDeleteTag.pl <DICOM_file_identifier> <DICOM_tag_to_delete> <path_to_directory>

use warnings;
use strict;

my $dcm_ID = $ARGV[0];
my $tag_ID = $ARGV[1];
my $path = $ARGV[2];

delete_tag( $dcm_ID, $tag_ID, $path );


####################################
# Function for deleting a DICOM tag
####################################
sub delete_tag {

        my $dcm_ID = shift;
	my $tag_ID = shift;
	my $path = shift;

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
		        delete_tag( $dcm_ID, $tag_ID, $thing_path );
		} 
		# If file is DICOM, delete the specified tag
		elsif ($thing =~ /$dcm_ID/) {
		        my $cmd = 'dcmodify -q -nb -imt -e "' . $tag_ID . '" ' . '"' . $thing_path . '"';
		        system($cmd);
 		}
		# If file is not a DICOM, skip it
		else {
			next;
		}
		
	}
}
