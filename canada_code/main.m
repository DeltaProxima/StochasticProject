%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Brief Description:     Part 1: Predefined variables
%                               These can be modified accordingly.
%                       Part 2: Loading Dataset
%                               This has been provided to reduce processing time. Both state and observations 
%                               symbols are included in the dataset. 
%                       Part 3: Preprocessing
%                               Some preprocessing is already done on the dataset. For this section, three
%                               processes are made: (1) splitting of dataset into training and evaluation
%                               using sequential sampling, (2) removing non common observations, (3) creating 
%                               sequence and states row matrices.
%                       Part 4: Training 
%                               Training algorithms used are Baum-Welch and Viterbi training. For each 
%                               training technique, the count-based, uniform, and random based initialisation 
%                               techniques have been used.
%                       Part 5: Evaluation
%                               Detection and prediction accuracy have been used. 
%                       Part 6: Plotting results.
%                               Detection of all states (AS), current state (CS), and prediction of next state 
%                               (NS) have been plotted on same bar graph. Results for random initialisation 
%                               vary. Also, normalisation can be excluded i.e in BW. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear;  clc;% clear variables and then clear screen

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Part 1: Predefined Variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Maxiter=500; %Maximum number of iterations
Tol=1e-6; %Convergence threshold
TrData_Percent=70; % Training data as a percentage i.e 70 represents 70% training data
Eps=1e-10;%Small number to assign to zeros in matrices

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Part 2: Load Dataset
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('Dataset.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Part 3: Preprocessing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Split Dataset into training and evaluation
[Training_Data1,Evaluation_Data1]=preprocess(Data_Nodup_ObS,TrData_Percent/100);
%Remove non common observations 
[Obs_Remove,Training_Data,Evaluation_Data]=filter_alerts(Training_Data1,Evaluation_Data1);

%create sequence and states row matrices
Training_Data=string_num(Training_Data); 
Evaluation_Data=string_num(Evaluation_Data);
Training_Seq(1,:)=Training_Data(1:end,1);
Training_States(1,:)=Training_Data(1:end,2);
Evaluation_Seq(1,:)=Evaluation_Data(1:end,1);
Evaluation_States(1,:)=Evaluation_Data(1:end,2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Part 4: Training
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
M=max(Training_Seq);%Number of observations in Training Data
Len=length(Training_Data);
N=max(Training_States); %Number of states    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1. Baum Welch Training                                                                               
%1A:Uniform initialisation 
A_Uniform=1/N*ones(N,N);
B_Uniform=1/M*ones(N,M);
fprintf('Training 1 of 2: BW Uniform,Random and Count\n');
[EstA_Unif_BW, EstB_Unif_BW] = hmmtrain(Training_Seq,A_Uniform,B_Uniform,'ALGORITHM','BaumWelch','Maxiterations',Maxiter,'Tolerance',Tol);
A_Unif_BW=normalise_rows(EstA_Unif_BW,Eps);
B_Unif_BW=normalise_rows(EstB_Unif_BW,Eps);

%1B:Random initialisation
[A_Random,B_Random,~]=initialise_random(M,N);%obtain initial A and B
[EstA_Rand_BW, EstB_Rand_BW] = hmmtrain(Training_Seq,A_Random,B_Random,'ALGORITHM','BaumWelch','Maxiterations',Maxiter,'Tolerance',Tol);    
A_Rand_BW=normalise_rows(EstA_Rand_BW,Eps);%Check if there is state transition of zero and scale
B_Rand_BW=normalise_rows(EstB_Rand_BW,Eps);

%1C:Count based initialisation
[A_Count,B_Count]=count_based(M,N,Len,Training_Data);%obtain initial A and B
[EstA_Count_BW, EstB_Count_BW] = hmmtrain(Training_Seq,A_Count,B_Count,'ALGORITHM','BaumWelch','Maxiterations',Maxiter,'Tolerance',Tol);     
A_Count_BW=normalise_rows(EstA_Count_BW,Eps);
B_Count_BW=normalise_rows(EstB_Count_BW,Eps);    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2.Viterbi Training                                                                               
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%2A:Uniform initialisation 
fprintf('Training Process 2 of 2: VT Uniform,Random and Count\n');
[EstA_Unif_VT, EstB_Unif_VT] = hmmtrain(Training_Seq,A_Uniform,B_Uniform,'ALGORITHM','Viterbi','Maxiterations',Maxiter,'Tolerance',Tol);     
A_Unif_VT=normalise_rows(EstA_Unif_VT,Eps);
B_Unif_VT=normalise_rows(EstB_Unif_VT,Eps);

%2B:Random initialisation
[A_Random,B_Random,~]=initialise_random(M,N);%obtain initial A and B
[EstA_Rand_VT, EstB_Rand_VT] = hmmtrain(Training_Seq,A_Random,B_Random,'ALGORITHM','Viterbi','Maxiterations',Maxiter,'Tolerance',Tol);
A_Rand_VT=normalise_rows(EstA_Rand_VT,Eps);%Check if there is state transition of zero and scale
B_Rand_VT=normalise_rows(EstB_Rand_VT,Eps);

%2C:Count based initialisation
[EstA_Count_VT, EstB_Count_VT] = hmmtrain(Training_Seq,A_Count,B_Count,'ALGORITHM','Viterbi','Maxiterations',Maxiter,'Tolerance',Tol);      
A_Count_VT=normalise_rows(EstA_Count_VT,Eps);
B_Count_VT=normalise_rows(EstB_Count_VT,Eps);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Part 5: Evaluation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('Evaluation Process\n');
Accuracy=["Pred Appr" "BW-Count" "VT-Count" "BW-Random" "VT-Random" "BW-Uniform" "VT-Uniform"];
for Window_Size=150:50:150
Acc=evaluate(Window_Size,Evaluation_Seq,Evaluation_States,A_Unif_BW,B_Unif_BW,A_Rand_BW,B_Rand_BW,A_Count_BW,B_Count_BW,A_Unif_VT,B_Unif_VT,A_Rand_VT,B_Rand_VT,A_Count_VT,B_Count_VT);
   Accuracy=[Accuracy; Acc];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Part 6: Plotting results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%AS, CS, NS and NO Accuracy   
Y=double([Accuracy(2,2:end);Accuracy(3,2:end);Accuracy(4,2:end)]');
bar(Y)
ylabel('Detection and Prediction Accuracy (%)')
xlabel('Training Technique')
No_Results=length(Y);
xticks(1:No_Results)
title('AS and CS Detection, and NS Prediction Performance');
set(gca,'XTickLabel',["Count-BW","Count-VT","Random-BW", "Random-VT", "Uniform-BW","Uniform-VT"]);
xtickangle(45)
legend('AS','CS','NS','Location','northeastoutside')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                              End of Main Program                                        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

