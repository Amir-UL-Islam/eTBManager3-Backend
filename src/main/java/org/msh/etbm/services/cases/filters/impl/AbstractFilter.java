package org.msh.etbm.services.cases.filters.impl;

import org.msh.etbm.commons.sqlquery.QueryDefs;
import org.msh.etbm.services.cases.filters.Filter;
import org.msh.etbm.services.cases.filters.FilterContext;
import org.msh.etbm.services.cases.filters.FilterGroup;
import org.springframework.context.ApplicationContext;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;

/**
 * Simple filter implementation to act as an starting point implementation
 *
 * Created by rmemoria on 17/8/16.
 */
public abstract class AbstractFilter implements Filter {

    private String id;
    private String label;
    private FilterGroup group;
    private ApplicationContext applicationContext;

    public AbstractFilter(FilterGroup group, String id, String label) {
        super();
        this.group = group;
        this.id = id;
        this.label = label;
    }

    @Override
    public String getId() {
        return id;
    }

    @Override
    public String getLabel() {
        return label;
    }

    @Override
    public FilterGroup getGroup() {
        return group;
    }

    @Override
    public Map<String, Object> getResources(FilterContext context, Map<String, Object> params) {
        return null;
    }

    @Override
    public void initialize(ApplicationContext context) {
        this.applicationContext = context;
    }

    /**
     * Add restrictions to the query based on the given value. If value is a collection, so the restriction
     * is implemented as an IN SQL restriction
     * @param defs
     * @param field
     * @param value
     * @param converter called for each value to convert to an appropriated value parameter
     */
    protected void addValuesRestriction(QueryDefs defs, String field, Object value, ValueConverter converter) {
        StringBuilder s = new StringBuilder();

        Collection lst = value instanceof Collection ? (Collection)value : null;

        // check if there is one single value
        Object singleValue;
        if (lst == null) {
            singleValue = value;
        } else {
            if (lst.size() == 0) {
                return;
            }
            singleValue = lst.size() == 1 ? lst.toArray()[0] : null;
        }

        // handle collection
        if (lst != null && lst.size() > 1) {
            handleMultiValuesRestriction(defs, field, lst, converter);
        } else {
            handleSingleValueRestriction(defs, field, singleValue, converter);
        }
    }


    /**
     * Add value restrictions when it is informed as an array of values
     * @param def
     * @param field
     * @param lst
     * @param converter
     */
    private void handleMultiValuesRestriction(QueryDefs def, String field, Collection lst, ValueConverter converter) {
        StringBuilder s = new StringBuilder();

        s.append(field).append(" in ");
        String delim = "(";
        List params = new ArrayList<>();

        for (Object item: lst) {
            Object param = converter != null ? converter.convert(item) : item;
            if (param != null) {
                s.append(delim).append("?");
                params.add(param);
                delim = ",";
            }
        }
        s.append(")");

        if (params.size() > 0) {
            def.restrict(s.toString(), params.toArray());
        }
    }

    /**
     * Add value restrictions when it is informed just a single value from the client request
     * @param def
     * @param field
     * @param value
     * @param converter
     */
    private void handleSingleValueRestriction(QueryDefs def, String field, Object value, ValueConverter converter) {
        Object param = converter != null ? converter.convert(value) : value;
        if (param != null) {
            String s = field + " = ?";
            def.restrict(s, param);
        }
    }

    public ApplicationContext getApplicationContext() {
        return applicationContext;
    }
}
