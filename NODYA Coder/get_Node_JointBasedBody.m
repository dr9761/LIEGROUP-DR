function [BodyNode,BodyNodeNr,NodeIndex,SystemNodeQuantity] = ...
	get_Node_JointBasedBody(Body,BodyNr, ...
	BodyNode,BodyNodeNr,NodeIndex,SystemNodeQuantity)
%%
if BodyNr == 0
	Joint = Body.Joint;
else
	Joint = Body{BodyNr}.Joint;
end
JointQuantity = numel(Joint);
Node = cell(JointQuantity,1);
NodeNr = cell(JointQuantity,1);
for JointNr = 1:JointQuantity
	Node{JointNr} = Joint{JointNr}.r;
	NodeNr{JointNr} = SystemNodeQuantity + 1;
	NodeIndex{SystemNodeQuantity+1} = [BodyNr,JointNr,NaN];
	SystemNodeQuantity = SystemNodeQuantity + 1;
end
%%
if BodyNr == 0
	BodyNode = Node;
	BodyNodeNr = NodeNr;
else
	BodyNode{BodyNr} = Node;
	BodyNodeNr{BodyNr} = NodeNr;
end
end