
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
delimiter //
create procedure eliminarIngrediente( in nombreIngrediente varchar(100),out mensaje varchar(100))
begin 
declare exito int;
declare id int;
set exito=0;
start transaction;
set id=(select codigo from materiaprima where nombreProducto=nombreIngrediente );
if id is not null then 
delete from materiaprima as mp where mp.codigo=id;
set exito=1;
else
set exito=0;
end if;
if exito=1 then 
set mensaje="se borro el registro";
commit;
else 
set mensaje="no se borro";
rollback;
end if;
end
//

delimiter ;
ALTER TABLE materiprima_receta  ADD  CONSTRAINT c12 FOREIGN KEY (idMateriaPrima)
REFERENCES materiaprima(codigo)
ON DELETE CASCADE;
ALTER TABLE materiprima_receta  ADD  CONSTRAINT c13 FOREIGN KEY (idMateriaPrima)
REFERENCES materiaprima(codigo)
ON UPDATE CASCADE;
ALTER TABLE proovedor_materia_prima  ADD  CONSTRAINT c14 FOREIGN KEY (codigo_materiaPrima)
REFERENCES materiaprima(codigo)
ON DELETE CASCADE;
ALTER TABLE proovedor_materia_prima  ADD  CONSTRAINT c15 FOREIGN KEY (codigo_materiaPrima)
REFERENCES materiaprima(codigo)
ON UPDATE CASCADE;
ALTER TABLE proovedor_materia_prima  ADD  CONSTRAINT c16 FOREIGN KEY (codigo_Proovedor)
REFERENCES proovedor(ruc)
ON DELETE CASCADE;
ALTER TABLE proovedor_materia_prima  ADD  CONSTRAINT c17 FOREIGN KEY (codigo_Proovedor)
REFERENCES proovedor(ruc)
ON UPDATE CASCADE;
ALTER TABLE materiprima_receta  ADD  CONSTRAINT c18 FOREIGN KEY (idReceta)
REFERENCES receta(codigo)
ON DELETE CASCADE;
ALTER TABLE materiprima_receta  ADD  CONSTRAINT c10 FOREIGN KEY (idReceta)
REFERENCES receta(codigo)
ON UPDATE CASCADE;
select * from proovedor_materia_prima;
select * from materiaprima;
call eliminarIngrediente( "azucar",@mensaje);
select @mensaje; 
drop procedure if exists IngresarUsuario;
delimiter //
create procedure IngresarUsuario( in nom varchar(100),in ap varchar(100),nomuser varchar(100), mail varchar(100), pass varchar(100),out mensaje varchar(100))
begin 
declare exito int;
declare id int;
start transaction;
set exito=0;
set id=(select codigo from usuario where nombre_Usuario=nomuser);
if id is null then 
insert into usuario (nombres,apellidos,nombre_Usuario,correo,clave) values 
(nom,ap,nomuser,mail,pass);
set exito=1;
set mensaje="se creo nuevo usuario";
else 
set exito=0;
set mensaje="el usuario ya existe";
end if;
if exito=1 then
commit;
else 
rollback;
end if;
end
//

delimiter ;
select * from usuario;
call IngresarUsuario( "Mariana","Peresz","Mperez", "correo@hotmail.com", "pass",@m);
drop procedure if exists IngresarMateriaPrima;
delimiter //
create procedure IngresarMateriaPrima( in nombremateria varchar(100),unidades varchar(20),out mensaje varchar(100))
begin 
declare exito int;
declare idmateria int;
start transaction;
set idmateria=(select codigo from materiaprima where nombreProducto=nombremateria);
if idmateria is null then 
set exito=1;
set mensaje= "se realizo el ingreso";
insert into materiaprima(nombreProducto,unidadesMedida) values (nombremateria,unidades);
else 
set exito=0;
set mensaje="la materia prima ya existe";
end if;
if exito=1 then
commit;
else
rollback;
end if;
end
//

delimiter ;
select * from materiaprima;
select * from proovedor;
select * from proovedor_materia_prima;

call IngresarMateriaPrima( "semillas", "Kg",@m);
select @m;
delimiter //
create procedure IngresarProovedor( in codi varchar(12),in nombreproo varchar(100),telefono varchar(10),out mensaje varchar(100))
begin 
declare exito int;
declare idproovedor varchar(20);
start transaction;
set exito=0;
set idproovedor=(select ruc from proovedor where nombre=nombreproo);
if idproovedor is null then 
insert into proovedor(ruc,nombre,telefono) values(codi,nombreproo,telefono);
set exito=1;
set mensaje="ingreso exitoso";
else
set exito=0;
set mensaje="el proovedor ya esta ingresado";
end if;
if exito=1 then
commit;
else
rollback;
end if;
end
//
SELECT * FROM proovedor;
delimiter ;
call IngresarProovedor("0945879001","La Fabril S.A","0945862589",@m);
select @m;
delimiter //
create function verificarMateriaP (nomproducto varchar(50))
returns boolean
READS SQL DATA
DETERMINISTIC
begin
declare idprod int;
declare exito boolean;
set idprod=(select codigo from materiaprima where nombreProducto=nomproducto );
if idprod is null then 
set exito=false;
else 
set exito=true;
end if;
return exito;
end//
delimiter ;
drop function if exists verificarProov;
delimiter //
create function verificarProov (nomproveedor varchar(50))
returns boolean
READS SQL DATA
DETERMINISTIC
begin
declare idproo varchar(50);
declare exito boolean;
set idproo=(select ruc from proovedor where nombre=nomproveedor );
if idproo is null then 
set exito=false;
else 
set exito=true;
end if;
return exito;
end//
delimiter ;
select * from materiaprima;
select * from proovedor;
select verificarMateriaP ("harina ");
select verificarProov("Inalecsa");
drop procedure if exists IngresoMateriaPrimaProo;
delimiter //
create procedure IngresoMateriaPrimaProo( in nomMp varchar(50),in unidadesMed varchar(50),in nomProo varchar(100),in rucproo varchar(50), in telproo varchar(120),in totalF double, in fechaC date, in uRecibidas int ,out mensaje varchar(100))
begin 
declare exito int;
declare idmateria int;
declare idproov varchar(50);
declare existemateria boolean;
declare existeproov boolean;
start transaction;
set exito=0;
set existemateria= verificarMateriaP(nomMp);
set existeproov= verificarProov(nomProo);
if existemateria is true and existeproov is true then 
set idmateria=(select codigo from materiaprima where nombreProducto=nomMp);
set idproov=(select ruc from proovedor  where nombre=nomProo);
set exito=1;
set mensaje="se inserto";
insert into proovedor_materia_prima(codigo_materiaPrima,codigo_Proovedor,costoxProovedor,fechaCaducidad,unidadesRecibidas) values
(idmateria,idproov,totalF,fechaC,uRecibidas);
else 
if idmateria is null then 
call IngresarMateriaPrima(nomMp,unidadesMed,@s);
set idmateria=(select codigo from materiaprima where nombreProducto=nomMp);
end if;
if idproov is null then 
call IngresarProovedor( rucproo,nomProo,telproo,@l);
set idproov=(select ruc from proovedor  where nombre=nomProo);
end if;
insert into proovedor_materia_prima(codigo_materiaPrima,codigo_Proovedor,costoxProovedor,fechaCaducidad,unidadesRecibidas) values
(idmateria,idproov,totalF,fechaC,uRecibidas);
set exito=1;
set mensaje="se hicieron ingreso nuevos en las tablas relacionadas";
end if;
if exito=1 then
commit;
else
rollback;
end if;
end

//
select * from proovedor;
select * from materiaprima;
call IngresoMateriaPrimaProo("leche evaporada","lt","Nestle S.A","0987563214", "0845824598",25, "2023-08-02",20 ,@m);
select @m;
select * from proovedor_materia_prima;
delimiter //
create procedure IngresoReceta( in nom varchar(50),in des varchar(100),in numP int,out mensaje varchar(100))
begin 
declare exito int;
declare idreceta int;
start transaction;
set exito=0;
set idreceta=(select codigo from receta where nombre=nom);
if idreceta is null then 
insert into receta(nombre,descripcion,numPorciones) values 
(nom,des,numP);
set exito=1;
set mensaje="ingreso una nueva receta";
else 
set exito="0";
set mensaje="la receta ya existe";
end if;
if exito=1 then
commit;
else
rollback;
end if;
end

//
select * from proovedor_materia_prima;
select * from materiaprima;
select * from materiaactual;
call calculoCostoPromedio("leche evaporada",@a);
select @a;
call IngresoReceta("pie de fresas","pie",8,@mensaje);
select @mensaje;
select * from receta;
drop procedure if exists EliminarReceta;
delimiter //
create procedure EliminarReceta( in nom varchar(50),out mensaje varchar(100))
begin 
declare exito int;
declare idreceta int;
start transaction;
set idreceta=(select codigo from receta where nombre=nom);
set exito=0;
if idreceta is not null then 
delete from receta where codigo=idreceta;
delete from materiprima_receta where idReceta=idreceta;
set exito=1;
set mensaje="se elimino una receta";
else set exito=0;
set mensaje="no se pudo eliminar ";
end if;
if exito=1 then
commit;
else
rollback;
end if;
end

//
select * from receta;
select * from materiprima_receta;
call EliminarReceta( "torta mojada de chocolate",@m);
select @m;
drop procedure if exists IngresarIngredienteReceta;
delimiter //
create procedure IngresarIngredienteReceta( in nomMP varchar(50),in nomReceta varchar(50), in cantidadN double,out mensaje varchar(100))
begin 
declare exito int;
declare idreceta int;
declare idIng int;
start transaction;
set exito=0;
set idreceta=(select codigo from receta where nombre=nomReceta);
set idIng=(select codigo from materiaprima where nombreProducto=nomMP);
if idreceta is not null and idIng is not null then 
insert into materiprima_receta(idMateriaPrima,idReceta,cantidadNecesaria) values
(idIng,idreceta,cantidadN);
set exito=1;
set mensaje="se ingreso de manera exitosa";
else 
set exito=0;
set mensaje="asegurese de que la receta y el ingrediente esten ingresados ";
end if;
if exito=1 then
commit;
else
rollback;
end if;
end

//
call IngresarIngredienteReceta( "mantequilla","pie de limon",0.5,@m);
select @m;
select * from materiprima_receta;