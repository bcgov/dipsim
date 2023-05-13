
<!-- README.md is generated from README.Rmd. Please edit that file -->

<div align="center">

<br>
<h1>
dipsim
</h1>

<strong>Simulating Data for BCGov Researchers</strong>

</div>

<br>

<!-- badges: start -->

[![Lifecycle:Maturing](https://img.shields.io/badge/Lifecycle-Maturing-007EC6)](https://github.com/bcgov/repomountie/blob/master/doc/lifecycle-badges.md)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
<!-- badges: end -->

## What is dipsim?

It is an R package with tools designed for simulating data from data
sets in `.parquet` format. It was primarily developed to help BCGov
researchers working in the DIP to create secondary datasets for use
during testing and development.

Developing code for data science applications can be time consuming and
testing code on massive data sets can slow down development
significantly. `dipsim` helps by providing a way to quickly create
smaller versions of the actual data set.

## Table of Contents

-   [What is Dipsim?](#what-is-dipsim)
-   [Table of Contents](#table-of-contents)
-   [Getting Help](#getting-help)
-   [Getting Started](#getting-started)
    -   [Prerequisites](#prerequisites)
    -   [Installation Documentation](#installation-documentation)
    -   [Example Workflow](#example-workflow)
-   [Documentation](#dcoumentation)
-   [Core team](#core-team)
-   [Contributing](#contributing)
-   [License](#license)

## Getting Help

To report bugs/issues/feature requests, please file an
[issue](https://github.com/bcgov/dipsim/issues).


## Getting Started

### Prerequisites

-   [R](https://www.r-project.org) `R --version` \> 4.0
-   [RStudio](https://posit.co/products/open-source/rstudio-server/)
    `RStudio --version` \> 2022.07.0(Spotted Wakerobin)

### Installation Documentation

You can install the development version of dipsim from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("bcgov/dipsim")
```

### Example Workflow

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

input_data <- make_input_data(support_fp = parquet_fp, resize = 100000, folder_location = wd)

```

``` r
##-------------------------- generate simulated data -------------------------
simulated_data <- make_simulated_data (samp_size = 50, folder_location = wd, 
                     name = tools::file_path_sans_ext(basename(parquet_fp)),
                     dataset_size = 100)
```

``` r
##--------------------------- diagnostics --------------------------------
##----- diagnostics step + helper function
original_data <- glue::glue("{wd}/{tools::file_path_sans_ext(basename(parquet_fp))}/distributions/theoretical/theoretical.csv")
original_data <- readr::read_csv(original_data, na = character())

cols <- compare_data(original_data, simulated_data)

vis_sim (original_data, simulated_data, cols) 
```

``` r
##----------------------- clean up temp folder
f=glue::glue("{wd}/{tools::file_path_sans_ext(basename(parquet_fp))}")
unlink(f, recursive = TRUE)
```

## Documentation

After installing the package you can view vignettes by typing
`browseVignettes("dipsim")` in your R session.

## Core team

-   [@BonnieJRobert](https://github.com/BonnieJRobert)

## Contributing

If you would like to contribute, please see our
[CONTRIBUTING](CONTRIBUTING.md) guidelines.

Please note that this project is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree
to abide by its terms.

## License

    Copyright 2021 Province of British Columbia

    Licensed under the Apache License, Version 2.0 (the &quot;License&quot;);
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an &quot;AS IS&quot; BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and limitations under the License.

[⬆ Back to Top](#table-of-contents)
