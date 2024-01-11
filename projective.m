function [result]=projective(IMP,FMP);
A=zeros(2*size(IMP,1),8);
L=zeros(2*size(IMP,1),1);
for i=1:size(IMP,1)
    A(2*i-1,:)=[IMP(i,:) 1 0 0 0 -(IMP(i,1))*(FMP(i,2)) -(IMP(i,2))*(FMP(i,2))];
    A(2*i,:)=[0 0 0 IMP(i,:) 1 -(IMP(i,1))*(FMP(i,3)) -(IMP(i,2))*(FMP(i,3))];
    L(2*i-1,1)=FMP(i,2)
    L(2*i,1)=FMP(i,3)
end
result=inv(A'*A)*A'*L;
