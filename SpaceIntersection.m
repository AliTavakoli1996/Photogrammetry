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
    EOP{i}=load([Adrs 'EOP_' File(1:end-4) '.txt']);
end
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
    [XYZ]=Intersection(xp1,yp1,xp2,yp2,f,EOP{1},EOP{2});
    Ans=menu('Are you wnat to continue?','Yes','No');
    Final(:,Counter)=XYZ;
Counter=Counter+1;
    clf
end
