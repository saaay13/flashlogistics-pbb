-- ============================================
-- FlashLogistics DSS - Esquema de Base de Datos
-- Motor: MySQL
-- ============================================

CREATE DATABASE IF NOT EXISTS flashlogistics_dss
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;

USE flashlogistics_dss;

-- --------------------------------------------
-- Tabla: Persona
-- --------------------------------------------
CREATE TABLE Persona (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    activo BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB;

-- --------------------------------------------
-- Tabla: Rol
-- --------------------------------------------
CREATE TABLE Rol (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(200),
    activo BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB;

-- --------------------------------------------
-- Tabla: Cliente (hereda de Persona)
-- --------------------------------------------
CREATE TABLE Cliente (
    id INT PRIMARY KEY,
    direccion VARCHAR(200) NOT NULL,
    FOREIGN KEY (id) REFERENCES Persona(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- --------------------------------------------
-- Tabla: Conductor (hereda de Persona)
-- --------------------------------------------
CREATE TABLE Conductor (
    id INT PRIMARY KEY,
    licencia VARCHAR(30) NOT NULL UNIQUE,
    estado VARCHAR(20) DEFAULT 'disponible',
    FOREIGN KEY (id) REFERENCES Persona(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- --------------------------------------------
-- Tabla: Usuario
-- --------------------------------------------
CREATE TABLE Usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    contrasena_hash VARCHAR(255) NOT NULL,
    ultimo_acceso DATETIME,
    activo BOOLEAN DEFAULT TRUE,
    persona_id INT,
    rol_id INT NOT NULL,
    FOREIGN KEY (persona_id) REFERENCES Persona(id) ON DELETE SET NULL,
    FOREIGN KEY (rol_id) REFERENCES Rol(id)
) ENGINE=InnoDB;

-- --------------------------------------------
-- Tabla: Pedido
-- --------------------------------------------
CREATE TABLE Pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL,
    direccion_entrega VARCHAR(200) NOT NULL,
    producto VARCHAR(100) NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    estado VARCHAR(20) DEFAULT 'pendiente',
    fecha_entrega_estimada DATETIME,
    fecha_entrega_real DATETIME,
    activo BOOLEAN DEFAULT TRUE,
    cliente_id INT NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES Cliente(id)
) ENGINE=InnoDB;

-- --------------------------------------------
-- Tabla: Vehiculo
-- --------------------------------------------
CREATE TABLE Vehiculo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    placa VARCHAR(20) NOT NULL UNIQUE,
    marca VARCHAR(50) NOT NULL,
    capacidad DECIMAL(10,2) NOT NULL CHECK (capacidad > 0),
    estado VARCHAR(20) DEFAULT 'disponible',
    activo BOOLEAN DEFAULT TRUE,
    conductor_id INT,
    FOREIGN KEY (conductor_id) REFERENCES Conductor(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- --------------------------------------------
-- Tabla: Ruta
-- --------------------------------------------
CREATE TABLE Ruta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    origen VARCHAR(200) NOT NULL,
    destino VARCHAR(200) NOT NULL,
    distancia_km DECIMAL(10,2) NOT NULL CHECK (distancia_km > 0),
    costo_estimado DECIMAL(10,2) NOT NULL CHECK (costo_estimado > 0),
    costo_real DECIMAL(10,2),
    tiempo_estimado INT NOT NULL CHECK (tiempo_estimado > 0),
    tiempo_real INT,
    activo BOOLEAN DEFAULT TRUE,
    pedido_id INT NOT NULL UNIQUE,
    conductor_id INT,
    FOREIGN KEY (pedido_id) REFERENCES Pedido(id),
    FOREIGN KEY (conductor_id) REFERENCES Conductor(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- --------------------------------------------
-- Tabla: UbicacionGPS
-- --------------------------------------------
CREATE TABLE UbicacionGPS (
    id INT AUTO_INCREMENT PRIMARY KEY,
    latitud DECIMAL(10,8) NOT NULL,
    longitud DECIMAL(11,8) NOT NULL,
    timestamp DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ruta_id INT,
    FOREIGN KEY (ruta_id) REFERENCES Ruta(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- --------------------------------------------
-- Tabla: Entrega
-- --------------------------------------------
CREATE TABLE Entrega (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) DEFAULT 'pendiente',
    firma VARCHAR(200),
    pedido_id INT,
    FOREIGN KEY (pedido_id) REFERENCES Pedido(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- --------------------------------------------
-- Tabla: ConsumoCombustible
-- --------------------------------------------
CREATE TABLE ConsumoCombustible (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cantidad DECIMAL(10,2) NOT NULL CHECK (cantidad > 0),
    fecha DATE NOT NULL,
    costo DECIMAL(10,2) NOT NULL CHECK (costo > 0),
    vehiculo_id INT NOT NULL,
    FOREIGN KEY (vehiculo_id) REFERENCES Vehiculo(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- --------------------------------------------
-- Tabla: Notificacion
-- --------------------------------------------
CREATE TABLE Notificacion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    destinatario VARCHAR(100) NOT NULL,
    mensaje TEXT NOT NULL,
    tipo VARCHAR(30) NOT NULL,
    fecha_envio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ruta_id INT,
    FOREIGN KEY (ruta_id) REFERENCES Ruta(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- --------------------------------------------
-- Tabla: Reporte
-- --------------------------------------------
CREATE TABLE Reporte (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha_generacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo VARCHAR(50) NOT NULL,
    indicadores TEXT
) ENGINE=InnoDB;
