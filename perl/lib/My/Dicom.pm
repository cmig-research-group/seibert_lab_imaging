package My::Dicom;

use warnings;
use strict;

# Import Digest module for hashing MRNs
use Digest::MD5 qw(md5_hex);

use Exporter qw(import);

our @EXPORT_OK = qw(anonymize_files find_path_to_MRNs decompress_dicoms change_tag delete_tag);

##################################
# Function for anonymizing DICOMs
##################################
sub anonymize_files {

	my $path = shift;
	my $dcm_ID = shift;
	my $new_patient_name = shift;
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
			anonymize_files( $thing_path, $dcm_ID, $new_patient_name, @dcm_keys );
		} 
		# If file is DICOM, anonymize it
		elsif ($thing =~ /$dcm_ID/) {
			foreach my $key (@dcm_keys) {
				my $cmd = 'dcmodify -q -nb -imt -e "' . $key . '" ' . '"' . $thing_path . '"';
				system($cmd);
			}
			my $hash_ID = get_hash_ID($thing_path);
			my $cmd2 = 'dcmodify -q -nb -imt -m "PatientID"="' . $hash_ID . '" ' . '"' . $thing_path . '"';
			system($cmd2);
			if ($new_patient_name eq '-h') {
				my $cmd3 = 'dcmodify -q -nb -imt -m "PatientName"="' . $hash_ID . '" ' . '"' . $thing_path . '"';
				system($cmd3);	
			}
			else { 
				my $cmd3 = 'dcmodify -q -nb -imt -m "PatientName"="' . $new_patient_name . '" ' . '"' . $thing_path . '"';
				system($cmd3);
			}
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

#######################################################
# Function for finding path to DICOM data ID'd by MRNs
#######################################################
sub find_path_to_MRNs {

	my $hashfile = shift;
	open(my $fh_hash, '<', $hashfile) || die "Error: Could not open file: $hashfile: $! \n\n";	
	
	my $path_search = shift;
	opendir(DIR, $path_search) || die "Error: Could not open $path_search: $! \n\n";
	my @things = readdir(DIR);
	closedir(DIR);
	
	my $path_out = shift;
	open(my $fh_results, '>>:encoding(UTF-8)', $path_out) || die "Error: Could not open file: $hashfile: $! \n\n";

	my $dcm_ID = shift;
	
	foreach my $thing (@things) { 
		
		# Throw away . and .. directories
		if ($thing eq '.' or $thing eq '..') {
			next;
		}
		
		my $thing_path = $path_search . '/' . $thing;
		
		# Recursively access directories
		if (-d $thing_path) {
			find_path_to_MRNs( $hashfile, $thing_path, $path_out, $dcm_ID );
		} 
		# If file is DICOM, check if it matches any MRNs
		elsif ($thing eq $dcm_ID) {
			my $text_dump = `dcmdump +P "PatientID" "$thing_path"`;
			my ($hash_ID) = $text_dump =~ m/ \[ (\w+) \] /x;
			while (my $hash = <$fh_hash>) {
				chomp $hash;
				if ($hash eq $hash_ID) {
					print $fh_results "$path_search\n";
					print "Found: $path_search\n";
					return;
				}				
			}
 		}

	}

	close $fh_hash;
	close $fh_results;

}

####################################
# Function for decompressing DICOMs
####################################
sub decompress_dicoms {

	my $path = shift;
	my $dcm_ID = shift;
	
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
			decompress_dicoms( $thing_path, $dcm_ID );
		} 
		# If file is DICOM, decompress it
		elsif ($thing =~ /$dcm_ID/i) {
			my $cmd = 'dcmdjpeg ' . '"' . $thing_path . '"' .  ' ' . '"' . $thing_path . '"';
			system($cmd);
 		}
		# If file is not a DICOM, skip it
		else {
			print "$thing not recognized as DICOM; skipping... \n";
		}
		
	}
} 

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

####################################
# Function for deleting a DICOM tag
####################################
sub delete_tag {

        my $dcm_ID = shift;
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
		        delete_tag( $dcm_ID, $tag_ID, $thing_path );
		} 
		# If file is DICOM, delete the specified tag
		elsif ($thing =~ /$dcm_ID/) {
		        my $cmd = 'dcmodify -q -nb -imt -e "' . $tag_ID . '" ' . '"' . $thing_path . '"';
		        system($cmd);
 		}
		# If file is not a DICOM, skip it
		else {
			next;
		}
		
	}
}

"Success";
