# =============================================================================
#  R Beginners Course 2026 — Session 4
#  Data I/O and Reshaping (Base R)
#
#  Companion script for the slides
#  "Beginners_Day1_Session3_DataIO_and_Reshaping.html"
#
#  How to use this file:
#  ---------------------
#   * Open in RStudio. Use Ctrl/Cmd+Shift+O to see the section outline.
#   * Run one line  : Cursor in the line and then Ctrl/Cmd + Enter
#   * Run a section : Highlight the section + Ctrl/Cmd+Enter
#   * Each block matches a slide; the comments mirror the scenario / hint
#     callouts on the slides so you can follow along live.
#
#  Dataset: built-in iris (150 x 5; 4 numeric measurements + Species factor).
# =============================================================================


# ---- 0. Setup ---------------------------------------------------------------

# Nothing to install — every function below is base R.
#
# We write demo files into the CURRENT WORKING DIRECTORY using simple
# relative paths like "iris.csv". Each participant should be in their own
# project folder so files don't collide. Useful helpers:
#
#   getwd()                              -> shows the working directory
#   setwd("path")                        -> changes it (avoid in scripts)
#   file.path("data", "iris.csv")        -> portable path "data/iris.csv"
#   dir.create("data")                   -> creates a sub-folder (once)

data(iris)
str(iris)
head(iris)

getwd()                              # where am I?
file.path("data", "iris.csv")        # build a portable path


# =============================================================================
#  PART I — Data I/O (read & write files)
# =============================================================================


# ---- 1a. CSV — read.csv() / write.csv()  (US/UK locale: "," and ".") --------

# Scenario: a collaborator sends an English-locale CSV.
write.csv(iris, "iris.csv", row.names = FALSE)
iris_csv <- read.csv("iris.csv")
head(iris_csv, n = 6)


# ---- 1b. CSV gotcha — Factor → Character  -----------------------------------

# Since R 4.0, read.csv() no longer converts strings to factors by default.
# The values look identical, but the TYPE differs — enough to trip identical().

class(iris$Species)       # "factor"
class(iris_csv$Species)   # "character" — factor levels lost!

identical(iris, iris_csv) # FALSE — surprising!

# Fix: rebuild the factor explicitly after loading
iris_csv$Species <- factor(iris_csv$Species,
                           levels = levels(iris$Species))
identical(iris, iris_csv) # TRUE


# ---- 1c. CSV — read.csv2() / write.csv2()  (DE/FR locale: ";" and ",") ------

# Scenario: same data from a German lab — ";" separator, "," decimal.
write.csv2(iris, "iris_de.csv", row.names = FALSE)
iris_csv2 <- read.csv2("iris_de.csv")

# Peek at the raw file to *see* the locale conventions
writeLines(readLines("iris_de.csv", n = 3))

head(iris_csv2, n = 6)

# Decision rule:
#   US/UK ("," + ".") -> read.csv()
#   DE/FR (";" + ",") -> read.csv2()
#   anything else     -> read.table() with explicit sep and dec


# ---- 2a. General tabular — read.table() / write.table() ---------------------

# Scenario: a TSV from a sequencing pipeline. Full control via sep/quote/...
write.table(iris, "iris.tsv", sep = "\t", row.names = FALSE)
iris_tab <- read.table("iris.tsv", header = TRUE, sep = "\t")
head(iris_tab, n = 10)


# ---- 2b. General tabular — read.delim() / read.delim2() ---------------------

# read.delim()  = read.table() with sep = "\t" baked in, US/UK decimal.
# read.delim2() = same but DE/FR decimal (",").

delim1 <- read.delim("iris.tsv")

# Write the same data DE-style: tab-separated, comma decimal
write.table(iris, "iris_de.tsv",
            sep = "\t", dec = ",", row.names = FALSE)

# Read it back with the locale-aware shortcut
delim2 <- read.delim2("iris_de.tsv")

head(delim1, n = 2)
head(delim2, n = 2)


# ---- 3. Binary formats — saveRDS / readRDS  vs  save / load -----------------

# Scenario: pick up tomorrow where you left off, without re-running a pipeline.
#
#   saveRDS / readRDS  -> ONE object, you choose the name on load
#   save    / load     -> one or many objects, original names reappear

# saveRDS / readRDS: a single object, no name preserved
saveRDS(iris, "iris.rds")
iris_rds <- readRDS("iris.rds")

# save / load: one or many objects, names preserved
save(iris, iris_rds, file = "iris.RData")
rm(iris_rds)            # remove from session
load("iris.RData")      # variables reappear with their ORIGINAL names
ls()

# Avoid: save.image() / load("workspace.RData") for reproducible work.
# Decision rule: single object -> saveRDS; many objects w/ names -> save.


# =============================================================================
#  PART II — Data Reshaping
# =============================================================================


# ---- 4. stack() / unstack() — quick wide<->long, no row identity -----------

# Mental model:
#   stack() melts numeric columns into two columns:
#     values -> all the numbers, concatenated column-by-column
#     ind    -> a factor labelling which original column each value came from

# Look & Predict: what will the first rows of `stacked` look like?
stacked <- stack(iris[1:4])
head(stacked, 8)

# Reverse
unstacked <- unstack(stacked)
identical(unstacked, iris[1:4])

# Break: shuffle then try to unstack — unstack() relies on column order.
set.seed(123)
stacked2   <- stacked[sample(nrow(stacked)), ]
unstacked2 <- try(unstack(stacked2), silent = TRUE)
unstacked2


# ---- 5a. reshape() — wide -> long  (with explicit IDs) ---------------------

# The six named arguments — read them in this order:
#   direction : "long" or "wide" — which way you're pivoting
#   varying   : columns to melt (long) / columns to split (wide)
#   v.names   : name of the new VALUE column
#   timevar   : name of the new KEY column (which-feature)
#   times     : labels that go into timevar
#   idvar     : columns that IDENTIFY a row (anchor for round-trip)

iris2       <- iris                          # local copy
iris2$rowID <- seq_len(nrow(iris2))          # explicit row identifier
head(iris2, 3)

long <- reshape(
  iris2,
  varying   = list(names(iris2)[1:4]),  # cols to melt into one
  v.names   = "Measurement",            # name of new value col
  timevar   = "Feature",                # name of new key col
  times     = names(iris2)[1:4],        # labels that fill timevar
  idvar     = c("rowID", "Species"),    # row-identity anchor
  direction = "long"                    # "long" or "wide"
)
dim(long)        # 600 x 4 — 150 flowers x 4 features
head(long, 5)


# ---- 5b. reshape() — long -> wide  (reversibility test) --------------------

# Shuffle so row order is destroyed, then pivot back. With explicit idvar,
# recovery should still succeed.

set.seed(42)
long_shuffled <- long[sample(nrow(long)), ]

wide <- reshape(
  long_shuffled,
  idvar     = c("rowID", "Species"),
  timevar   = "Feature",
  direction = "wide"
)
head(wide, 3)

# Clean up auto-generated names and row order, then compare
names(wide) <- sub("^Measurement\\.", "", names(wide))
wide        <- wide[, colnames(iris2)]
wide        <- wide[order(wide$rowID), ]
rownames(wide) <- NULL
all.equal(wide, iris2)


# ---- 5c. reshape() — Break: drop Species from idvar ------------------------

# Predict, then run: what happens if we drop Species from idvar?
wide_bad <- try(reshape(
  long_shuffled,
  idvar     = "rowID",          # Species is no longer a key
  timevar   = "Feature",
  direction = "wide"
))
head(wide_bad, 3)


# =============================================================================
#  PART III — Verifying round-trips
# =============================================================================


# ---- 6. identical() vs all.equal() ------------------------------------------

#   identical(x, y) : STRICT structural equality (attributes + types).
#   all.equal(x, y) : content-level check with numeric tolerance (~1.5e-8).
#                     Returns TRUE or a character describing the diff;
#                     wrap in isTRUE() to get a clean boolean.


# =============================================================================
#  PART IV — Combining tables
# =============================================================================


# ---- 7a. cbind() — same rows, glue columns ---------------------------------

# Predict: will all.equal(cb, iris) be TRUE? Will identical(cb, iris) be TRUE?
cb <- cbind(
  iris[, 1:2],
  iris[, 3:4],
  Species = iris$Species
)
head(cb)

all.equal(cb, iris)   # content-level (with tolerance)
identical(cb, iris)   # strict (attributes + types) — likely FALSE

# Why the disagreement? cbind() rebuilds the data.frame from scratch;
# tiny attribute differences (row.names) trip identical() but not all.equal().


# ---- 7b. rbind() — same columns, stack rows --------------------------------

upper <- iris[1:75, ]
lower <- iris[76:150, ]
rb    <- rbind(upper, lower)
identical(rb, iris)             # FALSE — row names preserved from sources
# Fix:
rownames(rb) <- NULL
identical(rb, iris)             # TRUE now (provided dims/types still match)


# ---- 7c. cbind() — Break: mismatched row counts -----------------------------

short <- iris[-(141:150), ]
tryCatch(
  cbind(short, iris),
  error = function(e) conditionMessage(e)
)
# cbind() expects equal row counts. It can't recycle or drop.


# ---- 7d. rbind() — Break: mismatched column order --------------------------

swapped <- iris[76:150, c("Species", "Sepal.Length", "Sepal.Width",
                          "Petal.Length", "Petal.Width")]
tryCatch(
  rbind(upper, swapped),
  error = function(e) conditionMessage(e)
)
# rbind() requires identical column NAMES & ORDER.


# ---- 8a. merge() — inner join with duplicate keys (Cartesian!) -------------

# Scenario: two partial tables share a key column ("Species"), and the key
# is DUPLICATED on both sides (50 versicolor x 50 versicolor).

dir1 <- iris[1:100,  c("Sepal.Length", "Species")]   # setosa + versicolor
dir2 <- iris[51:150, c("Sepal.Width",  "Species")]   # versicolor + virginica

merged <- merge(dir1, dir2, by = "Species")
nrow(merged)                                          # 2500 — 50 x 50 Cartesian
head(merged, 10)


# ---- 8b. merge() — one-to-one matching via an explicit ID ------------------

dir1$idx <- 1:nrow(dir1)
dir2$idx <- (50 + 1):(50 + nrow(dir2))

matched <- merge(dir1, dir2, by = c("Species", "idx"), all = TRUE)
head(matched, 10)
matched$idx <- NULL


# Join-type cheat sheet:
#   inner (default) : merge(x, y, by = "k")
#   left            : merge(x, y, by = "k", all.x = TRUE)
#   right           : merge(x, y, by = "k", all.y = TRUE)
#   full outer      : merge(x, y, by = "k", all   = TRUE)


# =============================================================================
#  PART V — Other interesting functions
# =============================================================================


# ---- 9a. split() / unsplit() — per-group analysis --------------------------

# "Run the same analysis per cell type / cluster / batch."
spl <- split(iris, iris$Species)
# e.g. per-species column means:
lapply(spl, function(df) colMeans(df[, 1:4]))

# Reassemble — round-trips iris exactly:
unspl <- unsplit(spl, iris$Species)
identical(unspl, iris)


# ---- 9b. table() and cut() --------------------------------------------------

# table() : fast cross-tabulation of factors.
# cut()   : bin a numeric vector into a factor with chosen breaks.

tbl <- table(iris$Species)
fl  <- cut(iris$Sepal.Length, breaks = 3)

tbl                    # counts per species
table(fl)              # counts per Sepal.Length bin
head(fl)               # the bin labels assigned to each row


# ---- 9c. Transpose — t() ----------------------------------------------------
#
# t() swaps rows <-> columns. Result is always a MATRIX.
# Useful when a plotting / modelling function expects samples in the OTHER
# orientation (boxplot, heatmap, prcomp, ...).
# Data frames with mixed types are coerced first — everything becomes character.

mat  <- as.matrix(iris[, 1:4])   # 150 rows (flowers) x 4 cols (measurements)
dim(mat)

tmat <- t(mat)                   #   4 rows (measurements) x 150 cols (flowers)
dim(tmat)
tmat[, 1:3]                      # first three flowers as columns

identical(mat, t(tmat))          # TRUE — t() is its own inverse


# ---- 9d. Sort & reorder — sort() / order() / rank() -------------------------
#
#   sort(x)   -> the VALUES of x in order
#   order(x)  -> the INDICES that put x in order; use to reorder data frames
#   rank(x)   -> for each value, its rank (handy for non-parametric stats)

x <- c(30, 10, 20)
sort(x)                          # 10 20 30
order(x)                         #  2  3  1
x[order(x)]                      # same as sort(x)

# Reorder a whole data frame by one column
head(iris[order(iris$Sepal.Length), ])

# Descending: negate the numeric column OR use decreasing = TRUE
head(iris[order(-iris$Sepal.Length), ])
head(iris[order(iris$Sepal.Length, decreasing = TRUE), ])

# Multi-key sort: Species first, then Sepal.Length within Species
head(iris[order(iris$Species, iris$Sepal.Length), ], 10)


# =============================================================================
#  PART VI — Hands-on Exercise
# =============================================================================

# Task: write iris with German-locale conventions, read it back, verify.
#
#   1. write.table() with sep = ";", dec = ",", row.names = FALSE
#      into "iris_de.csv" (in your project folder)
#   2. Read back with read.csv2()
#   3. Compare with all.equal(iris, iris_back) — what about Species?
#
# Hint: since R 4.0, text columns come back as character, not factor.
#       Rebuild with factor(..., levels = levels(iris$Species)) before comparing.

# --- Your turn ---------------------------------------------------------------
# Step 1: write iris with ; separator and , decimal into "iris_de.csv"
# ______

# Step 2: read it back with read.csv2()
# iris_back <- ______

# Step 3: compare
# all.equal(iris, iris_back)


# --- Solution (uncomment after you've tried) --------------------------------
# write.table(iris, "iris_de.csv", sep = ";", dec = ",", row.names = FALSE)
# iris_back <- read.csv2("iris_de.csv")
# all.equal(iris, iris_back)                      # complains about Species
#
# iris_back$Species <- factor(iris_back$Species,
#                             levels = levels(iris$Species))
# all.equal(iris, iris_back)                      # now TRUE


# =============================================================================
#  Takeaways
# =============================================================================
#
#   1. Match the function to the file — delimiter, decimal, locale.
#   2. Explicit IDs (idvar, key columns) survive reordering; position does not.
#   3. identical() is strict, all.equal() is forgiving — pick on purpose.
#
# =============================================================================
