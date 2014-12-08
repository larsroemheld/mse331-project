%Script to Get stacked graphs
%Get models, TN, TP, FN, FP
models = {'GLM';'LIBLINEAR_LR';'SVM';'GBM'}
X = [FP TP FN TN ];
X(1,:) = 100*X(1,:)/sum(X(1,1:2));
%X(1,3:4) = 50*X(1,3:4)/sum(X(1,1:2));

X(2,:) = 100*X(2,:)/sum(X(2,1:2));
%X(2,3:4) = 50*X(2,3:4)/sum(X(2,3:4));

X(3,:) = 100*X(3,:)/sum(X(3,1:2));
%X(4,3:4) = 50*X(4,3:4)/sum(X(4,3:4));

X(4,:) = 100*X(4,:)/sum(X(4,1:2));
%X(4,3:4) = 50*X(4,3:4)/sum(X(4,3:4));

%X = [X(1,:);X(3:4,:)];%Removing Lib Linear_LR

%[FN][TP][TN][FP]
%[blue][darkblue][darkred][red]
%Plot Stacked Graph
figure(1);

h= barh(1:3, X,0.5,'stacked');
set(h(1),'facecolor','blue')
set(h(2),'facecolor',[0 0 0.4])
set(h(3),'facecolor',[0.4 0 0])
set(h(4),'facecolor','red')

xlim([0 100]);
h = title('Confusion Matrix','fontsize',22,'fontweight','bold');
h = xlabel('% of cases','fontsize',22,'fontweight','bold')
h = legend('False Positive','True Positive','False Negative','True Negative','fontsize',22,'Location','BestOutside')
h = set(gca, 'YTick',1:3,'YTickLabels', models(1:3,:),'fontsize',22,'fontweight','bold');
h = set(gca,'XTick',0:10:100,'fontsize','22');