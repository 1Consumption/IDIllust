package com.id.illust.service;

import com.id.illust.entity.Color;
import com.id.illust.network.response.ChoiceApiResponse;
import com.id.illust.network.response.ColorApiResponse;
import com.id.illust.repository.ColorRepository;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ColorService {

    private final ColorRepository colorRepository;

    public ColorService(ColorRepository colorRepository) {
        this.colorRepository = colorRepository;
    }

    public ColorApiResponse readAll(Long categoryId, Long componentId) {
        return colorRepository.findAllByComponentId(componentId)
                              .map(colors -> colors.stream().filter(color -> color.getComponent().getCategory().getId().equals(categoryId)))
                              .map(colors -> response(colors.collect(Collectors.toList())))
                              .orElseGet(() -> response(new ArrayList<>()));
    }

    public ChoiceApiResponse getChooseImageUrl(Long categoryId, Long componentId, Long colorId) {
        return colorRepository.findById(colorId)
                              .filter(color -> color.getComponent().getId().equals(componentId))
                              .filter(color -> color.getComponent().getCategory().getId().equals(categoryId))
                              .map(color -> response(color.getThumbUrl()))
                              .orElseGet(() -> response(""));
    }

    private ColorApiResponse response(List<Color> colorList) {
        return ColorApiResponse.builder()
                               .colors(colorList)
                               .build();
    }

    private ChoiceApiResponse response(String thumbUrl) {
        return ChoiceApiResponse.builder()
                                .thumbUrl(thumbUrl)
                                .build();
    }
}
