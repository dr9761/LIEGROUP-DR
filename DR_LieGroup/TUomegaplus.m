function TUomegaplus = TUomegaplus(a,b)
alpha = get_alpha(b);
beta = get_beta(b);
skewab = skew(a)*skew(b)+skew(b)*skew(a);
TUomegaplus = -beta/2*skew(a) + (1-alpha)/dot(b,b)*skewab + ...
    b'*a/dot(b,b)*((beta-alpha)*skew(b)+(beta/2 - 3*(1-alpha)/dot(b,b))*skew(b)^2);
end