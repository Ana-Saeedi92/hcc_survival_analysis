# HCC Survival Analysis (R)

## Overview
This project presents a comprehensive survival analysis of patients with **hepatocellular carcinoma (HCC)** treated with **stereotactic body radiation therapy (SBRT)**.

The goal is to evaluate **local control and overall survival outcomes**, identify prognostic factors, and compare treatment subgroups using time-to-event methods.

## Methods
The analysis follows a structured clinical research workflow:

- Descriptive statistics for baseline characteristics  
- Kaplan–Meier estimation of:
  - Local control  
  - Overall survival  
- Log-rank tests for group comparisons  
- Cox proportional hazards models (univariate and multivariable)  
- Restricted Mean Survival Time (RMST) for robust survival comparison  
- Subgroup analyses (e.g., treatment interval timing)  


## code structure
├── hcc_survival_analysis.R        # streamlined script with main analyses
├── hcc_workflow.Rmd              # full reproducible workflow
├── hcc_workflow_report.pdf  # knitted report with results and outputs


## Data Availability
he dataset used in this analysis is not publicly available due to patient privacy and institutional restrictions.

However:

All analysis code is fully reproducible
Variable names and workflow reflect real clinical data
The pipeline can be applied to similar survival datasets
