/*CONSULTAS*/

/*Consulta 1: Mostrar el nombre, apellido y teléfono de todos los empleados y la cantidad de pacientes atendidos por cada 
empleado ordenados de mayor a menor.*/
SELECT emp.nombre,emp.apellido,emp.telefono,COUNT(evaluacion.fk_id_empleado) as Cantidad
FROM empleado emp
LEFT JOIN evaluacion ON (evaluacion.fk_id_empleado=emp.id_empleado)
GROUP BY emp.nombre,emp.apellido,emp.telefono
ORDER BY count(evaluacion.fk_id_empleado) DESC;

/*Consulta 2:el nombre, apellido, dirección y título de todos los empleados de sexo masculino que atendieron a más de 3 
pacientes en el año 2016.*/
SELECT emp.nombre,emp.apellido,emp.direccion,titulo.nombre as Titulo
FROM empleado emp
INNER JOIN titulo ON (emp.fk_id_titulo=titulo.id_titulo) 
INNER JOIN evaluacion ON (evaluacion.fk_id_empleado=emp.id_empleado AND EXTRACT( YEAR FROM evaluacion.fecha_evaluacion) =2016)
WHERE emp.genero='M'
GROUP BY emp.nombre,emp.apellido,emp.direccion,titulo.nombre
HAVING count(evaluacion.fk_id_empleado)>3;

/*Consulta 3: Mostrar el nombre y apellido de todos los pacientes que se están aplicando el tratamiento “Tabaco en polvo” y que 
tuvieron el síntoma “Dolor de cabeza”.*/
SELECT DISTINCT pc.nombre,pc.apellido
FROM paciente pc
INNER JOIN paciente_tratamiento ON (pc.id_paciente=paciente_tratamiento.fk_id_paciente)
INNER JOIN tratamiento ON (tratamiento.id_tratamiento=paciente_tratamiento.fk_id_tratamiento AND tratamiento.descripcion='Tabaco en polvo')
INNER JOIN evaluacion ON (evaluacion.fk_id_paciente=pc.id_paciente)
INNER JOIN evaluacion_sintoma ON (evaluacion_sintoma.fk_id_evaluacion=evaluacion.id_evaluacion)
INNER JOIN sintoma ON (sintoma.id_sintoma=evaluacion_sintoma.fk_id_sintoma AND sintoma.nombre='Dolor de cabeza');

/*Consulta 4:Top 5 de pacientes que más tratamientos se han aplicado del tratamiento “Antidepresivos”.  Mostrar nombre, apellido
y la cantidad de tratamientos.*/
SELECT pc.nombre,pc.apellido,COUNT(paciente_tratamiento.fk_id_paciente) as Cantidad_de_Tratamientos
FROM paciente pc
INNER JOIN paciente_tratamiento ON (pc.id_paciente=paciente_tratamiento.fk_id_paciente)
INNER JOIN tratamiento ON (tratamiento.id_tratamiento=paciente_tratamiento.fk_id_tratamiento AND tratamiento.descripcion='Antidepresivos')
GROUP BY pc.nombre,pc.apellido
ORDER BY COUNT(paciente_tratamiento.fk_id_paciente) DESC 
FETCH NEXT 5 ROWS ONLY;

/*Consulta 5:Mostrar el nombre, apellido y dirección de todos los pacientes que se hayan aplicado más de 3 tratamientos y no hayan
sido atendidos por un empleado.  Debe mostrar la cantidad de tratamientos que se aplicó el paciente.  Ordenar los resultados 
de mayor a menor utilizando la cantidad de tratamientos.*/
SELECT pc.nombre,pc.apellido,pc.direccion,COUNT(paciente_tratamiento.fk_id_paciente) as Cantidad_Tratamiento
FROM paciente pc
INNER JOIN paciente_tratamiento ON (pc.id_paciente=paciente_tratamiento.fk_id_paciente)
WHERE pc.id_paciente NOT IN( SELECT DISTINCT evaluacion.fk_id_paciente 
                        FROM evaluacion )
GROUP BY pc.nombre,pc.apellido,pc.direccion
HAVING COUNT(paciente_tratamiento.fk_id_paciente)>3
ORDER BY COUNT(paciente_tratamiento.fk_id_paciente) DESC;

/*Consulta 6: Mostrar el nombre del diagnóstico y la cantidad de síntomas a los que ha sido asignado donde el rango ha sido de 9.
Ordene sus resultados de mayor a menor en base a la cantidad de síntomas.*/
SELECT ds.descripcion as Diagnostico,count(sintoma.id_sintoma) as Cantidad_sintomas
FROM diagnostico ds
INNER JOIN diagnostico_sintoma ON (diagnostico_sintoma.fk_id_diagnostico=ds.id_diagnostico AND diagnostico_sintoma.nivel_certeza=9)
INNER JOIN sintoma ON (sintoma.id_sintoma = diagnostico_sintoma.fk_id_sintoma)
GROUP BY ds.descripcion
ORDER BY count(sintoma.nombre) DESC;

/*Consulta 7:Mostrar el nombre, apellido y dirección de todos los pacientes que presentaron un síntoma que al que le fue 
asignado un diagnóstico con un rango mayor a 5.  Debe mostrar los resultados en orden alfabético tomando en cuenta el nombre 
y apellido del paciente.*/
SELECT DISTINCT pc.nombre,pc.apellido,pc.direccion
FROM paciente pc
INNER JOIN evaluacion ON (evaluacion.fk_id_paciente=pc.id_paciente)
INNER JOIN evaluacion_sintoma ON (evaluacion_sintoma.fk_id_evaluacion=evaluacion.id_evaluacion)
INNER JOIN sintoma ON (sintoma.id_sintoma=evaluacion_sintoma.fk_id_sintoma)
INNER JOIN diagnostico_sintoma ON (diagnostico_sintoma.fk_id_sintoma=sintoma.id_sintoma AND diagnostico_sintoma.nivel_certeza>5)
ORDER BY pc.nombre,pc.apellido ASC;

/*Consulta 8: Mostrar el nombre, apellido y fecha de nacimiento de todos los empleados de sexo femenino cuya dirección es 
“1475 Dryden Crossing” y hayan atendido por lo menos a 2 pacientes.  Mostrar la cantidad de pacientes atendidos por el empleado 
y ordénelos de mayor a menor.*/
SELECT emp.nombre,emp.apellido,emp.fecha_nacimiento,COUNT(evaluacion.fk_id_empleado) as Cantidad_Atendidos
FROM empleado emp
INNER JOIN evaluacion ON (evaluacion.fk_id_empleado=emp.id_empleado)
WHERE emp.genero='F' AND  emp.direccion='1475 Dryden Crossing'
GROUP BY emp.nombre,emp.apellido,emp.fecha_nacimiento
HAVING COUNT(evaluacion.fk_id_empleado)>=2
ORDER BY COUNT(evaluacion.fk_id_empleado) DESC;

/*Consulta 9: Mostrar el porcentaje de pacientes que ha atendido cada empleado a partir del año 2017 y mostrarlos de mayor a 
menor en base al porcentaje calculado.*/
SELECT DISTINCT empleado.nombre,empleado.apellido,tem.total,COUNT(evaluacion.fk_id_empleado) as Cantidad, COUNT(evaluacion.fk_id_empleado)/tem.total*100 as Porcentaje
FROM empleado,evaluacion,(
    SELECT COUNT(evaluacion.fk_id_empleado) as total
    FROM empleado 
    INNER JOIN evaluacion ON (evaluacion.fk_id_empleado=empleado.id_empleado AND EXTRACT( YEAR FROM evaluacion.fecha_evaluacion)>2017)
) tem 
WHERE evaluacion.fk_id_empleado=empleado.id_empleado AND EXTRACT( YEAR FROM evaluacion.fecha_evaluacion)>2017
GROUP BY empleado.nombre,empleado.apellido,tem.total
ORDER BY COUNT(evaluacion.fk_id_empleado)/tem.total*100 DESC;

/*Consulta 9: Mostrar el porcentaje del título de empleado más común de la siguiente manera: nombre del título, porcentaje de 
empleados que tienen ese título.  Debe ordenar los resultados en base al porcentaje de mayor a menor.*/
SELECT titulo.nombre, COUNT(empleado.fk_id_titulo)/tem.total*100 as Porcentaje_Titulo
FROM titulo,empleado,(
    SELECT COUNT(empleado.fk_id_titulo) as total
    FROM titulo 
    INNER JOIN empleado ON (empleado.fk_id_titulo=titulo.id_titulo)
) tem 
WHERE empleado.fk_id_titulo=titulo.id_titulo
GROUP BY titulo.nombre,tem.total
ORDER BY COUNT(empleado.fk_id_titulo)/tem.total*100 DESC;

/*Consulta Extra: Mostrar el año y mes (de la fecha de evaluación) junto con el nombre y apellido de los pacientes que más 
tratamientos se han aplicado y los que menos. (Todo en una sola consulta). */
SELECT * FROM(
SELECT EXTRACT( YEAR FROM ev.fecha_evaluacion ) as Año,EXTRACT( MONTH FROM ev.fecha_evaluacion) as Mes, 
        paciente.nombre,paciente.apellido,temcount.contador
FROM evaluacion ev,paciente,(
    SELECT MAX(tem1.contador) as Max
    FROM (
        SELECT paciente.id_paciente as idn,COUNT(paciente_tratamiento.fk_id_paciente) as contador
        FROM paciente
        INNER JOIN paciente_tratamiento ON(paciente_tratamiento.fk_id_paciente = paciente.id_paciente)
        GROUP BY paciente.id_paciente
    )tem1
) tem,(
    SELECT paciente.id_paciente as idn,COUNT(paciente_tratamiento.fk_id_paciente) as contador
    FROM paciente
    INNER JOIN paciente_tratamiento ON(paciente_tratamiento.fk_id_paciente = paciente.id_paciente)
    GROUP BY paciente.id_paciente
)temcount
WHERE ev.fk_id_paciente=paciente.id_paciente AND temcount.idn=paciente.id_paciente AND tem.Max=temcount.contador
UNION ALL
SELECT EXTRACT( YEAR FROM ev.fecha_evaluacion ) as Año,EXTRACT( MONTH FROM ev.fecha_evaluacion) as Mes, 
        paciente.nombre,paciente.apellido,temcount.contador
FROM evaluacion ev,paciente,(
    SELECT MIN(tem1.contador) as Max
    FROM (
        SELECT paciente.id_paciente as idn,COUNT(paciente_tratamiento.fk_id_paciente) as contador
        FROM paciente
        INNER JOIN paciente_tratamiento ON(paciente_tratamiento.fk_id_paciente = paciente.id_paciente)
        GROUP BY paciente.id_paciente
    )tem1
) tem,(
    SELECT paciente.id_paciente as idn,COUNT(paciente_tratamiento.fk_id_paciente) as contador
    FROM paciente
    INNER JOIN paciente_tratamiento ON(paciente_tratamiento.fk_id_paciente = paciente.id_paciente)
    GROUP BY paciente.id_paciente
)temcount
WHERE ev.fk_id_paciente=paciente.id_paciente AND temcount.idn=paciente.id_paciente AND tem.Max=temcount.contador) tbfinal
ORDER BY tbfinal.contador DESC;