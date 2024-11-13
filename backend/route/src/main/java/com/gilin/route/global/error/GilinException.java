package com.gilin.route.global.error;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.http.HttpStatus;

@Getter
@AllArgsConstructor
public class GilinException extends RuntimeException {
    private final HttpStatus status;
    private final String message;
}
