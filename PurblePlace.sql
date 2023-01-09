drop database PurblePlace;

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
nombre varchar(50),
telefono varchar(10)
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

insert into usuario (nombres, apellidos, nombre_Usuario,correo,clave) values 
("Gisella","Perez","Gperez","gisella@hotmail.com","G12345");

insert into proovedor(ruc,nombre,telefono) values 
("0952959484","Industrias Trigo S.A","0981383239"),
("0981383239","Inalecsa S.A","0952959484"),
("0914463815","Megamaxi S.A","0981383239");

insert into materiaprima (nombreProducto,unidadesMedida) values
("chocolate blanco","kg"),
("chocolate negro","kg"),
("harina de trigo","kg"),
("cafe","kg"),
("manjar","kg");
select *
from proovedor_materia_prima;
/**trigger para que calcule el costo unitario despues de un ingreso**/
drop trigger if exists inProovedorMateria;
create trigger inProovedorMateria before insert on proovedor_materia_prima for each row
set new.costo_unitario_producto = new.costoxProovedor/new.unidadesRecibidas;

insert into proovedor_materia_prima(codigo_materiaPrima,codigo_Proovedor,costoxProovedor,fechaCaducidad,unidadesRecibidas)
values(3,"0952959484",100,"2023-02-02",20);*//
/*(4,"0981383239",100,"2023-02-02",18),
(5,"0914463815",150,"2023-04-02",15),
(1,"0914463815",550,"2023-02-02",100),
(1,"0952959484",50,"2022-02-02",20);*/
/*FUNCION QUE VERIFICA SI EL USUARIO ES CORRECTO*/
delimiter //
create function logIn (nomUser varchar(50),passW varchar(50))
returns boolean
READS SQL DATA
DETERMINISTIC
begin
declare numero int;
declare logeado boolean;
select count(codigo) into numero from usuario where nombre_Usuario=nomUser and clave=passW;
if numero >=1 then 
set logeado=true;
else
set logeado=false;
end if;
return logeado;
end//
delimiter ;
/*PRUEBA DE LA FUNCION*/
select logIn("Gperez","G12345");
drop procedure if exists almacenadoLogIn;
delimiter //
create procedure almacenadoLogIn ( in nomUser varchar(50),in passWord varchar(50),
out logeado boolean )

begin 
start transaction;
    select logIn(nomUser,passWord) into logeado;
	
end
//
delimiter ;
select * from usuario;
call almacenadoLogIn("Gperez","G1234",@logeado);
select @logeado;