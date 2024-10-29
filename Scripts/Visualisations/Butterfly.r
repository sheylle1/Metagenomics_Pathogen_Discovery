# Load necessary libraries
library(ggplot2)
library(reshape2)

# Load your data
data <- read.csv("D:/Umoya/Data/Patient3.csv")

# Example of sample data from patient 3
data <- data.frame(
  Pathogens = c("K.pneumoniae", "S. pneumoniae", "Enterovirus D", "E.coli", "S. maltophilia", "V. parahaemolticus", "S,aurues", "N, gonorrhoeae", "B. cereus"),
  Treated = c(6000, 1000, 280, 220, 115, 90, 70, 70, 68 ),   # (negative side)
  Untreated = c(55, 180, 0, 0, 0, 0, 0, 0, 0)  # (positive side)
)

# Reshape the data from wide to long format
data_long <- melt(data, id.vars = "Pathogens")

# Add a new column to specify the color conditionally
data_long$color <- ifelse(data_long$Pathogens == "Enterovirus D", "blue", "red")

# Create the butterfly chart using ggplot2
ggplot(data_long, aes(x = Pathogens, y = ifelse(variable == "Treated", -value, value), fill = color)) +
  geom_bar(stat = "identity", position = "identity", width = 0.8) +
  coord_flip() +  # Flip the coordinates for horizontal bars
  scale_y_continuous(labels = abs) +  # Display absolute values on the y-axis
  labs(x = "Pathogens", y = "Value", title = "Microbial comparison") +
  theme_minimal() +  # Use a minimal theme for a clean look
  scale_fill_identity() +  # Use the fill colors as defined in the 'color' column
  theme(legend.position = "none")  # Remove the legend since we have fixed colors
