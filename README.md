[![Appveyor build Status](https://ci.appveyor.com/api/projects/status/github/mrustl/fvbb.scorer?branch=master&svg=true)](https://ci.appveyor.com/project/mrustl/fvbb-scorer/branch/master)
[![Travis build Status](https://travis-ci.org/mrustl/fvbb.scorer.svg?branch=master)](https://travis-ci.org/mrustl/fvbb.scorer)
[![codecov](https://codecov.io/github/mrustl/fvbb.scorer/branch/master/graphs/badge.svg)](https://codecov.io/github/mrustl/fvbb.scorer)
[![Project Status](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/fvbb.scorer)]()

# fvbb.scorer

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

# Install KWB package 'fvbb.scorer' from GitHub

remotes::install_github("mrustl/fvbb.scorer")
```

## Documentation

Release: [https://mrustl.github.io/fvbb.scorer](https://mrustl.github.io/fvbb.scorer)

Development: [https://mrustl.github.io/fvbb.scorer/dev](https://mrustl.github.io/fvbb.scorer/dev)
