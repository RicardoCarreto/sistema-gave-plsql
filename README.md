# Sistema de Gestión GAVE - Base de Datos y Procedimientos PL/SQL

El presente trabajo tiene como finalidad el desarrollo de un sistema de gestión para una empresa ficticia llamada **GAVE**, dedicada al alquiler de vehículos eléctricos —bicicletas y scooters— en la ciudad de Nuevo León. Este sistema está implementado en **Oracle APEX**, utilizando programación en **SQL** para controlar la operación de clientes, vehículos, estaciones de carga y el proceso de alquiler.

## Contenido del repositorio

- `tablas_y_datos.sql`  
  Contiene la estructura de las tablas de la base de datos y los inserts iniciales para poblar la BD de GAVE.

- `funciones_plsql.sql`  
  Contiene procedimientos y funciones en PL/SQL:
  1. **`pa_cliente_cud`**: Procedimiento para Insertar (`I`), Actualizar (`U`) o Eliminar (`D`) clientes.
  2. **`pa_reporte_alquiler_anual`**: Procedimiento que genera un reporte anual de alquileres de bicicletas y scooters.
  3. **`pa_consulta_alquileres`**: Procedimiento que consulta los alquileres filtrando por tipo de vehículo y estación.
  4. **`fn_generar_password`**: Función que genera un password basado en ID de empleado, nombre y fecha de nacimiento.

## Ejecución de los scripts

1. **Ejecutar las tablas y datos iniciales**:  
   ```sql
   @tablas_y_datos.sql
   ```

2. **Ejecutar procedimientos y funciones PL/SQL**:  
   ```sql
   @funciones_plsql.sql
   ```

3. **Ejemplos de uso incluidos en `funciones_plsql.sql`**:
   - Insertar clientes con `pa_cliente_cud`.
   - Actualizar y eliminar clientes con `pa_cliente_cud`.
   - Generar reportes anuales de alquileres con `pa_reporte_alquiler_anual`.
   - Consultar alquileres con `pa_consulta_alquileres`.
   - Generar password de empleado con `fn_generar_password`.

## Notas

- Los procedimientos y funciones incluyen validaciones y manejo de errores usando `RAISE_APPLICATION_ERROR` y `DBMS_OUTPUT.PUT_LINE` para mostrar resultados y errores.
- Para ver la salida de `DBMS_OUTPUT.PUT_LINE`, asegúrate de tener habilitado el buffer de salida en tu cliente SQL.

## Autor

Ricardo Daniel Hernández Carreto

