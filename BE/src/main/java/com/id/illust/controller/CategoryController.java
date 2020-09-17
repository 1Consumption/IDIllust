package com.id.illust.controller;

import com.id.illust.network.response.CategoryApiResponse;
import com.id.illust.service.CategoryService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class CategoryController {

    private final CategoryService categoryService;

    public CategoryController(CategoryService categoryService) {
        this.categoryService = categoryService;
    }

    @GetMapping("/categories")
    public CategoryApiResponse getCategories() {
        return categoryService.readAll();
    }
}
