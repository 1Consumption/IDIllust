package com.id.illust.service;

import com.id.illust.entity.Category;
import com.id.illust.entity.Component;
import com.id.illust.network.response.ComponentApiResponse;
import com.id.illust.repository.CategoryRepository;
import com.id.illust.repository.ComponentRepository;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class ComponentService {

    private final ComponentRepository componentRepository;

    private final CategoryRepository categoryRepository;

    public ComponentService(ComponentRepository componentRepository, CategoryRepository categoryRepository) {
        this.componentRepository = componentRepository;
        this.categoryRepository = categoryRepository;
    }

    public ComponentApiResponse readAll(Long categoryId) {
        return categoryRepository.findById(categoryId)
                                 .map(category -> response(category.getComponentList()))
                                 .orElseGet(() -> response(new ArrayList<>()));
    }

    private ComponentApiResponse response(List<Component> componentList) {
        return ComponentApiResponse.builder()
                                   .components(componentList)
                                   .build();
    }
}
