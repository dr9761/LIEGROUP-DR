function write_AdditionalRigidLink_to_NODYA_ExchangeFile(...
	Additional_RigidLink,ExchangeFileObj)
%%
ConstraintQuantity = numel(Additional_RigidLink);
for ConstraintNr = 1:ConstraintQuantity
	if ~isempty(Additional_RigidLink{ConstraintNr})
		fprintf(ExchangeFileObj, ...
			'! Constraint Number %u\n',ConstraintNr);
		for RigidLinkNr = 1:numel(Additional_RigidLink{ConstraintNr}.RigidLink)
			
			ElementNr = ...
				Additional_RigidLink{ConstraintNr}.RigidLink{RigidLinkNr}(1);
			Nodec = ...
				Additional_RigidLink{ConstraintNr}.RigidLink{RigidLinkNr}(2);
			Nodei = ...
				Additional_RigidLink{ConstraintNr}.RigidLink{RigidLinkNr}(3);
			
			fprintf(ExchangeFileObj, ...
				'element n = %u type = rigidlink ..\n', ...
				ElementNr);
			fprintf(ExchangeFileObj,'nodec = %u nodei = %u\n', ...
				Nodec,Nodei);
			
		end
		fprintf(ExchangeFileObj,'\n');
	end	
end

end