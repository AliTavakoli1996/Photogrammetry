function [Result]=RelativeOrientation(IMP_L,IMP_R,f)
syms Omega Phi Kapa xo yo zo x y z
Rx=[1 0 0;0 cos(Omega) sin(Omega);0 -sin(Omega) cos(Omega)];
Ry=[cos(Phi) 0 -sin(Phi);0 1 0;sin(Phi) 0 cos(Phi)];
Rz=[cos(Kapa) sin(Kapa) 0;-sin(Kapa) cos(Kapa) 0;0 0 1];
M=Rx*Ry*Rz;
T=M*[x-xo;y-yo;z-zo];
F(1,1)=-f*(T(1)/T(3));
F(2,1)=-f*(T(2)/T(3));
B_ROP=jacobian(F,[Omega Phi Kapa yo zo]);
B_model=jacobian(F,[x y z]);
%%
%        Omega Phi Kapa xo                      yo zo
Lft_Par=[0      0   0    0                      0  f];
Rht_Par=[0      0   0    IMP_L(1,1)-IMP_R(1,1)  0  f];
xyz_model=[IMP_L zeros(size(IMP_L,1),1)];

A=zeros(4*size(IMP_L,1),5+3*size(xyz_model,1));
dL=zeros(4*size(IMP_L,1),1);
Delta=1;
while norm(Delta)>10^-7
    for i=1:size(IMP_L,1)
        A(2*size(IMP_L,1)+2*i-1:2*size(IMP_L,1)+2*i,1:5)=eval(subs(B_ROP,[Omega Phi Kapa xo yo zo x y z],[Rht_Par xyz_model(i,:)]));
        A(2*i-1:2*i,5+3*i-2:5+3*i)=eval(subs(B_model,[Omega Phi Kapa xo yo zo x y z],[Lft_Par xyz_model(i,:)]));
        A(2*size(IMP_L,1)+2*i-1:2*size(IMP_L,1)+2*i,5+3*i-2:5+3*i)=eval(subs(B_model,[Omega Phi Kapa xo yo zo x y z],[Rht_Par xyz_model(i,:)]));
        dL(2*i-1:2*i,1)=[IMP_L(i,1);IMP_L(i,2)]-eval(subs(F,[Omega Phi Kapa xo yo zo x y z],[Lft_Par xyz_model(i,:)]));
        dL(2*size(IMP_L,1)+2*i-1:2*size(IMP_L,1)+2*i,1)=[IMP_R(i,1);IMP_R(i,2)]-eval(subs(F,[Omega Phi Kapa xo yo zo x y z],[Rht_Par xyz_model(i,:)]));
    end
    Delta=(A'*A)\(A'*dL)
    Rht_Par(1:3)=Rht_Par(1:3)+Delta(1:3)';
    Rht_Par(5:6)=Rht_Par(5:6)+Delta(4:5)';
    for i=1:size(IMP_L,1)
        xyz_model(i,:)=xyz_model(i,:)+Delta(5+3*i-2:5+3*i)';
    end
end
Result=[Lft_Par;Rht_Par];







