function F2=judgeF(F1,F_idx)

F1temp=F1;
F1temp(~F_idx)=0;
D=min(F1temp,[],2); % lowest adjustable mixing proportions 
D=abs(D);

Drep=repmat(D,1,size(F1,2));
z=sum(F1,1)./(sum(F1,1)+sum(D)); %NOTICE!!!!!! This originally is +
z=repmat(z,size(F1,1),1); % ���ԣ�Fÿһ�еĺͿ϶�����1�����Ǻ�ԭ��һ��
F2=(F1+Drep).*z;

end