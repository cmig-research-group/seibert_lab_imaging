#!/usr/bin/perl

# Strictly anonymize directory of DICOM files
# Deletes, rather than hashes, patient and exam info, to make files suitable for distribution 
#
# Usage: $ perl dcmAnonStrict.pl <DICOM_file_identifier> <path_to_directory_containing_DICOM_files>

use warnings;
use strict;

my $dcm_ID = $ARGV[0];
my $path = $ARGV[1];

my @dcm_keys = (
    '(0010,0010)', # PatientName
    '(0010,0020)', # PatientID
    '(0010,0030)', # PatientBirthDate
    '(0010,0032)', # PatientBirthTime
    '(0008,0020)', # StudyDate
    '(0008,0021)', # SeriesDate
    '(0008,0030)', # StudyTime
    '(0008,0031)', # SeriesTime
    '(0008,0080)', # InstitutionName
    '(0008,1010)', # StationName
    '(0008,1070)', # OperatorsName
    '(0010,0040)', # PatientSex
    '(0010,1010)', # PatientAge
    '(0010,1030)', # PatientWeight
    '(0020,0010)', # StudyID
    '(0008,0090)', # ReferringPhysicianName
    '(0008,0050)', # AccessionNumber
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

anonymize_files( $path, $dcm_ID,  @dcm_keys );


##################################
# Function for anonymizing DICOMs
##################################
sub anonymize_files {

    my $path = shift;
    my $dcm_ID = shift;
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
	    anonymize_files( $thing_path, $dcm_ID, @dcm_keys );
	} 

	# If file is DICOM, anonymize it
	elsif ($thing =~ /$dcm_ID/) {
	    
	    foreach my $key (@dcm_keys) {
		my $cmd = 'dcmodify -q -nb -imt -e "' . $key . '" ' . "\'" . $path . "\'" . "/*$dcm_ID*";
		print("$cmd\n");
		system($cmd);
	    }
	    
	    return;
	    
	}
	
	# If file is not a DICOM, skip it
	else {
	    print "$thing not recognized as DICOM; skipping... \n";
	}
	
    }
} 
