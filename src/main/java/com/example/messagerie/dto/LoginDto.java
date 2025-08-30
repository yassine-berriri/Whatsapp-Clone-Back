package com.example.messagerie.dto;

import jakarta.validation.constraints.Size;
import lombok.Data;
import lombok.NonNull;
import lombok.ToString;

@Data
@ToString
public class LoginDto {


    @NonNull
    @Size(max = 50)
    private String name;



}
