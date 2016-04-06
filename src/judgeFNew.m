function F2=judgeFNew(F1,F_idx)

F1temp=F1;
F1temp(F_idx)=0;

F1sum=sum(F1temp,2);
F1sum=repmat(F1sum,1,size(F1,2));

F2=F1temp./F1sum*100;

end