clc
clear
close all
%% Space Intersection
prompt = {'Enter Focal Length:'};
dlg_title = 'Input';
num_lines = 1;
def = {'153.167'};
f = str2double(inputdlg(prompt,dlg_title,num_lines,def));
for i=1:2
    [File Adrs]=uigetfile('*.jpg',sprintf('Select Image %d  File',i));
    Im{i}=imread([Adrs File]);
    IOP{i}=load([Adrs 'IOP_' File(1:end-4) '.txt']);
    ROP{i}=load([Adrs 'ROP_' File(1:end-4) '.txt']);
end
[File Adrs]=uigetfile('*.txt','Select GCPs File');
MainGCP=load([Adrs File]);
Ans=1
Counter=1;
while Ans==1
    subplot(121)
    imshow(Im{1})
    subplot(122)
    imshow(Im{2})
    subplot(121)
    title('Select in This Image');
    pause
    [y1 x1]=ginput(1)
    subplot(122)
    title('Select in This Image');
    pause
    [y2 x2]=ginput(1)
    [xp1,yp1]=IOP_Transform(x1,y1,IOP{1});
    [xp2,yp2]=IOP_Transform(x2,y2,IOP{2});
    [XYZ]=Intersection(xp1,yp1,xp2,yp2,f,ROP{1},ROP{2});
    prompt = {'Enter ID of GCP'};
    dlg_title = 'Input';
    num_lines = 1;
    def = {' '};
    Code = str2double(inputdlg(prompt,dlg_title,num_lines,def));
    InputAO(Counter,:)=[MainGCP((MainGCP(:,1)==Code),:) XYZ'];
    if Counter>=3
        Ans=menu('Are you wnat to continue?','Yes','No');
    end
    Counter=Counter+1;
    clf
end
% AOP=AbsoluteOrientation(InputAO);
AOP=AbsoluteOrientationM43(InputAO);

% Rx=[1 0 0;0 cos(AOP(2)) sin(AOP(2));0 -sin(AOP(2)) cos(AOP(2))];
% Ry=[cos(AOP(3)) 0 -sin(AOP(3));0 1 0;sin(AOP(3)) 0 cos(AOP(3))];
% Rz=[cos(AOP(4)) sin(AOP(4)) 0;-sin(AOP(4)) cos(AOP(4)) 0;0 0 1];
% R=Rx*Ry*Rz;
% for i=1:size(InputAO,1)
%     XYZ=AOP(1)*R*InputAO(i,5:7)'+AOP(5:7)';
%     ComputedXYZ(i,:)=XYZ';
% end
% Error=InputAO(:,2:4)-ComputedXYZ


