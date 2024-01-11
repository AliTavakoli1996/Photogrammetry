function [EOP]=InitialEOP(xp,yp,f,SlctGCP)
%  EOP =[Omega Phi Kapa X0 Y0 Z0]
EOP(1:2)=0;
for i=1:length(xp)
    A(2*i-1:2*i,1:4)=[xp(i)/1000 yp(i)/1000 1 0;yp(i)/1000 -xp(i)/1000 0 1];
    L(2*i-1:2*i,1)=[SlctGCP(i,2);SlctGCP(i,3)];
end
Delta=(A'*A)\(A'*L);
EOP(3)=-atan2(Delta(2),Delta(1));
EOP(4:5)=Delta(3:4);
EOP(6)=sqrt(Delta(1)^2+Delta(2)^2)*f/1000+mean(SlctGCP(:,4));