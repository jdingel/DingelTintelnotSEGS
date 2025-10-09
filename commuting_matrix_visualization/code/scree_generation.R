library(tidyverse)
library(haven)  # Load DTA files
library(extrafont) # Font in figure legends

lodes_data <- read_dta("../input/nyc2010_lodes_wzero_wdelta.dta") %>%
    mutate(i = as.numeric(i),
           j = as.numeric(j)) %>%
    arrange(j, i)

lodes_svd_full <- lodes_data$X_ij %>% 
    matrix(ncol = 2143) %>% 
    svd()

tibble(rank = 1:2143,
       sin_vals = lodes_svd_full$d) %>%
    filter(rank <= 25) %>%
    ggplot() + 
    geom_point(aes(x = rank, y = sin_vals / sum(lodes_svd_full$d)), 
               size = 1, alpha = 1) + 
    geom_line(aes(x = rank, y = sin_vals / sum(lodes_svd_full$d)), 
              linewidth = 0.8, alpha = 0.5) + 
    geom_hline(yintercept = 0.005,
               linetype = "dotdash", linewidth = 1) +
    geom_label(aes(x = 22, y = 0.0095, label = "0.5% of total variance", family = "Times")) +
    scale_x_continuous(limits = c(1, 25),
                       breaks = 1:25,
                       minor_breaks = NULL,
                       expand = c(0.025, 0.025)) +
    scale_y_continuous(breaks = c(0.02, 0.04, 0.06),
                       labels = c("2%", "4%", "6%")) +
    labs(x = "Rank", y = "Percent of the sum of singular values", 
         caption = "Largest 25 singular values, ordered") +
    theme_classic() +
    theme(text = element_text(family = "Times", color = "black"))

ggsave("../output/lodes_svd_normalized_scree_25.png", bg = "white",
       width = 6, height = 3)
