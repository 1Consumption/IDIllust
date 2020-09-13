package com.id.illust.network.response;

import com.id.illust.entity.Component;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ComponentApiResponse {

    private List<Component> components;
}
