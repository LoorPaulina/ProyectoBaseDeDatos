
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
ALTER TABLE proovedor_materia_prima
ADD costo_unitario_producto double ;
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
/**view que me muestra solo los productos que no estan caducados*/
drop view if exists materiaActual;
create view materiaActual as 
select pmp.codigo,pmp.codigo_materiaPrima,m.nombreProducto,m.unidadesMedida,pmp.unidadesRecibidas,pmp.codigo_Proovedor,p.nombre,pmp.costo_unitario_producto from proovedor_materia_prima as pmp inner join materiaprima as m on 
m.codigo=pmp.codigo_materiaPrima 
inner join proovedor as p on p.ruc=pmp.codigo_Proovedor where pmp.fechaCaducidad > current_date(); 
select * from materiaActual;
select * from proovedor_materia_prima;
select* from materiaPrima;
delimiter ;
select * from usuario;
call almacenadoLogIn("Gperez","G1234",@logeado);
select @logeado;
drop procedure if exists calculoCostoPromedio;
select * from materiaActual;
drop procedure if exists calculoCostoPromedio;
delimiter //
create procedure calculoCostoPromedio(in nombrePro varchar(100), out costo double ) 
begin
declare exito int;
declare id int;
start transaction;
set id=(select m.codigo from materiaprima  as m where m.nombreProducto=nombrePro );
set exito=0;
if id is not null then 
set costo=(select avg(ma.costo_unitario_producto) from materiaActual as ma where ma.codigo_materiaPrima=id and ma.nombreProducto=nombrePro );
set exito=1;
end if;
if exito=0 then
rollback;
else 
commit;
end if;
end
//
delimiter ;
call calculoCostoPromedio("mantequilla",@a);
select @a;
drop procedure if exists tablaMateria;
delimiter //
create procedure tablaMateria()
begin 
start transaction;
select codigo,nombreProducto, unidadesMedida from materiaprima;
end
//
delimiter ;
call calculoCostoPromedio("harina de trigo",3,@resultado);
select avg(ma.costo_unitario_producto) from materiaActual as ma where ma.codigo_materiaPrima=18 and ma.nombreProducto="mantequilla";
select @resultado;
call tablaMateria();
select * from materiaActual;
delimiter //
create procedure calculoStockVigenteProducto( in codProducto int, in nomProducto varchar(100), out numero double)
begin 
start transaction;
set numero=(select sum(ma.unidadesRecibidas) from materiaActual as ma where ma.codigo_materiaPrima=codProducto and ma.nombreProducto=nomProducto );
end
//
delimiter ;
/*vista que me muestra los productos caducados*/
create view materiaCaducada as 
select pmp.codigo,pmp.codigo_materiaPrima,m.nombreProducto,m.unidadesMedida,pmp.unidadesRecibidas,pmp.codigo_Proovedor,p.nombre,pmp.costo_unitario_producto from proovedor_materia_prima as pmp inner join materiaprima as m on 
m.codigo=pmp.codigo_materiaPrima 
inner join proovedor as p on p.ruc=pmp.codigo_Proovedor where pmp.fechaCaducidad < current_date(); 
select * from materiaCaducada;
/* procedimiento que calcula el total de productos caducados*/
delimiter //
create procedure calculoStockCaducadoProducto( in codProducto int, in nomProducto varchar(100), out numero double)
begin 
start transaction;
set numero=(select sum(ma.unidadesRecibidas) from materiaCaducada as ma where ma.codigo_materiaPrima=codProducto and ma.nombreProducto=nomProducto );
end
//
delimiter ;
call calculoStockCaducadoProducto(1,"chocolate blanco",@total );
select @total;
/*almacenado que verfica el correo de un usuario*/
drop procedure if exists verificarCorreo;
delimiter //
create procedure verificarCorreo( in nomuser varchar(100), in usercorreo varchar(100), out estado boolean )
begin 
declare correoUsuario varchar(100);
start transaction;
set correoUsuario=(select correo from usuario where usuario.nombre_Usuario=nomUser);
if correoUsuario=usercorreo then
set estado=true;
commit;
else 
set estado=false;
rollback;
end if;
end
//
delimiter ;

call verificarCorreo("Gperez","gisella@hotmail.com",@es);
select @es;
select * from proovedor;
select * from materiaPrima;
select * from receta;
select * from materiprima_receta;
insert into materiaprima(nombreProducto,unidadesMedida) values("leche","ml"),
("huevo","U"),
("mantequilla","kg"),
("azucar","kg"),
("crema pastelera","kg");
select * from proovedor;
insert into proovedor_materia_prima(codigo_materiaPrima,codigo_Proovedor,costoxProovedor,fechaCaducidad,unidadesRecibidas) values 
(16,"0914463815",50,"2023-01-02",20),
(20,"0981383239",45,"2023-04-02",40),
(18,"0981383239",450,"2023-01-28",40),
(17,"0952959484",200,"2023-04-20",150),
(19,"0952959484",20,"2023-03-02",30),
(19,"0914463815",100,"2023-04-15",55);


insert into receta(nombre,descripcion,numPorciones) values 
("bizcocho de vainilla","bizcocho de vainilla",8),
("pie de limon","pie de limon",10),
("torta mojada de chocolate","torta mojada de chocolate",5),
("relleno de manjar","relleno para tortas",4);
call calculoCostoPromedio();

delimiter //
create procedure mostrarRecetas(  )
begin 
select * from receta;
end
//
delimiter ;

call mostrarRecetas();
select * from receta;
select * from materiprima_receta;
select * from materiaprima;
insert into materiprima_receta(idMateriaPrima,idReceta,cantidadNecesaria) values(3,4,0.5),
(16,4,1.5),
(17,4,3),
(19,4,0.5),
(20,4,1);
drop procedure if exists ingredientesxReceta;
delimiter //
create procedure ingredientesxReceta( in nombreReceta varchar(100),out mensaje varchar(100))
begin 
declare exito int;
declare id int;
start transaction;
set exito=0;
set id=(select codigo from receta where receta.nombre=nombreReceta);
if id is null then 
set exito=0;
set mensaje="el codigo no existe";
else 
set exito=1;
select mp.nombreProducto as nombre, mpr.cantidadNecesaria as cantidad from materiprima_receta as mpr inner join receta as r on mpr.idReceta=r.codigo inner join materiaprima as mp on mpr.idMateriaPrima=mp.codigo where r.codigo=id; 
set mensaje="muestra los ingredientes de la receta ingresada";
end if;
if exito=1 then
commit;
else
rollback;
end if;
end
//

delimiter ;
select * from receta;
call calculoCostoPromedio("leche",16,@resultado);
select @resultado;
call ingredientesxReceta("torta mojada de chocolate",@resultado);
select @resultado;
call ingredientesxReceta("a",@resultado);
select @resultado;
select * from materiaprima;