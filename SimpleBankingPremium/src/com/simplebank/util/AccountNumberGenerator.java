package com.simplebank.util;

public class AccountNumberGenerator {
    public static String generate(int userId) {
        return String.valueOf(100000000000L + userId);
    }
}
