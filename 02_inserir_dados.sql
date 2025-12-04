-- Inserir clientes
INSERT INTO clientes (nome, email, telefone, cidade, estado, segmento, data_cadastro, status) VALUES
('Tech Solutions LTDA', 'contato@techsol.com', '11987654321', 'São Paulo', 'SP', 'Tecnologia', '2024-01-15', 'Ativo'),
('Comercial Almeida', 'vendas@almeida.com', '11876543210', 'Rio de Janeiro', 'RJ', 'Varejo', '2024-02-20', 'Ativo'),
('Indústria XYZ', 'compras@xyz.com', '11765432109', 'Curitiba', 'PR', 'Indústria', '2024-03-10', 'Ativo'),
('Consultoria ABC', 'abc@consultoria.com', '11654321098', 'Belo Horizonte', 'MG', 'Serviços', '2024-01-25', 'Ativo'),
('Distribuidora Norte', 'norte@dist.com', '11543210987', 'Manaus', 'AM', 'Distribuição', '2024-04-05', 'Inativo'),
('Logística Sul', 'sul@logistica.com', '51987654321', 'Porto Alegre', 'RS', 'Logística', '2024-02-15', 'Ativo'),
('Farmácia Central', 'central@farmacia.com', '11987651234', 'São Paulo', 'SP', 'Saúde', '2024-03-20', 'Ativo'),
('Educacional Smart', 'contato@smart.edu', '11876541234', 'Campinas', 'SP', 'Educação', '2024-01-30', 'Ativo'),
('Agro Campo Verde', 'campo@agro.com', '65987654321', 'Cuiabá', 'MT', 'Agronegócio', '2024-04-12', 'Ativo'),
('Construtora Forte', 'forte@const.com', '11765431234', 'São Paulo', 'SP', 'Construção', '2024-02-08', 'Ativo');

-- Inserir pedidos
INSERT INTO pedidos (cliente_id, data_pedido, valor_total, desconto, status_pedido, forma_pagamento, vendedor) VALUES
(1, '2024-05-01', 15000.00, 750.00, 'Concluído', 'Boleto', 'João Silva'),
(1, '2024-06-15', 8500.00, 0.00, 'Concluído', 'Cartão', 'João Silva'),
(2, '2024-05-10', 3200.00, 160.00, 'Concluído', 'PIX', 'Maria Santos'),
(3, '2024-05-20', 45000.00, 4500.00, 'Concluído', 'Boleto', 'Carlos Lima'),
(4, '2024-06-01', 12000.00, 600.00, 'Concluído', 'Transferência', 'João Silva'),
(5, '2024-05-05', 7800.00, 0.00, 'Cancelado', 'Boleto', 'Ana Costa'),
(6, '2024-06-20', 22000.00, 2200.00, 'Concluído', 'Boleto', 'Maria Santos'),
(7, '2024-05-15', 5400.00, 270.00, 'Concluído', 'PIX', 'Carlos Lima'),
(8, '2024-06-10', 9800.00, 0.00, 'Em Processamento', 'Cartão', 'Ana Costa'),
(9, '2024-05-25', 31000.00, 3100.00, 'Concluído', 'Boleto', 'João Silva'),
(10, '2024-06-05', 18500.00, 925.00, 'Concluído', 'Transferência', 'Maria Santos'),
(1, '2024-07-01', 11000.00, 0.00, 'Em Processamento', 'PIX', 'João Silva'),
(2, '2024-06-25', 4200.00, 210.00, 'Concluído', 'Cartão', 'Maria Santos'),
(3, '2024-07-10', 38000.00, 3800.00, 'Concluído', 'Boleto', 'Carlos Lima'),
(7, '2024-07-05', 6700.00, 335.00, 'Concluído', 'PIX', 'Carlos Lima');

-- Inserir entregas
INSERT INTO entregas (pedido_id, data_envio, data_entrega_prevista, data_entrega_real, status_entrega, transportadora, custo_frete) VALUES
(1, '2024-05-02', '2024-05-10', '2024-05-09', 'Entregue', 'Transportadora Rápida', 450.00),
(2, '2024-06-16', '2024-06-23', '2024-06-25', 'Entregue com Atraso', 'Logística Express', 320.00),
(3, '2024-05-11', '2024-05-18', '2024-05-17', 'Entregue', 'Transportadora Rápida', 280.00),
(4, '2024-05-21', '2024-05-30', '2024-05-28', 'Entregue', 'Cargo Master', 780.00),
(5, '2024-06-02', '2024-06-10', '2024-06-09', 'Entregue', 'Logística Express', 450.00),
(7, '2024-06-21', '2024-06-28', '2024-06-27', 'Entregue', 'Transportadora Rápida', 650.00),
(8, '2024-05-16', '2024-05-23', '2024-05-22', 'Entregue', 'Cargo Master', 380.00),
(10, '2024-05-26', '2024-06-05', '2024-06-10', 'Entregue com Atraso', 'Logística Express', 890.00),
(11, '2024-06-06', '2024-06-15', '2024-06-14', 'Entregue', 'Transportadora Rápida', 520.00),
(13, '2024-06-26', '2024-07-03', '2024-07-02', 'Entregue', 'Cargo Master', 350.00),
(14, '2024-07-11', '2024-07-20', NULL, 'Em Trânsito', 'Logística Express', 720.00),
(15, '2024-07-06', '2024-07-15', '2024-07-14', 'Entregue', 'Transportadora Rápida', 480.00);

-- Inserir métricas diárias
INSERT INTO metricas_diarias (data_referencia, visitas_site, conversoes, ticket_medio, taxa_conversao) VALUES
('2024-05-01', 1250, 45, 8500.00, 3.60),
('2024-05-02', 1180, 38, 7200.00, 3.22),
('2024-05-03', 1420, 52, 9100.00, 3.66),
('2024-05-04', 980, 31, 6800.00, 3.16),
('2024-05-05', 1350, 47, 8300.00, 3.48),
('2024-06-01', 1580, 61, 9800.00, 3.86),
('2024-06-02', 1290, 44, 7900.00, 3.41),
('2024-06-03', 1670, 68, 10200.00, 4.07),
('2024-06-04', 1120, 35, 7100.00, 3.12),
('2024-06-05', 1450, 53, 8700.00, 3.65);