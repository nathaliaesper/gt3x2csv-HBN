% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gt3x_2_csv.R
\name{gt3x_2_csv}
\alias{gt3x_2_csv}
\title{Convert GT3X Files to Raw CSV}
\usage{
gt3x_2_csv(
  gt3x_files,
  outdir = NULL,
  progress = FALSE,
  parallel = TRUE,
  cores = NULL,
  logfile = FALSE,
  verbose = FALSE,
  recursive = TRUE,
  actilife = FALSE
)
}
\arguments{
\item{gt3x_files}{The file or files to convert. You can provide any of a
path to a single file, a path to a directory, or a vector of file paths.}

\item{outdir}{A directory where converted CSV files will be saved. If NULL,
the files are saved in the same directory as the original files.}

\item{progress}{Display a progress bar. Defaults to TRUE.}

\item{parallel}{Use a parallel backend. Defaults to TRUE.}

\item{cores}{If \code{parallel == TRUE}, how many cores are used for processing.
By default this is the smaller of the number of cores available minus 1, or
the number of files to process.}

\item{logfile}{create a log file for debugging. Can be one of \code{FALSE}
(default; do not create a file), \code{TRUE} (create the log file at the default
location), or a path for where to store the log file.}

\item{verbose}{Logical for if additional information should be displayed.
Defaults to \code{FALSE}}

\item{recursive}{If gt3x_files is a directory, should sub-folders be searched
for GT3X  files?}

\item{actilife}{The version string for the header. By default, this is
"gt3x2csv v0.2.0". If your analysis depends on knowing an Actilife version,
you can provide one here.}
}
\value{
Nothing. Files are saved as a side effect.
}
\description{
Convert a GT3X file to the raw CSV format provided by ActiLife.
}
\examples{
\dontrun{
gt3x_2_csv(
    gt3x_files = my_directory,
    outdir = NULL, # Save to the same place
    progress = FALSE, # Show a progress bar?
    parallel = TRUE # Process files in parallel?
)
}
}
