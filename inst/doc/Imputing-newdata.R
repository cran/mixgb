## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(mixgb)
data("nhanes3_newborn")
set.seed(2022)
n <- nrow(nhanes3_newborn)
idx <- sample(1:n, size = round(0.7 * n), replace = FALSE)
train.data <- nhanes3_newborn[idx, ]
test.data <- nhanes3_newborn[-idx, ]

## -----------------------------------------------------------------------------
params <- list(
  max_depth = 3,
  gamma = 0,
  eta = 0.3,
  min_child_weight = 1,
  subsample = 0.7,
  nthread = 2
)

# obtain m imputed datasets for train.data and save imputation models
mixgb.obj <- mixgb(data = train.data, m = 5, xgb.params = params, save.models = TRUE, save.vars = NULL)

## -----------------------------------------------------------------------------
train.imputed <- mixgb.obj$imputed.data
# the 5th imputed dataset
head(train.imputed[[5]])

## ---- eval = FALSE------------------------------------------------------------
#  test.imputed <- impute_new(object = mixgb.obj, newdata = test.data)

## ---- eval = FALSE------------------------------------------------------------
#  test.imputed <- impute_new(object = mixgb.obj, newdata = test.data, initial.newdata = FALSE, pmm.k = 3, m = 4)

