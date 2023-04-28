import numpy as np

def string_num(Data1):
    len_data1 = len(Data1)
    Data2 = np.zeros((len_data1, 2))

    for i in range(len_data1):
        for j in range(2):
            Data2[i, j] = int(Data1[i, j])

    return Data2
