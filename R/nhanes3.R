#' A small subset of the NHANES III (1988-1994) newborn data
#'
#' This dataset is a small subset of \code{nhanes3_newborn}. It is for demonstration purposes only. More information on NHANES III data can be found on \url{https://wwwn.cdc.gov/Nchs/Data/Nhanes3/7a/doc/mimodels.pdf}
#' @docType  data
#' @usage data(nhanes3)
#' @format A data frame of 500 rows and 6 variables. Three variables have missing values.
#' \describe{
#'  \item{HSAGEIR}{Age at interview (screener) - qty (months). An integer variable from 2 to 11.}
#'  \item{HSSEX}{Sex. A factor variable with levels 1 (Male) and 2 (Female).}
#'  \item{DMARETHN}{Race-ethnicity. A factor variable with levels 1 (Non-Hispanic white), 2 (Non-Hispanic black), 3 (Mexican-American) and 4 (Other).}
#'  \item{BMPHEAD}{Head circumference (cm). Numeric.}
#'  \item{BMPRECUM}{Recumbent length (cm). Numeric.}
#'  \item{BMPWT}{Weight (kg). Numeric.}
#' }

#' @references U.S. Department of Health and Human Services
#' (DHHS).  National Center for Health Statistics.  Third National
#' Health and Nutrition Examination Survey (NHANES III, 1988-1994):
#' Multiply Imputed Data Set. CD-ROM, Series 11, No. 7A.
#' Hyattsville, MD: Centers for Disease Control and Prevention,
#' 2001. Includes access software: Adobe Systems, Inc. Acrobat
#' Reader version 4.
#' @source \url{https://wwwn.cdc.gov/nchs/nhanes/nhanes3/datafiles.aspx}
"nhanes3"
