package com.id.illust.controller;

import com.id.illust.service.ColorService;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ColorController {

    private final ColorService colorService;

    public ColorController(ColorService colorService) {
        this.colorService = colorService;
    }


}
