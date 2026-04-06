3. Run the entire script

All outputs will be automatically saved in the `project_outputs` folder.

## Outputs

### Data Files
- `results.csv` → Summary of reliability estimates  
- `full_data.csv` → Complete simulated dataset  

### Figures
- `Figure1_RCI.png` → Distribution of |RCI| values  
- `Figure2_Reliability.png` → Comparison of reliability across methods  
- `Figure3_Scatter_Raw.png` → Raw test–retest relationship  
- `Figure4_Scatter_Adjusted.png` → Adjusted test–retest relationship  

### Reproducibility
- `session_info.txt` → R version and package details  

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