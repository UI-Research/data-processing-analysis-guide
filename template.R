# File title
# Authors
# Date

# Purpose - Prepare car data for analysis


# Load packages----
library(tidyverse)
library(skimr)
library(ISLR)


# Load data----
cars <- mtcars
autos <- Auto


# Check data----
# Does the population in the data match the target population for the study?
# Visually inspect the dataset

head(cars)
View(cars)

head(autos)
View(autos)

# What is the missingness of the variables? 
# Do you understand what each of the variables represents? 
# view the variables, their types, formats, labels, and label values. 
# view the number of observations and unique observations, and the mean, min, and max for each variable. 

summary(cars)
skim(cars)

summary(autos)
skim(autos)

# What unit of observation do you want? 
# Are there duplicates in the data? If so, how will you address them?
# Check the unit of observations and check for duplicates 
duplicated(cars)
duplicated(autos)

# Will any observations need to be excluded or deleted?
# You can use the filter command 
# In this example we don't want cars that have an mpg less than 12
cars %>%
  filter(mpg >= 12)


# Process data----
# Do any of the files need to be merged / joined together? If so, are the files at the same unit? 
# Do any of the files need to be appended together? If so, are they at the same unit? 
# In this example, we want to append / bind the autos and cars datasets.
# We process the data so that they can be combined.

# convert rownames to column, convert weight, add yr
cars <- cars %>%
  rownames_to_column("name") %>%
  mutate(wt = wt * 1000,
         year = 73)

# rename columns to match
autos <- autos %>%
  rename(cyl = "cylinders",
         disp = "displacement",
         hp = "horsepower",
         wt = "weight")


# Combine files----
car_auto <- bind_rows("mtcars" = cars, "Auto" = autos, .id="source")


# Process combined data----
# Is any other manipulation necessary for analysis (e.g., inflation adjusting)?

# make hp categorical variable, add make & model 
car_auto <- car_auto %>%
  mutate(hp_cat = case_when(hp < 100 ~ "<100",
                            hp < 125 ~ "100-124",
                            hp < 150 ~ "125-149",
                            hp < 200 ~ "150-199",
                            TRUE ~ "200+"),
         name = str_to_lower(name)) %>%
  separate(name, c("make", "model"), sep = " ", extra = "merge", fill = "right", remove=FALSE)
table(car_auto$hp,car_auto$hp_cat)

# clean make & model names
table(car_auto$make)
car_auto <- car_auto %>%
  mutate(make = if_else(make == "chevroelt" | make == "chevy", "chevrolet", make),
         make = if_else(make == "vokswagen" | make == "vw", "volkswagen", make),
         make = if_else(make == "maxda", "mazda", make),
         make = if_else(make == "merc" | make == "mercedes", "mercedes-benz", make),
         make = if_else(make == "toyouta", "toyota", make),
         make = if_else(make == "camaro", "chevrolet", make),
         model = if_else(model == "z28", "camaro z28", model),
         make = if_else(make == "capri", "mercury", make),
         model = if_else(model == "ii", "capri ii", model),
         make = if_else(make == "valiant", "plymouth", make),
         model = if_else(is.na(model), "valiant", model),
         model = if_else(model == "benz 300d", "300d", model))
table(car_auto$make)


# Check combined data----
# After processing the data, did you check the accuracy and quality of the data again?
# It is important to run checks on the dataset as you are processing and before you start analysis. 
# Below are some examples of checks that can be run. 

check <- car_auto %>%
  group_by(make, model) %>%
  summarize(n = n(),
            mtcars = sum(source == "mtcars"),
            Auto = sum(source == "Auto")) %>%
  arrange(mtcars)

skim(car_auto)
duplicated(car_auto)


# Save data----
save(car_auto, file="mtcars_Auto.rdata")

