import numpy as np

def initialise_random(M, N):
    A_Random = np.random.rand(N, N)
    B_Random = np.random.rand(N, M)
    Pi_Random = np.random.rand(1, N)

    # Modify A, B and Pi so that sum of each row is unity
    Pi_Random = Pi_Random / np.sum(Pi_Random)
    A_Random = A_Random / np.sum(A_Random, axis=1)[:, np.newaxis]
    B_Random = B_Random / np.sum(B_Random, axis=1)[:, np.newaxis]

    return A_Random, B_Random, Pi_Random
