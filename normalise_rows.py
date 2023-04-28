
import numpy as np

def normalise_rows(A_Old, Eps):
    
    N= A_Old.shape[0]  # number of rows

    A_New = np.copy(A_Old)

    # For negative values, shift all values by magnitude of minimum value
    if np.any(A_Old < 0):
        A_New = A_Old - np.min(A_Old)

    # Replace zero with small value
    A_New[A_New == 0] = Eps

    # Normalize rows to sum up to 1
    row_sums = np.sum(A_New, axis=1)
    row_sums[row_sums == 0] = 1  # avoid division by zero
    A_New = A_New / row_sums[:, np.newaxis]

    # If any row sums are greater than 1, re-normalize
    row_sums = np.sum(A_New, axis=1)
    mask = row_sums > 1
    A_New[mask, :] = A_New[mask, :] / row_sums[mask, np.newaxis]

    return A_New