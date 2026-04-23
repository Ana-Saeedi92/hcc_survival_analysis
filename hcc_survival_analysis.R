# ============================================
# HCC Survival Analysis (Clinical Oncology)
# Author: PhD Candidate in Biostatistics
#
# NOTE:
# This project uses a restricted clinical dataset.
# Data are not included in this repository.
# ============================================

library(haven)
library(dplyr)
library(survival)
library(survminer)
library(labelled)
library(readr)
library(scales)
library(stringr)

# Data input (NOT included)
file_path <- "data/HCC_4_6_SASPrep.sas7bdat"
chart_data <- read_sas(file_path)

# Data preprocessing
chart_data <- chart_data %>%
  mutate(
    residual_recurrence = residual_reccurence,
    date_ldt1 = date_LTD1,
    n_hcc_tx_ldt1 = n_hcc_tx_LTD1
  ) %>%
  select(-residual_reccurence, -date_LTD1, -n_hcc_tx_LTD1)

chart_data <- chart_data %>%
  mutate(
    Milan_criteria = factor(Milan_criteria, levels = c(0,1), labels = c("No","Yes")),
    pvtt = factor(pvtt, levels = c(0,1), labels = c("No","Yes")),
    Desc_Salv_Consol = factor(Desc_Salv_Consol,
                              levels = c(1,2),
                              labels = c("Salvage","CMT"))
  )

studyid_wise <- chart_data %>%
  arrange(study_id) %>%
  group_by(study_id) %>%
  slice(1) %>%
  ungroup()

# Local Control
model_set1 <- chart_data %>%
  mutate(
    time_lc_yr = as.numeric(difftime(lc_censor, sbrt_end, units = "days")) / 365,
    resp_fail = if_else(str_to_upper(str_trim(coalesce(resp, ""))) == "CPD", 1, 0)
  )

fit_km <- survfit(Surv(time_lc_yr, resp_fail) ~ Desc_Salv_Consol, data = model_set1)

ggsurvplot(fit_km, risk.table = TRUE, pval = TRUE)

# Overall Survival
model_overall <- studyid_wise %>%
  mutate(
    time_os = as.numeric(os_censor - date_LTD1) / 365,
    status_os = ifelse(os_censor_reason == "died", 1, 0)
  )

fit_os <- survfit(Surv(time_os, status_os) ~ Desc_Salv_Consol,
                  data = model_overall)

ggsurvplot(fit_os, risk.table = TRUE, pval = TRUE)

# Cox Model
cox_model <- coxph(Surv(time_os, status_os) ~ Desc_Salv_Consol,
                   data = model_overall)

summary(cox_model)
