function [reduce_index,group_index,X_test,group_test] = Reduce_sample(group_predict,X_test,group_test,group_index)

reduce_index=find(group_predict~=0);
X_test(reduce_index,:)=[];
group_test(reduce_index)=[];
group_index(reduce_index)=[];

end