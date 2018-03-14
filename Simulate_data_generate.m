clear all
clc

beta=zeros(1,1500);

beta(1)=5;
beta(4)=5;
beta(7)=5;
beta(15)=5;
% beta(19)=5;
% beta(23)=0;
% beta(26)=0;
% beta(130)=0;
% beta(235)=0;
% beta(456)=0;


sample1_size=50;
sample0_size=100;

intercept=0;
noise=0;
actual_beta=beta; 

x_1= normrnd(0, 1, sample1_size, size(beta,2));
x_0= normrnd(0, 1, sample0_size, size(beta,2));

X1_len=10;
X2_len=10;
X3_len=15;
X4_len=15;
% X5_len=15;
% X6_len=0;
% X7_len=0;
% X8_len=0;
% X9_len=0;
% X10_len=0;

mean_X1=10;
mean_X2=10;
mean_X3=10;
mean_X4=10;
% mean_X5=5;

if(X1_len~=0)
    X1=normrnd(mean_X1,1,X1_len,1);
    for i=1:X1_len
        x_1(i,1)=X1(i,1);
    end
end

if(X2_len~=0)
    X2=normrnd(mean_X2,1,X2_len,1);
    for i=1:X2_len
        x_1(i+X1_len,4)=X2(i,1);
    end
end

if(X3_len~=0)
    X3=normrnd(mean_X3,1,X3_len,1);
    for i=1:X3_len
        x_1(i+X1_len+X2_len,7)=X3(i,1);
    end
end

if(X4_len~=0)
    X4=normrnd(mean_X4,1,X4_len,1);
    for i=1:X4_len
        x_1(i+X1_len+X2_len+X3_len,15)=X4(i,1);
    end
end
% 
% if(X5_len~=0)
%     X5=normrnd(mean_X5,1,X5_len,1);
%     for i=1:X5_len
%         x_1(i+X1_len+X2_len+X3_len+X4_len,19)=X5(i,1);
%     end
% end

% if(X6_len~=0)
%     X6=normrnd(5,1,X6_len,1);
%     for i=1:X6_len
%         x(i+X5_len,23)=X6(i,1);
%     end
% end
% 
% if(X7_len~=0)
%     X7=normrnd(4,1,X7_len,1);
%     for i=1:X7_len
%         x(i+X6_len,26)=X7(i,1);
%     end
% end
% 
% if(X8_len~=0)
%     X8=normrnd(4,1,X8_len,1);
%     for i=1:X8_len
%         x(i+X7_len,130)=X8(i,1);
%     end
% end
% 
% if(X9_len~=0)
%     X9=normrnd(4,1,X9_len,1);
%     for i=1:X9_len
%         x(i+X8_len,235)=X9(i,1);
%     end
% end
% 
% if(X10_len~=0)
%     X10=normrnd(5,1,X10_len,1);
%     for i=1:X10_len
%         x(i+X9_len,546)=X10(i,1);
%     end
% end

X1=x_1;
X0=x_0;
[n1,p1]=size(X1);
[n0,p0]=size(X0);

l1=intercept + ( X1 * beta' + noise * normrnd(0, 1, n1, 1));  %% no noise 
prob1=exp(l1)./(11 + exp(l1));
for i=1:sample1_size
    if prob1(i)>0.5
        y1(i)=1;
    else
        y1(i)=0;
    end
end
Y1=y1';
Y1_0_index=find(Y1==0);
if(Y1_0_index)
    fprintf('Y of Class1 has some Y=0, rerun!!!\n')
else
    fprintf('Y of Class1 all equal to 1.\n');
end

l0=intercept + ( X0 * beta' + noise * normrnd(0, 1, n0, 1));  %% no noise 
prob0=exp(l0)./(10 + exp(l0));
for i=1:sample0_size
    if prob0(i)>0.5
        y0(i)=1;
    else
        y0(i)=0;
    end
end
Y0=y0';
Y0_0_number=length(find(Y0==0));
if(Y0_0_number>=50)
    Y0_0_index=find(Y0==0);
    Y0_0_index=Y0_0_index(1:50);
    Y0=Y0(Y0_0_index,:);
    X0=X0(Y0_0_index,:);
else
    fprintf('The number of Class0 not satisfied, rerun!!! ');
end


Y=[Y0;Y1];
X=[X0;X1];
% train=[Y,X];
test=[Y,X];

