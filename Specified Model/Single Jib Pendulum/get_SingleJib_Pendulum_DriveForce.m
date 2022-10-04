function DriveForce = get_SingleJib_Pendulum_DriveForce(u,Tb)
DriveForce = zeros(3,1);
%% Torsion
T1 = Tb{1};
Tphi1 = T1(4:6,:);

Mt = [0;0;u];
DriveForce = DriveForce + Tphi1'*Mt;
%%
DriveForce = -DriveForce;
end