package com.id.illust.service;

import com.id.illust.entity.Entry;
import com.id.illust.network.request.EntryApiRequest;
import com.id.illust.network.response.EntryApiResponse;
import com.id.illust.repository.EntryRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class EntryService {

    private final EntryRepository entryRepository;

    public EntryService(EntryRepository entryRepository) {
        this.entryRepository = entryRepository;
    }

    public EntryApiResponse create(EntryApiRequest request) {
        Entry entry = Entry.builder()
                           .url(request.getUrl())
                           .build();
        Entry newEntry = entryRepository.save(entry);
        return response(newEntry);
    }

    public EntryApiResponse read(Long id) {
        return entryRepository.findById(id)
                .map(entry -> response(entry))
                .orElseGet(() -> EntryApiResponse.builder().build());
    }

    public EntryApiResponse update(EntryApiRequest request) {
        return entryRepository.findById(request.getId())
                              .map(entry -> {
                                  entry.setUrl(request.getUrl());
                                  return entry;
                              })
                              .map(entry -> entryRepository.save(entry))
                              .map(updateEntry -> response(updateEntry))
                              .orElseGet(() -> EntryApiResponse.builder().build());
    }

    public EntryApiResponse delete(Long id) {
        return entryRepository.findById(id)
                              .map(entry -> {
                                  entryRepository.delete(entry);
                                  return EntryApiResponse.builder().build();
                              })
                              .orElseGet(() -> EntryApiResponse.builder().build());
    }

    public EntryApiResponse readOne() {
        List<Entry> entryList = entryRepository.findAll();
        return response(entryList.get(0));
    }

    private EntryApiResponse response(Entry entry) {
        return EntryApiResponse.builder()
                               .url(entry.getUrl())
                               .build();
    }
}
