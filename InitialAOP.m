function AOP=InitialAOP(Input)
% AOP =[Landa Omega Phi Kapa Xo Yo Zo]
A=zeros(2*size(Input,1),4);
L=zeros(2*size(Input,1),1);
for i=1:size(Input,1)
    A(2*i-1:2*i,:)=[Input(i,5) Input(i,6) 1 0;Input(i,6) -Input(i,5) 0 1];
    L(2*i-1:2*i,1)=Input(i,2:3)';
end
Delta=(A'*A)\(A'*L);
AOP(1)=sqrt(Delta(1)^2+Delta(2)^2);
AOP(4)=atan2(Delta(2),Delta(1));
AOP(5:6)=Delta(3:4);
AOP(7)=mean(Input(:,4)-AOP(1)*Input(:,7));
