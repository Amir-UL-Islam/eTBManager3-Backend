package org.msh.etbm.services.admin.regimens;

import org.msh.etbm.commons.SynchronizableItem;
import org.msh.etbm.commons.entities.EntityService;
import org.msh.etbm.commons.entities.query.QueryBuilder;
import org.msh.etbm.commons.entities.query.QueryBuilderFactory;
import org.msh.etbm.commons.entities.query.QueryResult;
import org.msh.etbm.db.entities.Medicine;
import org.msh.etbm.db.entities.Product;
import org.msh.etbm.db.entities.Regimen;
import org.msh.etbm.services.admin.products.ProductData;
import org.msh.etbm.services.admin.products.ProductDetailedData;
import org.msh.etbm.services.admin.products.ProductItem;
import org.msh.etbm.services.admin.products.ProductType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Created by rmemoria on 6/1/16.
 */
@Service
public class RegimenService extends EntityService<Regimen> {

    @Autowired
    QueryBuilderFactory queryBuilderFactory;

    public QueryResult findMany(RegimenQuery qry) {
        QueryBuilder<Regimen> builder = queryBuilderFactory.createQueryBuilder(Regimen.class);

        // order by options
        builder.addDefaultOrderByMap(RegimenQuery.ORDERBY_NAME, "name");
        builder.addOrderByMap(RegimenQuery.ORDERBY_CLASSIFICATION, "classification, name");
        builder.addOrderByMap(RegimenQuery.ORDERBY_CLASSIFICATION + "_DESC", "classification desc, name");

        // profiles
        builder.addDefaultProfile(RegimenQuery.PROFILE_DEFAULT, RegimenData.class);
        builder.addProfile(RegimenQuery.PROFILE_ITEM, SynchronizableItem.class);
        builder.addProfile(RegimenQuery.PROFILE_DETAILED, RegimenDetailedData.class);

        builder.initialize(qry);

        if (!qry.isIncludeDisabled()) {
            builder.addRestriction("active = true");
        }

        return builder.createQueryResult();
    }
}
