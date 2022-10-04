function write_Element_to_NODYA_ExchangeFile(BodyElement, ...
	FrameNode,BodyNode,NodeIndex, ...
	SolverParameter,ExchangeFileObj,ElementAxes)
BodyQuantity = numel(BodyElement);
for BodyNr = 1:BodyQuantity
	fprintf(ExchangeFileObj,'! Element of Body %u\n',BodyNr);
	if ~isempty(BodyElement{BodyNr})
		if isfield(BodyElement{BodyNr},'RigidBeam')
			RigidBodyElementQuantity = numel(BodyElement{BodyNr}.RigidBeam);
			for RigidBodyElementNr = 1:RigidBodyElementQuantity
				ElementNr = ...
					BodyElement{BodyNr}.RigidBeam{RigidBodyElementNr}.ElementNr;
				Nodec = ...
					BodyElement{BodyNr}.RigidBeam{RigidBodyElementNr}.Nodc;
				Nodei = ...
					BodyElement{BodyNr}.RigidBeam{RigidBodyElementNr}.Nodi;
				
				fprintf(ExchangeFileObj, ...
					'element n = %u type = rigidlink ..\n', ...
					ElementNr);
				fprintf(ExchangeFileObj,'nodec = %u nodei = %u\n', ...
					Nodec,Nodei);
				
				NodePosition1 = ...
					get_Node_Position_BasedOn_NodeIndex(Nodec, ...
					FrameNode,BodyNode,NodeIndex);
				NodePosition2 = ...
					get_Node_Position_BasedOn_NodeIndex(Nodei, ...
					FrameNode,BodyNode,NodeIndex);
				
				NodePositionX = [NodePosition1(1);NodePosition2(1)];
				NodePositionY = [NodePosition1(2);NodePosition2(2)];
				NodePositionZ = [NodePosition1(3);NodePosition2(3)];
				
				plot3(ElementAxes, ...
					NodePositionX,NodePositionY,NodePositionZ,'-.');
			end
		elseif isfield(BodyElement{BodyNr},'MainBeam')
			% Cross Section Beam
			CrossSectionBeam = BodyElement{BodyNr}.CrossSectionBeam;
			fprintf(ExchangeFileObj,'! Cross Section Beam\n');
			for CrossSectionNr = 1:size(CrossSectionBeam,1)
				for CrossSectionBeamNr = 1:size(CrossSectionBeam,2)
					if ~isempty(CrossSectionBeam{CrossSectionNr,CrossSectionBeamNr})
						
						ElementNr = CrossSectionBeam{CrossSectionNr,CrossSectionBeamNr}.ElementNr;
						BeamType = CrossSectionBeam{CrossSectionNr,CrossSectionBeamNr}.BeamType;
						MaterialNr = CrossSectionBeam{CrossSectionNr,CrossSectionBeamNr}.MaterialNr;
						PropertiesNr = CrossSectionBeam{CrossSectionNr,CrossSectionBeamNr}.PropertiesNr;
						
						BeamNodeNr1 = CrossSectionBeam{CrossSectionNr,CrossSectionBeamNr}.BeamNodeNr1;
						BeamNodeNr2 = CrossSectionBeam{CrossSectionNr,CrossSectionBeamNr}.BeamNodeNr2;
						
						fprintf(ExchangeFileObj, ...
							'element n = %u type = %s material = %u properties = %u ..\n', ...
							ElementNr,BeamType,MaterialNr,PropertiesNr);
						fprintf(ExchangeFileObj,'node1 = %u node2 = %u\n', ...
							BeamNodeNr1,BeamNodeNr2);
						
						NodePosition1 = get_Node_Position_BasedOn_NodeIndex(BeamNodeNr1, ...
							FrameNode,BodyNode,NodeIndex);
						NodePosition2 = get_Node_Position_BasedOn_NodeIndex(BeamNodeNr2, ...
							FrameNode,BodyNode,NodeIndex);
						
						NodePositionX = [NodePosition1(1);NodePosition2(1)];
						NodePositionY = [NodePosition1(2);NodePosition2(2)];
						NodePositionZ = [NodePosition1(3);NodePosition2(3)];
						
						plot3(ElementAxes,NodePositionX,NodePositionY,NodePositionZ,'.-');
					end
				end
			end
			% Main Beam
			MainBeam = BodyElement{BodyNr}.MainBeam;
			fprintf(ExchangeFileObj,'! Main Beam\n');
			for MainBeamNr = 1:size(MainBeam,1)
				for MainSubBeamNr = 1:size(MainBeam,2)
					ElementNr = MainBeam{MainBeamNr,MainSubBeamNr}.ElementNr;
					BeamType = MainBeam{MainBeamNr,MainSubBeamNr}.BeamType;
					MaterialNr = MainBeam{MainBeamNr,MainSubBeamNr}.MaterialNr;
					PropertiesNr = MainBeam{MainBeamNr,MainSubBeamNr}.PropertiesNr;
					
					BeamNodeNr1 = MainBeam{MainBeamNr,MainSubBeamNr}.BeamNodeNr1;
					BeamNodeNr2 = MainBeam{MainBeamNr,MainSubBeamNr}.BeamNodeNr2;
					
					fprintf(ExchangeFileObj, ...
						'element n = %u type = %s material = %u properties = %u ..\n', ...
						ElementNr,BeamType,MaterialNr,PropertiesNr);
					fprintf(ExchangeFileObj,'node1 = %u node2 = %u\n', ...
						BeamNodeNr1,BeamNodeNr2);
					
					NodePosition1 = get_Node_Position_BasedOn_NodeIndex(BeamNodeNr1, ...
						FrameNode,BodyNode,NodeIndex);
					NodePosition2 = get_Node_Position_BasedOn_NodeIndex(BeamNodeNr2, ...
						FrameNode,BodyNode,NodeIndex);
					
					NodePositionX = [NodePosition1(1);NodePosition2(1)];
					NodePositionY = [NodePosition1(2);NodePosition2(2)];
					NodePositionZ = [NodePosition1(3);NodePosition2(3)];
					
					plot3(ElementAxes,NodePositionX,NodePositionY,NodePositionZ,'.-');
				end
			end
			
			% Sub Beam
			SubBeam = BodyElement{BodyNr}.SubBeam;
			fprintf(ExchangeFileObj,'! Sub Beam\n');
			for PlaneNr = 1:size(SubBeam,1)
				for SubBeamNr = 1:size(SubBeam,2)
					if ~isempty(SubBeam{PlaneNr,SubBeamNr})
					ElementNr = SubBeam{PlaneNr,SubBeamNr}.ElementNr;
					BeamType = SubBeam{PlaneNr,SubBeamNr}.BeamType;
					MaterialNr = SubBeam{PlaneNr,SubBeamNr}.MaterialNr;
					PropertiesNr = SubBeam{PlaneNr,SubBeamNr}.PropertiesNr;
					
					BeamNodeNr1 = SubBeam{PlaneNr,SubBeamNr}.BeamNodeNr1;
					BeamNodeNr2 = SubBeam{PlaneNr,SubBeamNr}.BeamNodeNr2;
					
					fprintf(ExchangeFileObj, ...
						'element n = %u type = %s material = %u properties = %u ..\n', ...
						ElementNr,BeamType,MaterialNr,PropertiesNr);
					fprintf(ExchangeFileObj,'node1 = %u node2 = %u\n', ...
						BeamNodeNr1,BeamNodeNr2);
					
					NodePosition1 = ...
						get_Node_Position_BasedOn_NodeIndex(...
						BeamNodeNr1, ...
						FrameNode,BodyNode,NodeIndex);
					NodePosition2 = ...
						get_Node_Position_BasedOn_NodeIndex(...
						BeamNodeNr2, ...
						FrameNode,BodyNode,NodeIndex);
					
					NodePositionX = ...
						[NodePosition1(1);NodePosition2(1)];
					NodePositionY = ...
						[NodePosition1(2);NodePosition2(2)];
					NodePositionZ = ...
						[NodePosition1(3);NodePosition2(3)];
					
					plot3(ElementAxes,NodePositionX,NodePositionY,NodePositionZ,'.-');
					end
				end
			end
		else
			ElementNr = BodyElement{BodyNr}.ElementNr;
			BeamType = BodyElement{BodyNr}.BeamType;
			MaterialNr = BodyElement{BodyNr}.MaterialNr;
			PropertiesNr = BodyElement{BodyNr}.PropertiesNr;
			
			BeamNodeNr1 = BodyElement{BodyNr}.BeamNodeNr1;
			BeamNodeNr2 = BodyElement{BodyNr}.BeamNodeNr2;
			
			fprintf(ExchangeFileObj, ...
				'element n = %u type = %s material = %u properties = %u ..\n', ...
				ElementNr,BeamType,MaterialNr,PropertiesNr);
			fprintf(ExchangeFileObj,'node1 = %u node2 = %u\n', ...
				BeamNodeNr1,BeamNodeNr2);
			
			NodePosition1 = ...
				get_Node_Position_BasedOn_NodeIndex(BeamNodeNr1, ...
				FrameNode,BodyNode,NodeIndex);
			NodePosition2 = ...
				get_Node_Position_BasedOn_NodeIndex(BeamNodeNr2, ...
				FrameNode,BodyNode,NodeIndex);
			
			NodePositionX = [NodePosition1(1);NodePosition2(1)];
			NodePositionY = [NodePosition1(2);NodePosition2(2)];
			NodePositionZ = [NodePosition1(3);NodePosition2(3)];
			
			plot3(ElementAxes, ...
				NodePositionX,NodePositionY,NodePositionZ,'.-');
		end
		
	end
	fprintf(ExchangeFileObj,'\n');
end

axis(ElementAxes,SolverParameter.PlotConfiguration.AxesSize)
Azimuth = SolverParameter.PlotConfiguration.Azimuth;
Elevation = SolverParameter.PlotConfiguration.Elevation;
view(ElementAxes,Azimuth,Elevation);

end