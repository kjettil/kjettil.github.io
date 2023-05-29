library(shiny)
library(shinydashboard)
library(rnaturalearth)
library(rnaturalearthdata)
library(readxl)
library(tidyverse)
library(viridis)

#loading data ( data available at https://www.ecdc.europa.eu/)

tetracyclines <- read_excel("Annex_1_ESAC-Net_report_2020_downloadable_tables.xlsx", 
                            sheet = "D1_J01A_AC", range = "a2:K33")

beta_lactam_antibacterials <- read_excel("Annex_1_ESAC-Net_report_2020_downloadable_tables.xlsx", 
                                         sheet = "D2_J01C_AC", range = "a2:K33")

other_beta_lactam_antibacterials_antibacterials <- read_excel("Annex_1_ESAC-Net_report_2020_downloadable_tables.xlsx", 
                                                              sheet = "D3_J01D_AC", range = "a2:K33")

sulfonamides_and_trimethoprim <- read_excel("Annex_1_ESAC-Net_report_2020_downloadable_tables.xlsx", 
                                            sheet = "D4_J01E_AC", range = "a2:K33")

macrolides_lincosamides_and_streptogramins <- read_excel("Annex_1_ESAC-Net_report_2020_downloadable_tables.xlsx", 
                                                         sheet = "D5_J01F_AC",range = "a2:K33")

quinolones <- read_excel("Annex_1_ESAC-Net_report_2020_downloadable_tables.xlsx", 
                         sheet = "D6_J01M_AC", range = "a2:K33")

other_antibacterials <- read_excel("Annex_1_ESAC-Net_report_2020_downloadable_tables.xlsx", 
                                   sheet = "D7_J01X_AC", range = "a2:K33")


# Define the datasets and their names for the dropdown menu
datasets <- list(tetracyclines = tetracyclines,
                 "beta lactam antibacterials" = beta_lactam_antibacterials,
                 "other beta lactam antibacterials antibacterials" = other_beta_lactam_antibacterials_antibacterials,
                 "sulfonamides and trimethoprim" = sulfonamides_and_trimethoprim,
                 "macrolides lincosamides and streptogramins" = macrolides_lincosamides_and_streptogramins,
                 quinolones = quinolones,
                 "other antibacterials" = other_antibacterials)

# build dashboard
ui <- dashboardPage(
  dashboardHeader(
    title = "Antibiotics Usage in the European Community Over the Years",
    titleWidth = 650,
    tags$li(class = "dropdown", tags$a(href = "https://github.com/kjettil/kjettil.github.io", icon("github"), "My Github", target = "_blank")),
    tags$li(class = "dropdown", tags$a(href = "https://www.linkedin.com/in/kjettil-evers-b62194196/", icon("linkedin"), "My Profile", target = "_blank"))
  ),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dataset Information", tabName = "info_tab", icon = icon("info")),
      menuItem("Map", tabName = "map_tab", icon = icon("globe"))
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(
        # tab for the information of the data
        tabName = "info_tab",
        fluidRow(
          box(
            title = "Dataset Information",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            div(
              style = "position: relative;",
              img(
                src = "https://upload.wikimedia.org/wikipedia/en/thumb/5/5d/ECDC_logo.svg/1200px-ECDC_logo.svg.png",
                height = "150px",
                width = "auto",
                style = "position: absolute; top: 10px; right: 10px;"
              ),
              tags$h4("Information dataset"),
              tags$p("The Antimicrobial consumption in the EU/EEA (ESAC-Net) is acquired from the European Centre for Disease Prevention and Control. 
                     The dataset contains the antimicrobial consumption in the EU/EEA from 2011 till 2020. Antimicrobial consumption (AMC) data were collected using the Anatomical Therapeutic Chemical (ATC)
                     classification system and analysed using the defined daily dose (DDD) methodology developed by the World Health
                     Organization (WHO) Collaborating Centre for Drug Statistics Methodology (Oslo, Norway). For the analysis, DDDs
                     listed in the ATC Index for 2021 were used [4]. One DDD represents the assumed average maintenance dose per
                     day for a drug used in its main indication by adults. It is a technical unit of measurement, not a standard for
                     appropriate use. Application of the ATC/DDD methodology makes it possible to aggregate different brands of
                     medicines with different pack sizes and strengths into units of measurement of active substances. It represents a
                     standard in performing valid and reliable cross-national or longitudinal studies of AMC. DDD values of some
                     medicines may change over time because of alterations in the main indication, or regulatory amendments to the
                     recommended or prescribed daily dose. In case of such changes, all historical data require retrospective
                     adjustments to the latest DDD/ATC index    ", style = "padding-right: 170px;"),
              tags$p(),
              tags$h4("Key facts"),
              tags$ul(
                style = "padding-right: 170px; list-style-type: disc;",
                tags$li("For 2020, twenty-nine countries (27 European Union (EU) Member States and two European Economic Area (EEA) countries - Iceland and Norway) reported data on antimicrobial consumption. Twenty-five countries reported data for both community and hospital consumption; two countries (Germany and Iceland) reported only community consumption, and two countries (Cyprus and Czechia) reported total consumption for both sectors combined."),
                tags$li("The Anatomical Therapeutic Chemical (ATC) classification index with defined daily doses (DDD) 2021 was used for the analysis of both 2020 data and historical data. Antimicrobial consumption is expressed as DDD per 1 000 inhabitants per day."),
                tags$li("In 2020, the mean total (community and hospital sector combined) consumption of antibacterials for systemic use (ATC group J01) in the EU/EEA was 16.4 DDD per 1 000 inhabitants per day (country range: 8.5–28.9). During the period 2011–2020, a statistically significant decrease was observed for the EU/EEA overall, as well as for eight individual countries. A statistically significant increasing trend was observed for two countries."),
                tags$li("The EU/EEA mean total (community and hospital sector combined) consumption of antivirals for systemic use (ATC group J05) was 2.56 DDD per 1 000 inhabitants per day (country range: 0.59–11.19), with no statistically significant trends in the five-year period between 2016–2020."),
                style = "padding-right: 170px;"),
               tags$p(
                style = "padding-right: 170px;",
                HTML("More information available in the <a href='https://www.ecdc.europa.eu/sites/default/files/documents/ESAC-Net%20AER-2020-Antimicrobial-consumption-in-the-EU-EEA.pdf'>ECDC SURVEILLANCE REPORT</a>")
              )
            )
          )
        )
      ),
      #make tab where the map will be shown
      tabItem(
        tabName = "map_tab",
        fluidRow(
          box(
            title = "Choropleth Map",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            selectInput("dataset", "Select Antibiotics", choices = names(datasets), selected = "tetracyclines"),
            selectInput("column", "Select Year", choices = colnames(datasets$tetracyclines)[-c(1:5)], selected = "2011"),
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
    ## Obtain the map data for Europe:
    
    world <- ne_countries(scale = "medium", continent = "Europe", returnclass = "sf")
    
    ## Perform the left join using the selected dataset
    map_data <- left_join(world, datasets[[input$dataset]], by = c("name_long" = "Country name"))
    
    ## Define the zoom coordinates as a named list
    zoom_coordinates <- list(xmin = -10, xmax = 40, ymin = 30, ymax = 80)
    
    # make ggplot based on selected antibiotic and year
    ggplot(data = map_data) +
      geom_sf(aes(fill = .data[[input$column]]), color = "white") +
      scale_fill_viridis(option = "plasma", name = "DDD per 1.000 \ninhabitants per day") +
      theme_minimal() +
      coord_sf(
        xlim = c(zoom_coordinates$xmin, zoom_coordinates$xmax),
        ylim = c(zoom_coordinates$ymin, zoom_coordinates$ymax),
        expand = FALSE
      ) +
      labs(title = "consumption of antibiotics in the community \nexpressed as DDD per 1 000 inhabitants per day")
  })
  

  
}

shinyApp(ui = ui, server = server, options = list(height = 1080))
