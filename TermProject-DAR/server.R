library(ggplot2)
library(corrplot)
library(dplyr)
library(DT)

studentPerformanceData <- as.data.frame(read.csv("./dataset/student-por.csv",sep = ";",stringsAsFactors = TRUE))
germanCreditData <- as.data.frame(read.csv("./dataset/german_credit_data.csv"))

primary <- "#75f4f4"
secondary <- "#fffd82"
tertiary <- "#e84855"


server <- function(input, output, session) {
  
  # Student Performance Variables
  
  output$studentAge_Range <- renderPrint({range(studentPerformanceData$age)})
  column_names <- colnames(studentPerformanceData[sapply(studentPerformanceData,class)=="factor"])
  
  output$data_table <- DT::renderDataTable(
      studentPerformanceData,
      options = list(scrollX=TRUE)
    )
  
  output$student_summary <- shiny::renderPrint({
    summary(studentPerformanceData)
  })
  
  output$studentAge_hist <- renderPlot({
    ggplot(studentPerformanceData, aes(age)) +
      geom_histogram(fill=primary,color=tertiary,binwidth=1)
  })
  
  output$studentAge_boxplot <- renderPlot({
    ggplot(studentPerformanceData, aes(age)) +
      geom_boxplot(fill=primary,color=tertiary)
  })
  
  output$student_mvf <- renderPlot({
    ggplot(studentPerformanceData, aes(sex)) + geom_bar(fill=primary, color=tertiary)
  })
  
  output$student_corrplot <- renderPlot({
    corrplot(cor(studentPerformanceData[sapply(studentPerformanceData, class) == "integer"]))
  })
  
  output$x_axis_factor_columns <- renderUI({
    selectInput("x_axis", "X-Axis", column_names);
  })
  
  output$y_axis_factor_columns <- renderUI({
    selectInput("y_axis", "Y-Axis", column_names);
  })
  
  output$distribution_columns <- renderUI({
    selectInput("distribution_variable","Select the Variable You want to see the distribution of",column_names)
  })
  
  output$distribution_plot <- renderPlot({
    column_selected <- input$distribution_variable
    ggplot(studentPerformanceData, aes_string(column_selected)) + geom_bar(fill=primary, color=tertiary)
  })
  
  output$x_axis_chisq <- renderText({input$x_axis})
  output$y_axis_chisq <- renderText({input$y_axis})
  
  output$chi_sq_test_result <- renderPrint({
    x <- input$x_axis
    y <- input$y_axis
    test <- chisq.test(as.matrix(studentPerformanceData[x]),as.matrix(studentPerformanceData[y]))
    if(test$p.value > 0.05){
      "Retaining NULL Hypothesis"
    }else{
      "Retaining Alternate Hypothesis"
    }
  })
  
  output$regression <- renderPlot({
    ggplot(studentPerformanceData,aes_string(x=input$x_axis_regression, y=input$y_axis_regression)) + geom_point(color=tertiary) + 
      geom_smooth(method = 'lm', color=primary)
  })
  
  output$chi_sq_test <- renderPrint({
    x <- input$x_axis
    y <- input$y_axis
    chisq.test(as.matrix(studentPerformanceData[x]),as.matrix(studentPerformanceData[y]))
  })

  
}