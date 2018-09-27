library(shinythemes)
library(networkD3)

fluidPage(theme=shinytheme("journal"),

    titlePanel("Chmura słów"),
    
    sidebarLayout(
        sidebarPanel(
            fileInput("file1", "Wybierz plik\n",
                      accept = c(
                          "application/pdf", ".pdf", "application/msword",
                          "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
                          "text/plain", 
                          "text/html")
            ),
            tags$div(
                tags$p("Dostępne formaty plików: "),
                tags$p("(.pdf/.doc/.docx/.txt/.html)"),
                tags$style(HTML("
                    p {
                        font-family: 'Helvetica Neue',Helvetica,Arial,sans-serif;
                        font-style: italic;
                        font-weight: 500;
                        font-size: 14px;
                        color: #958e8c;
                    }
                "))
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

