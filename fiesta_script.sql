USE fiesta_db;

SELECT
  p.nombre,
  p.apellido,
  i.metodo_invitacion,
  c.estado,
  a.hora_llegada
FROM personas p
INNER JOIN invitados i ON p.id_persona = i.id_persona
INNER JOIN confirmaciones c ON p.id_persona = c.id_persona
INNER JOIN asistentes a ON p.id_persona = a.id_persona
WHERE c.estado = 'Confirma'
ORDER BY a.hora_llegada;

SELECT
	p.nombre,
    p.apellido,
    i.metodo_invitacion, 
	CASE 
		WHEN a.id_persona IS NOT NULL THEN CONCAT('SÍ - ', a.hora_llegada) 
		ELSE 'NO asistió'
	END AS asistencia 
FROM personas p 
INNER JOIN invitados i ON p.id_persona = i.id_persona
LEFT JOIN asistentes a ON p.id_persona = a.id_persona
ORDER BY p.nombre;

SELECT 
	p.nombre, 
	p.apellido,
	a.hora_llegada,
	i.metodo_invitacion
FROM invitados i
RIGHT JOIN asistentes a ON i.id_persona = a.id_persona
INNER JOIN personas p ON a.id_persona = p.id_persona;

SELECT p.nombre, p.apellido, 'Invitado' as tipo
FROM personas p
INNER JOIN invitados i ON p.id_persona = i.id_persona
UNION
SELECT p.nombre, p.apellido, 'Asistente' as tipo 
FROM personas p
INNER JOIN asistentes a ON p.id_persona = a.id_persona
ORDER BY nombre;

SELECT
    p.nombre,
    p.apellido,
    m.metodo_invitacion
FROM
    personas p
CROSS JOIN
    (SELECT DISTINCT metodo_invitacion FROM invitados) AS m;
    
SELECT
	p.nombre,
    p.apellido, 
	i.metodo_invitacion
FROM personas p
INNER JOIN invitados i 
ON p.id_persona = i.id_persona
LEFT JOIN asistentes a 
ON p.id_persona = a.id_persona
WHERE a.id_persona IS NULL -- No asistieron
ORDER BY p.nombre;

SELECT
	i1.id_persona as persona1_id,
    i2.id_persona as persona2_id,
    i1.fecha_invitacion as fecha_compartida
FROM invitados i1
INNER JOIN invitados i2 ON i1.fecha_invitacion = i2.fecha_invitacion
WHERE i1.id_persona < i2.id_persona
ORDER BY i1.fecha_invitacion;

-- DATE,TIME,YEAR,TIMESTAMP --

SELECT
	nombre,
    apellido,
    hora_llegada
FROM personas p
INNER JOIN asistentes a ON p.id_persona = a.id_persona
WHERE TIME(hora_llegada) < '20:00:00';

SELECT
	nombre,
    apellido,
    fecha_invitacion
FROM personas p
INNER JOIN invitados i ON p.id_persona = i.id_persona
WHERE DATE(fecha_invitacion) = '2024-08-15';

SELECT
	YEAR(fecha_invitacion) as año,
    COUNT(*) as total_invitaciones
FROM invitados
GROUP BY YEAR(fecha_invitacion);

ALTER TABLE personas
ADD COLUMN created_at TIMESTAMP DEFAULT current_timestamp;
SELECT nombre, apellido, created_at
FROM personas
WHERE nombre = 'Miguel';

SELECT 
nombre,
apellido,
metodo_invitacion,
CASE metodo_invitacion
WHEN 'WhatsApp' THEN '📱 Mensaje'
WHEN 'Email' THEN '📧 Correo'
WHEN 'Llamada' THEN '☎️ Teléfono'
WHEN 'En persona' THEN '👥 Cara a cara'
ELSE '❓ Desconocido'
END as tipo_invitacion
FROM personas p
JOIN invitados i ON p.id_persona = i.id_persona;

SELECT 
p.nombre,
p.apellido,
c.estado as confirmacion,
CASE 
WHEN c.estado = 'Confirma' THEN '✅ Viene seguro'
WHEN c.estado = 'No puede' THEN '❌ No puede venir'
WHEN c.estado = 'Tal vez' THEN '🤔 Tal vez viene'
WHEN c.estado IS NULL THEN '😶 Sin respuesta'
ELSE '❓ Estado raro'
END as situacion
FROM personas p
LEFT JOIN confirmaciones c ON p.id_persona = c.id_persona
WHERE p.id_persona IN (SELECT id_persona FROM invitados);

SELECT 
p.nombre,
p.apellido,
i.metodo_invitacion,
c.estado
FROM personas p
LEFT JOIN invitados i ON p.id_persona = i.id_persona
LEFT JOIN confirmaciones c ON p.id_persona = c.id_persona
WHERE 
CASE 
WHEN i.metodo_invitacion = 'WhatsApp' THEN c.estado = 'Confirma'
WHEN i.metodo_invitacion = 'Email' THEN c.estado IN ('Confirma', 'Tal vez')
ELSE TRUE
END;
