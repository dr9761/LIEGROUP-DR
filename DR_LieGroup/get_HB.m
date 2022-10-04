function HB = get_HB(ModelParameter, SolverParameter)
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

% xsB = Frame_Joint_Parameter{1, 1}.r;
% phiB = Frame_Joint_Parameter{1, 1}.phi(1);
L = 15;
xsB = [L 0 0]';
phiB = 0;
O0B=[1 0 0; 0 1 0; 0 0 1];
ytuB=[0 0 0]';
RsB=get_R(phiB);
xpB=[xsB+RsB.*O0B*ytuB];
HB=[RsB xpB;zeros(1,3) 1];

end