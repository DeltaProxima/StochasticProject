import streamlit as st
import numpy as np
import pandas as pd
import altair as alt

def plot_single_graphs(data_dict):
    data_list=[['All States']['Current State']['Next State']]
    for init_type in data_dict:
        st.write(f"For the {init_type} initialization:")
        st.write("The average accuracy for prediction of sequence of all states is: ",data_dict[init_type]['All States'])
        st.write("The average accuracy for prediction of current state is: ",data_dict[init_type]['Current State'])
        st.write("The average accuracy for prediction of next state is: ",data_dict[init_type]['Next State'])
        st.write('\n')
        data_list[0].append(data_dict[init_type]['All States'])
        data_list[1].append(data_dict[init_type]['Current State'])
        data_list[2].append(data_dict[init_type]['Next State'])
    st.write("The following bar chart compares the different types of accuracies for different types of initializations:")
    chart_data = pd.DataFrame(data_list) 
    source=pd.melt(chart_data, id_vars=['Initialization_Type'])

    chart=alt.Chart(source).mark_bar(strokeWidth=100).encode(
        x=alt.X('variable:N', title="", scale=alt.Scale(paddingOuter=0.5)),
        y='value:Q',
        color='variable:N',
        column=alt.Column('Initialization_Type:N', title="", spacing =0),
    ).properties( width = 300, height = 300, ).configure_header(labelOrient='bottom').configure_view(
        strokeOpacity=0)

    st.altair_chart(chart)
    return


