function careful_move(source_dir, target_dir)
  
src_contents = dir(source_dir);
src_pds = {src_contents.name}'; 
trgt_contents = dir(target_dir);
trgt_pds = {trgt_contents.name}';

fid = fopen('movelog.txt', 'w');

for i = 3:length(src_pds)

  fprintf('\n---------------------------------------\n');
  fprintf(fid, '\n---------------------------------------\n');

  % Patient codename
  src_subj = src_pds{i};
  src_path = fullfile(src_contents(i).folder, src_contents(i).name);
  match_subj = any(strcmp(src_subj, trgt_pds));
  
  if ~match_subj
    fprintf('Moving %s to target directory\n', src_subj);
    fprintf(fid, 'Moving %s to target directory\n', src_subj);
    [status, msg] = movefile(src_path, target_dir);
    if ~status
      fprintf('%s\n', msg);
      fprintf(fid, '%s\n', msg);
    end
    continue
    
  else
    fprintf('%s exists in target directory, checking scan dates\n', src_subj);
    fprintf(fid, '%s exists in target directory, checking scan dates\n', src_subj);
  end

  % Date of exam
  src_dates_dir = dir(src_path);
  src_dates = {src_dates_dir.name}';
  trgt_path = fullfile(target_dir, src_subj);
  trgt_dates_dir = dir(trgt_path);
  trgt_dates = {trgt_dates_dir.name}';
  
  for j = 3:length(src_dates)
    src_date = src_dates{j};
    src_date_path = fullfile(src_dates_dir(j).folder, src_dates_dir(j).name);
    match_dates = any(strcmp(src_date, trgt_dates));

    if ~match_dates
      fprintf('Moving exam date %s into directory for %s\n', src_date, src_subj);
      fprintf(fid, 'Moving exam date %s into directory for %s\n', src_date, src_subj);
      [status, msg] = movefile(src_date_path, trgt_path);
      if ~status
	fprintf('%s\n', msg);
	fprintf(fid, '%s\n', msg);
      end
      continue
      
    else
      fprintf('Date %s exists for %s, checking series\n', src_date, src_subj);
      fprintf(fid, 'Date %s exists for %s, checking series\n', src_date, src_subj);
    end

    trgt_date_indx = find(strcmp(src_date, trgt_dates));
    trgt_date_path = fullfile(trgt_dates_dir(trgt_date_indx).folder, trgt_dates_dir(trgt_date_indx).name);

    % Series
    src_ser_dir = dir(src_date_path);
    src_sers = {src_ser_dir.name}';
    for s = 3:length(src_sers)
      src_sers{s} = nixify(src_sers{s});
    end
    trgt_ser_dir = dir(trgt_date_path);
    trgt_sers = {trgt_ser_dir.name}';
    for s = 3:length(trgt_sers)
      trgt_sers{s} = nixify(trgt_sers{s});
    end

    for k = 3:length(src_sers)
      src_ser = src_sers{k};
      src_ser_path = fullfile(src_ser_dir(k).folder, src_ser_dir(k).name);
      match_ser = any(strcmp(src_ser, trgt_sers));

      if ~match_ser
	fprintf('Moving series %s into %s/%s\n', src_ser, src_subj, src_date);
	fprintf(fid, 'Moving series %s into %s/%s\n', src_ser, src_subj, src_date);
	[status, msg] = movefile(src_ser_path, trgt_date_path);
	if ~status
          fprintf('%s\n', msg);
          fprintf(fid, '%s\n', msg);
	end
	continue

      else
	fprintf('Series %s exists for %s/%s, not moving to target directory\n', src_ser, src_subj, src_date); 
	fprintf(fid,'Series %s exists for %s/%s, not moving to target directory\n', src_ser, src_subj, src_date); 
      end

    end
  end
end

fclose(fid);

end
