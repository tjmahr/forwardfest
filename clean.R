# Delete all figures, html and docx files
file.remove(list.files(
  rprojroot::find_rstudio_root_file(),
  pattern = "html$|png$|docx$",
  recursive = TRUE,
  full.names = TRUE))

