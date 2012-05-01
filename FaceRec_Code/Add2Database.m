function rec=Add2Database( img1,name )

fcdb='fc_database.dat';
if (exist(fcdb,'file')==2)
    load(fcdb,'-mat');
    fc_no=fc_no+1;    
    newfile=0;
else
    newfile=1;
    fc_no=1;    
end
rec=fc_no;


   % [id1 im1]=getImgMatch(img1,'trFcdb');
   % [id2 im2]=getImgMatch(img2,'trFcdb');
      
    pname{fc_no,1}=name;
    fname{fc_no,1}=strcat('trFcdb/',int2str(rec),'.jpg');
    if(newfile==1)
        save(fcdb,'fname','pname','fc_no');
        newfile=0;
    else
        save(fcdb,'fname','pname','fc_no','-append');
    end
    
   % imwrite(img1,strcat('trFcdb/',int2str(((rec-1)*2)+1),'.jpg'));
    imwrite(img1,strcat('trFcdb/',int2str(rec),'.jpg'));
    rec=fc_no;
    

end
