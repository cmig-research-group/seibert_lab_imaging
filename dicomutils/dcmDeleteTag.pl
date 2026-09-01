#!/usr/bin/perl

# Delete DICOM tag for every DICOM file in a directory. 
# Usage: $ perl dcmDeleteTag.pl <DICOM_tag_to_delete> <path_to_directory>

use warnings;
use strict;

my $tag_ID = $ARGV[0];
my $path = $ARGV[1];

delete_tag( $tag_ID, $path );


####################################
# Function for deleting a DICOM tag
####################################
sub delete_tag {

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
		        delete_tag( $tag_ID, $thing_path );
		} 
		# Delete the specified tag
		else {
		        my $cmd = 'dcmodify -q -nb -imt -e "' . $tag_ID . '" ' . '"' . $thing_path . '"';
		        system($cmd);
 		}
		
	}
}
