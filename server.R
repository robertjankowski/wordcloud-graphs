library(ggplot2)
library(igraph)
library(networkD3)

function(input, output, session) {

    terms <- reactive({

        file1 = input$file1
        if (is.null(file1)) {
            return(NULL)
        }
        input$update
        isolate({
            withProgress({
                setProgress(message = "Processing corpus...")
                getTermMatrix(file1$datapath)
            })
        })
    })
    
    wordcloud_reactive <- function(){
        v <- terms()
        if(!is.null(names(v))) {
            wordcloud(names(v), v, scale=c(4, .5),
                      min.freq = ifelse(input$freq < 2, 0, input$freq), 
                      max.words=ifelse(input$max > 1000, 0, input$max),
                      colors=brewer.pal(8, "Dark2"))   
        }
    }
    
    graph_reactive <- function(){
        v <- terms()
        if(is.null(names(v))) {
            return (NULL)
        }
        v <- v[v > input$freq]
        if (length(v) == 0) {
            return (NULL)
        }
        tmp <- v %*% t(v)
        g <- graph_from_adjacency_matrix(tmp, weighted=T, mode = "undirected")
        g <- simplify(g)
        V(g)$label <- V(g)$name
        V(g)$degree <- degree(g)
        V(g)$label.cex <- v / 9 
        V(g)$label.color <- rgb(0, 0, .2, .8)
        V(g)$frame.color <- NA
        E(g)$color <- rgb(.5, .5, 0)
        return (g)
    }
    
    output$chmura <- renderPlot({
        wordcloud_reactive()
    })
    output$graf <- renderPlot({
        g <- graph_reactive()
        if(!is.null(g)){
            plot(g, layout = layout.fruchterman.reingold, vertex.size=betweenness(g))   
        }
    })
    output$i_graf <- renderForceNetwork({
        g <- graph_reactive()
        v <- terms()
        v <- v[v > input$freq]
        if(!is.null(g) && length(v) > 1) {
            wc <- cluster_walktrap(g)
            members <- membership(wc)
            
            g_d3 <- igraph_to_networkD3(g, group = members)
            forceNetwork(Links = g_d3$links, Nodes = g_d3$nodes,
                         NodeID = "name", Group = "group", fontSize = 25,
                         linkDistance = 200, zoom = T)
        }
    })
    
    output$save <- downloadHandler(
        filename = function() { paste(Sys.Date(), '.png', sep='') },
        content = function(file) {
            device <- function(..., width, height) {
                grDevices::png(..., width = width, height = height, res = 1000, units = "in")
            }
            ggsave(file, plot = wordcloud_reactive(), device = device)
        }, "image/png"
    )
    
}