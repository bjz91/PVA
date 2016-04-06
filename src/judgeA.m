function [A1,F1]=judgeA(A0,A_idx,Xh)

A0temp=A0;
A0temp(~A_idx)=0;
D=min(A0temp,[],1); % lowest adjustable mixing proportions
D=abs(D);

Drep=repmat(D,size(A0,1),1);
z=1/(1+sum(D)); %NOTICE!!!!!! This originally is +
A1=(A0+Drep)*z;
F1=((A1'*A1)^-1)*(A1'*Xh);

end