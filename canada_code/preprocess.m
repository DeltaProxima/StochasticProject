function [Training_Data,Evaluation_Data]=preprocess(Data_Nodup_ObS,TrData_Percent)

L1=sum(Data_Nodup_ObS(:,10)=='1');
L2=sum(Data_Nodup_ObS(:,10)=='2');
L3=sum(Data_Nodup_ObS(:,10)=='3');
L4=sum(Data_Nodup_ObS(:,10)=='4');
L5=sum(Data_Nodup_ObS(:,10)=='5');
L6=sum(Data_Nodup_ObS(:,10)=='6');

%Obtain points to cut
Temp=[floor(TrData_Percent*L1) floor(TrData_Percent*L2) floor(TrData_Percent*L3) floor(TrData_Percent*L4) floor(TrData_Percent*L5) floor(TrData_Percent*L6)];
Cut=[Temp(1); L1; L1+Temp(2); L1+L2; L1+L2+Temp(3); L1+L2+L3; L1+L2+L3+Temp(4);
    L1+L2+L3+L4; L1+L2+L3+L4+Temp(5);L1+L2+L3+L4+L5; L1+L2+L3+L4+L5+Temp(6)];
                        
%Extract Training dataset            
Training_Data=[Data_Nodup_ObS(1:Cut(1),9:10); Data_Nodup_ObS(Cut(2)+1:Cut(3),9:10);Data_Nodup_ObS(Cut(4)+1:Cut(5),9:10);
              Data_Nodup_ObS(Cut(6)+1:Cut(7),9:10);Data_Nodup_ObS(Cut(8)+1:Cut(9),9:10);Data_Nodup_ObS(Cut(10)+1:Cut(11),9:10)];

%Extract Evaluation dataset 
Evaluation_Data=[Data_Nodup_ObS(Cut(1)+1:Cut(2),9:10);Data_Nodup_ObS(Cut(3)+1:Cut(4),9:10);Data_Nodup_ObS(Cut(5)+1:Cut(6),9:10);
              Data_Nodup_ObS(Cut(7)+1:Cut(8),9:10);Data_Nodup_ObS(Cut(9)+1:Cut(10),9:10);Data_Nodup_ObS(Cut(11)+1:end,9:10)];
          
end