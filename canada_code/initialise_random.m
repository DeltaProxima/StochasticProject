function [A_Random,B_Random,Pi_Random]=initialise_random(M,N)
A_Random=rand(N);
B_Random=rand(N,M);
Pi_Random=rand(1,N);
%Modify A, B and Pi so that sum of each row is unity
Pi_Random(1,:)=1/sum(Pi_Random(1,:))*Pi_Random(1,:);
for i=1:N
    A_Random(i,:)=1/sum(A_Random(i,:))*A_Random(i,:);
    B_Random(i,:)=1/sum(B_Random(i,:))*B_Random(i,:);
end
end