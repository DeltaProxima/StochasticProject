function [A_New]=normalise_rows(A_Old,Eps)

[N,~]=size(A_Old);%number of rows

A_New=A_Old;

%For negative values,shift all values by magnitude of minimum value
Count1=sum(A_Old(:) < 0);%Obtain number of negative values 
if Count1>=1
    A_New=A_Old-min(A_Old(:));
end


Count2=sum(A_New(:) == 0);%Number of elements with zeros


if Count2>=1
    A_New(A_New==0)=Eps;%Replace zero with small value
    for i=1:N   
        A_New(i,:)=A_New(i,:)/sum(A_New(i,:));
    end
end

for i=1:N   
    if sum(A_New(i,:))>1
        A_New(i,:)=A_New(i,:)/sum(A_New(i,:));
    end
end

end