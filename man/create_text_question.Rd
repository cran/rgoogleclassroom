% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/form-edits.R
\name{create_text_question}
\alias{create_text_question}
\title{Create a text question}
\usage{
create_text_question(
  form_id = NULL,
  commit_to_form = TRUE,
  required = FALSE,
  question = NULL,
  correct_answer = NULL,
  google_forms_request = NULL,
  point_value = 1,
  location = 0,
  quiet = FALSE
)
}
\arguments{
\item{form_id}{The id of the google form to be updated}

\item{commit_to_form}{Whether or not the request should be committed. If need to build the request further, you will want to say FALSE. Default is TRUE}

\item{required}{TRUE or FALSE is this a required question? Default is not required.}

\item{question}{a string that is what the question should say}

\item{correct_answer}{A string that matches exactly what would be considered a correct}

\item{google_forms_request}{A google forms request object. If not supplied, it will be created new.}

\item{point_value}{An integer representing how many points}

\item{location}{Where should the new question be added}

\item{quiet}{TRUE/FALSE you'd like a progress message?}
}
\description{
This function makes a google request object that will be able to be posted with a batch request and
and added to a Google form to edit it.
}
\examples{
\dontrun{

create_text_question(
  form_id = "12345",
  question = "Put text here that is for filling in the blank",
  point_value = 1
)
}
}
