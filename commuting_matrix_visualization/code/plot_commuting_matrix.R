library(tidyverse)
library(haven)  # Load DTA files
library(scales)
library(extrafont) # Font in figure legends
library(cowplot)

# Define ranks
svd_ranks <- c(5, 16, 100, 200)
svd_rank_labels <- paste("svd_", as.character(svd_ranks), "_approx", sep = "") 
svd_rank_colnames <- paste("X_ij_preperiod_", as.character(svd_ranks), sep = "") 
nnmf_rank <- 5
ife_rank <- 1

# Define matrix plotting function
plot_matrix <- function(df, label) {
    df %>%
    ggplot(aes(j_ind, -i_ind)) +
    geom_tile(mapping = aes(fill = log(commuters), color = "Zero commuters"), linetype = "blank") +
    theme_minimal() +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          text = element_text(family = "Times"),
          axis.title = element_text(size = 18),
          axis.text = element_blank(),
          legend.position = "none") +
    scale_fill_continuous(breaks = c(-4, -2, 0, 2, 4, 6), limits = c(-4, 7),
                          na.value = "#f4f4f4", low = "#f4f4f4", high = "grey40") +
    scale_color_manual(values = "#f5f5f5", labels = "Zero commuters", 
                       name = "") +
    guides(color = guide_legend(override.aes = list(fill = "#f5f5f5"),
                                title.position = "top"),
           fill = guide_colourbar(title.position = "top", 
                                  label.position = "bottom")) +
    labs(x = "Destination", y = "Origin",
         fill = "Commuters (log)", title = label)
}

# Load 2010 LODES data
lodes_data <- read_dta("../temp/nyc2010_lodes_cbmfit.dta") %>%
    mutate(i = as.numeric(i),
           j = as.numeric(j))

# Translate between tract IDs and indices
is <- tibble(i = lodes_data$i %>% unique()) %>% mutate(i_ind = row_number())
js <- tibble(j = lodes_data$j %>% unique()) %>% mutate(j_ind = row_number())

plot_df <- lodes_data %>% left_join(is) %>% left_join(js)

# Read in SVD-approximated data
lodes_svd_approx_df <- data.frame(i=lodes_data$i, j=lodes_data$j)
for(rank in svd_ranks){
    lodes_svd_approx <- data.frame(read_dta(
        str_c("../temp/nyc_2010_levels_tracttotract_approx_svd_", rank, ".dta")))
    # Rename column for the approximated data
    colnames(lodes_svd_approx)[3] <- str_c("X_ij_preperiod_", rank)
    lodes_svd_approx_df <- cbind(lodes_svd_approx_df, lodes_svd_approx)
}

# Read in non-negative matrix factorization approximated data
lodes_nnmf <- read_dta(str_c("../temp/nyc_2010_levels_tracttotract_approx_nnmf_", nnmf_rank, ".dta")) %>%
    mutate(i = as.numeric(i),
         j = as.numeric(j)) %>%
    rename("X_ij_preperiod_nnmf" = "X_ij_preperiod")

# Read in IFE fitted commuting flows
lodes_ife <- read_csv("../temp/labor_b_approx_ife_1.csv") %>%
    mutate(i = as.numeric(i),
         j = as.numeric(j)) %>%
    rename("X_ij_preperiod_ife" = "X_ij_preperiod")

# Combine data into a tibble for plotting
plot_df <- lodes_data %>%
  left_join(is) %>%
  left_join(js) %>%
  left_join(lodes_ife) %>%
  left_join(lodes_nnmf) %>%
  left_join(lodes_svd_approx_df[, !duplicated(names(lodes_svd_approx_df))])

# Generate individual plot panels without headers
## 2010 LODES commuting data
lodes_plot <- plot_matrix(plot_df %>%
                            rename("commuters" = "X_ij"),
                        "")
lodes_plot
ggsave("../output/lodes_visualization.png", 
       bg = "white", height = 8, width = 7.8, dpi = 300)

## Plot common legends
plot_legend <- get_legend(lodes_plot +
                            theme(legend.position = "bottom", 
                                  axis.text = element_blank(), 
                                  axis.title = element_blank()) +
                            guides(color = guide_legend(override.aes = list(fill = "#f4f4f4"),
                                                        title.position = "top"),
                                   fill = guide_colourbar(title.position = "top",
                                                          label.position = "bottom")))
plot_legend
ggsave("../output/lodes_visualizations_legend.png", 
       plot = plot_legend,  height = 1.5, width = 3, dpi = 300)

## Covariates-based model, fitted values
cbm_plot <- plot_matrix(plot_df %>%
                            rename("commuters" = "X_ij_pred"),
                        "")
cbm_plot
ggsave("../output/lodes_cbm_visualization.png",
       bg = "white", height = 8, width = 7.8, dpi = 300)

## str_c("Rank-", rank, " SVD approximation")
for(rank in svd_ranks){
    print(rank)
    svd_plot <- plot_matrix(plot_df %>%
                              rename("commuters" = str_c("X_ij_preperiod_", rank)), 
                            "")
    svd_plot
    ggsave(str_c("../output/lodes_svd_", rank, "_visualization.png"),
           bg = "white", height = 8, width = 7.8, dpi = 300)
}

## str_c("Rank-", nnmf_rank, " Non-negative matrix factorization")
nnmf_plot <- plot_matrix(plot_df %>%
                            rename("commuters" = "X_ij_preperiod_nnmf"),
                        "")
nnmf_plot
ggsave(str_c("../output/lodes_nnmf_", nnmf_rank, "_visualization.png"),
       bg = "white", height = 8, width = 7.8, dpi = 300)

## str_c("IFE factor rank ", ife_rank, ", fitted values")
ife_plot <- plot_matrix(plot_df %>%
                            rename("commuters" = "X_ij_preperiod_ife"),
                        "")
ife_plot
ggsave(str_c("../output/lodes_ife_", ife_rank, "_visualization.png"),
       bg = "white", height = 8, width = 7.8, dpi = 300)

dev.off() # Close a plotting device and upload to imguR