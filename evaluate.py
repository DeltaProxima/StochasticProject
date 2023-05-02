import numpy as np
from hmmlearn import hmm
from next_state import predict_next_state

def evaluate(model,window_size, Evaluation_Seq, Evaluation_States, A_normalized,B_normalized):
    # Initialise arrays to store accuracy values for all states
    acc_all_states = []

    # Initialise arrays to store accuracy values for current state
    acc_curr_state = []

    # Initialise arrays to store accuracy values for Next state
    acc_next_state = []

    start_points = []  # Array to store index
    start = 0
    stop = start + window_size - 1
    length = len(Evaluation_Seq)

    # Perform several tests
    num_experiments = 0
    while stop < length-1:
        num_experiments += 1
        stop = start + window_size - 1  # stop index
        start_points.append(start)
        alerts_observed = Evaluation_Seq[start:stop + 1]  # Observation row matrix
        states_actual = Evaluation_States[start:stop + 1]
        current_state = Evaluation_States[stop]
        next_state_actual = Evaluation_States[stop + 1]
        next_alert = Evaluation_Seq[stop + 1]
        alerts_observed_modified=alerts_observed.reshape(-1,1)
        # New start and stop point
        start += 1
        stop = start + window_size - 1

        # Decode using viterbi to determine state
        # Method 1: Use three standard techniques for BW
        # 1A: Uniform initialization
        states_predicted = model.predict(alerts_observed_modified)
        predicted_next_state = predict_next_state(model,states_predicted[-1], A_normalized, B_normalized, alerts_observed)

        curr_acc_all_states = 100*np.sum(states_actual == states_predicted) / len(states_actual)

        acc_all_states.append(curr_acc_all_states)

        #accuracy for current state
        curr_acc_curr_state = 100*np.sum(current_state == states_predicted[-1])
        acc_curr_state.append(curr_acc_curr_state)

        #accuracy for next state
        curr_acc_next_state = 100*np.sum(next_state_actual == predicted_next_state)
        print(next_state_actual,predicted_next_state)

        acc_next_state.append(curr_acc_next_state)

    # Calculate average accuracy for all states
    avg_acc_all_states = np.mean(acc_all_states)    
    avg_acc_curr_state = np.mean(acc_curr_state)
    avg_acc_next_state = np.mean(acc_next_state)

    return avg_acc_all_states, avg_acc_curr_state, avg_acc_next_state,num_experiments,start_points


