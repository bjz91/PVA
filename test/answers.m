clear
clc

[num,txt,raw]=xlsread('answers.xlsx');

A=num(:,1:3);
AAns=A(1:50,:);

FAns=num(:,6:8);

save('../input/Ans.mat','AAns','FAns');