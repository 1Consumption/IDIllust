package com.id.illust.controller;

import com.id.illust.network.response.ColorApiResponse;
import com.id.illust.service.ColorService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/categories/{categoryId}/components/{componentId}/colors")
public class ColorController {

    private final ColorService colorService;

    public ColorController(ColorService colorService) {
        this.colorService = colorService;
    }

    @GetMapping("")
    public ColorApiResponse getColors(@PathVariable Long categoryId, @PathVariable Long componentId) {
        return colorService.readAll(categoryId, componentId);
    }
}
