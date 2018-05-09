clear all
clc

load GSE19188_train.mat
load GSE19188_test.mat

% load GSE19188_train.mat
% load GSE19188_test.mat

iter=10;    % experiment times %
iter_i=1;
%-------------------------- file setup -----------------------------%
file_exist = exist('.\Result\GSE19188_result_single_model.txt', 'file');
if(file_exist~=0)
    delete('.\Result\GSE19188_result_single_model.txt');
end

fid = fopen('.\Result\GSE19188_result_single_model.txt', 'a');
fprintf(fid, 'Accurancy\tSensitivity\tSpecificity\tAUC\n');
%-------------------------- file setup -----------------------------%
while(iter_i<=iter)

%----------------- Random ranking ------------------%
A_train=train;
A_test=test; 

A_train_rowrank = randperm(size(A_train, 1));
A_test_rowrank = randperm(size(A_test, 1));
A_train= A_train(A_train_rowrank,:);
A_test= A_train(A_test_rowrank,:);

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

num_select=20;  % change number of selected features %

%------------Step1: Reduce the dimension by yanqiong Ren------------%
[IDX_ttest, Z_ttest] = rankfeatures(A, B,'Criterion','ttest','NumberOfIndices', num_select);
[IDX_entropy, Z_entropy] = rankfeatures(A, B,'Criterion','entropy','NumberOfIndices', num_select);
[IDX_Ch, Z_Ch] = rankfeatures(A, B,'Criterion','bhattacharyya','NumberOfIndices', num_select);
[IDX_U, Z_U] = rankfeatures(A, B,'Criterion','wilcoxon','NumberOfIndices', num_select);

[IDX] = CWeight(IDX_ttest,IDX_entropy,IDX_Ch,IDX_U);  %% calculate weight of IDX %%

rankfeatures_len=1:length(IDX);
X_train=A(IDX(rankfeatures_len),:)';
X_test=A_test(:,IDX(rankfeatures_len));

%------------Step2: re-lable y------------%
var_col_value=std(X_train,0,1);     %--- var >=1 continue analysis ---%
var_selected_index=find(var_col_value>2); % setting cutoff of var %

X_train=X_train(:,var_selected_index);
X_test=X_test(:,var_selected_index);

IDX_new=IDX(var_selected_index);
new_rankfeatures_len=length(var_selected_index);
 
group_index=1:test_n1;
group_index=group_index';
reduce_record=ones(test_n1,new_rankfeatures_len);   

group=B;
group_test=B_test;

for i=1:new_rankfeatures_len
    
    data=X_train(:,i);
    test_data=X_test(:,i);
    [idx_kmean,data,zero_error_index]=K_Mean(data,group);  %% K_Mean %%
 
    %----------------- training model --------------------%
    data_train=data;
    data_test=test_data;
    group_train=idx_kmean;
    
    %SVMModel(i) = svmtrain(data_train,group_train,'kernel_function','quadratic','showplot',true );   %% svm classifier %%
    %predict_label=svmclassify(SVMModel(i),data_test,'showplot',true);
    ctree = fitctree(data_train,group_train);
    predict_label = predict(ctree,data_test)  
    
    [reduce_index,group_index,X_test,group_test]=Reduce_sample(predict_label,X_test,group_test,group_index);  %% reduce sample which class=1 %%
    reduce_record(group_index,i)=0;
    
    if(sum(group_test)==0)
        break;
    end
    
end

group_final=ones(1,test_n1);
group_final=group_final';
group_final(group_index)=0;   %%% predicted y %%%%

[accurancy,sensitivity,specificity]=Performance(B_test,group_final);
[auc,X_FP,Y_TP]=plot_roc(B_test,group_final);

% fprintf('Using single gene multiple classifier£¬accurancy £º%f\n' ,accurancy);
% fprintf('Using single gene multiple classifier£¬sensitivity £º%f\n' ,sensitivity);
% fprintf('Using single gene multiple classifier£¬specificity £º%f\n' ,specificity);
% fprintf('Using single gene multiple classifier£¬AUC £º%f\n' ,auc);
 fprintf(fid, '%f\t%f\t%f\t%f\n' ,accurancy,sensitivity,specificity,auc);
iter_i=iter_i+1

end
fclose(fid);

