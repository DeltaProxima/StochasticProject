import numpy as np

def hmmtrain(transition,emission,test_sequence,Maxiter):
    
    #generating initial probabilities


    #defining states and sequence symbols
    states = [1,2,3,4,5,6]
    states_dic = {1:0,2:1,3:2,4:3,5:4,6:5}
    #21 symbols
    sequence_syms = {1:0,2:1, 3:2, 4:3, 5:4, 6:5, 7:6, 8:7,9:8,10:9,11:10,12:11,13:12,14:13,15:14,16:15,17:16,18:17,19:18,20:19,21:20}
    sequence = [1,2, 3, 4, 5, 6, 7, 8,9,10,11,12,13,14,15,16,17,18,19,20,21]


    #probabilities of going to end state
    end_probs = [1/6]*6
    #probabilities of going from start state
    start_probs = [1/6]*6
    


    #function to find forward probabilities
    def forward_probs():
        # node values stored during forward algorithm
        node_values_fwd = np.zeros((len(states), len(test_sequence)))

        for i, sequence_val in enumerate(test_sequence):
            for j in range(len(states)):
                # if first sequence value then do this
                if (i == 0):
                    node_values_fwd[j, i] = start_probs[j] * emission[j, sequence_syms[sequence_val]]
                # else perform this
                else:
                    values = [node_values_fwd[k, i - 1] * emission[j, sequence_syms[sequence_val]] * transition[k, j] for k in
                            range(len(states))]
                    node_values_fwd[j, i] = sum(values)

        #end state value
        end_state = np.multiply(node_values_fwd[:, -1], end_probs)
        end_state_val = sum(end_state)
        print(end_state_val)
        return node_values_fwd, end_state_val



    #function to find backward probabilities
    def backward_probs():
        # node values stored during forward algorithm
        node_values_bwd = np.zeros((len(states), len(test_sequence)))

        #for i, sequence_val in enumerate(test_sequence):
        for i in range(1,len(test_sequence)+1):
            for j in range(len(states)):
                # if first sequence value then do this
                if (-i == -1):
                    node_values_bwd[j, -i] = end_probs[j]
                # else perform this
                else:
                    values = [node_values_bwd[k, -i+1] * emission[k, sequence_syms[test_sequence[-i+1]]] * transition[j, k] for k in range(len(states))]
                    node_values_bwd[j, -i] = sum(values)

        #start state value
        start_state = [node_values_bwd[m,0] * emission[m, sequence_syms[test_sequence[0]]] for m in range(len(states))]
        start_state = np.multiply(start_state, start_probs)
        start_state_val = sum(start_state)
        return node_values_bwd, start_state_val


    #function to find si probabilities
    def si_probs(forward, backward, forward_val):

        si_probabilities = np.zeros((len(states), len(test_sequence)-1, len(states)))

        for i in range(len(test_sequence)-1):
            for j in range(len(states)):
                for k in range(len(states)):
                    si_probabilities[j,i,k] = ( forward[j,i] * backward[k,i+1] * transition[j,k] * emission[k,sequence_syms[test_sequence[i+1]]] )/forward_val
        return si_probabilities

    #function to find gamma probabilities
    def gamma_probs(forward, backward, forward_val):

        gamma_probabilities = np.zeros((len(states), len(test_sequence)))

        for i in range(len(test_sequence)):
            for j in range(len(states)):
                #gamma_probabilities[j,i] = ( forward[j,i] * backward[j,i] * emission[j,sequence_syms[test_sequence[i]]] ) / forward_val
                gamma_probabilities[j, i] = (forward[j, i] * backward[j, i]) / forward_val

        return gamma_probabilities



    #performing iterations until convergence

    for iteration in range(Maxiter):

        print('\nIteration No: ', iteration + 1)
        # print('\nTransition:\n ', transition)
        # print('\nEmission: \n', emission)

        #Calling probability functions to calculate all probabilities
        fwd_probs, fwd_val = forward_probs()
        bwd_probs, bwd_val = backward_probs()
        si_probabilities = si_probs(fwd_probs, bwd_probs, fwd_val)
        gamma_probabilities = gamma_probs(fwd_probs, bwd_probs, fwd_val)

        # print('Forward Probs:')
        # print(np.matrix(fwd_probs))
        #
        # print('Backward Probs:')
        # print(np.matrix(bwd_probs))
        #
        # print('Si Probs:')
        # print(si_probabilities)
        #
        # print('Gamma Probs:')
        # print(np.matrix(gamma_probabilities))

        #caclculating 'a' and 'b' matrices
        a = transition
        b = emission

        #'a' matrix
        for j in range(len(states)):
            for i in range(len(states)):
                for t in range(len(test_sequence)-1):
                    a[j,i] = a[j,i] + si_probabilities[j,t,i]

                denomenator_a = [si_probabilities[j, t_x, i_x] for t_x in range(len(test_sequence) - 1) for i_x in range(len(states))]
                denomenator_a = sum(denomenator_a)

                if (denomenator_a == 0):
                    a[j,i] = 0
                else:
                    a[j,i] = a[j,i]/denomenator_a

        #'b' matrix
        for j in range(len(states)): #states
            for i in range(len(sequence)): #seq
                indices = [idx for idx, val in enumerate(test_sequence) if val == sequence[i]]
                numerator_b = sum( gamma_probabilities[j,indices] )
                denomenator_b = sum( gamma_probabilities[j,:] )

                if (denomenator_b == 0):
                    b[j,i] = 0
                else:
                    b[j, i] = numerator_b / denomenator_b


        print('\nMatrix a:\n')
        print(np.matrix(a.round(decimals=4)))
        print('\nMatrix b:\n')
        print(np.matrix(b.round(decimals=4)))

        transition = a
        emission = b

        new_fwd_temp, new_fwd_temp_val = forward_probs()
        print('New forward probability: ', new_fwd_temp_val)
        diff =  np.abs(fwd_val - new_fwd_temp_val)
        print('Difference in forward probability: ', diff)

        print(transition,emission)

        if (diff < 0.0000001):
            break
    
    return transition, emission