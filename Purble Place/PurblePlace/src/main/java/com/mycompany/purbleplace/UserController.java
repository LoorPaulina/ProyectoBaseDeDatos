package com.mycompany.purbleplace;

import java.io.IOException;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.mycompany.purbleplace.modelo.Conexion;
import javafx.fxml.FXML;
import javafx.scene.control.Alert;
import javafx.scene.control.Button;
import javafx.scene.control.PasswordField;
import javafx.scene.control.TextField;

public class UserController {
    @FXML
    Button volver;
    @FXML
    TextField user;
    @FXML
    PasswordField contraseña;

    @FXML
    Button ingresar;

    @FXML
    public void volverAInicio(){
        try{
            App.setRoot("primary");
        }catch(IOException e){
        }
    }

    @FXML
    public void comprobarUsuario(){
        if(user.getText().equals("") || contraseña.getText().equals("")){
            Alert alerta=new Alert(Alert.AlertType.ERROR);
            alerta.setContentText("Llene todos los espacios");
            alerta.showAndWait();
        }else{
            try{
                ResultSet rs=null;
                CallableStatement st=null;
                String consulta="call almacenadoLogIn(?,?,?)";

                Conexion cn = new Conexion();
                st = cn.estableceConexion().prepareCall(consulta);


                st.setString(1, user.getText());
                st.setString(2, contraseña.getText());

                rs = st.executeQuery();
                boolean result=st.getBoolean(3);

                if(result==true){
                    Alert alerta=new Alert(Alert.AlertType.CONFIRMATION);
                    alerta.setContentText("El usuario es correcto, Ingresando a la aplicacion...");
                    alerta.showAndWait();


                    try{
                        App.setRoot("inventario");
                    }catch(IOException e){
                    }

                }else{
                    Alert alerta=new Alert(Alert.AlertType.ERROR);
                    alerta.setContentText("El usuario o la contraseña con incorrectos");
                    alerta.showAndWait();

                }

            }catch (Exception e){
            }
        }}
}
