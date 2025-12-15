if ~isdeployed

  paths2add = {'~/code'};

  disp('Adding my paths');
  for i = 1:length(paths2add)
    disp(['Adding: ' paths2add{i}]);
    addpath(genpath(paths2add{i}));
  end

  disp(['Adding: ' userpath]);
  addpath(genpath(userpath));

end
