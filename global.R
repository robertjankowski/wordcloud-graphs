library(tm)
library(wordcloud)
library(memoise)
library(stopwords)
library(pdftools)
library(qdapTools)
library(tools)
library(qdapTools)
library()

getTermMatrix <- memoise(function(files) {
    
    type <- file_ext(files)
    if (type == "pdf") {
        Rpdf <- readPDF(control = list(text = "-layout")) 
        text <- Corpus(URISource(files), 
                       readerControl = list(reader = Rpdf))
    }
    else if (type == "doc") {
        text <- Corpus(URISource(files), readerControl = list(reader=readDOC))
    }
    else if (type == "docx") {
        docx <- paste(read_docx(files), collapse='\n')
        text <- VCorpus(VectorSource(docx))
    }
    else if (type == "html") {
        text <- Corpus(URISource(files))
        # TODO
        # remove html tags
    }
    else if (type == "txt") { 
        txt <- read.delim(files, header = F, sep = '\n', stringsAsFactor = F)
        text <- VCorpus(VectorSource(txt))
    }
    else {
        print("Wrong file type")
        return (NULL)
    }
    
    myCorpus <- tm_map(text, content_transformer(tolower))
    myCorpus <- tm_map(myCorpus, removePunctuation)
    myCorpus <- tm_map(myCorpus, removeNumbers)
    myCorpus <- tm_map(myCorpus, removeWords,
                      c(stopwords("SMART"), stopwords("pl", source = "stopwords-iso")))
    myCorpus <- tm_map(myCorpus, stripWhitespace)
    
    myDTM <- TermDocumentMatrix(myCorpus,
                               control = list(minWordLength = 1))
    
    m <- as.matrix(myDTM)
    
    sort(rowSums(m), decreasing = TRUE)
})


