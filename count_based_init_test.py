import numpy as np
from scipy.io import loadmat
import pandas as pd
from preprocess import preprocess
from filter_alerts import filter_alerts
from string_num import string_num
from hmmtrain import hmmtrain
from hmmlearn import hmm
from normalise_rows import normalise_rows
from evaluate import evaluate
from count_based import count_based
# Maxiter=500; #Maximum number of iterations
# Tol=1e-6; #Convergence threshold
# TrData_Percent=70; #Training data as a percentage i.e 70 represents 70# training data
data_set = pd.read_csv('Data.csv', header=None)
data_frames = pd.DataFrame(data_set)
# print(data_frames[3].value_counts())
def train_test_model(data_frames,init_type,Maxiter,Tol,TrData_Percent):
    Eps=1e-10; #Small number to assign to zeros in matrices

    # data_set = pd.read_csv('Data.csv', header=None)
    # data_frames = pd.DataFrame(data_set)
    # covert the 9th and 10th columns into integer and decrement the value by 1 after which convert it back to string
    data_frames[8] = data_frames[8].astype(int) - 1
    data_frames[9] = data_frames[9].astype(int) - 1
    print(data_frames.head())

    data = np.array(data_frames.values)

    #Part 3: Preprocessing
    #Split Dataset into training and evaluation
    [Training_Data1, Evaluation_Data1] = preprocess(data,TrData_Percent)

    #Remove non common observations 
    [Obs_Remove,Training_Data,Evaluation_Data]=filter_alerts(Training_Data1,Evaluation_Data1)



    #create sequence and states row matrices
    Training_Data = np.array(string_num(Training_Data),dtype=np.int32)
    Evaluation_Data = np.array(string_num(Evaluation_Data),dtype=np.int32)
    Training_Seq = Training_Data[:, 0]
    Training_States = Training_Data[:, 1]
    Evaluation_Seq = Evaluation_Data[:, 0]
    Evaluation_States = Evaluation_Data[:, 1]

    #Part 4: Training
    M=int(max(Training_Seq))#Number of observations in Training Data
    Len=len(Training_Data)
    N=int(max(Training_States)) #Number of states
    print(N,M)    

    #1. Baum Welch Training
    #1A: Count Based initialization
    A = count_based(M, N, Len, Training_Data)[0]
    print(A,end='\n\n')
    B = count_based(M, N, Len, Training_Data)[1]
    print(B,end='\n\n')

    print('Training 1 of 2: BW Uniform, Random, and Count')

    model = hmm.CategoricalHMM(n_components=N, algorithm='viterbi', n_iter=Maxiter, tol=Tol)
    model.startprob_ = np.ones(N) / N
    model.transmat_ = A
    model.emissionprob_ = B
    traning_seq_modified=Training_Seq.reshape(-1,1)
    model.fit(traning_seq_modified)
    EstA = model.transmat_
    EstB = model.emissionprob_
    print('Transition Matrix\n',EstA)
    print('Emission Matrix\n',EstB)
    A_normalized =normalise_rows(EstA,Eps)
    B_normalized =normalise_rows(EstB,Eps)

    window_size = 150
    avg_acc_all_states, avg_acc_curr_state, avg_acc_next_state,num_experiments,start_points = evaluate(model,window_size, Evaluation_Seq, Evaluation_States, A_normalized,B_normalized)
    print(avg_acc_all_states, avg_acc_curr_state, avg_acc_next_state)

    return model,avg_acc_all_states, avg_acc_curr_state, avg_acc_next_state,num_experiments,start_points

train_test_model(data_frames,'count',500,1e-6,70)
