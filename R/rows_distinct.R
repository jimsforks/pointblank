#' Verify that row data are distinct
#'
#' Verification step where the combination of row data across selected columns
#' should be distinct, or, contain no duplicates.
#'
#' @inheritParams col_vals_gt
#' @param x An agent object of class `ptblank_agent`.
#'   
#' @return A `ptblank_agent` object.
#'   
#' @examples
#' # Create a simple data frame with
#' # three columns of numerical values
#' df <-
#'   data.frame(
#'     a = c(5, 7, 6, 5, 8, 7),
#'     b = c(7, 1, 0, 0, 8, 3),
#'     c = c(1, 1, 1, 3, 3, 3)
#'   )
#' 
#' # Validate that when considering only
#' # data in columns `a` and `b`, there
#' # are no duplicate rows (i.e., all
#' # rows are distinct)
#' agent <-
#'   create_agent(tbl = df) %>%
#'   rows_distinct(vars(a, b)) %>%
#'   interrogate()
#' 
#' # Determine if these column
#' # validations have all passed
#' # by using `all_passed()`
#' all_passed(agent)
#' 
#' @import rlang
#' @export
rows_distinct <- function(x,
                          columns = NULL,
                          preconditions = NULL,
                          actions = NULL,
                          brief = NULL) {

  # Capture the `columns` expression
  columns <- rlang::enquo(columns)
  
  # Resolve the columns based on the expression
  columns <- resolve_columns(x = x, var_expr = columns, preconditions)
  
  if (is_a_table_object(x)) {
    
    secret_agent <- create_agent(x) %>%
      rows_distinct(
        columns = columns,
        preconditions = preconditions,
        brief = brief,
        actions = prime_actions(actions)
      ) %>% interrogate()
    
    return(x)
  }
  
  agent <- x
  
  if (length(columns) > 0) {
    
    columns <- paste(columns, collapse = ", ")
    
  } else {
    
    columns <- NULL
  }
  
  if (is.null(brief)) {
    
    brief <-
      create_autobrief(
        agent = agent,
        assertion_type = "rows_distinct",
        column = columns
      )
  }
  
  # Add one or more validation steps
  agent <-
    create_validation_step(
      agent = agent,
      assertion_type = "rows_distinct",
      column = list(ifelse(is.null(columns), as.character(NA), columns)),
      value = NULL,
      preconditions = preconditions,
      actions = actions,
      brief = brief
    )

  agent
}

#' Verify that row data are not duplicated (deprecated)
#'
#' @inheritParams col_vals_gt
#' @param x An agent object of class `ptblank_agent`.
#'   
#' @return A `ptblank_agent` object.
#'
#' @export
rows_not_duplicated <- function(x,
                                columns = NULL,
                                preconditions = NULL,
                                brief = NULL,
                                actions = NULL) {
  
  # nocov start

  warning("The `rows_not_duplicated()` function is deprecated and will soon be removed\n",
          " * Use the `rows_distinct()` function instead",
          call. = FALSE)
  
  rows_distinct(
    x = x,
    columns = {{ columns }},
    preconditions = preconditions,
    brief = brief,
    actions = actions
  )

  # nocov end
}
