function K = getK(O0A,E,A,G,J,Iz,Iy)
KU = O0A*[E*A 0 0;0 G*A 0 ;0 0 G*A]*O0A';
Komega = O0A*[G*J(1) 0 0;0 E*Iy 0; 0 0 E*Iz]*O0A';
K = [KU zeros(3); zeros(3) Komega];
end
