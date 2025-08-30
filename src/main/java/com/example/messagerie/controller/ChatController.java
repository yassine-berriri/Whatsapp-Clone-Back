package com.example.messagerie.controller;

import com.example.messagerie.dto.ChatMessageDto;
import com.example.messagerie.dto.ChatMessageResponseDto;
import com.example.messagerie.model.ChatMessage;
import com.example.messagerie.service.ChatService;
import com.example.messagerie.service.UserService;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.Message;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

import java.time.LocalDateTime;
import java.util.Base64;

@Controller
public class ChatController {

    @Autowired
    private ObjectMapper objectMapper;


    private UserService userService;


    private ChatService chatService;

    public ChatController(ChatService chatService, UserService userService){
        this.userService = userService;
        this.chatService = chatService;
    }

    @MessageMapping("/chat.send")
    @SendTo("/topic/public")
    public ChatMessageResponseDto sendMessage(Message<?> rawMessage) throws Exception {
        byte[] payloadBytes = (byte[]) rawMessage.getPayload(); // 👈 on récupère les octets
        String json = new String(payloadBytes); // 👈 on convertit en String JSON

        ChatMessageDto messageDto = objectMapper.readValue(json, ChatMessageDto.class);

        ChatMessage message = new ChatMessage();
        message.setContent(messageDto.getContent());
        message.setTimestamp(LocalDateTime.now());
        message.setSender(userService.findUserById(messageDto.getSender_id()));
        message.setReceiver(userService.findUserById(messageDto.getReceiver_id()));
        chatService.saveMessage(message);

        ChatMessageResponseDto messageResponse = new ChatMessageResponseDto();
        messageResponse.setContent(messageDto.getContent());
        messageResponse.setSender(userService.findUserById(messageDto.getSender_id()).getUsername());
        messageResponse.setTimestamp(message.getTimestamp());
        messageResponse.setSender_id(messageDto.getSender_id());
        messageResponse.setReceiver_id(messageDto.getReceiver_id());
        return messageResponse;
    }

}
