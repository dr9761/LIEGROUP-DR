function NodePosition = get_Node_Position_BasedOn_NodeIndex(NodeIndexNr, ...
	FrameNode,BodyNode,NodeIndex)

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

end