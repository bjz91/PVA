function Fpp=evltF(F,xmax,xmin,S,K)

xmaxminrep=repmat(xmax-xmin,K,1); % Temporal variable
srep=repmat(S,1,size(F,2)); % Temporal variable
xminrep=repmat(xmin,K,1);     % Temporal variable
Fpp=(F-xminrep)./(xmaxminrep.*srep);

end