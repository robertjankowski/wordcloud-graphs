library(tm)
library(stringr)

Sys.setlocale(category = "LC_ALL", locale = "Polish")
read <- readDOC(engine = "antiword")
doc <- Corpus(URISource("test.doc", encoding = "UTF-8"), readerControl = list(reader=read, language="PL"))
doc <- content(doc[[1]])
doc <- str_replace_all(doc, "[\r\n]" , "")
print(doc)
