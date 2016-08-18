package org.msh.etbm.web.api.cases;

import org.msh.etbm.services.cases.search.CaseSearchInitResponse;
import org.msh.etbm.services.cases.search.CaseSearchService;
import org.msh.etbm.services.security.permissions.Permissions;
import org.msh.etbm.web.api.authentication.Authenticated;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

/**
 * REST API to expose advanced case search functionality
 *
 * Created by rmemoria on 17/8/16.
 */
@RestController
@RequestMapping("/api/cases/search")
@Authenticated(permissions = {Permissions.CASES})
public class CaseSearchREST {

    @Autowired
    CaseSearchService service;

    @RequestMapping(value = "/init", method = RequestMethod.POST)
    public CaseSearchInitResponse init() {
        return service.init();
    }
}
