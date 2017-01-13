package org.msh.etbm.services.cases.tag;

import org.msh.etbm.commons.objutils.ObjectUtils;
import org.msh.etbm.db.entities.Tag;
import org.msh.etbm.services.session.usersession.UserRequestService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.TransactionTemplate;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.sql.DataSource;
import java.util.List;
import java.util.UUID;

/**
 * Service to update cases tags links of auto generated tags
 * Created by Mauricio on 25/07/2016.
 */
@Service
public class AutoGenTagsCasesService {

    private static final Logger LOGGER = LoggerFactory.getLogger(AutoGenTagsCasesService.class);

    @PersistenceContext
    EntityManager entityManager;

    @Autowired
    UserRequestService userRequestService;

    @Autowired
    PlatformTransactionManager platformTransactionManager;

    @Autowired
    DataSource dataSource;

    /**
     * Update the cases of an auto generated tag
     *
     * @param tagId
     */
    public boolean updateCases(UUID tagId) {
        Tag tag = entityManager.find(Tag.class, tagId);

        if (!tag.isAutogenerated()) {
            return false;
        }

        TransactionTemplate txManager = new TransactionTemplate(platformTransactionManager);
        JdbcTemplate template = new JdbcTemplate(dataSource);

        // erase all tag_case of the current tag
        txManager.execute(status -> {
            template.update("delete from tags_case where tag_id = ?",
                    ObjectUtils.uuidAsBytes(tag.getId()));
            return 0;
        });

        // is tag active ?
        if (tag.isActive()) {
            // update tags
            txManager.execute(status -> {
                try {
                    String query = "insert into tags_case (case_id, tag_id) " +
                            "select a.id, ? " +
                            " from tbcase a join patient p on p.id=a.patient_id " +
                            " and p.workspace_id = ?" +
                            " and " + tag.getSqlCondition();

                    template.update(query,
                            ObjectUtils.uuidAsBytes(tag.getId()),
                            ObjectUtils.uuidAsBytes(tag.getWorkspace().getId()));

                } catch (Exception e) {
                    LOGGER.error("Invalid tag condition '" + tag.getName() + "'");
                    // deactivate tag if there was an error during its execution
                    template.update("update tag set active = false where id = ?",
                            ObjectUtils.uuidAsBytes(tag.getId()));
                }
                return 0;
            });
        }

        return true;
    }

    /**
     * Update the auto generated tags of a case
     *
     * @param caseId
     */
    //@Transactional(propagation = Propagation.NOT_SUPPORTED)
    public void updateTags(UUID caseId) {
        UUID wsid = userRequestService.getUserSession().getWorkspaceId();

        // get auto gen tags
        List<Tag> tags = entityManager.createQuery("from Tag t where t.active = true " +
                "and t.sqlCondition is not null and t.workspace.id = :wsid")
                .setParameter("wsid", wsid)
                .getResultList();

        if (tags.size() == 0) {
            return;
        }

        TransactionTemplate txManager = new TransactionTemplate(platformTransactionManager);
        JdbcTemplate template = new JdbcTemplate(dataSource);

        // erase all tags of the current case
        txManager.execute(status -> {
            template.update("delete from tags_case where case_id = ? and tag_id in (select id from tag where sqlCondition is not null)",
                    ObjectUtils.uuidAsBytes(caseId));
            return 0;
        });

        // update tags
        for (Tag tag : tags) {
            txManager.execute(status -> {
                try {
                    template.update("insert into tags_case (case_id, tag_id) " +
                                    "select a.id, ? " +
                                    " from tbcase a join patient p on p.id=a.patient_id " +
                                    " and p.workspace_id = ?" +
                                    " and a.id = ? " +
                                    " and " + tag.getSqlCondition(),
                            ObjectUtils.uuidAsBytes(tag.getId()),
                            ObjectUtils.uuidAsBytes(wsid),
                            ObjectUtils.uuidAsBytes(caseId));

                } catch (Exception e) {
                    LOGGER.error("Invalid tag condition '" + tag.getName() + "'");
                    // deactivate tag if there was an error during its execution
                    template.update("update tag set active = false where id = ?",
                            ObjectUtils.uuidAsBytes(tag.getId()));
                }
                return 0;
            });
        }
    }

    @Transactional
    public boolean updateAllCaseTags() {
        List<Tag> tags = entityManager.createQuery("from Tag where sqlCondition != null").getResultList();

        for (Tag tag : tags) {
            this.updateCases(tag.getId());
        }

        return true;
    }
}
