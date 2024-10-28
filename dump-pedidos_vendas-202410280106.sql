-- MySQL dump 10.13  Distrib 5.5.62, for Win64 (AMD64)
--
-- Host: localhost    Database: pedidos_vendas
-- ------------------------------------------------------
-- Server version	8.0.23

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clientes` (
  `codigo` int NOT NULL,
  `nome` varchar(100) DEFAULT NULL,
  `cidade` varchar(100) DEFAULT NULL,
  `uf` char(2) DEFAULT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'João Silva','São Paulo','SP'),(2,'Maria Oliveira','Rio de Janeiro','RJ'),(3,'Pedro Santos','Belo Horizonte','MG'),(4,'Ana Costa','Curitiba','PR'),(5,'Carlos Pereira','Porto Alegre','RS'),(6,'Mariana Almeida','Salvador','BA'),(7,'José Fernandes','Fortaleza','CE'),(8,'Paula Souza','Recife','PE'),(9,'Lucas Rodrigues','Florianópolis','SC'),(10,'Fernanda Gomes','Brasília','DF'),(11,'Ricardo Lima','Manaus','AM'),(12,'Camila Barbosa','Belém','PA'),(13,'André Ribeiro','Goiânia','GO'),(14,'Juliana Pinto','Maceió','AL'),(15,'Bruno Martins','Natal','RN'),(16,'Isabela Dias','João Pessoa','PB'),(17,'Roberto Carvalho','Campo Grande','MS'),(18,'Larissa Araújo','Vitória','ES'),(19,'Thiago Cardoso','São Luís','MA'),(20,'Gabriela Batista','Teresina','PI'),(21,'Felipe Teixeira','Aracaju','SE'),(22,'Vanessa Mendes','Macapá','AP'),(23,'Eduardo Nunes','Palmas','TO'),(24,'Patrícia Freitas','Boa Vista','RR'),(25,'Renato Lopes','Rio Branco','AC'),(26,'Aline Correia','Porto Velho','RO'),(27,'Diego Monteiro','Cuiabá','MT'),(28,'Sabrina Rocha','São Paulo','SP'),(29,'Leonardo Castro','Rio de Janeiro','RJ'),(30,'Elaine Sousa','Curitiba','PR');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidoprodutos`
--

DROP TABLE IF EXISTS `pedidoprodutos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pedidoprodutos` (
  `autoinc` int NOT NULL AUTO_INCREMENT,
  `numeropedido` int DEFAULT NULL,
  `codigoproduto` int DEFAULT NULL,
  `quantidade` int DEFAULT NULL,
  `valorunitario` decimal(10,2) DEFAULT NULL,
  `valortotal` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`autoinc`),
  KEY `idx_NumeroPedido` (`numeropedido`),
  CONSTRAINT `pedidoprodutos_ibfk_1` FOREIGN KEY (`numeropedido`) REFERENCES `pedidos` (`numeropedido`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidoprodutos`
--

LOCK TABLES `pedidoprodutos` WRITE;
/*!40000 ALTER TABLE `pedidoprodutos` DISABLE KEYS */;
/*!40000 ALTER TABLE `pedidoprodutos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos`
--

DROP TABLE IF EXISTS `pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pedidos` (
  `numeropedido` int NOT NULL,
  `dataemissao` datetime DEFAULT NULL,
  `codigocliente` int DEFAULT NULL,
  `valortotal` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`numeropedido`),
  KEY `codigocliente` (`codigocliente`),
  CONSTRAINT `pedidos_ibfk_1` FOREIGN KEY (`codigocliente`) REFERENCES `clientes` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos`
--

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produtos`
--

DROP TABLE IF EXISTS `produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `produtos` (
  `codigo` int NOT NULL,
  `descricao` varchar(100) DEFAULT NULL,
  `precovenda` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtos`
--

LOCK TABLES `produtos` WRITE;
/*!40000 ALTER TABLE `produtos` DISABLE KEYS */;
INSERT INTO `produtos` VALUES (1,'Caneta Esferográfica',1.50),(2,'Lápis HB',0.75),(3,'Caderno Universitário',12.90),(4,'Borracha',0.50),(5,'Apontador',1.20),(6,'Marcador de Texto',3.80),(7,'Estojo Escolar',9.50),(8,'Mochila',59.90),(9,'Agenda 2024',15.00),(10,'Bloco de Notas',2.00),(11,'Grampeador',7.25),(12,'Tesoura Escolar',4.30),(13,'Cola Branca',2.50),(14,'Régua 30cm',1.80),(15,'Transferidor',2.00),(16,'Compasso',3.50),(17,'Papel Sulfite A4 (500 folhas)',22.00),(18,'Cartolina',1.00),(19,'Pincel Atômico',2.75),(20,'Corretivo Líquido',3.20),(21,'Canetinha Hidrocor',5.50),(22,'Pasta Plástica',2.10),(23,'Clips (caixa com 100)',1.50),(24,'Envelope A4',0.80),(25,'Etiqueta Adesiva',4.00),(26,'Calculadora Simples',15.90),(27,'Dicionário Português',18.00),(28,'Papel Crepom',0.90),(29,'Papelão Paraná',2.50),(30,'Giz de Cera',6.00);
/*!40000 ALTER TABLE `produtos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'pedidos_vendas'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-28  1:06:05
