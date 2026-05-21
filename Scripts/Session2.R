## -----------------------------------------------------------------------------
# Basis Concepts in R
## -----------------------------------------------------------------------------

## Variables

# This is a comment
name <- "John"    # This is also a comment
age <- 40
name

name <- "Tom"
print (name)


## -----------------------------------------------------------------------------
# Allowed variable names:
myvar    <- "John"
my_var   <- "John"
myvar_2. <- "John"
.myvar   <- "John"

# These assignments do not overwrite "myvar":
myVar    <- "Jenny"
MYVAR    <- "Cathy"



## -----------------------------------------------------------------------------
# Forbidden variable names:

# my var  <- "John"  # space
# 
# 2myvar  <- "John"  # starts with a number
# .2myvar <- "John"  # starts with a '.' plus number
# my-var  <- "John"  # special character
# _my_var <- "John"  # starts with a '_'
# my_var% <- "John"  # special character
# TRUE    <- "John"  # reserved words


## -----------------------------------------------------------------------------
# R Data Structures
## -----------------------------------------------------------------------------

## Vectors
### Definition
numbers <- c(100, 200, 450, 670) # create a vector

 # set element names (the names are also a vector!)
names(numbers) <- c("a",'b','c',"d")
print(numbers) # print the whole vector


numbers[1]   # print first element by index
numbers["a"] # print first element by name 


is.vector(numbers)
is.vector(numbers[1])


## -----------------------------------------------------------------------------
### Vectorization
v1 <- 1:3 # define the numeric vector c(1,2,3) 
          # by start and end
v1

v2 <- c(1,7,14)
v2

v1 + v2



## -----------------------------------------------------------------------------
### Recycling
# a vector of type "character"
v1 <- c("A","B","C","D","E")  
v1

v2 <- c("X","Y")
v2

paste(v1,v2,sep="|")


## -----------------------------------------------------------------------------
### Recycling Length-1 Vectors
v <- c(1,4,0,2,-4)
v * 2


## -----------------------------------------------------------------------------
## Matrices
M = matrix( c(2,10,-4,0,7,5.5), 
            nrow = 2, 
            ncol = 3, 
            byrow = TRUE,
            dimnames = 
              list(Sex=c("F","M"),Day=1:3))

# Print the matrix
print(M)

nrow(M) # Get the number of rows

M[1,] # Extract the first row

ncol(M) # Get the number of columns

M[,1] # Extract the first column


## -----------------------------------------------------------------------------
## Arrays

# Create an array with 3 dimensions:
a <- array(dim = c(2,3,2))

# Assume that Dimension 3 (=z) relates to 
# two experiments in different conditions,
a[,,1] <- M     # condition 1 
a[,,2] <- M + 2 # condition 2 

# Print the array
print(a)

## -----------------------------------------------------------------------------
## Lists

L <- list(c(), c(), c()) # a list of length 3 without any object attached 
length(L)

# L itself has data type "list"
class(L) 
# and each of its elements, too (as a vector should!)
class(L[1]) 


# a list with heterogeneous objects attached: 
L <- list(date = date(), 
          mouse = c("M5|1"), 
          treatment = 
            list( 
              doses = c(drug1=5,
                        drug2=15),
              technician = "Amy"
            )
     )

#  Double brackets extract the value of an element
L[[2]] 

# Two more ways to retrieve the value:
L[["mouse"]]
L$mouse


# Single brackets extract the entire 2nd list element:
L[2]


# Extract a component of a sub-list:
L$treatment$doses

## -----------------------------------------------------------------------------
## Dataframes

# A dataframe is a tabular representation of a list data structure.
# A list can be represented as a dataframe if all its columns are vectors of the
# same length (they may have different data types)

# Create the data frame
BMI <- 	data.frame(
   gender = c("Male", "Male","Female"), 
   height = c(152, 171.5, 165), 
   weight = c(81,93, 78),
   Age = c(42,38,26)
)

# Print the data frame
print(BMI)


# Print column "Age"
print(BMI[,"Age"]) # alternatively: print(BMI$Age)


# Print second row:
print(BMI[2,])


## -----------------------------------------------------------------------------
## Factors


# The factor data type describes relationships between categories.
# A factor variable is typically used to group another variable according to these categories,
# and then run statistical tests of category differences on this variable.  

# Often, the grouping variable and the grouped variable are columns in the same dataframe.



### Unordered Factors
### (distinguishes a base level (the first level listed) from all other levels)

apple_colors <- 
  c('green','green','yellow','red','red','red','green')

df <-
  data.frame(
    sugar = c(0.5, 0.1, 1.4, 2.3, 1.9, 3.0, 0.9),
    color = factor(apple_colors, 
                   ordered = FALSE, # default 
                   
                   # IF NOT SET, ORDER IS ALPHABETIC!
                   levels = c("green","yellow","red"))
  )

print(df) # the "color" column looks like a normal dataframe column
print(df$color) # the extracted column "color" also looks like a normal vector,
                # but it has an additional attribute: the levels


### Ordered Factors
df <-
  data.frame(
    sugar = c(0.5, 0.1, 1.4, 2.3, 1.9, 3.0, 0.9),
    
    # Need to set ordered=TRUE to get an ordered factor!
    color = factor(apple_colors, 
                   ordered =TRUE,
                   levels = c("green","yellow","red"))
  )
print(df) # the "color" column looks like a normal dataframe column
print(df$color) # Like in an unordered factor, the vector has an additional
                #   "levels" attribute. However regard: It is now describing an
                #   order relation on all levels


## -----------------------------------------------------------------------------
# Operators
## Arithmetic ------------------------------------------------------------------
###  + addition
###  - subtraction
###  * multiplication
###  / division
### all of these are vectorizing

## ^ exponentiation
3^3
c(2,3,4)^3 ## exponentiation is also vectorizing

## %% modulus (remainder from division)
7 %% 4 ## result is 3: 7 is 1*4 + 3

## %%/%% integer division
7 %/% 4 ## result is 1: 7/4 = 1.75; the integer part of this is 1

## modulus and integer division are vectorizing, too

## Relational ------------------------------------------------------------------
# These operators test a relationship between variables or objects
# and return TRUE (relationship holds) or FALSE (does not hold)

x <- 3
y <- 4

# == 	Equal
x == y # FALSE

# != 	Not equal 
x != y # TRUE

# > 	Greater than 
x > y # FALSE

# < 	Less than 
x < y # TRUE

# >= 	Greater than or equal to 
x > y # FALSE

# <= 	Less than or equal to 
x < y # TRUE

# All relational operators are vectorizing

## Logical ---------------------------------------------------------------------

x <- 3
y <- 4

v1 <- c(3, 5)
v2 <- c(4, 1)

# && Statement-wise logical AND
(x == 3) && (y == 5)
#[1] FALSE

# &    Vectorizing logical AND 
(v1 == 3) &  (v2 == 1)
#[1]  FALSE FALSE

# || Statement-wise logical OR
(x == 3) || (y == 5) 
#[1] TRUE

# |    Vectorizing logical OR 
(v1 == 3) |  (v2 == 1)
#[1] TRUE TRUE


## Miscellaneous ---------------------------------------------------------------

## Assignment ------------------------------------------------------------------

my_var <- 3

## the assignment "arrow" works in reverse order, too:
3 -> my_var

## the assign() function is equivalent to an "arrow" assignment:
assign("my_var", c(10.4, 5.6, 3.1, 6.4, 21.7))

my_var # print my_var



