function [xp,yp]=IOP_Transform(xi,yi,IOP)
switch size(IOP,1)
    case 4
        xp=IOP(1)*xi+IOP(2)*yi+IOP(3);
        yp=yi*IOP(1)-xi*IOP(2)+IOP(4);
    case 6
        xp=IOP(1)*xi+IOP(2)*yi+IOP(3);
        yp=IOP(4)*xi+IOP(5)*yi+IOP(6);
    case 8
        xp=(IOP(1)*xi+IOP(2)*yi+IOP(3))/(IOP(7)*xi+IOP(8)*yi+1);
        yp=(IOP(4)*xi+IOP(5)*yi+IOP(6))/(IOP(7)*xi+IOP(8)*yi+1);
end
