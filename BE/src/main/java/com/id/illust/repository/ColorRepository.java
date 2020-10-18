package com.id.illust.repository;

import com.id.illust.entity.Color;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ColorRepository extends JpaRepository<Color, Long> {

    Optional<List<Color>> findAllByComponentId(Long componentId);
}
