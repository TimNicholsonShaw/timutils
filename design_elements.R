# A good start for how I like to theme graphs
common_theme_1 <- theme_minimal() +
  theme(panel.grid.major.y=element_blank(), 
          panel.grid.minor.x=element_blank(),
          panel.grid.major.x=element_blank(),
          panel.grid.minor.y=element_blank(),
          axis.ticks=element_line(size=0.1),
          panel.border=element_rect(size=0.7, fill=NA, color='black'),
          text=element_text(size=8, color='black'),
          axis.text=element_text(size=8, color='black'),
          axis.title=element_text(size=8, face="bold"),
          legend.title=element_blank(), 
          legend.key.height=unit(0.5, "line"),
          legend.key.width=unit(0.8, "line"),
          legend.text = element_text(size=8),
          plot.title = element_text(hjust = 0.5, size=8, face='bold'))

# Convert this to a palette object
tim_colors=c( 
    "#A4A4A5", # grey
    "#386cb0", # dark blue
    "#a6cee3", # light blue
    "#F08080" # salmon reddish
    )