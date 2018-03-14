function IDX_return = CWeight(IDX_1,IDX_2,IDX_3,IDX_4)

IDX = [IDX_1;IDX_2;IDX_3;IDX_4];
IDX= unique(IDX);
L_IDX1=length(IDX_1);
L_IDX2=length(IDX_2);
L_IDX3=length(IDX_3);
L_IDX4=length(IDX_4);
weight_IDX=zeros(1,length(IDX));

for i=1:length(IDX)
   exist_search_1=ismember(IDX(i),IDX_1);
   if(exist_search_1==1)
       exist_index_1=find(IDX_1==IDX(i));
       index_1=L_IDX1-exist_index_1+1;
   else
       index_1=0;
   end

   exist_search_2=ismember(IDX(i),IDX_2);
   if(exist_search_2==1)
       exist_index_2=find(IDX_2==IDX(i));
       index_2=L_IDX2-exist_index_2+1;
   else
       index_2=0;
   end

   exist_search_3=ismember(IDX(i),IDX_3);
   if(exist_search_3==1)
       exist_index_3=find(IDX_3==IDX(i));
       index_3=L_IDX3-exist_index_3+1;
   else
       index_3=0;
   end

   exist_search_4=ismember(IDX(i),IDX_4);
   if(exist_search_4==1)
       exist_index_4=find(IDX_4==IDX(i));
       index_4=L_IDX4-exist_index_4+1;
   else
       index_4=0;
   end


%weight_IDX(i)=(index_1 + index_2 + index_3 + index_4)/(exist_search_1*L_IDX1 + exist_search_2*L_IDX2 + exist_search_3*L_IDX3 + exist_search_4*L_IDX4);
weight_IDX(i)=(index_1 + index_2 + index_3 + index_4)/(L_IDX1 + L_IDX2 + L_IDX3 + L_IDX4);

end

IDX=IDX';
IDX_W_matrix=[IDX;weight_IDX]';
IDX_W_matrix=sortrows(IDX_W_matrix,-2);
IDX_return=IDX_W_matrix(:,1);

end

