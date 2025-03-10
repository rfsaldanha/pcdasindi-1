#'
#' Taxa de mortalidade específica por diabete melito - C.12
#'
#' Follows the RIPSA 2012 card \url{http://fichas.ripsa.org.br/2012/c-12}
#'
#' @param conn Connection object created with \code{\link{pcdas_connect}}.
#' @param ano numeric. Year.
#' @param multi Indicator multiplier. Defaults to RIPSA recommendation.
#'
#' @return A \code{data.frame} containing the municipalities IBGE codes (\code{cod_mun}) and the calculated indicator.
#' @examples
#' c.12 <- indi_c.12(conn, 2010)

indi_c.12 <- function(conn, ano, multi = 100000){

  categorias <- c(
    "E10   Diabetes mellitus insulino-dependente",
    "E11   Diabetes mellitus nao-insulino-dependemte",
    "E12   Diabetes mellitus relac c/a desnutr",
    "E13   Outr tipos espec de diabetes mellitus",
    "E14   Diabetes mellitus NE"
  )

  sim <- data.frame()
  sim$cod_mun <- as.character()
  for(c in 1:length(categorias)){
    temp <- get_sim_mun(conn = conn, ano = ano, causabas_categoria = categorias[c])
    sim <- dplyr::full_join(sim, temp, by = c("cod_mun", "cod_mun"))
  }

  sums <- rowSums(sim[,-1], na.rm = TRUE)

  sim <- data.frame(cod_mun = sim$cod_mun, sim = sums)
  sim$cod_mun <- as.character(sim$cod_mun)

  pop <- get_pop_mun(conn = conn, ano = ano)

  df <- dplyr::left_join(sim, pop, by = c("cod_mun", "cod_mun")) %>%
    mutate(indi_c.12 = sim/pop*multi) %>%
    select(cod_mun, indi_c.12)

  return(df)
}
