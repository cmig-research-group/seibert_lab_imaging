#!/usr/bin/perl

# Delete a list of tags from a directory of DICOM files.
# 
# Usage: $ perl dcmDeleteMultiTags.pl <path_to_directory>

use warnings;
use strict;

my $path = $ARGV[0];

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
    '(0010,0050)', # PatientInsurancePlanCodeSequence
    '(0038,0011)',
    '(0400,0561)',
    '(0023,1080)',
    '(0033,1013)',
    '(0009,1101)');

anonymize_files( $path, @dcm_keys );


##################################
# Function for anonymizing DICOMs
##################################
sub anonymize_files {

    my $path = shift;
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
	    anonymize_files( $thing_path, @dcm_keys );
	} 

	# Anonymize all DICOM files in directory
	else {
	    
	    foreach my $key (@dcm_keys) {
		my $cmd = 'dcmodify -q -nb -imt -e "' . $key . '" ' . "\'" . $path . "\'" . "/*";
		print("$cmd\n");
		system($cmd);
	    }
	    
	    return;
	    
	}
		
    }
} 

