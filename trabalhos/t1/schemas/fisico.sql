CREATE TABLE usuario (
    email VARCHAR PRIMARY KEY,
    nome VARCHAR,
    foto TEXT,
    nivel INTEGER
);

CREATE TABLE modo (
    id INTEGER PRIMARY KEY,
    nome VARCHAR,
    timer INTEGER,
    multiplicador FLOAT
);

CREATE TABLE categoria (
    id INTEGER PRIMARY KEY,
    titulo VARCHAR,
    icone VARCHAR
);

CREATE TABLE partida (
    inicio TIMESTAMP,
    fim TIMESTAMP,
    pontos INTEGER,
    id INTEGER PRIMARY KEY,
    fk_modo_id INTEGER,
    FOREIGN KEY (fk_modo_id) REFERENCES modo(id)
);

CREATE TABLE pergunta (
    id INTEGER PRIMARY KEY
    texto TEXT,
    imagem TEXT,
    fk_categoria_id INTEGER,
    FOREIGN KEY (fk_categoria_id) REFERENCES categoria(id)
);

CREATE TABLE respostas (
    id INTEGER PRIMARY KEY,
    texto TEXT,
    imagem TEXT,
    correta BOOLEAN
);

CREATE TABLE categoria_partida (
    fk_categoria_id INTEGER,
    fk_partida_id INTEGER,
    FOREIGN KEY (fk_categoria_id) REFERENCES categoria(id),
    FOREIGN KEY (fk_partida_id) REFERENCES partida(id)
);

CREATE TABLE desafio (
    inicio TIMESTAMP,
    fk_partida_id INTEGER,
    FOREIGN KEY (fk_partida_id) REFERENCES partida(id)
);

CREATE TABLE ranking (
    id INTEGER PRIMARY KEY,
    titulo VARCHAR
);

CREATE TABLE follow (
    email_seguidor VARCHAR,
    email_seguido VARCHAR,
    FOREIGN KEY (email_seguidor) REFERENCES usuario(email),
    FOREIGN KEY (email_seguido) REFERENCES usuario(email)
);

CREATE TABLE participacao (
    fk_usuario_email VARCHAR,
    fk_partida_id INTEGER,
    FOREIGN KEY (fk_usuario_email) REFERENCES usuario(email),
    FOREIGN KEY (fk_partida_id) REFERENCES partida(id)
);

CREATE TABLE usuario_ranking (
    fk_ranking_id INTEGER,
    fk_usuario_email VARCHAR,
    FOREIGN KEY (fk_ranking_id) REFERENCES ranking(id),
    FOREIGN KEY (fk_usuario_email) REFERENCES usuario(email)
);