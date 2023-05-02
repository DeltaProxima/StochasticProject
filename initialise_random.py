import numpy as np

def initialise_random(M, N):
    A_Random = np.random.rand(N, N)
    B_Random = np.random.rand(N, M)
    Pi_Random = np.random.rand(1, N)
    
    # Modify A, B and Pi so that sum of each row is unity
    Pi_Random = (1 / np.sum(Pi_Random)) * Pi_Random
    
    for i in range(N):
        A_Random[i, :] = (1 / np.sum(A_Random[i, :])) * A_Random[i, :]
        B_Random[i, :] = (1 / np.sum(B_Random[i, :])) * B_Random[i, :]
    
    return A_Random, B_Random, Pi_Random