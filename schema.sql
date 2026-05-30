-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: skytrip_db
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ciudades`
--

DROP TABLE IF EXISTS `ciudades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ciudades` (
  `id_ciudad` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `id_pais` int(11) NOT NULL,
  PRIMARY KEY (`id_ciudad`),
  UNIQUE KEY `uq_ciudad_pais` (`nombre`,`id_pais`),
  KEY `idx_ciudades_pais` (`id_pais`),
  CONSTRAINT `fk_ciudades_pais` FOREIGN KEY (`id_pais`) REFERENCES `paises` (`id_pais`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Ciudades ligadas a un país';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cms_contenido`
--

DROP TABLE IF EXISTS `cms_contenido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_contenido` (
  `id` tinyint(3) unsigned NOT NULL DEFAULT 1,
  `datos` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`datos`)),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cms_filtros`
--

DROP TABLE IF EXISTS `cms_filtros`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_filtros` (
  `id_filtro` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `id_servicio` int(11) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `orden` tinyint(4) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id_filtro`),
  KEY `idx_filtros_servicio` (`id_servicio`),
  CONSTRAINT `fk_filtros_servicio` FOREIGN KEY (`id_servicio`) REFERENCES `servicios` (`id_servicio`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Filtros rápidos configurables en pantalla de búsqueda';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cms_home_config`
--

DROP TABLE IF EXISTS `cms_home_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_home_config` (
  `clave` varchar(100) NOT NULL,
  `valor` varchar(255) NOT NULL,
  `tipo` enum('bool','string','int') NOT NULL DEFAULT 'string',
  PRIMARY KEY (`clave`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Toggles de secciones de la pantalla Home';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cms_paginas`
--

DROP TABLE IF EXISTS `cms_paginas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_paginas` (
  `id_pagina` int(11) NOT NULL AUTO_INCREMENT,
  `clave` varchar(100) NOT NULL COMMENT 'ej: condiciones, destinos, atencion',
  `titulo` varchar(200) NOT NULL,
  `contenido` longtext DEFAULT NULL,
  `orden` tinyint(4) NOT NULL DEFAULT 0,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_pagina`),
  UNIQUE KEY `uq_cms_paginas_clave` (`clave`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Páginas dinámicas del CMS';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cms_secciones`
--

DROP TABLE IF EXISTS `cms_secciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cms_secciones` (
  `id_seccion` int(11) NOT NULL AUTO_INCREMENT,
  `id_pagina` int(11) NOT NULL,
  `titulo` varchar(200) NOT NULL,
  `contenido` text DEFAULT NULL,
  `orden` tinyint(4) NOT NULL DEFAULT 0,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_seccion`),
  KEY `idx_cmss_pagina` (`id_pagina`),
  CONSTRAINT `fk_cmss_pagina` FOREIGN KEY (`id_pagina`) REFERENCES `cms_paginas` (`id_pagina`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Sub-secciones de páginas CMS';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contacto_canales`
--

DROP TABLE IF EXISTS `contacto_canales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contacto_canales` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tipo` varchar(50) NOT NULL,
  `etiqueta` varchar(100) NOT NULL,
  `valor` varchar(255) NOT NULL,
  `icono` varchar(100) NOT NULL DEFAULT '',
  `posicion` int(11) NOT NULL DEFAULT 0,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  KEY `idx_posicion` (`posicion`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `favoritos_destinos`
--

DROP TABLE IF EXISTS `favoritos_destinos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `favoritos_destinos` (
  `id_usuario` int(11) NOT NULL,
  `id_pais` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_usuario`,`id_pais`),
  KEY `idx_favd_pais` (`id_pais`),
  CONSTRAINT `fk_favd_pais` FOREIGN KEY (`id_pais`) REFERENCES `paises` (`id_pais`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_favd_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Países favoritos por usuario';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `favoritos_hoteles`
--

DROP TABLE IF EXISTS `favoritos_hoteles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `favoritos_hoteles` (
  `id_usuario` int(11) NOT NULL,
  `id_hotel` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_usuario`,`id_hotel`),
  KEY `idx_favh_hotel` (`id_hotel`),
  CONSTRAINT `fk_favh_hotel` FOREIGN KEY (`id_hotel`) REFERENCES `hoteles` (`id_hotel`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_favh_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Hoteles marcados como favoritos por usuario';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `habitaciones`
--

DROP TABLE IF EXISTS `habitaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `habitaciones` (
  `id_habitacion` int(11) NOT NULL AUTO_INCREMENT,
  `id_hotel` int(11) NOT NULL,
  `tipo_habitacion` varchar(100) NOT NULL,
  `capacidad` int(11) NOT NULL,
  `precio_noche` decimal(10,2) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_habitacion`),
  KEY `idx_habitaciones_hotel` (`id_hotel`),
  CONSTRAINT `fk_habitaciones_hotel` FOREIGN KEY (`id_hotel`) REFERENCES `hoteles` (`id_hotel`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=361 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Tipos de habitación por hotel';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `home_carrusel`
--

DROP TABLE IF EXISTS `home_carrusel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `home_carrusel` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `seccion` varchar(32) NOT NULL,
  `id_hotel` int(11) NOT NULL,
  `posicion` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_seccion_hotel` (`seccion`,`id_hotel`),
  KEY `idx_seccion` (`seccion`),
  KEY `hc_fk_hotel` (`id_hotel`),
  CONSTRAINT `hc_fk_hotel` FOREIGN KEY (`id_hotel`) REFERENCES `hoteles` (`id_hotel`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hotel_imagenes`
--

DROP TABLE IF EXISTS `hotel_imagenes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hotel_imagenes` (
  `id_imagen` int(11) NOT NULL AUTO_INCREMENT,
  `id_hotel` int(11) NOT NULL,
  `url` varchar(500) NOT NULL,
  `orden` tinyint(4) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_imagen`),
  KEY `idx_himagenes_hotel` (`id_hotel`),
  CONSTRAINT `fk_himagenes_hotel` FOREIGN KEY (`id_hotel`) REFERENCES `hoteles` (`id_hotel`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=182 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Galería de imágenes por hotel';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hotel_servicios`
--

DROP TABLE IF EXISTS `hotel_servicios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hotel_servicios` (
  `id_hotel` int(11) NOT NULL,
  `id_servicio` int(11) NOT NULL,
  PRIMARY KEY (`id_hotel`,`id_servicio`),
  KEY `idx_hserv_servicio` (`id_servicio`),
  CONSTRAINT `fk_hserv_hotel` FOREIGN KEY (`id_hotel`) REFERENCES `hoteles` (`id_hotel`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_hserv_servicio` FOREIGN KEY (`id_servicio`) REFERENCES `servicios` (`id_servicio`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Relación N:M hotel – servicio';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hoteles`
--

DROP TABLE IF EXISTS `hoteles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hoteles` (
  `id_hotel` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) NOT NULL,
  `biografia` text DEFAULT NULL,
  `id_ciudad` int(11) NOT NULL,
  `precio_noche` decimal(10,2) NOT NULL,
  `puntuacion` decimal(3,1) NOT NULL DEFAULT 0.0 COMMENT '0.0 – 10.0, recalculado por trigger',
  `estrellas` tinyint(4) NOT NULL DEFAULT 3,
  `capacidad_personas` int(11) NOT NULL DEFAULT 2,
  `distancia_centro_km` decimal(5,2) DEFAULT NULL,
  `distancia_aeropuerto_km` decimal(5,2) DEFAULT NULL,
  `latitud` decimal(10,7) DEFAULT NULL,
  `longitud` decimal(10,7) DEFAULT NULL,
  `imagen` varchar(500) DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_hotel`),
  KEY `idx_hoteles_ciudad` (`id_ciudad`),
  KEY `idx_hoteles_precio` (`precio_noche`),
  KEY `idx_hoteles_puntuacion` (`puntuacion`),
  KEY `idx_hoteles_estrellas` (`estrellas`),
  CONSTRAINT `fk_hoteles_ciudad` FOREIGN KEY (`id_ciudad`) REFERENCES `ciudades` (`id_ciudad`) ON UPDATE CASCADE,
  CONSTRAINT `chk_estrellas` CHECK (`estrellas` between 1 and 5),
  CONSTRAINT `chk_puntuacion_hotel` CHECK (`puntuacion` between 0.0 and 10.0)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Hoteles con datos geográficos y de negocio';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `idiomas`
--

DROP TABLE IF EXISTS `idiomas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `idiomas` (
  `codigo` char(2) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Idiomas soportados por la app';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `monedas`
--

DROP TABLE IF EXISTS `monedas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `monedas` (
  `codigo` char(3) NOT NULL,
  `simbolo` varchar(5) NOT NULL,
  `tasa_cambio` decimal(12,6) NOT NULL COMMENT 'Relativa a EUR como base',
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Divisas disponibles en el selector de moneda';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `paises`
--

DROP TABLE IF EXISTS `paises`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `paises` (
  `id_pais` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `codigo_iso` char(2) DEFAULT NULL COMMENT 'ISO 3166-1 alpha-2',
  PRIMARY KEY (`id_pais`),
  UNIQUE KEY `uq_paises_nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Catálogo de países';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `recently_viewed`
--

DROP TABLE IF EXISTS `recently_viewed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recently_viewed` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_usuario` int(11) NOT NULL,
  `id_hotel` int(11) NOT NULL,
  `visto_en` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_rv_usuario_fecha` (`id_usuario`,`visto_en`),
  KEY `idx_rv_hotel` (`id_hotel`),
  CONSTRAINT `fk_rv_hotel` FOREIGN KEY (`id_hotel`) REFERENCES `hoteles` (`id_hotel`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_rv_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Últimos 8 hoteles vistos por usuario (límite a nivel app)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reservas`
--

DROP TABLE IF EXISTS `reservas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reservas` (
  `id_reserva` int(11) NOT NULL AUTO_INCREMENT,
  `id_usuario` int(11) NOT NULL,
  `id_hotel` int(11) NOT NULL,
  `id_habitacion` int(11) DEFAULT NULL,
  `nombre_huesped` varchar(150) NOT NULL,
  `dni` varchar(20) NOT NULL,
  `telefono` varchar(20) NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `adultos` int(11) NOT NULL DEFAULT 1,
  `bebes` int(11) NOT NULL DEFAULT 0,
  `necesita_cuna` tinyint(1) NOT NULL DEFAULT 0,
  `con_desayuno` tinyint(1) NOT NULL DEFAULT 0,
  `es_reembolsable` tinyint(1) NOT NULL DEFAULT 1,
  `total_precio` decimal(10,2) NOT NULL,
  `estado` enum('confirmada','cancelada','completada') NOT NULL DEFAULT 'confirmada',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_reserva`),
  KEY `idx_reservas_usuario` (`id_usuario`),
  KEY `idx_reservas_hotel` (`id_hotel`),
  KEY `idx_reservas_fecha_inicio` (`fecha_inicio`),
  KEY `idx_reservas_fecha_fin` (`fecha_fin`),
  KEY `idx_reservas_estado` (`estado`),
  KEY `fk_reservas_habitacion` (`id_habitacion`),
  CONSTRAINT `fk_reservas_habitacion` FOREIGN KEY (`id_habitacion`) REFERENCES `habitaciones` (`id_habitacion`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_reservas_hotel` FOREIGN KEY (`id_hotel`) REFERENCES `hoteles` (`id_hotel`) ON UPDATE CASCADE,
  CONSTRAINT `fk_reservas_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON UPDATE CASCADE,
  CONSTRAINT `chk_fechas_reserva` CHECK (`fecha_fin` > `fecha_inicio`),
  CONSTRAINT `chk_adultos_min` CHECK (`adultos` >= 1)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Reservas de habitaciones por usuario';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `reviews` (
  `id_review` int(11) NOT NULL AUTO_INCREMENT,
  `id_hotel` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `puntuacion` decimal(2,1) NOT NULL COMMENT '0.5 – 5.0 estrellas',
  `comentario` text DEFAULT NULL,
  `fecha` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id_review`),
  UNIQUE KEY `uq_review_hotel_usuario` (`id_hotel`,`id_usuario`),
  KEY `idx_reviews_hotel` (`id_hotel`),
  KEY `idx_reviews_usuario` (`id_usuario`),
  CONSTRAINT `fk_reviews_hotel` FOREIGN KEY (`id_hotel`) REFERENCES `hoteles` (`id_hotel`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_reviews_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_puntuacion_review` CHECK (`puntuacion` between 0.5 and 5.0)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Reseñas: un usuario solo puede reseñar un hotel una vez';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_after_insert_review`
AFTER INSERT ON `reviews`
FOR EACH ROW
BEGIN
    CALL sp_actualizar_puntuacion_hotel(NEW.id_hotel);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_after_update_review`
AFTER UPDATE ON `reviews`
FOR EACH ROW
BEGIN
    CALL sp_actualizar_puntuacion_hotel(NEW.id_hotel);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_after_delete_review`
AFTER DELETE ON `reviews`
FOR EACH ROW
BEGIN
    CALL sp_actualizar_puntuacion_hotel(OLD.id_hotel);
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `servicios`
--

DROP TABLE IF EXISTS `servicios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `servicios` (
  `id_servicio` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `icono` varchar(100) DEFAULT NULL COMMENT 'Nombre del icono en la app Flutter',
  `activo` tinyint(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_servicio`),
  UNIQUE KEY `uq_servicios_nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Catálogo de 22 amenidades / servicios';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL AUTO_INCREMENT,
  `usuario` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL COMMENT 'Hash bcrypt',
  `rol` enum('admin','usuario') NOT NULL DEFAULT 'usuario',
  `direccion` varchar(255) DEFAULT NULL,
  `pais_nacimiento` varchar(100) DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `notifications_enabled` tinyint(1) NOT NULL DEFAULT 1,
  `totp_secret` varchar(64) DEFAULT NULL COMMENT 'Secreto TOTP Base32 para 2FA',
  `totp_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `token` varchar(512) DEFAULT NULL COMMENT 'Bearer JWT activo',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `uq_usuarios_usuario` (`usuario`),
  UNIQUE KEY `uq_usuarios_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Usuarios de la app (admin y normales)';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_before_delete_usuario`
BEFORE DELETE ON `usuarios`
FOR EACH ROW
BEGIN
    DECLARE v_count INT DEFAULT 0;

    SELECT COUNT(*) INTO v_count
    FROM   reservas
    WHERE  id_usuario = OLD.id_usuario
      AND  estado     = 'confirmada'
      AND  fecha_fin  >= CURDATE();

    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No se puede eliminar un usuario con reservas activas.';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary table structure for view `v_estadisticas_hotel`
--

DROP TABLE IF EXISTS `v_estadisticas_hotel`;
/*!50001 DROP VIEW IF EXISTS `v_estadisticas_hotel`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_estadisticas_hotel` AS SELECT
 1 AS `id_hotel`,
  1 AS `hotel`,
  1 AS `total_reservas`,
  1 AS `ingresos_totales`,
  1 AS `media_puntuacion`,
  1 AS `total_reviews`,
  1 AS `total_favoritos` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_hoteles_completos`
--

DROP TABLE IF EXISTS `v_hoteles_completos`;
/*!50001 DROP VIEW IF EXISTS `v_hoteles_completos`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_hoteles_completos` AS SELECT
 1 AS `id_hotel`,
  1 AS `hotel`,
  1 AS `estrellas`,
  1 AS `puntuacion`,
  1 AS `precio_noche`,
  1 AS `capacidad_personas`,
  1 AS `distancia_centro_km`,
  1 AS `distancia_aeropuerto_km`,
  1 AS `imagen`,
  1 AS `biografia`,
  1 AS `activo`,
  1 AS `id_ciudad`,
  1 AS `ciudad`,
  1 AS `id_pais`,
  1 AS `pais`,
  1 AS `codigo_iso`,
  1 AS `media_reviews`,
  1 AS `total_reviews`,
  1 AS `servicios` */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `v_reservas_activas`
--

DROP TABLE IF EXISTS `v_reservas_activas`;
/*!50001 DROP VIEW IF EXISTS `v_reservas_activas`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `v_reservas_activas` AS SELECT
 1 AS `id_reserva`,
  1 AS `id_usuario`,
  1 AS `id_hotel`,
  1 AS `id_habitacion`,
  1 AS `nombre_huesped`,
  1 AS `dni`,
  1 AS `telefono`,
  1 AS `fecha_inicio`,
  1 AS `fecha_fin`,
  1 AS `adultos`,
  1 AS `bebes`,
  1 AS `necesita_cuna`,
  1 AS `con_desayuno`,
  1 AS `es_reembolsable`,
  1 AS `total_precio`,
  1 AS `estado`,
  1 AS `created_at`,
  1 AS `updated_at`,
  1 AS `usuario`,
  1 AS `email`,
  1 AS `hotel`,
  1 AS `ciudad`,
  1 AS `pais` */;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `v_estadisticas_hotel`
--

/*!50001 DROP VIEW IF EXISTS `v_estadisticas_hotel`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_estadisticas_hotel` AS select `h`.`id_hotel` AS `id_hotel`,`h`.`nombre` AS `hotel`,count(distinct `res`.`id_reserva`) AS `total_reservas`,ifnull(sum(`res`.`total_precio`),0) AS `ingresos_totales`,round(avg(`rv`.`puntuacion`),2) AS `media_puntuacion`,count(distinct `rv`.`id_review`) AS `total_reviews`,count(distinct `fav`.`id_usuario`) AS `total_favoritos` from (((`hoteles` `h` left join `reservas` `res` on(`res`.`id_hotel` = `h`.`id_hotel`)) left join `reviews` `rv` on(`rv`.`id_hotel` = `h`.`id_hotel`)) left join `favoritos_hoteles` `fav` on(`fav`.`id_hotel` = `h`.`id_hotel`)) group by `h`.`id_hotel`,`h`.`nombre` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_hoteles_completos`
--

/*!50001 DROP VIEW IF EXISTS `v_hoteles_completos`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_hoteles_completos` AS select `h`.`id_hotel` AS `id_hotel`,`h`.`nombre` AS `hotel`,`h`.`estrellas` AS `estrellas`,`h`.`puntuacion` AS `puntuacion`,`h`.`precio_noche` AS `precio_noche`,`h`.`capacidad_personas` AS `capacidad_personas`,`h`.`distancia_centro_km` AS `distancia_centro_km`,`h`.`distancia_aeropuerto_km` AS `distancia_aeropuerto_km`,`h`.`imagen` AS `imagen`,`h`.`biografia` AS `biografia`,`h`.`activo` AS `activo`,`c`.`id_ciudad` AS `id_ciudad`,`c`.`nombre` AS `ciudad`,`p`.`id_pais` AS `id_pais`,`p`.`nombre` AS `pais`,`p`.`codigo_iso` AS `codigo_iso`,round(avg(`r`.`puntuacion`),2) AS `media_reviews`,count(distinct `r`.`id_review`) AS `total_reviews`,group_concat(distinct `s`.`nombre` order by `s`.`nombre` ASC separator ', ') AS `servicios` from (((((`hoteles` `h` join `ciudades` `c` on(`c`.`id_ciudad` = `h`.`id_ciudad`)) join `paises` `p` on(`p`.`id_pais` = `c`.`id_pais`)) left join `reviews` `r` on(`r`.`id_hotel` = `h`.`id_hotel`)) left join `hotel_servicios` `hs` on(`hs`.`id_hotel` = `h`.`id_hotel`)) left join `servicios` `s` on(`s`.`id_servicio` = `hs`.`id_servicio`)) group by `h`.`id_hotel`,`h`.`nombre`,`h`.`estrellas`,`h`.`puntuacion`,`h`.`precio_noche`,`h`.`capacidad_personas`,`h`.`distancia_centro_km`,`h`.`distancia_aeropuerto_km`,`h`.`imagen`,`h`.`biografia`,`h`.`activo`,`c`.`id_ciudad`,`c`.`nombre`,`p`.`id_pais`,`p`.`nombre`,`p`.`codigo_iso` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_reservas_activas`
--

/*!50001 DROP VIEW IF EXISTS `v_reservas_activas`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_reservas_activas` AS select `r`.`id_reserva` AS `id_reserva`,`r`.`id_usuario` AS `id_usuario`,`r`.`id_hotel` AS `id_hotel`,`r`.`id_habitacion` AS `id_habitacion`,`r`.`nombre_huesped` AS `nombre_huesped`,`r`.`dni` AS `dni`,`r`.`telefono` AS `telefono`,`r`.`fecha_inicio` AS `fecha_inicio`,`r`.`fecha_fin` AS `fecha_fin`,`r`.`adultos` AS `adultos`,`r`.`bebes` AS `bebes`,`r`.`necesita_cuna` AS `necesita_cuna`,`r`.`con_desayuno` AS `con_desayuno`,`r`.`es_reembolsable` AS `es_reembolsable`,`r`.`total_precio` AS `total_precio`,`r`.`estado` AS `estado`,`r`.`created_at` AS `created_at`,`r`.`updated_at` AS `updated_at`,`u`.`usuario` AS `usuario`,`u`.`email` AS `email`,`h`.`nombre` AS `hotel`,`c`.`nombre` AS `ciudad`,`p`.`nombre` AS `pais` from ((((`reservas` `r` join `usuarios` `u` on(`u`.`id_usuario` = `r`.`id_usuario`)) join `hoteles` `h` on(`h`.`id_hotel` = `r`.`id_hotel`)) join `ciudades` `c` on(`c`.`id_ciudad` = `h`.`id_ciudad`)) join `paises` `p` on(`p`.`id_pais` = `c`.`id_pais`)) where `r`.`estado` = 'confirmada' and `r`.`fecha_fin` >= curdate() */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-30 16:41:20
