package org.msh.etbm.services.offline.init.data;

import java.util.UUID;

/**
 * Class data to initialize an off-line mode instance
 * Created by Mauricio on 21/11/2016.
 */
public class OfflineModeInitData {

    private String parentServerUrl;
    private String username;
    private String password;
    private UUID workspaceId;

    public String getParentServerUrl() {
        return parentServerUrl;
    }

    public void setParentServerUrl(String parentServerUrl) {
        this.parentServerUrl = parentServerUrl;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public UUID getWorkspaceId() {
        return workspaceId;
    }

    public void setWorkspaceId(UUID workspaceId) {
        this.workspaceId = workspaceId;
    }
}
