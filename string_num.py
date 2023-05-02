import numpy as np

def string_num(Data1):
    len_ = len(Data1)
    Data2 = np.zeros_like(Data1, dtype=np.float64)
    
    for i in range(len_):
        for j in range(2):
            Data2[i,j] = float(Data1[i,j])
    
    return Data2
