package org.msh.etbm.db.entities;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;

import java.util.UUID;

/**
 * Responsible for keeping information about a user related to the command history even if the user is
 * deleted from the system
 */
@Entity
@Table(name = "userlog")
public class UserLog {

    @Id
    private UUID id;

    @Column(length = 100)
    @NotNull
    private String name;

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
