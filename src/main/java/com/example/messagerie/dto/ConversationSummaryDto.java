package com.example.messagerie.dto;

import com.example.messagerie.model.ChatMessage;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.List;

@Data
public class ConversationSummaryDto {
    private Long userId;
    private String username;
    private String lastMessage;
    private LocalDateTime timestamp;
    private List<ChatMessage> allMessages; // Optionnel
}

