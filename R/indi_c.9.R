#'
#' Taxa de mortalidade específica por causas externas - C.9
#'
#' Follows the RIPSA 2012 card \url{http://fichas.ripsa.org.br/2012/c-9}
#'
#' @param conn Connection object created with \code{\link{pcdas_connect}}.
#' @param ano numeric. Year.
#' @param multi Indicator multiplier. Defaults to RIPSA recommendation.
#'
#' @return A \code{data.frame} containing the municipalities IBGE codes (\code{cod_mun}) and the calculated indicator.
#' @examples
#' c.9 <- indi_c.9(conn, 2010)

indi_c.9 <- function(conn, ano, multi = 100000){

  sim <- get_sim_mun(conn = conn, ano = ano, causabas_capitulo = "XX.  Causas externas de morbidade e mortalidade")
  pop <- get_pop_mun(conn = conn, ano = ano)

  df <- dplyr::left_join(sim, pop, by = c("cod_mun", "cod_mun")) %>%
    mutate(indi_c.9 = sim/pop*multi) %>%
    select(cod_mun, indi_c.9)

  return(df)
}
