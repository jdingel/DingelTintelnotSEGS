#-------------------
# Get the generators
#-------------------
source("rlaptrans.r")


set.seed(682) # The seed number is from Ridout (2009)

#-----------------------------
# Define the Laplace transform
#-----------------------------
lt.psd_pdf <- function(s, zeta) {
   exp(-s^zeta)
}


args <- commandArgs(trailingOnly=TRUE)
zeta <- as.numeric(args[1])
num <- as.numeric(args[2])

psd_draws <- rlaptrans(num, lt.psd_pdf, zeta)
log_psd <- sort(log(psd_draws))
pcentile <- seq(0, 1, length.out = num)

cdf <- data.frame(zeta, pcentile, log_psd)
output_filepath <- paste0("../temp/log_psd_cdf_",args[1],".csv")
write.csv(cdf, file = output_filepath, row.names = FALSE)