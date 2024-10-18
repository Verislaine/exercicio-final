# Função para calcular o VPL trazendo todos os fluxos para o valor presente
calcular_vpl_mensal <- function(fluxos, taxa) {
  vpl_total <- sum(fluxos / ((1 + taxa)^(1:length(fluxos))))
  return(vpl_total)
}

# Gerando o fluxo de caixa com 100 valores (média 5000, desvio padrão 1000)
set.seed(123)
fluxos <- rnorm(100, mean = 5000, sd = 1000)

# Taxas de desconto de 0.01 a 0.10
taxas <- seq(0.01, 0.10, by = 0.01)

# Criando uma matriz
resultados <- matrix(nrow = length(fluxos), ncol = length(taxas) + 1)
colnames(resultados) <- c("Fluxo", paste0("VPL_TAXA_", formatC(taxas, format = "f", digits = 2)))

# Calculando o VPL para cada taxa de desconto, trazendo tudo para o valor presente no mês 1
for (i in 1:length(fluxos)) {
  resultados[i, 1] <- fluxos[i]
  for (j in 1:length(taxas)) {
    # Calcula o VPL de cada fluxo para o valor presente no mês 1
    resultados[i, j + 1] <- fluxos[i] / ((1 + taxas[j])^i)
  }
}

# Adicionando os somatórios dos fluxos e dos VPLs (trazidos para o mês 1)
soma_fluxos <- sum(resultados[, 1])
soma_vpls <- colSums(resultados[, -1])

# Criando o data frame para exibir a tabela de fluxos
df_fluxos <- data.frame(Mês = 1:100, Fluxo = resultados[, 1], VPL_TAXA_0_01 = resultados[, 2], VPL_TAXA_0_02 = resultados[, 3], 
                        VPL_TAXA_0_03 = resultados[, 4], VPL_TAXA_0_04 = resultados[, 5], VPL_TAXA_0_05 = resultados[, 6], 
                        VPL_TAXA_0_06 = resultados[, 7], VPL_TAXA_0_07 = resultados[, 8], VPL_TAXA_0_08 = resultados[, 9], 
                        VPL_TAXA_0_09 = resultados[, 10], VPL_TAXA_0_10 = resultados[, 11])

# Exibindo os resultados
print(df_fluxos)

# Exibindo os somatórios
print(data.frame(Fluxo_Total = soma_fluxos, VPL_TAXA_0_01 = soma_vpls[1], VPL_TAXA_0_02 = soma_vpls[2], 
                 VPL_TAXA_0_03 = soma_vpls[3], VPL_TAXA_0_04 = soma_vpls[4], VPL_TAXA_0_05 = soma_vpls[5], 
                 VPL_TAXA_0_06 = soma_vpls[6], VPL_TAXA_0_07 = soma_vpls[7], VPL_TAXA_0_08 = soma_vpls[8], 
                 VPL_TAXA_0_09 = soma_vpls[9], VPL_TAXA_0_10 = soma_vpls[10]))
