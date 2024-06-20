package org.msh.etbm.web;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.msh.etbm.services.session.usersession.UserRequestService;
import org.msh.etbm.services.session.usersession.UserSession;
import org.msh.etbm.services.session.usersession.UserSessionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.support.RequestContextUtils;

import java.util.Locale;

/**
 * Interceptor that gets the locale in the request and set it to the locale resolver
 * <p>
 * Created by rmemoria on 10/11/15.
 */
@Component
public class LocaleRequestInterceptor implements HandlerInterceptor {

    @Autowired
    UserSessionService userSessionService;

    @Autowired
    UserRequestService userRequestService;

    @Value("${app.default-language}")
    String defaultLanguage;

    @Value("${app.languages}")
    String[] languages;

    /**
     * A HandlerInterceptor gets called before the appropriate HandlerAdapter triggers the execution of the handler itself. This mechanism can be used for a large field of preprocessing aspects, or common handler behavior like locale or theme changes. Its main purpose is to allow for factoring out repetitive handler code.
     *
     * @param request
     * @param response
     * @param handler
     * @return
     * @throws ServletException
     */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws ServletException {
        Locale locale = getLocale(request);

        LocaleResolver localeResolver = RequestContextUtils.getLocaleResolver(request);

        if (localeResolver == null) {
            throw new IllegalStateException("No LocaleResolver found: not in a DispatcherServlet request?");
        }

        localeResolver.setLocale(request, response, locale);

        return true;
    }


    /**
     * Return the application locale based on the request object.
     *
     * @param request instance of the request made from the client side
     * @return the app locale, compatible with the locale in the request
     */
    public Locale getLocale(HttpServletRequest request) {
        // try to get the locale selected by the user
        Locale locale = getUserSelectedLocale(request);

        // user selected no locale ?
        if (locale == null) {
            locale = request.getLocale();
        }

        return getCompatibleLocale(locale);
    }

    /**
     * Return the closest application locale based on the given locale.
     *
     * @param locale the selected locale of the user
     * @return the compatible locale of the system
     */
    protected Locale getCompatibleLocale(Locale locale) {
        String locCode = locale.toString();

        // search for locales with same language and country
        for (String lang : languages) {
            if (locCode.equals(lang)) {
                return locale;
            }
        }

        // search for locales with same language
        for (String lang : languages) {
            if (lang.startsWith(locale.getLanguage())) {
                return new Locale(lang);
            }
        }

        // return the locale of the default language
        return new Locale(defaultLanguage);
    }

    /**
     * Return the locale selected by the user
     *
     * @param request
     * @return
     */
    protected Locale getUserSelectedLocale(HttpServletRequest request) {
        String newLocale = null;

        // search for selected language in cookies
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if (c.getName().equals(Constants.LANG_TOKEN_COOKIE)) {
                    newLocale = c.getValue();
                    break;
                }
            }
        }

        // if language is null, tries to get it from the parameter
        if (newLocale == null) {
            newLocale = request.getParameter(Constants.LANG_TOKEN_PARAM);
        }

        // no locale selected by the user? return null
        if (newLocale == null) {
            return null;
        }

        //check if language selected is the same as user's preferred language (user.language)
        UserSession userSession = userRequestService.getUserSession();
        if (userSession != null && !newLocale.equals(userSession.getLanguage())) {
            userSessionService.updateUserPrefLanguage(userSession, newLocale);
        }

        try {
            return StringUtils.parseLocaleString(newLocale);
        } catch (IllegalArgumentException e) {
            // if locale passed by the browser is invalid, return null
            return null;
        }
    }
}
