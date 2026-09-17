USE Ventas_Tech_DB;
SELECT * FROM Ventas;

--- Consulta 1 — Resumen ejecutivo mensual

SELECT
SUM(cantidad * precio_unitario) AS total_facturado,
COUNT(ID_Venta) AS cantidad_pedidos,
AVG(cantidad * precio_unitario) AS ticket_promedio,
MONTH(fecha_venta) AS mes
FROM Ventas
GROUP BY MONTH(fecha_venta); 

--- Consulta 2 — Ranking de productos

SELECT TOP 5
SUM(cantidad * precio_unitario) AS total_facturado,
SUM(cantidad) AS unidades_vendidas
FROM Ventas 
GROUP BY ID_Producto
ORDER BY total_facturado DESC; 

--- Consulta 3 — Clientes recurrentes 

SELECT 
SUM(cantidad) AS cantidad_pedidos,
SUM(cantidad * precio_unitario) AS total_gastado
FROM Ventas
GROUP BY id_cliente 
HAVING COUNT (*) > 1; 

--- Consulta 4 Meses por encima/por debajo del promedio

WITH ReporteMensual AS 
(SELECT 
SUM(cantidad * precio_unitario) AS total_facturado,
MONTH(fecha_venta) AS mes
FROM Ventas
GROUP BY MONTH(fecha_venta)
)

SELECT 
mes, total_facturado, AVG(total_facturado) OVER() AS promedio_general,
CASE 
WHEN total_facturado > AVG(total_facturado) OVER() THEN 'Por encima del promedio'
WHEN total_facturado < AVG(total_facturado) OVER() THEN 'Por debajo del promedio'
ELSE 'Igual al promedio'
END AS estado_rendimiento
FROM ReporteMensual
ORDER BY mes;

--- Hallazgos encontrados en los resultados: 
--- 1. El producto 1 concentra el 56% del total de la facturación. Los siguientes 4 productos concentran el 39%.
--- 2. Los clientes 1 y 5 concentran el 74% del total de la facturación. 
--- 3. Los clientes 2 y 3 concentran el 62% del total de pedidos.
