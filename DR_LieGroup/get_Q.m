function Q = get_Q(x,d,BodyParameter)
Q = zeros(6,12);

L  = BodyParameter.L;
Q=[eye(6)-Tasterisk(x,d,L) Tasterisk(x,d,L)];

end