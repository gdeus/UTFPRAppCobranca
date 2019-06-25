-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: 25-Jun-2019 às 06:04
-- Versão do servidor: 10.1.38-MariaDB
-- versão do PHP: 7.3.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `banco_cobranca`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `divida`
--

CREATE TABLE `divida` (
  `id` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `id_compra` int(11) NOT NULL,
  `valor` double NOT NULL,
  `parcela` int(11) NOT NULL,
  `data_vcto` date NOT NULL,
  `pago` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `divida`
--

INSERT INTO `divida` (`id`, `id_user`, `id_compra`, `valor`, `parcela`, `data_vcto`, `pago`) VALUES
(1, 2, 2, 250, 1, '2019-01-10', 1),
(2, 2, 1, 250, 1, '2019-02-10', 1),
(3, 2, 1, 250, 3, '2019-03-10', 1),
(4, 2, 1, 250, 5, '2019-04-10', 1),
(5, 2, 1, 250, 6, '2019-05-10', 0),
(6, 2, 1, 250, 7, '2019-06-10', 0),
(7, 2, 3, 250, 7, '2019-07-10', 0),
(8, 3, 4, 130, 1, '2019-02-10', 1),
(9, 3, 4, 130, 2, '2019-03-10', 1),
(10, 3, 4, 130, 3, '2019-04-10', 1),
(11, 3, 4, 130, 4, '2019-05-10', 1),
(12, 3, 4, 130, 5, '2019-06-10', 1),
(13, 4, 5, 150, 1, '2019-03-25', 1),
(14, 4, 5, 150, 2, '2019-04-25', 1),
(15, 4, 5, 150, 3, '2019-05-25', 0),
(16, 4, 5, 150, 4, '2019-06-25', 0),
(17, 4, 5, 150, 5, '2019-07-25', 0),
(18, 4, 5, 150, 6, '2019-08-25', 0),
(19, 4, 5, 150, 7, '2019-09-25', 0),
(20, 5, 5, 200, 1, '2019-04-05', 1),
(21, 5, 5, 200, 2, '2019-05-05', 0),
(22, 5, 5, 200, 3, '2019-06-05', 0),
(23, 5, 5, 200, 4, '2019-07-05', 0),
(24, 5, 5, 200, 5, '2019-08-05', 0),
(25, 5, 5, 200, 6, '2019-09-05', 0),
(26, 8, 13, 450, 1, '2019-06-25', 0),
(27, 8, 13, 450, 2, '2019-07-25', 0);

-- --------------------------------------------------------

--
-- Estrutura da tabela `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `nome` text NOT NULL,
  `user` text NOT NULL,
  `senha` text NOT NULL,
  `tipo` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Extraindo dados da tabela `user`
--

INSERT INTO `user` (`id`, `nome`, `user`, `senha`, `tipo`) VALUES
(1, 'Administrador', 'admin', 'admin', 'loja'),
(2, 'Augusto', 'augusto', 'augusto', 'cliente'),
(3, 'Vitor', 'vitor', 'vitor', 'cliente'),
(4, 'Carmem Rosalina', 'carmem', 'carmem', 'cliente'),
(5, 'Leticia Ferreira', 'leticia', 'leticia', 'cliente'),
(6, 'Teste', 'teste', 'teste', 'cliente'),
(8, 'Marcos', 'marcos', 'marcos', 'cliente');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `divida`
--
ALTER TABLE `divida`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
