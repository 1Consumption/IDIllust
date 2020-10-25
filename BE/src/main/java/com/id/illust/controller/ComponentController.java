package com.id.illust.controller;

import com.id.illust.network.response.ChoiceApiResponse;
import com.id.illust.network.response.ComponentApiResponse;
import com.id.illust.service.ComponentService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/categories/{categoryId}/components")
public class ComponentController {

    private final ComponentService componentService;

    public ComponentController(ComponentService componentService) {
        this.componentService = componentService;
    }

    @GetMapping("")
    public ComponentApiResponse getComponents(@PathVariable Long categoryId) {
        return componentService.readAll(categoryId);
    }

    @GetMapping("/{componentId}")
    public ChoiceApiResponse getDefaultUrl(@PathVariable Long categoryId, @PathVariable Long componentId) {
        return componentService.readFirst(categoryId, componentId);
    }
}
