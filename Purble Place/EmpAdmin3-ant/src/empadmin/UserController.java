/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package empadmin;

import java.io.IOException;
import javafx.fxml.FXML;
import javafx.scene.control.Button;

/**
 *
 * @author user
 */
public class UserController {
    @FXML
    Button volver;
    
    @FXML
    Button ingresar;
    
    @FXML
    public void volverAInicio(){
        try{
           App.setRoot("primary");
           }catch(IOException e){
        } 
    }
}
