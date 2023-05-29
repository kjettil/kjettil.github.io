library(shiny)
library(shinydashboard)
library(tidyverse)
library(viridis)

#loading data ( data available at https://www.ecdc.europa.eu/)
library(readxl)
tetracyclines <- read_excel("~/dsfb2/dsfb2_workflows_portfolio/opdracht3_2/antibiotics_usage/Annex_1_ESAC-Net_report_2020_downloadable_tables.xlsx", 
                            sheet = "D1_J01A_AC", range = "a2:K33")

beta_lactam_antibacterials <- read_excel("~/dsfb2/dsfb2_workflows_portfolio/opdracht3_2/antibiotics_usage/Annex_1_ESAC-Net_report_2020_downloadable_tables.xlsx", 
                                         sheet = "D2_J01C_AC", range = "a2:K33")

other_beta_lactam_antibacterials_antibacterials <- read_excel("~/dsfb2/dsfb2_workflows_portfolio/opdracht3_2/antibiotics_usage/Annex_1_ESAC-Net_report_2020_downloadable_tables.xlsx", 
                                                              sheet = "D3_J01D_AC", range = "a2:K33")

sulfonamides_and_trimethoprim <- read_excel("~/dsfb2/dsfb2_workflows_portfolio/opdracht3_2/antibiotics_usage/Annex_1_ESAC-Net_report_2020_downloadable_tables.xlsx", 
                                            sheet = "D4_J01E_AC", range = "a2:K33")

macrolides_lincosamides_and_streptogramins <- read_excel("~/dsfb2/dsfb2_workflows_portfolio/opdracht3_2/antibiotics_usage/Annex_1_ESAC-Net_report_2020_downloadable_tables.xlsx", 
                                                         sheet = "D5_J01F_AC",range = "a2:K33")

quinolones <- read_excel("~/dsfb2/dsfb2_workflows_portfolio/opdracht3_2/antibiotics_usage/Annex_1_ESAC-Net_report_2020_downloadable_tables.xlsx", 
                         sheet = "D6_J01M_AC", range = "a2:K33")

other_antibacterials <- read_excel("~/dsfb2/dsfb2_workflows_portfolio/opdracht3_2/antibiotics_usage/Annex_1_ESAC-Net_report_2020_downloadable_tables.xlsx", 
                                   sheet = "D7_J01X_AC", range = "a2:K33")

# Obtain the map data for Europe:
library(rnaturalearth)
world <- ne_countries(scale = "medium", continent = "Europe", returnclass = "sf")

# Define the datasets and their names for the dropdown menu
datasets <- list(tetracyclines = tetracyclines,
                 "beta lactam antibacterials" = beta_lactam_antibacterials,
                 "other beta lactam antibacterials antibacterials" = other_beta_lactam_antibacterials_antibacterials,
                 "sulfonamides and trimethoprim" = sulfonamides_and_trimethoprim,
                 "macrolides lincosamides and streptogramins" = macrolides_lincosamides_and_streptogramins,
                 quinolones = quinolones,
                 "other antibacterials" = other_antibacterials)

# Define the zoom coordinates as a named list
zoom_coordinates <- list(xmin = -10, xmax = 40, ymin = 30, ymax = 80)

ui <- dashboardPage(
  dashboardHeader(title = "Antibiotics Usage in the European Community Over the Years", titleWidth = 650,
                  tags$li(class = "dropdown", tags$a(href = "https://github.com/kjettil/kjettil.github.io", icon("github"), "My Github", target = "_blank")),
                  tags$li(class = "dropdown", tags$a(href = "https://www.linkedin.com/in/kjettil-evers-b62194196/", icon("linkedin"), "My Profile", target = "_blank"))
  ),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Map", tabName = "map_tab", icon = icon("globe"))
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "map_tab",
        fluidRow(
          box(
            title = "Choropleth Map",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            selectInput("dataset", "Select Dataset", choices = names(datasets), selected = "tetracyclines"),
            selectInput("column", "Select Column", choices = colnames(datasets$tetracyclines)[-c(1:5)], selected = "2011"),
            plotOutput("map")
          )
        )
      )
    )
  )
)

server <- function(input, output, session) {
  
  # Update column choices based on the selected dataset
  observeEvent(input$dataset, {
    updateSelectInput(session, "column", choices = colnames(datasets[[input$dataset]])[(2:11)], selected = "2011")
  })
  
  output$map <- renderPlot({
    # Create the choropleth map with zoom
    
    # Perform the left join using the selected dataset
    map_data <- left_join(world, datasets[[input$dataset]], by = c("name_long" = "Country name"))
    
    ggplot(data = map_data) +
      geom_sf(aes(fill = .data[[input$column]]), color = "white") +
      scale_fill_viridis(option = "plasma", name = "Data") +
      theme_minimal() +
      coord_sf(xlim = c(zoom_coordinates$xmin, zoom_coordinates$xmax),
               ylim = c(zoom_coordinates$ymin, zoom_coordinates$ymax),
               expand = FALSE)+
      labs(title = "consumption of antibiotics in the community \nexpressed as DDD per 1 000 inhabitants per day")
    
  })

}

shinyApp(ui = ui, server = server, options = list(height = 1080))



