package org.msh.etbm;

import com.github.benmanes.caffeine.cache.Caffeine;
import org.msh.etbm.commons.forms.impl.FormStoreService;
import org.springframework.cache.CacheManager;
import org.springframework.cache.caffeine.CaffeineCache;
import org.springframework.cache.support.SimpleCacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.Arrays;
import java.util.concurrent.TimeUnit;

@Configuration
public class CacheConfiguration {

    public static final String CACHE_SESSION_ID = "session";
    public static final Integer CACHE_SESSION_TIMEOUT_MIN = 5;

    @Bean
    public CacheManager cacheManager() {
        SimpleCacheManager cacheManager = new SimpleCacheManager();

        CaffeineCache sessionCache = new CaffeineCache(CACHE_SESSION_ID, Caffeine.newBuilder()
                .expireAfterAccess(CACHE_SESSION_TIMEOUT_MIN, TimeUnit.MINUTES)
                .build());

        CaffeineCache formsCache = new CaffeineCache(FormStoreService.CACHE_ID, Caffeine.newBuilder()
                .build());

        cacheManager.setCaches(Arrays.asList(sessionCache, formsCache));
        return cacheManager;
    }
}
