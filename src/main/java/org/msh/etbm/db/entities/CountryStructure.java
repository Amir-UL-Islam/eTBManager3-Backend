package org.msh.etbm.db.entities;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import org.msh.etbm.commons.entities.cmdlog.Operation;
import org.msh.etbm.commons.entities.cmdlog.PropertyLog;
import org.msh.etbm.db.WorkspaceEntity;

@Entity
@Table(name = "countrystructure")
public class CountryStructure extends WorkspaceEntity {

    @Column(length = 100)
    @PropertyLog(messageKey = "form.name")
    @NotNull
    private String name;

    @Column(name = "STRUCTURE_LEVEL")
    @Max(5)
    @Min(1)
    @PropertyLog(messageKey = "form.level", operations = {Operation.ALL})
    @NotNull
    private Integer level;


    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    /**
     * @param level the level to set
     */
    public void setLevel(Integer level) {
        this.level = level;
    }

    public Integer getLevel() {
        return level;
    }

    @Override
    public String toString() {
        return super.toString() +
                "name='" + name + '\'' +
                ", level=" + level;
    }

    @Override
    public String getDisplayString() {
        return name;
    }
}
