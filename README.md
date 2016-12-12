# ggDESeq

Overview
--------

The aim of `ggDESeq` is to make rapid visualizations of commonly used RNA seq plots derived from `DESeq` data sets a possibility. By implementing the aesthetic qualities of `ggplot2`, we are able to generate publication-worthy graphics. You need to provide the `DESeq`-related data frame with subsequent experimental conditions, and it takes care of the graphics and condtional statements.

Installation
------------

The easiest way to obtain this package is to install `devtools` and pull the package contents directly from GitHub.

``` r
# Load packages
pack.man <- function(pkg) {
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

packages <- c('devtools')
pack.man(packages)

install.github('btmonier/ggDESeq')
```

Dependencies
------------

Since this package assumes that you have prior knowledge with RNA seq experimentation and `DESeq2`, it is mandatory that you not only have `DESeq2` already installed in your `R` environment, but also `ggplot2` for aesthetic rendering. `DESeq2` can be found on Bioconductor. For further information on `DESeq2` and Bioconductor in general, please visit the following [website](http://bioconductor.org/packages/release/bioc/html/DESeq2.html).
