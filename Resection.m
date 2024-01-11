function [EOP]=Resection(xp,yp,f,SlctGCP)
EOP=InitialEOP(xp,yp,f,SlctGCP);
syms Omega Phi Kapa xo yo zo x y z
Rx=[1 0 0;0 cos(Omega) sin(Omega);0 -sin(Omega) cos(Omega)];
Ry=[cos(Phi) 0 -sin(Phi);0 1 0;sin(Phi) 0 cos(Phi)];
Rz=[cos(Kapa) sin(Kapa) 0;-sin(Kapa) cos(Kapa) 0;0 0 1];
M=Rx*Ry*Rz;
T=M*[x-xo;y-yo;z-zo];
F(1,1)=-f*(T(1)/T(3));
F(2,1)=-f*(T(2)/T(3));
B=jacobian(F,[Omega Phi Kapa xo yo zo]);
A=zeros(2*length(xp),6);
dL=zeros(2*length(xp),1);
Delta=1;
while norm(Delta)>10^-6
    for i=1:length(xp)
        A(2*i-1:2*i,:)=eval(subs(B,[Omega Phi Kapa xo yo zo x y z],[EOP SlctGCP(i,2:4)]));
        dL(2*i-1,1)=xp(i)-eval(subs(F(1),[Omega Phi Kapa xo yo zo x y z],[EOP SlctGCP(i,2:4)]));
        dL(2*i,1)=yp(i)-eval(subs(F(2),[Omega Phi Kapa xo yo zo x y z],[EOP SlctGCP(i,2:4)]));
    end
    Delta=(A'*A)\(A'*dL);
    EOP=EOP+Delta';
end
