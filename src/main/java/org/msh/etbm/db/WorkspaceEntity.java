package org.msh.etbm.db;

import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.MappedSuperclass;
import jakarta.validation.constraints.NotNull;
import org.msh.etbm.commons.Displayable;
import org.msh.etbm.commons.entities.cmdlog.PropertyLog;
import org.msh.etbm.db.entities.Workspace;


/**
 * Super entity class where all entities that support workspace must inherit from.
 * This class contains the workspace information and the transactions that created
 * the entity and update it for the last time
 *
 * @author Ricardo Memoria
 */
@MappedSuperclass
public abstract class WorkspaceEntity extends Synchronizable implements Displayable {

    /**
     * The workspace of this entity
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "WORKSPACE_ID")
    @NotNull
    @PropertyLog(ignore = true)
    private Workspace workspace;


    /**
     * Get the workspace that the entity belongs to
     *
     * @return
     */
    public Workspace getWorkspace() {
        return workspace;
    }

    /**
     * Set the entity workspace
     *
     * @param workspace
     */
    public void setWorkspace(Workspace workspace) {
        this.workspace = workspace;
    }
}
