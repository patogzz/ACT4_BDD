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

-- Paso 1: CREA EL PROCEDIMIENTO
DELIMITER //
CREATE PROCEDURE mostrar_todas_mascotas()
BEGIN
	SELECT 
		m.id_mascota as 'ID Mascota',
		m.nombre as 'Nombre Mascota',
		m.especie as 'Especie',
		m.raza as 'Raza',
		m.edad as 'Edad',
		m.peso as 'Peso (kg)',
		CONCAT(p.nombre, ' ', p.apellido) as 'Propietario',
		p.telefono as 'Teléfono Propietario'
	FROM mascotas m
	INNER JOIN propietarios p ON m.id_propietario = p.id_propietario
	ORDER BY m.nombre;
END //
DELIMITER ;

-- Paso 1: Crear el procedimiento con IN
DELIMITER //
CREATE PROCEDURE buscar_mascota_por_id(IN p_id INT)
BEGIN
-- Validar que el ID sea válido
IF p_id <= 0 THEN
SELECT 'Error: El ID debe ser mayor a 0' as Mensaje;
ELSE
-- Buscar la mascota por ID
SELECT 
id_mascota as 'ID',
nombre as 'Nombre',
especie as 'Especie',
raza as 'Raza',
edad as 'Edad años',
peso as 'Peso kg'
FROM mascotas 
WHERE id_mascota = p_id;
END IF;
END //
DELIMITER ;

-- Buscar mascota con ID 1
CALL buscar_mascota_por_id(1);

-- Probar con ID inválido (debe mostrar error)
CALL buscar_mascota_por_id(0);

-- Paso 1: CREAR EL PROCEDIMIENTO CON OUT
DELIMITER //
CREATE PROCEDURE contar_mascotas(OUT p_total INT)
BEGIN
-- Contar todas las mascotas y guardar en p_total
SELECT COUNT(*) INTO p_total
FROM mascotas;
END //
DELIMITER ;

-- Declaramos una variable para recibir el resultado
SET @resultado_de_contar_mascotas = 0;
-- Ejecutamos el procedimiento
CALL contar_mascotas(@resultado_de_contar_mascotas);
-- Ver el resultado
SELECT @resultado_de_contar_mascotas as 'Total de Mascotas';

DELIMITER //
CREATE PROCEDURE actualizar_peso_mascota(IN p_id INT, INOUT p_peso DECIMAL(5,2))
BEGIN
DECLARE peso_anterior DECIMAL(5,2) DEFAULT 0;
DECLARE mascota_existe INT DEFAULT 0;
-- 1. Verificamos si la mascota existe
SELECT COUNT(*) INTO mascota_existe 
FROM mascotas 
WHERE id_mascota = p_id;
IF mascota_existe = 0 THEN
SET p_peso = -1; -- Error: mascota no encontrada
ELSE
-- 2. Buscamos el peso actual antes de cambiarlo
SELECT peso INTO peso_anterior 
FROM mascotas 
WHERE id_mascota = p_id;
-- 3. Actualizamos el campo 'peso' en la tabla 'mascotas'
UPDATE mascotas 
SET peso = p_peso 
WHERE id_mascota = p_id;
-- 4. Devolvemos el peso anterior en la misma variable
SET p_peso = peso_anterior;
END IF;
END //
DELIMITER ;

SELECT id_mascota, nombre, peso as 'Peso Actual' FROM mascotas;

SET @nuevo_peso = 27.8; -- Aquí cambiamos el peso a 27.8

SELECT @nuevo_peso as 'Peso que vamos a ponerle al id de la mascota';

CALL actualizar_peso_mascota(1, @nuevo_peso);

SELECT id_mascota, nombre, peso as 'nuevo peso (debe ser 27.8) ' 
FROM mascotas WHERE id_mascota = 1;

DELIMITER //
CREATE PROCEDURE agregar_nueva_mascota(
IN p_nombre VARCHAR(50),
IN p_especie VARCHAR(30), 
IN p_raza VARCHAR(50),
IN p_edad INT,
IN p_peso DECIMAL(5,2),
IN p_color VARCHAR(30),
IN p_id_propietario INT
)
BEGIN
DECLARE propietario_existe INT DEFAULT 0;
-- Validamos que el propietario exista
SELECT COUNT(*) INTO propietario_existe
FROM propietarios 
WHERE id_propietario = p_id_propietario;
IF propietario_existe = 0 THEN
SELECT 'Error: El propietario no existe' as Mensaje;
ELSE
-- Si existe un propietario insertamos la nueva mascota
INSERT INTO mascotas (nombre, especie, raza, edad, peso, color, id_propietario)
VALUES (p_nombre, p_especie, p_raza, p_edad, p_peso, p_color, p_id_propietario);
SELECT 'Mascota agregada exitosamente' as Mensaje;
END IF;
END //
DELIMITER ;

CALL agregar_nueva_mascota('Nachito', 'Gato', 'Naranja', 2, 15.5, 'Negro', 1);

SELECT * FROM mascotas WHERE nombre = 'Nachito';

DELIMITER //
CREATE PROCEDURE validar_edad_mascota(IN p_id_mascota INT, OUT p_es_valida VARCHAR(50))
BEGIN
DECLARE v_edad INT DEFAULT 0;
DECLARE mascota_existe INT DEFAULT 0;
-- Primero verificar si la mascota existe
SELECT COUNT(*) INTO mascota_existe
FROM mascotas 
WHERE id_mascota = p_id_mascota;
-- Si existe, obtener su edad
IF mascota_existe > 0 THEN
SELECT edad INTO v_edad
FROM mascotas 
WHERE id_mascota = p_id_mascota;
END IF;
-- Validar resultados
IF mascota_existe = 0 THEN
SET p_es_valida = 'Error: Mascota no encontrada';
ELSEIF v_edad <= 0 THEN
SET p_es_valida = 'Error: Edad inválida';
ELSE
-- Regla de negocio: Las mascotas no pueden tener más de 25 años
IF v_edad <= 25 THEN
SET p_es_valida = 'Edad válida';
ELSE
SET p_es_valida = 'Edad muy alta (máximo 25 años)';
END IF;
END IF;
END //
DELIMITER ;

-- Paso 1: Asignamos el valor a la variable
SET @resultado = '';

-- Paso 2: Verificamos la edad de la mascota con ID 3
SELECT id_mascota, nombre, edad FROM mascotas WHERE id_mascota = 3;

-- Paso 3: Ejecutamos el procedimiento de validación al ID 3
CALL validar_edad_mascota(3, @resultado);

-- Paso 4: Vemos el resultado de la validación
SELECT @resultado as 'Resultado de validación';