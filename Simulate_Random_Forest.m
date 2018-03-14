clear all
clc

% load lung_train.mat
% load lung_test.mat

% load lung1_train.mat
% load lung1_test.mat

load GSE19188_train.mat
load GSE19188_test.mat

%-------------------------------------------------------------------%
iter=30;  % experiment times %
iter_i=1;
%-------------------------- file setup -----------------------------%
file_exist = exist('.\Result\GSE19188_result_RF.txt', 'file');
if(file_exist~=0)
    delete('.\Result\GSE19188_result_RF.txt');
end
fid = fopen('.\Result\GSE19188_result_RF.txt', 'a');
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

    B=TreeBagger(100,X,Y);
    predict_y=predict(B,X_test);

    predict_y=cell2mat(predict_y);
    predict_y=str2num(predict_y);
    [accurancy,sensitivity,specificity]=Performance(Y_test,predict_y);
    [auc,X_FP,Y_TP]=plot_roc(Y_test,predict_y);

    % fprintf('Using Random Forest£¬accurancy £º%f\n' ,accurancy);
    % fprintf('Using Random Forest£¬sensitivity £º%f\n' ,sensitivity);
    % fprintf('Using Random Forest£¬specificity £º%f\n' ,specificity);
    % fprintf('Using Random Forest£¬AUC £º%f\n' ,auc);

    fprintf(fid, '%f\t%f\t%f\t%f\n' ,accurancy,sensitivity,specificity,auc);
    iter_i=iter_i+1
end
fclose(fid);