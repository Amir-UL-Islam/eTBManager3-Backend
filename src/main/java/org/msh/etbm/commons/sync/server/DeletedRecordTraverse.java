package org.msh.etbm.commons.sync.server;

import java.util.UUID;

/**
 * Used by {@link TableChangesTraverser} to traverse each deleted record
 *
 * Created by rmemoria on 8/11/16.
 */
public interface DeletedRecordTraverse {

    /**
     * Called on each deleted record
     * @param id the ID of the deleted record
     */
    void onDeletedRecord(UUID id);
}
