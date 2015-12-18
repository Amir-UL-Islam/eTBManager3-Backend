package org.msh.etbm.services.admin.units;

import org.msh.etbm.commons.ErrorMessages;
import org.msh.etbm.commons.entities.EntityService;
import org.msh.etbm.commons.entities.query.QueryBuilder;
import org.msh.etbm.commons.entities.query.QueryBuilderFactory;
import org.msh.etbm.commons.entities.query.QueryResult;
import org.msh.etbm.db.entities.AdministrativeUnit;
import org.msh.etbm.db.entities.Laboratory;
import org.msh.etbm.db.entities.Tbunit;
import org.msh.etbm.db.entities.Unit;
import org.msh.etbm.db.repositories.AdminUnitRepository;
import org.msh.etbm.services.admin.admunits.parents.ParentAdmUnitsService;
import org.msh.etbm.services.admin.units.data.UnitData;
import org.msh.etbm.services.admin.units.data.UnitDetailedData;
import org.msh.etbm.services.admin.units.data.UnitItemData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;

import java.util.UUID;

/**
 * CRUD service to handle units (laboratories and TB units)
 *
 * Created by rmemoria on 31/10/15.
 */
@Service
public class UnitService extends EntityService<Unit> {

    @Autowired
    QueryBuilderFactory queryBuilderFactory;

    @Autowired
    AdminUnitRepository adminUnitRepository;

    @Autowired
    ParentAdmUnitsService parentAdmUnitsService;

    /**
     * Search for units based on the given query
     * @param qry unit query filters
     * @return list of units
     */
    public QueryResult<UnitItemData> findMany(UnitQuery qry) {
        // determine the class to be used in the query
        Class clazz;
        if (qry.getType() != null) {
            clazz = qry.getType() == UnitType.TBUNIT? Tbunit.class : Laboratory.class;
        }
        else {
            clazz = Unit.class;
        }
        QueryBuilder<Unit> builder = queryBuilderFactory.createQueryBuilder(clazz, "a");

        // add the available profiles
        builder.addProfile(UnitRequest.PROFILE_ITEM, UnitItemData.class);
        builder.addDefaultProfile(UnitRequest.PROFILE_DEFAULT, UnitData.class);
        builder.addProfile(UnitRequest.PROFILE_DETAILED, UnitDetailedData.class);

        // add the order by keys
        builder.addDefaultOrderByMap(UnitRequest.ORDERBY_NAME, "a.name");
        builder.addOrderByMap(UnitRequest.ORDERBY_ADMINUNIT, "a.adminUnit.name, a.name");
        builder.addOrderByMap(UnitRequest.ORDERBY_ADMINUNIT + " desc", "a.adminUnit.name desc, a.name desc");

        builder.initialize(qry);

        // add the restrictions
        builder.addLikeRestriction("a.name", qry.getKey());

        builder.addRestriction("a.name = :name", qry.getName());

        // default to include just active items
        if (!qry.isIncludeDisabled()) {
            builder.addRestriction("a.active = true");
        }

        // restrictions administrative unit
        if (qry.getAdminUnitId() != null) {
            // include children?
            if (qry.isIncludeSubunits()) {
                AdministrativeUnit au = adminUnitRepository.findOne(qry.getAdminUnitId());
                if (au == null || !au.getWorkspace().getId().equals(getWorkspaceId())) {
                    rejectFieldException(qry, "adminUnitId", "Invalid administrative unit");
                }
                // search for all administrative units
                builder.addRestriction("a.address.adminUnit.code like :code", au.getCode() + "%");
            }
            else {
                // search for units directly registered in this administrative unit
                builder.addRestriction("a.address.adminUnit.id = :auid", qry.getAdminUnitId());
            }
        }

        // laboratory filters
        builder.addRestriction("performCulture = :pefculture", qry.getPerformCulture());
        builder.addRestriction("performMicroscopy = :pefmic", qry.getPerformMicroscopy());
        builder.addRestriction("performDst = :pefdst", qry.getPerformDst());
        builder.addRestriction("performXpert = :pefxpert", qry.getPerformXpert());

        // TB unit filters
        builder.addRestriction("tbFacility = :tbfacility", qry.getTbFacility());
        builder.addRestriction("mdrFacility = :mdrfacility", qry.getMdrFacility());
        builder.addRestriction("ntmFacility = :ntmfacility", qry.getNtmFacility());
        builder.addRestriction("notificationUnit = :notifunit", qry.getNotificationUnit());

        QueryResult<UnitItemData> res = builder.createQueryResult();
        return res;
    }


    @Override
    protected Unit createEntityInstance(Object req) {
        UnitRequest ureq = (UnitRequest)req;

        if (ureq.getType() == null) {
            raiseRequiredFieldException(req, "type");
        }

        switch (ureq.getUnitType()) {
            case LAB: return new Laboratory();
            case TBUNIT: return new Tbunit();
        }

        rejectFieldException(req, "type", "InvalidValue");
        return null;
    }

    @Override
    protected void prepareToSave(Unit entity, BindingResult bindingResult) {
        super.prepareToSave(entity, bindingResult);

        if (entity.getAddress() == null) {
            bindingResult.rejectValue("address", ErrorMessages.REQUIRED);
        }
        else {
            if (entity.getAddress().getAdminUnit() == null) {
                bindingResult.rejectValue("address.adminUnit", ErrorMessages.REQUIRED);
            }
        }
    }

//    @Override
//    protected <K> K mapResponse(Unit entity, Class<K> resultClass) {
//        K res = super.mapResponse(entity, resultClass);
//
//        if (res instanceof UnitData) {
//            UnitData data = (UnitData)res;
//            data.setAdminUnit(parentAdmUnitsService.getAdminUnitSeries(entity.getAddress().getAdminUnit()));
//        }
//
//        if (res instanceof UnitDetailedData) {
//            UnitDetailedData data = (UnitDetailedData)res;
//            data.getAddress().setAdminUnit(parentAdmUnitsService.getAdminUnitSeries(entity.getAddress().getAdminUnit()));
//            data.getShipAddress().setAdminUnit(parentAdmUnitsService.getAdminUnitSeries(entity.getShipAddress().getAdminUnit()));
//        }
//        return res;
//    }
}
