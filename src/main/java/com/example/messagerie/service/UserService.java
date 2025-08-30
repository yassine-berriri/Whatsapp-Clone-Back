package com.example.messagerie.service;

import com.example.messagerie.dto.ConversationSummaryDto;
import com.example.messagerie.dto.UserDto;
import com.example.messagerie.model.ChatMessage;
import com.example.messagerie.model.User;
import com.example.messagerie.repository.ChatMessageRepository;
import com.example.messagerie.repository.UserRepository;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class UserService {

    UserRepository userRepository;

    ChatMessageRepository chatMessageRepository;

    UserService(UserRepository userRepository, ChatMessageRepository chatMessageRepository){
        this.userRepository = userRepository;
        this.chatMessageRepository = chatMessageRepository;
    }

    public UserDto findByName(String name){
        User user =  userRepository.findByUsername(name).orElse(null);

        if (user == null) {
            return null;
        }

        UserDto userDto = new UserDto();
        userDto.setId(user.getId());
        userDto.setUsername(user.getUsername());
        userDto.setRole(user.getRole());


        List<ConversationSummaryDto> conversationSummaryDto = getUserConversations(user.getId());

        userDto.setConversationSummaryDto(conversationSummaryDto);

        return userDto;
    }

    public UserDto createUser(String name) {
        User user = new User();
        UserDto userDto = new UserDto();
        user.setUsername(name);
        userDto.setUsername(name);

        if (user.getUsername().equals("admin")){
            user.setRole("admin");
            userDto.setRole("admin");

        }
        else {
            user.setRole("user");
            userDto.setRole("user");
        }
        this.userRepository.save(user);
        Optional<User> userByName = this.userRepository.findByUsername(name);
        userByName.ifPresent(value -> userDto.setId(value.getId()));
        return userDto;
    }


    public User findUserById(Long id){

        return this.userRepository.findById(id).orElse(null);
    }



    public List<ConversationSummaryDto> getUserConversations(Long userId) {
        List<ChatMessage> messages = chatMessageRepository.findAllMessagesByUser(userId);

        if (messages == null || messages.isEmpty()) {
            return Collections.emptyList();
        }

        // Regrouper les messages par autre utilisateur (distinct de userId)
        Map<Long, List<ChatMessage>> groupedMessages = new LinkedHashMap<>();

        for (ChatMessage msg : messages) {
            User other = msg.getSender().getId().equals(userId) ? msg.getReceiver() : msg.getSender();
            groupedMessages
                    .computeIfAbsent(other.getId(), k -> new ArrayList<>())
                    .add(msg);
        }

        List<ConversationSummaryDto> summaries = new ArrayList<>();

        for (Map.Entry<Long, List<ChatMessage>> entry : groupedMessages.entrySet()) {
            List<ChatMessage> convMessages = entry.getValue();
            convMessages.sort(Comparator.comparing(ChatMessage::getTimestamp)); // Chronologique

            ChatMessage lastMessage = convMessages.get(convMessages.size() - 1);
            User other = lastMessage.getSender().getId().equals(userId) ? lastMessage.getReceiver() : lastMessage.getSender();

            ConversationSummaryDto dto = new ConversationSummaryDto();
            dto.setUserId(other.getId());
            dto.setUsername(other.getUsername());
            dto.setLastMessage(lastMessage.getContent());
            dto.setTimestamp(lastMessage.getTimestamp());
            dto.setAllMessages(convMessages);

            summaries.add(dto);
        }

        return summaries;
    }



}
