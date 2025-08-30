package com.example.messagerie.dto;

import lombok.Data;
import lombok.ToString;

import java.time.LocalDateTime;

@Data
@ToString
public class ChatMessageResponseDto {
    private Long sender_id;
    private Long receiver_id;
    private String content;

    private String sender;
    private LocalDateTime timestamp;
}
