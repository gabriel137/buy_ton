CREATE TABLE contas (
    id SERIAL PRIMARY KEY,
    numero_agencia VARCHAR(10) NOT NULL,
    numero_conta VARCHAR(15) NOT NULL,
    CONSTRAINT unique_conta UNIQUE (numero_agencia, numero_conta)
);

-- Considerando consultas constantes pelo número da conta
CREATE INDEX index_numero_conta ON contas (numero_conta);

CREATE TABLE transacoes (
    id SERIAL PRIMARY KEY,
    tipo_de_documento VARCHAR(20) NOT NULL,
    id_conta_origem INT,
    numero_agencia_destino VARCHAR(10), 
    numero_conta_destino VARCHAR(15), 
    documento_destino VARCHAR(20),
    valor DECIMAL(10, 2) NOT NULL,
    data_transacao TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_conta_id FOREIGN KEY (id_conta_origem) REFERENCES contas (id)
);

-- Considerando que possam ser campos muito acionados em futuras consultas.
CREATE INDEX index_data_transacao ON transacoes (data_transacao);
CREATE INDEX index_id_conta_origem ON transacoes (id_conta_origem);
CREATE INDEX index_id_conta_destino ON transacoes (numero_conta_destino);
CREATE INDEX index_id_agencia_destino ON transacoes (numero_agencia_destino);

-- Dado o agrupamento do mês, irá otimizar a consulta de transações.
CREATE INDEX index_data_transacao ON transacoes (data_transacao);

WITH pagamentos_boleto AS (
    SELECT
        id,
        tipo_de_documento,
        valor,
        data_transacao
    FROM
        transacoes
    WHERE
        tipo_de_documento = 'boleto'
)
SELECT
    DATE_TRUNC('month', data_transacao) AS mes,
    SUM(valor) AS total_pagamentos_boleto
FROM
    pagamentos_boleto
WHERE
    EXTRACT(YEAR FROM data_transacao) = EXTRACT(YEAR FROM CURRENT_TIMESTAMP)
GROUP BY
    mes
ORDER BY
    mes;


-- Dados para testar
INSERT INTO contas (numero_agencia, numero_conta)
VALUES
    ('1234', '567890'),
    ('5678', '123456'),
    ('9012', '345678');


INSERT INTO transacoes (tipo, id_conta_origem, numero_agencia_destino, numero_conta_destino, documento_destino, valor, data_transacao)
VALUES
    ('boleto', 1, 1456, 12345, 005155, 150.00, '2023-08-05 10:00:00'),
    ('boleto', 2, 6587, 96587, 005478, 200.00, '2023-08-10 15:30:00'),
    ('deposito', 3, 1020, 65485, 054123, 1000.00, '2023-08-12 08:45:00'),
    ('saque', 1, 2358, 23487, 154786, 50.00, '2023-08-15 11:20:00'),
    ('transferencia', 2, '4321', '987654', '123456789', 300.00, '2023-08-20 14:00:00');
