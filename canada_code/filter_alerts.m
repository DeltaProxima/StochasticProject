function [Obs_Remove,Tr_Data,Ev_Data]=rem_obs(Tr_Data,Ev_Data)
%Obtain the uniques symbols
Tr_Data_Obs=unique(Tr_Data(:,1));
Ev_Data_Obs=unique(Ev_Data(:,1));
        
%get different observations
Diff1=setdiff(Tr_Data_Obs,Ev_Data_Obs);
Diff2=setdiff(Ev_Data_Obs,Tr_Data_Obs);
Obs_Remove=[Diff1; Diff2];%Symbols to be removed
Len=length(Obs_Remove);

% Remove uncommon observations
for i=1:Len
Tr_Data(Tr_Data(:,1)==Obs_Remove(i),:)=[];
Ev_Data(Ev_Data(:,1)==Obs_Remove(i),:)=[];
end


end