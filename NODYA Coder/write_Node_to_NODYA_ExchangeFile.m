function write_Node_to_NODYA_ExchangeFile(FrameNode,BodyNode,NodeIndex, ...
	SolverParameter,ExchangeFileObj,NodeAxes)
%%
fprintf(ExchangeFileObj,'! Node\n');
%%
for NodeIndexNr = 1:numel(NodeIndex)
	if ~isempty(NodeIndex{NodeIndexNr})
		if ismissing(NodeIndex{NodeIndexNr}(3))
			NodeNr_BodyNr = NodeIndex{NodeIndexNr}(1);
			NodeNr_JointNr = NodeIndex{NodeIndexNr}(2);
			if NodeNr_BodyNr == 0
				NodePosition = ...
					FrameNode{NodeNr_JointNr};
			else
				NodePosition = ...
					BodyNode{NodeNr_BodyNr}{NodeNr_JointNr};
			end
		elseif ~ismissing(NodeIndex{NodeIndexNr}(3))
			NodeNr_BodyNr = NodeIndex{NodeIndexNr}(1);
			NodeNr_MainBeamNr = NodeIndex{NodeIndexNr}(2);
			NodeNr_InternalNodeNr = NodeIndex{NodeIndexNr}(3);
			
			NodePosition = ...
				BodyNode{NodeNr_BodyNr}{NodeNr_MainBeamNr,NodeNr_InternalNodeNr};
			
		end
		NodePositionX = NodePosition(1);
		NodePositionY = NodePosition(2);
		NodePositionZ = NodePosition(3);
		
		TypeName = 'standard';
		fprintf(ExchangeFileObj,'node %u type = %s %f %f %f\n',...
			NodeIndexNr,TypeName,NodePositionX,NodePositionY,NodePositionZ);
		
		plot3(NodeAxes,NodePositionX,NodePositionY,NodePositionZ,'*');
	end
end
%%
axis(NodeAxes,SolverParameter.PlotConfiguration.AxesSize)
Azimuth = SolverParameter.PlotConfiguration.Azimuth;
Elevation = SolverParameter.PlotConfiguration.Elevation;
view(NodeAxes,Azimuth,Elevation);
end