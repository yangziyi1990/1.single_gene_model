clear all
clc

% load lung_train.mat
% load lung_test.mat

% load lung1_train.mat
% load lung1_test.mat

load GSE19188_train.mat
load GSE19188_test.mat

%¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª¡ª%
iter=30;  % experiment times %
iter_i=1;
%-------------------------- file setup -----------------------------%
file_exist = exist('.\Result\GSE19188_result_svm.txt', 'file');
if(file_exist~=0)
    delete('.\Result\GSE19188_result_svm.txt');
end

fid = fopen('.\Result\GSE19188_result_svm.txt', 'a');
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

    SVMModel = fitcsvm(X,Y,'KernelScale','auto','Standardize',true); 
    predict_y=predict(SVMModel,X_test);

    [accurancy,sensitivity,specificity]=Performance(Y_test,predict_y);
    [auc,X_FP,Y_TP]=plot_roc(Y_test,predict_y);

    % fprintf('Using SVM classifier£¬accurancy £º%f\n' ,accurancy);
    % fprintf('Using SVM classifier£¬sensitivity £º%f\n' ,sensitivity);
    % fprintf('Using SVM classifier£¬specificity £º%f\n' ,specificity);
    % fprintf('Using SVM classifier£¬AUC £º%f\n' ,auc);
    % fprintf('Seleted key features number £º%d\n', minpts_num);

    fprintf(fid, '%f\t%f\t%f\t%f\n' ,accurancy,sensitivity,specificity,auc);
    iter_i=iter_i+1
    
end
fclose(fid);
