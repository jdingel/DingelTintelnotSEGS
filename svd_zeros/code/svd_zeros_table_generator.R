library(tidyverse)

rank_list <- commandArgs(trailingOnly=TRUE) %>%
    as.numeric()
max_nnmf_rank <- tail(rank_list, n = 1)
nnmf_ranks <- rank_list[rank_list <= max_nnmf_rank] %>% unique() %>% sort()
svd_ranks <- rank_list %>% unique() %>% sort()

skeleton <- read_file("svd_zeros_skeleton.tex")

rank_count <- length(svd_ranks)

zeros_nnmf <- lapply(nnmf_ranks, 
                     function(r) {
                         read.table(str_c("../input/zeros_share_nnmf_", r, ".txt"), 
                                    sep = "%")[1]}) %>%
    unlist()

zeros_svd <- lapply(svd_ranks, 
                    function(r) {
                        read.table(str_c("../input/zeros_share_", r, ".txt"), 
                                   sep = "%")[1]}) %>%
    unlist()

zeros_df <- tibble(rank = svd_ranks, 
                   svd_zeros = zeros_svd) %>%
    left_join(tibble(rank = nnmf_ranks, 
                     nnmf_zeros = zeros_nnmf), 
              by = "rank") %>%
    transmute(`Approximation Rank` = rank,
              `SVD (with truncation)` = as.character(svd_zeros) %>% 
                  str_c("%"),
              `Non-negative factorization` = as.character(nnmf_zeros) %>% 
                  str_c("%"))

zeros_svd_formatted <- str_c("SVD & ",
    zeros_svd %>%
    signif(digits = 2) %>%
    str_flatten(collapse = " & "),
    "\\\\\\\\\n")

zeros_nnmf_formatted <- str_c("NNMF & ",
    zeros_nnmf %>% 
    signif(digits = 2) %>%
    str_flatten(collapse = " & "),
    "\\\\\\\\\n") %>%
    str_replace_all(" 0.[1-9]", " .")

skeleton %>%
    str_replace_all("RANKS_CENTERED", strrep("c", rank_count)) %>%
    str_replace_all("NUM_COLS", as.character(rank_count + 1)) %>%
    str_replace_all("NUM_RANKS", as.character(rank_count)) %>%
    str_replace("RANK_LIST", svd_ranks %>% str_flatten(collapse = " & ")) %>%
    str_replace("SVD_PROPORTIONS", zeros_svd_formatted) %>%
    str_replace("NNMF_PROPORTIONS", zeros_nnmf_formatted) %>%
    write_file("../output/svd_zeros.tex")
