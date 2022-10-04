function TUomegaminus = TUomegaminus(a,b)
alpha = get_alpha(b);
beta = get_beta(b);
skewab = skew(a)*skew(b)+skew(b)*skew(a);
TUomegaminus = 0.5*skew(a) + (beta-alpha)/(beta*dot(b,b))*skewab + ...
    (1+alpha-2*beta)/(beta*dot(b,b)^2)*(b'*a)*skew(b)^2;
end