#'
#' Taxa de mortalidade na infância - C.16
#'
#' Follows the RIPSA 2012 card \url{http://fichas.ripsa.org.br/2012/c-16}
#'
#' @param conn Connection object created with \code{\link{pcdas_connect}}.
#' @param ano numeric. Year.
#' @param multi Indicator multiplier. Defaults to RIPSA recommendation.
#'
#' @return A \code{data.frame} containing the municipalities IBGE codes (\code{cod_mun}) and the calculated indicator.
#' @examples
#' c.16 <- indi_c.16(conn = conn, ano = 2010)

indi_c.16 <- function(conn, ano, multi = 1000){

  sim <- get_sim_mun(conn = conn, ano = ano, idade_obito_anos_min = 0, idade_obito_anos_max = 5)
  sinasc <- get_sinasc_mun(conn = conn, ano = ano)

  df <- dplyr::left_join(sim, sinasc, by = c("cod_mun", "cod_mun")) %>%
    mutate(indi_c.16 = sim/sinasc*multi) %>%
    select(cod_mun, indi_c.16)

  return(df)
}
