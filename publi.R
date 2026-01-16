#install.packages("bibtex")  # si no lo tenés
library(bibtex)

current_year <- as.integer(format(Sys.Date(), "%Y"))
cut_year <- current_year - 6  # últimos 5 años (ej 2026 -> 2022)

# Leer bibs (tolera mejor entradas incompletas)
b1 <- read.bib("publicaciones/echarte.bib")
b2 <- read.bib("publicaciones/lewczuk.bib")

b <- c(b1, b2)

# Extraer año de forma robusta
get_year <- function(x){
  y <- x$year
  if (is.null(y) || length(y) == 0) return(NA_integer_)
  y <- gsub("[^0-9]", "", as.character(y))
  if (nchar(y) < 4) return(NA_integer_)
  as.integer(substr(y, 1, 4))
}

make_recent_bib <- function(infile, outfile, cut_year){
  b <- read.bib(infile)
  
  yrs <- vapply(b, get_year, integer(1))
  keep <- !is.na(yrs) & yrs >= cut_year
  
  b_recent <- b[keep]
  yrs_recent <- yrs[keep]
  
  ord <- order(yrs_recent, decreasing = TRUE)
  b_recent <- b_recent[ord]
  
  write.bib(b_recent, file = outfile)
  invisible(outfile)
}

e <- read.bib("publicaciones/echarte_ult5.bib")
l <- read.bib("publicaciones/lewczuk_ult5.bib")

head(sapply(e, function(x) x$year))
head(sapply(l, function(x) x$year))



make_recent_bib("publicaciones/echarte.bib", "publicaciones/echarte_ult5.bib", cut_year)
make_recent_bib("publicaciones/lewczuk.bib", "publicaciones/lewczuk_ult5.bib", cut_year)