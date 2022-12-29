/*Create database PurblePlace;
Use PurblePlace;*/

USE PurblePlace;

CREATE TABLE USUARIO
(
codigo varchar(5) primary key not null,
nombres varchar(10),
apellidos varchar(10),
nombre_Usuario varchar(10),
correo varchar(20),
clave varchar(7)
);


