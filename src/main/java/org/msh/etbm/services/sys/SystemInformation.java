package org.msh.etbm.services.sys;

/**
 * Created by rmemoria on 16/8/15.
 */
public class SystemInformation {
    /**
     * Possible system states
     */
    public enum SystemState {
        NEW,        // is a new instance of the system and requires a initialization
        READY;      // the system is ready to be used
    }

    /**
     * Store the state of the system
     */
    private SystemState state;


    public SystemState getState() {
        return state;
    }

    public void setState(SystemState state) {
        this.state = state;
    }
}
