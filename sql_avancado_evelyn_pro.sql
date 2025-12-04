-- =============================================
-- EVELYN PRO - SQL AVANÇADO PARA ANÁLISE DE DADOS
-- 10 Queries Profissionais para Portfólio Tech
-- =============================================

-- =============================================
-- CATEGORIA 1: JOINS MÚLTIPLOS
-- =============================================

-- Query 1: Análise Completa de Pedidos com Clientes e Entregas
-- Objetivo: Unir dados de 3 tabelas para visão 360º do pedido
SELECT 
    c.nome AS cliente,
    c.cidade,
    c.estado,
    c.segmento,
    p.pedido_id,
    p.data_pedido,
    p.valor_total,
    p.status_pedido,
    e.data_entrega_prevista,
    e.data_entrega_real,
    e.status_entrega,
    e.transportadora,
    CASE 
        WHEN e.data_entrega_real IS NULL THEN 'Não Entregue'
        WHEN e.data_entrega_real <= e.data_entrega_prevista THEN 'No Prazo'
        ELSE 'Atrasado'
    END AS avaliacao_entrega
FROM clientes c
INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
LEFT JOIN entregas e ON p.pedido_id = e.pedido_id
WHERE p.status_pedido != 'Cancelado'
ORDER BY p.data_pedido DESC;

-- Query 2: Performance de Vendedores com Dados de Cliente e Entrega
-- Objetivo: Avaliar eficiência de cada vendedor incluindo taxa de atraso
SELECT 
    p.vendedor,
    COUNT(DISTINCT p.pedido_id) AS total_pedidos,
    COUNT(DISTINCT c.cliente_id) AS clientes_atendidos,
    SUM(p.valor_total) AS receita_total,
    AVG(p.valor_total) AS ticket_medio,
    SUM(p.desconto) AS total_descontos,
    COUNT(CASE WHEN e.data_entrega_real > e.data_entrega_prevista THEN 1 END) AS entregas_atrasadas,
    ROUND(COUNT(CASE WHEN e.data_entrega_real > e.data_entrega_prevista THEN 1 END) * 100.0 / 
          NULLIF(COUNT(e.entrega_id), 0), 2) AS taxa_atraso_pct
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.cliente_id
LEFT JOIN entregas e ON p.pedido_id = e.pedido_id
WHERE p.status_pedido = 'Concluído'
GROUP BY p.vendedor
ORDER BY receita_total DESC;

-- =============================================
-- CATEGORIA 2: CTEs (Common Table Expressions)
-- =============================================

-- Query 3: Análise de Clientes com Múltiplas Compras usando CTE
-- Objetivo: Identificar padrões de recompra e lifetime value
WITH cliente_stats AS (
    SELECT 
        c.cliente_id,
        c.nome,
        c.segmento,
        COUNT(p.pedido_id) AS total_pedidos,
        SUM(p.valor_total) AS lifetime_value,
        AVG(p.valor_total) AS ticket_medio,
        MIN(p.data_pedido) AS primeira_compra,
        MAX(p.data_pedido) AS ultima_compra
    FROM clientes c
    LEFT JOIN pedidos p ON c.cliente_id = p.cliente_id
    WHERE p.status_pedido = 'Concluído'
    GROUP BY c.cliente_id, c.nome, c.segmento
)
SELECT 
    *,
    CASE 
        WHEN total_pedidos >= 3 THEN 'VIP'
        WHEN total_pedidos = 2 THEN 'Recorrente'
        ELSE 'Novo'
    END AS classificacao_cliente,
    ROUND(lifetime_value / NULLIF(total_pedidos, 0), 2) AS valor_medio_pedido
FROM cliente_stats
WHERE total_pedidos > 0
ORDER BY lifetime_value DESC;

-- Query 4: Análise Temporal de Vendas com CTE Encadeada
-- Objetivo: Calcular crescimento mês a mês
WITH vendas_mensais AS (
    SELECT 
        DATE_TRUNC('month', data_pedido) AS mes,
        COUNT(pedido_id) AS qtd_pedidos,
        SUM(valor_total) AS receita_total,
        AVG(valor_total) AS ticket_medio
    FROM pedidos
    WHERE status_pedido = 'Concluído'
    GROUP BY DATE_TRUNC('month', data_pedido)
),
vendas_com_lag AS (
    SELECT 
        mes,
        qtd_pedidos,
        receita_total,
        ticket_medio,
        LAG(receita_total) OVER (ORDER BY mes) AS receita_mes_anterior
    FROM vendas_mensais
)
SELECT 
    TO_CHAR(mes, 'YYYY-MM') AS mes_ref,
    qtd_pedidos,
    ROUND(receita_total, 2) AS receita,
    ROUND(ticket_medio, 2) AS ticket_medio,
    ROUND(receita_mes_anterior, 2) AS receita_mes_anterior,
    ROUND(
        ((receita_total - receita_mes_anterior) / NULLIF(receita_mes_anterior, 0)) * 100, 
        2
    ) AS crescimento_pct
FROM vendas_com_lag
ORDER BY mes;

-- =============================================
-- CATEGORIA 3: WINDOW FUNCTIONS
-- =============================================

-- Query 5: Ranking de Clientes por Receita com Window Function
-- Objetivo: Classificar clientes e calcular participação no faturamento
SELECT 
    c.nome AS cliente,
    c.segmento,
    SUM(p.valor_total) AS receita_total,
    COUNT(p.pedido_id) AS total_pedidos,
    RANK() OVER (ORDER BY SUM(p.valor_total) DESC) AS ranking_receita,
    DENSE_RANK() OVER (PARTITION BY c.segmento ORDER BY SUM(p.valor_total) DESC) AS ranking_no_segmento,
    ROUND(
        SUM(p.valor_total) * 100.0 / SUM(SUM(p.valor_total)) OVER (),
        2
    ) AS percentual_faturamento
FROM clientes c
INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
WHERE p.status_pedido = 'Concluído'
GROUP BY c.cliente_id, c.nome, c.segmento
ORDER BY receita_total DESC;

-- Query 6: Análise de Tendência de Conversão com Moving Average
-- Objetivo: Suavizar flutuações diárias e identificar tendências
SELECT 
    data_referencia,
    visitas_site,
    conversoes,
    taxa_conversao,
    ROUND(
        AVG(taxa_conversao) OVER (
            ORDER BY data_referencia 
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS taxa_conversao_media_movel_3d,
    ROUND(
        AVG(visitas_site) OVER (
            ORDER BY data_referencia 
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ),
        0
    ) AS visitas_media_movel_7d
FROM metricas_diarias
ORDER BY data_referencia;

-- =============================================
-- CATEGORIA 4: AGREGAÇÕES COMPLEXAS
-- =============================================

-- Query 7: Análise Multidimensional por Segmento e Forma de Pagamento
-- Objetivo: Cruzar múltiplas dimensões para insights de negócio
SELECT 
    c.segmento,
    p.forma_pagamento,
    COUNT(DISTINCT c.cliente_id) AS clientes_unicos,
    COUNT(p.pedido_id) AS total_pedidos,
    SUM(p.valor_total) AS receita_total,
    AVG(p.valor_total) AS ticket_medio,
    SUM(p.desconto) AS total_descontos,
    ROUND(SUM(p.desconto) * 100.0 / NULLIF(SUM(p.valor_total), 0), 2) AS taxa_desconto_pct,
    MIN(p.valor_total) AS menor_pedido,
    MAX(p.valor_total) AS maior_pedido
FROM clientes c
INNER JOIN pedidos p ON c.cliente_id = p.cliente_id
WHERE p.status_pedido = 'Concluído'
GROUP BY c.segmento, p.forma_pagamento
HAVING COUNT(p.pedido_id) >= 1
ORDER BY c.segmento, receita_total DESC;

-- Query 8: Análise de Performance Logística
-- Objetivo: Avaliar eficiência de transportadoras e custos
SELECT 
    e.transportadora,
    COUNT(e.entrega_id) AS total_entregas,
    SUM(e.custo_frete) AS custo_total_frete,
    AVG(e.custo_frete) AS custo_medio_frete,
    COUNT(CASE WHEN e.status_entrega = 'Entregue' THEN 1 END) AS entregas_concluidas,
    COUNT(CASE WHEN e.data_entrega_real <= e.data_entrega_prevista THEN 1 END) AS entregas_no_prazo,
    COUNT(CASE WHEN e.data_entrega_real > e.data_entrega_prevista THEN 1 END) AS entregas_atrasadas,
    ROUND(
        COUNT(CASE WHEN e.data_entrega_real <= e.data_entrega_prevista THEN 1 END) * 100.0 / 
        NULLIF(COUNT(CASE WHEN e.data_entrega_real IS NOT NULL THEN 1 END), 0),
        2
    ) AS taxa_pontualidade_pct,
    ROUND(
        AVG(CASE 
            WHEN e.data_entrega_real IS NOT NULL 
            THEN e.data_entrega_real - e.data_envio 
        END),
        1
    ) AS tempo_medio_entrega_dias
FROM entregas e
GROUP BY e.transportadora
ORDER BY taxa_pontualidade_pct DESC;

-- =============================================
-- CATEGORIA 5: QUERIES PARA BI
-- =============================================

-- Query 9: Dataset para Dashboard Executivo
-- Objetivo: KPIs principais para visualização em Power BI
SELECT 
    -- Dimensões de tempo
    DATE_TRUNC('month', p.data_pedido) AS mes,
    EXTRACT(YEAR FROM p.data_pedido) AS ano,
    EXTRACT(QUARTER FROM p.data_pedido) AS trimestre,
    
    -- Dimensões de negócio
    c.segmento,
    c.estado,
    p.forma_pagamento,
    p.vendedor,
    
    -- Métricas
    COUNT(DISTINCT c.cliente_id) AS clientes_unicos,
    COUNT(p.pedido_id) AS total_pedidos,
    SUM(p.valor_total) AS receita_bruta,
    SUM(p.desconto) AS total_descontos,
    SUM(p.valor_total - p.desconto) AS receita_liquida,
    AVG(p.valor_total) AS ticket_medio,
    
    -- Métricas de entrega
    COUNT(e.entrega_id) AS pedidos_com_entrega,
    SUM(e.custo_frete) AS custo_total_frete,
    COUNT(CASE WHEN e.data_entrega_real > e.data_entrega_prevista THEN 1 END) AS entregas_atrasadas
    
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.cliente_id
LEFT JOIN entregas e ON p.pedido_id = e.pedido_id
WHERE p.status_pedido = 'Concluído'
GROUP BY 
    DATE_TRUNC('month', p.data_pedido),
    EXTRACT(YEAR FROM p.data_pedido),
    EXTRACT(QUARTER FROM p.data_pedido),
    c.segmento,
    c.estado,
    p.forma_pagamento,
    p.vendedor
ORDER BY mes DESC, receita_liquida DESC;

-- Query 10: Análise RFM (Recency, Frequency, Monetary) para Segmentação
-- Objetivo: Segmentar clientes para estratégias de marketing
WITH rfm_calc AS (
    SELECT 
        c.cliente_id,
        c.nome,
        c.email,
        c.segmento,
        CURRENT_DATE - MAX(p.data_pedido) AS recencia_dias,
        COUNT(p.pedido_id) AS frequencia,
        SUM(p.valor_total) AS valor_monetario
    FROM clientes c
    LEFT JOIN pedidos p ON c.cliente_id = p.cliente_id
    WHERE p.status_pedido = 'Concluído'
    GROUP BY c.cliente_id, c.nome, c.email, c.segmento
),
rfm_scores AS (
    SELECT 
        *,
        NTILE(5) OVER (ORDER BY recencia_dias) AS score_recencia,
        NTILE(5) OVER (ORDER BY frequencia DESC) AS score_frequencia,
        NTILE(5) OVER (ORDER BY valor_monetario DESC) AS score_monetario
    FROM rfm_calc
)
SELECT 
    cliente_id,
    nome,
    email,
    segmento,
    recencia_dias,
    frequencia,
    ROUND(valor_monetario, 2) AS valor_monetario,
    score_recencia,
    score_frequencia,
    score_monetario,
    (score_recencia + score_frequencia + score_monetario) AS rfm_score_total,
    CASE 
        WHEN score_recencia >= 4 AND score_frequencia >= 4 AND score_monetario >= 4 THEN 'Champions'
        WHEN score_recencia >= 3 AND score_frequencia >= 3 THEN 'Clientes Leais'
        WHEN score_recencia >= 4 AND score_frequencia <= 2 THEN 'Clientes Promissores'
        WHEN score_recencia <= 2 AND score_frequencia >= 3 THEN 'Precisa Atenção'
        WHEN score_recencia <= 2 AND score_frequencia <= 2 THEN 'Em Risco'
        ELSE 'Clientes Regulares'
    END AS segmento_rfm
FROM rfm_scores
ORDER BY rfm_score_total DESC;

-- =============================================
-- FIM DO ARQUIVO
-- Desenvolvido por: Evelyn Moura
-- Data: Dezembro 2024
-- Portfólio: Análise Avançada de Dados
-- =============================================