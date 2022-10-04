function M = M(Q,MC,x,w)
MC = [m/L*eye(3) 0; 0 -O0A*J*O0A' ];
M = int(Q'*MC*Q,s,0,L);
end