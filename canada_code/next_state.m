function [Next_State]=next_state(Crt_State,A,B,Old_Observ)

Prob_Next_Observ=A(Crt_State,:)*B; %Prediction probability

[~,Next_Observ]=find(max(Prob_Next_Observ)); %Obtain index of highest probability

New_Observ=[Old_Observ Next_Observ];%Append new observation to old seq

Next_States=hmmviterbi(New_Observ,A,B); %Predict next state
Next_State=Next_States(end); % Take last element

end