import numpy as np

#obs: a list or array of observed symbols
#A: the transition matrix, a numpy array of shape (N,N) where N is the number of states
#B: the emission matrix, a numpy array of shape (N,M) where M is the number of possible observations
#pi: the initial state probabilities, a numpy array of shape (N,)


def hmmviterbi(obs, A, B, pi):
    N = A.shape[0]
    T = len(obs)
    path = np.zeros(T, dtype=int)
    delta = np.zeros((N, T))
    delta[:, 0] = pi * B[:, obs[0]]
    for t in range(1, T):
        for i in range(N):
            delta[i, t] = np.max(delta[:, t-1] * A[:, i]) * B[i, obs[t]]
            path[t] = np.argmax(delta[:, t-1] * A[:, i])
    return (path, np.max(delta[:, -1]))
 
 #It returns a tuple containing:

#path: a list of the most likely state sequence, where each element is an integer representing the state at that time step
#prob: the probability of the most likely state sequence