## -----------------------------------------------------------------------------
# delete environment
rm(list=ls())
## -----------------------------------------------------------------------------
species_tables <- 
	split(iris[,-5],  ## what to split
		  iris[, 5])  ## split by what

class(species_tables)
names(species_tables)


## -----------------------------------------------------------------------------

head(species_tables[["setosa"]],n=3)


## -----------------------------------------------------------------------------
species_means <- 
	rbind(setosa = 
		  	colMeans( ## return table column means as a vector
		  		species_tables[["setosa"]]
		  		),
		  versicolor = 
		  	colMeans(species_tables[["versicolor"]]),
	      virginica = 
		  	colMeans(species_tables[["virginica"]])
	)

species_means
## -----------------------------------------------------------------------------

## These colors are supposed to be easy to
## discriminate for sight-impaired people.
species_colors = setNames( ## makes a named vector
	                palette()[1:3],  rownames(species_means)
				 )
species_colors


## -----------------------------------------------------------------------------

## colors reflecting the organ type:
trait_colors <-
	c(Petal.Length = "orange2",Petal.Width = "yellow2",
      Sepal.Length = "blue3",Sepal.Width = "lightblue"
	)
trait_colors 


## -----------------------------------------------------------------------------

barplot(## one plot per column == trait,
	    ## one bar == species mean!
	    species_means,
	    
	    ## do not stack the bars
		beside=TRUE,
		
		## larger group labels
		cex.names=1.5,
		
		col=species_colors,
		)

## add a legend (plot "augmentation"!)
legend("topright",
	   rownames(species_means), 
	   fill=species_colors,
	   cex=1.5)



## -----------------------------------------------------------------------------
m <-  t(species_means) ## TRANSPOSE

barplot(## one plot per column == species,
	    ## one bar == trait mean!
		m,
		
	    ## do not stack the bars
		beside=TRUE,
		
		## larger group labels
		cex.names=2,
		
		col=trait_colors,
		
		## increase y limit to fit the legend
		ylim = c(0,10),
		cex = 2
		)

## add a legend (plot "augmentation"!)
legend(x=1,y=10, ##"topright",
	   rownames(m), 
	   fill=trait_colors)



## ----PieChart1----------------------------------------------------------------

pie(species_means[,"Petal.Length"], 
	labels = rownames(species_means),
    main = paste("Mean Petal Lengths in ",
			     "Fisher's Iris Species"),
	col=species_colors,
	
	cex=2, ## larger text annotation
	cex.main = 2 ## larger title
)



## ----PieChart2----------------------------------------------------------------

pie(species_means["setosa",], 
	labels = colnames(species_means),
	main = paste("Mean Flower Organ Dimensions",
    			 "in Iris setosa"),
	col=trait_colors,
	
	cex=2, ## larger text annotation
	cex.main = 2 ## larger title
)



## ----scatterplot_init_empty---------------------------------------------------

## (see par() for graphical parameters!)
plot(x=NULL,y=NULL,
	 
	 ## Note that if you start empty, 
	 ## you have to set the canvas 
	 ## dimensions yourself!
	 
	 xlim=c(0,3),
	 ylim=c(0,9),
	 xlab = "x dimension",
	 ylab = "y dimension"
	 
)


## ----scatterplot_init_data1---------------------------------------------------

plot(x=iris$Petal.Width, 
     y=iris$Petal.Length
)


plot.new() ## explicitly empty the global device!


## ----scatterplot_formula------------------------------------------------------

## Initialize a new plot, 
## using formula notation to specify x and y:
plot(Petal.Length ~ Petal.Width,
	 data = iris)



## ----scatterplot_grid---------------------------------------------------------

grid() 


## ----scatterplot_add_data-----------------------------------------------------

points(Petal.Length ~ Petal.Width, 
	   
	   data=subset(iris,
	   			Species == "versicolor"
	   	    ),
	   
	   pch=21, # symbol code 21: bullet with
	           # separate interior color (bg) 
	           # and border color (col)
			   ## See points()!

	   ## Set color manually:
	   col= "red", 
	   bg = "red"  
)
	


plot.new() ## explicitly empty the global device!

## ----scatterplot_name_colors--------------------------------------------------
plot(Petal.Length ~ Petal.Width, 
	 data=iris,
	 pch=21,
	 
	 ## index the "species_colors" vector
	 ## by species names:
	 col=species_colors[Species], 
	 bg =species_colors[Species]  
     )

legend("topleft",
	   rownames(species_means),
	   fill=species_colors)


## ----scatterplot_linestyle----------------------------------------------------

## See par() for line-related parameters!

## Make a new data.frame, 
## containing only setosa:
df <- subset(iris, Species=="setosa")

plot(
	 # x is now the row number in df
	 x=1:nrow(df),
	 xlab="individual plant",
	 	 
	 y=df$Petal.Width,
	 ylab="Petal.Width",
	 	 
	 ## show both points and 
	 ## connecting lines:
	 type="b",
	 
	 ## line width:
	 lwd = 2,
	 ## line style = dashed:
	 lty=2,
	 	 
	 main="Iris setosa"
)



## ----scatterplot_smeansplot---------------------------------------------------

## Initialize a plain x/y plot:
plot(Petal.Length ~ Petal.Width,
	 data=iris)

## Add colored mean points, connected by lines
lines(x=species_means[,"Petal.Width"],
	  y=species_means[,"Petal.Length"],
	  type="b", # show both points and lines 
	  pch=21,
	  bg=species_colors,
	  cex=2.5
)



## ----scatterplot_smeansplot_with_labels---------------------------------------

text(x=species_means[,"Petal.Width"],   
	 y=species_means[,"Petal.Length"],
	 
	 labels=rownames(species_means),
	 
	 pos=4, ## put labels to the right of points
	        ## (see ?text)
	 cex=3  ## expansion factor for the text
)


plot.new() ## explicitly empty the global device!

## ----scatterplot_regline------------------------------------------------------

## Initialize a plain x/y plot:
plot(Petal.Length ~ Petal.Width,
	 data=iris,
	 ## Put a title:
	 main = "Regression Line Example")
 
## Mark the linear regression line:
abline(lm(Petal.Length ~ Petal.Width,
		  data=iris
	   ),
	   lty=2, lwd=2,col="blue"
	   )



## ----scatterplot_abline-------------------------------------------------------

## Initialize a plain x/y plot:
plot(Petal.Length ~ Petal.Width,
	 data=iris,
	 main = "abline() example"
	 )

## Horizontal and vertical markers:
abline(h = 2.5, col = "red", 
	   lwd=2 ## line width
	   )
abline(v = 0.75, col = "yellow", lwd=2)

## An "assumed" regression line for reference:
abline(a=1,b=2,lwd=2)




## ----layout1------------------------------------------------------------------

## prepare the layout matrix
m <- matrix(1:4, 
	    nrow=2, 
	    ncol=2, 
	    byrow=FALSE)
m



## ----layout2------------------------------------------------------------------

layout(m) ## read the layout matrix

use_cols =  species_colors[iris$Species]
## 1
plot(Sepal.Length ~ Sepal.Width, data=iris,
	 pch=21, col=use_cols, bg=use_cols, 
	 cex.lab=2)
## 2
plot(Petal.Length ~ Petal.Width, data=iris, 
	 pch=21, col=use_cols, bg=use_cols, 
	 cex.lab=2)
## 3
plot(Sepal.Length ~ Petal.Length, data=iris, 
	 pch=21, col=use_cols, bg=use_cols, 
	 cex.lab=2)
## 4
plot(Sepal.Width ~ Petal.Width, data=iris, 
	 pch=21, col=use_cols, bg=use_cols, 
	 cex.lab=2)



## ----layout3------------------------------------------------------------------

layout(1) ## back to full screen


## ----Histogram----------------------------------------------------------------

setosa <- subset(iris,Species=="setosa")
versicolor <- subset(iris,Species=="versicolor")
virginica <- subset(iris,Species=="virginica")
		      
## Plot the histogram of setosa, 
## and initialize the entire plot: 

hist(setosa$Petal.Length,
     col=species_colors["setosa"],
	 
	 add=FALSE, ## this is the default
	 
	 ## initialize to full x range !
	 xlim=range(iris$Petal.Length),
	 
	 ## full y range you usually 
	 ## only know after some trials ..
	 ylim=c(0,22),
	 
	 ## x-axis label
	 xlab="Petal Length",
	 
	 ## larger axis labels:
	 cex.lab = 2,
	 
         main = "Petal Length Distributions",
	 
	 ## larger title:
	 cex.main = 2
)


## ----Histogram_added2---------------------------------------------------------

hist(versicolor$Petal.Length,
	 add=TRUE,
     col=species_colors["versicolor"]
)


## ----Histogram_added3---------------------------------------------------------

hist(virginica$Petal.Length,
	 add=TRUE,
     col=species_colors["virginica"]
)

legend(x=2,y=22, 
       legend=c("setosa",
       		 "versicolor",
       		 "virginica"), 
       fill=species_colors,
	   cex =1.5, ## larger script in legend 
       )



plot.new() ## explicitly empty the global device!

## ----BoxPlot------------------------------------------------------------------
boxplot(Petal.Length ~ Species, 
		data = iris,
		## colors are not automatically
		## inferred from the factor levels!
		col = species_colors
		)



## ----boxplot2-----------------------------------------------------------------
# Repeat the last boxplot, with an extended x axis: 
boxplot(Petal.Length ~ Species, 
		data = iris, col = species_colors,
		xlim=c(0,6)
		)


## ----boxplot2_augmented-------------------------------------------------------

boxplot(iris$Petal.Length, # take the entire column!
		add=TRUE, 
		at=5, ## position on x axis
		names="all species",
		show.names=TRUE
		)



