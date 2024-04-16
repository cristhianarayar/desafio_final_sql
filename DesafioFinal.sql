--1. Revisa el tipo de relación y crea el modelo correspondiente. Respeta las claves
--primarias, foráneas y tipos de datos.
CREATE TABLE peliculas(
  id SERIAL PRIMARY key,
  nombre VARCHAR(255),
  anno INTEGER
);
CREATE TABLE tags(
  id SERIAL PRIMARY key,
  tag VARCHAR(32)
);
CREATE TABLE peliculas_tags(
  pelicula_id INTEGER,
  tag_id INTEGER,
  PRIMARY key (pelicula_id,tag_id),
  CONSTRAINT fk_pelicula_id FOREIGN KEY(pelicula_id) REFERENCES peliculas(ID) ON DELETE CASCADE,
  CONSTRAINT fk_tag_id FOREIGN key(tag_id) REFERENCES tags(id) ON DELETE CASCADE
);

--2. Inserta 5 películas y 5 tags; la primera película debe tener 3 tags asociados, la segunda película debe tener 2 tags asociados.
INSERT INTO peliculas (nombre,anno) VALUES ('Rambo V',2019),('Iron Man I',2008),('Harry Potter y la piedra filosofal',2001),('Zootopia',2016),('The Karate Kid',2010);
INSERT INTO tags (tag) VALUES ('Excelente Película'),('Excelentes Efectos'),('Falta Trama'),('Mejor que la anterior'),('Aburrida');
INSERT INTO peliculas_tags (pelicula_id,tag_id) VALUES (1,1),(1,3),(1,5),(2,4),(2,2);

SELECT * FROM peliculas;
SELECT * FROM tags;
SELECT * FROM peliculas_tags;

--3. Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe mostrar 0.
SELECT p.nombre, COALESCE(COUNT(pt.tag_id),0) AS cant_tags 
FROM peliculas P LEFT JOIN peliculas_tags pt on P.id = pt.pelicula_id GROUP by P.nombre, P.id ORDER by cant_tags desc;

--4. Crea las tablas correspondientes respetando los nombres, tipos, claves primarias y
--foráneas y tipos de datos.
CREATE TABLE preguntas(
  id SERIAL PRIMARY KEY,
  pregunta VARCHAR(255),
  respuesta_correcta VARCHAR
);

CREATE TABLE usuarios(
  id SERIAL primary key,
  nombre VARCHAR(255),
  edad INTEGER
);

CREATE table respuestas(
  id SERIAL primary KEY,
  respuesta VARCHAR(255),
  usuario_id INTEGER,
  pregunta_id INTEGER,
  CONSTRAINT fk_usuario_id FOREIGN key(usuario_id) REFERENCES usuarios(id),
  CONSTRAINT fk_preguntas_id FOREIGN key(pregunta_id) REFERENCES preguntas(id)
);

--5.- Agrega 5 usuarios y 5 preguntas.
--a. La primera pregunta debe estar respondida correctamente dos veces, por dos usuarios diferentes.
--b. La segunda pregunta debe estar contestada correctamente solo por un usuario.
--c. Las otras tres preguntas deben tener respuestas incorrectas.
INSERT INTO preguntas (pregunta,respuesta_correcta) values ('¿Cuantos días tiene enero?','31'),('¿Colores de la bandera chilena?','Blanco,azul y rojo'),
('¿Cuantos minutos tiene 1 hora?','60 minutos'),('¿Cuantos lados tiene un cubo?','6'),('¿Cuantos lados tiene un triangulo?','3');
INSERT Into usuarios (nombre,edad) Values ('Leonardo',52),('Cristhian',42),('Michelle',20),('Trinidad',18),('Katherinne',40);
INSERT INTO respuestas (respuesta,usuario_id,pregunta_id) VALUES ('31',2,1),('31',3,1),('Blanco,azul y rojo',2,2),('60',5,3),('3',1,4),('6',4,5);

SELECT * from preguntas;
select * FROM usuarios;
SELECT * from respuestas;

--6. Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la pregunta).
SELECT u.nombre as Usuario, COUNT(r.id) as cant_resp_correctas_del_usurios 
FROM usuarios u LEFT JOIN (SELECT r.id, r.usuario_id 
                         FROM respuestas r INNER JOIN preguntas p on r.pregunta_id = p.id
                         WHERE r.respuesta = p.respuesta_correcta) as r on u.id = r.usuario_id 
                         GROUP by u.nombre, r.usuario_id
                         ORDER by cant_resp_correctas_del_usurios DESC;
						 
--7. Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios respondieron correctamente.
SELECT p.pregunta, COUNT(r.usuario_id) as usuarios_respuestas_correctas
FROM preguntas P LEFT JOIN (SELECT r.id, r.usuario_id 
                            FROM respuestas r INNER JOIN preguntas p on r.pregunta_id = p.id
                            WHERE r.respuesta = p.respuesta_correcta) as r on p.id = r.usuario_id 
                            GROUP BY p.pregunta, r.usuario_id
                            ORDER by usuarios_respuestas_correctas desc;	

--8. Implementa un borrado en cascada de las respuestas al borrar un usuario. Prueba la implementación borrando el primer usuario.
ALTER TABLE respuestas DROP CONSTRAINT fk_usuario_id;
ALTER TABLE respuestas ADD CONSTRAINT fk_usuario_id FOREIGN key(usuario_id) REFERENCES usuarios(id) on DELETE CASCADE;

select * from usuarios;
select * from respuestas where usuario_id=1;

DELETE FROM usuarios WHERE id=1;

--9. Crea una restricción que impida insertar usuarios menores de 18 años en la base de datos.
ALTER TABLE usuarios ADD CHECK(edad >= 18);
INSERT Into usuarios (nombre,edad) Values ('Leonardo',16)

--10. Altera la tabla existente de usuarios agregando el campo email. Debe tener la restricción de ser único.
ALTER TABLE usuarios add COLUMN email VARCHAR UNIQUE;
SELECT * FROM usuarios;