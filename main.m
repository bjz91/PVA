clear
clc

addpath('src/');

%%------------------------------
%% Load data


% For validation
%{
load('input/Ans.mat');
X=AAns*FAns';
%}

X=csvread('input/MODIS.csv');
X=X(:,1:7); % Load first 7 columns


%%------------------------------
%% PVA

[AFinal,FFinal,s]=PVA(X,20); % (Input array, Maximum of iteration)


%%------------------------------
%% Save data

csvwrite('output/AFinal.csv',AFinal);
csvwrite('output/FFinal.csv',FFinal);


%%------------------------------
%% Plot

% A
figure(1)
plot3(AFinal(:,1),AFinal(:,2),AFinal(:,3),'or');
axis square
grid on
title('A');

% F
figure(2)
FX=[648,858,470,555,1240,1640,2130];
[FXNew,FIndex]=sort(FX);
F1=FFinal(1,:);
F1=F1(FIndex);
F2=FFinal(2,:);
F2=F2(FIndex);
F3=FFinal(3,:);
F3=F3(FIndex);
plot(FXNew,F1,'*-');
hold on
plot(FXNew,F2,'*-');
hold on
plot(FXNew,F3,'*-');
legend('First Row','Second Row','Third Row');
title('F');

% s
figure(3)
s_new=zeros(1,7);
for s_i=1:length(s)
    s_new(s_i)=sum(s(1:s_i));
end
plot(1:7,s_new,'*-');
hold on
plot(0:100,ones(1,101),':','color',[0.2,0.2,0.2]);
for t_i=1:length(s_new)
    text(t_i+0.05,s_new(t_i)-0.003,num2str(s_new(t_i)));
end
set(gca,'XTickLabel',{'PC1','PC2','PC3','PC4','PC5','PC6','PC7'})  
ylabel('cumulative percentage variance');
title('cumulative percentage variance');
axis([0.5,7.5,min(s_new)-0.005,1.005]);

%%------------------------------
%% For validation

%{
figure(3)
clf

subplot(1,2,1)
plot3(AFinal(:,1),AFinal(:,2),AFinal(:,3),'or');
axis square
grid on
hold on
plot3(AAns(:,1),AAns(:,2),AAns(:,3),'ob');
title('The final result of A');
legend('A Final','A Answers','Location','northwest');

subplot(1,2,2)
plot3(FFinal(1,:),FFinal(2,:),FFinal(3,:),'or');
axis square
grid on
hold on
plot3(FAns(:,1),FAns(:,2),FAns(:,3),'ob');
title('The final result of F');
legend('F Final','F Answers','Location','northwest');


figure(4)
DDA=detectError(AFinal,AAns);
DDF=detectError(FFinal',FAns);
subplot(1,2,1)
hist(DDA,20);
title('The error histogram of A');
xlabel('errors');
ylabel('Frequency');
subplot(1,2,2)
hist(DDF,20);
title('The error histogram of F');
xlabel('errors');
ylabel('Frequency');
%}







