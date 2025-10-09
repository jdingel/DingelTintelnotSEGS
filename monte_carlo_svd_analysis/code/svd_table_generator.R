library(tidyverse)
library(haven)

# Capture the command line arguments
rank_list_temp <- commandArgs(trailingOnly=TRUE)

# Separate numeric and string arguments
num_list <- c()
string_list <- c()

for (arg in rank_list_temp) {
  if (grepl("^[0-9]+$", arg)) {
    # Argument is numeric
    num_list <- c(num_list, as.numeric(arg))
  } else {
    # Argument is a string
    string_list <- c(string_list, arg)
  }
}

# Sort the numeric list
sorted_num_list <- sort(num_list)

# Combine the sorted numeric list with the string list
rank_list <- c(as.character(sorted_num_list), string_list)

skeleton <- read_file("monte_carlo_svd_performance_skeleton.tex")

rank_count <- length(rank_list)

## Monte Carlo Performance
mc_slope_int_MSE <- map2(
    rank_list, rank_list, \(r, orig_r) {
        read_dta(str_c(
            "../output/sum_continuum_labor_0_2.488905_1.09_", 
            r, ".dta"
        )) %>%
            mutate(rank = orig_r)
    }
) %>%
    reduce(bind_rows) %>%
    group_by(rank) %>%
    summarise(mean_int = round(mean(intercept_svd), 3),
              mean_slope = round(mean(slope_svd), 3),
              mean_MSE = round(mean(mse_svd), 4)) %>%
    mutate(rank_numeric = as.numeric(rank)) %>%
    arrange(is.na(rank_numeric), rank_numeric, rank) %>%
    select(-rank_numeric)

## Print the results
print(mc_slope_int_MSE)


## Event study Performance
es_rank_list <- rank_list
index_to_replace <- which(rank_list == "full")
es_rank_list[index_to_replace] <- "2143"

es_slope_int_MSE <- map2(
    es_rank_list, rank_list, \(r, orig_r) {
        read_csv(str_c(
            "../input/slope_int_MSE_all_svd_", 
            r, ".csv"
        )) %>%
            mutate(rank = orig_r)
    }
) %>%
    reduce(bind_rows) %>%
    group_by(rank) %>%
    summarise(mean_int = mean(intercept),
              mean_slope = mean(slope),
              mean_MSE = mean(mse)) %>%
    mutate(rank_numeric = as.numeric(rank)) %>%
    arrange(is.na(rank_numeric), rank_numeric, rank) %>%
    select(-rank_numeric)

## Print the results
print(es_slope_int_MSE)

##
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

mc_perf_formatted <- str_flatten(c("Slope", 
                                   format(mc_slope_int_MSE$mean_slope, 
                                          digits = 2)), 
                                 collapse = " & ") %>%
    str_c("\\\\\\\\\n",
          str_flatten(c("Int.", 
                        format(mc_slope_int_MSE$mean_int, 
                               digits = 3)), 
                      collapse = " & "),
          "\\\\\\\\\n",
          str_flatten(c("MSE", 
                        format(mc_slope_int_MSE$mean_MSE, 
                               digits = 3)), 
                      collapse = " & "),
          "\\\\\\\\") %>% 
    str_replace_all(" 0.", " .") %>%
    str_replace_all(" -0.", " -.")

rank_list[index_to_replace] <- "full rank"
skeleton %>%
    str_replace_all("RANKS_CENTERED", strrep("c", rank_count)) %>%
    str_replace_all("NUM_COLS", as.character(rank_count + 1)) %>%
    str_replace_all("NUM_RANKS", as.character(rank_count)) %>%
    str_replace("RANK_LIST", rank_list %>% str_flatten(collapse = " & ")) %>%
    str_replace("MONTE_CARLO_PERF", mc_perf_formatted) %>%
    str_replace("ES_PERF", es_perf_formatted) %>%
    write_file("../output/monte_carlo_svd_performance.tex")