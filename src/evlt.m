function [Xpp,xmax,xmin]=evlt(X)

xmax=max(X,[],1);
xmaxrep=repmat(xmax,size(X,1),1); % Temporal variable
xmin=min(X,[],1);
xminrep=repmat(xmin,size(X,1),1); % Temporal variable

% Calculate X'
Xp=(X-xminrep)./(xmaxrep-xminrep);

% Calculate X''
Xpd=Xp.^2;
Y=1./sqrt(sum(Xpd,2));
Y=diag(Y);
Xpp=Y*Xp;

end