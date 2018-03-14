function [idx_kmean,data,zero_error_index] = K_Mean(data,group)

    zero_index_group=find(group==0);
    idx_kmean=kmeans(data,2,'dist','sqEuclidean','rep',5);  %--- kmeans ---% sqEuclidean
    zero_error_index=0;
    zero_value_kmeans=idx_kmean(zero_index_group);
    if(isequal(zero_value_kmeans,ones(size(zero_value_kmeans))*zero_value_kmeans(1)))
        kmeans_class_zero=zero_value_kmeans(1);
        zero_index_kmeans=find(idx_kmean==kmeans_class_zero);
        idx_kmean(zero_index_kmeans)=0;
    else
        [number_max_stat,zero_value_kmeans_stat]=hist(zero_value_kmeans,unique(zero_value_kmeans));
        [min_vaule,min_index]=min(number_max_stat);
        [max_value,max_index]=max(number_max_stat);
        zero_error_index=find(zero_value_kmeans==zero_value_kmeans_stat(min_index));
        zero_error_index_true=zero_index_group(zero_error_index);
        data(zero_error_index_true)=[];
        idx_kmean(zero_error_index_true)=[];
        kmeans_class_zero=zero_value_kmeans_stat(max_index);
        zero_index_kmeans=find(idx_kmean==kmeans_class_zero);
        idx_kmean(zero_index_kmeans)=0;     
    end 
    idx_kmean(find(idx_kmean~=0))=1;
end