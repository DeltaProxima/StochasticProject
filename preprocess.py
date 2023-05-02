import pandas as pd
import numpy as np

def preprocess(data,TrData_Percent):
    
   TrData_Percent = TrData_Percent/100
   _,[L1,L2,L3,L4,L5,L6] = np.unique(data[:,9], return_counts=True)

   Temp=[np.floor(TrData_Percent*L1), np.floor(TrData_Percent*L2), np.floor(TrData_Percent*L3), np.floor(TrData_Percent*L4), np.floor(TrData_Percent*L5), np.floor(TrData_Percent*L6)]
   
   Cut = np.array([Temp[0], L1, L1 + Temp[1], L1 + L2, L1 + L2 + Temp[2], L1 + L2 + L3, L1 + L2 + L3 + Temp[3],
      L1 + L2 + L3 + L4, L1 + L2 + L3 + L4 + Temp[4], L1 + L2 + L3 + L4 + L5, L1 + L2 + L3 + L4 + L5 + Temp[5]], dtype=int)


   # Extract Training dataset
   Training_Data = np.concatenate((data[:Cut[0], 8:10],
                                    data[Cut[1]+1:Cut[2]+1, 8:10],
                                    data[Cut[3]+1:Cut[4]+1, 8:10],
                                    data[Cut[5]+1:Cut[6]+1, 8:10],
                                    data[Cut[7]+1:Cut[8]+1, 8:10],
                                    data[Cut[9]+1:Cut[10]+1, 8:10]), axis=0)

   # Extract Evaluation dataset
   Evaluation_Data = np.concatenate((data[Cut[0]+1:Cut[1]+1, 8:10],
                                    data[Cut[2]+1:Cut[3]+1, 8:10],
                                    data[Cut[4]+1:Cut[5]+1, 8:10],
                                    data[Cut[6]+1:Cut[7]+1, 8:10],
                                    data[Cut[8]+1:Cut[9]+1, 8:10],
                                    data[Cut[10]+1:, 8:10]), axis=0)
   return [Training_Data, Evaluation_Data]
