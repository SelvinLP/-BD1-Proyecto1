/*Llenando tablas de temporal al modelo relacional*/

/*LLENANDO TABLA TITULO*/
INSERT INTO titulo ( nombre )
SELECT DISTINCT titulo_del_empleado 
FROM temporal
WHERE temporal.titulo_del_empleado IS NOT NULL;

/*LLENANDO TABLA EMPLEADO*/
INSERT INTO empleado ( nombre,apellido,direccion,telefono,fecha_nacimiento,genero,fk_id_titulo )
SELECT DISTINCT tem.nombre_empleado,tem.apellido_empleado, tem.direccion_empleado, REPLACE(tem.telefono_empleado ,'-',''), 
                TO_DATE(tem.fecha_nacimiento_empleado, 'yyyy-mm-dd'), tem.genero_empleado, titulo.id_titulo
FROM temporal tem
INNER JOIN titulo ON tem.titulo_del_empleado=titulo.nombre;

/*LLENANDO TABLA TRATAMIENTO*/
INSERT INTO tratamiento ( descripcion )
SELECT DISTINCT tem.tratamiento_aplicado
FROM temporal tem
WHERE tem.tratamiento_aplicado IS NOT NULL;

/*LLENANDO TABLA PACIENTE*/
INSERT INTO paciente ( nombre,apellido,direccion,telefono,fecha_nacimiento,genero,altura, peso)
SELECT DISTINCT tem.nombre_paciente,tem.apellido_paciente, tem.direccion_paciente, REPLACE(tem.telefono_paciente ,'-',''), 
                TO_DATE(tem.fecha_nacimiento_paciente,'yyyy-mm-dd'), tem.genero_paciente, tem.altura,tem.peso
FROM temporal tem
WHERE tem.nombre_paciente IS NOT NULL;

/*LLENANDO TABLA PACIENTE_TRATAMIENTO*/
INSERT INTO paciente_tratamiento ( fecha_tratamiento,fk_id_paciente,fk_id_tratamiento)
SELECT DISTINCT TO_DATE(tem.fecha_tratamiento,'yyyy-mm-dd'),paciente.id_paciente,tratamiento.id_tratamiento
FROM temporal tem
INNER JOIN paciente ON (tem.nombre_paciente=paciente.nombre AND tem.apellido_paciente=paciente.apellido)
INNER JOIN tratamiento ON (tem.tratamiento_aplicado=tratamiento.descripcion);

/*LLENANDO TABLA EVALUACION*/
INSERT INTO evaluacion ( fecha_evaluacion,fk_id_empleado,fk_id_paciente)
SELECT DISTINCT TO_DATE(tem.fecha_evaluacion,'yyyy-mm-dd'),empleado.id_empleado,paciente.id_paciente
FROM temporal tem
INNER JOIN empleado ON (tem.nombre_empleado=empleado.nombre AND tem.apellido_empleado=empleado.apellido)
INNER JOIN paciente ON (tem.nombre_paciente=paciente.nombre AND tem.apellido_paciente=paciente.apellido);

/*LLENANDO TABLA SINTOMA*/
INSERT INTO sintoma ( nombre )
SELECT DISTINCT tem.sintoma_del_paciente
FROM temporal tem
WHERE tem.sintoma_del_paciente IS NOT NULL;

/*LLENANDO TABLA EVALUACION_SINTOMA*/
INSERT INTO evaluacion_sintoma ( fk_id_evaluacion,fk_id_sintoma)
SELECT DISTINCT evaluacion.id_evaluacion,sintoma.id_sintoma
FROM temporal tem
INNER JOIN empleado ON (tem.nombre_empleado=empleado.nombre AND tem.apellido_empleado=empleado.apellido)
INNER JOIN paciente ON (tem.nombre_paciente=paciente.nombre AND tem.apellido_paciente=paciente.apellido)
INNER JOIN evaluacion ON (empleado.id_empleado=evaluacion.fk_id_empleado AND paciente.id_paciente=evaluacion.fk_id_paciente)
INNER JOIN sintoma ON (tem.sintoma_del_paciente=sintoma.nombre);

/*LLENANDO TABLA DIAGNOSTICO*/
INSERT INTO diagnostico ( descripcion )
SELECT DISTINCT tem.diagnostico_del_sintoma
FROM temporal tem
WHERE tem.diagnostico_del_sintoma IS NOT NULL;


/*LLENANDO TABLA DIANOSTICO_SINTOMA*/
INSERT INTO diagnostico_sintoma ( nivel_certeza,fk_id_diagnostico,fk_id_sintoma )
SELECT DISTINCT tem.rango_del_diagnostico, diagnostico.id_diagnostico, sintoma.id_sintoma
FROM temporal tem
INNER JOIN diagnostico ON (tem.diagnostico_del_sintoma=diagnostico.descripcion)
INNER JOIN sintoma ON (tem.sintoma_del_paciente= sintoma.nombre);

SELECT * FROM titulo; SELECT COUNT(*)FROM titulo;
SELECT * FROM empleado; SELECT COUNT(*)FROM empleado;
SELECT * FROM tratamiento; SELECT COUNT(*)FROM tratamiento;
SELECT * FROM paciente; SELECT COUNT(*)FROM paciente;
SELECT * FROM paciente_tratamiento; SELECT COUNT(*)FROM paciente_tratamiento;
SELECT * FROM evaluacion; SELECT COUNT(*)FROM evaluacion; 
SELECT * FROM sintoma; SELECT COUNT(*)FROM sintoma;
SELECT * FROM evaluacion_sintoma; SELECT COUNT(*) FROM evaluacion_sintoma;
SELECT * FROM diagnostico; SELECT COUNT(*)FROM diagnostico;
SELECT * FROM diagnostico_sintoma; SELECT COUNT(*)FROM diagnostico_sintoma;


truncate table evaluacion_sintoma ;