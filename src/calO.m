function [A0pp,F0pp]=calO(App,Fpp,O0)

A0pp=App*(O0^-1);
F0pp=O0*Fpp;

end