
USE red_cero_desperdicio;

CREATE TABLE Categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(150)
);

CREATE TABLE Conservacion (
    id_conservacion INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    temperatura VARCHAR(50) NOT NULL
);

CREATE TABLE Donante (
    id_donante INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(15),
    correo VARCHAR(100) UNIQUE,
    direccion VARCHAR(150),
    estatus BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE Almacen (
    id_almacen INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(150),
    capacidad DECIMAL(10,2) NOT NULL CHECK (capacidad >= 0),
    tipo_almacen VARCHAR(50)
);

CREATE TABLE EstadoProducto (
    id_estado_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(150)
);

CREATE TABLE TipoBeneficiario (
    id_tipo_beneficiario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(150)
);

CREATE TABLE Producto (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    id_categoria INT NOT NULL,
    id_conservacion INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    unidad_medida VARCHAR(20) NOT NULL,
    descripcion VARCHAR(150),
    CONSTRAINT fk_producto_categoria FOREIGN KEY (id_categoria) 
        REFERENCES Categoria(id_categoria) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_producto_conservacion FOREIGN KEY (id_conservacion) 
        REFERENCES Conservacion(id_conservacion) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Sucursal (
    id_sucursal INT AUTO_INCREMENT PRIMARY KEY,
    id_donante INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(150),
    ciudad VARCHAR(60),
    telefono VARCHAR(15),
    estatus BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_sucursal_donante FOREIGN KEY (id_donante) 
        REFERENCES Donante(id_donante) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Ubicacion (
    id_ubicacion INT AUTO_INCREMENT PRIMARY KEY,
    id_almacen INT NOT NULL,
    id_conservacion INT NOT NULL,
    codigo_ubicacion VARCHAR(20) NOT NULL,
    descripcion VARCHAR(100),
    capacidad DECIMAL(10,2) NOT NULL CHECK (capacidad >= 0),
    CONSTRAINT fk_ubicacion_almacen FOREIGN KEY (id_almacen) 
        REFERENCES Almacen(id_almacen) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_ubicacion_conservacion FOREIGN KEY (id_conservacion) 
        REFERENCES Conservacion(id_conservacion) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT unique_almacen_codigo UNIQUE (id_almacen, codigo_ubicacion)
);

CREATE TABLE Beneficiario (
    id_beneficiario INT AUTO_INCREMENT PRIMARY KEY,
    id_tipo_beneficiario INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(15),
    correo VARCHAR(100) UNIQUE,
    direccion VARCHAR(150),
    prioridad VARCHAR(20) NOT NULL DEFAULT 'Media',
    vigencia DATE NOT NULL,
    estatus BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_beneficiario_tipo FOREIGN KEY (id_tipo_beneficiario) 
        REFERENCES TipoBeneficiario(id_tipo_beneficiario) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Donacion (
    id_donacion INT AUTO_INCREMENT PRIMARY KEY,
    id_sucursal INT NOT NULL,
    fecha DATE NOT NULL,
    responsable VARCHAR(80) NOT NULL,
    observaciones TEXT,
    estatus VARCHAR(20) NOT NULL DEFAULT 'Recibida',
    CONSTRAINT fk_donacion_sucursal FOREIGN KEY (id_sucursal) 
        REFERENCES Sucursal(id_sucursal) ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE TABLE Solicitud (
    id_solicitud INT AUTO_INCREMENT PRIMARY KEY,
    id_beneficiario INT NOT NULL,
    fecha DATE NOT NULL,
    necesidad TEXT,
    estatus VARCHAR(20) NOT NULL DEFAULT 'Pendiente',
    CONSTRAINT fk_solicitud_beneficiario FOREIGN KEY (id_beneficiario) 
        REFERENCES Beneficiario(id_beneficiario) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Lote (
    id_lote INT AUTO_INCREMENT PRIMARY KEY,
    id_donacion INT NOT NULL,
    id_producto INT NOT NULL,
    id_ubicacion INT,
    codigo_lote VARCHAR(50) NOT NULL UNIQUE,
    fecha_recepcion DATE NOT NULL,
    fecha_caducidad DATE NOT NULL,
    cantidad_recibida DECIMAL(10,2) NOT NULL,
    cantidad_disponible DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_lote_donacion FOREIGN KEY (id_donacion) 
        REFERENCES Donacion(id_donacion) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_lote_producto FOREIGN KEY (id_producto) 
        REFERENCES Producto(id_producto) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_lote_ubicacion FOREIGN KEY (id_ubicacion) 
        REFERENCES Ubicacion(id_ubicacion) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_lote_fechas CHECK (fecha_caducidad >= fecha_recepcion),
    CONSTRAINT chk_lote_cant_recibida CHECK (cantidad_recibida > 0),
    CONSTRAINT chk_lote_cant_disponible CHECK (cantidad_disponible >= 0 AND cantidad_disponible <= cantidad_recibida)
);

CREATE TABLE Inspeccion (
    id_inspeccion INT AUTO_INCREMENT PRIMARY KEY,
    id_lote INT NOT NULL,
    id_estado_producto INT NOT NULL,
    fecha_inspeccion DATE NOT NULL,
    inspector VARCHAR(80) NOT NULL,
    motivo_rechazo TEXT,
    observaciones TEXT,
    CONSTRAINT fk_inspeccion_lote FOREIGN KEY (id_lote) 
        REFERENCES Lote(id_lote) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_inspeccion_estado FOREIGN KEY (id_estado_producto) 
        REFERENCES EstadoProducto(id_estado_producto) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE Entrega (
    id_entrega INT AUTO_INCREMENT PRIMARY KEY,
    id_solicitud INT NOT NULL,
    fecha DATE NOT NULL,
    responsable VARCHAR(80) NOT NULL,
    observaciones TEXT,
    CONSTRAINT fk_entrega_solicitud FOREIGN KEY (id_solicitud) 
        REFERENCES Solicitud(id_solicitud) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE DetalleEntrega (
    id_detalle_entrega INT AUTO_INCREMENT PRIMARY KEY,
    id_entrega INT NOT NULL,
    id_lote INT NOT NULL,
    cantidad DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_detalle_entrega FOREIGN KEY (id_entrega) 
        REFERENCES Entrega(id_entrega) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_detalle_lote FOREIGN KEY (id_lote) 
        REFERENCES Lote(id_lote) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_detalle_entrega_cantidad CHECK (cantidad > 0)
);