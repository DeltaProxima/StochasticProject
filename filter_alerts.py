import numpy as np

def filter_alerts(Tr_Data, Ev_Data):
    # Obtain the unique symbols
    Tr_Data_Obs = np.unique(Tr_Data[:,0])
    Ev_Data_Obs = np.unique(Ev_Data[:,0])
    
    # Get different observations
    Diff1 = np.setdiff1d(Tr_Data_Obs, Ev_Data_Obs)
    Diff2 = np.setdiff1d(Ev_Data_Obs, Tr_Data_Obs)
    Obs_Remove = np.concatenate((Diff1, Diff2)) # Symbols to be removed
    Len = len(Obs_Remove)
    
    # Remove uncommon observations
    for i in range(Len):
        Tr_Data = Tr_Data[Tr_Data[:,0] != Obs_Remove[i], :]
        Ev_Data = Ev_Data[Ev_Data[:,0] != Obs_Remove[i], :]
    
    return Obs_Remove, Tr_Data, Ev_Data
