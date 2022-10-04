function [InternalNode] = get_InternalNode_of_one_MainBeam(...
	CrossSectionNode,MainBeamNr, ...
	TrussOrder,MainBeamParameter,PlaneParameter)
%%
PlaneQuantity = numel(PlaneParameter.Plane);
MainBeamQuantity = numel(MainBeamParameter.Beam);
for PlaneNr = 1:PlaneQuantity
	% PlaneNr = 1;
	InternalNode.Plane{PlaneNr}.qi = cell(MainBeamQuantity,TrussOrder+1);
	InternalNode.Plane{PlaneNr}.dqi = cell(MainBeamQuantity,TrussOrder+1);
	InternalNode.Plane{PlaneNr}.Ti = cell(MainBeamQuantity,TrussOrder+1);
	InternalNode.Plane{PlaneNr}.dTi = cell(MainBeamQuantity,TrussOrder+1);
	%%
	for MainBeamNr = PlaneParameter.Plane{PlaneNr}
		% MainBeamNr = PlaneParameter.Plane{PlaneNr}(1);
		%%
		CrossSectionNodeNr1 = MainBeamParameter.Beam{MainBeamNr}(1);
		CrossSectionNodeNr2 = MainBeamParameter.Beam{MainBeamNr}(2);
		Body_Parameter = MainBeamParameter.BodyParameter{MainBeamNr};
		phiMB = MainBeamParameter.Rotation{MainBeamNr,PlaneNr};
		RMB = get_R(phiMB);
		%%
		qcs1 = CrossSectionNode.CrossSection{1}.qs{CrossSectionNodeNr1};
		qcs2 = CrossSectionNode.CrossSection{2}.qs{CrossSectionNodeNr2};
		
		phics1 = qcs1(4:6);
		phics2 = qcs2(4:6);
		Rcs1 = get_R(phics1);
		Rcs2 = get_R(phics2);
		
		ri1 = qcs1(1:3);
		ri2 = qcs2(1:3);
		phii1 = get_Rotation_from_R(Rcs1*RMB,phics1);
		phii2 = get_Rotation_from_R(Rcs2*RMB,phii1);
		
		qi1 = [ri1;phii1];
		qi2 = [ri2;phii2];
		qiend = [qi1;qi2];
		%%
		T_is_cs = [eye(3),zeros(3);zeros(3),RMB'];
		Tcs1 = CrossSectionNode.CrossSection{1}.Ts{CrossSectionNodeNr1};
		Tcs2 = CrossSectionNode.CrossSection{2}.Ts{CrossSectionNodeNr2};
		
		Ti1 = T_is_cs * Tcs1;
		Ti2 = T_is_cs * Tcs2;
		
		Tiend = [Ti1;Ti2];
		%%
		% dqiend = Tiend * dqe;
		dqcs1 = CrossSectionNode.CrossSection{1}.dqs{CrossSectionNodeNr1};
		dqcs2 = CrossSectionNode.CrossSection{2}.dqs{CrossSectionNodeNr2};
		
		dqi1 = T_is_cs * dqcs1;
		dqi2 = T_is_cs * dqcs2;
		
		dqiend  = [dqi1;dqi2];
		%%
		dTienddt = zeros(size(Tiend));
		%%
		
		for IntenalNodeNr = 0:TrussOrder
			xi = IntenalNodeNr / TrussOrder;
			[qi,dqi,Ti,dTi] = get_InternalNode(qiend,dqiend,Tiend,dTienddt, ...
				xi,Body_Parameter);
			
			InternalNode.Plane{PlaneNr}.qi{MainBeamNr,IntenalNodeNr+1} = qi;
			InternalNode.Plane{PlaneNr}.dqi{MainBeamNr,IntenalNodeNr+1} = dqi;
			InternalNode.Plane{PlaneNr}.Ti{MainBeamNr,IntenalNodeNr+1} = Ti;
			InternalNode.Plane{PlaneNr}.dTi{MainBeamNr,IntenalNodeNr+1} = dTi;
			
			% 	InternalNode_MainBeam.qi{IntenalNodeNr+1}  = qi;
			% 	InternalNode_MainBeam.dqi{IntenalNodeNr+1} = dqi;
			% 	InternalNode_MainBeam.Ti{IntenalNodeNr+1}  = Ti;
			% 	InternalNode_MainBeam.dTi{IntenalNodeNr+1} = dTi;
		end
	end
end
end