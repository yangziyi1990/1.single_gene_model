clear all
clc

% load lung_train.mat
% load lung_test.mat

% load lung1_train.mat
% load lung1_test.mat

load GSE19188_train.mat
load GSE19188_test.mat

[train_m,train_p]=size(train);
iter=30;  % experiment times %
iter_i=1;
beta_record=zeros(train_p-1,iter);
%-------------------------- file setup -----------------------------%
file_exist = exist('.\Result\GSE19188_result_logistic.txt', 'file');
if(file_exist~=0)
    delete('.\Result\GSE19188_result_logistic.txt');
end
fid = fopen('.\Result\GSE19188_result_logistic.txt', 'a');
fprintf(fid, 'Accurancy\tSensitivity\tSpecificity\tAUC\n');
%-------------------------- file setup -----------------------------%
while(iter_i<=iter)

	original=train;
	original_test=test;
	[m,n]=size(original);
	Y=original(:,1);
	X=original(:,2:n);
	Y_test=original_test(:,1);
	X_test=original_test(:,2:n);

	[B,FitInfo] = lassoglm(X,Y,'binomial','NumLambda',25,'CV',10); 

	indx = FitInfo.Index1SE;
	B0 = B(:,indx);
	nonzeros = sum(B0 ~= 0);
	cnst = FitInfo.Intercept(indx);

    Y_predict=X_test*B0 + cnst;
    prob1=exp(Y_predict)./(1 + exp(Y_predict));

    beta_record(:,iter_i)=B0;

    [m1,n1]=size(X_test);
    for i=1:m1
        if prob1(i)>0.5
            predict_y(i)=1;
        else
            predict_y(i)=0;
        end
    end

    predict_y1=predict_y';
    [accurancy,sensitivity,specificity]=Performance(Y_test,predict_y1);
    [auc,X_FP,Y_TP]=plot_roc(Y_test,predict_y1);

	% fprintf('Using Logistic classifier£¬accurancy £º%f\n' ,accurancy);
	% fprintf('Using Logistic classifier£¬sensitivity £º%f\n' ,sensitivity);
	% fprintf('Using Logistic classifier£¬specificity £º%f\n' ,specificity);
	% fprintf('Using Logistic classifier£¬AUC £º%f\n' ,auc);
	% fprintf('Seleted key features number £º%d\n', nonzeros);

    fprintf(fid, '%f\t%f\t%f\t%f\t%f\n' ,accurancy,sensitivity,specificity,auc,nonzeros);
    iter_i=iter_i+1
end
fclose(fid);
dlmwrite('.\Result\GSE19188_logistic_beta.txt', beta_record, 'precision', '%5f', 'delimiter', '\t')

