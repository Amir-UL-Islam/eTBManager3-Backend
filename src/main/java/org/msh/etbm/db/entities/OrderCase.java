package org.msh.etbm.db.entities;


import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotNull;
import org.msh.etbm.db.Synchronizable;


@Entity
@Table(name = "ordercase")
public class OrderCase extends Synchronizable {


    @ManyToOne
    @JoinColumn(name = "CASE_ID")
    @NotNull
    private TbCase tbcase;

    @ManyToOne
    @JoinColumn(name = "ORDERITEM_ID")
    @NotNull
    private OrderItem item;

    private int estimatedQuantity;


    public TbCase getTbcase() {
        return tbcase;
    }

    public void setTbcase(TbCase tbcase) {
        this.tbcase = tbcase;
    }

    public OrderItem getItem() {
        return item;
    }

    public void setItem(OrderItem item) {
        this.item = item;
    }

    public int getEstimatedQuantity() {
        return estimatedQuantity;
    }

    public void setEstimatedQuantity(int estimatedQuantity) {
        this.estimatedQuantity = estimatedQuantity;
    }
}
