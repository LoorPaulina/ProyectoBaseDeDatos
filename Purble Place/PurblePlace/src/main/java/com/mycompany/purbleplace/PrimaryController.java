package com.mycompany.purbleplace;

import java.io.IOException;
import javafx.fxml.FXML;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import javafx.application.Platform;
import javafx.collections.FXCollections;
import javafx.fxml.FXML;
import javafx.fxml.FXMLLoader;
import javafx.scene.Cursor;
import javafx.scene.Node;
import javafx.scene.Parent;
import javafx.scene.control.Alert;
import javafx.scene.control.Button;
import javafx.scene.control.ButtonType;
import javafx.scene.control.ComboBox;
import javafx.scene.control.Label;
import javafx.scene.control.ListView;
import javafx.scene.control.TableCell;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.AnchorPane;
import javafx.scene.layout.HBox;
import javafx.scene.layout.VBox;
import javafx.stage.Stage;
import javafx.util.Callback;

public class PrimaryController {

    @FXML
    Button inicioSesion;
    @FXML
    Button salir;
    @FXML
    Button registro;
    @FXML
    AnchorPane pane;

    Stage stage;

    @FXML
    private void initialize() {
        inicioSesion.setCursor(Cursor.HAND);
        salir.setCursor(Cursor.HAND);
        registro.setCursor(Cursor.HAND);
    }

    @FXML
    public void cerrarVentana(){
        Alert alert = new Alert(Alert.AlertType.CONFIRMATION);
        alert.setTitle("Atención ");
        alert.setContentText("desea salir de la aplicación ?");
        stage= (Stage)pane.getScene().getWindow();

        if (alert.showAndWait().get().equals(ButtonType.OK)) {
            stage.close();
            Platform.exit();
        }
    }

    @FXML
    public void inicioSesion(){
        try{
            App.setRoot("inicioSesion");
        }catch(IOException e){

        }
    }

    @FXML
    public void registro(){
        try{
            App.setRoot("registro");
        }catch(IOException e){

        }
    }
}

