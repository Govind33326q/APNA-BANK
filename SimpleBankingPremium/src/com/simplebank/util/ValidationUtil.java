package com.simplebank.util;

import java.math.BigDecimal;

public class ValidationUtil {
    public static boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    public static boolean isValidEmail(String email) {
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");
    }

    public static BigDecimal parseAmount(String value) {
        try {
            BigDecimal amount = new BigDecimal(value.trim());
            return amount.compareTo(BigDecimal.ZERO) > 0 ? amount : null;
        } catch (Exception e) {
            return null;
        }
    }

    public static boolean isAccountNumber(String value) {
        return value != null && value.matches("[0-9]{6,18}");
    }
}
