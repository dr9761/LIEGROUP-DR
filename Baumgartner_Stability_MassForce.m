function [SystemMass,SystemForce,lambda] = ...
	Baumgartner_Stability_MassForce(...
	Mass,Force, ...
	Phi,dPhi,B,Tau)
%%
alpha = 100;
beta = 1;
%%
% lambda = (B' * inv(Mass) * B) \ ...
% 	(-B'*inv(Mass)*Force + ...
% 	Tau + 2*alpha*beta*dPhi + alpha^2*Phi);
% 
% SystemMass = Mass;
% SystemForce = Force + B*lambda;

if ~isempty(B)
	lambda = (B' * inv(Mass) * B) \ ...
		(-B'*inv(Mass)*Force + ...
		Tau + 2*alpha*beta*dPhi + alpha^2*Phi);
	
	SystemMass = Mass;
	SystemForce = Force + B*lambda;
else
	lambda = [];
	SystemMass = Mass;
	SystemForce = Force;
end
%%
% ddq = -SystemMass \ SystemForce;
end