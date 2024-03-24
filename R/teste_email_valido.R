#' Teste com expressão regular se o endereço de email tem uma estrutura válida
#'
#' @param email Endereço de email a ser testado
#'
#' @return Valor lógico (TRUE/FALSE)
#' @export
#'
#' @examples
#' testar_validade_email("milz.bea@gmail.com")
testar_validade_email <- function(email) {
  grepl(
    "\\<[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}\\>",
    as.character(email),
    ignore.case = TRUE
  )
}
