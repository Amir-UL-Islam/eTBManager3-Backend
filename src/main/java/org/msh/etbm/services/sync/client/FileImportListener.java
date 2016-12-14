package org.msh.etbm.services.sync.client;

import java.io.File;

/**
 * Used by {@link ClientModeInitService} to call initialization process finishing after asynchronously importing the file
 * Created by Mauricio on 13/12/2016.
 */
public interface FileImportListener {

    void afterImport(File importedFile);

}
