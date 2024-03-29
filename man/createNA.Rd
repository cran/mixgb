% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/createNA.R
\name{createNA}
\alias{createNA}
\title{Create missing values for a dataset}
\usage{
createNA(data, var.names = NULL, p = 0.3)
}
\arguments{
\item{data}{A complete data frame.}

\item{var.names}{The names of variables where missing values will be generated.}

\item{p}{The proportion of missing values in the data frame or the proportions of missing values corresponding to the variables specified in \code{var.names}.}
}
\value{
A data frame with artificial missing values
}
\description{
This function creates missing values under the missing complete at random (MCAR) mechanism. It is for demonstration purposes only.
}
\examples{
# Create 30\% MCAR data across all variables in a dataset
withNA.df <- createNA(data = iris, p = 0.3)

# Create 30\% MCAR data in a specified variable in a dataset
withNA.df <- createNA(data = iris, var.names = c("Sepal.Length"), p = 0.3)

# Create MCAR data in several specified variables in a dataset
withNA.df <- createNA(
  data = iris,
  var.names = c("Sepal.Length", "Petal.Width", "Species"),
  p = c(0.3, 0.2, 0.1)
)
}
