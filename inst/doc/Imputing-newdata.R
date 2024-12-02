## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval = FALSE-------------------------------------------------------------
#  set.seed(2022)
#  n <- nrow(nhanes3)
#  idx <- sample(1:n, size = round(0.7 * n), replace = FALSE)
#  train.data <- nhanes3[idx, ]
#  test.data <- nhanes3[-idx, ]

## ----eval = FALSE-------------------------------------------------------------
#  # obtain m imputed datasets for train.data and save imputation models
#  mixgb.obj <- mixgb(data = train.data, m = 5, save.models = TRUE, save.models.folder = "C:/Users/.....")
#  saveRDS(object = mixgb.obj, file = "C:/Users/.../mixgbimputer.rds")

## ----eval=FALSE---------------------------------------------------------------
#  mixgb.obj <- readRDS(file = "C:/Users/.../mixgbimputer.rds")
#  test.imputed <- impute_new(object = mixgb.obj, newdata = test.data)

## ----eval = FALSE-------------------------------------------------------------
#  test.imputed <- impute_new(object = mixgb.obj, newdata = test.data)

## ----eval = FALSE-------------------------------------------------------------
#  test.imputed <- impute_new(object = mixgb.obj, newdata = test.data, initial.newdata = FALSE, pmm.k = 3, m = 4)

