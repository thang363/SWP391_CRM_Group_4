package com.crm.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

public class PasswordUtil {
    
    private static final int SALT_LENGTH = 16;
    private static final String ALGORITHM = "SHA-256";
    private static final String SEPARATOR = ":";
    
    public static String hashPassword(String password) {
        try {
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[SALT_LENGTH];
            random.nextBytes(salt);
            
            String hash = hashWithSalt(password, salt);
            String encodedSalt = Base64.getEncoder().encodeToString(salt);
            
            return encodedSalt + SEPARATOR + hash;
            
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password: " + e.getMessage(), e);
        }
    }
    
    public static boolean verifyPassword(String password, String storedHash) {
        if (password == null || storedHash == null) {
            return false;
        }
        
        try {
            String[] parts = storedHash.split(SEPARATOR);
            if (parts.length != 2) {
                return false;
            }
            
            byte[] salt = Base64.getDecoder().decode(parts[0]);
            String expectedHash = parts[1];
            
            String actualHash = hashWithSalt(password, salt);
            
            return MessageDigest.isEqual(
                expectedHash.getBytes(StandardCharsets.UTF_8),
                actualHash.getBytes(StandardCharsets.UTF_8)
            );
            
        } catch (Exception e) {
            System.err.println("Error verifying password: " + e.getMessage());
            return false;
        }
    }
    
    private static String hashWithSalt(String password, byte[] salt) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance(ALGORITHM);
        md.update(salt);
        byte[] hashedPassword = md.digest(password.getBytes(StandardCharsets.UTF_8));
        return Base64.getEncoder().encodeToString(hashedPassword);
    }
    
    public static String generateRandomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
        SecureRandom random = new SecureRandom();
        StringBuilder password = new StringBuilder();
        
        for (int i = 0; i < length; i++) {
            password.append(chars.charAt(random.nextInt(chars.length())));
        }
        
        return password.toString();
    }
    
    public static boolean meetsRequirements(String password) {
        if (password == null || password.length() < 6) {
            return false;
        }
        
        boolean hasLetter = false;
        boolean hasDigit = false;
        
        for (char c : password.toCharArray()) {
            if (Character.isLetter(c)) hasLetter = true;
            if (Character.isDigit(c)) hasDigit = true;
        }
        
        return hasLetter && hasDigit;
    }
    
    private PasswordUtil() {
        throw new AssertionError();
    }
}
