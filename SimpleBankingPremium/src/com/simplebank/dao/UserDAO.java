package com.simplebank.dao;

import com.simplebank.model.User;
import com.simplebank.util.AccountNumberGenerator;
import com.simplebank.util.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    public void ensureStaffRoleSupported() {
        try (Connection con = DBConnection.getConnection(); Statement st = con.createStatement()) {
            st.executeUpdate("ALTER TABLE users DROP CONSTRAINT IF EXISTS users_role_check");
            st.executeUpdate("ALTER TABLE users ADD CONSTRAINT users_role_check CHECK (role IN ('ADMIN', 'STAFF', 'CUSTOMER', 'REMOVED'))");
        } catch (Exception ignored) {
            // The table may not exist yet during first project setup.
        }
    }

    public boolean registerCustomer(User user, String accountType) throws Exception {
        String insertUser = "INSERT INTO users(full_name, email, password, role, phone, address) VALUES(?,?,?,?,?,?)";
        String insertAccount = "INSERT INTO accounts(user_id, account_number, account_type, balance, status) VALUES(?,?,?,?,?)";

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);
            try (PreparedStatement userPs = con.prepareStatement(insertUser, Statement.RETURN_GENERATED_KEYS)) {
                userPs.setString(1, user.getFullName());
                userPs.setString(2, user.getEmail());
                userPs.setString(3, user.getPassword());
                userPs.setString(4, "CUSTOMER");
                userPs.setString(5, user.getPhone());
                userPs.setString(6, user.getAddress());
                userPs.executeUpdate();

                int userId;
                try (ResultSet rs = userPs.getGeneratedKeys()) {
                    if (!rs.next()) {
                        con.rollback();
                        return false;
                    }
                    userId = rs.getInt(1);
                }

                try (PreparedStatement accountPs = con.prepareStatement(insertAccount)) {
                    accountPs.setInt(1, userId);
                    accountPs.setString(2, AccountNumberGenerator.generate(userId));
                    accountPs.setString(3, accountType);
                    accountPs.setBigDecimal(4, BigDecimal.ZERO);
                    accountPs.setString(5, "PENDING");
                    accountPs.executeUpdate();
                }

                con.commit();
                return true;
            } catch (Exception e) {
                con.rollback();
                throw e;
            } finally {
                con.setAutoCommit(true);
            }
        }
    }

    public User login(String email, String hashedPassword) throws Exception {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, hashedPassword);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public User getUserById(int userId) throws Exception {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public boolean updateProfile(User user) throws Exception {
        String sql = "UPDATE users SET full_name = ?, phone = ?, address = ? WHERE user_id = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getAddress());
            ps.setInt(4, user.getUserId());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean changePassword(int userId, String newHashedPassword) throws Exception {
        String sql = "UPDATE users SET password = ? WHERE user_id = ?";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newHashedPassword);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    public List<User> getCustomers(String keyword) throws Exception {
        List<User> customers = new ArrayList<>();
        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        String sql = hasKeyword
                ? "SELECT * FROM users WHERE role = 'CUSTOMER' AND (LOWER(full_name) LIKE ? OR LOWER(email) LIKE ? OR phone LIKE ?) ORDER BY user_id DESC"
                : "SELECT * FROM users WHERE role = 'CUSTOMER' ORDER BY user_id DESC";

        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            if (hasKeyword) {
                String search = "%" + keyword.trim().toLowerCase() + "%";
                ps.setString(1, search);
                ps.setString(2, search);
                ps.setString(3, "%" + keyword.trim() + "%");
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    customers.add(map(rs));
                }
            }
        }
        return customers;
    }

    public int countCustomers() throws Exception {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'CUSTOMER'";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public List<User> getStaffMembers() throws Exception {
        ensureStaffRoleSupported();
        List<User> staff = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role IN ('ADMIN', 'STAFF') ORDER BY role, user_id DESC";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                staff.add(map(rs));
            }
        }
        return staff;
    }

    public boolean createStaff(User user) throws Exception {
        ensureStaffRoleSupported();
        String sql = "INSERT INTO users(full_name, email, password, role, phone, address) VALUES(?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, "STAFF");
            ps.setString(5, user.getPhone());
            ps.setString(6, user.getAddress());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean removeStaff(int userId) throws Exception {
        String sql = "DELETE FROM users WHERE user_id = ? AND role = 'STAFF'";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        }
    }


    public boolean promoteCustomerToStaff(int userId) throws Exception {
        ensureStaffRoleSupported();
        String sql = "UPDATE users SET role = 'STAFF' WHERE user_id = ? AND role = 'CUSTOMER'";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean removeCustomer(int userId) throws Exception {
        ensureStaffRoleSupported();
        String sql = "UPDATE users SET role = 'REMOVED' WHERE user_id = ? AND role = 'CUSTOMER'";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        }
    }

    public int countStaff() throws Exception {
        ensureStaffRoleSupported();
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'STAFF'";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private User map(ResultSet rs) throws Exception {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setRole(rs.getString("role"));
        user.setPhone(rs.getString("phone"));
        user.setAddress(rs.getString("address"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        return user;
    }
}
