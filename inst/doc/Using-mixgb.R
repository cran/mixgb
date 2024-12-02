## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
library(mixgb)
str(nhanes3_newborn)
colSums(is.na(nhanes3_newborn))

## ----eval = FALSE-------------------------------------------------------------
#  # use mixgb with default settings
#  imputed.data <- mixgb(data = nhanes3_newborn, m = 5)

## ----eval = FALSE-------------------------------------------------------------
#  # Use mixgb with chosen settings
#  params <- list(
#    max_depth = 5,
#    subsample = 0.9,
#    nthread = 2,
#    tree_method = "hist"
#  )
#  
#  imputed.data <- mixgb(
#    data = nhanes3_newborn, m = 10, maxit = 2,
#    ordinalAsInteger = FALSE, bootstrap = FALSE,
#    pmm.type = "auto", pmm.k = 5, pmm.link = "prob",
#    initial.num = "normal", initial.int = "mode", initial.fac = "mode",
#    save.models = FALSE, save.vars = NULL,
#    xgb.params = params, nrounds = 200, early_stopping_rounds = 10, print_every_n = 10L, verbose = 0
#  )

## -----------------------------------------------------------------------------
params <- list(max_depth = 3, subsample = 0.7, nthread = 2)
cv.results <- mixgb_cv(data = nhanes3_newborn, nrounds = 100, xgb.params = params, verbose = FALSE)
cv.results$evaluation.log
cv.results$response
cv.results$best.nrounds

## -----------------------------------------------------------------------------
cv.results <- mixgb_cv(
  data = nhanes3_newborn, nfold = 10, nrounds = 100, early_stopping_rounds = 1,
  response = "BMPHEAD", select_features = c("HSAGEIR", "HSSEX", "DMARETHN", "BMPRECUM", "BMPSB1", "BMPSB2", "BMPTR1", "BMPTR2", "BMPWT"), xgb.params = params, verbose = FALSE
)

cv.results$best.nrounds

## ----eval = FALSE-------------------------------------------------------------
#  imputed.data <- mixgb(data = nhanes3_newborn, m = 5, nrounds = cv.results$best.nrounds)

