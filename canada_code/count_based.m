function [A_Count,B_Count]=count_based(M,N,L,Data)
%obtain initial A 
A_Count(1:N,1)=0.8;% Assign 0.8 for first column
A_Count(1:N,2:N)=0.2/N;%Assign evenly distributed 0.2 value to rest of columns

%compute initial B
for i=1:N
    for j=1:M
        count=0;
        for m=1:L
            if Data(m,1)==j&&Data(m,2)==i
            count=count+1;
            end        
        end
        B_Count(i,j)=count;        
    end
end
%Normalise values in B so that the sum of observations per state is unity
for i=1:N    
    B_Count(i,:)=1/sum(B_Count(i,:))*B_Count(i,:);
end
end