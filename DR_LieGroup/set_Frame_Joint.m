function FrameJoint = set_Frame_Joint(qe,dqe, ...
	Frame_Joint_Parameter)
%%
% qe  = zeros(6,1);
% dqe = zeros(6,1);
% phi 3*1 
%%
FrameJointQuantity = numel(Frame_Joint_Parameter);
FrameJoint = cell(FrameJointQuantity,1);
for FrameJointNr = 1:FrameJointQuantity
	r = Frame_Joint_Parameter{FrameJointNr}.r;
	phi = Frame_Joint_Parameter{FrameJointNr}.phi;
    R = getR(phi);
	FrameJoint{FrameJointNr} = set_RigidBody_Joint(...
		R,r,phi,qe,dqe);
end

end