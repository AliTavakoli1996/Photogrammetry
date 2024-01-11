clc
clear all
close all
format long g
%%
% reading right image and loading file
[file1 adrs]=uigetfile('*.jpg','select your right image');
pic1=imread([adrs file1]);
[file adrs]=uigetfile('*.txt','select your calibration file');
calibration=load([adrs file]);
answer=1;
counter=1;
%namayesh aks va andazegiri fidooshelmark
while  answer==1
    imshow(pic1);
    Txt=sprintf('x= %f y=%f',calibration(counter,2),calibration(counter,3));
    title(Txt);
    pause
    [y x]=ginput(1);
    mearsuements(counter,:)=[x y]
    answer=menu('are you want to choose select points?','yes','no');
    counter=counter+1;
    if counter>size(calibration,1)
        break
    end
    
end
% entekhab model
modelselection=-1;
switch size(mearsuements,1)
    case 2
        modelselection=menu('select your interior oirentation model','conformal');
    case 3
        modelselection=menu('select your interior oirentation model','conformal','affine');
    case 4
        modelselection=menu('select your interior oirentation model','conformal','affine','2D-projective');
end
if modelselection>0
    fid=fopen(['right image results.txt'],'w');
    switch modelselection
        
        case 1
            [delta]=conformal(mearsuements,calibration);
            fprintf(fid, '%f\n%f\n%f\n%f',delta);
        case 2
            [delta]=affine(mearsuements,calibration);
            fprintf(fid, '%f\n%f\n%f\n%f\n%f\n%f',delta);
        case 3
            [delta]=projective(mearsuements,calibration);
            fprintf(fid, '%f\n%f\n%f\n%f%f\n%f\n%f\n%f',delta);
    end
end
fclose(fid);

%%
% reading left image and loading file
[file1 adrs]=uigetfile('*.jpg','select your left image');
pic2=imread([adrs file1]);
[file adrs]=uigetfile('*.txt','select your calibration file');
calibration=load([adrs file]);
answer=1;
counter=1;
%namayesh aks va andazegiri fidooshelmark
while  answer==1
    imshow(pic2);
    Txt=sprintf('x= %f y=%f',calibration(counter,2),calibration(counter,3));
    title(Txt);
    pause
    [y x]=ginput(1);
    mearsuements(counter,:)=[x y]
    answer=menu('are you want to choose select points?','yes','no');
    counter=counter+1;
    if counter>size(calibration,1)
        break
    end
    
end
% entekhab model
modelselection=-1;
switch size(mearsuements,1)
    case 2
        modelselection=menu('select your interior oirentation model','conformal');
    case 3
        modelselection=menu('select your interior oirentation model','conformal','affine');
    case 4
        modelselection=menu('select your interior oirentation model','conformal','affine','2D-projective');
end
if modelselection>0
    fid=fopen(['left image results.txt'],'w');
    switch modelselection
        
        case 1
            [delta]=conformal(mearsuements,calibration);
            fprintf(fid, '%f\n%f\n%f\n%f',delta);
        case 2
            [delta]=affine(mearsuements,calibration);
            fprintf(fid, '%f\n%f\n%f\n%f\n%f\n%f',delta);
        case 3
            [delta]=projective(mearsuements,calibration);
            fprintf(fid, '%f\n%f\n%f\n%f%f\n%f\n%f\n%f',delta);
    end
end
fclose(fid);
%%
prompt = {'Enter focal length:'};
dlg_title = 'focal length';
num_lines = 1;
defaultans = {'153.167'};
f = str2double(inputdlg(prompt,dlg_title,num_lines,defaultans));
%%
[file, adrs]=uigetfile('*.txt','select IOP file');
IOP=load([adrs file]);

answer=1;
counter=1;
while answer==1
    imshow(pic1);
    pause
    [y x]=ginput(1);
    xi(counter)=x;
    yi(counter)=y;
    %gereftan ID noghat GCP
    prompt = {'Enter ID of GCP:'};
    dlg_title = 'input';
    num_lines = 1;
    defaultans = {''};
    code(counter)= str2double(inputdlg(prompt,dlg_title,num_lines,defaultans));
    mearsuementsi(counter,:)=[code(counter) yi(counter) xi(counter)];
    counter=counter+1;
    answer=menu('are you want to select another GCP?','yes','no');
    
end
%zakhire natayej dar yek file text

fileID = fopen('results.txt','w');
fprintf(fileID,'%s %10s %10s\n','code','y','x');
fprintf(fileID,'%.0f %13.4f %13.4f\n',mearsuementsi);
fclose(fileID);

% winopen('results.txt');
%%
%  tabdil mokhtasat picseli be mokhtasat aksi ya fidooshelmarki
[xp yp]=IOP_Transform(xi,yi,IOP)
[file adrs]=uigetfile('*.txt','select GCPs file');
GCP=load([adrs file]);
for i=1:length(code)
    
    selectGCP(i,:)=GCP(GCP(:,1)==code(i),:)
end
[EOP]=resection(xp,yp,f,selectGCP);
