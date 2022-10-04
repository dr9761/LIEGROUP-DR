function write_Properties_to_NODYA_ExchangeFile(...
	BodyProperties,ExchangeFileObj)
BodyQuantity = numel(BodyProperties);
for BodyNr = 1:BodyQuantity
	fprintf(ExchangeFileObj,'! Properties of Body %u\n',BodyNr);
	BodyType = BodyProperties{BodyNr}.BodyType;
	switch BodyType
		case {'Timoshenko Beam','Cubic Spline Beam'}
			Type = BodyProperties{BodyNr}.Type;
			PropertiesNr = 100 * BodyNr;
			
			if ~strcmpi(Type,'BAR-GENERAL')
				Profile = BodyProperties{BodyNr}.Profile;
				
				H = BodyProperties{BodyNr}.H;
				B1 = BodyProperties{BodyNr}.B1;
				B2 = BodyProperties{BodyNr}.B2;
				T1 = BodyProperties{BodyNr}.T1;
				T2 = BodyProperties{BodyNr}.T2;
				T3 = BodyProperties{BodyNr}.T3;
				
				fprintf(ExchangeFileObj, ...
				'properties n = %u type = %s %s %f %f %f %f %f %f\n', ...
				PropertiesNr,Type,Profile,H,B1,B2,T1,T2,T3);
			else
				
			end
		case {'Strut Tie Model'}
			Type = BodyProperties{BodyNr}.Type;
			Area = BodyProperties{BodyNr}.Area;
			PropertiesNr = 100 * BodyNr;
			
			fprintf(ExchangeFileObj, ...
				'properties n = %u type = %s area = %f\n', ...
				PropertiesNr,Type,Area);
		case {'Strut Tie Rope Model','Cubic Spline Rope'}
			Type = BodyProperties{BodyNr}.Type;
			Area = BodyProperties{BodyNr}.Area;
			PropertiesNr = 100 * BodyNr;
			
			fprintf(ExchangeFileObj, ...
				'properties n = %u type = %s area = %f\n', ...
				PropertiesNr,Type,Area);
		case 'Super Truss Element'
			Type = BodyProperties{BodyNr}.Type;
			if ~strcmpi(Type,'BAR-GENERAL')
				Profile = BodyProperties{BodyNr}.Profile;
				
				H = BodyProperties{BodyNr}.H;
				B1 = BodyProperties{BodyNr}.B1;
				B2 = BodyProperties{BodyNr}.B2;
				T1 = BodyProperties{BodyNr}.T1;
				T2 = BodyProperties{BodyNr}.T2;
				T3 = BodyProperties{BodyNr}.T3;
				
				% Cross Section Beam
				PropertiesNr = 100 * BodyNr + 1;
				fprintf(ExchangeFileObj, ...
					'properties n = %u type = %s %s %f %f %f %f %f %f\n', ...
					PropertiesNr,Type,Profile, ...
					H(1),B1(1),B2(1),T1(1),T2(1),T3(1));
				% Main Beam
				PropertiesNr = 100 * BodyNr + 2;
				fprintf(ExchangeFileObj, ...
					'properties n = %u type = %s %s %f %f %f %f %f %f\n', ...
					PropertiesNr,Type,Profile, ...
					H(2),B1(2),B2(2),T1(2),T2(2),T3(2));
				% Sub Beam
				PropertiesNr = 100 * BodyNr + 3;
				fprintf(ExchangeFileObj, ...
					'properties n = %u type = %s %s %f %f %f %f %f %f\n', ...
					PropertiesNr,Type,Profile, ...
					H(3),B1(3),B2(3),T1(3),T2(3),T3(3));
			else
				
			end
			% Cross Section Beam
			
% 			PropertiesNr = 100 * BodyNr;
			
	end
	fprintf(ExchangeFileObj,'\n');
	
end

end