function [q0,dq0,x,ModelParameter] = ModelPreProcessing(PreProcessingMethode, ...
	t,x,tspan,ModelParameter)
%%
switch PreProcessingMethode
	case 'None'
		q0  = zeros(6,1);
		dq0 = zeros(6,1);
	case 'Cantilever Pendulum Frame Motion'
		s0 = -pi/2;
		t0 = tspan(2) - tspan(1);
		t1 = 0.1 * t0;
		t3 = 0.1 * t0;
		[s,v,a] = ThreeStage_PolyFunc_2(t,s0,t0,t1,t3);
		q0  = zeros(6,1);
		q0(5) = s;
		dq0 = zeros(6,1);
		dq0(5) = v;
	case 'Lattice Boom Crane'
		BodyElementParameter = ModelParameter.BodyElementParameter;
		%
		BodyElementParameter{13}.L = BodyElementParameter{13}.L + ...
			ThreeStage_PolyFunc_2(t,5,100,20,20);
		BodyElementParameter{13}.m = ...
			BodyElementParameter{13}.L * pi * BodyElementParameter{13}.ra^2;
		
		BodyElementParameter{15}.L = BodyElementParameter{15}.L - ...
			ThreeStage_PolyFunc_2(t,25,100,20,20);
		BodyElementParameter{15}.m = ...
			BodyElementParameter{15}.L * pi * BodyElementParameter{15}.ra^2;
		%
		ModelParameter.BodyElementParameter = BodyElementParameter;
		q0  = zeros(6,1);
		dq0 = zeros(6,1);
	case 'Lattice Boom Crane Control'
		BodyElementParameter = ModelParameter.BodyElementParameter;
		L13_FitCurve = ModelParameter.PreProcessingData.L13_FitCurve;
		L15_FitCurve = ModelParameter.PreProcessingData.L15_FitCurve;
		
		BodyElementParameter{13}.L = L13_FitCurve(t);
		BodyElementParameter{13}.m = ...
			BodyElementParameter{13}.L * pi * BodyElementParameter{13}.ra^2;
		BodyElementParameter{15}.L = L15_FitCurve(t);
		BodyElementParameter{15}.m = ...
			BodyElementParameter{15}.L * pi * BodyElementParameter{15}.ra^2;
		
		ModelParameter.BodyElementParameter = BodyElementParameter;
		q0  = zeros(6,1);
		dq0 = zeros(6,1);
	otherwise
		q0  = zeros(6,1);
		dq0 = zeros(6,1);
end


end