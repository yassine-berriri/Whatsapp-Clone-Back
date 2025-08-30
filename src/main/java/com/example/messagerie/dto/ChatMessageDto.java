package com.example.messagerie.dto;

import com.example.messagerie.model.User;
import jakarta.persistence.*;
import lombok.Data;
import lombok.ToString;

import java.time.LocalDateTime;

@Data
@ToString
public class ChatMessageDto {
    private Long sender_id;
    private Long receiver_id;
    private String content;
}
