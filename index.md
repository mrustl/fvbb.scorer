[![Appveyor build Status](https://ci.appveyor.com/api/projects/status/github/KWB-R/fvbb.scorer?branch=master&svg=true)](https://ci.appveyor.com/project/KWB-R/fvbb-scorer/branch/master)
[![Travis build Status](https://travis-ci.org/KWB-R/fvbb.scorer.svg?branch=master)](https://travis-ci.org/KWB-R/fvbb.scorer)
[![codecov](https://codecov.io/github/KWB-R/fvbb.scorer/branch/master/graphs/badge.svg)](https://codecov.io/github/KWB-R/fvbb.scorer)
[![Project Status](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/fvbb.scorer)]()

Helper functions for creating scorer table
based on game results on FVBB website
(https://fvbb.saisonmanager.de)

## Installation

For details on how to install KWB-R packages checkout our [installation tutorial](https://kwb-r.github.io/kwb.pkgbuild/articles/install.html).

```r
### Optionally: specify GitHub Personal Access Token (GITHUB_PAT)
### See here why this might be important for you:
### https://kwb-r.github.io/kwb.pkgbuild/articles/install.html#set-your-github_pat

# Sys.setenv(GITHUB_PAT = "mysecret_access_token")

# Install package "remotes" from CRAN
if (! require("remotes")) {
  install.packages("remotes", repos = "https://cloud.r-project.org")
}

# Install KWB package 'fvbb.scorer' from GitHub

remotes::install_github("KWB-R/fvbb.scorer")
```
