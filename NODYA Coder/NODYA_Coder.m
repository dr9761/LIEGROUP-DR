function NODYA_Coder(ExcelFile)
%%
% clc;clear;close all;
if nargin == 0
	ExcelFileName = ...
		'Lattice Boom Crane Simplify 3';
	ExcelFileDir = [...
		'Parameter File', ...
		'\Lattice boom crane model'];
	ExcelFile = [ExcelFileDir,'\',ExcelFileName];
end
%%
[ExcelFileDir,ExcelFileName] = fileparts(ExcelFile);
[ModelParameter,SolverParameter] = ...
	Set_AllParameter_from_ExcelFile(ExcelFileName,ExcelFileDir,false);
%% Node Element
[Frame,Body] = get_Current_Body_State(...
	ModelParameter.InitialState.x0,ModelParameter);

BodyElementParameter = ModelParameter.BodyElementParameter;
%% get All Nodes without Constraint (With duplicate nodes)
[FrameNode,BodyNode,FrameNodeNr,BodyNodeNr,NodeIndex] = ...
	get_AllNodes_without_Constraint(Frame,Body);
% SystemNode
% SystemNode.FrameNode = FrameNode;
% SystemNode.FrameNodeNr = FrameNodeNr;
% SystemNode.BodyNodePosition = BodyNode;
% SystemNode.BodyNodeNr = BodyNodeNr;
% SystemNode.NodeIndex = NodeIndex;
%% add Constraint to eliminate duplicate nodes
ConstraintParameter = ModelParameter.ConstraintParameter;
for ConstraintNr = 1:numel(ConstraintParameter)
	ConstraintType = ConstraintParameter{ConstraintNr}.ConstraintType;
	BodyNr1 = ConstraintParameter{ConstraintNr}.BodyNr1;
	JointNr1 = ConstraintParameter{ConstraintNr}.JointNr1;
	
	BodyNr2 = ConstraintParameter{ConstraintNr}.BodyNr2;
	JointNr2 = ConstraintParameter{ConstraintNr}.JointNr2;
	
	if BodyNr1 == 0
		BodyType1 = Frame.BodyType;
		NodeNr1 = FrameNodeNr{JointNr1};
	else
		BodyType1 = Body{BodyNr1}.BodyType;
		NodeNr1 = BodyNodeNr{BodyNr1}{JointNr1};
	end
	if BodyNr2 == 0
		BodyType2 = Frame.BodyType;
		NodeNr2 = FrameNodeNr{JointNr2};
	else
		BodyType2 = Body{BodyNr2}.BodyType;
		NodeNr2 = BodyNodeNr{BodyNr2}{JointNr2};
	end
	switch ConstraintType
		case {'Revolute_x','Revolute_y','Revolute_z', ...
				'Spherical','Fixed','Closed_Revolute'}
			[FrameNodeNr,BodyNodeNr,NodeIndex] = ...
				Replace_NodeIndex(FrameNodeNr,BodyNodeNr,NodeIndex, ...
				BodyNr1,BodyType1,JointNr1,NodeNr1, ...
				BodyNr2,BodyType2,JointNr2,NodeNr2,	...
				BodyElementParameter);
		case 'Prismatic'

		otherwise
			
	end
end

%% Element
BodyQuantity = numel(Body);
BodyElement = cell(BodyQuantity,1);
SystemMaterial = cell(0);
SystemElementQuantity = 0;
for BodyNr = 1:BodyQuantity
	BodyType = Body{BodyNr}.BodyType;
	switch BodyType
		case 'Rigid Body'
			RigidBodyElementQuantity = ...
				numel(ModelParameter.PlotParameter{BodyNr}.PlotSequence)-1;
			for RigidBodyElementNr = 1:RigidBodyElementQuantity
				JointNr1 = ...
					ModelParameter.PlotParameter{BodyNr}.PlotSequence(RigidBodyElementNr);
				JointNr2 = ...
					ModelParameter.PlotParameter{BodyNr}.PlotSequence(RigidBodyElementNr+1);
				
				BodyElement{BodyNr}.RigidBeam{RigidBodyElementNr}.Nodc = ...
					BodyNodeNr{BodyNr}{JointNr1};
				BodyElement{BodyNr}.RigidBeam{RigidBodyElementNr}.Nodi = ...
					BodyNodeNr{BodyNr}{JointNr2};
				BodyElement{BodyNr}.RigidBeam{RigidBodyElementNr}.ElementNr = ...
					SystemElementQuantity + 1;
				
				SystemElementQuantity = SystemElementQuantity + 1;
			end
		case {'Timoshenko Beam','Cubic Spline Beam'}
			BodyElement{BodyNr}.BeamType = 'bar';
			BodyElement{BodyNr}.MaterialNr = BodyNr * 100;
			BodyElement{BodyNr}.PropertiesNr = BodyNr * 100;
			BodyElement{BodyNr}.BeamNodeNr1 = BodyNodeNr{BodyNr}{1};
			BodyElement{BodyNr}.BeamNodeNr2 = BodyNodeNr{BodyNr}{2};
			BodyElement{BodyNr}.ElementNr = SystemElementQuantity + 1;
			
			SystemElementQuantity = SystemElementQuantity + 1;
		case {'Strut Tie Model'}
			BodyElement{BodyNr}.BeamType = 'truss';
			BodyElement{BodyNr}.MaterialNr = BodyNr * 100;
			BodyElement{BodyNr}.PropertiesNr = BodyNr * 100;
			BodyElement{BodyNr}.BeamNodeNr1 = BodyNodeNr{BodyNr}{1};
			BodyElement{BodyNr}.BeamNodeNr2 = BodyNodeNr{BodyNr}{2};
			BodyElement{BodyNr}.ElementNr = SystemElementQuantity + 1;
			
			SystemElementQuantity = SystemElementQuantity + 1;
		case {'Strut Tie Rope Model','Cubic Spline Rope'}
			BodyElement{BodyNr}.BeamType = 'cable';
			BodyElement{BodyNr}.MaterialNr = BodyNr * 100;
			BodyElement{BodyNr}.PropertiesNr = BodyNr * 100;
			BodyElement{BodyNr}.BeamNodeNr1 = BodyNodeNr{BodyNr}{1};
			BodyElement{BodyNr}.BeamNodeNr2 = BodyNodeNr{BodyNr}{2};
			BodyElement{BodyNr}.ElementNr = SystemElementQuantity + 1;
			
			SystemElementQuantity = SystemElementQuantity + 1;
		case 'Super Truss Element'
			Truss_Parameter = BodyElementParameter{BodyNr}.Truss_Parameter;
			TrussOrder = Truss_Parameter.TrussOrder;
			% Cross Section Beam
			CrossSectionBeamParameter = ...
				Truss_Parameter.CrossSectionBeamParameter;
			
			CrossSectionBeamMaterialNr = BodyNr * 100 + 1;
			CrossSectionBeamPropertiesNr = BodyNr * 100 + 1;
			for CrossSectionNr = ...
					1:numel(CrossSectionBeamParameter.CrossSectionBeam)
				for CrossSectionBeamNr = ...
						1:numel(CrossSectionBeamParameter.CrossSectionBeam{CrossSectionNr}.Beam)
					CrossSectionBeamEndPointNr1 = ...
						CrossSectionBeamParameter.CrossSectionBeam{CrossSectionNr}.Beam{CrossSectionBeamNr}(1);
					CrossSectionBeamEndPointNr2 = ...
						CrossSectionBeamParameter.CrossSectionBeam{CrossSectionNr}.Beam{CrossSectionBeamNr}(2);
					if CrossSectionNr == 1
						NodeNr1 = BodyNodeNr{BodyNr}{CrossSectionBeamEndPointNr1,1};
						NodeNr2 = BodyNodeNr{BodyNr}{CrossSectionBeamEndPointNr2,1};
					elseif CrossSectionNr == 2
						NodeNr1 = BodyNodeNr{BodyNr}{CrossSectionBeamEndPointNr1,TrussOrder+1};
						NodeNr2 = BodyNodeNr{BodyNr}{CrossSectionBeamEndPointNr2,TrussOrder+1};
					end
					BodyElement{BodyNr}.CrossSectionBeam{CrossSectionNr,CrossSectionBeamNr}.BeamType = ...
						'bar';
					BodyElement{BodyNr}.CrossSectionBeam{CrossSectionNr,CrossSectionBeamNr}.MaterialNr = ...
						CrossSectionBeamMaterialNr;
					BodyElement{BodyNr}.CrossSectionBeam{CrossSectionNr,CrossSectionBeamNr}.PropertiesNr = ...
						CrossSectionBeamPropertiesNr;
					BodyElement{BodyNr}.CrossSectionBeam{CrossSectionNr,CrossSectionBeamNr}.BeamNodeNr1 = ...
						NodeNr1;
					BodyElement{BodyNr}.CrossSectionBeam{CrossSectionNr,CrossSectionBeamNr}.BeamNodeNr2 = ...
						NodeNr2;
					BodyElement{BodyNr}.CrossSectionBeam{CrossSectionNr,CrossSectionBeamNr}.ElementNr = SystemElementQuantity + 1;
					
					SystemElementQuantity = SystemElementQuantity + 1;
				end
			end
			% Main Beam
			MainBeamParameter = Truss_Parameter.MainBeamParameter;
			
			MainBeamMaterialNr = BodyNr * 100 + 2;
			MainBeamPropertiesNr = BodyNr * 100 + 2;
			for MainBeamNr = 1:numel(MainBeamParameter.Beam)
				for MainSubBeamNr = 1:TrussOrder
					if MainSubBeamNr == 1
						MainBeamEndPointNr1 = MainBeamParameter.Beam{MainBeamNr}(1);
						NodeNr1 = BodyNodeNr{BodyNr}{MainBeamEndPointNr1,1};
						NodeNr2 = BodyNodeNr{BodyNr}{MainBeamNr,MainSubBeamNr+1};
					elseif MainSubBeamNr == TrussOrder
						NodeNr1 = BodyNodeNr{BodyNr}{MainBeamNr,MainSubBeamNr};
						MainBeamEndPointNr2 = MainBeamParameter.Beam{MainBeamNr}(2);
						NodeNr2 = BodyNodeNr{BodyNr}{MainBeamEndPointNr2,TrussOrder+1};
					else
						NodeNr1 = BodyNodeNr{BodyNr}{MainBeamNr,MainSubBeamNr};
						NodeNr2 = BodyNodeNr{BodyNr}{MainBeamNr,MainSubBeamNr+1};
					end
					BodyElement{BodyNr}.MainBeam{MainBeamNr,MainSubBeamNr}.BeamType = ...
						'bar';
					BodyElement{BodyNr}.MainBeam{MainBeamNr,MainSubBeamNr}.MaterialNr = ...
						MainBeamMaterialNr;
					BodyElement{BodyNr}.MainBeam{MainBeamNr,MainSubBeamNr}.PropertiesNr = ...
						MainBeamPropertiesNr;
					BodyElement{BodyNr}.MainBeam{MainBeamNr,MainSubBeamNr}.BeamNodeNr1 = ...
						NodeNr1;
					BodyElement{BodyNr}.MainBeam{MainBeamNr,MainSubBeamNr}.BeamNodeNr2 = ...
						NodeNr2;
					BodyElement{BodyNr}.MainBeam{MainBeamNr,MainSubBeamNr}.ElementNr = SystemElementQuantity + 1;
					
					SystemElementQuantity = SystemElementQuantity + 1;
				end
			end
			% Sub Beam
			SubBeamParameter = Truss_Parameter.SubBeamParameter;
			
			SubBeamMaterialNr = BodyNr * 100 + 3;
			SubBeamPropertiesNr = BodyNr * 100 + 3;
			for PlaneNr = 1:size(SubBeamParameter.Beam,1)
				for SubBeamNr = 1:size(SubBeamParameter.Beam,2)
					if ~isempty(SubBeamParameter.Beam{PlaneNr,SubBeamNr})
						MainBeamNr1 = SubBeamParameter.Beam{PlaneNr,SubBeamNr}(1);
						InternalNodeNr1 = SubBeamParameter.Beam{PlaneNr,SubBeamNr}(2);
						MainBeamNr2 = SubBeamParameter.Beam{PlaneNr,SubBeamNr}(3);
						InternalNodeNr2 = SubBeamParameter.Beam{PlaneNr,SubBeamNr}(4);
						if InternalNodeNr1 == 1
							SubBeamEndPointNr1 = MainBeamParameter.Beam{MainBeamNr1}(1);
							NodeNr1 = BodyNodeNr{BodyNr}{SubBeamEndPointNr1,1};
						elseif InternalNodeNr1 == TrussOrder+1
							SubBeamEndPointNr1 = MainBeamParameter.Beam{MainBeamNr1}(2);
							NodeNr1 = BodyNodeNr{BodyNr}{SubBeamEndPointNr1,TrussOrder+1};
						else
							NodeNr1 = BodyNodeNr{BodyNr}{MainBeamNr1,InternalNodeNr1};
						end
						if InternalNodeNr2 == 1
							SubBeamEndPointNr2 = MainBeamParameter.Beam{MainBeamNr2}(1);
							NodeNr2 = BodyNodeNr{BodyNr}{SubBeamEndPointNr2,1};
						elseif InternalNodeNr2 == TrussOrder+1
							SubBeamEndPointNr2 = MainBeamParameter.Beam{MainBeamNr2}(2);
							NodeNr2 = BodyNodeNr{BodyNr}{SubBeamEndPointNr2,TrussOrder+1};
						else
							NodeNr2 = BodyNodeNr{BodyNr}{MainBeamNr2,InternalNodeNr2};
						end
						
						BodyElement{BodyNr}.SubBeam{PlaneNr,SubBeamNr}.BeamType = ...
							'bar';
						BodyElement{BodyNr}.SubBeam{PlaneNr,SubBeamNr}.MaterialNr = ...
							SubBeamMaterialNr;
						BodyElement{BodyNr}.SubBeam{PlaneNr,SubBeamNr}.PropertiesNr = ...
							SubBeamPropertiesNr;
						BodyElement{BodyNr}.SubBeam{PlaneNr,SubBeamNr}.BeamNodeNr1 = ...
							NodeNr1;
						BodyElement{BodyNr}.SubBeam{PlaneNr,SubBeamNr}.BeamNodeNr2 = ...
							NodeNr2;
						BodyElement{BodyNr}.SubBeam{PlaneNr,SubBeamNr}.ElementNr = SystemElementQuantity + 1;
						
						SystemElementQuantity = SystemElementQuantity + 1;
					end
				end
			end

		otherwise
			
	end
end
%% Element to connect Super Truss Element & others
Additional_RigidLink = cell(numel(ConstraintParameter),1);
for ConstraintNr = 1:numel(ConstraintParameter)
	ConstraintType = ConstraintParameter{ConstraintNr}.ConstraintType;
	if ~strcmpi(ConstraintType,'Prismatic')
		BodyNr1 = ConstraintParameter{ConstraintNr}.BodyNr1;
		JointNr1 = ConstraintParameter{ConstraintNr}.JointNr1;
		
		BodyNr2 = ConstraintParameter{ConstraintNr}.BodyNr2;
		JointNr2 = ConstraintParameter{ConstraintNr}.JointNr2;
		%
		if BodyNr1 == 0
			BodyType1 = Frame.BodyType;
			NodeNr1 = FrameNodeNr{JointNr1};
		else
			BodyType1 = Body{BodyNr1}.BodyType;
			NodeNr1 = BodyNodeNr{BodyNr1}{JointNr1};
		end
		if BodyNr2 == 0
			BodyType2 = Frame.BodyType;
		else
			BodyType2 = Body{BodyNr2}.BodyType;
		end
		%
		if strcmpi(BodyType1,'Super Truss Element') && ...
				~strcmpi(BodyType2,'Super Truss Element')
			%
			if BodyNr2 == 0
				NodeNr2 = FrameNodeNr{JointNr2};
			else
				NodeNr2 = BodyNodeNr{BodyNr2}{JointNr2};
			end
			%
			if JointNr1 == 1
				
				for CrossSectionNodeNr = 1:size(BodyNodeNr{BodyNr1},1)
					NodeNr1 = ...
						BodyNodeNr{BodyNr1}{CrossSectionNodeNr,1};
					if ~isempty(NodeNr1)
						Additional_RigidLink{ConstraintNr}.RigidLink{CrossSectionNodeNr} = ...
							[SystemElementQuantity+1;NodeNr1;NodeNr2];
						SystemElementQuantity = SystemElementQuantity + 1;
					end
				end
				
			elseif JointNr1 == 2
				for CrossSectionNodeNr = 1:size(BodyNodeNr{BodyNr1},1)
					NodeNr1 = ...
						BodyNodeNr{BodyNr1}{CrossSectionNodeNr,end};
					if ~isempty(NodeNr1)
						Additional_RigidLink{ConstraintNr}.RigidLink{CrossSectionNodeNr} = ...
							[SystemElementQuantity+1;NodeNr1;NodeNr2];
						SystemElementQuantity = SystemElementQuantity + 1;
					end

				end
			end
			
		elseif ~strcmpi(BodyType1,'Super Truss Element') && ...
				strcmpi(BodyType2,'Super Truss Element')
			%
			if BodyNr1 == 0
				NodeNr1 = FrameNodeNr{JointNr1};
			else
				NodeNr1 = BodyNodeNr{BodyNr1}{JointNr1};
			end
			%
			if JointNr2 == 1
				
				for CrossSectionNodeNr = 1:size(BodyNodeNr{BodyNr2},1)
					NodeNr2 = ...
						BodyNodeNr{BodyNr2}{CrossSectionNodeNr,1};
					if ~isempty(NodeNr2)
						Additional_RigidLink{BodyNr2}.RigidLink{CrossSectionNodeNr} = ...
							[SystemElementQuantity+1;NodeNr1;NodeNr2];
						SystemElementQuantity = SystemElementQuantity + 1;
					end
				end
				
			elseif JointNr2 == 2
				for CrossSectionNodeNr = 1:size(BodyNodeNr{BodyNr2},1)
					NodeNr2 = ...
						BodyNodeNr{BodyNr2}{CrossSectionNodeNr,end};
					if ~isempty(NodeNr2)
						Additional_RigidLink{BodyNr2}.RigidLink{CrossSectionNodeNr} = ...
							[SystemElementQuantity+1;NodeNr1;NodeNr2];
						SystemElementQuantity = SystemElementQuantity + 1;
					end
				end
			end
			
		end
		
	end
	
	
end
%% Properties
BodyProperties = cell(BodyQuantity,1);
for BodyNr = 1:BodyQuantity
	BodyType = BodyElementParameter{BodyNr}.BodyType;
	BodyProperties{BodyNr}.BodyType = BodyType;
	switch BodyType
		case {'Timoshenko Beam','Cubic Spline Beam'}
			SectionType = BodyElementParameter{BodyNr}.SectionType;
			switch SectionType
				case 'Round Tube'
					H = 0;B1 = 0;B2 = 0;T1 = 0;T2 = 0;T3 = 0;
					
					ra = BodyElementParameter{BodyNr}.ra;
					ri = BodyElementParameter{BodyNr}.ri;
					H = 2 * ra;
					T1 = ra - ri;
					
					BodyProperties{BodyNr}.Type = 'bar-section';
					BodyProperties{BodyNr}.Profile = 'pipe';
					
					BodyProperties{BodyNr}.H  =  H;
					BodyProperties{BodyNr}.B1 = B1;
					BodyProperties{BodyNr}.B2 = B2;
					BodyProperties{BodyNr}.T1 = T1;
					BodyProperties{BodyNr}.T2 = T2;
					BodyProperties{BodyNr}.T3 = T3;
			end
		case {'Strut Tie Model'}
			BodyProperties{BodyNr}.Type = 'truss';
			BodyProperties{BodyNr}.Area = BodyElementParameter{BodyNr}.A;
		case {'Strut Tie Rope Model','Cubic Spline Rope'}
			BodyProperties{BodyNr}.Type = 'cable';
			BodyProperties{BodyNr}.Area = BodyElementParameter{BodyNr}.A;
		case 'Super Truss Element'
			SectionType = BodyElementParameter{BodyNr}.SectionType;
			
			switch SectionType
				case 'Round Tube'
					H  = zeros(3,1);
					B1 = zeros(3,1);
					B2 = zeros(3,1);
					T1 = zeros(3,1);
					T2 = zeros(3,1);
					T3 = zeros(3,1);
					
					ra = zeros(3,1);
					ri = zeros(3,1);
					
					Truss_Parameter = BodyElementParameter{BodyNr}.Truss_Parameter;
					CrossSectionBeamParameter = ...
						Truss_Parameter.CrossSectionBeamParameter.CrossSectionBeam{1}.BodyParameter{1};
					MainBeamParameter = ...
						Truss_Parameter.MainBeamParameter.BodyParameter{1};
					SubBeamParameter = ...
						Truss_Parameter.SubBeamParameter.BodyParameter{1,1};
					
					ra(1) = CrossSectionBeamParameter.ra;
					ra(2) = MainBeamParameter.ra;
					ra(3) = SubBeamParameter.ra;
					
					ri(1) = CrossSectionBeamParameter.ri;
					ri(2) = MainBeamParameter.ri;
					ri(3) = SubBeamParameter.ri;
					
					H = 2 * ra;
					T1 = ra - ri;
					
					BodyProperties{BodyNr}.Type = 'bar-section';
					BodyProperties{BodyNr}.Profile = 'pipe';
					
					BodyProperties{BodyNr}.H  =  H;
					BodyProperties{BodyNr}.B1 = B1;
					BodyProperties{BodyNr}.B2 = B2;
					BodyProperties{BodyNr}.T1 = T1;
					BodyProperties{BodyNr}.T2 = T2;
					BodyProperties{BodyNr}.T3 = T3;
			end
	end
end
%% Material
BodyMaterial = cell(BodyQuantity,1);
for BodyNr = 1:BodyQuantity
	BodyType = BodyElementParameter{BodyNr}.BodyType;
	if strcmpi(BodyType,'Super Truss Element')
		Truss_Parameter = ...
			BodyElementParameter{BodyNr}.Truss_Parameter;
		
		CrossSectionBeamBodyParameter = ...
			Truss_Parameter.CrossSectionBeamParameter.CrossSectionBeam{1}.BodyParameter{1};
		MainBeamBodyParameter = ...
			Truss_Parameter.MainBeamParameter.BodyParameter{1};
		SubBeamBodyParameter = ...
			Truss_Parameter.SubBeamParameter.BodyParameter{1};
		%
		BodyMaterial{BodyNr}.CrossSectionBeam.Density = ...
			CrossSectionBeamBodyParameter.rho;
		BodyMaterial{BodyNr}.MainBeam.Density = ...
			MainBeamBodyParameter.rho;
		BodyMaterial{BodyNr}.SubBeam.Density = ...
			SubBeamBodyParameter.rho;
		
		BodyMaterial{BodyNr}.CrossSectionBeam.E = ...
			CrossSectionBeamBodyParameter.E;
		BodyMaterial{BodyNr}.MainBeam.E = ...
			MainBeamBodyParameter.E;
		BodyMaterial{BodyNr}.SubBeam.E = ...
			SubBeamBodyParameter.E;
		
		BodyMaterial{BodyNr}.CrossSectionBeam.Type = 'elastic';
		BodyMaterial{BodyNr}.MainBeam.Type = 'elastic';
		BodyMaterial{BodyNr}.SubBeam.Type = 'elastic';
		
		BodyMaterial{BodyNr}.CrossSectionBeam.MaterialNr = ...
			BodyNr * 100 + 1;
		BodyMaterial{BodyNr}.MainBeam.MaterialNr = ...
			BodyNr * 100 + 2;
		BodyMaterial{BodyNr}.SubBeam.MaterialNr = ...
			BodyNr * 100 + 3;
		%
		BodyMaterial{BodyNr}.BodyType = BodyType;
		
	elseif ~strcmpi(BodyType,'Rigid Body')
		Type = 'elastic';
		Density = BodyElementParameter{BodyNr}.rho;
		E = BodyElementParameter{BodyNr}.E;
		MaterialNr = BodyNr * 100;
		
		BodyMaterial{BodyNr}.BodyType = BodyType;
		BodyMaterial{BodyNr}.Type = Type;
		BodyMaterial{BodyNr}.Density = Density;
		BodyMaterial{BodyNr}.E = E;
		BodyMaterial{BodyNr}.MaterialNr = MaterialNr;

	elseif strcmpi(BodyType,'Rigid Body')
		
	end
	
	
end
%% do_write
do_write = true;
if do_write
	%% create and open Exchange File
	ExchangeFileName = [ExcelFileName,'_',datestr(now,'yyyymmdd_HHMM'),'.npi'];
	ExchangeFileDir = ['NODYA Coder\NODYA Exchange File'];
	ExchangeFile = [ExchangeFileDir,'\',ExchangeFileName];
	%
	ExchangeFileObj = fopen(ExchangeFile,'wt');
	%% Figure & Axes
	NodeFigure = figure('Name','Node');
	NodeAxes = axes(NodeFigure);
	hold(NodeAxes,'on');
	
	ElementFigure = figure('Name','Element');
	ElementAxes = axes(ElementFigure);
	hold(ElementAxes,'on');
	%% write Node to Exchange File=====
	fprintf(ExchangeFileObj,'! =============================Node============================\n');
	write_Node_to_NODYA_ExchangeFile(FrameNode,BodyNode,NodeIndex, ...
		SolverParameter,ExchangeFileObj,NodeAxes);
	fprintf(ExchangeFileObj,'! =============================================================\n');
	%% write Element to Exchange File
	fprintf(ExchangeFileObj,'! ===========================Element===========================\n');
	write_Element_to_NODYA_ExchangeFile(BodyElement, ...
		FrameNode,BodyNode,NodeIndex, ...
		SolverParameter,ExchangeFileObj,ElementAxes);
	fprintf(ExchangeFileObj,'! =============================================================\n');
	%% write Additional Rigid Link to Exchange File
	fprintf(ExchangeFileObj,'! ====================Additional Rigid Link====================\n');
	write_AdditionalRigidLink_to_NODYA_ExchangeFile(...
		Additional_RigidLink,ExchangeFileObj);
	fprintf(ExchangeFileObj,'! =============================================================\n');
	%% write Properties to Exchange File
	fprintf(ExchangeFileObj,'! =========================Properties==========================\n');
	write_Properties_to_NODYA_ExchangeFile(BodyProperties,ExchangeFileObj);
	fprintf(ExchangeFileObj,'! =============================================================\n');
	%% write Properties to Exchange File
	fprintf(ExchangeFileObj,'! ==========================Material===========================\n');
	write_Material_to_NODYA_ExchangeFile(BodyMaterial,ExchangeFileObj);
	fprintf(ExchangeFileObj,'! =============================================================\n');
	%% save and close Exchange File
	fclose(ExchangeFileObj);
end
end

