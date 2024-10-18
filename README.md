import pandas as pd
from tabulate import tabulate

# Classe base para representar os investimentos:
class Investimento:
    def __init__(self, nome, quantidade, valor_unitario):
        self.nome = nome
        self.quantidade = quantidade
        self.valor_unitario = valor_unitario
        self.percentual = 0
        self.valor_alocado = 0
        self.dividendos = 0  # Inicializa os dividendos como 0
        self.taxa_juros = 0  # Inicializa a taxa de juros como 0

    def valor_total(self):
        return self.quantidade * self.valor_unitario

# Subclasse para ações:
class Acao(Investimento):
    def __init__(self, nome, quantidade, valor_unitario, dividendos):
        super().__init__(nome, quantidade, valor_unitario)
        self.dividendos = dividendos

# Subclasse para títulos:
class Titulo(Investimento):
    def __init__(self, nome, quantidade, valor_unitario, taxa_juros):
        super().__init__(nome, quantidade, valor_unitario)
        self.taxa_juros = taxa_juros

# Subclasse para fundos mútuos:
class FundoMutuo(Investimento):
    def __init__(self, nome, quantidade, valor_unitario, dividendos):
        super().__init__(nome, quantidade, valor_unitario)
        self.dividendos = dividendos

# Subclasse para imóveis:
class Imovel(Investimento):
    def __init__(self, nome, valor_unitario, aluguel_mensal):
        super().__init__(nome, 1, valor_unitario)  # Imóveis têm quantidade 1
        self.aluguel_mensal = aluguel_mensal

# Subclasse para commodities:
class Commodities(Investimento):
    def __init__(self, nome, quantidade, valor_unitario):
        super().__init__(nome, quantidade, valor_unitario)

# Subclasse para fundos imobiliários:
class FundoImobiliario(Investimento):
    def __init__(self, nome, quantidade, valor_unitario, dividendos):
        super().__init__(nome, quantidade, valor_unitario)
        self.dividendos = dividendos

# Classe para gerenciar o portfólio:
class Portfolio:
    def __init__(self, total_investimento):
        self.total_investimento = total_investimento
        self.investimentos = []

    def adicionar_investimento(self, investimento):
        self.investimentos.append(investimento)

    def remover_investimentos(self, nomes_investimentos, remover=True):
        if remover:
            removidos = []
            nao_encontrados = []

            for nome_investimento in nomes_investimentos:
                investimentos_antes = len(self.investimentos)
                self.investimentos = [i for i in self.investimentos if i.nome != nome_investimento]
                investimentos_depois = len(self.investimentos)

                if investimentos_depois < investimentos_antes:
                    removidos.append(nome_investimento)
                else:
                    nao_encontrados.append(nome_investimento)

            if removidos:
                print(f"Investimentos removidos: {', '.join(removidos)}")
            if nao_encontrados:
                print(f"Investimentos não encontrados: {', '.join(nao_encontrados)}")
        else:
            print("Não foram removidos investimentos do portfólio.")

    def distribuir_percentual_por_tipo(self, tipo_investimento, percentual_alocado):
        ativos_tipo = [i for i in self.investimentos if isinstance(i, tipo_investimento)]
        if len(ativos_tipo) == 0:
            return

        percentual_por_ativo = percentual_alocado / len(ativos_tipo)
        for ativo in ativos_tipo:
            ativo.percentual = percentual_por_ativo

    def recalcular_portfolio(self, alocacao_tipos):
        for tipo, percentual in alocacao_tipos.items():
            if tipo == 'Ação':
                self.distribuir_percentual_por_tipo(Acao, percentual)
            elif tipo == 'Fundo Mútuo':
                self.distribuir_percentual_por_tipo(FundoMutuo, percentual)
            elif tipo == 'Commodities':
                self.distribuir_percentual_por_tipo(Commodities, percentual)
            elif tipo == 'Título':
                self.distribuir_percentual_por_tipo(Titulo, percentual)
            elif tipo == 'Imóvel':
                self.distribuir_percentual_por_tipo(Imovel, percentual)
            elif tipo == 'Fundo Imobiliário':
                self.distribuir_percentual_por_tipo(FundoImobiliario, percentual)

        for investimento in self.investimentos:
            investimento.valor_alocado = (investimento.percentual / 100) * self.total_investimento
            if investimento.valor_unitario > 0:
                investimento.quantidade = investimento.valor_alocado / investimento.valor_unitario
            else:
                investimento.quantidade = 0

    def valor_total_portfolio(self):
        return sum(invest.valor_total() for invest in self.investimentos)

    def gerar_relatorio(self):
        dados = []

        tipo_traducao = {
            'Acao': 'Ação',
            'FundoMutuo': 'Fundo Mútuo',
            'Commodities': 'Commodities',
            'Titulo': 'Título',
            'Imovel': 'Imóvel',
            'FundoImobiliario': 'Fundo Imobiliário'
        }

        for invest in self.investimentos:
            tipo_invest = tipo_traducao.get(type(invest).__name__, 'Outro')
            dados.append({
                'Nome': invest.nome,
                'Tipo': tipo_invest,
                'Valor Unitário': f"R${invest.valor_unitario:,.2f}",
                'Percentual': f"{invest.percentual:.2f}%",
                'Valor Alocado (R$)': f"R${invest.valor_alocado:,.2f}",
                'Quantidade': f"{invest.quantidade:.4f}",
                'Dividendos': f"R${invest.dividendos:.2f}" if invest.dividendos else "N/A",
                'Taxa de Juros': f"{invest.taxa_juros:.2%}" if invest.taxa_juros else "N/A",
                'Aluguel Mensal': f"R${getattr(invest, 'aluguel_mensal', 'N/A')}"
            })
        df = pd.DataFrame(dados)
        print(tabulate(df, headers='keys', tablefmt='pretty', showindex=False))

# Especificações da carteira definidas a priori:
total_investimento = 20000  # Aporte inicial
alocacao_tipos = {
    "Ação": 30,
    "Fundo Mútuo": 20,
    "Commodities": 15,
    "Título": 20,
    "Fundo Imobiliário": 10,
    "Imóvel": 5
}

# Cria o portfólio:
meu_portfolio = Portfolio(total_investimento)

# Adiciona investimentos:
meu_portfolio.adicionar_investimento(Acao("BBAS3", 37.5404, 26.08, 0.17))
meu_portfolio.adicionar_investimento(Acao("VALE3", 16.5520, 59.15, 0))
meu_portfolio.adicionar_investimento(FundoMutuo("VFIAX", 1.8320, 501.01, 1.78))
meu_portfolio.adicionar_investimento(Commodities("Ouro", 10, 298.56))
meu_portfolio.adicionar_investimento(Titulo("Tesouro Prefixado 2030", 1.5978, 765.95, 0.0107))
meu_portfolio.adicionar_investimento(FundoImobiliario("FII XPML11", 15, 95.85, 0.58))
meu_portfolio.adicionar_investimento(Imovel("Apartamento SP", 500000, 2500))

# Recalcula o portfólio com base nas alocações:
meu_portfolio.recalcular_portfolio(alocacao_tipos)

# Exibe o portfólio original:
print("\n--- Portfólio Original ---")
meu_portfolio.gerar_relatorio()

# Remove alguns investimentos:
meu_portfolio.remover_investimentos(["Ouro", "Apartamento SP"], remover=True)

# Recalcula o portfólio após a remoção dos ativos:
meu_portfolio.recalcular_portfolio(alocacao_tipos)

# Exibe o portfólio atualizado:
print("\n--- Portfólio Atualizado ---")
meu_portfolio.gerar_relatorio()

# Valor total do portfólio:
print(f"\nValor total do portfólio: R$ {meu_portfolio.valor_total_portfolio():,.2f}")
