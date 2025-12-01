package com.pm.auth_service.service;

import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.pm.auth_service.dto.LoginRequestDTO;
import com.pm.auth_service.model.User;
import com.pm.auth_service.util.JwtUtil;

import io.jsonwebtoken.JwtException;

@Service
public class AuthService {

    private static final Logger logger = LoggerFactory.getLogger(AuthService.class);
    private final UserService userService;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;

    public AuthService(UserService userService, PasswordEncoder passwordEncoder, JwtUtil jwtUtil) {
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
        this.jwtUtil = jwtUtil;
    }

    public Optional<String> authenticate(LoginRequestDTO loginRequestDTO) {
        logger.info("Authentication attempt for email: {}", loginRequestDTO.getEmail());
        Optional<User> userOpt = userService.findByEmail(loginRequestDTO.getEmail());

        if (userOpt.isEmpty()) {
            logger.warn("User not found: {}", loginRequestDTO.getEmail());
            return Optional.empty();
        }

        User user = userOpt.get();
        logger.info("User found: {}, checking password", user.getEmail());
        boolean passwordMatches = passwordEncoder.matches(loginRequestDTO.getPassword(), user.getPassword());
        logger.info("Password matches: {}", passwordMatches);

        if (passwordMatches) {
            String token = jwtUtil.generateToken(user.getEmail(), user.getRole());
            logger.info("Token generated for user: {}", user.getEmail());
            return Optional.of(token);
        }

        return Optional.empty();
    }

    public boolean validateToken(String token) {
        try {
            jwtUtil.validateToken(token);
            return true;
        } catch (JwtException e) {
            return false;
        }
    }

}
