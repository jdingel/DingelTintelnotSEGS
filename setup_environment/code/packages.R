packages <- c("tidyverse", "kableExtra", "assertthat", "stargazer", "haven", "ggpubr", "scales", "extrafont", "cowplot")

# Create a directory for  packages
dir.create(path = Sys.getenv("R_LIBS_USER"), showWarnings = FALSE, recursive = TRUE)

i <- 1
output <- NA
for (package in packages) {
  if (require(package, character.only = TRUE) == FALSE) {
    install.packages(package, lib = Sys.getenv("R_LIBS_USER"),
                     repos = "http://cran.us.r-project.org")
    message(paste("Installing", package, sep = ""))
  }
  version <- packageDescription(package, fields = "Version")
  output[i] <- paste(package, version, sep = " : ")
  print(output)
  i <- i + 1
}

output <- paste(output, collapse = "\n")
output <- paste("Packages installed: ", output, sep = "\n")
write.table(output, "../output/R_packages.txt", col.names = FALSE, row.names = FALSE)