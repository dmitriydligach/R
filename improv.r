#!/usr/bin/env Rscript

# generate plots for multiple phenotypes
all.phenotypes <- function(directory) {

  cat(sprintf("%3s %7s %7s %7s\n", "", "500", "1000", "3000"))

  total_improvement <- 0
  for(phenotype in c("cd", "uc", "ms", "t2d")) {
    phenotype_improvement <- average.improvement(directory, phenotype)
    total_improvement <- total_improvement + phenotype_improvement
  }

  cat(sprintf("%3s %7.2f\n", "av", (total_improvement * 100) / 12))
}

# average improvement above baseline
average.improvement <- function(directory, phenotype) {
  
  file <- paste(phenotype, ".txt", sep="")
  data <- load.results(file.path(directory, file))
  data.subset <- data[data$size <= MAXSIZE, ]
  
  diff500 <- data.subset$u500 - data.subset$u0
  diff1000 <- data.subset$u1000 - data.subset$u0
  diff3000 <- data.subset$u3000 - data.subset$u0

  out <- sprintf("%3s %7.2f %7.2f %7.2f\n", phenotype,
                 mean(diff500)*100, mean(diff1000)*100, mean(diff3000)*100)
  cat(out)

  return(mean(diff500) + mean(diff1000) + mean(diff3000))
}

# source RESULTROOT and load.results() 
source("common.r")

# compute average improvement up to this size
MAXSIZE = 390

for(experiment_directory in list.files(RESULTROOT)) {
  cat(sprintf("* %s\n\n", experiment_directory))
  all.phenotypes(file.path(RESULTROOT, experiment_directory))
  cat("\n")
}
