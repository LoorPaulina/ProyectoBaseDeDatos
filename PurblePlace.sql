/*Create database PurblePlace;*/
Use PurblePlace;
create table usuario(
codigoUsuario int not null primary key auto_increment,
nombres varchar(50),
apellidos varchar(50),
nombreUsuario varchar(15),
password varchar(15)
);