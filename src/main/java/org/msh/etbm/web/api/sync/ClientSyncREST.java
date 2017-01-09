package org.msh.etbm.web.api.sync;

import org.msh.etbm.services.offline.client.data.ServerCredentialsData;
import org.msh.etbm.services.offline.client.data.ServerStatusResponse;
import org.msh.etbm.services.offline.client.init.ClientModeInitService;
import org.msh.etbm.services.security.authentication.WorkspaceInfo;
import org.msh.etbm.web.api.StandardResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.validation.Valid;
import javax.validation.constraints.NotNull;
import java.util.List;

/**
 * REST API to handle Off-line mode initialization and synchronization operations
 * Created by Mauricio on 21/11/16.
 */
@RestController
@RequestMapping("/api/offline")
public class ClientSyncREST {

    @Autowired
    ClientModeInitService service;

    /**
     * Returns the workspaces available for the user/password sent on request
     * @param req
     * @return
     */
    @RequestMapping(value = "/init/workspaces", method = RequestMethod.POST)
    public StandardResult findWorkspaces(@Valid @NotNull @RequestBody ServerCredentialsData req) {

        List<WorkspaceInfo> res = service.findWorkspaces(req);

        return new StandardResult(res, null, true);
    }

    /**
     * Starts the initialization progress and returns the current status of it
     * @param req
     * @return
     */
    @RequestMapping(value = "/init/initialize", method = RequestMethod.POST)
    public ServerStatusResponse initialize(@Valid @NotNull @RequestBody ServerCredentialsData req) {
        return service.initialize(req);
    }

    /**
     * Returns the status of the initialization progress
     * @return
     */
    @RequestMapping(value = "/init/status", method = RequestMethod.GET)
    public ServerStatusResponse status() {
        return service.getStatus();
    }
}
