#!/usr/bin/perl

use warnings;
use strict;

# Import my DICOM library
use File::Basename qw(dirname);
use Cwd qw(abs_path);
use lib dirname(abs_path($0)) . '/lib';
use My::Dicom qw(decompress_dicoms);

my $dcm_ID = $ARGV[0];
my $path = $ARGV[1];

print "Decompressing DICOMs...\n\n";
decompress_dicoms( $path, $dcm_ID );

