function [AFinal,FFinal,s]=PVA(Xn,iterNumMax)

%% Calculate X''

[Xpp,xmax,xmin]=evlt(Xn);

%% Calculate A(An) and F(Fn)

[U,S,V]=svd(Xpp);
An=U*S;
Fn=V';

s=svd(Xpp);
s=s.^2;
s=s./sum(s);

%% Calculate A'' and F''

K=3;
App=An(:,1:K);
Fpp=(App'*App)^-1;
Fpp=Fpp*App'*Xpp;

%% Calculate A, F and Xhat

[A,F]=scaleBack(App,Fpp,xmax,xmin,K);
Xh=A*F;

iterNum=0;

while iterNum<iterNumMax
    
    iterNum=iterNum+1;
    disp(['loop = ',num2str((iterNum))]);
    
    %% Calculate O0
    
    [~,App]=varimaxTP(App);
    [~,max_i]=max(abs(App),[],1); %Here might be the absolute maximum
    O0=App(max_i,:);
    
    %% Iteration of O0

    oldmax_i=max_i;
    iterNum_O=0;
    iterNumMax_O=100;
    while true
        if iterNum_O<iterNumMax_O
            iterNum_O=iterNum_O+1;
            % Calculate A0'' and F0''
            [A0pp,F0pp]=calO(App,Fpp,O0);
            % Scale back
            [A0,F0,S]=scaleBack(A0pp,F0pp,xmax,xmin,K);
            % Judgement
            [newmax_A,newmax_i]=max(abs(A0),[],1);
            one_cols=find(newmax_A>1);
            if ~isempty(one_cols) % Whether the A0 greater than 1
                one_rows=newmax_i(one_cols);
                for one_num=1:length(one_cols)
                    O0(one_cols(one_num),:)=App(one_rows(one_num),:);
                    oldmax_i(one_cols(one_num))=one_rows(one_num);
                end
                continue;
            end
            if sum(newmax_i-oldmax_i)~=0 % Whether there are new rows
                O0=App(newmax_i,:);
                oldmax_i=newmax_i;
            else
                break;
            end
        else
            O0=App(max_i,:);
            [A0pp,F0pp]=calO(App,Fpp,O0);
            [A0,F0,S]=scaleBack(A0pp,F0pp,xmax,xmin,K);
            break;
        end
    end
    
    disp(newmax_A);
    
    %----------------------------------
    %{
    figure(1)
    clf
    plot3(App(:,1),App(:,2),App(:,3),'or');
    axis square
    grid on
    hold on
    plot3(O0(:,1),O0(:,2),O0(:,3),'*g');
    title('A" and O_0');
    legend('A"','O_0','Location','northwest');
    
    figure(2)
    clf
    subplot(1,2,1)
    plot3(A0(:,1),A0(:,2),A0(:,3),'or');
    axis square
    grid on
    hold on
    plot3(AAns(:,1),AAns(:,2),AAns(:,3),'ob');
    title('A_0');
    legend('A_0','A Answers','Location','northwest');
    
    subplot(1,2,2)
    plot3(F0(1,:),F0(2,:),F0(3,:),'or');
    axis square
    grid on
    hold on
    plot3(FAns(:,1),FAns(:,2),FAns(:,3),'ob');
    title('F_0');
    legend('F_0','F Answers','Location','northwest');
    %}
    %----------------------------------
    
    if iterNum==iterNumMax
        AFinal=A0;
        FFinal=F0;
        disp('Maximum iteration');
        break;
    end
    
    
    %% DENEG
    
    % A judgement
    [A_idx]=negaA(A0);                                                      %把A为负的挑出来
    if sum(sum(A_idx))==0                                                 %如果A没有负值，则结束
        AFinal=A0;
        FFinal=F0;
        disp('A end');
        break;
    else
        [A1,F1]=judgeA(A0,A_idx,Xh);                                         %否则，把A里的负值归0，并归一化
    end
    
    % F judgement
    [F_idx]=negaF(F1); %把F为负的挑出来
    if sum(sum(F_idx))==0                                               %如果F没有负值，则结束
        AFinal=A1;
        FFinal=F1;
        disp('F end');
        break;
    else
        F2=judgeFNew(F1,F_idx);                                              %否则，把F里的负值归0，并“归一化”F                                      % 这里应该和judgeA一样，转换之后每一列的和不变
        F2pp=evlt(F2);                                                       %经检查，evltF和scaleBack对于F来说的确是互逆的关系
        Xhpp=evlt(Xh);
        A2pp=(Xhpp*F2')*((F2pp*F2pp')^-1);
        
        App=A2pp;
        Fpp=F2pp;
    end
    
end

end