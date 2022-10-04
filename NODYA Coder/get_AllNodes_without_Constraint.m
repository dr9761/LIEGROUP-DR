function [FrameNode,BodyNode,FrameNodeNr,BodyNodeNr,NodeIndex] = ...
	get_AllNodes_without_Constraint(Frame,Body)

BodyQuantity = numel(Body);
BodyNode = cell(BodyQuantity,1);
BodyNodeNr = cell(BodyQuantity,1);
FrameNodeNr = cell(1,1);
NodeIndex = cell(0);
SystemNodeQuantity = 0;
for BodyNr = 0:BodyQuantity
	if BodyNr == 0
		[FrameNode,FrameNodeNr,NodeIndex,SystemNodeQuantity] = ...
				get_Node_JointBasedBody(Frame,BodyNr, ...
				[],[],NodeIndex,SystemNodeQuantity);
		continue;
	end
	
	BodyType = Body{BodyNr}.BodyType;
	
	switch BodyType
		case {'Rigid Body','Timoshenko Beam', ...
				'Strut Tie Model','Strut Tie Rope Model', ...
				'Cubic Spline Beam','Cubic Spline Rope'}
			[BodyNode,BodyNodeNr,NodeIndex,SystemNodeQuantity] = ...
				get_Node_JointBasedBody(Body,BodyNr, ...
				BodyNode,BodyNodeNr,NodeIndex,SystemNodeQuantity);
% 		case 'Timoshenko Beam'
% 			[BodyNode,BodyNodeNr,NodeIndex,SystemNodeQuantity] = ...
% 				get_Node_JointBasedBody(Body,BodyNr, ...
% 				BodyNode,BodyNodeNr,NodeIndex,SystemNodeQuantity);
		case 'Super Truss Element'
			qe = Body{BodyNr}.qe;
			dqe = Body{BodyNr}.dqe;
			%
			Truss_Parameter = Body{BodyNr}.Truss_Parameter;
			TrussOrder = Truss_Parameter.TrussOrder;
			CrossSectionParameter = Truss_Parameter.CrossSectionParameter;
			MainBeamParameter = Truss_Parameter.MainBeamParameter;
			PlaneParameter = Truss_Parameter.PlaneParameter;
			% CrossSection Node
			[CrossSectionNode] = set_CrossSection_Node(...
				qe,dqe,CrossSectionParameter);
			% Internal Node
			[InternalNode] = set_InternalNode(TrussOrder, ...
				MainBeamParameter,CrossSectionNode,PlaneParameter);
			
			Node = cell(numel(MainBeamParameter.Beam),TrussOrder+1);
			NodeNr = cell(numel(MainBeamParameter.Beam),TrussOrder+1);
			% get_Node_SuperTrussElement
			for CrossSecionNr = 1:2
				CrossSectionNodeQuantity = ...
					numel(CrossSectionNode.CrossSection{CrossSecionNr}.qs);
				
				for CrossSectionNodeNr = 1:CrossSectionNodeQuantity
					if CrossSecionNr == 1
						Node{CrossSectionNodeNr,1} = ...
							CrossSectionNode.CrossSection{CrossSecionNr}.qs{CrossSectionNodeNr}(1:3);
						NodeNr{CrossSectionNodeNr,1} = SystemNodeQuantity + 1;
						NodeIndex{SystemNodeQuantity+1} = ...
							[BodyNr,CrossSectionNodeNr,CrossSecionNr];
					elseif CrossSecionNr == 2
						Node{CrossSectionNodeNr,TrussOrder+1} = ...
							CrossSectionNode.CrossSection{CrossSecionNr}.qs{CrossSectionNodeNr}(1:3);
						NodeNr{CrossSectionNodeNr,TrussOrder+1} = SystemNodeQuantity + 1;
						NodeIndex{SystemNodeQuantity+1} = [BodyNr,CrossSectionNodeNr,TrussOrder+1];
					end
					SystemNodeQuantity = SystemNodeQuantity + 1;
				end
			end
			
			for MainBeamNr = 1:numel(MainBeamParameter.Beam)
				PlaneNr = MainBeamParameter.Plane{MainBeamNr}(1);
				for InternalNodeNr = 2:TrussOrder
					Node{MainBeamNr,InternalNodeNr} = ...
						InternalNode.Plane{PlaneNr}.qi{MainBeamNr,InternalNodeNr}(1:3);
					NodeNr{MainBeamNr,InternalNodeNr} = SystemNodeQuantity + 1;
					NodeIndex{SystemNodeQuantity+1} = [BodyNr,MainBeamNr,InternalNodeNr];
					SystemNodeQuantity = SystemNodeQuantity + 1;
				end
			end
			
			BodyNode{BodyNr} = Node;
			BodyNodeNr{BodyNr} = NodeNr;
% 		case 'Strut Tie Model'
% 			[BodyNode,BodyNodeNr,NodeIndex,SystemNodeQuantity] = ...
% 				get_Node_JointBasedBody(Body,BodyNr, ...
% 				BodyNode,BodyNodeNr,NodeIndex,SystemNodeQuantity);
% 		case 'Strut Tie Rope Model'
% 			[BodyNode,BodyNodeNr,NodeIndex,SystemNodeQuantity] = ...
% 				get_Node_JointBasedBody(Body,BodyNr, ...
% 				BodyNode,BodyNodeNr,NodeIndex,SystemNodeQuantity);
% 		case 'Cubic Spline Beam'
% 			[BodyNode,BodyNodeNr,NodeIndex,SystemNodeQuantity] = ...
% 				get_Node_JointBasedBody(Body,BodyNr, ...
% 				BodyNode,BodyNodeNr,NodeIndex,SystemNodeQuantity);
% 		case 'Cubic Spline Rope'
% 			[BodyNode,BodyNodeNr,NodeIndex,SystemNodeQuantity] = ...
% 				get_Node_JointBasedBody(Body,BodyNr, ...
% 				BodyNode,BodyNodeNr,NodeIndex,SystemNodeQuantity);
		otherwise
			
	end
	
end
NodeIndex = NodeIndex';
end