#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Streamlit app for querying the knowledge graph system

Run with: streamlit run streamlit_app.py
"""
import streamlit as st
import asyncio
from api_main import orchestrate, Question
import time

# Page configuration
st.set_page_config(
    page_title="Knowledge Graph Query System",
    page_icon="📊",
    layout="wide"
)

# Custom CSS for better styling
st.markdown("""
    <style>
    .main-header {
        font-size: 2.5rem;
        font-weight: bold;
        color: #1f77b4;
        margin-bottom: 1rem;
    }
    .query-section {
        background-color: #f0f2f6;
        padding: 1.5rem;
        border-radius: 10px;
        margin-bottom: 2rem;
    }
    .result-section {
        background-color: #ffffff;
        padding: 1.5rem;
        border-radius: 10px;
        border: 1px solid #e0e0e0;
        margin-top: 1rem;
    }
    .success-box {
        background-color: #d4edda;
        color: #155724;
        padding: 1rem;
        border-radius: 5px;
        border: 1px solid #c3e6cb;
    }
    .error-box {
        background-color: #f8d7da;
        color: #721c24;
        padding: 1rem;
        border-radius: 5px;
        border: 1px solid #f5c6cb;
    }
    </style>
""", unsafe_allow_html=True)

# Title
st.markdown('<div class="main-header">📊 Knowledge Graph Query System</div>', unsafe_allow_html=True)
st.markdown("Ask questions about Indian economic data including GDP, IIP, CPI, and more.")

# Initialize session state
if 'query_history' not in st.session_state:
    st.session_state.query_history = []

# Sidebar for history
with st.sidebar:
    st.header("📝 Query History")
    if st.session_state.query_history:
        for idx, query in enumerate(reversed(st.session_state.query_history[-10:]), 1):
            if st.button(f"{idx}. {query[:50]}...", key=f"history_{idx}"):
                st.session_state.current_query = query
    else:
        st.info("No queries yet. Start asking questions!")

# Query input section
st.markdown('<div class="query-section">', unsafe_allow_html=True)
st.header("💬 Enter Your Question")

# Use session state to preserve query if selected from history
query_text = st.text_area(
    "Question:",
    value=st.session_state.get('current_query', ''),
    height=100,
    placeholder="e.g., What is the GDP growth rate in India for the last 5 years?",
    key="query_input"
)

submit_button = st.button("🔍 Submit Query", type="primary", use_container_width=True)
st.markdown('</div>', unsafe_allow_html=True)

# Process query
if submit_button and query_text.strip():
    # Clear previous results
    st.session_state.current_query = query_text.strip()
    
    # Add to history
    if query_text.strip() not in st.session_state.query_history:
        st.session_state.query_history.append(query_text.strip())
    
    # Show loading spinner
    with st.spinner("Processing your query... This may take a moment."):
        try:
            # Create Question object
            question = Question(question=query_text.strip())
            
            # Run async orchestrate function
            result = asyncio.run(orchestrate(question))
            
            # Display results
            st.markdown('<div class="result-section">', unsafe_allow_html=True)
            
            if result.get("success", False):
                data = result.get("data", {})
                
                # Success indicator
                st.markdown('<div class="success-box">✅ Query processed successfully</div>', unsafe_allow_html=True)
                
                # Display suggested answer
                st.header("📄 Suggested Answer")
                suggested_answer = data.get("suggested_answer", "N/A")
                
                # Render markdown if it contains markdown
                if isinstance(suggested_answer, str) and ("**" in suggested_answer or "|" in suggested_answer):
                    st.markdown(suggested_answer)
                else:
                    st.write(suggested_answer)
                
                # Confidence and timing
                col1, col2 = st.columns(2)
                with col1:
                    confidence = data.get("confidence", "N/A")
                    st.metric("Confidence", confidence)
                with col2:
                    total_time = data.get("total_time", 0)
                    st.metric("Processing Time", f"{total_time:.2f} seconds")
                
                # Additional information in expanders
                with st.expander("📋 Query Details"):
                    st.write(f"**Original Query:** {data.get('query', 'N/A')}")
                    st.write(f"**Rephrased Query:** {data.get('rephrased_query', 'N/A')}")
                    if data.get('sql_queries'):
                        st.write(f"**SQL Queries:** {data.get('sql_queries', 'N/A')}")
                
                # URLs and References
                urls = data.get("urls", [])
                refs = data.get("references", [])
                
                if urls or refs:
                    with st.expander("🔗 URLs and References"):
                        if urls:
                            st.write("**URLs:**")
                            for url in urls:
                                if url and url != "N/A":
                                    st.write(f"- {url}")
                        if refs:
                            st.write("**References:**")
                            for ref in refs:
                                if ref and ref != "N/A":
                                    st.write(f"- {ref}")
                
                # Token usage
                with st.expander("🔢 Token Usage"):
                    input_tokens = result.get("total_input_tokens", {})
                    output_tokens = result.get("total_output_tokens", {})
                    
                    if input_tokens or output_tokens:
                        col1, col2 = st.columns(2)
                        with col1:
                            st.write("**Input Tokens:**")
                            for model, count in input_tokens.items():
                                st.write(f"- {model}: {count:,}")
                        with col2:
                            st.write("**Output Tokens:**")
                            for model, count in output_tokens.items():
                                st.write(f"- {model}: {count:,}")
                    else:
                        st.info("No token usage data available")
                
                # Context information
                context = data.get("context", "")
                if context and context != "N/A":
                    with st.expander("📝 Context"):
                        st.write(context)
                        
            else:
                # Error indicator
                st.markdown('<div class="error-box">❌ Query processing failed</div>', unsafe_allow_html=True)
                
                data = result.get("data", {})
                st.error(f"**Error:** {data.get('suggested_answer', 'Unknown error')}")
                
                if data.get("context"):
                    st.warning(f"**Context:** {data.get('context')}")
                
                st.write(f"**Query:** {data.get('query', 'N/A')}")
                st.write(f"**Total Time:** {data.get('total_time', 0):.2f} seconds")
            
            st.markdown('</div>', unsafe_allow_html=True)
            
        except Exception as e:
            st.error(f"An error occurred: {str(e)}")
            st.exception(e)
elif submit_button and not query_text.strip():
    st.warning("Please enter a question before submitting.")

# Footer
st.markdown("---")
st.markdown(
    "<div style='text-align: center; color: #666;'>Knowledge Graph Query System | Indian Economic Data</div>",
    unsafe_allow_html=True
)

