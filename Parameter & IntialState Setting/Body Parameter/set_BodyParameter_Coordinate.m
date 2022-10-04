function [BodyElementParameter,TotalCoordinateNr] = ...
	set_BodyParameter_Coordinate(...
	BodyType,TotalCoordinateNr,BodyElementParameter)

switch BodyType
	case 'Rigid Body'
		DoF = 6;
		
		Coordinate.r = TotalCoordinateNr + [1:3];
		Coordinate.phi = TotalCoordinateNr + [4:6];
		
		CoordinateBase.r = [];
		CoordinateBase.phi = [];
		
		GlobalCoordinate = [Coordinate.r,Coordinate.phi];
		
		TotalCoordinateNr = TotalCoordinateNr + DoF;
	case 'Timoshenko Beam'
		DoF = 12;
		
		Coordinate.r1 = TotalCoordinateNr + [1:3];
		Coordinate.phi1 = TotalCoordinateNr + [4:6];
		Coordinate.r2 = TotalCoordinateNr + [7:9];
		Coordinate.phi2 = TotalCoordinateNr + [10:12];
		
		CoordinateBase.r1 = [];
		CoordinateBase.phi1 = [];
		CoordinateBase.r2 = [];
		CoordinateBase.phi2 = [];
		
		GlobalCoordinate = [...
			Coordinate.r1,Coordinate.phi1, ...
			Coordinate.r2,Coordinate.phi2];
		
		TotalCoordinateNr = TotalCoordinateNr + DoF;
	case 'Super Truss Element'
		DoF = 12;
		
		Coordinate.r1 = TotalCoordinateNr + [1:3];
		Coordinate.phi1 = TotalCoordinateNr + [4:6];
		Coordinate.r2 = TotalCoordinateNr + [7:9];
		Coordinate.phi2 = TotalCoordinateNr + [10:12];
		
		CoordinateBase.r1 = [];
		CoordinateBase.phi1 = [];
		CoordinateBase.r2 = [];
		CoordinateBase.phi2 = [];
		
		GlobalCoordinate = [...
			Coordinate.r1,Coordinate.phi1, ...
			Coordinate.r2,Coordinate.phi2];
		
		TotalCoordinateNr = TotalCoordinateNr + DoF;
	case 'Strut Tie Model'
		DoF = 6;
		
		Coordinate.r1 = TotalCoordinateNr + [1:3];
		Coordinate.r2 = TotalCoordinateNr + [4:6];
		
		CoordinateBase.r1 = [];
		CoordinateBase.r2 = [];
		
		GlobalCoordinate = [Coordinate.r1,Coordinate.r2];
		
		TotalCoordinateNr = TotalCoordinateNr + DoF;
	case 'Strut Tie Rope Model'
		DoF = 6;
		
		Coordinate.r1 = TotalCoordinateNr + [1:3];
		Coordinate.r2 = TotalCoordinateNr + [4:6];
		
		CoordinateBase.r1 = [];
		CoordinateBase.r2 = [];
		
		GlobalCoordinate = [Coordinate.r1,Coordinate.r2];
		
		TotalCoordinateNr = TotalCoordinateNr + DoF;
	case 'Cubic Spline Beam'
		DoF = 14;
		
		Coordinate.r1 = TotalCoordinateNr + [1:3];
		Coordinate.phi1 = TotalCoordinateNr + [4:6];
		Coordinate.norm_drdx1 = TotalCoordinateNr + 7;
		Coordinate.r2 = TotalCoordinateNr + [8:10];
		Coordinate.phi2 = TotalCoordinateNr + [11:13];
		Coordinate.norm_drdx2 = TotalCoordinateNr + 14;
		
		CoordinateBase.r1 = [];
		CoordinateBase.phi1 = [];
		CoordinateBase.norm_drdx1 = [];
		CoordinateBase.r2 = [];
		CoordinateBase.phi2 = [];
		CoordinateBase.norm_drdx2 = [];
		
		GlobalCoordinate = [...
			Coordinate.r1,Coordinate.phi1,Coordinate.norm_drdx1, ...
			Coordinate.r2,Coordinate.phi2,Coordinate.norm_drdx2];
		
		TotalCoordinateNr = TotalCoordinateNr + DoF;
	case 'Cubic Spline Rope'
		DoF = 14;
		
		Coordinate.r1 = TotalCoordinateNr + [1:3];
		Coordinate.phi1 = TotalCoordinateNr + [4:6];
		Coordinate.norm_drdx1 = TotalCoordinateNr + 7;
		Coordinate.r2 = TotalCoordinateNr + [8:10];
		Coordinate.phi2 = TotalCoordinateNr + [11:13];
		Coordinate.norm_drdx2 = TotalCoordinateNr + 14;
		
		CoordinateBase.r1 = [];
		CoordinateBase.phi1 = [];
		CoordinateBase.norm_drdx1 = [];
		CoordinateBase.r2 = [];
		CoordinateBase.phi2 = [];
		CoordinateBase.norm_drdx2 = [];
		
		GlobalCoordinate = [...
			Coordinate.r1,Coordinate.phi1,Coordinate.norm_drdx1, ...
			Coordinate.r2,Coordinate.phi2,Coordinate.norm_drdx2];
		
		TotalCoordinateNr = TotalCoordinateNr + DoF;
	otherwise
	
end
% BodyElementParameter{BodyNr}.Coordinate = TotalCoordinateNr + [1:DoF];
BodyElementParameter{BodyNr}.Coordinate = Coordinate;
BodyElementParameter{BodyNr}.CoordinateBase = CoordinateBase;
BodyElementParameter{BodyNr}.GlobalCoordinate = GlobalCoordinate;
% TotalCoordinateNr = TotalCoordinateNr + DoF;

end