function Load_SubModule(FullPathOfProject)
if nargin == 0
	FullPathOfProgramm = mfilename('fullpath'); 
	[FullPathOfProject,~]=fileparts(FullPathOfProgramm);
end
%%
fprintf('Start to Load Sub-Module ...\n');
fprintf('...\n');
Uninstall_SubModule(FullPathOfProject);
%%
All_File = dir(FullPathOfProject);
All_File = All_File(3:end);
SubModule_Folder = find([All_File(:).bytes] == 0);
%%
for SubModule_Nr = 1:numel(SubModule_Folder)
	FolderName = ...
		All_File(SubModule_Folder(SubModule_Nr)).name;
	if strcmp(FolderName,'3D Rotation')
		addpath(genpath(FolderName));
	elseif strcmp(FolderName,'Result')
		addpath(FolderName);
	else
		addpath(genpath(FolderName));
	end
end

% addpath(genpath(pwd));
%%
fprintf('All Sub-Modules have been loaded!\n');
fprintf('Ready to Run the Main Programm!\n');
fprintf('\n');

end