package org.msh.etbm.db.entities;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;

import java.util.UUID;

/**
 * Responsible to keep information about a workspace related to the command history that will not
 * disappear if the workspace is deleted
 */
@Entity
@Table(name = "workspacelog")
public class WorkspaceLog {

    @Id
    private UUID id;

    @Column(length = 100)
    @NotNull
    private String name;

    @Override
    public String toString() {
        return "WorkspaceLog{" +
                "id=" + id +
                ", name='" + name + '\'' +
                '}';
    }

    /**
     * @return the id
     */
    public UUID getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(UUID id) {
        this.id = id;
    }

    /**
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * @param name the name to set
     */
    public void setName(String name) {
        this.name = name;
    }
}
