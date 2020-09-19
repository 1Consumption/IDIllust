package com.id.illust.network.response;

import com.id.illust.entity.Color;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ColorApiResponse {

    private List<Color> colors;
}
