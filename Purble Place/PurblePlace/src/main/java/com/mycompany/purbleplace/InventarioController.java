package com.mycompany.purbleplace;

import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.layout.GridPane;
import javafx.scene.layout.VBox;


public class InventarioController {

    @FXML
    Button materiaPrima;

    @FXML
    Button recetas;

    @FXML
    Button productos;

    @FXML
    Button salir;

    @FXML
    VBox panel;

    @FXML


    public void initialize(){

    }

    @FXML
    public void mostrarProductos(){
        TableView cargar=new TableView();


        panel.getChildren().add(cargar);
    }



    @FXML
    public void mostrarRecetas(){
        TableView cargar=new TableView();
        TableColumn<Ingrediente, String> colCodigo=new TableColumn<Ingrediente, String>("CÓDIGO");
        TableColumn<Ingrediente, String> colNombre=new TableColumn<Ingrediente, String>("NOMBRE");
        cargar.getColumns().addAll(colCodigo, colNombre );
        panel.getChildren().add(cargar);

        colCodigo.setCellValueFactory(new PropertyValueFactory<>("codigo"));
        colCodigo.setCellValueFactory(new PropertyValueFactory<>("nombre"));

        Ingrediente ingrediente=new Ingrediente();
        ObservableList<Ingrediente> items=ingrediente.getServicios();
        cargar.setItems(items);

    }
    @FXML
    public void mostrarIngredientes(){
        TableView cargar=new TableView();


        panel.getChildren().add(cargar);
    }

    @FXML
    public void salir(){}

}
