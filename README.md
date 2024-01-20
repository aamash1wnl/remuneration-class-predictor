# Adult Income Prediction Project

## Overview
This project aims to predict whether an adult's income exceeds $50,000 per year based on various demographic and employment-related features. The dataset used for this prediction is sourced from the "adult_sal.csv" file.

## Table of Contents
- [Libraries Used](#libraries-used)
- [Dataset Overview](#dataset-overview)
- [Data Preprocessing](#data-preprocessing)
- [Exploratory Data Analysis](#exploratory-data-analysis)
- [Model Building](#model-building)
- [Model Evaluation](#model-evaluation)
- [Results](#results)
- [Inspiration](#inspiration)
- [Instructions for Use](#instructions-for-use)

## Libraries Used
The following R libraries were used in this project:
- dplyr
- Amelia
- ggplot2
- caTools

## Dataset Overview
The dataset consists of demographic and employment-related information, including features such as age, education, marital status, occupation, and more.

Link to dataset: https://archive.ics.uci.edu/dataset/2/adult

```
# Load necessary libraries
library(dplyr)
library(Amelia)
library(ggplot2)
library(caTools)

# Read the CSV file
adult <- read.csv('adult_sal.csv')

# View the first few rows of the dataset
head(adult)

## # Explore and handle missing values
# Recode and handle categorical variables
# Convert variables to factors
# Remove rows with missing values
# ...
```

## Data Preprocessing
The dataset underwent several preprocessing steps, including handling missing values, recoding categorical variables, and converting variables to factors.

```
# Explore and handle missing values
# Recode and handle categorical variables
# Convert variables to factors
# Remove rows with missing values
# ...

# Display missing data visualization
missmap(adult, y.at = c(1), y.labels = c(''), col = c('yellow', 'black'))
```

## Exploratory Data Analysis
Exploratory Data Analysis (EDA) was conducted to understand the distribution of key variables and their relationship with the target variable.

```
# Explore and visualize the data
ggplot(adult, aes(x = age)) + geom_histogram(aes(fill = income), color = 'black', binwidth = 1) + theme_bw()
ggplot(adult, aes(x = hr_per_week), colors = income) + geom_histogram(color = 'black', binwidth = 1) + theme_bw()
```

## Model Building
A logistic regression model was built to predict the income category based on the available features. The dataset was split into training and testing sets for model evaluation.

```
# Split the dataset into training and testing sets
sample <- sample.split(adult$age, SplitRatio = 0.7)
train <- subset(adult, sample == TRUE)
test <- subset(adult, sample == FALSE)

# Build a logistic regression model
model <- glm(income ~ ., family = binomial(logit), data = train)
```

## Model Evaluation
The model was evaluated using metrics such as accuracy, recall, and precision on the test set.

```
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
```

## Results

The project concludes with the evaluation of different models, highlighting that the logistic regression model performed the best in terms of accuracy. However, it's important to note that these results may vary based on the dataset and the specific problem being addressed.

## Inspiration

This project is inspired by the need to predict income levels accurately based on demographic and employment features. It serves as a practical example for individuals looking to understand logistic regression models and their application in predictive analytics.

## Instructions for Use

1. Clone the repository from GitHub.
2. Make sure to have the necessary R libraries installed (`dplyr`, `Amelia`, `ggplot2`, `caTools`).
3. Open R and execute the code in the `income_prediction_script.R` file.
4. Explore the data preprocessing, exploratory data analysis, and logistic regression model building steps.
5. Experiment with different preprocessing techniques or try alternative models for further exploration.

Feel free to contribute, report issues, or provide feedback to enhance the project and its applicability.
