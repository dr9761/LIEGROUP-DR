function IdentificationError = get_Identification_Error(...
	RealValue,PredictiveValue)
%%
Predictive_Error = PredictiveValue - RealValue;
Predictive_AbsError = abs(Predictive_Error);
%%
if size(RealValue,2) == 1
	Predictive_SumAbsError = sum(Predictive_AbsError);
	Predictive_AverageAbsError = ...
		Predictive_SumAbsError / numel(PredictiveValue);
	Predictive_SumRelError = sum(Predictive_AbsError ./ abs(RealValue));
else
	Predictive_SumAbsError = sum(sum(Predictive_AbsError));
	Predictive_AverageAbsError = ...
		Predictive_SumAbsError / numel(PredictiveValue);
	Predictive_SumRelError = sum(sum(Predictive_AbsError ./ abs(RealValue)));
end
%%
Predictive_AverageRelError = Predictive_SumRelError / numel(PredictiveValue);
%%
IdentificationError.AverageAbsError = Predictive_AverageAbsError;
IdentificationError.AverageRelError = Predictive_AverageRelError;

end