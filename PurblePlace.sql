
USE PurblePlace;
drop table if exists USUARIO;
CREATE TABLE USUARIO
(
codigo int primary key not null auto_increment,
nombres varchar(10),
apellidos varchar(10),
nombre_Usuario varchar(10),
correo varchar(20),
clave varchar(7)
);
drop table if exists proovedor;
create table proovedor(
ruc varchar(10) primary key not null,
codigoUsuario int not null ,
nombre varchar(50),
telefono varchar(10),
constraint c1 foreign key(codigoUsuario) references USUARIO(codigo)

);
drop table if exists materiaPrima;
create table materiaPrima (
codigo int primary key not null auto_increment,
cantidadDisponible double,
costo double, 
nombreProducto varchar(20),
unidadesMedida varchar(4)

);
create table Proovedor_Materia_Prima(
codigo int primary key not null auto_increment,
codigo_materiaPrima int not null,
codigo_Proovedor varchar(10) not null,
costoxProovedor double not null,
fechaCaducidad date,
unidadesRecibidas double,
constraint c2 foreign key (codigo_materiaPrima) references materiaPrima(codigo),
constraint c3 foreign key (codigo_Proovedor) references proovedor (ruc)
);
create table receta (
codigo int not null primary key auto_increment,
nombre varchar(50),
descripcion varchar(70),
numPorciones int
);
create table materiPrima_receta(
codigoxReceta int not null primary key auto_increment,
idMateriaPrima int not null,
idReceta int not null,
cantidadNecesaria double not null,
constraint c4 foreign key (idMateriaPrima) references materiaPrima(Codigo),
constraint c5 foreign key (idReceta) references receta(codigo)
);