library(readr)
library(dplyr)
library(ggplot2)
library(extrafont)
library(scales)
library(grid)
library(RColorBrewer)
library(digest)
library(readr)
library(stringr)

fontFamily <- "CMU Concrete"
fontTitle <- "CMU Concrete"

reorder_within <- function(x, by, within, fun = mean, sep = "___", ...) {
  new_x <- paste(x, within, sep = sep)
  reorder(new_x, by, FUN = fun)
}

repmat = function(X,m,n){
  ##R equivalent of repmat (matlab)
  mx = dim(X)[1]
  nx = dim(X)[2]
  matrix(t(matrix(X,mx,nx*n)),mx*m,nx*n,byrow=T)
}


capitalizeNonStopwords <- function(s) {
  #Capitalize if its not a stopword or longer than 2 characters.
  if (nchar(s)<2|s %in% stopwords$word){
    return(s)
  } else
  {
    return(paste0(toupper(substring(s, 1,1)), substring(s, 2)))
  }
}

simpleCap <- function(x) {
  s <- strsplit(x, " ")[[1]]
  paste(lapply(s, capitalizeNonStopwords), collapse=" ") %>% return()
}

scale_x_reordered <- function(..., sep = "___") {
  reg <- paste0(sep, ".+$")
  ggplot2::scale_x_discrete(labels = function(x) gsub(reg, "", x), ...)
}

neutral_colors = function(number) {
  return (brewer.pal(11, "RdYlBu")[-c(5:7)][(number %% 8) + 1])
}

set1_colors = function(number) {
  return (brewer.pal(9, "Set1")[c(-6,-8)][(number %% 7) + 1])
}

theme_custom <- function() {theme_bw(base_size = 8) + 
    theme(panel.background = element_rect(fill="#eaeaea"),
          plot.background = element_rect(fill="white"),
          panel.grid.minor = element_blank(),
          panel.grid.major = element_line(color="#dddddd"),
          axis.ticks.x = element_blank(),
          axis.ticks.y = element_blank(),
          axis.title.x = element_text(family=fontTitle, size=8, vjust=-.3),
          axis.title.y = element_text(family=fontTitle, size=8, vjust=1.5),
          panel.border = element_rect(color="#cccccc"),
          text = element_text(color = "#1a1a1a", family=fontFamily),
          plot.margin = unit(c(0.25,0.1,0.1,0.35), "cm"),
          plot.title = element_text(family=fontTitle, size=9, vjust=1))                          
}

web_Layout <- grid.layout(nrow = 2, ncol = 1, heights = unit(c(2,
                                                               0.125), c("null", "null")), )
tallweb_Layout <- grid.layout(nrow = 2, ncol = 1, heights = unit(c(3.5,
                                                                   0.125), c("null", "null")), )
video_Layout <- grid.layout(nrow = 1, ncol = 2, widths = unit(c(2,
                                                                1), c("null", "null")), )

#grid.show.layout(Layout)
vplayout <- function(...) {
  grid.newpage()
  pushViewport(viewport(layout = web_Layout))
}

talllayout <- function(...) {
  grid.newpage()
  pushViewport(viewport(layout = tallweb_Layout))
}

vidlayout <- function(...) {
  grid.newpage()
  pushViewport(viewport(layout = video_Layout))
}

subplot <- function(x, y) viewport(layout.pos.row = x,
                                   layout.pos.col = y)

web_plot <- function(a) {
  vplayout()
  print(a, vp = subplot(1, 1))
}

tallweb_plot <- function(a) {
  talllayout()
  print(a, vp = subplot(1, 1))
}

video_plot <- function(a) {
  vidlayout()
  print(a, vp = subplot(1, 1))
}

save_image <- function(plot, filename, source = '', pdf = FALSE, w=4, h=3, tall=F, dark=F, bg_overide=NA) {
  png(paste(filename,"png",sep="."),res=300,units="in",width=w,height=h)
  plot.new()
  #if (!is.na(bg_overide)) {par(bg = bg_overide)}
  ifelse(tall,tallweb_plot(plot),web_plot(plot))
  dev.off()
  
  if (pdf) {
    ggsave(paste(filename,"pdf",sep="."), plot, width=w, height=h)
  }
}

video_save <- function(plot1, plot2, filename) {
  png(paste(filename,"png",sep="."),res=300,units="in",width=1920/300,height=1080/300)
  video_plot(plot1,plot2)
  dev.off()
  
}

fte_theme <- function (palate_color = "Greys") {
  
  #display.brewer.all(n=9,type="seq",exact.n=TRUE)
  palate <- brewer.pal(palate_color, n=9)
  color.background = palate[1]
  color.grid.minor = palate[3]
  color.grid.major = palate[3]
  color.axis.text = palate[6]
  color.axis.title = palate[7]
  color.title = palate[9]
  #color.title = "#2c3e50"
  
  font.title <- "CMU Concrete"
  font.axis <- "CMU Concrete"
  #font.axis <- "M+ 1m regular"
  #font.title <- "Arial"
  #font.axis <- "Arial"
  
  theme_bw(base_size=9) +
    # Set the entire chart region to a light gray color
    theme(panel.background=element_rect(fill=color.background, color=color.background)) +
    theme(plot.background=element_rect(fill=color.background, color=color.background)) +
    theme(panel.border=element_rect(color=color.background)) +
    # Format the grid
    theme(panel.grid.major=element_line(color=color.grid.major,size=.25)) +
    theme(panel.grid.minor=element_blank()) +
    #scale_x_continuous(minor_breaks=0,breaks=seq(0,100,10),limits=c(0,100)) +
    #scale_y_continuous(minor_breaks=0,breaks=seq(0,26,4),limits=c(0,25)) +
    theme(axis.ticks=element_blank()) +
    # Dispose of the legend
    theme(legend.position="none") +
    theme(legend.background = element_rect(fill=color.background)) +
    theme(legend.text = element_text(size=7,colour=color.axis.title,family=font.axis)) +
    # Set title and axis labels, and format these and tick marks
    theme(plot.title=element_text(colour=color.title,family=font.title, size=9, vjust=1.25, lineheight=0.1)) +
    theme(axis.text.x=element_text(size=7,colour=color.axis.text,family=font.axis)) +
    theme(axis.text.y=element_text(size=7,colour=color.axis.text,family=font.axis)) +
    theme(axis.title.y=element_text(size=7,colour=color.axis.title,family=font.title, vjust=1.25)) +
    theme(axis.title.x=element_text(size=7,colour=color.axis.title,family=font.title, vjust=0)) +
    
    # Big bold line at y=0
    #geom_hline(yintercept=0,size=0.75,colour=palate[9]) +
    # Plot margins and finally line annotations
    theme(plot.margin = unit(c(0.35, 0.2, 0.15, 0.4), "cm")) +
    
    theme(strip.background = element_rect(fill=color.background, color=color.background),strip.text=element_text(size=7,colour=color.axis.title,family=font.title))
  
}
