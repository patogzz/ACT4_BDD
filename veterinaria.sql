-- Base de datos en la cual haremos los procedimientos
-- PASO 1: CREAR LA BASE DE DATOS
CREATE DATABASE IF NOT EXISTS veterinaria;
USE veterinaria;

-- PASO 2: CREAR TABLA PROPIETARIOS

CREATE TABLE propietarios (
    id_propietario INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    telefono VARCHAR(15),
    email VARCHAR(100),
    direccion TEXT,
    fecha_registro DATE DEFAULT (CURRENT_DATE)
);

-- PASO 3: CREAR TABLA MASCOTAS
CREATE TABLE mascotas (
    id_mascota INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    especie VARCHAR(30) NOT NULL,
    raza VARCHAR(50),
    edad INT,
    peso DECIMAL(5,2),
    color VARCHAR(30),
    id_propietario INT NOT NULL,
    fecha_registro DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (id_propietario) REFERENCES propietarios(id_propietario)
);

-- PASO 4: CREAR TABLA VETERINARIOS
CREATE TABLE veterinarios (
    id_veterinario INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    cedula_profesional VARCHAR(20) UNIQUE,
    especialidad VARCHAR(100),
    telefono VARCHAR(15),
    email VARCHAR(100)
);

-- PASO 5: CREAR TABLA CITAS
CREATE TABLE citas (
    id_cita INT PRIMARY KEY AUTO_INCREMENT,
    fecha_cita DATE NOT NULL,
    hora_cita TIME NOT NULL,
    motivo TEXT,
    estado VARCHAR(20) DEFAULT 'Programada',
    id_mascota INT NOT NULL,
    id_veterinario INT NOT NULL,
    FOREIGN KEY (id_mascota) REFERENCES mascotas(id_mascota),
    FOREIGN KEY (id_veterinario) REFERENCES veterinarios(id_veterinario)
);

-- PASO 6: CREAR TABLA TRATAMIENTOS
CREATE TABLE tratamientos (
    id_tratamiento INT PRIMARY KEY AUTO_INCREMENT,
    nombre_tratamiento VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2),
    duracion_minutos INT
);

-- PASO 7: CREAR TABLA HISTORIAL MÉDICO
CREATE TABLE historial_medico (
    id_historial INT PRIMARY KEY AUTO_INCREMENT,
    fecha_consulta DATE NOT NULL,
    diagnostico TEXT,
    observaciones TEXT,
    peso_actual DECIMAL(5,2),
    temperatura DECIMAL(4,1),
    id_mascota INT NOT NULL,
    id_veterinario INT NOT NULL,
    id_tratamiento INT,
    FOREIGN KEY (id_mascota) REFERENCES mascotas(id_mascota),
    FOREIGN KEY (id_veterinario) REFERENCES veterinarios(id_veterinario),
    FOREIGN KEY (id_tratamiento) REFERENCES tratamientos(id_tratamiento)
);

-- PASO 8: INSERTAR DATOS DE EJEMPLO
INSERT INTO propietarios (nombre, apellido, telefono, email, direccion) VALUES
('Juan', 'Pérez', '555-1234', 'juan.perez@email.com', 'Av. Principal 123'),
('María', 'González', '555-5678', 'maria.gonzalez@email.com', 'Calle Secundaria 456'),
('Carlos', 'López', '555-9012', 'carlos.lopez@email.com', 'Colonia Centro 789');

INSERT INTO veterinarios (nombre, apellido, cedula_profesional, especialidad, telefono, email) VALUES
('Dr. Ana', 'Martínez', 'VET001', 'Medicina General', '555-1111', 'ana.martinez@vet.com'),
('Dr. Luis', 'Rodríguez', 'VET002', 'Cirugía', '555-2222', 'luis.rodriguez@vet.com');

INSERT INTO mascotas (nombre, especie, raza, edad, peso, color, id_propietario) VALUES
('Max', 'Perro', 'Labrador', 3, 25.5, 'Dorado', 1),
('Luna', 'Gato', 'Siamés', 2, 4.2, 'Blanco', 1),
('Rocky', 'Perro', 'Bulldog', 5, 18.0, 'Marrón', 2),
('Mimi', 'Gato', 'Persa', 1, 3.8, 'Gris', 3);

INSERT INTO tratamientos (nombre_tratamiento, descripcion, precio, duracion_minutos) VALUES
('Consulta General', 'Revisión médica completa', 300.00, 30),
('Vacunación', 'Aplicación de vacunas', 150.00, 15),
('Desparasitación', 'Tratamiento antiparasitario', 200.00, 20),
('Cirugía Menor', 'Procedimientos quirúrgicos menores', 800.00, 60);

-- Veamos la información de las tablas: pk, fk, columnas

DESCRIBE propietarios;

DESCRIBE mascotas;

DESCRIBE veterinarios;

DESCRIBE citas;

DESCRIBE tratamientos;

-- Ahora veamos los datos o info de las tablas
SELECT * FROM propietarios;

SELECT * FROM mascotas;

SELECT * FROM veterinarios;

SELECT * FROM tratamientos;