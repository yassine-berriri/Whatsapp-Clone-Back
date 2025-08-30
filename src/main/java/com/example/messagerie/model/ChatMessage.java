package com.example.messagerie.model;


import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Data
@ToString
@NoArgsConstructor
@Entity
public class ChatMessage {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO) // ou AUTO
    private Long id;
    private String content;

    private LocalDateTime timestamp;

    @ManyToOne
    @JoinColumn(name = "sender_id")
    private User sender;

    @ManyToOne
    @JoinColumn(name = "receiver_id")
    private User receiver;


}
