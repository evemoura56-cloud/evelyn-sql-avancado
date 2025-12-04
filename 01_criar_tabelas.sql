-- =============================================
-- EVELYN PRO - SISTEMA DE ANALYTICS CORPORATIVO
-- Banco de Dados para Análise Avançada
-- =============================================

-- Tabela de Clientes
CREATE TABLE IF NOT EXISTS clientes (
    cliente_id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    telefone VARCHAR(20),
    cidade VARCHAR(50),
    estado VARCHAR(2),
    segmento VARCHAR(50),
    data_cadastro DATE,
    status VARCHAR(20)
);

-- Tabela de Pedidos
CREATE TABLE IF NOT EXISTS pedidos (
    pedido_id SERIAL PRIMARY KEY,
    cliente_id INTEGER REFERENCES clientes(cliente_id),
    data_pedido DATE NOT NULL,
    valor_total DECIMAL(10,2),
    desconto DECIMAL(10,2),
    status_pedido VARCHAR(30),
    forma_pagamento VARCHAR(30),
    vendedor VARCHAR(50)
);

-- Tabela de Entregas
CREATE TABLE IF NOT EXISTS entregas (
    entrega_id SERIAL PRIMARY KEY,
    pedido_id INTEGER REFERENCES pedidos(pedido_id),
    data_envio DATE,
    data_entrega_prevista DATE,
    data_entrega_real DATE,
    status_entrega VARCHAR(30),
    transportadora VARCHAR(50),
    custo_frete DECIMAL(10,2)
);

-- Tabela de Métricas Diárias
CREATE TABLE IF NOT EXISTS metricas_diarias (
    metrica_id SERIAL PRIMARY KEY,
    data_referencia DATE NOT NULL,
    visitas_site INTEGER,
    conversoes INTEGER,
    ticket_medio DECIMAL(10,2),
    taxa_conversao DECIMAL(5,2)
);