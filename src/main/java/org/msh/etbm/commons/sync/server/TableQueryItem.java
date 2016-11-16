package org.msh.etbm.commons.sync.server;

import org.msh.etbm.commons.sqlquery.SQLQueryBuilder;

/**
 * Store temporary information about the table data to be included in the synchronization file
 *
 * Created by rmemoria on 14/11/16.
 */
public class TableQueryItem {

    public enum SyncAction { INSERT, UPDATE }

    /**
     * The query that will generate the data
     */
    private SQLQueryBuilder query;

    /**
     * The action to be taken during synchronization
     */
    private SyncAction action;

    public TableQueryItem(SQLQueryBuilder query, SyncAction action) {
        this.query = query;
        this.action = action;
    }

    public SQLQueryBuilder getQuery() {
        return query;
    }

    public void setQuery(SQLQueryBuilder query) {
        this.query = query;
    }

    public SyncAction getAction() {
        return action;
    }

    public void setAction(SyncAction action) {
        this.action = action;
    }
}
