package org.msh.etbm.db;

import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.MappedSuperclass;
import org.hibernate.annotations.GenericGenerator;
import org.msh.etbm.commons.entities.cmdlog.PropertyLog;

import java.util.UUID;

/**
 * Indicates that an entity can be synchronized with another database
 * <p>
 * Created by rmemoria on 11/10/15.
 */
@MappedSuperclass
public class Synchronizable {

    /**
     * The table primary key
     */
    @Id
    @GeneratedValue(generator = "uuid2", strategy = GenerationType.SEQUENCE)
    @GenericGenerator(name = "uuid2", strategy = "uuid2", parameters = {@org.hibernate.annotations.Parameter(name = "uuid_gen_strategy_class", value = "org.hibernate.id.uuid.CustomVersionOneStrategy")})
    @PropertyLog(ignore = true)
    private UUID id;


    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }


    @Override
    public boolean equals(Object obj) {
        if (obj == null) {
            return false;
        }

        if (obj == this) {
            return true;
        }

        if (!(obj instanceof Synchronizable)) {
            return false;
        }

        UUID objId = ((Synchronizable) obj).getId();

        if (objId == null) {
            return false;
        }

        return objId.equals(getId());
    }

    @Override
    public int hashCode() {
        return id != null ? id.hashCode() : super.hashCode();
    }

    @Override
    public String toString() {
        return "id=" + id;
    }
}
