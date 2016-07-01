package org.msh.etbm.services.admin.tags;

import org.msh.etbm.db.entities.Tag;
import org.msh.etbm.services.session.usersession.UserRequestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.List;
import java.util.UUID;

@Service
public class CasesTagsUpdateService {

    @PersistenceContext
    EntityManager entityManager;

    @Autowired
    UserRequestService userRequestService;

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

        // remove previous tags
        String sql = "delete from tags_case where tag_id = :id";
        entityManager.createNativeQuery(sql).setParameter("id", tag.getId()).executeUpdate();

        UUID wsid = userRequestService.getUserSession().getWorkspaceId();

        // is tag active ?
        if (tag.isActive()) {
            // include new tags
            sql = "insert into tags_case (case_id, tag_id) " +
                    "select a.id, '" + tag.getId() + "' from tbcase a join patient p on p.id=a.patient_id " +
                    "where " + tag.getSqlCondition() + " and p.workspace_id = :id";
            entityManager.createNativeQuery(sql).setParameter("id", wsid).executeUpdate();
        }

        return true;
    }

    /**
     * Update the automatic tags of a case
     *
     * @param tbcaseId
     */
    public void updateTags(UUID tbcaseId) {
        UUID wsid = userRequestService.getUserSession().getWorkspaceId();

        // get tags
        List<Tag> tags = entityManager.createQuery("from Tag t where t.active = true \n" +
                "and t.sqlCondition is not null and t.workspace.id = :wId")
                .setParameter("wId", wsid)
                .getResultList();

        if (tags.isEmpty()) {
            return;
        }

        // erase all tags of the current case
        entityManager.createNativeQuery("delete from tags_case where case_id = :id " +
                "and tag_id in (select id from tag where sqlCondition is not null)")
                .setParameter("id", tbcaseId)
                .executeUpdate();

        // update tags
        String sql = "";
        for (Tag tag : tags) {
            if (!sql.isEmpty()) {
                sql += " union ";
                sql += "select a.id, " + tag.getId() +
                        " from tbcase a join patient p on p.id=a.patient_id " +
                        " and p.workspace_id = '" + wsid + "'" +
                        " and a.id = :tbcaseId " +
                        " and " + tag.getSqlCondition();
            }
        }
        sql = "insert into tags_case (case_id, tag_id) " + sql;
        entityManager.createNativeQuery(sql).setParameter("tbcaseId", tbcaseId).executeUpdate();
    }

    /**
     * Update the cases of all auto generated tag
     */
    public void fixTagsConsolidation() {
        List<Tag> tags = entityManager.createQuery("from Tag").getResultList();

        for (Tag tag : tags) {
            if (tag.isAutogenerated()) {
                // remove previous tags
                String sql = "delete from tags_case where tag_id = :id";
                entityManager.createNativeQuery(sql).setParameter("id", tag.getId()).executeUpdate();

                UUID wsid = userRequestService.getUserSession().getWorkspaceId();

                // include new tags
                sql = "insert into tags_case (case_id, tag_id) " +
                        "select a.id, " + tag.getId() + " from tbcase a join patient p on p.id=a.patient_id " +
                        "where " + tag.getSqlCondition() + " and p.workspace_id = :id";
                entityManager.createNativeQuery(sql).setParameter("id", wsid).executeUpdate();
            }
        }
    }
}
