USE red_cero_desperdicio;



-- Consulta 1: Mostrar todos los productos
SELECT *
FROM Producto;

-- Consulta 2: Mostrar los nombres de las categorías
SELECT nombre
FROM Categoria;

-- Consulta 3: Mostrar los donantes activos
SELECT nombre, telefono, correo
FROM Donante
WHERE estatus = TRUE;

-- Consulta 4: Mostrar los beneficiarios con prioridad alta
SELECT nombre, prioridad
FROM Beneficiario
WHERE prioridad = 'Alta';

-- Consulta 5: Mostrar los productos ordenados alfabéticamente
SELECT nombre, unidad_medida
FROM Producto
ORDER BY nombre ASC;

-- Consulta 6: Mostrar los almacenes con capacidad mayor a 100
SELECT nombre, capacidad
FROM Almacen
WHERE capacidad > 100;


-- Consulta 7: Mostrar los productos que contienen "arroz" en su nombre
SELECT nombre, descripcion
FROM Producto
WHERE nombre LIKE 'arroz';

-- Consulta 8: Mostrar los lotes con cantidad disponible
SELECT codigo_lote, cantidad_recibida, cantidad_disponible
FROM Lote
WHERE cantidad_disponible > 0;

-- Consulta 9: Contar el número de productos
SELECT COUNT(*) AS total_productos
FROM Producto;

-- Consulta 10: Contar el número de donantes activos
SELECT COUNT(*) AS total_donantes
FROM Donante
WHERE estatus = TRUE;

-- Consulta 11: Obtener la cantidad total recibida de todos los lotes
SELECT SUM(cantidad_recibida) AS total_recibido
FROM Lote;

-- Consulta 12: Obtener la cantidad promedio disponible de los lotes
SELECT AVG(cantidad_disponible) AS promedio_disponible
FROM Lote;


-- Consulta 13: Mostrar productos junto con su categoría
SELECT
    p.nombre AS producto,
    c.nombre AS categoria
FROM Producto p
INNER JOIN Categoria c
    ON p.id_categoria = c.id_categoria;

-- Consulta 14: Mostrar productos junto con su conservación
SELECT
    p.nombre AS producto,
    c.nombre AS conservacion,
    c.temperatura
FROM Producto p
INNER JOIN Conservacion c
    ON p.id_conservacion = c.id_conservacion;

-- Consulta 15: Mostrar beneficiarios junto con su tipo
SELECT
    b.nombre AS beneficiario,
    t.nombre AS tipo_beneficiario
FROM Beneficiario b
INNER JOIN TipoBeneficiario t
    ON b.id_tipo_beneficiario = t.id_tipo_beneficiario;

-- Consulta 16: Mostrar sucursales junto con su donante
SELECT
    s.nombre AS sucursal,
    d.nombre AS donante
FROM Sucursal s
INNER JOIN Donante d
    ON s.id_donante = d.id_donante;

-- Consulta 17: Mostrar ubicaciones junto con su almacén
SELECT
    u.codigo_ubicacion,
    u.descripcion,
    a.nombre AS almacen
FROM Ubicacion u
INNER JOIN Almacen a
    ON u.id_almacen = a.id_almacen;

-- Consulta 18: Mostrar lotes junto con el producto
SELECT
    l.codigo_lote,
    p.nombre AS producto,
    l.cantidad_recibida,
    l.cantidad_disponible
FROM Lote l
INNER JOIN Producto p
    ON l.id_producto = p.id_producto;

-- Consulta 19: Contar cuántos productos existen por categoría
SELECT
    c.nombre AS categoria,
    COUNT(p.id_producto) AS total_productos
FROM Categoria c
INNER JOIN Producto p
    ON c.id_categoria = p.id_categoria
GROUP BY c.id_categoria, c.nombre;

-- Consulta 20: Mostrar solamente las categorías que tienen más de un producto
SELECT
    c.nombre AS categoria,
    COUNT(p.id_producto) AS total_productos
FROM Categoria c
INNER JOIN Producto p
    ON c.id_categoria = p.id_categoria
GROUP BY c.id_categoria, c.nombre
HAVING COUNT(p.id_producto) > 1;

-- Consulta 21: Mostrar la cantidad total recibida por producto
SELECT
    p.nombre AS producto,
    SUM(l.cantidad_recibida) AS total_recibido
FROM Producto p
INNER JOIN Lote l
    ON p.id_producto = l.id_producto
GROUP BY p.id_producto, p.nombre;

-- Consulta 22: Mostrar productos cuya cantidad total recibida sea mayor a 100
SELECT
    p.nombre AS producto,
    SUM(l.cantidad_recibida) AS total_recibido
FROM Producto p
INNER JOIN Lote l
    ON p.id_producto = l.id_producto
GROUP BY p.id_producto, p.nombre
HAVING SUM(l.cantidad_recibida) > 100;

-- Consulta 23: Contar las solicitudes realizadas por cada beneficiario
SELECT
    b.nombre AS beneficiario,
    COUNT(s.id_solicitud) AS total_solicitudes
FROM Beneficiario b
INNER JOIN Solicitud s
    ON b.id_beneficiario = s.id_beneficiario
GROUP BY b.id_beneficiario, b.nombre;

-- Consulta 24: Mostrar beneficiarios que tienen más de una solicitud
SELECT
    b.nombre AS beneficiario,
    COUNT(s.id_solicitud) AS total_solicitudes
FROM Beneficiario b
INNER JOIN Solicitud s
    ON b.id_beneficiario = s.id_beneficiario
GROUP BY b.id_beneficiario, b.nombre
HAVING COUNT(s.id_solicitud) > 1;


SELECT
    p.nombre AS producto,
    l.codigo_lote,
    l.cantidad_recibida
FROM Producto p
INNER JOIN Lote l
    ON p.id_producto = l.id_producto
WHERE l.cantidad_recibida > (
    SELECT AVG(cantidad_recibida)
    FROM Lote
);

-- Consulta 26: Mostrar almacenes con capacidad superior
-- a la capacidad promedio
SELECT
    nombre,
    capacidad
FROM Almacen
WHERE capacidad > (
    SELECT AVG(capacidad)
    FROM Almacen
);

-- Consulta 27: Mostrar beneficiarios que tienen al menos una solicitud
SELECT
    nombre
FROM Beneficiario
WHERE id_beneficiario IN (
    SELECT id_beneficiario
    FROM Solicitud
);

-- Consulta 28: Mostrar productos que tienen al menos un lote registrado
SELECT
    nombre
FROM Producto
WHERE id_producto IN (
    SELECT id_producto
    FROM Lote
);

-- Consulta 29: Mostrar los lotes cuya cantidad disponible
-- es mayor que el promedio de cantidad disponible
SELECT
    codigo_lote,
    cantidad_disponible
FROM Lote
WHERE cantidad_disponible > (
    SELECT AVG(cantidad_disponible)
    FROM Lote
);


-- Consulta 30: Mostrar categorías que tienen más productos
-- que el promedio de productos por categoría
SELECT
    c.nombre AS categoria,
    COUNT(p.id_producto) AS total_productos
FROM Categoria c
INNER JOIN Producto p
    ON c.id_categoria = p.id_categoria
GROUP BY c.id_categoria, c.nombre
HAVING COUNT(p.id_producto) > (
    SELECT AVG(total_productos)
    FROM (
        SELECT COUNT(*) AS total_productos
        FROM Producto
        GROUP BY id_categoria
    ) AS cantidades
);

-- Consulta 31: Mostrar beneficiarios que tienen más solicitudes
-- que el promedio de solicitudes por beneficiario
SELECT
    b.nombre AS beneficiario,
    COUNT(s.id_solicitud) AS total_solicitudes
FROM Beneficiario b
INNER JOIN Solicitud s
    ON b.id_beneficiario = s.id_beneficiario
GROUP BY b.id_beneficiario, b.nombre
HAVING COUNT(s.id_solicitud) > (
    SELECT AVG(total_solicitudes)
    FROM (
        SELECT COUNT(*) AS total_solicitudes
        FROM Solicitud
        GROUP BY id_beneficiario
    ) AS solicitudes_promedio
);

-- Consulta 32: Mostrar productos cuya cantidad total disponible
-- es mayor al promedio de las cantidades disponibles por producto
SELECT
    p.nombre AS producto,
    SUM(l.cantidad_disponible) AS total_disponible
FROM Producto p
INNER JOIN Lote l
    ON p.id_producto = l.id_producto
GROUP BY p.id_producto, p.nombre
HAVING SUM(l.cantidad_disponible) > (
    SELECT AVG(total_disponible)
    FROM (
        SELECT SUM(cantidad_disponible) AS total_disponible
        FROM Lote
        GROUP BY id_producto
    ) AS cantidades
);

-- Consulta 33: Mostrar los estados de producto que aparecen
-- en más de una inspección
SELECT
    ep.nombre AS estado,
    COUNT(i.id_inspeccion) AS total_inspecciones
FROM EstadoProducto ep
INNER JOIN Inspeccion i
    ON ep.id_estado_producto = i.id_estado_producto
GROUP BY ep.id_estado_producto, ep.nombre
HAVING COUNT(i.id_inspeccion) > 1;

-- Consulta 34: Mostrar los productos que tienen más de un lote
-- y cuya cantidad disponible total es mayor a 50
SELECT
    p.nombre AS producto,
    COUNT(l.id_lote) AS total_lotes,
    SUM(l.cantidad_disponible) AS disponible
FROM Producto p
INNER JOIN Lote l
    ON p.id_producto = l.id_producto
GROUP BY p.id_producto, p.nombre
HAVING COUNT(l.id_lote) > 1
   AND SUM(l.cantidad_disponible) > 50;

-- Consulta 35: Mostrar los beneficiarios que tienen más de una entrega
-- y cuya cantidad total recibida supera el promedio de todas las entregas
SELECT
    b.nombre AS beneficiario,
    COUNT(DISTINCT e.id_entrega) AS total_entregas,
    SUM(de.cantidad) AS cantidad_recibida
FROM Beneficiario b
INNER JOIN Solicitud s
    ON b.id_beneficiario = s.id_beneficiario
INNER JOIN Entrega e
    ON s.id_solicitud = e.id_solicitud
INNER JOIN DetalleEntrega de
    ON e.id_entrega = de.id_entrega
GROUP BY b.id_beneficiario, b.nombre
HAVING COUNT(DISTINCT e.id_entrega) > 1
   AND SUM(de.cantidad) > (
       SELECT AVG(total_entregado)
       FROM (
           SELECT SUM(cantidad) AS total_entregado
           FROM DetalleEntrega
           GROUP BY id_entrega
       ) AS promedios
   );