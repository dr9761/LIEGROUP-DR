function FullPathOfProject = Configure_WorkingDirectory
%%
FullPathOfProgramm = mfilename('fullpath');
% [FullPathOfProject,~] = fileparts(fileparts(FullPathOfProgramm));
[FullPathOfProject,~] = fileparts(FullPathOfProgramm);
CurrentWorkingDictionary = cd;
%%
if ~strcmp(CurrentWorkingDictionary,FullPathOfProject)
	fprintf('Your Current Working Dictionary is not the path of the Programm!\n');
	fprintf('In order to make the program run normally,\n');
	fprintf('Your Working Dictionary will be changed!\n');
	fprintf('...\n');
	% 	fprintf('Do you want to change your Working Dictionary?[Y/N]\n');
	cd(FullPathOfProject);
	fprintf('Working Dictionary has been changed!\n\n');
end

end