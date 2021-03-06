
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gt3x2csv - HBN

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/tarensanders/gt3x2csv/workflows/R-CMD-check/badge.svg)](https://github.com/tarensanders/gt3x2csv/actions)
<!-- badges: end -->

Changes made by the Healthy Brain Network project:

We made a change on the Utils.R file.

The previous package saves the file with the extension "RAW.csv".

We changed to save only ".csv" instead of "RAW.csv".

-------------

The goal of gt3x2csv is to convert .gt3x files into (raw) csv files so
that they can be analysed in other packages such as
[GGIR](https://cran.r-project.org/package=GGIR). The goals of this
package are:

1.  To create output that as closely mimics output from ActiLife as
    possible.
2.  To be orders of magnitude faster than using ActiLife for conversion.

This package is a rewrite of a package previously written by Danilo de
Paula Santos ([@danilodpsantos](https://github.com/danilodpsantos)).

## Why use gt3x2csv instead of ActiLife?

gt3x2csv has a number of advantages over converting files in ActiLife.
Firstly, it is substantially faster both on a per-file basis, and
overall. This is largely thanks to the great work on the
[`read.gt3x`](https://github.com/THLfi/read.gt3x) package, which uses
C++ to read the activity data quickly. gt3x2csv is further bolsted by
being able to process files in parallel, something not available on
ActiLife.

As an example of how much faster it is, see the table below.

| Method                                                          | One File | Five Files | Thirty Files<sup>[1](#myfootnote1)</sup> |
|-----------------------------------------------------------------|----------|------------|------------------------------------------|
| **Actilife<sup>[2](#myfootnote2)</sup>**                        | 58s      | 4min 55s   | 29min 20s                                |
| **gt3x2csv<sup>[3](#myfootnote3)</sup><sub>(Sequential)</sub>** | 8s       | 40s        | 4mins                                    |
| **gt3x2csv<sub>(Parallel)</sub>**                               | 8s       | 14s        | 1min 42s                                 |

<a name="myfootnote1"><sup>1</sup></a> All files were 159MB, or a little
over three days of data.<br> <a name="myfootnote2"><sup>2</sup></a>
Using ActiLife v6.11.9 (newer versions might be faster.<br>
<a name="myfootnote3"><sup>3</sup></a> As run on a AMD Ryzen 7 3700X
8-Core CPU; 32GB of RAM.

## What does gt3x2csv do?

gt3x2csv uses [`read.gt3x`](https://github.com/THLfi/read.gt3x) to
unpack the GT3X file, and formats the output in the same way as
ActiLife.

## Installation

gt3x2csv is not (currently) available on CRAN. You can install from
GitHub:

``` r
# install.packages("devtools")
devtools::install_github("tarensanders/gt3x2csv")
```

## Example

Using gt3x2csv is simple. You can provide any of a single file to
process, a vector of file paths, or a directory. If you do not provide
an output directory, the resulting CSV files are stored in the sample
place as the originals. Here is an example:

``` r
library(gt3x2csv)

# Setting up a test directory - ignore this.
my_directory <- gt3x2csv:::local_dir_with_files()

# An example directory with some GT3X files
list.files(my_directory)
#> [1] "test_file1.gt3x" "test_file2.gt3x" "test_file3.gt3x" "test_file4.gt3x"
#> [5] "test_file5.gt3x"
gt3x_2_csv(
  gt3x_files = my_directory,
  outdir = NULL, # Save to the same place
  progress = FALSE, # Show a progress bar?
  parallel = TRUE # Process files in parallel?
  )

# Directory now has the new files.
list.files(my_directory)
#>  [1] "test_file1.gt3x"   "test_file1RAW.csv" "test_file2.gt3x"  
#>  [4] "test_file2RAW.csv" "test_file3.gt3x"   "test_file3RAW.csv"
#>  [7] "test_file4.gt3x"   "test_file4RAW.csv" "test_file5.gt3x"  
#> [10] "test_file5RAW.csv"
```

## Caveat Emptor

A few warnings for those using gt3x2csv.

### File Sizes

A GT3X file is a zip file containing some metadata (`info.txt`) and a
binary file (`log.bin`) with data recorded by the device. The GT3X file
is compressed, making it smaller than the raw versions of these files.
Converting to CSV uncompresses the file, and will take up more space.
This is true regardless of if you use ActiLife or gt3x2csv. How much
extra space seems to depend on the size of the file. Here???s three files,
and their compressed/uncompressed sizes.

| File       | GT3X Size | CSV Size | Times Larger |
|------------|-----------|----------|--------------|
| **File 1** | 200KB     | 4.28MB   | \~22         |
| **File 2** | 159MB     | 524MB    | \~3.3        |
| **File 3** | 352MB     | 1.13GB   | \~3.3        |

All this is to say that if you can do your analysis without saving CSV
files in the middle (e.g., using
[`read.gt3x`](https://github.com/THLfi/read.gt3x) or
[`AGread`](https://github.com/paulhibbing/AGread)), that would be
better. But, some processing packages (e.g.,
[`GGIR`](https://github.com/wadpac/GGIR)) don???t allow this (mostly due
to memory issues).

### Memory Use

In the process of unzipping the files, the data are temporarily stored
in memory. If you run gt3x2csv in parallel with lots of cores, you might
run out of memory. If this happens, just set `cores` to be a lower
value. For example, using all 16 threads on my 8 core CPU was actually
slower to process 30 files than setting `cores = 8` and using 8 threads,
because the 32GB of RAM was being exhausted.

### Differences to ActiLife

I???ve validated gt3x2csv against the output from ActiLife using several
different files. There are also tests to check that changes to the
package do not muck this up. However, this package is provided with no
guarantee, and you should test the output yourself.
