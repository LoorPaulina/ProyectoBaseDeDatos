package com.mycompany.purbleplace.modelo;

import java.sql.Connection;
import java.sql.DriverManager;

public class Conexion {
    Connection con;

    public Connection estableceConexion(){
        try{
            Class.forName("com.mysql.cj.jdbc.Driver");
            con=DriverManager.getConnection("jdbc:mysql://localhost:3306/PurblePlace","root","caramelito");
            System.out.println("Se conecto a la base de datos");
        }catch(Exception e){
            System.out.println("Error: "+e);
        }

        return con;
    }

}

