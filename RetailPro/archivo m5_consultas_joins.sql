
--- Consulta 1 — Vista base del proyecto (INNER JOIN)

SELECT V.ID_Venta, C.Nombre, C.Email, C.Ciudad, C.Fecha_Registro, P.nombre_producto, cat.Nombre_categoria, cat.Descripcion, P.precio, P.stock, V.cantidad, V.precio_unitario, V.fecha_venta

FROM Ventas V 
INNER JOIN Clientes C ON V.ID_Cliente = C.ID_cliente
INNER JOIN Productos P ON V.ID_Producto = P.ID_producto
INNER JOIN Categorias Cat ON cat.ID_categoria = P.ID_categoria;

--- Consulta 2 — Clientes sin ventas (LEFT JOIN)

SELECT C.Nombre, C.Email, C.Fecha_Registro
FROM Clientes C
LEFT JOIN Ventas V ON C.ID_cliente = V.ID_Cliente
WHERE V.ID_Cliente IS NULL; 


--- Consulta 3 — Productos sin ventas (LEFT JOIN) 

SELECT P.nombre_producto, Cat.Nombre_categoria, P.precio
FROM Productos P 
INNER JOIN Categorias Cat ON Cat.ID_categoria = P.ID_categoria
LEFT JOIN Ventas V ON P.ID_producto = V.ID_Producto
WHERE V.id_venta IS NULL;

--- Consulta 4 — Consolidado por canal (UNION ALL). Se busca agrupar el total de ventas por región. 

SELECT Region, SUM(cantidad * precio_unitario) AS Total_Facturado
FROM (
SELECT 'Region Pampeana' AS Region, cantidad, precio_unitario FROM Ventas V
INNER JOIN Clientes C ON V.ID_Cliente = C.ID_cliente
WHERE c.ciudad IN ('Buenos Aires', 'Córdoba', 'Rosario')
UNION ALL 
SELECT 'Region Cuyo' AS region, cantidad, precio_unitario FROM Ventas V
INNER JOIN Clientes C ON V.ID_Cliente = C.ID_cliente
WHERE c.ciudad IN ('Mendoza')
UNION ALL
SELECT 'Region Noroeste' AS region, cantidad, precio_unitario FROM Ventas V
INNER JOIN Clientes C ON V.ID_Cliente = C.ID_cliente
WHERE c.ciudad IN ('Tucumán')
) AS Ventas_regionales
GROUP BY Region;
