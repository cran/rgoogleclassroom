#' Pipe operator
#'
#' See \code{magrittr::\link[magrittr:pipe]{\%>\%}} for details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
#' @param lhs A value or the magrittr placeholder.
#' @param rhs A function call using the magrittr semantics.
#' @return The result of calling `rhs(lhs)`.
NULL

utils::globalVariables(c(
  "link", "point_value", "formatted_df", "form_info", "all_answers", "question",
  "type", "original", "trimmed", "shuffle_opt", "index", "quiz_path"
))

#' Generate endpoint for the Google classroom API
#' @param type_of_endpoint Type of endpoint to convert to url
#' @param course_id (Optional) ID of the google course to be affected/retrieved
#' @param topic_id (Optional) ID of the topic to be affected/retrieved
#' @param coursework_id (Optional) ID of the coursework to be affected/retrieved
#' @param materials_id (Optional) ID of the material to be affected/retrieved
#' @param form_id (Optional) ID of the form to be affected/retrieved
#' @return A url that is the endpoint for the API call
#' @importFrom assertthat is.string

get_endpoint <- function(type_of_endpoint = "classroom.endpoint.user",
                         course_id = NULL,
                         topic_id = NULL,
                         coursework_id = NULL,
                         materials_id = NULL,
                         form_id = NULL) {
  # Make sure the options given are strings
  if (!is.null(course_id)) assert_that(is.string(course_id))
  if (!is.null(topic_id)) assert_that(is.string(topic_id))
  if (!is.null(coursework_id)) assert_that(is.string(coursework_id))
  if (!is.null(materials_id)) assert_that(is.string(materials_id))
  if (!is.null(form_id)) assert_that(is.string(form_id))

  # Here's our endpoints
  endpoint_list <- list(
    googledrive.endpoint = "https://www.googleapis.com/drive/v3/files/",
    googledrive.endpoint.copy = "https://www.googleapis.com/drive/v3/files/{formId}/copy",
    classroom.endpoint.user = "https://classroom.googleapis.com/v1/userProfiles/me",
    classroom.endpoint.course.get = "https://classroom.googleapis.com/v1/courses",
    classroom.endpoint.course = "https://classroom.googleapis.com/v1/courses/{courseId}",
    classroom.endpoint.topic.get = "https://classroom.googleapis.com/v1/courses/{courseId}/topics/",
    classroom.endpoint.topic = "https://classroom.googleapis.com/v1/courses/{courseId}/topics/{topicId}",
    classroom.endpoint.coursework.get = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWork/",
    classroom.endpoint.coursework = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWork/{courseWorkId}/",
    classroom.endpoint.materials.get = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWorkMaterials",
    classroom.endpoint.materials = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWorkMaterials/{materialsId}",
    forms.endpoint.get = "https://forms.googleapis.com/v1/forms/",
    forms.endpoint = "https://forms.googleapis.com/v1/forms/{formId}",
    forms.endpoint.batchUpdate = "https://forms.googleapis.com/v1/forms/{formId}:batchUpdate",
    forms.endpoint.responses = "https://forms.googleapis.com/v1/forms/{formId}/responses"
  )

  if (!(type_of_endpoint %in% names(endpoint_list))) {
    stop(paste0("No such endpoint: '", type_of_endpoint, "' supported or in the list"))
  }

  # Extract the endpoint based on what is specified
  endpoint <- endpoint_list[[type_of_endpoint]]

  # Start off with URL that we will build
  url_temp <- endpoint

  # Here's the list of the ids we may need
  variables_list <- list(
    "{courseId}" = course_id,
    "{topicId}" = topic_id,
    "{courseWorkId}" = coursework_id,
    "{materialsId}" = materials_id,
    "{formId}" = form_id
  )

  # Find out which need to be set based on endpoint grep
  which_to_set <- sapply(names(variables_list), grepl, x = endpoint, fixed = TRUE)

  variables_list <- unlist(variables_list[which_to_set])

  # Go through each variable and replace it with the function defined ids to build the URL
  if (length(variables_list) > 0) {
    for (item in 1:length(variables_list)) {
      # If the variable is null stop.
      if (is.null(variables_list[item])) stop(paste("Variable not set. Require:", names(variables_list)[item]))

      # Replace the variable with the thing set
      url_temp <- gsub(names(variables_list)[item], variables_list[item], url_temp, fixed = TRUE)
    }
  }

  # Return the URL
  return(url_temp)
}


handle_linked_sheet <- function(linked_sheet) {
  if (!is.null(linked_sheet)) assert_that(is.string(linked_sheet))

  # If user provides a link, extract the sheet id from it
  if (grepl("http", linked_sheet)) {
    strings_to_remove <- "https://docs.google.com/spreadsheets/d/|/edit"
    linked_sheet <- stringr::word(linked_sheet, sep = strings_to_remove, 2)
  }

  return(linked_sheet)
}

handle_form_url <- function(form_url) {
  if (!is.null(form_url)) assert_that(is.string(form_url))

  # If user provides a link, extract the sheet id from it
  if (grepl("http", form_url)) {
    strings_to_remove <- "https://docs.google.com/forms/d/|/edit|/viewform"
    form_url <- stringr::word(form_url, sep = strings_to_remove, 2)
  }

  return(form_url)
}
