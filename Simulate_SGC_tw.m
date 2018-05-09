clear all
clc

% load lung_train.mat
% load lung_test.mat

% load lung1_train.mat
% load lung1_test.mat

load GSE19188_train.mat
load GSE19188_test.mat

A_train=train;
A_test=test; 

% A_train_rowrank = randperm(size(A_train, 1));
% A_test_rowrank = randperm(size(A_test, 1));
% A_train= A_train(A_train_rowrank,:);
% A_test= A_train(A_test_rowrank,:);

%_________________Training data______________________%
A=A_train;
[A_n,A_p]=size(A);
B=A(:,1);
group_original=B;
A=A';
A=A(2:A_p,:);
[n,p]=size(A);

%_________________Testing data_______________________%
[test_n,test_p]=size(A_test);
B_test=A_test(:,1);
A_test=A_test(:,2:test_p);
[test_n1,test_p1]=size(A_test);

[IDX_ttest, Z_ttest] = rankfeatures(A,B,'Criterion','ttest','NumberOfIndices', 1);
[IDX_U, Z_U] = rankfeatures(A,B,'Criterion','wilcoxon','NumberOfIndices', 1);

A_test_ttest=A_test(:,IDX_ttest);
A_test_wilcon=A_test(:,IDX_U);

[Y_ttest,E_ttest] = discretize(A_test_ttest,2);
[Y_wilcon,E_wilcon] = discretize(A_test_wilcon,2);

Y_ttest_0_index=find(Y_ttest==2);
Y_ttest(Y_ttest_0_index)=0;
Y_wilcon_0_index=find(Y_wilcon==2);
Y_wilcon(Y_wilcon_0_index)=0;

[accurancy_t,sensitivity_t,specificity_t]=Performance(B_test,Y_ttest);
[auc_t,X_FP_t,Y_TP_t]=plot_roc(B_test,Y_ttest);

[accurancy_w,sensitivity_w,specificity_w]=Performance(B_test,Y_wilcon);
[auc_w,X_FP_w,Y_TP_w]=plot_roc(B_test,Y_wilcon);

fprintf('Using SG-t classifier£¬accurancy £º%f\n' ,accurancy_t);
fprintf('Using SG-t classifier£¬sensitivity £º%f\n' ,sensitivity_t);
fprintf('Using SG-t classifier£¬specificity £º%f\n' ,specificity_t);
fprintf('Using SG-t classifier£¬AUC £º%f\n' ,auc_w);
fprintf('Seleted key feature is £º%d\n', IDX_ttest);

fprintf('Using SG-w classifier£¬accurancy £º%f\n' ,accurancy_w);
fprintf('Using SG-w classifier£¬sensitivity £º%f\n' ,sensitivity_w);
fprintf('Using SG-w classifier£¬specificity £º%f\n' ,specificity_w);
fprintf('Using SG-w classifier£¬AUC £º%f\n' ,auc_w);
fprintf('Seleted key feature is £º%d\n', IDX_U);


