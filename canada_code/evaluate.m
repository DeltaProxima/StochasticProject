function [Acc,No_Experiments,Start_Points]=evaluate(sSize,Evaluation_Seq,Evaluation_States,A_Unif_BW,B_Unif_BW,A_Rand_BW,B_Rand_BW,A_Count_BW,B_Count_BW,A_Unif_VT,B_Unif_VT,A_Rand_VT,B_Rand_VT,A_Count_VT,B_Count_VT)

%Initialise arrays to store accuracy values for all states
Acc_all_Unif_BW=[]; Acc_all_Rand_BW=[]; Acc_all_Count_BW=[];
Acc_all_Unif_VT=[]; Acc_all_Rand_VT=[]; Acc_all_Count_VT=[];

%Initialise arrays to store accuracy values for current state
Acc_CS_Unif_BW=[]; Acc_CS_Rand_BW=[]; Acc_CS_Count_BW=[];
Acc_CS_Unif_VT=[]; Acc_CS_Rand_VT=[]; Acc_CS_Count_VT=[];

%Initialise arrays to store accuracy values for Next state
Acc_NS_Unif_BW=[]; Acc_NS_Rand_BW=[]; Acc_NS_Count_BW=[];
Acc_NS_Unif_VT=[]; Acc_NS_Rand_VT=[]; Acc_NS_Count_VT=[];

Start_Points=[];%Array to store index
Start=1;
Stop=Start+sSize-1;
Len=length(Evaluation_Seq);

%perform several tests
No_Experiments=0;
while Stop<Len
    No_Experiments=No_Experiments+1;
    Stop =Start+sSize-1; %Stop index
    Start_Points=[Start_Points Start];
    Observ=Evaluation_Seq(Start:Stop); %Observation row matrix
    States_Actual= Evaluation_States(Start:Stop);
    Current_State=Evaluation_States(Stop);
    Next_State=Evaluation_States(Stop+1);
    Next_Observ=Evaluation_Seq(Stop+1);
    
    %New start  and Stop point
    Start=Start+1;
    Stop=Start+sSize-1;
    
    %Decode using viterbi to determine state
    %Method 1: %Use three standard techniques for BW
    %1A: Uniform initialisation 
    States_Unif_BW = hmmviterbi(Observ,A_Unif_BW, B_Unif_BW);
    %Predict next state (NS) 
    NS_Unif_BW=next_state(States_Unif_BW(end),A_Unif_BW,B_Unif_BW,Observ);

    %2B: Random initialisation
    States_Rand_BW = hmmviterbi(Observ,A_Rand_BW, B_Rand_BW);
    %Predict next state (NS) 
    NS_Rand_BW=next_state(States_Rand_BW(end),A_Rand_BW,B_Rand_BW,Observ);
   
    %2C: Count based initialisation
    States_Count_BW = hmmviterbi(Observ,A_Count_BW, B_Count_BW);
    %Predict next state (NS) 
    NS_Count_BW=next_state(States_Count_BW(end),A_Count_BW,B_Count_BW,Observ);
     
    
    %Method 3: %Use three standard techniques for VT
    %3A: Uniform initialisation 
    States_Unif_VT = hmmviterbi(Observ,A_Unif_VT, B_Unif_VT);
    %Predict next state (NS) 
    NS_Unif_VT=next_state(States_Unif_VT(end),A_Unif_VT,B_Unif_VT,Observ);
    %3B: Random initialisation
    States_Rand_VT = hmmviterbi(Observ,A_Rand_VT, B_Rand_VT);
    %Predict next state (NS)
    NS_Rand_VT=next_state(States_Rand_VT(end),A_Rand_VT,B_Rand_VT,Observ);    
    %3C: Count based initialisation
    States_Count_VT = hmmviterbi(Observ,A_Count_VT, B_Count_VT);
    %Predict next state (NS)
    NS_Count_VT=next_state(States_Count_VT(end),A_Count_VT,B_Count_VT,Observ);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Accuracy computation 1: Entire states prediction         %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    %Compare entire states
    Comp_all_Unif_BW=eq(States_Actual,States_Unif_BW);    
	Comp_all_Rand_BW=eq(States_Actual,States_Rand_BW); 
	Comp_all_Count_BW=eq(States_Actual,States_Count_BW); 
    Comp_all_Unif_VT=eq(States_Actual,States_Unif_VT);    
	Comp_all_Rand_VT=eq(States_Actual,States_Rand_VT); 
	Comp_all_Count_VT=eq(States_Actual,States_Count_VT); 
    
    %Compute percent accuracy of predicting all state
    Accuracy_all_Unif_BW=nnz(Comp_all_Unif_BW)/length(Comp_all_Unif_BW)*100;
	Accuracy_all_Rand_BW=nnz(Comp_all_Rand_BW)/length(Comp_all_Rand_BW)*100;
	Accuracy_all_Count_BW=nnz(Comp_all_Count_BW)/length(Comp_all_Count_BW)*100;
    Accuracy_all_Unif_VT=nnz(Comp_all_Unif_VT)/length(Comp_all_Unif_VT)*100;
	Accuracy_all_Rand_VT=nnz(Comp_all_Rand_VT)/length(Comp_all_Rand_VT)*100;
	Accuracy_all_Count_VT=nnz(Comp_all_Count_VT)/length(Comp_all_Count_VT)*100;
    
    %Store accuracy results in an array 
    Acc_all_Unif_BW=[Acc_all_Unif_BW Accuracy_all_Unif_BW];  
	Acc_all_Rand_BW=[Acc_all_Rand_BW Accuracy_all_Rand_BW];
	Acc_all_Count_BW=[Acc_all_Count_BW Accuracy_all_Count_BW];
    Acc_all_Unif_VT=[Acc_all_Unif_VT Accuracy_all_Unif_VT];  
	Acc_all_Rand_VT=[Acc_all_Rand_VT Accuracy_all_Rand_VT];
	Acc_all_Count_VT=[Acc_all_Count_VT Accuracy_all_Count_VT];
            
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Accuracy computation 2: Current state prediction         %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Compare current states with predicted state from algorithms
    Comp_CS_Unif_BW=eq(Current_State,States_Unif_BW(end));
    Comp_CS_Rand_BW=eq(Current_State,States_Rand_BW(end));
	Comp_CS_Count_BW=eq(Current_State,States_Count_BW(end));
	Comp_CS_Unif_VT=eq(Current_State,States_Unif_VT(end));
    Comp_CS_Rand_VT=eq(Current_State,States_Rand_VT(end));
	Comp_CS_Count_VT=eq(Current_State,States_Count_VT(end));
    
    %Compute percent accuracy of predicting current state
    Accuracy_CS_Unif_BW=Comp_CS_Unif_BW;   
    Accuracy_CS_Rand_BW=Comp_CS_Rand_BW;
	Accuracy_CS_Count_BW=Comp_CS_Count_BW;
	Accuracy_CS_Unif_VT=Comp_CS_Unif_VT;   
    Accuracy_CS_Rand_VT=Comp_CS_Rand_VT;
	Accuracy_CS_Count_VT=Comp_CS_Count_VT;
    
    %Store accuracy results in an array 
    Acc_CS_Unif_BW=[Acc_CS_Unif_BW Accuracy_CS_Unif_BW];
	Acc_CS_Rand_BW=[Acc_CS_Rand_BW Accuracy_CS_Rand_BW];
	Acc_CS_Count_BW=[Acc_CS_Count_BW Accuracy_CS_Count_BW];
    Acc_CS_Unif_VT=[Acc_CS_Unif_VT Accuracy_CS_Unif_VT];
	Acc_CS_Rand_VT=[Acc_CS_Rand_VT Accuracy_CS_Rand_VT];
	Acc_CS_Count_VT=[Acc_CS_Count_VT Accuracy_CS_Count_VT];
       
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Accuracy computation 3: Next state prediction            
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Compare next states with predicted next state
    Comp_NS_Unif_BW=eq(Next_State,NS_Unif_BW); 
	Comp_NS_Rand_BW=eq(Next_State,NS_Rand_BW);
	Comp_NS_Count_BW=eq(Next_State,NS_Count_BW);	
    Comp_NS_Unif_VT=eq(Next_State,NS_Unif_VT); 
	Comp_NS_Rand_VT=eq(Next_State,NS_Rand_VT);
	Comp_NS_Count_VT=eq(Next_State,NS_Count_VT);
    
    %Compute percent accuracy of predicting next state
    Accuracy_NS_Unif_BW=Comp_NS_Unif_BW;    
    Accuracy_NS_Rand_BW=Comp_NS_Rand_BW;
	Accuracy_NS_Count_BW=Comp_NS_Count_BW;
	Accuracy_NS_Unif_VT=Comp_NS_Unif_VT;    
    Accuracy_NS_Rand_VT=Comp_NS_Rand_VT;
	Accuracy_NS_Count_VT=Comp_NS_Count_VT;
    
    %Store accuracy results in an array 
    Acc_NS_Unif_BW=[Acc_NS_Unif_BW Accuracy_NS_Unif_BW];   
	Acc_NS_Rand_BW=[Acc_NS_Rand_BW Accuracy_NS_Rand_BW];
	Acc_NS_Count_BW=[Acc_NS_Count_BW Accuracy_NS_Count_BW];
    Acc_NS_Unif_VT=[Acc_NS_Unif_VT Accuracy_NS_Unif_VT];   
	Acc_NS_Rand_VT=[Acc_NS_Rand_VT Accuracy_NS_Rand_VT];
	Acc_NS_Count_VT=[Acc_NS_Count_VT Accuracy_NS_Count_VT];
           
end

%Compute Average accuracy for entire states prediction
Average_Acc_all_Unif_BW=mean(Acc_all_Unif_BW);
Average_Acc_all_Rand_BW=mean(Acc_all_Rand_BW);
Average_Acc_all_Count_BW=mean(Acc_all_Count_BW);
Average_Acc_all_Unif_VT=mean(Acc_all_Unif_VT);
Average_Acc_all_Rand_VT=mean(Acc_all_Rand_VT);
Average_Acc_all_Count_VT=mean(Acc_all_Count_VT);

%Compute Average accuracy for current state prediction
Average_Acc_CS_Unif_BW=mean(Acc_CS_Unif_BW)*100;
Average_Acc_CS_Rand_BW=mean(Acc_CS_Rand_BW)*100;
Average_Acc_CS_Count_BW=mean(Acc_CS_Count_BW)*100;
Average_Acc_CS_Unif_VT=mean(Acc_CS_Unif_VT)*100;
Average_Acc_CS_Rand_VT=mean(Acc_CS_Rand_VT)*100;
Average_Acc_CS_Count_VT=mean(Acc_CS_Count_VT*100);

%Compute Average accuracy for next state prediction
Average_Acc_NS_Unif_BW=mean(Acc_NS_Unif_BW)*100;
Average_Acc_NS_Rand_BW=mean(Acc_NS_Rand_BW)*100;
Average_Acc_NS_Count_BW=mean(Acc_NS_Count_BW)*100;
Average_Acc_NS_Unif_VT=mean(Acc_NS_Unif_VT)*100;
Average_Acc_NS_Rand_VT=mean(Acc_NS_Rand_VT)*100;
Average_Acc_NS_Count_VT=mean(Acc_NS_Count_VT)*100;


%Store average values for all experiments in single array
Acc(1,:)=["AS" Average_Acc_all_Count_BW Average_Acc_all_Count_VT Average_Acc_all_Rand_BW Average_Acc_all_Rand_VT Average_Acc_all_Unif_BW Average_Acc_all_Unif_VT];
Acc(2,:)=["CS" Average_Acc_CS_Count_BW Average_Acc_CS_Count_VT Average_Acc_CS_Rand_BW Average_Acc_CS_Rand_VT Average_Acc_CS_Unif_BW Average_Acc_CS_Unif_VT];
Acc(3,:)=["NS" Average_Acc_NS_Count_BW Average_Acc_NS_Count_VT Average_Acc_NS_Rand_BW Average_Acc_NS_Rand_VT Average_Acc_NS_Unif_BW Average_Acc_NS_Unif_VT];
end