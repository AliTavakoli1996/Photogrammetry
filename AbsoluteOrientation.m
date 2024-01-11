function [AOP]=AbsoluteOrientation(Input)
AOP=InitialAOP(Input);
syms Landa Omega Phi Kapa Xo Yo Zo x y z
Rx=[1 0 0;0 cos(Omega) sin(Omega);0 -sin(Omega) cos(Omega)];
Ry=[cos(Phi) 0 -sin(Phi);0 1 0;sin(Phi) 0 cos(Phi)];
Rz=[cos(Kapa) sin(Kapa) 0;-sin(Kapa) cos(Kapa) 0;0 0 1];
R=Rx*Ry*Rz;
XYZ=Landa*R*[x;y;z]+[Xo;Yo;Zo];
B=jacobian(XYZ,[Landa Omega Phi Kapa Xo Yo Zo]);

A=zeros(3*size(Input,1),7);
dL=zeros(3*size(Input,1),1);
Delta=1;
while norm(Delta)>10^-7
    for i=1:size(Input,1)
        A(3*i-2:3*i,:)=eval(subs(B,[Landa Omega Phi Kapa Xo Yo Zo x y z],[AOP Input(i,5:7)]));
        dL(3*i-2:3*i,1)=Input(i,2:4)'-eval(subs(XYZ,[Landa Omega Phi Kapa Xo Yo Zo x y z],[AOP Input(i,5:7)]));
    end
    Delta=(A'*A)\(A'*dL);
    AOP=AOP+Delta';
end

