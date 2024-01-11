function [Result]=Conformal(IMP,FMP)
A=zeros(2*size(IMP,1),4);
L=zeros(2*size(IMP,1),1);
for i=1:size(IMP,1)
    A(2*i-1,:)=[IMP(i,:) 1 0];
    A(2*i,:)=[IMP(i,2) -IMP(i,1) 0 1];
    L(2*i-1,1)=FMP(i,2);
    L(2*i,1)=FMP(i,3);
end
Result=inv(A'*A)*A'*L;


