#' rOpenSci ggplot2 theme
#'
#' @description rOpenSci ggplot2 theme, which is just a wrapper
#'  around Bob Rudis' hrbrthemes.
#'
#' @param base_size size parameter
#' @param axis_title_size size parameter
#' @param axis_title_size size parameter
#' @param ... other parameters passed to \code{hrbrthemes::theme_ipsum}
#'
#' @return ggplot2 theme
#' @export
#'
#' @examples
#' \dontrun{
#' library("ggplot2")
#' df <- data.frame(
#' gp = factor(rep(letters[1:3], each = 10)),
#' y = rnorm(30)
#' )
#' ggplot(df, aes(gp, y)) +
#'   geom_point() +
#'   ggtitle("wow title LHS great",
#'           subtitle = "nice plot") +
#'   theme_ro()
#'   }

theme_ro <- function(base_size = 12,
                     axis_title_size = 12,
                     axis_text_size = 12,
                     ...){
  hrbrthemes::theme_ipsum(base_size = 12,
                          axis_title_size = 12,
                          axis_text_size = 12,
                          ...)
}
