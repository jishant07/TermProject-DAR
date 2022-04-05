library(shiny)
library(shinythemes)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title="Data Analytics in R!"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dataset Description",tabName = "dataset_description",icon = icon("dashboard")),
      menuItem("Factor Frequency Distributions",tabName = "factor_distributions",icon = icon("th")),
      menuItem("Chi-Square test of Factors",tabName = "chi_sq"),
      menuItem("Regression Between Period Marks", tabName = "regression"),
      menuItem("References"),
      menuItem("About")
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
              tags$h2("DATASET DESCRIPTION")
            ),
            DT::dataTableOutput("data_table"),
            hr(),
            fluidRow(
              verbatimTextOutput("student_summary")
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
          hr(),
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
              tags$h2("REGRESSION DIFFERENT BETWEEN PERIOD MARKs")
            )
          ),
          fluidRow(
            column(
              4,
              selectInput("x_axis_regression","X-Axis Regression Variable",choices = c("G1","G2","G3")),
              selectInput("y_axis_regression","Y-Axis Regression Variable",choices = c("G1","G2","G3")),
            ),
            column(
              8,
              plotOutput("regression")
            )
          )
        )
      )
    )
  )
)