# Contemporary Sequential Network Attacks Detection and Prediction Using Hidden Markov Model
This code reproduces the results for the research paper titled **Contemporary Sequential Network Attacks Prediction Using Hidden Markov Model** by Timothy Chadza, Konstantinos Kyriakopoulos & Sangarapillai Lambotharan presented at the 17th International Conference on Privacy, Security and Trust (PST), IEEE, Fredericton, NB, Canada, 2019. If you use this code, please, cite the above article.

To run this code, simply, run the `main.m` MATLAB script. 


## Included Materials

The following briefly describes the various files included in this folder:

* `count_based.py`: obtains the count-based parameters for HMM initialisation.
* `evaluate.py`: computes the detection and prediction accuracy.
* `filter_alerts.py`: removes non-common observations to ensure similar unique observations in both training and evaluation dataset.
* `initialise_random.py`: obtains initial random HMM parameters.
* `main.py`: Main file implementing all the experiments. The file plots the results for the detection of all states (AS), the current state (CS) and the next state (NS).
* `next_state.py`: computes the next state. First, the next observation is obtained and is then appended to the observation sequence. Thereafter, the Viterbi decoding is applied to estimate the next state.
* `normalise_rows.py`: assigns small values to zeroes and normalises the rows of HMM parameters so that each row sums to unity. Also, if negative parameters are obtained, they are scaled to start from zero and then normalised.
* `preprocess.py`: divides the dataset into training and evaluation using the sequential sampling. The dataset has already been processed to reduce the run time, otherwise, the essential fields ought to be extracted from the Snort IDS alerts then remove duplicates and assign symbols for both states and observations. 
* `string_num.py`: converts a data string to a number
* `Dataset.mat`: stores the Snort alerts including the assigned symbols and states. 

### Authors
Timothy Chadza, Konstantinos Kyriakopoulos & Sangarapillai Lambotharan 

Wolfson School of Mechanical, Electrical and Manufacturing Engineering,
Loughborough University, Loughborough, UK
