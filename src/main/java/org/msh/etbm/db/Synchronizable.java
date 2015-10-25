package org.msh.etbm.db;

import org.hibernate.annotations.GenericGenerator;

import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.MappedSuperclass;
import java.util.UUID;

/**
 * Indicates that an entity can be synchronized with another database
 *
 * Created by rmemoria on 11/10/15.
 */
@MappedSuperclass
public class Synchronizable {

    /**
     * The table primary key
     */
    @Id
    @GeneratedValue(generator = "uuid2", strategy = GenerationType.SEQUENCE)
    @GenericGenerator(name = "uuid2", strategy = "uuid2", parameters = { @org.hibernate.annotations.Parameter(name = "uuid_gen_strategy_class", value = "org.hibernate.id.uuid.CustomVersionOneStrategy") })
    private UUID id;


    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }


    @Override
    public boolean equals(Object obj) {
        if (obj == this)
            return true;

        if (!getClass().isAssignableFrom(obj.getClass())) {
            return false;
        }

        UUID objId = ((Synchronizable)obj).getId();

        if (objId == null)
            return false;

        return objId.equals(getId());
    }

}