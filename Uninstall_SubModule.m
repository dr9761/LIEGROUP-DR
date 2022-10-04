function Uninstall_SubModule(FullPathOfProject)
if nargin == 0
	FullPathOfProgramm = mfilename('fullpath'); 
	[FullPathOfProject,~]=fileparts(FullPathOfProgramm);
end
%%
All_File = dir(FullPathOfProject);
All_File = All_File(3:end);
SubModule_Folder = find([All_File(:).bytes] == 0);
%%
for SubModule_Nr = 1:numel(SubModule_Folder)
	FolderName = All_File(SubModule_Folder(SubModule_Nr)).name;
	warning('off');
% 	if exist(genpath(FolderName),'dir')
		rmpath(genpath(FolderName));
% 	end
	warning('on');
end

end