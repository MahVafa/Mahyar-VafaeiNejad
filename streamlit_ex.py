import streamlit as st


st.title("Simple Form with Streamlit")

with st.form(key='simple_form'):
   
    textbox_1 = st.text_input("Enter your first text")
    textbox_2 = st.text_input("Enter your second text")
    
    
    submit_button = st.form_submit_button("Submit")
    
    if submit_button:
        st.write(f"First Text: {textbox_1}")
        st.write(f"Second Text: {textbox_2}")
