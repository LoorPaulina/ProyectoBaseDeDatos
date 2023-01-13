package com.mycompany.purbleplace;

import com.mycompany.purbleplace.modelo.Conexion;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


public class Ingrediente {
    private int codigo;
    private String nombre;
    private int costo;

    public Ingrediente(int codigo, String nombre, int costo ){
        this.codigo=codigo;
        this.nombre=nombre;
        this.costo=costo;
    }

    public Ingrediente(){}

    public ObservableList<Ingrediente> getServicios(){
        ObservableList<Ingrediente> obIngrediente= FXCollections.observableArrayList();

        try{
            ResultSet rs=null;
            CallableStatement st=null;
            String consulta;

            Conexion cn = new Conexion();
            st = cn.estableceConexion().prepareCall(consulta);
            rs = st.executeQuery();

            while(rs.next()){

                int codigo=rs.getInt(0);
                String nombre=rs.getString(1);

                Ingrediente ingrediente=new Ingrediente(codigo, nombre,);
                obIngrediente.add(ingrediente);


            }


        }catch (SQLException e)

    }

}
