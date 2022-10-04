function Load_3D_Rotation_Methode(Rotation_Methode)

All_File = dir('3D Rotation');
All_File = All_File(3:end);
SubModule_Folder = find([All_File(:).bytes] == 0);

for SubModule_Nr = 1:numel(SubModule_Folder)
	FolderName = ['3D Rotation\', ...
		All_File(SubModule_Folder(SubModule_Nr)).name];
	if exist(FolderName,'dir')
		rmpath(FolderName);
	end
end

FolderName = ['3D Rotation\',Rotation_Methode];
addpath(FolderName);

end