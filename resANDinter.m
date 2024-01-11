clc
clear all
close all
%%
[file adrs]=uigetfile('*img','select image point file:');
D=textread([adrs file],'%f');
[file adrs]=uigetfile('*ctr','select image point file:');
P=textread([adrs file],'%f');

%fasele kanoni
prompt = {'Enter Focal Length:'};
dlg_title = 'Input';
num_lines = 1;
def = {'153.167'};
f = str2double(inputdlg(prompt,dlg_title,num_lines,def));

index=(D==-99);
[max maxpos]=max(index);
im1=D(1:maxpos-1);
im2=D(maxpos+1:end);
size(im1,1)/3;
for i=1:size(im1,1)/3
    img1(i,:)=im1(3*i-1:3*i+1);
end
size(im2,1)/3;
for i=1:size(im2,1)/3
    img2(i,:)=im2(3*i-1:3*i+1);
end
size(P,1)/4;
for i=1:size(P,1)/4;
    control(i,:)=P(4*i-3:4*i);
end
counter=1;
for i=1:size(P,1)/4;
    if control(i,4)<1
        Plncontrol(counter,:)=control(i,:);
        counter=counter+1;
    end
end
counter=1;
for i=1:size(P,1)/4;
    if control(i,2:3)<1
        Altcontrol(counter,:)=control(i,:);
        counter=counter+1;
    end
end
image1=img1;
image2=img2;
for i=1:size(Plncontrol,1);
    for j=1:size(image1,1);
        if image1(j,1)==Plncontrol(i,1)
            image1(j,:)=0;
        end
    end
end
for i=1:size(Altcontrol,1);
    for j=1:size(image2,1);
        if image2(j,1)==Altcontrol(i,1)
            image2(j,:)=0;
        end
    end
end

if size(image2,1)>size(image1,1)
    a=image2;
    b=image1;
else
    a=image1;
    b=image2;
end
%a>b
j=1;
for i=1:size(a,1)
    if a(i,1)~=0
        tieA(j,:)=a(i,:);
        j=j+1;
    end 
end
        
j=1;
for i=1:size(b,1)
    if b(i,1)~=0
        tieB(j,:)=b(i,:);
        j=j+1;
    end 
end
    
c=ismember(tieA(:,1),tieB(:,1));
TieA=tieA(find(c),:);
d=ismember(tieB(:,1),tieA(:,1));
TieB=tieB(find(d),:);
%
counter=1;
j=1;
for i=1:size(P,1)/4;
    if control(i,1)==img1(j,:)
        xp(:,i)=img1(j,2);
        yp(:,i)=img1(j,3);
        counter=counter+1;
        j=j+1;
    end
end
[EOP]=Resection(xp,yp,f,SlctGCP)
