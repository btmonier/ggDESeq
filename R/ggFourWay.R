#' @title 
#' Four-Way plot for comparison of log fold changes in a multiple factor RNA seq
#' experiment  
#'
#' @author 
#' Brandon Monier, \email{brandon.monier@sdstate.edu}
#'
#' @description
#' This function allows you to extract necessary results-based data from a 
#' DESeq object class to create a four-way plot to compare log fold changes in 
#' various treatments using ggplot2 aesthetics. 
#' 
#' @details  
#' This function allows the user to extract various elements from a DESeq object
#' class which in turn, creates a temporary data frame to plot the necessary
#' ggplot aesthetics. In order for this function to work, RNA seq experiments
#' must have multiple factors and levels including treatments and controls.
#' By having the recommended criteria, this function will extract the necessary
#' data by exploiting DESeq's 'contrast' parameters. Data points with 'extreme' 
#' values that exceed the default viewing frame of the plot will change character 
#' classes (i.e. points of interest a substantially large log fold change). 
#'  
#' @param data a DESeq object class with multiple factors and levels
#' @param x.level treatment for the x-axis of the plot
#' @param y.level treatment for the y-axis of the plot
#' @param control experimental control used in the experiment
#' @param factor factor given for the DESeq object for specific treatments
#' @param padj significance threshold for adjusted p-value highlighting
#' @param xlim optional limits to the x-axis
#' @param ylim optional limits to the y-axis
#' @param lfc foldchange threshold for visualization
#'   
#' @export
#' 
#' @examples
#' ggFourWay()

ggFourWay <- function(data, x.level, y.level, control, factor, padj = 0.05, 
                      xlim = NULL, ylim = NULL, lfc = NULL) {
  require(ggplot2)
  require(dplyr)
  
  tmp.x <- c(factor, control, x.level) 
  tmp.y <- c(factor, control, y.level)
  
  tmp.df <- data.frame(
    row.names = rownames(data),
    results(data, contrast = tmp.x)[[2]],
    results(data, contrast = tmp.x)[[6]],
    results(data, contrast = tmp.y)[[2]],
    results(data, contrast = tmp.y)[[6]]
  )
  
  colnames(tmp.df) <- c('log2fc.x', 'padj.x', 'log2fc.y', 'padj.y')
  
  tmp.df$isDE.x   <- ifelse(is.na(tmp.df$padj.x), FALSE, tmp.df$padj.x < padj)
  tmp.df$isDE.y   <- ifelse(is.na(tmp.df$padj.y), FALSE, tmp.df$padj.y < padj)
  tmp.df$isDE.all <- ifelse(
    (tmp.df$isDE.x == TRUE) & (tmp.df$isDE.y == TRUE), TRUE, FALSE
    )
  
  px   <- tmp.df$log2fc.x
  py   <- tmp.df$log2fc.y
  pall <- tmp.df$isDE.all == TRUE 
  
  if (is.null(xlim))
    xlim = c(-1, 1) * quantile(abs(px[is.finite(px)]), probs = 0.99) * 3
  if (is.null(ylim))
    ylim = c(-1, 1) * quantile(abs(py[is.finite(py)]), probs = 0.99) * 3
  if (is.null(lfc))
    lfc = 1
  
  tmp.col <- ifelse(
    (pall) & (px < -lfc) & (py < -lfc), 'royalblue1',
    ifelse(
      (pall) & (px > lfc) & (py > lfc), 'royalblue1',
      ifelse(
        (pall) & (px < -lfc) & (py > lfc), 'royalblue1',
        ifelse(
          (pall) & (px > lfc) & (py < -lfc), 'royalblue1',
          ifelse(
            (pall) & (px < lfc) & (py > lfc), 'green',
            ifelse(
              (pall) & (px < lfc) & (py < -lfc), 'green',
              ifelse(
                (pall) & (px > lfc) & (py < lfc), 'red',
                ifelse(
                  (pall) & (px < -lfc) & (py < lfc), 'red', 'grey75'
                )
              )
            )
          )
        )
      )
    )
  )
  
  tmp.size <- ifelse(
    (px < -lfc) & (py < -lfc), 3,
    ifelse(
      (px > lfc) & (py > lfc), 3,
      ifelse(
        (px < -lfc) & (py > lfc), 3,
        ifelse(
          (px > lfc) & (py < -lfc), 3,
          ifelse(
            (px < lfc) & (py > lfc), 2,
            ifelse(
              (px < lfc) & (py < -lfc), 2,
              ifelse(
                (px > lfc) & (py < lfc), 2,
                ifelse(
                  (px < -lfc) & (py < lfc), 2, 1
                )
              )
            )
          )
        )
      )
    )
  )
  
  tmp.shape <- ifelse(
    px < xlim[1], 17, 
    ifelse(
      px > xlim[2], 17, 
      ifelse(
        py < ylim[1], 17,
        ifelse(
          py > ylim[2], 17, 16
        )
      )
    )  
  )
  
  aes.x <- pmax(xlim[1], pmin(xlim[2], px))
  aes.y <- pmax(ylim[1], pmin(ylim[2], py))
  
  all.lab  <- c(x.level, y.level, control)
  
  aes.xlab <- bquote(
    .(all.lab[1]) ~ 'vs.' ~ .(all.lab[3]) ~ 'log'['2'] ~ 'fold change'
  )
  aes.ylab <- bquote(
    .(all.lab[2]) ~ 'vs.' ~ .(all.lab[3]) ~ 'log'['2'] ~ 'fold change'
  )
  
  tmp.plot <- ggplot(tmp.df, aes(x = aes.x, y = aes.y)) +
    geom_point(
      color = tmp.col,
      size  = tmp.size,
      shape = tmp.shape,
      alpha = 0.7
    ) +
    geom_vline(
      xintercept = c(-lfc, lfc), 
      color      = 'grey32', 
      size       = 1, 
      alpha      = 0.8,
      linetype   = 'dashed') +
    geom_hline(
      yintercept = c(-lfc, lfc),
      color      = 'grey32',
      size       = 1,
      alpha      = 0.8,
      linetype   = 'dashed') +
    geom_vline(
      xintercept = 0,
      color      = 'red3',
      size       = 0.5,
      alpha      = 0.8,
      linetype   = 'longdash') +
    geom_hline(
      yintercept = 0,
      color      = 'red3',
      size       = 0.5,
      alpha      = 0.8,
      linetype   = 'longdash') +
    xlab(aes.xlab) +
    ylab(aes.ylab) +
    theme_bw()
  
  print(tmp.plot)
  
}