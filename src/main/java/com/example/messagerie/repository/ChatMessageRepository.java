package com.example.messagerie.repository;

import com.example.messagerie.model.ChatMessage;
import com.example.messagerie.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface ChatMessageRepository  extends JpaRepository<ChatMessage, Long> {
    List<ChatMessage> findBySenderOrReceiver(User sender, User receiver);
    List<ChatMessage> findBySenderAndReceiver(User sender, User receiver);


    // Messages envoyés par un utilisateur
    List<ChatMessage> findBySender_Id(Long senderId);

    // Messages reçus par un utilisateur
    List<ChatMessage> findByReceiver_Id(Long receiverId);

    @Query("""
    SELECT m FROM ChatMessage m
    WHERE m.sender.id = :userId OR m.receiver.id = :userId
    ORDER BY m.timestamp DESC
""")
    List<ChatMessage> findAllMessagesByUser(@Param("userId") Long userId);

}
