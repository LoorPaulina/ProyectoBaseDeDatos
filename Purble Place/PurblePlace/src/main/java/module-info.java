module com.mycompany.purbleplace {
    requires javafx.controls;
    requires javafx.fxml;

    opens com.mycompany.purbleplace to javafx.fxml;
    exports com.mycompany.purbleplace;
}
