package com.id.illust.service;

import com.id.illust.entity.Category;
import com.id.illust.network.response.CategoryApiResponse;
import com.id.illust.repository.CategoryRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CategoryService {

    private final CategoryRepository categoryRepository;

    public CategoryService(CategoryRepository categoryRepository) {
        this.categoryRepository = categoryRepository;
    }

    public CategoryApiResponse readAll() {
        return response(categoryRepository.findAll());
    }

    private CategoryApiResponse response(List<Category> categoryList) {
        return CategoryApiResponse.builder()
                                  .categories(categoryList)
                                  .build();
    }
}
