function HA = get_HA(ModelParameter, SolverParameter)
% O0A=[is it iu];
% ytuA=[0 t u]';
Frame_Joint_Parameter = ModelParameter.Frame_Joint_Parameter;
Joint_Parameter = ModelParameter.Joint_Parameter;
q0  = zeros(6,1);
dq0 = zeros(6,1);
Frame.Joint = set_Frame_Joint(q0,dq0,Frame_Joint_Parameter);

FrameJointQuantity = numel(Frame_Joint_Parameter);
FrameJoint = cell(FrameJointQuantity,1);
for FrameJointNr = 1:FrameJointQuantity
	r = Frame_Joint_Parameter{FrameJointNr}.r;
	phi = Frame_Joint_Parameter{FrameJointNr}.phi;
	
	FrameJoint{FrameJointNr} = set_RigidBody_Joint(...
		r,phi,q0,dq0);
end

xsA = Frame_Joint_Parameter{1, 1}.r;
phiA = Frame_Joint_Parameter{1, 1}.phi(1);
O0A=[1 0 0; 0 1 0; 0 0 1];
ytuA=[0 0 0]';
RsA=get_R(phiA);
xpA=[xsA+RsA.*O0A*ytuA];
HA=[RsA xpA;zeros(1,3) 1];

end