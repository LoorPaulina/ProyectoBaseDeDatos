module com.mycompany.purbleplace {
    requires javafx.controls;
    requires javafx.fxml;
    requires java.sql;

    opens com.mycompany.purbleplace to javafx.fxml;
    exports com.mycompany.purbleplace;
}
