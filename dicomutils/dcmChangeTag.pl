#!/usr/bin/perl

# Change DICOM tag value for every DICOM file in a directory. 
# Usage: $ perl dcmChangeTag.pl <DICOM_file_identifier> <DICOM_tag_to_change> <new_DICOM_tag_value> <path_to_directory>

use warnings;
use strict;

my $tag_ID = $ARGV[0];
my $tag_value = $ARGV[1];
my $path = $ARGV[2];

change_tag( $tag_ID, $tag_value, $path );


####################################
# Function for changing a DICOM tag
####################################
sub change_tag {

	my $tag_ID = shift;
	my $tag_value = shift;
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
		        change_tag( $tag_ID, $tag_value, $thing_path );
		} 
		# Change the specified tag
		else {
			my $cmd = 'dcmodify -q -nb -imt -m "' . $tag_ID . '"="' . $tag_value . '" ' . '"' . $thing_path . '"';
			system($cmd);
 		}
		
	}
}
