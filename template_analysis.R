# File title
# Authors
# Date

# Purpose - Analyze car data

# Load packages----
library(tidyverse)
library(tidymodels)
library(urbnthemes)

set_urbn_defaults(style = "print")


# Load data----
load("mtcars_Auto.rdata")


# Correlation----
# *all----
car_auto %>%
  select(mpg, hp, wt, cyl, year) %>%
  cor()

# *hp & mpg----
cor.test(~ hp + mpg, data=car_auto)

# *wt & mpg----
cor.test(~ wt + mpg, data=car_auto)

# *cyl & mpg----
cor.test(~ cyl + mpg, data=car_auto)


# Visualize----
# *hp & mpg----
car_auto %>%
  ggplot(aes(x=hp, y=mpg)) +
  geom_point() +
  scatter_grid()

# *wt & mpg----
car_auto %>%
  ggplot(aes(x=wt, y=mpg)) +
  geom_point() +
  scatter_grid()

# *cyl----
car_auto %>%
  ggplot(aes(x=factor(cyl))) +
  geom_bar() 


# Regression----
# *hp, wt, cyl----
mod1 <- lm(mpg ~ hp + wt + factor(cyl), data = car_auto)
summary(mod1)

# *add year----
mod2 <- lm(mpg ~ hp + wt + factor(cyl) + year, data = car_auto)
summary(mod2)
