# Meta-analysis of Schizophrenia and Suicidality  
*A reproducible workflow for literature screening, effect extraction, and random-effects meta-analysis*

This repository contains a curated and fully reproducible workflow for a systematic review and meta-analysis examining **risk factors for suicidality among individuals with schizophrenia**.  
The project was conducted as part of my research work at **Vanderbilt University Medical Center, Department of Biostatistics** (PI: Dr. Jinyuan Liu) and contributed to an ongoing manuscript.

---

## 📌 Project Overview

Individuals with schizophrenia face markedly elevated risk of suicidal ideation, suicide attempts, and suicide death.  
To better understand these risks, I performed:

- Systematic literature retrieval (≈ **2050** PubMed records)
- Two-stage screening (title/abstract → full text)
- Manual extraction of **effect sizes (OR/HR)**, 95% CIs, SEs, and p-values
- Categorization of risk factors into major domains (demographics, psychopathology, social support, hospitalization history, pharmacotherapy, etc.)
- Generation of **random-effects meta-analysis models** using the `metafor` R package
- Visualization via **forest plots** and **PRISMA flowchart**

This repository presents a cleaned subset of the workflow and code used to generate the core analytical outputs.

---

## 📂 Repository Structure

Meta-analysis_Schizophrenia_Suicidality/
│
├── data/
│   ├── systematic_review_extraction_sheet.xlsx    # Extracted effect sizes for included studies
│   └── example_input.csv                          # Demo dataset used for running the template code
│
├── code/
│   └── meta_suicide_forestplot_code.R             # Reproducible forest plot + meta-analysis script
│
├── outputs/
│   ├── forest_plots/                              # Exported forest plots for each risk factor category
│   ├── summaries/                                 # Model summaries (tau^2, I^2, pooled HR/OR)
│   └── prisma_flowchart/                          # PRISMA diagram (screening workflow)
│
└── README.md

---

## 🔍 Methodology

### **1. Literature Search Strategy**
Following **PRISMA guidelines** and drawing on methods from prior psychiatric meta-analyses :contentReference[oaicite:2]{index=2}, I searched PubMed using combinations of:

- **Subject headings**: schizophrenia, schizoaffective psychosis, schizophreniform disorder, suicide
- **Text words**: SCHIZOPHREN*, SUICID*, RISK*, FOLLOW-UP, COHORT STUD*, CASE CONTROL STUD*

Initial retrieval: **2050** records.

---

### **2. Screening Procedure**
A two-step screening was performed:

1. **Title & abstract screening** → 1977 excluded  
2. **Full-text assessment** → 42 excluded  
3. **Included in meta-analysis**: **31** studies

A PRISMA-style flowchart summarizing these stages is available under:
outputs/prisma_flowchart/prisma_flowchart.png

(No full-text PDFs or copyrighted materials are included in this repository)

---

### **3. Effect Size Extraction**
From each eligible study, the following were extracted:

- Effect measure: **Hazard Ratio (HR)** or **Odds Ratio (OR)**
- 95% confidence interval
- Standard error (computed when not reported)
- Sample size and design notes
- Risk factor domain

These extracted values are stored in:
data/systematic_review_extraction_sheet.xlsx

---

### **4. Meta-analysis Model**
The `metafor::rma()` random-effects model (REML) was used to compute:

- Pooled HR/OR  
- 95% CI  
- Prediction interval  
- Study-level weights  
- Heterogeneity statistics: **τ²**, **I²**, Q-test  

Summaries are exported into:
outputs/summaries/

---

## 📊 Key Outputs

### ✔ Forest Plots  
Forest plots for each risk factor domain (e.g., demographics, hospitalization, pharmacotherapy, social support) are located in:
outputs/forest_plots/

Each file follows naming conventions such as:
forest_plot_demographics_gender_HR.png
forest_plot_pharmacotherapy_aripiprazole.png

### ✔ PRISMA Flowchart  
A professionally formatted PRISMA diagram summarizing the screening stages is available at:
outputs/prisma_flowchart/prisma_flowchart.png

---

## 🧪 Reproducing the Analysis

To reproduce the forest plot pipeline, run:

```r
source("code/meta_suicide_forestplot_code.R")
```

The script:

- Reads data/example_input.csv
- Fits a random-effects meta-analysis
- Saves a PDF forest plot
- Outputs a CSV summary of model estimates

---

👤 Author

Jiawei (Blake) Wang
Undergraduate Research Assistant
Vanderbilt University Medical Center — Department of Biostatistics
Email: jiawei.wang.1@vanderbilt.edu

GitHub: github.com/BlakeWang177
LinkedIn: linkedin.com/in/jw147

This work forms part of an ongoing manuscript in preparation:
Liu, J., Wang, J. Risk Factors for Suicide in Schizophrenia: A Systematic Review and Future Directions.

---

📘 Citation

If using components of this repository, please cite:

Wang, J. (n.d.). Meta-analysis of Schizophrenia and Suicidality.  
Vanderbilt University Medical Center, Department of Biostatistics.
