# Load necessary libraries
library(ggplot2)
library(dplyr)
library(reshape2)
library(ggpattern)

# Data preparation
data <- data.frame(
  Patient = c("1", "2", "3", "4", "1", "2", "3", "4"),
  Sample_ID = c("S1", "S2", "S3", "S4", "S5", "S6", "S7", "S8"),
  Treatment = c("Yes", "Yes", "Yes", "Yes", "No", "No", "No", "No"),
  Reads_before_filtering = c(33228304, 153092, 37762488, 34926406, 24009362, 27034120, 24325386, 23943786),
  Afterfiltering_percent = c(0.97, 0.96, 0.97, 0.97, 0.98, 0.98, 0.98, 0.98) * 100,
  Reads_after_filtering = c(32116888, 146736, 36679050, 33887822, 23448708, 26489850, 23765854, 23488458),
  HostReads_percent = c(0.90, 0.84, 0.90, 0.90, 0.92, 0.93, 0.91, 0.90) * 100,
  Host_Reads = c(29772495, 129357, 34172992, 31551308, 22129393, 25217102, 22190138, 21642885),
  Unmapped_percent = c(0.07, 0.11, 0.07, 0.07, 0.05, 0.05, 0.06, 0.08) * 100,
  Unmapped = c(2344393, 17379, 2506058, 2336514, 1319315, 1272748, 1575716, 1845573)
)

data_long <- melt(data, id.vars = c("Patient", "Sample_ID", "Treatment"),
                  measure.vars = c("Reads_before_filtering", "Reads_after_filtering", "Host_Reads", "Unmapped"),
                  variable.name = "Category", value.name = "Reads") %>%
  mutate(Category = factor(Category, levels = c( "Unmapped", "Host_Reads", "Reads_after_filtering", "Reads_before_filtering")))

# Add percentage data for the appropriate categories
data_long <- data_long %>%
  mutate(Percentage = case_when(
    Category == "Reads_after_filtering" ~ data$Afterfiltering_percent[match(Sample_ID, data$Sample_ID)],
    Category == "Host_Reads" ~ data$HostReads_percent[match(Sample_ID, data$Sample_ID)],
    Category == "Unmapped" ~ data$Unmapped_percent[match(Sample_ID, data$Sample_ID)],
    TRUE ~ NA_real_
  ))

data_long <- data_long %>%
  mutate(Patient_Treatment = paste(Patient, "-", Treatment))

# Create the plot 
ggplot(data_long, aes(x = Reads, y = Patient_Treatment, fill = Category)) +
  geom_bar(stat = "identity", position = position_dodge(width = 0.8), width = 0.6) +
  geom_text(aes(label = ifelse(is.na(Percentage), scales::comma(Reads),
                               paste0(scales::comma(Reads), " (", round(Percentage, 0), "%)"))),
            position = position_dodge(width = 0.8), size = 3, hjust = -0.1) +
  scale_fill_manual(values = c("Reads_before_filtering" = "red", 
                               "Reads_after_filtering" = "orange", 
                               "Host_Reads" = "blue", 
                               "Unmapped" = "#008080")) +  # Teal hex code
  scale_x_continuous(labels = scales::label_number(scale = 1e-6, suffix = "M"), limits = c(0, 45000000)) +  # Limits up to 45M
  labs(title = "Read Distribution per Patient",
       x = "Number of Reads (Millions)") +
  labs(y = "Patient ", x = "Number of Reads") +
  theme_minimal() +
  theme(axis.text.y = element_text(size = 10)) 

