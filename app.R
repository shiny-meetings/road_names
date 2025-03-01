library(geoarrow)
library(shiny)
library(bslib)
# library(mapgl)
library(leaflet)
library(dplyr)
library(sf)

ui <- page_fluid(
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
  div(class = 'background-container'),
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
  ),
  leafletOutput("lmap"),
  div(
    style = "background-color: #222; color: white; padding: 20px; margin-top: 20px;",
    div(
      class = "container",
      p("Data source: OpenStreetMap Data Extracts downloaded from geofabrick website")
    )
  )
  # story_map(
  #   map_id = "map",
  #   sections = list(
  #     "intro" = story_section(
  #       "Introduction",
  #       "This is a story map."
  #     ),
  #     "location" = story_section(
  #       "Location",
  #       "Check out this interesting location."
  #     )
  #   )
  # )
)

server <- function(input, output, session) {
  road_data <- eventReactive(input$search, {
    result <- get_roads(input$street_name)
    
    if (is.null(result)) {
      showNotification(
        "No roads found. Please try a different search term.",
        type = "warning",
        duration = 5
      )
      return(NULL)
    } else {
      result |> 
        rowwise() |> 
        mutate(lng = get_avg_coords(geometry)[1],
               lat = get_avg_coords(geometry)[2])
    }
  })
  
  
  output$lmap <- renderLeaflet({
    req(road_data())
    
    leaflet(road_data()) |> 
      # Add OpenStreetMap as base layer
      addProviderTiles(providers$Stadia.StamenToner) |> 
      # Add the roads as lines
      addPolylines(
        color = "blue",          
        weight = 2,             
        opacity = 1#,            
        # popup = ~name          
      ) |> 
      addMarkers(
        lng = ~lng,
        lat = ~lat,
        label = ~name
      )
  })
  
  # output$map <- renderMapboxgl({
  #   mapboxgl(scrollZoom = FALSE)
  # })
  # 
  # create_section("intro", get_avg_coords(road_data()$geometry[1]), 15, 19, 12)
  # create_section("location", get_avg_coords(road_data()$geometry[2]), 15, 19, 12)

}

shinyApp(ui, server)