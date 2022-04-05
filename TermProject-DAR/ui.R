library(shiny)
library(shinythemes)
library(shinydashboard)
library(knitr)

ui <- dashboardPage(
  skin = "purple",
  dashboardHeader(title="Data Analytics in R!"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dataset Description",tabName = "dataset_description",icon = icon("dashboard")),
      menuItem("Factor Frequency Distributions",tabName = "factor_distributions",icon = icon("chart-bar",lib="font-awesome")),
      menuItem("Chi-Square test of Factors",tabName = "chi_sq",icon=icon("th")),
      menuItem("Regression", tabName = "regression", icon = icon("line-chart", lib="font-awesome")),
      menuItem("About",tabName = "about", icon = icon("child", lib="font-awesome"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "dataset_description", 
        fluidPage(
          fluidRow(
            column(
              12,
              tags$h2("DATASET DESCRIPTION"),
              tags$hr(style="border-color: purple;"),
            ),
            column(
              12,
              DT::dataTableOutput("data_table"),
            ),
            tags$hr(style="border-color: purple;"),
            fluidRow(
              column(
                12,
                box(title = "Dataset Description"
                    , status = "primary", solidHeader = F
                    , collapsible = T, width = 12
                    , column(12, align="center", tableOutput('dataset_description')))  
              )
            ),
            fluidRow(
              column(
                12,
                tags$h3("Dataset Summary"),
                tags$hr(style="border-color: purple;"),
                verbatimTextOutput("student_summary")
              )
            )
          )
        )
      ),
      tabItem(
        tabName = "factor_distributions",
        fluidPage(
          fluidRow(
            tags$h2("DISTRIBUTION OF FACTOR VARIABLES")
          ),
          tags$hr(style="border-color: purple;"),
          fluidRow(
            column(
              3,
              uiOutput("distribution_columns") 
            ),
            column(
              9,
              plotOutput("distribution_plot")
            )
          )
        )
      ),
      tabItem(
        tabName = "chi_sq",
        fluidPage(
          fluidRow(
            tags$h2("CHI - SQUARE TEST OF INDEPENDENCE")
          ),
          tags$hr(style="border-color: purple;"),
          fluidRow(
            column(
              4, 
              uiOutput("x_axis_factor_columns"),
              uiOutput("y_axis_factor_columns")
            ),
            column(
              8,
              fluidRow(
                tags$h3("General Hypothesis"),
                column(
                  6,
                  tags$h4("H0 : There is no relationship between variables")
                ),
                column(
                  6,
                  tags$h4("H1 : There is relationship between variables")
                ),
                column(
                  4,
                  tags$h4("X Variable")
                ),
                column(
                  8,
                  verbatimTextOutput("x_axis_chisq")
                ),
                column(
                  4,
                  tags$h4("Y Variable")
                ),
                column(
                  8,
                  verbatimTextOutput("y_axis_chisq")
                ),
                column(
                  12,
                  tags$h4(verbatimTextOutput("chi_sq_test"))
                ),
                column(
                  12,
                  tags$h4(verbatimTextOutput("chi_sq_test_result"))
                )
              )
            )
          )
        )
      ),
      tabItem(
        tabName="regression",
        fluidPage(
          fluidRow(
            column(
              12,
              tags$h2("REGRESSION")
            )
          ),
          tags$hr(style="border-color: purple;"),
          fluidRow(
            column(
              4,
              selectInput("x_axis_regression","X-Axis Regression Variable",choices = c("G1","G2","G3","absences","age")),
              selectInput("y_axis_regression","Y-Axis Regression Variable",choices = c("G1","G2","G3","absences","age")),
            ),
            column(
              8,
              plotOutput("regression")
            )
          )
        )
      ),
      tabItem(
        tabName = "about",
        fluidPage(
          fluidRow(
            tags$h2("ABOUT")
          ),
          tags$hr(style="border-color: purple;"),
          fluidRow(
            column(
              4, 
              img(src = "me.jpeg")
            ),
            column(
              8,
              tags$h4("Made By - Jishant Prashant Acharya"),
              tags$h4("Student ID - 0720442"),
              tags$h4("Program : Applied Modelling and Quantitative Methods : Big Data Analytics"),
              tags$h4("Subject : AMOD5250H - Data Analytics with R")
            )
          )
        )
      )
    )
  )
)