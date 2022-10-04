function DriveForce = get_TripleJib_Pendulum_DriveForce(u,Tb)
DriveForce = zeros(5,1);
ut = u(1);
u1 = u(2);
u2 = u(3);
%% Torsion
T1 = Tb{1};
Tphi1 = T1(4:6,:);

Mt = [ut;0;0];
DriveForce = DriveForce + Tphi1'*Mt;
%% Moment 1
T2 = Tb{2};
Tphi2 = T2(4:6,:);

M1 = [0;-u1;0];
DriveForce = DriveForce + Tphi2'*M1;
%% Moment 1
T3 = Tb{3};
Tphi3 = T3(4:6,:);

M2 = [0;-u2;0];
DriveForce = DriveForce + Tphi3'*M2;
%%
DriveForce = -DriveForce;
end