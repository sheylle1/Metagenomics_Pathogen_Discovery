library(ggplot2)
library(dplyr)

# Load your data
data <- read.csv("D:/Umoya/Data/Patient1.csv")


# Example of Patient 1 (Benzonase-treated data)
data <- data.frame(
  pathogen = c(
    "B. cereus", "CMV", "E. coli", "Enterovirus A", "Enterovirus D", "EBV", "H. ducreyi",
    "H. influenzae", "K. pneumoniae", "L. santarosai", "M. intracellulare", "N. gonorrhoeae",
    "P. equi", "P. gingivalis", "P. melaninogenica", "P. putida", "Rhinovirus A", 
    "S. agalactiae", "S. anginosus", "S. aureus", "S. dysgalactiae", "S. equi", "S. gordonii",
    "S. maltophilia", "S. mitis", "S. oralis", "S. pneumoniae", "S. pyogenes", 
    "S. sanguinis", "S. suis", "V. parahaemolyticus", "Y. enterocolitica"
  ),
  reads = c(
    64, 7888, 116, 3630, 10, 16, 108, 68, 6344, 62, 50, 74, 16, 12, 10, 14, 466, 32, 
    32, 22, 22, 14, 30, 54, 3466, 492, 1374, 40, 30, 60, 94, 80
  )
)

# Apply Log10 to reads for slice sizes and order by color groups
data <- data %>%
  mutate(
    log_reads = log10(reads),
    label = paste0(pathogen,"  ", reads),
    color = case_when(
      pathogen %in% c("Enterovirus A", "Enterovirus D", "Rhinovirus A") ~ "darkblue",
      pathogen %in% c("CMV", "EBV") ~ "lightblue",
      pathogen %in% c("M. intracellulare", "S. aureus", "S. pneumoniae", "S. pyogenes", "K. pneumoniae") ~ "red",
      pathogen %in% c("S. dysgalactiae", "S. agalactiae", "S. anginosus", "P. putida", "S. maltophilia", "E. coli") ~ "orange",
      pathogen %in% c("P. melaninogenica", "N. gonorrhoeae", "S. gordonii", "S. mitis", "S. oralis", "S. sanguinis") ~ "yellow",
      TRUE ~ "gray"
    )
  ) %>%
  arrange(color) %>%  # Order by color
  mutate(
    percentage = log_reads / sum(log_reads) * 100,
    ymax = cumsum(percentage),
    ymin = c(0, head(ymax, -1)),
    label_position = (ymin + ymax) / 2
  )

ggplot(data, aes(ymax = ymax, ymin = ymin, xmax = 9, xmin = 5, fill = color)) +
  geom_rect(color = "black") +                 # Outline each wedge in black
  coord_polar(theta = "y") +                   # Create the circular shape
  xlim(c(2, 10)) +                           
  theme_void() +                              
  geom_text(aes(x = 9.5, y = label_position, label = label), size = 3, hjust = 0) +  
  scale_fill_identity() +                      
  theme(legend.position = "none")
