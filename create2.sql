-- Tabela Pais
DROP TABLE IF EXISTS Pais;
CREATE TABLE Pais
(
    idPais VARCHAR(2),
    Nome VARCHAR(20) NOT NULL,
    Estatuto VARCHAR(2) 
        CHECK (Estatuto IN (‘C’, ‘E’, ‘BF’))
        DEFAULT ‘E’,
    UNIQUE (Nome),
    PRIMARY KEY (idPais)
);



-- Tabela Apresentador
DROP TABLE IF EXISTS Apresentador;
CREATE TABLE Apresentador
(
    idApresentador NUMERIC(2,0),
    Nome VARCHAR(30) NOT NULL,
    PRIMARY KEY (idApresentador)
);



-- Tabela Evento
DROP TABLE IF EXISTS Evento;
CREATE TABLE Evento
(
    idEvento NUMERIC(2,0),
    Ano NUMERIC(4,0)
        CHECK (Ano >= 2011 AND Ano <= 2023),
    Tema VARCHAR(20),
    UNIQUE (Ano),
    PRIMARY KEY (idEvento)

);



-- Tabela Prova
DROP TABLE IF EXISTS Prova;
CREATE TABLE Prova
(
    idProva NUMERIC(2,0),
    idEvento NUMERIC(2,0),
    Tipo VARCHAR(3) 
        CHECK (Tipo IN (‘1SF’, ‘2SF’, ‘F’)),
    DataP DATE,
    FOREIGN KEY (idEvento) REFERENCES Evento(idEvento) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    PRIMARY KEY (idProva)
);



-- Tabela Cancao
DROP TABLE IF EXISTS Cancao;
CREATE TABLE Cancao
(
    idCancao NUMERIC(3,0),
    idEvento NUMERIC(2,0),
    Titulo VARCHAR(50) NOT NULL,
    Letrista VARCHAR(30),
    Compositor VARCHAR(30),
    Estilo VARCHAR(30),
    Duração TIME,
    FOREIGN KEY (idEvento) REFERENCES Evento(idEvento) 
        ON DELETE SET NULL 
        ON UPDATE CASCADE,
    PRIMARY KEY (idCancao)
);



-- Tabela Cantor
DROP TABLE IF EXISTS Cantor;
CREATE TABLE Cantor
(
    idCantor NUMERIC(3,0),
    idPais VARCHAR(2),
    idCancao NUMERIC(3,0),
    Nome VARCHAR(50) NOT NULL,
    Sexo VARCHAR(1) 
        CHECK (Sexo IN (‘M’, ‘F’)),
    DataNascimento DATE,
    FOREIGN KEY (idPais) REFERENCES Pais(idPais)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (idCancao) REFERENCES Cancao(idCancao)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    PRIMARY KEY (idCantor)
);



-- Tabela Votos
DROP TABLE IF EXISTS Votos;
CREATE TABLE Votos
(
    idVotos NUMERIC(5,0),
    idPaisVotante VARCHAR(2),
    idPaisVotado VARCHAR(2),
    idProva NUMERIC(2,0),
    Tipo VARCHAR(1) 
        CHECK (Tipo IN (‘J’, ‘P’)),
    Pontos NUMERIC(2,0) 
        CHECK ((Pontos >= 1 AND Pontos <= 8) OR Pontos = 10 OR Pontos  = 12),
    CHECK (idPaisVotante <> idPaisVotado),
    UNIQUE (idProva, idPaisVotante, Tipo, Pontos),
    UNIQUE (idProva, idPaisVotante, idPaisVotado, Tipo),
    FOREIGN KEY (idPaisVotante) REFERENCES Pais(idPais)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (idPaisVotado) REFERENCES Pais(idPais)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (idProva) REFERENCES Prova(idProva)
        ON DELETE CASCADE
        ON UPDATE CASCADE, 
    PRIMARY KEY (idVotos)
);



-- Tabela Idioma
DROP TABLE IF EXISTS Idioma;
CREATE TABLE Idioma
(
    idIdioma NUMERIC(2,0),
    Idioma VARCHAR(30) NOT NULL,
    UNIQUE (Idioma),
    PRIMARY KEY (idIdioma)
);



-- Tabela IdiomaFalado
DROP TABLE IF EXISTS IdiomaFalado;
CREATE TABLE IdiomaFalado
(
    idPais VARCHAR(2),
    idIdioma NUMERIC(2,0),
    FOREIGN KEY (idPais) REFERENCES Pais(idPais)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (idIdioma) REFERENCES Idioma(idIdioma)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    PRIMARY KEY (idIdioma, idPais)
);



-- Tabela IdiomaCantado
DROP TABLE IF EXISTS IdiomaCantado;
CREATE TABLE IdiomaCantado
(
    idCancao NUMERIC(3,0),
    idIdioma NUMERIC(2,0),
    FOREIGN KEY (idCancao) REFERENCES Cancao(idCancao)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (idIdioma) REFERENCES Idioma(idIdioma)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    PRIMARY KEY (idIdioma, idCancao)
);



-- Tabela Realizacao
DROP TABLE IF EXISTS Realizacao;
CREATE TABLE Realizacao
(
    idEvento NUMERIC(2,0),
    idPais VARCHAR(2),
    CanalTransmissor VARCHAR(5), 
    LocalR VARCHAR(50),
    FOREIGN KEY (idEvento) REFERENCES Evento(idEvento)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (idPais) REFERENCES Pais(idPais)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    PRIMARY KEY (idEvento)
);



-- Tabela Apresentacao
DROP TABLE IF EXISTS Apresentacao;
CREATE TABLE Apresentacao
(
    idEvento NUMERIC(2,0),
    idApresentador NUMERIC(2,0),
    FOREIGN KEY (idEvento) REFERENCES Evento(idEvento)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (idApresentador) REFERENCES Apresentador(idApresentador)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    PRIMARY KEY (idEvento, idApresentador)
);



-- Tabela CantoresDoEvento
DROP TABLE IF EXISTS CantoresDoEvento;
CREATE TABLE CantoresDoEvento
(
    idEvento NUMERIC(2,0),
    idCantor NUMERIC(3,0),
    FOREIGN KEY (idEvento) REFERENCES Evento(idEvento)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (idCantor) REFERENCES Cantor(idCantor)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    PRIMARY KEY (idEvento, idCantor)
);



-- Tabela PontuacaoPaisesEmProva
DROP TABLE IF EXISTS PontuacaoPaisesEmProva;
CREATE TABLE PontuacaoPaisesEmProva
(
    idProva NUMERIC(2,0),
    idPais VARCHAR(2),
    TotalDePontos NUMERIC(3,0),
    Classificacao NUMERIC(2,0),
    Aprovado BOOLEAN NOT NULL,
    UNIQUE (idProva, Classificacao),
    FOREIGN KEY (idProva) REFERENCES Prova(idProva)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (idPais) REFERENCES Pais(idPais)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    PRIMARY KEY (idProva, idPais)
);