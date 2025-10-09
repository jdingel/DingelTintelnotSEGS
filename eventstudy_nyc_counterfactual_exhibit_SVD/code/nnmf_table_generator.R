library(tidyverse)

rank_list <- commandArgs(trailingOnly=TRUE) %>%
    as.numeric()
skeleton <- read_file("eventstudy_nnmf_performance_skeleton.tex")

rank_count <- length(rank_list)

es_slope_int_MSE <- map(
    rank_list, \(r) {
        read_csv(str_c(
            "../input/slope_int_MSE_all_nnmf_", 
            r, ".csv"
        )) %>%
            mutate(rank = r)
    }
) %>%
    reduce(bind_rows) %>%
    group_by(rank) %>%
    summarise(mean_int = mean(intercept),
              mean_slope = mean(slope),
              mean_MSE = mean(mse))

es_perf_formatted <- str_flatten(c("Slope", 
                                   format(es_slope_int_MSE$mean_slope, 
                                          digits = 2)), 
                                 collapse = " & ") %>%
    str_c("\\\\\\\\\n",
          str_flatten(c("Int.", 
                        format(es_slope_int_MSE$mean_int, 
                               digits = 1)), 
                      collapse = " & "),
          "\\\\\\\\\n",
          str_flatten(c("MSE", 
                        format(es_slope_int_MSE$mean_MSE, 
                               digits = 4)), 
                      collapse = " & "),
          "\\\\\\\\") %>% 
    str_replace_all(" 0.", " .") %>%
    str_replace_all(" -0.", " -.")

skeleton %>%
    str_replace_all("RANKS_CENTERED", strrep("c", rank_count)) %>%
    str_replace_all("NUM_COLS", as.character(rank_count + 1)) %>%
    str_replace_all("NUM_RANKS", as.character(rank_count)) %>%
    str_replace("RANK_LIST", rank_list %>% str_flatten(collapse = " & ")) %>%
    str_replace("ES_PERF", es_perf_formatted) %>%
    write_file("../output/eventstudy_nnmf_performance.tex")
