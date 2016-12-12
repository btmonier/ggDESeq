# ggDESeq

Overview
--------

The aim of 'ggDESeq' is to make rapid visualizations of commonly used RNA seq plots derived from 'DESeq' data sets a possibility. By implementing the aesthetic qualities of 'ggplot2', we are able to generate publication-worthy graphics. You need to provide the DESeq-related data frame with subsequent experimental conditions, and it takes care of the graphics and condtional statements.

Installation
------------

The easiest way to obtain this package is to install 'devtools' and pull the package contents directly from GitHub.

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
