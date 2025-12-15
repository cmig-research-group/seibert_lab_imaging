#!/usr/bin/perl

# Change DICOM tag value for every DICOM file in a directory. 
# Usage: $ perl dcmChangeTag.pl <DICOM_file_identifier> <DICOM_tag_to_change> <new_DICOM_tag_value> <path_to_directory>

use warnings;
use strict;

# Import my DICOM library
use File::Basename qw(dirname);
use Cwd qw(abs_path);
use lib dirname(abs_path($0)) . '/lib';
use My::Dicom qw(change_tag);

my $dcm_ID = $ARGV[0];
my $tag_ID = $ARGV[1];
my $tag_value = $ARGV[2];
my $path = $ARGV[3];

change_tag( $dcm_ID, $tag_ID, $tag_value, $path );
