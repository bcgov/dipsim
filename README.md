
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dipsim

<!-- badges: start -->

[![Lifecycle:Maturing](https://img.shields.io/badge/Lifecycle-Maturing-007EC6)](https://github.com/bcgov/repomountie/blob/master/doc/lifecycle-badges.md)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
<!-- badges: end -->

The goal of dipsim is to …

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
dataset_size = 1000 
wd <- "/Users/brobert/Desktop"
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

### Getting Help or Reporting an Issue

To report bugs/issues/feature requests, please file an
[issue](https://github.com/bcgov/dipsim/issues).

### How to Contribute

If you would like to contribute, please see our
[CONTRIBUTING](CONTRIBUTING.md) guidelines.

Please note that this project is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree
to abide by its terms.

### License

    Copyright 2021 Province of British Columbia

    Licensed under the Apache License, Version 2.0 (the &quot;License&quot;);
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an &quot;AS IS&quot; BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and limitations under the License.
