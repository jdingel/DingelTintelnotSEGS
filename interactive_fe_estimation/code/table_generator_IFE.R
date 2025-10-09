library(tidyverse)

max_rank <- commandArgs(trailingOnly=TRUE) %>%
    as.numeric()

ife_ranks <- 0:max_rank

skeleton <- read_file("IFE_estimation_results_skeleton.tex")

beta_ife <- lapply(
    ife_ranks,
    \(r) {
        read_csv(str_c("../output/beta_", r, ".csv"), col_names = "beta") %>%
            unlist()
    }) %>% 
    unlist()

r2_ife <- read_csv("../temp/ife_mcf_r2.csv") %>%
    filter(R %in% ife_ranks) %>%
    select(R2) %>%
    unlist()

lodes_df <- read_csv(str_c("../temp/nyc2010_lodes.csv")) 

ols_output <- read_file(str_c("../input/NYC2010_gravity_time_impute_simple.tex"))

beta_ols <- ols_output %>%
    str_extract("Commuting cost .*") %>%
    str_split("&") %>%
    (\(x) {x[[1]][3]}) %>%
    str_remove_all("\\\\") %>%
    as.numeric()

r2_ols <- ols_output %>%
    str_extract("R.*") %>%
    str_split("&") %>%
    (\(x) {x[[1]][3]}) %>%
    str_remove_all("\\\\") %>%
    as.numeric()

lodes_summary <- lodes_df %>% 
    summarise(loc_pairs_ols = sum(X_ij > 0), 
              loc_pairs = n(), 
              commuter_count = sum(X_ij)) %>%
    unlist()

r2s_formatted <- c(r2_ols, r2_ife) %>%
    round(digits = 3) %>%
    str_c(collapse = " & ")

betas_formatted <- c(beta_ols, beta_ife) %>%
    round(digits = 3) %>%
    str_c(collapse = " & ")

rank_header <- str_c("& & ", 
                     lapply(0:max_rank, 
                            \(r){str_c("\\\\(R = ", r, "\\\\)")}) %>% 
                         str_c(collapse = " & "))

skeleton %>%
    str_replace_all("COLS_CENTERED", strrep("c", max_rank + 1)) %>%
    str_replace_all("NUM_COLS", as.character(3 + max_rank)) %>%
    str_replace_all("NUM_RANKS", as.character(max_rank + 1)) %>%
    str_replace_all("RANK_HEADER", rank_header) %>%
    str_replace_all("ELASTICITY_ESTIMATES", betas_formatted) %>%
    str_replace_all("R2S", r2s_formatted) %>%
    str_replace_all("LOC_PAIRS_OLS", lodes_summary["loc_pairs_ols"] %>% format(big.mark = ",")) %>%
    str_replace_all("LOC_PAIRS", lodes_summary["loc_pairs"] %>% format(big.mark = ",")) %>%
    str_replace_all("COMMUTER_COUNT", lodes_summary["commuter_count"] %>% format(big.mark = ",")) %>%
    write_file("../output/gravity_time_NYC_IFE.tex")
