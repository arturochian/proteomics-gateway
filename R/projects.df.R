
pride_archive_url <- "http://www.ebi.ac.uk/pride/ws/archive"

#' Returns the number of public projects in PRIDE Archive
#'
#' @return The count of projects
#' @author Jose A. Dianes
#' @details TODO
#' @export
#' @importFrom rjson fromJSON
project_count <- function() {
  projectCount <- fromJSON(file=paste0(pride_archive_url, "/project/count"), method="C")
  projectCount                          
}

#' Retrieves the list of projects in PRIDE Archive
#'
#' @param count The maximum number of projects to retrieve in the list
#' @return The list of projects in a data frame
#' @author Jose A. Dianes
#' @details TODO
#' @export
#' @importFrom rjson fromJSON
project_list <- function(count) {
  prideJson <- fromJSON(file=paste0(pride_archive_url, "/project/list?show=",count), method="C")
  prideDataFrame <- fromJsonListToDataFrame(prideJson$list)
  prideDataFrame$numAssays <- as.numeric(prideDataFrame$numAssays)
  prideDataFrame
}

#' Returns a PRIDE Archive project
#'
#' @param accession The project accession
#' @return The project in a data frame
#' @author Jose A. Dianes
#' @details TODO
#' @export
#' @importFrom rjson fromJSON
project <- function(accession) {
  prideJson <- fromJSON(file=paste0(pride_archive_url, "/project/", accession), method="C")
  prideDataFrame <- fromJsonToDataFrame(prideJson)
  prideDataFrame$numAssays <- as.numeric(prideDataFrame$numAssays)
  prideDataFrame
}

#' Returns a series of PRIDE Archive projects
#' to satisify a given query. This is actually a 
#' query filtered version of project_list
#'
#' @param q The query terms
#' @param count The maximum number of search results
#' @return The search results in a data frame
#' @author Jose A. Dianes
#' @details TODO
#' @export
#' @importFrom rjson fromJSON
search_projects <- function(q,count) {
  prideJson <- fromJSON(file=paste0(pride_archive_url, "/project/list?show=",count,"&q=",q), method="C")
  prideDataFrame <- fromJsonListToDataFrame(prideJson$list)
  prideDataFrame$numAssays <- as.numeric(prideDataFrame$numAssays)
  prideDataFrame
}

fromJsonListToDataFrame <- function(jsonList) {
  cleanJsonList <- lapply(jsonList, function(x) {
    x[sapply(x, is.null)] <- NA # clean null values
    x[sapply(x,length)==0] <- NA # clean empty lists
    x[sapply(x,length)>1] <- sapply(x[sapply(x,length)>1], function(y) {paste(y,collapse=" || ")}) # clean multivalued lists
    unlist(x)
  })
  dataFrame <- as.data.frame(do.call("rbind", cleanJsonList))
}

fromJsonToDataFrame <- function(jsonItem) {
  jsonItem[sapply(jsonItem, is.null)] <- NA # clean null values
  jsonItem[sapply(jsonItem,length)==0] <- NA # clean empty lists
  jsonItem[sapply(jsonItem,length)>1] <- sapply(jsonItem[sapply(jsonItem,length)>1], function(y) {paste(y,collapse=" || ")}) # clean multivalued lists
  dataFrame <- as.data.frame(jsonItem)
}