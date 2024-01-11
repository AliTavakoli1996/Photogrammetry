function [AOP]=AbsoluteOrientationM43(Input)

%AOP =[Landa Omega Phi Kapa Xo Yo Zo]
for i=1:size(Input,1)
    xmodel(i,1)=Input(i,5);
    ymodel(i,1)=Input(i,6);
    zmodel(i,1)=Input(i,7);
end
Delta=1;
%while norm(Delta)>10^-7%Delta
    %M4
    %AOP =[Landa 0 0 Kapa Xo Yo 0]
    A=zeros(2*size(Input,1),4);
    L=zeros(2*size(Input,1),1);
    for i=1:size(Input,1)
        A(2*i-1:2*i,:)=[xmodel(i,1) ymodel(i,1) 1 0;ymodel(i,1) -xmodel(i,1) 0 1];
        L(2*i-1:2*i,1)=[Input(i,2);Input(i,3)];
    end
    Delta1=(A'*A)\(A'*L);
    AOP(1)=sqrt(Delta1(1)^2+Delta1(2)^2)
    AOP(4)=atan2(Delta1(2),Delta1(1))
    AOP(5:6)=Delta1(3:4)
    %EEMAL KARDAN xO ,yO
    
    
    Counter=1;
    for i=1:size(Input,1)
        Xg(Counter)=Delta1(1)*xmodel(i,1)+Delta1(2)*ymodel(i,1)+Delta1(3)
        
        Yg(Counter)=Delta1(1)*ymodel(i,1)-Delta1(2)*xmodel(i,1)+Delta1(4)
        Zg(Counter)=AOP(1)*zmodel(i,1)
        Counter=Counter+1;
    end
  

    %M3
    %AOP =[0 Omega Phi 0 0 0 Zo]
    A=zeros(size(Input,1),3);
    L=zeros(size(Input,1),1);
    for i=1:size(Input,1)
        A(i,:)=[Yg(i) -Xg(i) 1];
        L(i,1)=Input(i,4)- Zg(i);
    end
    Delta=inv(A'*A)*A'*L;
    AOP(2:3)=Delta(1:2)
    AOP(7)=Delta(3)
    for i=1:size(Input,1)
        
        A(3*i-2:3*i,:)=[0 Zg(i) 0;-Zg(i) 0 0;Yg(i) -Xg(i) 1];
    end
    M=A*Delta;
    for i=1:size(Input,1)
        xmodel(i)=M(i)+Xg(i);
        ymodel(i)=M(i)+Yg(i);
        zmodel(i)=M(i)+Zg(i);
        
    end
    
% Rx=[1 0 0;0 cos(AOP(2)) sin(AOP(2));0 -sin(AOP(2)) cos(AOP(2))];
% Ry=[cos(AOP(3)) 0 -sin(AOP(3));0 1 0;sin(AOP(3)) 0 cos(AOP(3))];
% Rz=[cos(AOP(4)) sin(AOP(4)) 0;-sin(AOP(4)) cos(AOP(4)) 0;0 0 1];
% R=Rx*Ry*Rz;
% for i=1:size(InputAO,1)
%     XYZ=AOP(1)*R*InputAO(i,5:7)'+AOP(5:7)';
%     ComputedXYZ(i,:)=XYZ';
% end
% Error=InputAO(:,2:4)-ComputedXYZ