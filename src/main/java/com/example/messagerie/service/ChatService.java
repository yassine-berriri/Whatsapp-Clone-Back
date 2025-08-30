package com.example.messagerie.service;

import com.example.messagerie.dto.ConversationSummaryDto;
import com.example.messagerie.model.ChatMessage;
import com.example.messagerie.repository.ChatMessageRepository;
import com.example.messagerie.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Service
public class ChatService {

    ChatMessageRepository chatMessageRepository;

    ChatService(ChatMessageRepository chatMessageRepository){
        this.chatMessageRepository = chatMessageRepository;
    }

    public void saveMessage(ChatMessage chatMessage){
        this.chatMessageRepository.save(chatMessage);
    }

    public List<ChatMessage> getSentMessages(Long userId) {
        return chatMessageRepository.findBySender_Id(userId);
    }

    public List<ChatMessage> getReceivedMessages(Long userId) {
        return chatMessageRepository.findByReceiver_Id(userId);
    }



}
