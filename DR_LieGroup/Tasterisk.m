function Tasterisk = Tasterisk(s,d,L)
Tasterisk = s/L*TSE3(s*d/L).*TSE3invers(d);
end