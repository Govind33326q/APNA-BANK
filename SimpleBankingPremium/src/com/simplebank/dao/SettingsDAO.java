package com.simplebank.dao;

import com.simplebank.model.BankSettings;
import com.simplebank.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class SettingsDAO {
    private void ensureTable(Connection con) throws Exception {
        String createSql = "CREATE TABLE IF NOT EXISTS bank_settings (" +
                "id INT PRIMARY KEY DEFAULT 1, " +
                "bank_name VARCHAR(120) NOT NULL DEFAULT 'Aurora Bank', " +
                "logo_path VARCHAR(255), " +
                "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                "CHECK (id = 1))";
        try (Statement st = con.createStatement()) {
            st.execute(createSql);
            st.executeUpdate("INSERT INTO bank_settings(id, bank_name, logo_path) " +
                    "VALUES(1, 'Aurora Bank', NULL) ON CONFLICT (id) DO NOTHING");
        }
    }

    public BankSettings getSettings() {
        BankSettings settings = new BankSettings();
        settings.setBankName("Aurora Bank");
        settings.setLogoPath(null);

        String sql = "SELECT bank_name, logo_path FROM bank_settings WHERE id = 1";
        try (Connection con = DBConnection.getConnection()) {
            ensureTable(con);
            try (PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    settings.setBankName(rs.getString("bank_name"));
                    settings.setLogoPath(rs.getString("logo_path"));
                }
            }
        } catch (Throwable ignored) {
            // Default settings are used before DB setup or if the JDBC driver is missing.
        }
        return settings;
    }

    public void updateSettings(String bankName, String logoPath) throws Exception {
        String sql = "INSERT INTO bank_settings(id, bank_name, logo_path, updated_at) " +
                "VALUES(1, ?, ?, CURRENT_TIMESTAMP) " +
                "ON CONFLICT (id) DO UPDATE SET bank_name = EXCLUDED.bank_name, " +
                "logo_path = COALESCE(EXCLUDED.logo_path, bank_settings.logo_path), " +
                "updated_at = CURRENT_TIMESTAMP";
        try (Connection con = DBConnection.getConnection()) {
            ensureTable(con);
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, bankName);
                ps.setString(2, logoPath);
                ps.executeUpdate();
            }
        }
    }
}
