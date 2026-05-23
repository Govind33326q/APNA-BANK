package com.simplebank.dao;

import com.simplebank.model.Account;
import com.simplebank.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AccountDAO {
    public Account getAccountByUserId(int userId) throws Exception {
        String sql = "SELECT a.*, u.full_name, u.email FROM accounts a JOIN users u ON a.user_id = u.user_id WHERE a.user_id = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public List<Account> getAllAccounts(String status) throws Exception {
        List<Account> accounts = new ArrayList<>();
        boolean hasStatus = status != null && !status.trim().isEmpty() && !"ALL".equalsIgnoreCase(status);
        String sql = hasStatus
                ? "SELECT a.*, u.full_name, u.email FROM accounts a JOIN users u ON a.user_id = u.user_id WHERE a.status = ? ORDER BY a.account_id DESC"
                : "SELECT a.*, u.full_name, u.email FROM accounts a JOIN users u ON a.user_id = u.user_id ORDER BY a.account_id DESC";

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            if (hasStatus) {
                ps.setString(1, status.toUpperCase());
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    accounts.add(map(rs));
                }
            }
        }
        return accounts;
    }

    public boolean updateStatus(int accountId, String status) throws Exception {
        String sql = "UPDATE accounts SET status = ? WHERE account_id = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status.toUpperCase());
            ps.setInt(2, accountId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateAccountNumber(int accountId, String accountNumber) throws Exception {
        String checkSql = "SELECT account_id FROM accounts WHERE account_number = ? AND account_id <> ?";
        String updateSql = "UPDATE accounts SET account_number = ? WHERE account_id = ?";
        try (Connection con = DBConnection.getConnection()) {
            try (PreparedStatement check = con.prepareStatement(checkSql)) {
                check.setString(1, accountNumber);
                check.setInt(2, accountId);
                try (ResultSet rs = check.executeQuery()) {
                    if (rs.next()) {
                        throw new Exception("Account number already exists");
                    }
                }
            }
            try (PreparedStatement ps = con.prepareStatement(updateSql)) {
                ps.setString(1, accountNumber);
                ps.setInt(2, accountId);
                return ps.executeUpdate() > 0;
            }
        }
    }

    public boolean updateAccountType(int accountId, String accountType) throws Exception {
        String sql = "UPDATE accounts SET account_type = ? WHERE account_id = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, accountType.toUpperCase());
            ps.setInt(2, accountId);
            return ps.executeUpdate() > 0;
        }
    }

    public int countByStatus(String status) throws Exception {
        String sql = "SELECT COUNT(*) FROM accounts WHERE status = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status.toUpperCase());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public int countAllAccounts() throws Exception {
        String sql = "SELECT COUNT(*) FROM accounts";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private Account map(ResultSet rs) throws Exception {
        Account account = new Account();
        account.setAccountId(rs.getInt("account_id"));
        account.setUserId(rs.getInt("user_id"));
        account.setAccountNumber(rs.getString("account_number"));
        account.setAccountType(rs.getString("account_type"));
        account.setBalance(rs.getBigDecimal("balance"));
        account.setStatus(rs.getString("status"));
        account.setCreatedAt(rs.getTimestamp("created_at"));
        account.setCustomerName(rs.getString("full_name"));
        account.setCustomerEmail(rs.getString("email"));
        return account;
    }
}
