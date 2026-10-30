-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 24-08-2026 a las 15:59:44
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `lenguaje_señas`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `logs_detecciones`
--

CREATE TABLE `logs_detecciones` (
  `id_log` int(11) NOT NULL,
  `id_sesion` int(11) NOT NULL,
  `letra_detectada` varchar(5) NOT NULL,
  `confianza` decimal(5,2) NOT NULL,
  `fecha_deteccion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `modelos`
--

CREATE TABLE `modelos` (
  `id_modelo` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `nombre_modelo` varchar(100) DEFAULT 'modelo_senas',
  `archivo_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`archivo_json`)),
  `es_activo` tinyint(1) DEFAULT 0,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `muestras_senas`
--

CREATE TABLE `muestras_senas` (
  `id_muestra` int(11) NOT NULL,
  `id_modelo` int(11) NOT NULL,
  `etiqueta_letra` varchar(5) NOT NULL,
  `vector_landmarks` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`vector_landmarks`)),
  `fecha_captura` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sesiones_traduccion`
--

CREATE TABLE `sesiones_traduccion` (
  `id_sesion` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `id_modelo_usado` int(11) DEFAULT NULL,
  `texto_acumulado` text DEFAULT NULL,
  `fecha_inicio` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `logs_detecciones`
--
ALTER TABLE `logs_detecciones`
  ADD PRIMARY KEY (`id_log`),
  ADD KEY `id_sesion` (`id_sesion`);

--
-- Indices de la tabla `modelos`
--
ALTER TABLE `modelos`
  ADD PRIMARY KEY (`id_modelo`),
  ADD KEY `id_usuario` (`id_usuario`);

--
-- Indices de la tabla `muestras_senas`
--
ALTER TABLE `muestras_senas`
  ADD PRIMARY KEY (`id_muestra`),
  ADD KEY `id_modelo` (`id_modelo`);

--
-- Indices de la tabla `sesiones_traduccion`
--
ALTER TABLE `sesiones_traduccion`
  ADD PRIMARY KEY (`id_sesion`),
  ADD KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_modelo_usado` (`id_modelo_usado`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `logs_detecciones`
--
ALTER TABLE `logs_detecciones`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `modelos`
--
ALTER TABLE `modelos`
  MODIFY `id_modelo` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `muestras_senas`
--
ALTER TABLE `muestras_senas`
  MODIFY `id_muestra` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `sesiones_traduccion`
--
ALTER TABLE `sesiones_traduccion`
  MODIFY `id_sesion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `logs_detecciones`
--
ALTER TABLE `logs_detecciones`
  ADD CONSTRAINT `logs_detecciones_ibfk_1` FOREIGN KEY (`id_sesion`) REFERENCES `sesiones_traduccion` (`id_sesion`) ON DELETE CASCADE;

--
-- Filtros para la tabla `modelos`
--
ALTER TABLE `modelos`
  ADD CONSTRAINT `modelos_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE;

--
-- Filtros para la tabla `muestras_senas`
--
ALTER TABLE `muestras_senas`
  ADD CONSTRAINT `muestras_senas_ibfk_1` FOREIGN KEY (`id_modelo`) REFERENCES `modelos` (`id_modelo`) ON DELETE CASCADE;

--
-- Filtros para la tabla `sesiones_traduccion`
--
ALTER TABLE `sesiones_traduccion`
  ADD CONSTRAINT `sesiones_traduccion_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE,
  ADD CONSTRAINT `sesiones_traduccion_ibfk_2` FOREIGN KEY (`id_modelo_usado`) REFERENCES `modelos` (`id_modelo`) ON DELETE SET NULL;
COMMIT;

-- 1. Crear un usuario de prueba con ID 1
INSERT INTO `usuarios` (`id_usuario`, `nombre`, `email`, `password_hash`) 
VALUES (1, 'Admin', 'admin@mail.com', '123456');

-- 2. Crear un modelo de prueba con ID 1 asignado a ese usuario
INSERT INTO `modelos` (`id_modelo`, `id_usuario`, `nombre_modelo`, `archivo_json`, `es_activo`) 
VALUES (1, 1, 'Modelo Inicial', '{}', 1);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
