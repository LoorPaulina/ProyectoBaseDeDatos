package empadmin;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

import java.io.IOException;
import static javafx.application.Application.launch;
import javafx.application.Platform;
import javafx.fxml.FXML;
import javafx.scene.control.Alert;
import javafx.scene.control.Button;
import javafx.scene.control.ButtonType;

/**
 * JavaFX App
 */
public class App extends Application {


    private static Scene scene;
    @Override
    public void start(Stage stage) throws IOException {
        scene = new Scene(loadFXML("primary"), 1500, 800);
        scene.getStylesheets().add(App.class.getResource("../vista/css/estilos.css").toExternalForm());
        stage.setScene(scene);
        stage.show();
        
        stage.setOnCloseRequest(ev->{
            ev.consume();
            
            Alert alert = new Alert(Alert.AlertType.CONFIRMATION);
            alert.setTitle("Atención ");
            alert.setContentText("desea salir de la aplicación ?");
            
            if (alert.showAndWait().get().equals(ButtonType.OK)) {
                    stage.close();
                    Platform.exit();
            }
            });
            
    }
   
    static void setRoot(String fxml) throws IOException {
        scene.setRoot(loadFXML(fxml));
    }
    
    //metodo para cambiar el contenido de la escena
    static void changeRoot(Parent rootNode) {
        scene.setRoot(rootNode);
    }
    private static Parent loadFXML(String fxml) throws IOException {
 
         FXMLLoader fxmlLoader = new FXMLLoader(App.class.getResource("../vista/"+fxml + ".fxml"));
        
        return fxmlLoader.load();
    }

    public static void main(String[] args) {
        launch();
    }

}