[![Appveyor build Status](https://ci.appveyor.com/api/projects/status/2ib3jrl85ea2vqcd?svg=true)](https://ci.appveyor.com/project/KWB-R/fvbb-scorer)
[![Travis build Status](https://travis-ci.org/mrustl/fvbb.scorer.svg?branch=master)](https://travis-ci.org/mrustl/fvbb.scorer)
[![codecov](https://codecov.io/github/mrustl/fvbb.scorer/branch/master/graphs/badge.svg)](https://codecov.io/github/mrustl/fvbb.scorer)
[![Project Status](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/fvbb.scorer)]()

Helper functions for creating scorer table
based on game results on FVBB website
(https://fvbb.saisonmanager.de)

## Installation

To install the R package run the following code:

```r

# Sys.setenv(GITHUB_PAT = "mysecret_access_token")

# Install package "remotes" from CRAN
if (! require("remotes")) {
  install.packages("remotes", repos = "https://cloud.r-project.org")
}

# Install R package 'fvbb.scorer' from GitHub

remotes::install_github("mrustl/fvbb.scorer")
```
