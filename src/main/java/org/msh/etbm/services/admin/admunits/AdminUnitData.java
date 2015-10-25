package org.msh.etbm.services.admin.admunits;

import java.util.UUID;

/**
 * Created by rmemoria on 21/10/15.
 */
public class AdminUnitData {
    private UUID id;
    private String name;

    private UUID parentId;
    private String parentName;

    private UUID csId;
    private String csName;

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public UUID getParentId() {
        return parentId;
    }

    public void setParentId(UUID parentId) {
        this.parentId = parentId;
    }

    public String getParentName() {
        return parentName;
    }

    public void setParentName(String parentName) {
        this.parentName = parentName;
    }

    public UUID getCsId() {
        return csId;
    }

    public void setCsId(UUID csId) {
        this.csId = csId;
    }

    public String getCsName() {
        return csName;
    }

    public void setCsName(String csName) {
        this.csName = csName;
    }
}