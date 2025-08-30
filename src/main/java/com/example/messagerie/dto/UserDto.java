package com.example.messagerie.dto;

import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import lombok.Data;

import java.util.List;

@Data
public class UserDto {


    Long id;
    String username;
    String role;

    List<ConversationSummaryDto> conversationSummaryDto;

}
