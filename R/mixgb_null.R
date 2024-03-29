# Multiple imputation using xgboost (without bootstrap)
mixgb_null <- function(pmm.type, pmm.link, pmm.k, yobs.list, yhatobs.list = NULL, sorted.dt, missing.vars, sorted.names, Na.idx, missing.types, Ncol,
                       xgb.params = list(max_depth = 3, gamma = 0, eta = 0.3, colsample_bytree = 1, min_child_weight = 1, subsample = 1, tree_method = "auto", gpu_id = 0, predictor = "auto", scale_pos_weight = 1),
                       nrounds = 100, early_stopping_rounds = 10, print_every_n = 10L, verbose = 0,
                       ...) {
  # param yhatobs.list if it is pmm.type 1, must feed in the yhatobs.list
  for (var in missing.vars) {
    features <- setdiff(sorted.names, var)
    form <- reformulate(termlabels = features, response = var)

    na.idx <- Na.idx[[var]]
    obs.y <- yobs.list[[var]]

    if (Ncol == 2) {
      obs.data <- sparse.model.matrix(form, data = sorted.dt[-na.idx, ])
      mis.data <- sparse.model.matrix(form, data = sorted.dt[na.idx, ])
    } else {
      obs.data <- sparse.model.matrix(form, data = sorted.dt[-na.idx, ])[, -1, drop = FALSE]
      mis.data <- sparse.model.matrix(form, data = sorted.dt[na.idx, ])[, -1, drop = FALSE]
    }
    # numeric or integer ---------------------------------------------------------------------------
    if (missing.types[var] == "numeric" | missing.types[var] == "integer") {
      obj.type <- "reg:squarederror"
      xgb.fit <- xgboost(
        data = obs.data, label = obs.y, objective = obj.type,
        params = xgb.params, nrounds = nrounds, early_stopping_rounds = early_stopping_rounds, print_every_n = print_every_n, verbose = verbose,
        ...
      )
      yhatmis <- predict(xgb.fit, mis.data)
      if (!is.null(pmm.type)) {
        if (pmm.type != 1) {
          # for pmm.type=0 or 2 or auto (type 2 for numeric or integer)
          yhatobs <- predict(xgb.fit, obs.data)
        } else {
          # for pmm.type=1
          yhatobs <- yhatobs.list[[var]]
        }
        yhatmis <- pmm(yhatobs = yhatobs, yhatmis = yhatmis, yobs = obs.y, k = pmm.k)
      }
      # update dataset
      sorted.dt[[var]][na.idx] <- yhatmis
    } else if (missing.types[var] == "binary") {
      # binary ---------------------------------------------------------------------------
      obs.y <- as.integer(obs.y) - 1
      bin.t <- sort(table(obs.y))
      # when bin.t has two values: bin.t[1] minority class & bin.t[2] majority class
      # when bin.t only has one value: bin.t[1] the only existent class
      if (is.na(bin.t[2])) {
        # this binary variable only has a single class being observed (e.g., observed values are all "0"s)
        # skip xgboost training, just impute the only existent class
        sorted.dt[[var]][na.idx] <- levels(sorted.dt[[var]])[as.integer(names(bin.t[1])) + 1]
        msg <- paste("The binary variable", var, "in the data only have single class. Imputation models can't be built.")
        stop(msg)
      } else {
        if (!is.null(pmm) & pmm.link == "logit") {
          # pmm by "logit" value
          obj.type <- "binary:logitraw"
        } else {
          # pmm by "prob" and for no pmm
          obj.type <- "binary:logistic"
        }
        xgb.fit <- xgboost(
          data = obs.data, label = obs.y, objective = obj.type, eval_metric = "logloss",
          params = xgb.params, nrounds = nrounds, early_stopping_rounds = early_stopping_rounds, print_every_n = print_every_n, verbose = verbose,
          ...
        )
        yhatmis <- predict(xgb.fit, mis.data)
        if (is.null(pmm.type) | isTRUE(pmm.type == "auto")) {
          # for pmm.type=NULL or "auto"
          yhatmis <- ifelse(yhatmis >= 0.5, 1, 0)
          sorted.dt[[var]][na.idx] <- levels(sorted.dt[[var]])[yhatmis + 1]
        } else {
          if (pmm.type == 1) {
            # for pmm.type=1
            yhatobs <- yhatobs.list[[var]]
          } else {
            # for pmm.type=0 or 2
            yhatobs <- predict(xgb.fit, obs.data)
          }
          sorted.dt[[var]][na.idx] <- pmm(yhatobs = yhatobs, yhatmis = yhatmis, yobs = yobs.list[[var]], k = pmm.k)
        }
      }
    } else {
      # multiclass ---------------------------------------------------------------------------
      obs.y <- as.integer(obs.y) - 1
      if (is.null(pmm.type) | isTRUE(pmm.type == "auto")) {
        obj.type <- "multi:softmax"
      } else {
        # use probability to do matching
        obj.type <- "multi:softprob"
      }
      N.class <- length(levels(sorted.dt[[var]]))
      xgb.fit <- xgboost(
        data = obs.data, label = obs.y, num_class = N.class, objective = obj.type, eval_metric = "mlogloss",
        params = xgb.params, nrounds = nrounds, early_stopping_rounds = early_stopping_rounds, print_every_n = print_every_n, verbose = verbose,
        ...
      )

      if (is.null(pmm.type) | isTRUE(pmm.type == "auto")) {
        # use softmax, predict returns class
        # for pmm.type=NULL or "auto"
        yhatmis <- predict(xgb.fit, mis.data)
        sorted.dt[[var]][na.idx] <- levels(sorted.dt[[var]])[yhatmis + 1]
      } else {
        # predict returns probability matrix for each class
        yhatmis <- predict(xgb.fit, mis.data, reshape = TRUE)
        if (pmm.type == 1) {
          # for pmm.type=1
          yhatobs <- yhatobs.list[[var]]
        } else {
          # for pmm.type=0 or 2
          # probability matrix for each class
          yhatobs <- predict(xgb.fit, obs.data, reshape = TRUE)
        }
        sorted.dt[[var]][na.idx] <- pmm.multiclass(yhatobs = yhatobs, yhatmis = yhatmis, yobs = yobs.list[[var]], k = pmm.k)
      }
    }
  } # end of for each missing variable
  return(sorted.dt)
}
