function [Data2]=string_num(Data1)
len=length(Data1);
for i=1:len
    for j=1:2
        Data2(i,j)=str2num(Data1(i,j));
    end
end
        
end