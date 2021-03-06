#' Plot the distribution (geom_histogram) of each column in the given data frame. 
#' If the data is categorical data (factor or character), the statistics is set 
#' as "count". Otherwise, it is set as "bin". 
#' 
#' \code{ggdistr} plot the data distribution (histogram/bar for numeric/categorical variables)
#' 
#' @param data The data frame used for plot
#' @param n_sample Number of samples used for the plot. If it is NULL, then all 
#' records are used
#' @param ncol Number of columns for the plot layout 
#' @param sample_seed The seed used for sampling
#' 
#' @return ggplot of the histogram/bar for all variables
#'    
#' @examples
#' data <- rpart::stagec
#' ggdistr(data)
#' @export

ggdistr <- function(data, n_sample=NULL, ncol=3, sample_seed = 123, ...) {
  set.seed(sample_seed)
  if(is.null(n_sample)) {
    n_sample <- nrow(data)
  }
  dt_sample <- data[sample(nrow(data), min(n_sample, nrow(data))), ]
  
  plot_list <- lapply(colnames(dt_sample), function(col_x) {
    cat_flag <- is.factor(data[, col_x]) | is.character(data[, col_x])
    ggplot(dt_sample, aes_string(x = col_x)) + 
      geom_histogram(stat = ifelse(cat_flag, 'count', 'bin'), 
        fill = 'cornflowerblue', ...) +
      labs(x = NULL, title = col_x) + 
      theme_classic() +
      theme(axis.text.x = element_text(angle=25, hjust=1),
        rect = element_rect(linetype = 0, color = NA),
        axis.line.x = element_line(), axis.line.y = element_line(),
        strip.background = element_blank(),
        plot.title = element_text(hjust = 0.5))
  })
  
  cowplot::plot_grid(plotlist = plot_list, ncol = ncol)
}

# data <- rpart::stagec
# ggdistr(data[, 1:5])