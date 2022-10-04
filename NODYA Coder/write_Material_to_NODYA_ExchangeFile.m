function write_Material_to_NODYA_ExchangeFile(BodyMaterial,ExchangeFileObj)

BodyQuantity = numel(BodyMaterial);
for BodyNr = 1:BodyQuantity
	fprintf(ExchangeFileObj,'! Material of Body %u\n',BodyNr);
	
	if ~isempty(BodyMaterial{BodyNr})
		BodyType = BodyMaterial{BodyNr}.BodyType;
		
		if ~strcmpi(BodyType,'Super Truss Element')

			MaterialNr = BodyMaterial{BodyNr}.MaterialNr;
			Type = BodyMaterial{BodyNr}.Type;
			Density = BodyMaterial{BodyNr}.Density;
			E = BodyMaterial{BodyNr}.E;
			
			fprintf(ExchangeFileObj, ...
				'material n = %u type = %s density = %f E = %f\n', ...
				MaterialNr,Type,Density,E);

		elseif strcmpi(BodyType,'Super Truss Element')
			% Cross Section Beam
			MaterialNr = BodyMaterial{BodyNr}.CrossSectionBeam.MaterialNr;
			Type = BodyMaterial{BodyNr}.CrossSectionBeam.Type;
			Density = BodyMaterial{BodyNr}.CrossSectionBeam.Density;
			E = BodyMaterial{BodyNr}.CrossSectionBeam.E;
			
			fprintf(ExchangeFileObj, ...
				'material n = %u type = %s density = %f E = %f\n', ...
				MaterialNr,Type,Density,E);
			% Main Beam
			MaterialNr = BodyMaterial{BodyNr}.MainBeam.MaterialNr;
			Type = BodyMaterial{BodyNr}.MainBeam.Type;
			Density = BodyMaterial{BodyNr}.MainBeam.Density;
			E = BodyMaterial{BodyNr}.MainBeam.E;
			
			fprintf(ExchangeFileObj, ...
				'material n = %u type = %s density = %f E = %f\n', ...
				MaterialNr,Type,Density,E);
			% Sub Beam
			MaterialNr = BodyMaterial{BodyNr}.SubBeam.MaterialNr;
			Type = BodyMaterial{BodyNr}.SubBeam.Type;
			Density = BodyMaterial{BodyNr}.SubBeam.Density;
			E = BodyMaterial{BodyNr}.SubBeam.E;
			
			fprintf(ExchangeFileObj, ...
				'material n = %u type = %s density = %f E = %f\n', ...
				MaterialNr,Type,Density,E);
		end
		
	end
	
	fprintf(ExchangeFileObj,'\n');
end

end