package com.id.illust.controller;

import com.id.illust.entity.Category;
import com.id.illust.entity.Color;
import com.id.illust.entity.Component;
import com.id.illust.network.response.CategoryApiResponse;
import com.id.illust.network.response.ComponentApiResponse;
import com.id.illust.network.response.EntryApiResponse;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.List;

@RestController
public class IllustController {

    @GetMapping("/entry")
    public EntryApiResponse getEntry() {
        return EntryApiResponse.builder()
                               .url("www.idillust.com")
                               .build();
    }

    @GetMapping("/categories")
    public CategoryApiResponse getCategories() {
        List<Category> categories = new ArrayList<>();
        categories.add(Category.builder()
                               .id(1L)
                               .name("hair")
                               .url("www.idillust.com")
                               .build());
        categories.add(Category.builder()
                               .id(2L)
                               .name("eye")
                               .url("www.idillust.com")
                               .build());
        return CategoryApiResponse.builder()
                                  .categories(categories)
                                  .build();
    }

    @GetMapping("/categories/{categoryId}/components")
    public ComponentApiResponse getComponents(@PathVariable Long categoryId) {
        List<Component> components = new ArrayList<>();
        List<Color> colors = new ArrayList<>();
        colors.add(Color.builder()
                        .id(1L)
                        .name("red")
                        .url("www.IDIllust.com/red")
                        .build());
        colors.add(Color.builder()
                        .id(2L)
                        .name("blue")
                        .url("www.IDIllust.com/blue")
                        .build());
        components.add(Component.builder()
                  .id(1L)
                  .name("eyes1")
                  .thumbUrl("www.IDIllust.com/eyes1")
                  .hex("#000000")
                  .colors(colors)
                  .build());
        components.add(Component.builder()
                  .id(2L)
                  .name("hair1")
                  .thumbUrl("www.IDIllust.com/hair1")
                  .hex("#000000")
                  .colors(colors)
                  .build());
        return ComponentApiResponse.builder()
                                   .components(components)
                                   .build();
    }
}
