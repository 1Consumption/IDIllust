package com.id.illust.controller;

import com.id.illust.network.request.EntryApiRequest;
import com.id.illust.network.response.EntryApiResponse;
import com.id.illust.service.EntryService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
public class EntryController {

    private final EntryService entryService;

    public EntryController(EntryService entryService) {
        this.entryService = entryService;
    }

    @PostMapping("/entry")
    public EntryApiResponse createEntry(@RequestBody EntryApiRequest entryApiRequest) {
        log.info("{}", entryApiRequest);
        return entryService.create(entryApiRequest);
    }

    @GetMapping("/entry")
    public EntryApiResponse getEntry() {
        return entryService.readOne();
    }
}
