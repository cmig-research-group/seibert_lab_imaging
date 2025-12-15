#!/usr/bin/perl

# Delete DICOM tag for every DICOM file in a directory. 
# Usage: $ perl dcmDeleteTag.pl <DICOM_file_identifier> <DICOM_tag_to_delete> <path_to_directory>

use warnings;
use strict;

# Import my DICOM library
use File::Basename qw(dirname);
use Cwd qw(abs_path);
use lib dirname(abs_path($0)) . '/lib';
use My::Dicom qw(delete_tag);

my $dcm_ID = $ARGV[0];
my $tag_ID = $ARGV[1];
my $path = $ARGV[2];

delete_tag( $dcm_ID, $tag_ID, $path );
