-- ============================================================
-- SkyTrip – Migration Script
-- Ejecutar en la base de datos MySQL/MariaDB de Railway
-- ============================================================

-- 1. Columna saldo en usuarios (5000 € por defecto)
ALTER TABLE usuarios
    ADD COLUMN IF NOT EXISTS saldo DECIMAL(10,2) NOT NULL DEFAULT 5000.00;

-- Actualizar usuarios existentes que no tengan saldo
UPDATE usuarios SET saldo = 5000.00 WHERE saldo IS NULL OR saldo = 0;

-- 2. Columnas TOTP en usuarios
ALTER TABLE usuarios
    ADD COLUMN IF NOT EXISTS totp_secret VARCHAR(64) DEFAULT NULL;

ALTER TABLE usuarios
    ADD COLUMN IF NOT EXISTS totp_enabled TINYINT(1) NOT NULL DEFAULT 0;

-- 3. Asegurar que habitaciones usa la columna 'activo' (algunos DBs usan 'disponible')
ALTER TABLE habitaciones
    ADD COLUMN IF NOT EXISTS activo TINYINT(1) NOT NULL DEFAULT 1;

-- Si existe columna 'disponible', copiar sus valores a 'activo'
SET @col_exists = (
    SELECT COUNT(*) FROM information_schema.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'habitaciones'
    AND COLUMN_NAME = 'disponible'
);
SET @sql = IF(@col_exists > 0,
    'UPDATE habitaciones SET activo = disponible WHERE activo != disponible',
    'SELECT 1'
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 4. Tabla de mensajes de contacto
CREATE TABLE IF NOT EXISTS mensajes_contacto (
    id_mensaje  INT          AUTO_INCREMENT PRIMARY KEY,
    nombre      VARCHAR(100) NOT NULL,
    email       VARCHAR(100) NOT NULL,
    asunto      VARCHAR(200) NOT NULL,
    mensaje     TEXT         NOT NULL,
    leido       TINYINT(1)   NOT NULL DEFAULT 0,
    fecha       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. Tabla de canales de contacto
CREATE TABLE IF NOT EXISTS canales_contacto (
    id       INT          AUTO_INCREMENT PRIMARY KEY,
    tipo     VARCHAR(50)  NOT NULL,
    etiqueta VARCHAR(100) NOT NULL,
    valor    VARCHAR(300) NOT NULL,
    activo   TINYINT(1)   NOT NULL DEFAULT 1,
    orden    INT          NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Insertar canales por defecto solo si la tabla está vacía
INSERT INTO canales_contacto (tipo, etiqueta, valor, activo, orden)
SELECT * FROM (
    SELECT 'whatsapp'  AS tipo, 'WhatsApp'           AS etiqueta, 'https://wa.me/34600000000'       AS valor, 1 AS activo, 1 AS orden UNION ALL
    SELECT 'email',             'Correo electrónico',              'mailto:soporte@skytrip.com',      1, 2        UNION ALL
    SELECT 'telefono',          'Teléfono',                        'tel:+34900000000',                1, 3
) AS defaults
WHERE NOT EXISTS (SELECT 1 FROM canales_contacto LIMIT 1);

-- 6. Tabla CMS (almacena JSON del panel de administración)
CREATE TABLE IF NOT EXISTS cms_contenido (
    id         TINYINT UNSIGNED NOT NULL DEFAULT 1 PRIMARY KEY,
    datos      LONGTEXT         NOT NULL,
    updated_at TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 7. Tabla para el carrusel de inicio
CREATE TABLE IF NOT EXISTS home_carrusel (
    id        INT         AUTO_INCREMENT PRIMARY KEY,
    seccion   VARCHAR(32) NOT NULL,
    id_hotel  INT         NOT NULL,
    posicion  INT         NOT NULL DEFAULT 0,
    UNIQUE KEY uq_carrusel (seccion, id_hotel),
    KEY       idx_seccion (seccion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8. Índice útil en usuarios para búsquedas por usuario/email
ALTER TABLE usuarios
    ADD INDEX IF NOT EXISTS idx_usuario (usuario),
    ADD INDEX IF NOT EXISTS idx_email   (email);
