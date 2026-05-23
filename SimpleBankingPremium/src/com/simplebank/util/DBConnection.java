package com.simplebank.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:postgresql://localhost:5432/BMS";
    private static final String USERNAME = "postgres";
    private static final String PASSWORD = "root"; // change this to your pgAdmin/PostgreSQL password

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("PostgreSQL JDBC driver not found. Copy postgresql-42.x.x.jar into WebContent/WEB-INF/lib and add it to Build Path.", e);
        }
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}
