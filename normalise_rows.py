import numpy as np

def normalise_rows(A_Old, Eps):
    # number of rows
    N, _ = A_Old.shape

    # create a copy of A_Old
    A_New = A_Old.copy()

    # For negative values, shift all values by the magnitude of the minimum value
    if np.sum(A_Old<0) > 0:
        A_New = A_Old - np.min(A_Old)

    # Number of elements with zeros
    if np.sum(A_New == 0) > 0:
        A_New[np.where(A_New == 0)] = Eps  # replace zero with small value
        A_New = A_New / np.sum(A_New, axis=1, keepdims=True)

    # Normalize rows
    for i in range(N):
        if np.sum(A_New[i, :]) > 0:
            A_New[i, :] = A_New[i, :] / np.sum(A_New[i, :])

    return A_New
