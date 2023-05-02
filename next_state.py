import numpy as np
from hmmlearn import hmm

def predict_next_state(model,curr_state, A, B, old_alerts):
    Prob_Next_Observ = np.dot(A[curr_state, :], B)
    next_alerts = np.argmax(Prob_Next_Observ)
    new_alerts_arr = np.append(old_alerts, next_alerts)
    new_alerts_arr = new_alerts_arr.reshape(-1, 1)
    next_states = model.predict(new_alerts_arr)
    next_state = next_states[-1]
    return next_state
