function Rskew =  Rskew(R)
%%
Rskew = zeros(9,3);
Rskew(1:3,1:3) = skew(R(1:3));
Rskew(4:6,1:3) = skew(R(4:6));
Rskew(7:9,1:3) = skew(R(7:9));


end