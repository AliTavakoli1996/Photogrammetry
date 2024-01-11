clc
clear
%%
[File_Im Adrs]=uigetfile('*.jpg','Select Image Point');
Img=imread([Adrs File_Im]);
prompt = {'Enter Focal Length:'};
dlg_title = 'Input';
num_lines = 1;
def = {'153.167'};
f = str2double(inputdlg(prompt,dlg_title,num_lines,def));
[File Adrs]=uigetfile('*.txt','Select IOP File');
IOP=load([Adrs File]);
Answer=1;
Counter=1;
while Answer==1
    imshow(Img);
    pause
    [y x]=ginput(1);
    xi(Counter)=x;
    yi(Counter)=y;
    prompt = {'Enter ID of GCP'};
    dlg_title = 'Input';
    num_lines = 1;
    def = {' '};
    Code(Counter) = str2double(inputdlg(prompt,dlg_title,num_lines,def));
    Counter=Counter+1;
    Answer=menu('Are you want to select another GCP?','Yes','No');
end




%  tabdil mokhtasat picseli be mokhtasat aksi ya fidooshelmarki
[xp yp]=IOP_Transform(xi,yi,IOP);
[File Adrs]=uigetfile('*.txt','Select GCPs File');
GCP=load([Adrs File]);
for i=1:length(Code)
    SlctGCP(i,:)=GCP(GCP(:,1)==Code(i),:);
end
EOP=Resection(xp,yp,f,SlctGCP);
fid=fopen(['EOP_' File_Im(1:end-4) '.txt'],'w');
fprintf(fid,'%f\n%f\n%f\n%f\n%f\n%f',EOP);
fclose(fid);