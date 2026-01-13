function dcmDecompress(path_in)

files = recursive_dir(path_in);
num_files = length(files);

TransferSyntax_not_compressed = {'1.2.840.10008.1.2', '1.2.840.10008.1.2.1', '1.2.840.10008.1.2.1.99', '1.2.840.10008.1.2.2'};

for i = 1:num_files
    try

      fname = files{i};
      dcminfo = dicominfo(fname);
      if any(strcmp(dcminfo.TransferSyntaxUID, TransferSyntax_not_compressed))
	fprintf('Not compressed: %s\n', fname);
	continue
      end

      dcmdata = dicomread(fname);
      dcminfo.TransferSyntaxUID = '1.2.840.10008.1.2.1';
      dicomwrite(dcmdata, fname, dcminfo);

      fprintf('%d/%d\n', i, num_files);

    catch ME
      fprintf('%s\n', ME.message);
    end
end

end
