package com.gilin.route.global.error;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@Slf4j
@ControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(GilinException.class)
    public ResponseEntity<?> handleException(GilinException e) {
        e.printStackTrace();
        return ResponseEntity.status(e.getStatus().value()).body(e.getMessage());
    }
}
