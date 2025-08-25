-- TABLAS
CREATE TABLE Lectores (
    id_lector INT PRIMARY KEY,
    nombre VARCHAR(50),
    fecha_registro DATE
);

CREATE TABLE Libros (
    id_libro INT PRIMARY KEY,
    titulo VARCHAR(100),
    autor VARCHAR(50),
    genero VARCHAR(30)
);

CREATE TABLE Lecturas (
    id_lectura INT PRIMARY KEY,
    id_lector INT,
    id_libro INT,
    fecha_lectura DATE,
    calificacion INT,
    FOREIGN KEY (id_lector) REFERENCES Lectores(id_lector),
    FOREIGN KEY (id_libro) REFERENCES Libros(id_libro)
);

-- DATOS DE EJEMPLO
INSERT INTO Lectores VALUES (1, 'Ricardo', '2024-01-10');
INSERT INTO Lectores VALUES (2, 'Ana', '2024-03-15');

INSERT INTO Libros VALUES (1, 'Cien Años de Soledad', 'Gabriel García Márquez', 'Realismo Mágico');
INSERT INTO Libros VALUES (2, '1984', 'George Orwell', 'Distopía');
INSERT INTO Libros VALUES (3, 'El Principito', 'Antoine de Saint-Exupéry', 'Fábula');

INSERT INTO Lecturas VALUES (1, 1, 1, '2025-01-05', 5);
INSERT INTO Lecturas VALUES (2, 1, 2, '2025-02-10', 4);
INSERT INTO Lecturas VALUES (3, 2, 3, '2025-03-01', 5);

-- CONSULTA: Recomendación simple por género más leído (SQL estándar)
SELECT L.nombre AS lector, B.titulo AS libro_recomendado, B.genero
FROM Lectores L
JOIN Libros B ON B.genero = (
    SELECT genero
    FROM Libros LB
    JOIN Lecturas LE ON LB.id_libro = LE.id_libro
    WHERE LE.id_lector = L.id_lector
    GROUP BY LB.genero
    ORDER BY COUNT(*) DESC
    LIMIT 1
)
WHERE B.id_libro NOT IN (
    SELECT id_libro
    FROM Lecturas
    WHERE id_lector = L.id_lector
);
