library(shinythemes)
library(networkD3)

fluidPage(theme=shinytheme("journal"),

    titlePanel("Chmura słów"),
    
    sidebarLayout(
        sidebarPanel(
            fileInput("file1", "Wybierz plik .pdf/.doc/.docx/.txt",
                      accept = c(
                          "application/pdf", ".pdf", "application/msword",
                          "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                          "text/plain", 
                          "text/html")
            ),
            tags$hr(),
            hr(),
            sliderInput("freq",
                        "Minimalna frekwencja:",
                        min = 1,  max = 70, value = 15),
            sliderInput("max",
                        "Maksymalna ilość słów:",
                        min = 1,  max = 300,  value = 100),
            downloadButton(outputId = "save", label = "Zapisz"),
            hr(),
            verbatimTextOutput("console_text")
        ),
        # Show Word Cloud
        mainPanel(
            tabsetPanel(
                tabPanel("Chmura słów", plotOutput("chmura", width = "100%")),
                tabPanel("Graf", plotOutput("graf", width = "100%")),
                tabPanel("Interaktywny graf", forceNetworkOutput("i_graf", width = "100%"))   
            )
        )
    )
)

