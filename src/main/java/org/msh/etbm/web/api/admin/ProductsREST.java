package org.msh.etbm.web.api.admin;

import org.msh.etbm.commons.entities.ServiceResult;
import org.msh.etbm.commons.entities.query.QueryResult;
import org.msh.etbm.commons.forms.FormRequest;
import org.msh.etbm.commons.forms.FormResponse;
import org.msh.etbm.commons.forms.FormsService;
import org.msh.etbm.services.admin.products.ProductDetailedData;
import org.msh.etbm.services.admin.products.ProductFormData;
import org.msh.etbm.services.admin.products.ProductQueryParams;
import org.msh.etbm.services.admin.products.ProductService;
import org.msh.etbm.services.permissions.Permissions;
import org.msh.etbm.web.api.StandardResult;
import org.msh.etbm.web.api.authentication.Authenticated;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import javax.validation.constraints.NotNull;
import java.util.UUID;

/**
 * REST API controller to expose CRUD operations in a product/medicine
 *
 * Created by rmemoria on 11/11/15.
 */
@RestController
@RequestMapping("/api/tbl")
@Authenticated(permissions = {Permissions.TABLE_PRODUCTS_EDT})
public class ProductsREST {

    // the api prefix used in the URL
    private static final String API_PREFIX = "/product";

    @Autowired
    ProductService service;

    @Autowired
    FormsService formsService;

    @RequestMapping(value = API_PREFIX + "/{id}", method = RequestMethod.GET)
    @Authenticated()
    public ProductDetailedData get(@PathVariable UUID id) {
        return service.findOne(id, ProductDetailedData.class);
    }

    @RequestMapping(value = API_PREFIX + "/form", method = RequestMethod.POST)
    @Authenticated()
    public FormResponse initForm(@Valid @NotNull @RequestBody FormRequest req) {
        return formsService.initForm(req, service, ProductFormData.class);
    }

    @RequestMapping(value = API_PREFIX, method = RequestMethod.POST)
    public StandardResult create(@Valid @NotNull @RequestBody ProductFormData req) {
        ServiceResult res = service.create(req);
        return new StandardResult(res);
    }

    @RequestMapping(value = API_PREFIX + "/{id}", method = RequestMethod.POST)
    public StandardResult update(@PathVariable UUID id, @Valid @NotNull @RequestBody ProductFormData req) {
        ServiceResult res = service.update(id, req);
        return new StandardResult(res);
    }

    @RequestMapping(value = API_PREFIX + "/{id}", method = RequestMethod.DELETE)
    public UUID delete(@PathVariable @NotNull UUID id) {
        return service.delete(id).getId();
    }

    @RequestMapping(value = API_PREFIX + "/query", method = RequestMethod.POST)
    @Authenticated()
    public QueryResult query(@Valid @RequestBody ProductQueryParams query) {
        return service.findMany(query);
    }
    
}
