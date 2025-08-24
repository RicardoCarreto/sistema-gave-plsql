--1

CREATE OR REPLACE PROCEDURE pa_cliente_cud (
    p_accion IN VARCHAR2, -- 'I' Insertar, 'U' Update, 'D' Delete
    p_idCliente IN NUMBER,
    p_nombre IN VARCHAR2 DEFAULT NULL,
    p_correo IN VARCHAR2 DEFAULT NULL,
    p_telefono IN VARCHAR2 DEFAULT NULL,
    p_idTarjeta IN NUMBER DEFAULT NULL
) IS
BEGIN
    IF p_accion = 'I' THEN
        -- Validaciones
        IF p_nombre IS NULL OR p_correo IS NULL OR p_idTarjeta IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'Datos obligatorios faltantes');
        END IF;

        INSERT INTO Cliente (idCliente, nombre, correo, telefono, idTarjeta)
        VALUES (p_idCliente, p_nombre, p_correo, p_telefono, p_idTarjeta);

        DBMS_OUTPUT.PUT_LINE('Cliente insertado correctamente');

    ELSIF p_accion = 'U' THEN
        UPDATE Cliente
        SET nombre = NVL(p_nombre, nombre),
            correo = NVL(p_correo, correo),
            telefono = NVL(p_telefono, telefono),
            idTarjeta = NVL(p_idTarjeta, idTarjeta)
        WHERE idCliente = p_idCliente;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Cliente no encontrado');
        END IF;

        DBMS_OUTPUT.PUT_LINE('Cliente actualizado correctamente');

    ELSIF p_accion = 'D' THEN
        DELETE FROM Cliente WHERE idCliente = p_idCliente;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'Cliente no encontrado');
        END IF;

        DBMS_OUTPUT.PUT_LINE('Cliente eliminado correctamente');
    ELSE
        RAISE_APPLICATION_ERROR(-20004, 'Acción no válida');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;




------------------------------------------------------------------------------------------------------
--2

CREATE OR REPLACE PROCEDURE pa_reporte_alquiler_anual (p_anio IN NUMBER) IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Mes | Bicicleta | Scooter | Total');
    FOR mes IN 1..12 LOOP
        DECLARE
            v_bicicleta NUMBER := 0;
            v_scooter NUMBER := 0;
        BEGIN
            SELECT COUNT(*)
            INTO v_bicicleta
            FROM Alquiler a
            JOIN Vehiculo v ON a.idVehiculo = v.idVehiculo
            WHERE EXTRACT(YEAR FROM a.fechaInicio) = p_anio
            AND EXTRACT(MONTH FROM a.fechaInicio) = mes
            AND v.tipo = 'bicicleta';

            SELECT COUNT(*)
            INTO v_scooter
            FROM Alquiler a
            JOIN Vehiculo v ON a.idVehiculo = v.idVehiculo
            WHERE EXTRACT(YEAR FROM a.fechaInicio) = p_anio
            AND EXTRACT(MONTH FROM a.fechaInicio) = mes
            AND v.tipo = 'scooter';

            DBMS_OUTPUT.PUT_LINE(TO_CHAR(TO_DATE(mes, 'MM'), 'Month') || ' | ' ||
                                 v_bicicleta || ' | ' ||
                                 v_scooter || ' | ' ||
                                 (v_bicicleta + v_scooter));
        END;
    END LOOP;
END;

--------------------------------------------------------------------------------------
--3

CREATE OR REPLACE PROCEDURE pa_consulta_alquileres (
    p_idTipoVehiculo IN NUMBER,
    p_idEstacion IN NUMBER
) IS
BEGIN
    FOR r IN (
        SELECT a.idAlquiler, c.nombre AS cliente, v.tipo, v.modelo,
               a.fechaInicio, a.fechaFin, e.nombre AS estacion
        FROM Alquiler a
        JOIN Cliente c ON a.idCliente = c.idCliente
        JOIN Vehiculo v ON a.idVehiculo = v.idVehiculo
        JOIN Estacion e ON v.idEstacion = e.idEstacion
        WHERE (v.idVehiculo = p_idTipoVehiculo OR p_idTipoVehiculo = -99)
          AND (v.idEstacion = p_idEstacion OR p_idEstacion = -99)
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Alquiler ID: ' || r.idAlquiler || ' | Cliente: ' || r.cliente ||
                             ' | Tipo: ' || r.tipo || ' | Modelo: ' || r.modelo ||
                             ' | Estacion: ' || r.estacion || ' | Inicio: ' || r.fechaInicio ||
                             ' | Fin: ' || NVL(TO_CHAR(r.fechaFin), 'En curso'));
    END LOOP;
END;
/
------------------------------------------------------------------------------------------------------------
--4

CREATE OR REPLACE FUNCTION fn_generar_password (
    p_idEmpleado IN NUMBER,
    p_nombre IN VARCHAR2,
    p_fechaNacimiento IN DATE
) RETURN VARCHAR2 IS
    v_password VARCHAR2(50);
    v_vocal CHAR(1);
    v_consonante CHAR(1);
    v_diaNacimiento VARCHAR2(2);
BEGIN

    v_password := LPAD(p_idEmpleado, 5, '0');

    FOR i IN 1..LENGTH(p_nombre) LOOP
        IF SUBSTR(LOWER(p_nombre), i, 1) IN ('a', 'e', 'i', 'o', 'u') THEN
            v_vocal := SUBSTR(LOWER(p_nombre), i, 1);
            EXIT;
        END IF;
    END LOOP;


    FOR i IN REVERSE 1..LENGTH(p_nombre) LOOP
        IF SUBSTR(LOWER(p_nombre), i, 1) BETWEEN 'a' AND 'z' AND
           SUBSTR(LOWER(p_nombre), i, 1) NOT IN ('a', 'e', 'i', 'o', 'u') THEN
            v_consonante := UPPER(SUBSTR(p_nombre, i, 1));
            EXIT;
        END IF;
    END LOOP;

   
    v_diaNacimiento := TO_CHAR(p_fechaNacimiento, 'DD');

   
    v_password := v_password || v_vocal || v_consonante || v_diaNacimiento || '_';

    RETURN v_password;
END;
/
--------------------------------------------------------------------------------
-- EJECUCION DE PROCEDIMIENTO: pa_cliente_cud (INSERTAR CLIENTE)
--------------------------------------------------------------------------------
BEGIN
    pa_cliente_cud(
        p_accion => 'I',
        p_idCliente => 1,
        p_nombre => 'Juan Perez',
        p_correo => 'juan.perez@mail.com',
        p_telefono => '8112345678',
        p_idTarjeta => 100
    );
END;
/

BEGIN
    pa_cliente_cud(
        p_accion => 'I',
        p_idCliente => 2,
        p_nombre => 'Maria Lopez',
        p_correo => 'maria.lopez@mail.com',
        p_telefono => '8119876543',
        p_idTarjeta => 101
    );
END;
/

BEGIN
    pa_cliente_cud(
        p_accion => 'I',
        p_idCliente => 3,
        p_nombre => 'Luis Mendoza',
        p_correo => 'luis.mendoza@mail.com',
        p_telefono => '8187654321',
        p_idTarjeta => 102
    );
END;
/

--------------------------------------------------------------------------------
-- EJECUCION DE PROCEDIMIENTO: pa_cliente_cud (ACTUALIZAR CLIENTE)
--------------------------------------------------------------------------------
BEGIN
    pa_cliente_cud(
        p_accion => 'U',
        p_idCliente => 3,
        p_nombre => NULL,
        p_correo => 'carlos.reyes.actualizado@mail.com',
        p_telefono => '8198765432',
        p_idTarjeta => NULL
    );
END;
/

--------------------------------------------------------------------------------
-- EJECUCION DE PROCEDIMIENTO: pa_cliente_cud (ELIMINAR CLIENTE)
--------------------------------------------------------------------------------
BEGIN
    pa_cliente_cud(
        p_accion => 'D',
        p_idCliente => 3
    );
END;
/

--------------------------------------------------------------------------------
-- EJECUCION DE PROCEDIMIENTO: pa_reporte_alquiler_anual (AÑO 2024)
--------------------------------------------------------------------------------
BEGIN
    pa_reporte_alquiler_anual(p_anio => 2024);
END;
/

--------------------------------------------------------------------------------
-- EJECUCION DE PROCEDIMIENTO: pa_consulta_alquileres (TODOS LOS TIPOS Y ESTACIONES)
--------------------------------------------------------------------------------
BEGIN
    pa_consulta_alquileres(p_idTipoVehiculo => -99, p_idEstacion => -99);
END;
/

--------------------------------------------------------------------------------
-- EJECUCION DE FUNCION: fn_generar_password PARA CLIENTE
--------------------------------------------------------------------------------
DECLARE
    v_password VARCHAR2(50);
BEGIN
    v_password := fn_generar_password(p_idEmpleado => 5,
                                      p_nombre => 'Roberto Ramos',
                                      p_fechaNacimiento => TO_DATE('1998-04-15','YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('Password generado: ' || v_password);
END;
/