
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dipsim

<!-- badges: start -->

[![Lifecycle:Experimental](https://img.shields.io/badge/Lifecycle-Experimental-339999)](Redirect-URL)
<!-- badges: end -->

dipsim is a package built to simulate large datasets in a parquet format


## Installation

You can install the development version of dipsim from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("bcgov/dipsim")
```

## Example

This is a basic example of using `dipsim` to simulate a data set of 50
rows, based on data transformed into parquet format. The data set
`penguins` is found in the CRAN package, `palmerpenguins`.

``` r
library(dipsim)
dataset_size = 50 
wd <- "/Users/brobert"
```

``` r
##-------------------------- load routine -------------------------------
parquet_fp <- search_parquet_data()

create_folder_structure(folder_location = wd, name = basename(parquet_fp))

data <- generate_theoretical(support = parquet_fp, resize = 100000, folder_location = wd)

generate_empirical(samp_size = 50, folder_location = wd, name = basename(parquet_fp))
```

``` r
##-------------------------- generate test data -------------------------
##------ generate test data step
generate_testdata(folder_location = wd, name = basename(parquet_fp), dataset_size = dataset_size)

simulated_data <- read_testdata(folder_location = wd, name = basename(parquet_fp))
```

``` r
##--------------------------- diagnostics --------------------------------
##----- diagnostics step + helper function
original_data <- readr::read_csv(glue("{wd}/{basename(parquet_fp)}/
                                      distributions/theoretical/theoretical.csv"),
                                 na = character())

cols <- compare_data(original_data, simulated_data)

vis_sim (original_data, simulated_data, cols) 
```

Copyright 2019 Province of British Columbia

Licensed under the Apache License, Version 2.0 (the “License”); you may
not use this file except in compliance with the License. You may obtain
a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an “AS IS” BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
