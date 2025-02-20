library(shiny)
library(bslib)

ui <- page_fillable(
  title = "Roads Explorer",
  theme = bs_theme(
    bg = '#2b3035',
    fg = '#ffffff',
    primary = '#008000'
  ),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
  ),
  # Background image
  tags$div(class = 'background-container'),
  # Search Container
  div(
    class = 'search-container',
    h1('Explore Roads and Streets'),
    p('Enter a road name to discover similar roads', 
      class = "custom-paragraph"),
    
    layout_column_wrap(
      width = 1/2,
      textInput('street_name', NULL, 
                placeholder = 'Type a street name...', 
                width = '100%'),
      input_task_button('search', 'Explore', 
                   class = 'btn-lg fancy-button')
    )
  )
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)