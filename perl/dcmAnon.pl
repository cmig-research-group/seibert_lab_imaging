#!/usr/bin/perl

# Anonymize directory of DICOM files. 
# Usage: $ perl dcmAnon.pl <DICOM_file_identifier> <new_patient_name> <path_to_directory>
# If you want to use a hashed MRN for the new patient name, use "-h" for new_patient_name

use warnings;
use strict;

# Import my DICOM library
use File::Basename qw(dirname);
use Cwd qw(abs_path);
use lib dirname(abs_path($0)) . '/lib';
use My::Dicom qw(anonymize_files);

my $dcm_ID = $ARGV[0];
my $new_patient_name = $ARGV[1];
my $path = $ARGV[2];

my @dcm_keys = qw[
	AdmissionID
	SourceApplicationEntityTitle
	AccessionNumber
	ReferringPhysicianName
	ReferringPhysicianAddress
	ReferringPhysicianTelephoneNumber
	ReferringPhysicianIDSequence
	ReferencedSOPInstanceUID
	PhysicianOfRecord
	PhysicianOfRecordIDSequence
	PerformingPhysicianName
	PerformingPhysicianIDSequence
	ServiceID
	MobileLocationNumber
	SuiteID
	PatientBirthDate
	OtherPatientIDs
	OtherPatientNames
	MedicalRecordLocator
	PatientTelephoneNumber
	PatientTelephoneNumbers
	AdditionalPatientHistory
	PatientAddress
	PatientComments
	ImageComments
	PrimaryReceiverSuiteAndHost
	CurrentPatientLocation
	PatientInstitutionResidence
	SchedulePerformingPhysicianName
	PersonName
	ReferringPhysicianName
	AdditionalPatientHistory
	AdmissionID
	IssuerOfAdmissionID
        PatientBirthName
        PatientMotherBirthName
        PatientReligiousPreference
];
push @dcm_keys, '(0038,0011)';
push @dcm_keys, '(0400,0561)';
push @dcm_keys, '(0023,1080)';
push @dcm_keys, '(0033,1013)';

anonymize_files( $path, $dcm_ID, $new_patient_name, @dcm_keys );

