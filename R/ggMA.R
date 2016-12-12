#' @title 
#' MA plot from mean expression and log fold changes 
#'
#' @author 
#' Brandon Monier, \email{brandon.monier@sdstate.edu}
#'
#' @description
#' This function allows you to extract necessary results-based data from a 
#' DESeq object class to create a MA plot (i.e. a scatter plot) of log2 fold 
#' changes versus normalized mean counts while implementing ggplot2 aesthetics. 
#' 
#' @details  
#' This function allows the user to extract various elements from a DESeq object
#' class which in turn, creates a temporary data frame to plot the necessary
#' ggplot aesthetics. Data points with 'extreme' values that exceed the default
#' viewing frame of the plot will change character classes (i.e. points of 
#' interest a substantially large log fold change).
#' 
#' @param data a DESeq object class
#' @param ylim optional limits to the y axis
#' @param padj significance threshold for adjusted p-value highlighting
#' @param lfc fold change threshold for visualization
#' 
#' @export
#' 
#' @examples
#' ggMA()

ggMA <- function (data, ylim = NULL, padj = 0.05, lfc = 1) {
  require(ggplot2)
  
  tmp.df = data.frame(
    results(data)[[1]],
    results(data)[[2]],
    results(data)[[3]],
    results(data)[[4]],
    results(data)[[5]],
    results(data)[[6]]
  )
  colnames(tmp.df) = colnames(results(data))
  
  py = tmp.df$log2FoldChange
  if (is.null(ylim)) 
    ylim = c(-1, 1) * quantile(abs(py[is.finite(py)]), probs = 0.99) * 1.1
  
  tmp.df$isDE <- ifelse(is.na(tmp.df$padj), FALSE, tmp.df$padj < padj)
  
  tmp.plot <- ggplot(tmp.df, aes(x = baseMean, 
                                 y = pmax(ylim[1], pmin(ylim[2], py)))) +
    geom_point(
      shape = ifelse(py < ylim[1], 6, ifelse(py > ylim[2], 2, 16)),
      size  = ifelse(py < ylim[1], 2, ifelse(py > ylim[2], 2, 1.5)),
      color = ifelse(tmp.df$isDE != TRUE, 'gray32', 'red3'),
      alpha = 0.4) +
    scale_x_log10() +
    geom_hline(
      yintercept = 0, 
      color      = 'firebrick1', 
      size       = 2, 
      alpha      = 0.8,
      linetype   = 'longdash') +
    geom_hline(
      yintercept = -lfc, 
      color      = 'royalblue1', 
      size       = 1, 
      alpha      = 0.8,
      linetype   = 'dashed') +
    geom_hline(
      yintercept = lfc, 
      color      = 'royalblue1', 
      size       = 1, 
      alpha      = 0.8,
      linetype   = 'dashed') +
    xlab('mean expression [log(x)]') +
    ylab(expression(paste('log'['2'], ' fold change'))) +
    theme_bw() +
    theme(legend.position = 'none')
  
  print(tmp.plot)
  
}