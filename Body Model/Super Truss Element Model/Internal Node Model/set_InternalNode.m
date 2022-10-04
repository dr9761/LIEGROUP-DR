function [InternalNode] = set_InternalNode(TrussOrder, ...
	MainBeamParameter,CrossSectionNode,PlaneParameter)

% for MainBeamNr = 1:numel(MainBeamParameter.Beam)
%
% 	[InternalNode.MainBeam{MainBeamNr}] = ...
% 		get_InternalNode_of_one_MainBeam(...
% 		CrossSectionNode,MainBeamNr, ...
% 		TrussOrder,MainBeamParameter,PlaneParameter);
% end
%%
PlaneQuantity = numel(PlaneParameter.Plane);
MainBeamQuantity = numel(MainBeamParameter.Beam);
for PlaneNr = 1:PlaneQuantity
	InternalNode.Plane{PlaneNr}.r0i = cell(MainBeamQuantity,TrussOrder+1);
	InternalNode.Plane{PlaneNr}.Ri = cell(MainBeamQuantity,TrussOrder+1);
	InternalNode.Plane{PlaneNr}.dqi = cell(MainBeamQuantity,TrussOrder+1);
	InternalNode.Plane{PlaneNr}.Ti = cell(MainBeamQuantity,TrussOrder+1);
	InternalNode.Plane{PlaneNr}.dTi = cell(MainBeamQuantity,TrussOrder+1);
	%%
	for MainBeamNr = PlaneParameter.Plane{PlaneNr}
		%%
		CrossSectionNodeNr1 = MainBeamParameter.Beam{MainBeamNr}(1);
		CrossSectionNodeNr2 = MainBeamParameter.Beam{MainBeamNr}(2);
		Body_Parameter = MainBeamParameter.BodyParameter{MainBeamNr};
		phiMB = MainBeamParameter.Rotation{MainBeamNr,PlaneNr};
		RMB = get_R(phiMB);
		%% qiend
		qcs1 = CrossSectionNode.CrossSection{1}.qs{CrossSectionNodeNr1};
		qcs2 = CrossSectionNode.CrossSection{2}.qs{CrossSectionNodeNr2};
		
		phics1 = qcs1(4:6);
		phics2 = qcs2(4:6);
		Rcs1 = get_R(phics1);
		Rcs2 = get_R(phics2);
		
		ri1 = qcs1(1:3);
		ri2 = qcs2(1:3);
% 		phii1 = get_Rotation_from_R(Rcs1*RMB,phics1);
% 		phii2 = get_Rotation_from_R(Rcs2*RMB,phii1);
		Ri1 = Rcs1*RMB;
		Ri2 = Rcs2*RMB;
		
% 		qi1 = [ri1;phii1];
% 		qi2 = [ri2;phii2];
% 		qiend = [qi1;qi2];
		
		r0iend = [ri1;ri2];
		Riend = [Ri1;Ri2];
		%% Tiend
		T_is_cs = [eye(3),zeros(3);zeros(3),RMB'];
		Tcs1 = CrossSectionNode.CrossSection{1}.Ts{CrossSectionNodeNr1};
		Tcs2 = CrossSectionNode.CrossSection{2}.Ts{CrossSectionNodeNr2};
		
		Ti1 = T_is_cs * Tcs1;
		Ti2 = T_is_cs * Tcs2;
		
		Tiend = [Ti1;Ti2];
		%% dqiend
		dqcs1 = CrossSectionNode.CrossSection{1}.dqs{CrossSectionNodeNr1};
		dqcs2 = CrossSectionNode.CrossSection{2}.dqs{CrossSectionNodeNr2};
		
		dqi1 = T_is_cs * dqcs1;
		dqi2 = T_is_cs * dqcs2;
		
		dqiend  = [dqi1;dqi2];
		%% dTienddt
		dTienddt = zeros(size(Tiend));
		%%
		for IntenalNodeNr = 0:TrussOrder
			xi = IntenalNodeNr / TrussOrder;
			[r0i,Ri,dqi,Ti,dTi] = get_InternalNode(r0iend,Riend,dqiend, ...
				Tiend,dTienddt, ...
				xi,Body_Parameter);
			
% 			InternalNode.Plane{PlaneNr}.qi{MainBeamNr,IntenalNodeNr+1} = qi;
			InternalNode.Plane{PlaneNr}.r0i{MainBeamNr,IntenalNodeNr+1} = r0i;
			InternalNode.Plane{PlaneNr}.Ri{MainBeamNr,IntenalNodeNr+1} = Ri;
			InternalNode.Plane{PlaneNr}.dqi{MainBeamNr,IntenalNodeNr+1} = dqi;
			InternalNode.Plane{PlaneNr}.Ti{MainBeamNr,IntenalNodeNr+1} = Ti;
			InternalNode.Plane{PlaneNr}.dTi{MainBeamNr,IntenalNodeNr+1} = dTi;
		end
	end
end
end