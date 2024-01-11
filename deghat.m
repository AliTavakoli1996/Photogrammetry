   fid=fopen(['ROP_Test.txt'],'w');
    fprintf(fid,'%20.15f\n%20.15f\n%20.15f\n%20.15f\n%20.15f\n%20.15f',AOP(1:6));
    fclose(fid);