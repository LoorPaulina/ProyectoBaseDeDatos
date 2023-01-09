package com.mycompany.purbleplace;


import javafx.fxml.FXML;
import javafx.scene.control.Button;

import java.io.IOException;

public class RegistroController {

    @FXML
    Button volver;

    @FXML
    Button registrarse;

    @FXML
    public void volverAInicio(){
        try{
            App.setRoot("primary");
        }catch(IOException e){
        }
    }
}
