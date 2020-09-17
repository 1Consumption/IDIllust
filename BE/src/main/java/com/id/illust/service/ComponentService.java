package com.id.illust.service;

import com.id.illust.entity.Component;
import com.id.illust.network.response.ComponentApiResponse;
import com.id.illust.repository.ComponentRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ComponentService {

    private final ComponentRepository componentRepository;

    public ComponentService(ComponentRepository componentRepository) {
        this.componentRepository = componentRepository;
    }

    public ComponentApiResponse readAll() {
        return response(componentRepository.findAll());
    }

    private ComponentApiResponse response(List<Component> componentList) {
        return ComponentApiResponse.builder()
                                   .components(componentList)
                                   .build();
    }
}
