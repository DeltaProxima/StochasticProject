import streamlit as st
import numpy as np
from scipy.io import loadmat
import pandas as pd
from main import train_test_model

def main_demo():    
    #uploading csv file
    uploaded_file = st.sidebar.file_uploader("Choose a file")
    if uploaded_file is not None:
        data_set = pd.read_csv(uploaded_file,header=None)
        data_frames = pd.DataFrame(data_set)
        st.sidebar.success('File successfully uploaded!!', icon="🎉")
        print(data_frames.head())
    #select type of initialization from count based, random or uniform
    init_type = st.sidebar.selectbox("Select type of initialization",("Count Based","Random","Uniform"))
    #enter number of interations
    Maxiter = st.sidebar.slider("Enter number of iterations",min_value=1,max_value=1000,value=500,step=50)
    #enter convergence threshold
    Tol = 1e-6
    #enter percentage of training data
    TrData_Percent = st.sidebar.slider("Enter percentage of training data",min_value=1,max_value=100,value=70,step=5)
    #run button
    btn = st.sidebar.button("Run")
    if btn:
        btn = False
        if uploaded_file is not None:
            train_test_model(data_frames,init_type,Maxiter,Tol,TrData_Percent)
        else:
            st.warning('No file uploaded!!', icon="⚠️")


    #Explaining the alerts and states in the dataset
    st.header("The structure of the Dataset")
    st.write("We have used the CSE-CIC-IDS2018 Dataset for training and testing our hmm")
    st.write("It comprises seven modern attack scenarios over a large network for 10 days.The attack scenarios are Brute-force, Heartbleed, Botnet, DoS,DDoS, Web attacks, and infiltration of the network from inside.")

    st.write("To acquire observations from this dataset, Snort version 2.9.11.1 was used to first obtain alerts and later process these alerts before feeding into an HMM.")

    st.write("In the data we have 21 different kinds of alerts (emissions) observed. The different alerts observed are shown in the table below: ")

    #displaying the alerts
    alert_names = np.array(["Consecutive TCP small segments exceeding threshold","(http_inspect) NO CONTENT-LENGTH OR TRANSFER-ENCODING IN HTTP RESPONSE","Reset outside window","(spp_ssh) Protocol mismatch","TCP Timestamp is missing","(portscan) TCP Portscan","(http_inspect) TOO MANY PIPELINED REQUESTS", "(http_inspect) LONG HEADER","(portscan) UDP Distributed Portscan","(spp_sdf) SDF Combination Alert","(http_inspect) UNESCAPED SPACE IN HTTP URI","Bad segment, adjusted size <= 0","(portscan) TCP Portsweep","(portscan) UDP Portsweep","SENSITIVE-DATA Email Addresses","(portscan) UDP Portscan","(http_inspect) NON-RFC DEFINED CHAR","(spp_reputation) packets blacklisted","(portscan) TCP Distributed Portscan","MALWARE-CNC Win.Trojan.ZeroAccess outbound connection","MALWARE-CNC Win.Trojan.ZeroAccess outbound connection"])

    states_names = np.array(["Potentially Bad Traffic","Unknown Traffic","Detection of a non-standard protocol or event","Attempted Information Leak","Senstive Data","A Network Trojan was detected"])

    st.table(data={"Alerts":alert_names})
    st.write("\nThe HMM Model \n")
    st.image(r"hmm_image.png",width=800)
    st.write("\n")
    st.write("The HMM that we trained has 6 hidden states that indicated the different scenarios in the network. The different states are shown in the table below: ")
    st.table(data={"States":states_names})

    #displaying the uploaded file
    if uploaded_file is not None:
        st.write("The File you uploaded is")
        st.write("The number of rows in the file are: ",data_frames.shape[0])
        st.write(data_frames.head())      


st.set_page_config(
    page_title="EE336 Project Presentation",
    page_icon="🐱‍💻",
)
st.title("Attack Detection using HMM")
st.sidebar.markdown("Select the page to view")
page_names_to_funcs = {
    "Main Page": main_demo
}

selected_page = st.sidebar.selectbox("Select a page", page_names_to_funcs.keys())
page_names_to_funcs[selected_page]()