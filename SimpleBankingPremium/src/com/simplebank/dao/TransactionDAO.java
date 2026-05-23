package com.simplebank.dao;

import com.simplebank.model.Transaction;
import com.simplebank.util.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class TransactionDAO {
    public void deposit(int userId, BigDecimal amount) throws Exception {
        String lockSql = "SELECT account_id, status FROM accounts WHERE user_id = ? FOR UPDATE";
        String updateSql = "UPDATE accounts SET balance = balance + ? WHERE account_id = ?";
        try (Connection con = DBConnection.getConnection()) {
            ensureReversalColumns(con);
            con.setAutoCommit(false);
            try {
                int accountId;
                String status;
                try (PreparedStatement ps = con.prepareStatement(lockSql)) {
                    ps.setInt(1, userId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) throw new Exception("Account not found");
                        accountId = rs.getInt("account_id");
                        status = rs.getString("status");
                    }
                }
                if (!"ACTIVE".equals(status)) throw new Exception("Account is not active");
                try (PreparedStatement ps = con.prepareStatement(updateSql)) {
                    ps.setBigDecimal(1, amount);
                    ps.setInt(2, accountId);
                    ps.executeUpdate();
                }
                insertTransaction(con, null, accountId, "DEPOSIT", amount, "Cash deposit", null);
                con.commit();
            } catch (Exception e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }

    public void withdraw(int userId, BigDecimal amount) throws Exception {
        String lockSql = "SELECT account_id, balance, status FROM accounts WHERE user_id = ? FOR UPDATE";
        String updateSql = "UPDATE accounts SET balance = balance - ? WHERE account_id = ?";
        try (Connection con = DBConnection.getConnection()) {
            ensureReversalColumns(con);
            con.setAutoCommit(false);
            try {
                int accountId;
                BigDecimal balance;
                String status;
                try (PreparedStatement ps = con.prepareStatement(lockSql)) {
                    ps.setInt(1, userId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) throw new Exception("Account not found");
                        accountId = rs.getInt("account_id");
                        balance = rs.getBigDecimal("balance");
                        status = rs.getString("status");
                    }
                }
                if (!"ACTIVE".equals(status)) throw new Exception("Account is not active");
                if (balance.compareTo(amount) < 0) throw new Exception("Insufficient balance");
                try (PreparedStatement ps = con.prepareStatement(updateSql)) {
                    ps.setBigDecimal(1, amount);
                    ps.setInt(2, accountId);
                    ps.executeUpdate();
                }
                insertTransaction(con, accountId, null, "WITHDRAW", amount, "Cash withdrawal", null);
                con.commit();
            } catch (Exception e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }

    public void transfer(int userId, String receiverAccountNumber, BigDecimal amount) throws Exception {
        String senderSql = "SELECT account_id, account_number, balance, status FROM accounts WHERE user_id = ? FOR UPDATE";
        String receiverSql = "SELECT account_id, status FROM accounts WHERE account_number = ? FOR UPDATE";
        String debitSql = "UPDATE accounts SET balance = balance - ? WHERE account_id = ?";
        String creditSql = "UPDATE accounts SET balance = balance + ? WHERE account_id = ?";
        try (Connection con = DBConnection.getConnection()) {
            ensureReversalColumns(con);
            con.setAutoCommit(false);
            try {
                int senderId;
                String senderNumber;
                BigDecimal senderBalance;
                String senderStatus;
                try (PreparedStatement ps = con.prepareStatement(senderSql)) {
                    ps.setInt(1, userId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) throw new Exception("Sender account not found");
                        senderId = rs.getInt("account_id");
                        senderNumber = rs.getString("account_number");
                        senderBalance = rs.getBigDecimal("balance");
                        senderStatus = rs.getString("status");
                    }
                }
                if (!"ACTIVE".equals(senderStatus)) throw new Exception("Your account is not active");
                if (senderNumber.equals(receiverAccountNumber)) throw new Exception("Cannot transfer to same account");
                if (senderBalance.compareTo(amount) < 0) throw new Exception("Insufficient balance");

                int receiverId;
                String receiverStatus;
                try (PreparedStatement ps = con.prepareStatement(receiverSql)) {
                    ps.setString(1, receiverAccountNumber);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) throw new Exception("Receiver account not found");
                        receiverId = rs.getInt("account_id");
                        receiverStatus = rs.getString("status");
                    }
                }
                if (!"ACTIVE".equals(receiverStatus)) throw new Exception("Receiver account is not active");
                try (PreparedStatement ps = con.prepareStatement(debitSql)) {
                    ps.setBigDecimal(1, amount);
                    ps.setInt(2, senderId);
                    ps.executeUpdate();
                }
                try (PreparedStatement ps = con.prepareStatement(creditSql)) {
                    ps.setBigDecimal(1, amount);
                    ps.setInt(2, receiverId);
                    ps.executeUpdate();
                }
                insertTransaction(con, senderId, receiverId, "TRANSFER", amount, "Money transfer", null);
                con.commit();
            } catch (Exception e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }

    public void reverseTransaction(int transactionId) throws Exception {
        try (Connection con = DBConnection.getConnection()) {
            ensureReversalColumns(con);
            con.setAutoCommit(false);
            try {
                Transaction t = getTransactionForUpdate(con, transactionId);
                if (t == null) throw new Exception("Transaction not found");
                if (t.isReverted()) throw new Exception("Transaction already reverted");
                if (t.getReversedTransactionId() != null) throw new Exception("Reversal entry cannot be reverted");

                if ("DEPOSIT".equals(t.getTransactionType())) {
                    ensureBalance(con, t.getToAccountId(), t.getAmount());
                    updateBalance(con, t.getToAccountId(), t.getAmount().negate());
                    insertTransaction(con, t.getToAccountId(), null, "DEPOSIT", t.getAmount(), "Reversal of deposit #" + transactionId, transactionId);
                } else if ("WITHDRAW".equals(t.getTransactionType())) {
                    updateBalance(con, t.getFromAccountId(), t.getAmount());
                    insertTransaction(con, null, t.getFromAccountId(), "WITHDRAW", t.getAmount(), "Reversal of withdrawal #" + transactionId, transactionId);
                } else if ("TRANSFER".equals(t.getTransactionType())) {
                    ensureBalance(con, t.getToAccountId(), t.getAmount());
                    updateBalance(con, t.getToAccountId(), t.getAmount().negate());
                    updateBalance(con, t.getFromAccountId(), t.getAmount());
                    insertTransaction(con, t.getToAccountId(), t.getFromAccountId(), "TRANSFER", t.getAmount(), "Reversal of transfer #" + transactionId, transactionId);
                } else {
                    throw new Exception("Unsupported transaction type");
                }

                try (PreparedStatement ps = con.prepareStatement("UPDATE transactions SET is_reverted = TRUE WHERE transaction_id = ?")) {
                    ps.setInt(1, transactionId);
                    ps.executeUpdate();
                }
                con.commit();
            } catch (Exception e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }

    private Transaction getTransactionForUpdate(Connection con, int transactionId) throws Exception {
        String sql = "SELECT * FROM transactions WHERE transaction_id = ? FOR UPDATE";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, transactionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                Transaction t = new Transaction();
                t.setTransactionId(rs.getInt("transaction_id"));
                int fromId = rs.getInt("from_account_id");
                t.setFromAccountId(rs.wasNull() ? null : fromId);
                int toId = rs.getInt("to_account_id");
                t.setToAccountId(rs.wasNull() ? null : toId);
                t.setTransactionType(rs.getString("transaction_type"));
                t.setAmount(rs.getBigDecimal("amount"));
                t.setDescription(rs.getString("description"));
                t.setReverted(rs.getBoolean("is_reverted"));
                return t;
            }
        }
    }

    private void ensureBalance(Connection con, Integer accountId, BigDecimal amount) throws Exception {
        if (accountId == null) throw new Exception("Account not found for reversal");
        String sql = "SELECT balance FROM accounts WHERE account_id = ? FOR UPDATE";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) throw new Exception("Account not found for reversal");
                if (rs.getBigDecimal("balance").compareTo(amount) < 0) {
                    throw new Exception("Reversal blocked: receiver has insufficient balance");
                }
            }
        }
    }

    private void updateBalance(Connection con, Integer accountId, BigDecimal amount) throws Exception {
        if (accountId == null) throw new Exception("Account not found for reversal");
        try (PreparedStatement ps = con.prepareStatement("UPDATE accounts SET balance = balance + ? WHERE account_id = ?")) {
            ps.setBigDecimal(1, amount);
            ps.setInt(2, accountId);
            ps.executeUpdate();
        }
    }

    public List<Transaction> getTransactionsByUserId(int userId) throws Exception {
        String sql = "SELECT t.*, fa.account_number AS from_account_number, ta.account_number AS to_account_number " +
                "FROM transactions t " +
                "LEFT JOIN accounts fa ON t.from_account_id = fa.account_id " +
                "LEFT JOIN accounts ta ON t.to_account_id = ta.account_id " +
                "WHERE t.from_account_id IN (SELECT account_id FROM accounts WHERE user_id = ?) " +
                "OR t.to_account_id IN (SELECT account_id FROM accounts WHERE user_id = ?) " +
                "ORDER BY t.transaction_id DESC";
        List<Transaction> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            ensureReversalColumns(con);
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setInt(2, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) list.add(map(rs));
                }
            }
        }
        return list;
    }

    public List<Transaction> getAllTransactions() throws Exception {
        String sql = "SELECT t.*, fa.account_number AS from_account_number, ta.account_number AS to_account_number, " +
                "COALESCE(u1.full_name, u2.full_name, 'Bank') AS customer_name " +
                "FROM transactions t " +
                "LEFT JOIN accounts fa ON t.from_account_id = fa.account_id " +
                "LEFT JOIN users u1 ON fa.user_id = u1.user_id " +
                "LEFT JOIN accounts ta ON t.to_account_id = ta.account_id " +
                "LEFT JOIN users u2 ON ta.user_id = u2.user_id " +
                "ORDER BY t.transaction_id DESC";
        List<Transaction> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            ensureReversalColumns(con);
            try (PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    public int countTransactions() throws Exception {
        try (Connection con = DBConnection.getConnection()) {
            ensureReversalColumns(con);
            try (PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM transactions"); ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    private void insertTransaction(Connection con, Integer fromAccountId, Integer toAccountId, String type, BigDecimal amount, String description, Integer reversedTransactionId) throws Exception {
        String sql = "INSERT INTO transactions(from_account_id, to_account_id, transaction_type, amount, description, reversed_transaction_id) VALUES(?,?,?,?,?,?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            if (fromAccountId == null) ps.setNull(1, Types.INTEGER); else ps.setInt(1, fromAccountId);
            if (toAccountId == null) ps.setNull(2, Types.INTEGER); else ps.setInt(2, toAccountId);
            ps.setString(3, type);
            ps.setBigDecimal(4, amount);
            ps.setString(5, description);
            if (reversedTransactionId == null) ps.setNull(6, Types.INTEGER); else ps.setInt(6, reversedTransactionId);
            ps.executeUpdate();
        }
    }

    private void ensureReversalColumns(Connection con) throws Exception {
        try (Statement st = con.createStatement()) {
            st.executeUpdate("ALTER TABLE transactions ADD COLUMN IF NOT EXISTS is_reverted BOOLEAN DEFAULT FALSE");
            st.executeUpdate("ALTER TABLE transactions ADD COLUMN IF NOT EXISTS reversed_transaction_id INT");
        }
    }

    private Transaction map(ResultSet rs) throws Exception {
        Transaction t = new Transaction();
        t.setTransactionId(rs.getInt("transaction_id"));
        int fromId = rs.getInt("from_account_id");
        t.setFromAccountId(rs.wasNull() ? null : fromId);
        int toId = rs.getInt("to_account_id");
        t.setToAccountId(rs.wasNull() ? null : toId);
        t.setTransactionType(rs.getString("transaction_type"));
        t.setAmount(rs.getBigDecimal("amount"));
        t.setDescription(rs.getString("description"));
        t.setCreatedAt(rs.getTimestamp("created_at"));
        t.setFromAccountNumber(rs.getString("from_account_number"));
        t.setToAccountNumber(rs.getString("to_account_number"));
        try { t.setCustomerName(rs.getString("customer_name")); } catch (Exception ignored) { }
        try { t.setReverted(rs.getBoolean("is_reverted")); } catch (Exception ignored) { }
        try {
            int reversedId = rs.getInt("reversed_transaction_id");
            t.setReversedTransactionId(rs.wasNull() ? null : reversedId);
        } catch (Exception ignored) { }
        return t;
    }
}
