% SparseIdentification_EquivalentModel_MassForce
%% Mass
DataQuantity = numel(DataBase);
FunctionOutput = zeros(DataQuantity,1);

MatrixNr = 1;
for DataNr = 1:DataQuantity
	Mass = DataBase{DataNr}.Mass;
	CubicSpline_Mass_Function_Library = ...
		DataBase{DataNr}.CubicSpline_Mass_Function_Library;
	%
	FunctionOutput(DataNr) = Mass(MatrixNr);
	FunctionLibraryUnitQuantity = ...
		size(CubicSpline_Mass_Function_Library,2) / 12;
	%
	FunctionLibrary = zeros(DataQuantity,FunctionLibraryUnitQuantity);
	for FunctionLibraryUnitNr = 1:FunctionLibraryUnitQuantity
		FunctionLibraryUnit = ...
			CubicSpline_Mass_Function_Library(:,12*(FunctionLibraryUnitNr-1)+[1:12]);
		FunctionLibrary(DataNr,FunctionLibraryUnitNr) = FunctionLibraryUnit(MatrixNr);
	end
end
StateDimension = size(FunctionOutput,2);
lambda = 1e-16;
% FunctionOutput = Mass_set;
% FunctionLibrary = CubicSpline_Mass_Function_Library_set;
Xi = sparsifyDynamics(FunctionLibrary,FunctionOutput,lambda,StateDimension);
%
FunctionOutput_Predictive = FunctionLibrary*Xi;
%
IdentificationError = get_Identification_Error(RealValue,PredictiveValue);

Predictive_Error = FunctionOutput_Predictive - FunctionOutput;
Predictive_AbsError = abs(Predictive_Error);
if size(FunctionOutput,2) == 1
	Predictive_SumAbsError = sum(Predictive_AbsError);
	Predictive_AverageAbsError = ...
		Predictive_SumAbsError / numel(FunctionOutput_Predictive);
	Predictive_SumRelError = sum(Predictive_AbsError ./ abs(FunctionOutput));
	Predictive_AverageRelError = Predictive_SumRelError / numel(FunctionOutput_Predictive);
else
	Predictive_SumAbsError = sum(sum(Predictive_AbsError));
	Predictive_AverageAbsError = ...
		Predictive_SumAbsError / numel(FunctionOutput_Predictive);
	Predictive_SumRelError = sum(sum(Predictive_AbsError ./ abs(FunctionOutput)));
	Predictive_AverageRelError = Predictive_SumRelError / numel(FunctionOutput_Predictive);
end
Predictive_AverageAbsError
Predictive_AverageRelError
%% Force
StateDimension = 1;
lambda = 1e-16;
FunctionOutput = Force_set;
FunctionLibrary = CubicSpline_Force_Function_Library_set;
Xi = sparsifyDynamics(FunctionLibrary,FunctionOutput,lambda,StateDimension);
%
FunctionOutput_Predictive = FunctionLibrary*Xi;
%
Predictive_Error = FunctionOutput_Predictive - FunctionOutput;
Predictive_AbsError = abs(Predictive_Error);
if size(FunctionOutput,2) == 1
	Predictive_SumAbsError = sum(Predictive_AbsError);
	Predictive_AverageAbsError = ...
		Predictive_SumAbsError / numel(FunctionOutput_Predictive);
	Predictive_SumRelError = sum(Predictive_AbsError ./ abs(FunctionOutput));
	Predictive_AverageRelError = Predictive_SumRelError / numel(FunctionOutput_Predictive);
else
	Predictive_SumAbsError = sum(sum(Predictive_AbsError));
	Predictive_AverageAbsError = ...
		Predictive_SumAbsError / numel(FunctionOutput_Predictive);
	Predictive_SumRelError = sum(sum(Predictive_AbsError ./ abs(FunctionOutput)));
	Predictive_AverageRelError = Predictive_SumRelError / numel(FunctionOutput_Predictive);
end
Predictive_AverageAbsError
Predictive_AverageRelError