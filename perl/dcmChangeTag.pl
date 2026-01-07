#!/usr/bin/perl

# Change DICOM tag value for every DICOM file in a directory. 
# Usage: $ perl dcmChangeTag.pl <DICOM_file_identifier> <DICOM_tag_to_change> <new_DICOM_tag_value> <path_to_directory>

use warnings;
use strict;

my $dcm_ID = $ARGV[0];
my $tag_ID = $ARGV[1];
my $tag_value = $ARGV[2];
my $path = $ARGV[3];

change_tag( $dcm_ID, $tag_ID, $tag_value, $path );


####################################
# Function for changing a DICOM tag
####################################
sub change_tag {

        my $dcm_ID = shift;
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
		        change_tag( $dcm_ID, $tag_ID, $tag_value, $thing_path );
		} 
		# If file is DICOM, change the specified tag
		elsif ($thing =~ /$dcm_ID/) {
			my $cmd = 'dcmodify -q -nb -imt -m "' . $tag_ID . '"="' . $tag_value . '" ' . '"' . $thing_path . '"';
			system($cmd);
 		}
		# If file is not a DICOM, skip it
		else {
			next;
		}
		
	}
}
