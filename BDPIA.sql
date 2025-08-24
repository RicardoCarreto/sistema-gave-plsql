CREATE TABLE Estacion (
    idEstacion NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    ubicacion VARCHAR2(150),
    capacidadMaxima NUMBER NOT NULL
);

CREATE TABLE Vehiculo (
    idVehiculo NUMBER PRIMARY KEY,
    tipo VARCHAR2(20) CHECK (tipo IN ('bicicleta', 'scooter')),
    modelo VARCHAR2(100),
    estado VARCHAR2(20) CHECK (estado IN ('disponible', 'en mantenimiento', 'alquilado')),
    idEstacion NUMBER,
    CONSTRAINT fk_vehiculo_estacion FOREIGN KEY (idEstacion) REFERENCES Estacion(idEstacion)
);

CREATE TABLE Cliente (
    idCliente NUMBER PRIMARY KEY,
    nombre VARCHAR2(100),
    correo VARCHAR2(100),
    telefono VARCHAR2(20),
    idTarjeta NUMBER
);

CREATE TABLE TarjetaCredito (
    idTarjeta NUMBER PRIMARY KEY,
    numeroTarjeta VARCHAR2(20) UNIQUE,
    fechaExpiracion DATE,
    titular VARCHAR2(100)
);

CREATE TABLE Alquiler (
    idAlquiler NUMBER PRIMARY KEY,
    idCliente NUMBER,
    idVehiculo NUMBER,
    fechaInicio DATE NOT NULL,
    fechaFin DATE,
    tipoCobro VARCHAR2(10) CHECK (tipoCobro IN ('hora', 'dia')),
    precio NUMBER,
    CONSTRAINT fk_alquiler_cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente),
    CONSTRAINT fk_alquiler_vehiculo FOREIGN KEY (idVehiculo) REFERENCES Vehiculo(idVehiculo)
);

CREATE TABLE Pago (
    idPago NUMBER PRIMARY KEY,
    idAlquiler NUMBER,
    monto NUMBER,
    fechaPago DATE DEFAULT SYSDATE,
    metodoPago VARCHAR2(30),
    CONSTRAINT fk_pago_alquiler FOREIGN KEY (idAlquiler) REFERENCES Alquiler(idAlquiler)
);


--------------------------------------------------------------------------------
-- INSERCION DE DATOS (ESTACIONES, VEHICULOS, TARJETAS, ALQUILERES, PAGOS)
--------------------------------------------------------------------------------

-- Insertar Estaciones
INSERT INTO Estacion (idEstacion, nombre, ubicacion, capacidadMaxima) VALUES (1, 'Estacion Centro', 'Av. Principal 123', 20);
INSERT INTO Estacion (idEstacion, nombre, ubicacion, capacidadMaxima) VALUES (2, 'Estacion Norte', 'Calle Reforma 456', 15);

-- Insertar Vehiculos
INSERT INTO Vehiculo (idVehiculo, tipo, modelo, estado, idEstacion) VALUES (1, 'bicicleta', 'BMX Pro', 'disponible', 1);
INSERT INTO Vehiculo (idVehiculo, tipo, modelo, estado, idEstacion) VALUES (2, 'scooter', 'Scooter X', 'disponible', 1);
INSERT INTO Vehiculo (idVehiculo, tipo, modelo, estado, idEstacion) VALUES (3, 'bicicleta', 'Mountain Ride', 'alquilado', 2);

-- Insertar Tarjetas de Crédito
INSERT INTO TarjetaCredito (idTarjeta, numeroTarjeta, fechaExpiracion, titular)
VALUES (100, '1234567890123456', TO_DATE('2026-12-31','YYYY-MM-DD'), 'Juan Perez');

INSERT INTO TarjetaCredito (idTarjeta, numeroTarjeta, fechaExpiracion, titular)
VALUES (101, '9876543210987654', TO_DATE('2027-06-30','YYYY-MM-DD'), 'Maria Lopez');

-- Insertar Alquileres
INSERT INTO Alquiler (idAlquiler, idCliente, idVehiculo, fechaInicio, fechaFin, tipoCobro, precio)
VALUES (1, 1, 1, TO_DATE('2024-01-15','YYYY-MM-DD'), TO_DATE('2024-01-16','YYYY-MM-DD'), 'hora', 50);

INSERT INTO Alquiler (idAlquiler, idCliente, idVehiculo, fechaInicio, fechaFin, tipoCobro, precio)
VALUES (2, 2, 2, TO_DATE('2024-02-10','YYYY-MM-DD'), TO_DATE('2024-02-11','YYYY-MM-DD'), 'dia', 100);

-- Insertar Pagos
INSERT INTO Pago (idPago, idAlquiler, monto, fechaPago, metodoPago)
VALUES (1, 1, 50, SYSDATE, 'Tarjeta');

INSERT INTO Pago (idPago, idAlquiler, monto, fechaPago, metodoPago)
VALUES (2, 2, 100, SYSDATE, 'Tarjeta');