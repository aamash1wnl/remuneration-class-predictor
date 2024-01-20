# Load necessary libraries
library(dplyr)
library(Amelia)
library(ggplot2)
library(caTools)

# Read the CSV file
adult <- read.csv('adult_sal.csv')

# View the first few rows of the dataset
head(adult)

# Remove unnecessary column 'X'
adult <- select(adult, -X)

# Display the structure and summary of the dataset
str(adult)
summary(adult)

# Explore and handle missing values in 'type_employer' column
table(adult$type_employer)
sum(is.na(adult$type_employer))

# Create functions to recode 'type_employer' values
func1 <- function(col1) {
  col1[col1 %in% c('Never-worked', 'Without-pay')] <- 'Unemployed'
  return(col1)
}

func2 <- function(col1) {
  col1[col1 %in% c('State-gov', 'Local-gov')] <- 'SL-gov'
  return(col1)
}

func3 <- function(col1) {
  col1[col1 %in% c('Self-emp-inc', 'Self-emp-not-inc')] <- 'self-emp'
  return(col1)
}

# Apply the functions to 'type_employer'
adult$type_employer <- sapply(adult$type_employer, func1)
adult$type_employer <- sapply(adult$type_employer, func2)
adult$type_employer <- sapply(adult$type_employer, func3)

# Display the updated table
table(adult$type_employer)

# Explore and handle missing values in 'marital' column
table(adult$marital)

# Create function to recode 'marital' values
func4 <- function(col1) {
  col1[col1 %in% c('Married-AF-spouse', 'Married-civ-spouse', 'Married-spouse-absent')] <- 'Married'
  col1[col1 %in% c('Divorced', 'Separated', 'Widowed')] <- 'Not-Married'
  return(col1)
}

# Apply the function to 'marital'
adult$marital <- sapply(adult$marital, func4)

# Display the updated table
table(adult$marital)

# Explore and handle missing values in 'country' column
table(adult$country)

# Create function to recode 'country' values
func5 <- function(country) {
  # Define categories for different regions
  asia <- c('Cambodia', 'China', 'Hong', 'India', 'Iran', 'Japan', 'Laos', 'Philippines', 'Taiwan', 'Thailand', 'Vietnam')
  europe <- c('England', 'France', 'Germany', 'Greece', 'Hungary', 'Ireland', 'Italy', 'Poland', 'Portugal', 'Scotland', 'Yugoslavia')
  latin_and_south_america <- c('Columbia', 'Cuba', 'Dominican-Republic', 'Ecuador', 'El-Salvador', 'Guatemala', 'Haiti', 'Honduras', 'Mexico', 'Nicaragua', 'Peru', 'Trinadad&Tobago')
  north_america <- c('Canada', 'United-States')
  other <- c('?', 'Holand-Netherlands', 'Outlying-US(Guam-USVI-etc)', 'Puerto-Rico')
  
  # Recode 'country' values based on regions
  if (country %in% asia) {
    return('Asia')
  } else if (country %in% europe) {
    return('Europe')
  } else if (country %in% latin_and_south_america) {
    return('Latin.and.South.America')
  } else if (country %in% north_america) {
    return('North.America')
  } else if (country %in% other) {
    return('Other')
  } else {
    return('Unknown')
  }
}

# Apply the function to 'country'
adult$country <- sapply(adult$country, func5)

# Display the updated table
table(adult$country)

# Convert categorical variables to factors
str(adult)
adult$marital <- sapply(adult$marital, factor)
adult$education <- sapply(adult$education, factor)
adult$occupation <- sapply(adult$occupation, factor)
adult$relationship <- sapply(adult$relationship, factor)
adult$race <- sapply(adult$race, factor)
adult$sex <- sapply(adult$sex, factor)
adult$type_employer <- sapply(adult$type_employer, factor)
adult$income <- sapply(adult$income, factor)

# Check for missing values and impute if necessary
func6 <- function(df) {
  for (i in colnames(df)) {
    df[[i]][df[[i]] %in% c('?', ' ?', '? ')] <- NA
  }
  return(df)
}

# Apply the function to handle missing values
adult <- func6(adult)

# Display the missing data visualization
table(adult$type_employer)
missmap(adult, y.at = c(1), y.labels = c(''), col = c('yellow', 'black'))

# Remove rows with missing values
adult <- na.omit(adult)

# Display the missing data visualization after handling missing values
str(adult)
missmap(adult, y.at = c(1), y.labels = c(''), col = c('yellow', 'black'))

# Explore and visualize the data
ggplot(adult, aes(x = age)) + geom_histogram(aes(fill = income), color = 'black', binwidth = 1) + theme_bw()
ggplot(adult, aes(x = hr_per_week), colors = income) + geom_histogram(color = 'black', binwidth = 1) + theme_bw()

# Rename the 'country' column to 'Region'
colnames(adult)[14] <- 'Region'

# Plot a bar chart of income by region
ggplot(adult, aes(x = Region)) + geom_bar(aes(fill = income), color = 'black') +
  theme_bw() + theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Split the dataset into training and testing sets
sample <- sample.split(adult$age, SplitRatio = 0.7)
train <- subset(adult, sample == TRUE)
test <- subset(adult, sample == FALSE)

# Build a logistic regression model
model <- glm(income ~ ., family = binomial(logit), data = train)

# Display the summary of the model
summary(model)

# Stepwise variable selection
model.2 <- step(model)

# Make predictions on the test set
test$predicted.income <- predict.lm(model, newdata = test, type = 'response')

# Create a confusion matrix and calculate accuracy, recall, and precision
conf_matrix <- table(test$predicted.income > 0.5, test$income)
accuracy <- sum(diag(conf_matrix)) / sum(conf_matrix)
recall <- conf_matrix[2, 2] / sum(conf_matrix[, 2])
precision <- conf_matrix[2, 2] / sum(conf_matrix[2, ])

# Display the evaluation metrics
print(paste('Accuracy:', accuracy))
print(paste('Recall:', recall))
print(paste('Precision:', precision))
