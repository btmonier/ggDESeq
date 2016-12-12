#' @title 
#' Volcano plot from log fold changes and -log10 of the p-value
#'   
#' @author 
#' Brandon Monier, \email{brandon.monier@sdstate.edu}
#' 
#' @description
#' This function allows you to extract necessary results-based data from a 
#' DESEq object class to create a volcano plot (i.e. a scatter plot) of the
#' negative log of the p-value versus the log of the fold change while
#' implementing ggplot2 aesthetics. 
#'  
#' 
#' @details  
#' This function allows the user to extract various elements from a DESeq object
#' class which in turn, creates a temporary data frame to plot the necessary
#' ggplot aesthetics. Data points with 'extreme' values that exceed the default
#' viewing frame of the plot will change character classes (i.e. points of 
#' interest that either have a substantially large -log10 p-value or log fold
#' change).
#' 
#' @param data a DESeq object class
#' @param xlim optional limits to the x axis
#' @param padj significance threshold for adjusted p-value highlighting
#' 
#' @export
#' 
#' @examples
#' ggVolcano()

ggVolcano <- function (data, xlim = NULL, padj = 0.05) {
  require(ggplot2)
  
  tmp.df <- data.frame(
    results(data)[[1]],
    results(data)[[2]],
    results(data)[[3]],
    results(data)[[4]],
    results(data)[[5]],
    results(data)[[6]]
  )
  colnames(tmp.df) = colnames(results(data))
  
  p <- padj
  
  px = tmp.df$log2FoldChange
  if (is.null(xlim)) 
    xlim = c(-1, 1) * quantile(abs(px[is.finite(px)]), probs = 0.99) * 2
  
  tmp.df$isDE <- ifelse(is.na(tmp.df$padj), FALSE, tmp.df$padj < padj)
  
  tmp.plot <- ggplot(tmp.df, aes(x = pmax(xlim[1], pmin(xlim[2], px)), 
                                 y = -log10(pvalue))) +
    scale_shape_identity() +
    geom_point(
      shape = ifelse(px < xlim[1], 60, ifelse(px > xlim[2], 62, 16)),
      size  = ifelse(px < xlim[1], 5, ifelse(px > xlim[2], 5, 1.5)),
      color = ifelse((tmp.df$isDE == TRUE) & (abs(tmp.df$log2FoldChange) > 1), 
                     'red3', 'gray32'),
      alpha = 0.4) +
    xlab(expression(paste('log'['2'], ' fold change'))) +
    ylab(expression(paste('-log'['10'], '(p-value)'))) +
    geom_vline(
      xintercept = -1, 
      color      = 'royalblue1', 
      size       = 1, 
      alpha      = 0.8,
      linetype   = 'dashed') +
    geom_vline(
      xintercept = 1, 
      color      = 'royalblue1', 
      size       = 1, 
      alpha      = 0.8,
      linetype   = 'dashed') +
    geom_hline(
      yintercept = -log10(p),
      color      = 'royalblue1',
      size       = 1,
      alpha      = 0.8,
      linetype   = 'dashed') +
    theme_bw() 
  
  print(tmp.plot)
  
}