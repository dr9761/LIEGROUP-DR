function [FrameNodeNr,BodyNodeNr,NodeIndex] = ...
	Replace_NodeIndex(FrameNodeNr,BodyNodeNr,NodeIndex, ...
	BodyNr1,BodyType1,JointNr1,NodeNr1, ...
	BodyNr2,BodyType2,JointNr2,NodeNr2,	...
	BodyElementParameter)

if ~strcmpi(BodyType1,'Super Truss Element') && ...
		~strcmpi(BodyType2,'Super Truss Element')
% 	NodeIndex{NodeNr2} = NaN;
	if BodyNr2 == 0
		FrameNodeNr{JointNr2} = NodeNr1;
	else
		BodyNodeNr{BodyNr2}{JointNr2} = NodeNr1;
	end
	NodeIndex{NodeNr2} = [];
	BodyNodeNr{BodyNr2}{JointNr2} = NodeNr1;
elseif strcmpi(BodyType1,'Super Truss Element') && ...
		strcmpi(BodyType2,'Super Truss Element')
	if JointNr1 == 1
		SectionNr1 = 1;
	else
		SectionNr1 = ...
			BodyElementParameter{BodyNr1}.Truss_Parameter.TrussOrder+1;
	end
	if JointNr2 == 1
		SectionNr2 = 1;
	else
		SectionNr2 = ...
			BodyElementParameter{BodyNr2}.Truss_Parameter.TrussOrder+1;
	end
	if numel(BodyNodeNr{BodyNr1}(:,SectionNr1)) ~= ...
			numel(BodyNodeNr{BodyNr2}(:,SectionNr2))
		error('The Cross Section of Super Truss Element do not match!\n');
	end
	for CrossSectionNr = 1:numel(BodyNodeNr{BodyNr2}(:,SectionNr2))
		NodeNr2 = BodyNodeNr{BodyNr2}{CrossSectionNr,SectionNr2};
		BodyNodeNr{BodyNr2}{CrossSectionNr,SectionNr2} = ...
			BodyNodeNr{BodyNr1}{CrossSectionNr,SectionNr1};
		NodeIndex{NodeNr2} = [];
	end
end

end