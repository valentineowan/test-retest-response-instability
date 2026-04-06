# Test–Retest Reliability Simulation and Response Instability Analysis
## Project Description

This repository contains a fully reproducible simulation study investigating how respondent-level variation affects test–retest reliability estimates. The analysis demonstrates that temporal differences in responses may arise not only from measurement error but also from response instability, and presents simple procedures for detecting and managing such variation.

The workflow includes data generation, reliability estimation, computation of the Reliable Change Index (RCI), classification of respondents, and application of correction methods (exclusion, weighting, and adjustment).

## Methods Summary

- Simulation of test–retest data under controlled conditions  
- Introduction of respondent patterns:
  - Consistent responses  
  - Systematic bias  
  - Temporal inconsistency  
- Estimation of test–retest reliability using Pearson correlation  
- Computation of the Reliable Change Index (RCI)  
- Classification based on temporal consistency thresholds  
- Application of correction methods:
  - Exclusion of inconsistent cases  
  - Weighting based on instability  
  - Adjustment of responses
    
3. Run the entire script

All outputs will be automatically saved in the `project_outputs` folder.

## Key Outputs

The script generates:

### Data
- Summary of reliability estimates  
- Full simulated dataset  
- Cleaned dataset  
- Group-level summaries  
- Classification counts  

### Figures
- Distribution of absolute RCI values  
- Comparison of reliability across methods  
- Test–retest scatterplots (raw and adjusted)  

### Reproducibility
- Session information (R version and packages)  

## Requirements

The script uses the following R packages:
- ggplot2  
- scales  

These will be installed automatically if not already available.

## Notes

- A fixed random seed is used to ensure reproducibility  
- The simulation assumes a stable underlying construct  
- Differences across time are introduced through respondent behaviour  

## Author

Valentine Joseph Owan



## License

This project is provided for academic and research purposes.
