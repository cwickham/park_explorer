# Function to form a one sentence summary from a year
# of annual data
summarize_park <- function(one_year){
  comma <- scales::label_comma()
  one_year %>% 
    glue::glue_data(
      "In { year }, { park_name } had { comma(recreation_visits) } recreation visits."
    )
}

