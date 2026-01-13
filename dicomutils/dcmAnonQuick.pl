#!/usr/bin/perl

# Anonymize directory of DICOM files FOR A SINGLE PATIENT.
# There better not be multiple subjects in the directory.
# There better not be any spaces in the DICOM file name.
# This script only hashes the MRN once, and uses it for all files in the directory.
# 
# Usage: $ perl dcmAnonQuick.pl <DICOM_file_identifier> <new_patient_name> <path_to_directory>
# If you want to use a hashed MRN for the new patient name, use "-h" for new_patient_name

use warnings;
use strict;

# Import Digest module for hashing MRNs
use Digest::MD5 qw(md5_hex);

my $dcm_ID = $ARGV[0];
my $new_patient_name = $ARGV[1];
my $path = $ARGV[2];

my @dcm_keys = (
    '(0038,0010)', # AdmissionID
    '(0008,0092)', # ReferringPhysicianAddress
    '(0008,0094)', # ReferringPhysicianTelephoneNumber
    '(0008,0096)', # ReferringPhysicianIDSequence
    '(0008,1155)', # ReferencedSOPInstanceUID
    '(0008,1048)', # PhysicianOfRecord
    '(0008,1049)', # PhysicianOfRecordIDSequence
    '(0008,1050)', # PerformingPhysicianName
    '(0008,1052)', # PerformingPhysicianIDSequence
    '(0009,1030)', # ServiceID
    '(0009,1031)', # MobileLocationNumber
    '(0009,1002)', # SuiteID
    '(0010,1000)', # OtherPatientIDs
    '(0010,1002)', # OtherPatientIDsSequence
    '(0010,1001)', # OtherPatientNames
    '(0010,1090)', # MedicalRecordLocator
    '(0040,1103)', # PatientTelephoneNumber
    '(0010,2154)', # PatientTelephoneNumbers
    '(0010,21b0)', # AdditionalPatientHistory
    '(0010,1040)', # PatientAddress
    '(0010,4000)', # PatientComments
    '(0018,4000)', # AcquisitionComments
    '(0020,4000)', # ImageComments
    '(0025,101a)', # PrimaryReceiverSuiteAndHost
    '(0038,0300)', # CurrentPatientLocation
    '(0038,0400)', # PatientInstitutionResidence
    '(0040,0006)', # SchedulePerformingPhysicianName
    '(0040,a123)', # PersonName
    '(0040,0275)', # RequestAttributesSequence (may contain accession number)
    '(0010,21b0)', # AdditionalPatientHistory
    '(0038,0014)', # IssuerOfAdmissionID
    '(0010,1005)', # PatientBirthName
    '(0010,1060)', # PatientMotherBirthName
    '(0010,21f0)', # PatientReligiousPreference
    '(0038,0011)',
    '(0400,0561)',
    '(0023,1080)',
    '(0033,1013)',
    '(0009,1101)');

anonymize_files( $path, $dcm_ID, $new_patient_name, '', @dcm_keys );


##################################
# Function for anonymizing DICOMs
##################################
sub anonymize_files {

    my $path = shift;
    my $dcm_ID = shift;
    my $new_patient_name = shift;
    my $hash_ID = shift;
    my @dcm_keys = @_;

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
	    anonymize_files( $thing_path, $dcm_ID, $new_patient_name, $hash_ID, @dcm_keys );
	} 

	# If file is DICOM, anonymize it
	elsif ($thing =~ /$dcm_ID/) {
	    
	    foreach my $key (@dcm_keys) {
		my $cmd = 'dcmodify -q -nb -imt -e "' . $key . '" ' . "\'" . $path . "\'" . "/*$dcm_ID*";
		print("$cmd\n");
		system($cmd);
	    }
	    
	    if ($hash_ID eq '') {
		$hash_ID = get_hash_ID($thing_path);
	    }

	    # Patient ID
	    my $cmd2 = 'dcmodify -q -nb -imt -m "(0010,0020)"="' . $hash_ID . '" ' . "\'" . $path . "\'" . "/*$dcm_ID*";
	    print("$cmd2\n");
	    system($cmd2);

	    # Patient name
	    if ($new_patient_name eq '-h') {
		my $cmd3 = 'dcmodify -q -nb -imt -m "(0010,0010)"="' . $hash_ID . '" ' . "\'" . $path . "\'" . "/*$dcm_ID*";
		print("$cmd3\n");
		system($cmd3);	
	    }
	    else { 
		my $cmd3 = 'dcmodify -q -nb -imt -m "(0010,0010)"="' . $new_patient_name . '" ' . "\'" . $path . "\'" . "/*$dcm_ID*";
		print("$cmd3\n");
		system($cmd3);
	    }

	    # Patient birth date
	    my $cmd4 = 'dcmodify -q -nb -imt -m "(0010,0030)"="" ' . "\'" . $path . "\'" . "/*$dcm_ID*";
	    print("$cmd4\n");
	    system($cmd4);

	    # Referring physician name
	    my $cmd5 = 'dcmodify -q -nb -imt -m "(0008,0090)"="cleared^cleared" ' . "\'" . $path . "\'" . "/*$dcm_ID*";
            print("$cmd5\n");
            system($cmd5);

	    # Accession number
	    my $trunc = substr($hash_ID, 0, 16);
            my $cmd6 = 'dcmodify -q -nb -imt -m "(0008,0050)"="' . $trunc . '" ' . "\'" . $path . "\'" . "/*$dcm_ID*";
            print("$cmd6\n");
            system($cmd6);
	    
	    return;
	    
	}
	
	# If file is not a DICOM, skip it
	else {
	    print "$thing not recognized as DICOM; skipping... \n";
	}
	
    }
} 


####################################
# Function for hashing patient MRNs
####################################
sub get_hash_ID {

    my $thing_path = shift;
    my $text_dump = `dcmdump +P "PatientID" "$thing_path"`;
    my ($mrn) = $text_dump =~ m/ \[ (\w+) \] /x;
    my $hash = md5_hex($mrn);
    return $hash;

}
