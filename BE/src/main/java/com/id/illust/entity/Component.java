package com.id.illust.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.*;

import javax.persistence.*;
import java.util.List;

@Entity
@NoArgsConstructor
@AllArgsConstructor
@Data
@Builder
@ToString(exclude = {"colors", "category"})
public class Component {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    private String thumbUrl;

    private String hex;

    @JsonIgnore
    @OneToMany(fetch = FetchType.LAZY, mappedBy = "component")
    private List<Color> colors;

    @JsonIgnore
    @ManyToOne
    private Category category;
}
