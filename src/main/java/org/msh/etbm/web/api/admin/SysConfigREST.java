package org.msh.etbm.web.api.admin;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import org.msh.etbm.services.admin.sysconfig.SysConfigFormData;
import org.msh.etbm.services.admin.sysconfig.SysConfigService;
import org.msh.etbm.services.security.permissions.Permissions;
import org.msh.etbm.web.api.StandardResult;
import org.msh.etbm.web.api.authentication.Authenticated;
import org.msh.etbm.web.api.authentication.InstanceType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;


/**
 * Created by rmemoria on 6/4/16.
 */
@RestController
@RequestMapping("/api/admin/sysconfig")
@Authenticated(permissions = {Permissions.ADMIN_SETUP_SYSTEM}, instanceType = InstanceType.SERVER_MODE)
public class SysConfigREST {

    @Autowired
    SysConfigService sysConfigService;

    @RequestMapping(method = RequestMethod.GET)
    public SysConfigFormData readConfig() {
        return sysConfigService.loadFormConfig();
    }

    @RequestMapping(method = RequestMethod.POST)
    public StandardResult postConfig(@RequestBody @NotNull @Valid SysConfigFormData data) {
        sysConfigService.updateConfig(data);
        return StandardResult.createSuccessResult();
    }
}
