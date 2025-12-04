# 🗄️ Evelyn PRO - SQL Avançado para Análise de Dados

![SQL](https://img.shields.io/badge/SQL-Advanced-blue)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-316192?logo=postgresql)
![Status](https://img.shields.io/badge/Status-Completo-success)

## 📊 Sobre o Projeto

Projeto de portfólio técnico demonstrando domínio de **SQL avançado** para análise de dados corporativos. Inclui banco de dados completo com 4 tabelas relacionais e 10 queries complexas cobrindo:

- ✅ **JOINs Múltiplos** (INNER, LEFT, RIGHT)
- ✅ **CTEs** (Common Table Expressions)
- ✅ **Window Functions** (RANK, LAG, Moving Averages)
- ✅ **Agregações Complexas**
- ✅ **Queries otimizadas para BI**
- ✅ **Análise RFM** para segmentação de clientes

## 🎯 Casos de Uso

1. **Análise 360º de Pedidos** - Visão completa unindo clientes, pedidos e entregas
2. **Performance de Vendedores** - KPIs de vendas e eficiência logística
3. **Lifetime Value de Clientes** - Identificação de padrões de recompra
4. **Crescimento Mês a Mês** - Análise temporal com cálculo de variação
5. **Ranking de Clientes** - Classificação por receita e segmento
6. **Tendências de Conversão** - Médias móveis para identificar padrões
7. **Análise Multidimensional** - Cruzamento de segmento x forma de pagamento
8. **Performance Logística** - Avaliação de transportadoras
9. **Dataset para Dashboard** - KPIs prontos para Power BI
10. **Segmentação RFM** - Classificação de clientes para marketing

## 🗃️ Estrutura do Banco de Dados
clientes (10 registros)

├── cliente_id (PK)

├── nome, email, telefone

├── cidade, estado

├── segmento

└── data_cadastro, status

pedidos (15 registros)

├── pedido_id (PK)

├── cliente_id (FK)

├── data_pedido

├── valor_total, desconto

├── status_pedido

├── forma_pagamento

└── vendedor

entregas (12 registros)

├── entrega_id (PK)

├── pedido_id (FK)

├── data_envio, data_entrega_prevista, data_entrega_real

├── status_entrega

├── transportadora

└── custo_frete

metricas_diarias (10 registros)

├── metrica_id (PK)

├── data_referencia

├── visitas_site, conversoes

├── ticket_medio

└── taxa_conversao

## 🚀 Como Executar

### Opção 1: PostgreSQL
# Criar o banco

creatdb evelyn_pro_analytics

# Executar os scripts

psql -d evelyn_pro_analytics -f 01_criar_tabelas.sql

psql -d evelyn_pro_analytics -f 02_inserir_dados.sql

psql -d evelyn_pro_analytics -f sql_avancado_evelyn_pro.sql

### Opção 2: SQLite
import sqlite3

conn = sqlite3.connect('evelyn_pro_analytics.db')

cursor = conn.cursor()

for arquivo in ['01_criar_tabelas.sql', '02_inserir_dados.sql', 'sql_avancado_evelyn_pro.sql']:

with open(arquivo, 'r', encoding='utf-8') as f:

cursor.executescript([f.read](http://f.read)())

conn.commit()

conn.close()

## 💡 Destaques Técnicos

- **CTEs Encadeadas**: Queries modulares e reutilizáveis
- **Window Functions**: Cálculos contextuais sem GROUP BY
- **Análise RFM**: Técnica avançada de segmentação de clientes
- **Moving Averages**: Suavização de tendências temporais
- **Queries Otimizadas**: Preparadas para grandes volumes de dados

## 📈 Próximos Passos

- [ ] Integração com Power BI
- [ ] API FastAPI para consulta de dados
- [ ] Dashboard interativo
- [ ] Testes de performance

## 👩‍💻 Autora

**Evelyn Moura**  
Consultora de Automação & Processos | Especialista em Dados

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue)](https://www.linkedin.com/in/evelyn-moura-dos-santos-6a6094211?utm_source=share_via&utm_content=profile&utm_medium=member_ios)
[![Portfolio](https://img.shields.io/badge/Portfolio-View-success)](https://github.com/evemoura56-cloud)

---

⭐ Se este projeto foi útil, deixe uma estrela!
