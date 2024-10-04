package com.ssafy.a303.notification;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import jakarta.annotation.PostConstruct;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;

@Component
public class FcmInitializer {

    private static final String SCOPES = "https://www.googleapis.com/auth/firebase.messaging";

    @Value("${firebase.key-path}")
    String fcmKeyPath;

    @PostConstruct
    public void getFcmCredential(){
        try {
            InputStream refreshToken = new ClassPathResource(fcmKeyPath).getInputStream();
            FirebaseOptions options = FirebaseOptions.builder()
                    .setCredentials(GoogleCredentials.fromStream(refreshToken)).build();
            FirebaseApp.initializeApp(options);
        } catch (IOException e) {
            throw new RuntimeException(e.getMessage());
        }
    }

}