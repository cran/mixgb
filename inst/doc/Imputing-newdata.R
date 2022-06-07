## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(mixgb)
set.seed(2022)
n <- nrow(nhanes3_newborn)
idx <- sample(1:n, size = round(0.7 * n), replace = FALSE)
train.data <- nhanes3_newborn[idx, ]
test.data <- nhanes3_newborn[-idx, ]

## -----------------------------------------------------------------------------
# obtain m imputed datasets for train.data and save imputation models
mixgb.obj <- mixgb(data = train.data, m = 5, save.models = TRUE, save.vars = NULL)

## -----------------------------------------------------------------------------
train.imputed <- mixgb.obj$imputed.data
# the 5th imputed dataset
head(train.imputed[[5]])

## -----------------------------------------------------------------------------
test.imputed <- impute_new(object = mixgb.obj, newdata = test.data)

## -----------------------------------------------------------------------------
test.imputed <- impute_new(object = mixgb.obj, newdata = test.data, initial.newdata = FALSE, pmm.k = 3, m = 4)

