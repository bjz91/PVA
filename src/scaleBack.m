function [A,F,S]=scaleBack(App,Fpp,xmax,xmin,K)

Kcon=100;
ksum=repmat(Kcon-sum(xmin),K,1);  % Temporal variable
xmaxminrep=repmat(xmax-xmin,K,1); % Temporal variable
fppmaxmin=sum(Fpp.*xmaxminrep,2); % Temporal variable
S=ksum./fppmaxmin;
% F
srep=repmat(S,1,size(Fpp,2)); % Temporal variable
xminrep=repmat(xmin,K,1);     % Temporal variable
Fp=srep.*Fpp;
F=Fp.*xmaxminrep+xminrep;
% A
srept=repmat(S',size(App,1),1); % Temporal variable
Ap=App./srept;
r=repmat(sum(Ap,2),1,K);
A=Ap./r;

end