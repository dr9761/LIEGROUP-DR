function [ddq,lambda] = Baumgartner_Stability_Method(Mass,Force, ...
	Phi,dPhi,B,Tau)
%%
alpha = 100;
beta = 1;
%%
if ~isempty(B)
	lambda = (B' * inv(Mass) * B) \ ...
		(-B'*inv(Mass)*Force + ...
		Tau + 2*alpha*beta*dPhi + alpha^2*Phi);
	
	ddq = -Mass \ (Force + B*lambda);
else
	lambda = [];
	ddq = -Mass \ Force;
end
	
end