function [A_idx]=negaA(A)

A_idx=A>-0.25 & A<-0.05;

end