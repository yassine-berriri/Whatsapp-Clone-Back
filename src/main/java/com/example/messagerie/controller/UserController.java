package com.example.messagerie.controller;

import com.example.messagerie.dto.LoginDto;
import com.example.messagerie.dto.UserDto;
import com.example.messagerie.model.User;
import com.example.messagerie.service.UserService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@RestController
@CrossOrigin(origins = "*", maxAge = 3600)
@RequestMapping("/user")
public class UserController {


    private UserService userService;

    UserController(UserService userService){
        this.userService = userService;
    }

    @PostMapping()
    public ResponseEntity<UserDto> login(@RequestBody LoginDto loginDto){
        if (this.userService.findByName(loginDto.getName()) != null){
            return ResponseEntity.ok().body(this.userService.findByName(loginDto.getName()));
        }
        else {
            return ResponseEntity.ok().body(this.userService.createUser(loginDto.getName()));
        }

    }



}
