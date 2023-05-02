import numpy as np

def count_based(M, N, L, Data):
    # Obtain initial A
    A_Count = np.zeros((N, N))
    A_Count[:, 0] = 0.8
    A_Count[:, 1:] = 0.2 / N

    # Compute initial B
    B_Count = np.zeros((N, M))
    for i in range(N):
        for j in range(M):
            count = 0
            for m in range(L):
                if Data[m, 0] == j+1 and Data[m, 1] == i+1:
                    count += 1
            B_Count[i, j] = count

    # Normalize values in B so that the sum of observations per state is unity
    for i in range(N):
        B_Count[i, :] = 1 / np.sum(B_Count[i, :]) * B_Count[i, :]

    return A_Count, B_Count
