CREATE TABLE administrativeunit
(
    id                  BINARY(16) NOT NULL,
    workspace_id        BINARY(16) NOT NULL,
    name                VARCHAR(255) NOT NULL,
    pid0                BINARY(16) NULL,
    pid1                BINARY(16) NULL,
    pid2                BINARY(16) NULL,
    pid3                BINARY(16) NULL,
    pname0              VARCHAR(255) NULL,
    pname1              VARCHAR(255) NULL,
    pname2              VARCHAR(255) NULL,
    pname3              VARCHAR(255) NULL,
    custom_id           VARCHAR(50) NULL,
    units_count         INT          NOT NULL,
    countrystructure_id BINARY(16) NOT NULL,
    CONSTRAINT pk_administrativeunit PRIMARY KEY (id)
);

CREATE TABLE agerange
(
    id           BINARY(16) NOT NULL,
    workspace_id BINARY(16) NOT NULL,
    ini_age      INT NOT NULL,
    end_age      INT NOT NULL,
    CONSTRAINT pk_agerange PRIMARY KEY (id)
);

CREATE TABLE batch
(
    id           BINARY(16) NOT NULL,
    workspace_id BINARY(16) NOT NULL,
    expiry_date  date        NOT NULL,
    batch_number VARCHAR(30) NOT NULL,
    manufacturer VARCHAR(80) NULL,
    medicine_id  BINARY(16) NOT NULL,
    unit_price   DOUBLE      NOT NULL,
    CONSTRAINT pk_batch PRIMARY KEY (id)
);

CREATE TABLE batchdispensing
(
    id            BINARY(16) NOT NULL,
    dispensing_id BINARY(16) NULL,
    batch_id      BINARY(16) NOT NULL,
    source_id     BINARY(16) NOT NULL,
    quantity      INT NOT NULL,
    CONSTRAINT pk_batchdispensing PRIMARY KEY (id)
);

CREATE TABLE batchmovement
(
    id                 BINARY(16) NOT NULL,
    batch_id           BINARY(16) NOT NULL,
    quantity           INT    NOT NULL,
    available_quantity INT    NOT NULL,
    movement_id        BINARY(16) NOT NULL,
    header             BIT(1) NOT NULL,
    CONSTRAINT pk_batchmovement PRIMARY KEY (id)
);

CREATE TABLE cacheddata
(
    id           BIGINT       NOT NULL,
    entry_id     VARCHAR(250) NOT NULL,
    method       VARCHAR(250) NOT NULL,
    hash         VARCHAR(40)  NOT NULL,
    args         LONGTEXT     NOT NULL,
    entry_date   datetime     NOT NULL,
    expiry_date  datetime NULL,
    data         LONGTEXT     NOT NULL,
    data_class   VARCHAR(250) NOT NULL,
    workspace_id BINARY(16) NULL,
    CONSTRAINT pk_cacheddata PRIMARY KEY (id)
);

CREATE TABLE casecomment
(
    id            BINARY(16) NOT NULL,
    case_id       BINARY(16) NOT NULL,
    user_id       BINARY(16) NOT NULL,
    comment_date  datetime NOT NULL,
    comment       LONGTEXT NOT NULL,
    comment_group SMALLINT NOT NULL,
    CONSTRAINT pk_casecomment PRIMARY KEY (id)
);

CREATE TABLE casecomorbidities
(
    id                    BINARY(16) NOT NULL,
    case_id               BINARY(16) NOT NULL,
    alcohol_excessive_use BIT(1) NOT NULL,
    tobacco_use_within    BIT(1) NOT NULL,
    aids                  BIT(1) NOT NULL,
    diabetes              BIT(1) NOT NULL,
    anaemia               BIT(1) NOT NULL,
    malnutrition          BIT(1) NOT NULL,
    CONSTRAINT pk_casecomorbidities PRIMARY KEY (id)
);

CREATE TABLE casecontact
(
    id                  BINARY(16) NOT NULL,
    case_id             BINARY(16) NOT NULL,
    name                VARCHAR(255) NOT NULL,
    gender              SMALLINT     NOT NULL,
    age                 VARCHAR(255) NOT NULL,
    date_of_examination datetime NULL,
    contact_type        VARCHAR(50) NULL,
    examinated          BIT(1)       NOT NULL,
    conduct             VARCHAR(50) NULL,
    comments            LONGTEXT NULL,
    CONSTRAINT pk_casecontact PRIMARY KEY (id)
);

CREATE TABLE caseresistancepattern
(
    id               INT    NOT NULL,
    case_id          BINARY(16) NULL,
    resistpattern_id BINARY(16) NOT NULL,
    diagnosis        BIT(1) NOT NULL,
    CONSTRAINT pk_caseresistancepattern PRIMARY KEY (id)
);

CREATE TABLE casesideeffect
(
    id            BINARY(16) NOT NULL,
    case_id       BINARY(16) NOT NULL,
    side_effect   VARCHAR(255) NULL,
    medicines     VARCHAR(255) NULL,
    se_month      INT NULL,
    substance_id  BINARY(16) NULL,
    substance2_id BINARY(16) NULL,
    comment       LONGTEXT NULL,
    CONSTRAINT pk_casesideeffect PRIMARY KEY (id)
);

CREATE TABLE commandhistory
(
    id              INT          NOT NULL,
    type            VARCHAR(200) NOT NULL,
    action          SMALLINT     NOT NULL,
    data            LONGTEXT NULL,
    exec_date       datetime NULL,
    userlog_id      BINARY(16) NOT NULL,
    workspacelog_id BINARY(16) NULL,
    unit_id         BINARY(16) NULL,
    entity_id       BINARY(16) NULL,
    entity_name     VARCHAR(250) NULL,
    parent_id       BINARY(16) NULL,
    CONSTRAINT pk_commandhistory PRIMARY KEY (id)
);

CREATE TABLE countrystructure
(
    id              BINARY(16) NOT NULL,
    workspace_id    BINARY(16) NOT NULL,
    name            VARCHAR(100) NOT NULL,
    structure_level INT          NOT NULL,
    CONSTRAINT pk_countrystructure PRIMARY KEY (id)
);

CREATE TABLE errorlog
(
    id                BIGINT NOT NULL,
    error_date        datetime NULL,
    exception_class   VARCHAR(100) NULL,
    exception_message VARCHAR(500) NULL,
    url               VARCHAR(150) NULL,
    user_name         VARCHAR(100) NULL,
    user_id           BINARY(16) NULL,
    stack_trace       LONGTEXT NULL,
    workspace         VARCHAR(100) NULL,
    request           LONGTEXT NULL,
    CONSTRAINT pk_errorlog PRIMARY KEY (id)
);

CREATE TABLE examculture
(
    id                 BINARY(16) NOT NULL,
    sample_number      VARCHAR(50) NULL,
    request_id         BINARY(16) NULL,
    laboratory_id      BINARY(16) NULL,
    date_release       date NULL,
    status             SMALLINT NULL,
    event_date         date NULL,
    comments           LONGTEXT NULL,
    case_id            BINARY(16) NOT NULL,
    result             SMALLINT NULL,
    number_of_colonies INT NULL,
    sample_type        SMALLINT NULL,
    method             VARCHAR(50) NULL,
    CONSTRAINT pk_examculture PRIMARY KEY (id)
);

CREATE TABLE examdst
(
    id            BINARY(16) NOT NULL,
    sample_number VARCHAR(50) NULL,
    request_id    BINARY(16) NULL,
    laboratory_id BINARY(16) NULL,
    date_release  date NULL,
    status        SMALLINT NULL,
    event_date    date NULL,
    comments      LONGTEXT NULL,
    case_id       BINARY(16) NOT NULL,
    result_am     SMALLINT NULL,
    result_cfz    SMALLINT NULL,
    result_cm     SMALLINT NULL,
    result_cs     SMALLINT NULL,
    resulte       SMALLINT NULL,
    result_eto    SMALLINT NULL,
    resulth       SMALLINT NULL,
    result_lfx    SMALLINT NULL,
    result_ofx    SMALLINT NULL,
    resultr       SMALLINT NULL,
    results       SMALLINT NULL,
    resultz       SMALLINT NULL,
    method        VARCHAR(50) NULL,
    CONSTRAINT pk_examdst PRIMARY KEY (id)
);

CREATE TABLE examhiv
(
    id             BINARY(16) NOT NULL,
    event_date     date NULL,
    comments       LONGTEXT NULL,
    case_id        BINARY(16) NOT NULL,
    result         SMALLINT NULL,
    startedartdate date NULL,
    startedcptdate date NULL,
    laboratory     VARCHAR(100) NULL,
    CONSTRAINT pk_examhiv PRIMARY KEY (id)
);

CREATE TABLE exammicroscopy
(
    id                BINARY(16) NOT NULL,
    sample_number     VARCHAR(50) NULL,
    request_id        BINARY(16) NULL,
    laboratory_id     BINARY(16) NULL,
    date_release      date NULL,
    status            SMALLINT NULL,
    event_date        date NULL,
    comments          LONGTEXT NULL,
    case_id           BINARY(16) NOT NULL,
    result            SMALLINT NULL,
    number_ofafb      INT NULL,
    sample_type       SMALLINT NULL,
    other_sample_type VARCHAR(255) NULL,
    visual_appearance SMALLINT NULL,
    method            VARCHAR(50) NULL,
    CONSTRAINT pk_exammicroscopy PRIMARY KEY (id)
);

CREATE TABLE examrequest
(
    id            BINARY(16) NOT NULL,
    request_date  datetime NULL,
    case_id       BINARY(16) NULL,
    unit_id       BINARY(16) NULL,
    laboratory_id BINARY(16) NOT NULL,
    user_id       BINARY(16) NOT NULL,
    CONSTRAINT pk_examrequest PRIMARY KEY (id)
);

CREATE TABLE examxpert
(
    id            BINARY(16) NOT NULL,
    sample_number VARCHAR(50) NULL,
    request_id    BINARY(16) NULL,
    laboratory_id BINARY(16) NULL,
    date_release  date NULL,
    status        SMALLINT NULL,
    event_date    date NULL,
    comments      LONGTEXT NULL,
    case_id       BINARY(16) NOT NULL,
    result        SMALLINT NULL,
    CONSTRAINT pk_examxpert PRIMARY KEY (id)
);

CREATE TABLE examxray
(
    id           BINARY(16) NOT NULL,
    event_date   date NULL,
    comments     LONGTEXT NULL,
    case_id      BINARY(16) NOT NULL,
    evolution    VARCHAR(50) NULL,
    presentation VARCHAR(50) NULL,
    CONSTRAINT pk_examxray PRIMARY KEY (id)
);

CREATE TABLE formdata
(
    id           BINARY(16) NOT NULL,
    workspace_id BINARY(16) NOT NULL,
    form_id      VARCHAR(50) NULL,
    name         VARCHAR(200) NULL,
    data         LONGTEXT NULL,
    version      INT NULL,
    CONSTRAINT pk_formdata PRIMARY KEY (id)
);

CREATE TABLE issue
(
    id            BINARY(16) NOT NULL,
    case_id       BINARY(16) NOT NULL,
    closed        BIT(1) NOT NULL,
    user_id       BINARY(16) NULL,
    creation_date datetime NULL,
    title         VARCHAR(200) NULL,
    `description` LONGTEXT NULL,
    unit_id       BINARY(16) NOT NULL,
    CONSTRAINT pk_issue PRIMARY KEY (id)
);

CREATE TABLE issuefollowup
(
    id            BINARY(16) NOT NULL,
    issue_id      BINARY(16) NOT NULL,
    text          LONGTEXT NOT NULL,
    user_id       BINARY(16) NOT NULL,
    followup_date datetime NOT NULL,
    unit_id       BINARY(16) NOT NULL,
    CONSTRAINT pk_issuefollowup PRIMARY KEY (id)
);

CREATE TABLE medicalexamination
(
    id                               BINARY(16) NOT NULL,
    event_date                       date NULL,
    comments                         LONGTEXT NULL,
    case_id                          BINARY(16) NOT NULL,
    weight                           DOUBLE NULL,
    height                           DOUBLE NULL,
    appointment_type                 SMALLINT NULL,
    using_presc_medicines            BIT(1) NULL,
    reason_not_using_presc_medicines VARCHAR(200) NULL,
    responsible                      VARCHAR(100) NULL,
    position_responsible             VARCHAR(100) NULL,
    CONSTRAINT pk_medicalexamination PRIMARY KEY (id)
);

CREATE TABLE medicine_substances
(
    medicine_id  BINARY(16) NOT NULL,
    substance_id BINARY(16) NOT NULL
);

CREATE TABLE medicinedispensing
(
    id              BINARY(16) NOT NULL,
    unit_id         BINARY(16) NULL,
    dispensing_date date NOT NULL,
    CONSTRAINT pk_medicinedispensing PRIMARY KEY (id)
);

CREATE TABLE medicinedispensingcase
(
    id            BINARY(16) NOT NULL,
    dispensing_id BINARY(16) NOT NULL,
    case_id       BINARY(16) NOT NULL,
    source_id     BINARY(16) NOT NULL,
    batch_id      BINARY(16) NOT NULL,
    quantity      INT NOT NULL,
    CONSTRAINT pk_medicinedispensingcase PRIMARY KEY (id)
);

CREATE TABLE medicineregimen
(
    id                BINARY(16) NOT NULL,
    medicine_id       BINARY(16) NOT NULL,
    regimen_id        BINARY(16) NULL,
    default_dose_unit INT NOT NULL,
    default_frequency INT NOT NULL,
    ini_day           INT NOT NULL,
    days              INT NOT NULL,
    CONSTRAINT pk_medicineregimen PRIMARY KEY (id)
);

CREATE TABLE modeldata
(
    id        VARCHAR(255) NOT NULL,
    json_data LONGTEXT NULL,
    version   INT          NOT NULL,
    CONSTRAINT pk_modeldata PRIMARY KEY (id)
);

CREATE TABLE movement
(
    id                    BINARY(16) NOT NULL,
    mov_date              date     NOT NULL,
    type                  SMALLINT NULL,
    product_id            BINARY(16) NOT NULL,
    unit_id               BINARY(16) NOT NULL,
    source_id             BINARY(16) NOT NULL,
    record_date           datetime NOT NULL,
    comment               VARCHAR(250) NULL,
    adjustment_type       VARCHAR(50) NULL,
    available_quantity    INT      NOT NULL,
    total_price_inventory DOUBLE   NOT NULL,
    header                BIT(1)   NOT NULL,
    CONSTRAINT pk_movement PRIMARY KEY (id)
);

CREATE TABLE movements_dispensing
(
    dispensing_id BINARY(16) NOT NULL,
    movement_id   BINARY(16) NOT NULL
);

CREATE TABLE movements_receiving
(
    movement_id  BINARY(16) NOT NULL,
    receiving_id BINARY(16) NOT NULL
);

CREATE TABLE orderbatch
(
    id                BINARY(16) NOT NULL,
    orderitem_id      BINARY(16) NOT NULL,
    batch_id          BINARY(16) NOT NULL,
    quantity          INT NOT NULL,
    received_quantity INT NULL,
    CONSTRAINT pk_orderbatch PRIMARY KEY (id)
);

CREATE TABLE ordercase
(
    id                 BINARY(16) NOT NULL,
    case_id            BINARY(16) NOT NULL,
    orderitem_id       BINARY(16) NOT NULL,
    estimated_quantity INT NOT NULL,
    CONSTRAINT pk_ordercase PRIMARY KEY (id)
);

CREATE TABLE ordercomment
(
    id                BINARY(16) NOT NULL,
    order_id          BINARY(16) NOT NULL,
    comment           LONGTEXT NULL,
    user_creator_id   BINARY(16) NOT NULL,
    date              datetime NOT NULL,
    status_on_comment SMALLINT NULL,
    CONSTRAINT pk_ordercomment PRIMARY KEY (id)
);

CREATE TABLE orderitem
(
    id                 BINARY(16) NOT NULL,
    order_id           BINARY(16) NOT NULL,
    product_id         BINARY(16) NOT NULL,
    source_id          BINARY(16) NOT NULL,
    movement_in_id     BINARY(16) NULL,
    movement_out_id    BINARY(16) NULL,
    estimated_quantity INT NOT NULL,
    requested_quantity INT NOT NULL,
    approved_quantity  INT NULL,
    shipped_quantity   INT NULL,
    received_quantity  INT NULL,
    stock_quantity     INT NULL,
    num_patients       INT NULL,
    comment            VARCHAR(200) NULL,
    CONSTRAINT pk_orderitem PRIMARY KEY (id)
);

CREATE TABLE patient
(
    id           BINARY(16) NOT NULL,
    workspace_id BINARY(16) NOT NULL,
    mother_name  VARCHAR(100) NULL,
    birth_date   date NULL,
    gender       VARCHAR(255) NOT NULL,
    custom_id    VARCHAR(50) NULL,
    name         VARCHAR(100) NULL,
    middle_name  VARCHAR(100) NULL,
    last_name    VARCHAR(100) NULL,
    CONSTRAINT pk_patient PRIMARY KEY (id)
);

CREATE TABLE prescribedmedicine
(
    id         BINARY(16) NOT NULL,
    case_id    BINARY(16) NOT NULL,
    product_id BINARY(16) NOT NULL,
    dose_unit  INT NOT NULL,
    frequency  INT NOT NULL,
    comments   LONGTEXT NULL,
    ini_date   date NULL,
    end_date   date NULL,
    CONSTRAINT pk_prescribedmedicine PRIMARY KEY (id)
);

CREATE TABLE prevtbtreatment
(
    id              BINARY(16) NOT NULL,
    case_id         BINARY(16) NOT NULL,
    treatment_month INT NULL,
    treatment_year  INT NULL,
    outcome_month   INT NULL,
    outcome_year    INT NULL,
    outcome         VARCHAR(255) NOT NULL,
    am              BIT(1)       NOT NULL,
    cfz             BIT(1)       NOT NULL,
    cm              BIT(1)       NOT NULL,
    cs              BIT(1)       NOT NULL,
    e               BIT(1)       NOT NULL,
    eto             BIT(1)       NOT NULL,
    h               BIT(1)       NOT NULL,
    lfx             BIT(1)       NOT NULL,
    ofx             BIT(1)       NOT NULL,
    r               BIT(1)       NOT NULL,
    s               BIT(1)       NOT NULL,
    z               BIT(1)       NOT NULL,
    CONSTRAINT pk_prevtbtreatment PRIMARY KEY (id)
);

CREATE TABLE product
(
    id            BINARY(16) NOT NULL,
    discriminator VARCHAR(31) NULL,
    workspace_id  BINARY(16) NOT NULL,
    name          VARCHAR(250) NOT NULL,
    short_name    VARCHAR(30)  NOT NULL,
    custom_id     VARCHAR(50) NULL,
    active        BIT(1)       NOT NULL,
    category      SMALLINT     NOT NULL,
    line          SMALLINT     NOT NULL,
    CONSTRAINT pk_product PRIMARY KEY (id)
);

CREATE TABLE productorder
(
    id                    BINARY(16) NOT NULL,
    workspace_id          BINARY(16) NOT NULL,
    order_date            datetime NOT NULL,
    approving_date        datetime NULL,
    shipping_date         date NULL,
    receiving_date        date NULL,
    status                SMALLINT NULL,
    num_days              INT NULL,
    unit_from_id          BINARY(16) NOT NULL,
    unit_to_id            BINARY(16) NOT NULL,
    cancel_reason         VARCHAR(200) NULL,
    user_creator_id       BINARY(16) NOT NULL,
    authorizer_unit_id    BINARY(16) NULL,
    custom_id             VARCHAR(50) NULL,
    ship_address          VARCHAR(200) NULL,
    ship_address_cont     VARCHAR(200) NULL,
    ship_contact_name     VARCHAR(200) NULL,
    ship_contact_phone    VARCHAR(200) NULL,
    ship_adminunit_id     BINARY(16) NULL,
    ship_zip_code         VARCHAR(50) NULL,
    ship_institution_name VARCHAR(200) NULL,
    CONSTRAINT pk_productorder PRIMARY KEY (id)
);

CREATE TABLE productreceiving
(
    id             BINARY(16) NOT NULL,
    unit_id        BINARY(16) NOT NULL,
    receiving_date date   NOT NULL,
    source_id      BINARY(16) NOT NULL,
    comments       LONGTEXT NULL,
    total_price    DOUBLE NOT NULL,
    CONSTRAINT pk_productreceiving PRIMARY KEY (id)
);

CREATE TABLE regimen
(
    id             BINARY(16) NOT NULL,
    workspace_id   BINARY(16) NOT NULL,
    name           VARCHAR(100) NOT NULL,
    classification SMALLINT NULL,
    custom_id      VARCHAR(50) NULL,
    active         BIT(1)       NOT NULL,
    CONSTRAINT pk_regimen PRIMARY KEY (id)
);

CREATE TABLE report
(
    id                BINARY(16) NOT NULL,
    workspace_id      BINARY(16) NOT NULL,
    title             VARCHAR(200) NOT NULL,
    published         BIT(1)       NOT NULL,
    registration_date datetime NULL,
    dashboard         BIT(1)       NOT NULL,
    data              LONGTEXT NULL,
    CONSTRAINT pk_report PRIMARY KEY (id)
);

CREATE TABLE resistancepattern
(
    id           BINARY(16) NOT NULL,
    workspace_id BINARY(16) NOT NULL,
    pattern_name VARCHAR(100) NULL,
    criteria     SMALLINT NULL,
    CONSTRAINT pk_resistancepattern PRIMARY KEY (id)
);

CREATE TABLE searchable
(
    id           BINARY(16) NOT NULL,
    workspace_id BINARY(16) NOT NULL,
    type         SMALLINT     NOT NULL,
    title        VARCHAR(100) NOT NULL,
    subtitle     VARCHAR(200) NULL,
    unit_id      BINARY(16) NULL,
    CONSTRAINT pk_searchable PRIMARY KEY (id)
);

CREATE TABLE sequenceinfo
(
    id           BINARY(16) NOT NULL,
    seq_name     VARCHAR(50) NOT NULL,
    number       INT         NOT NULL,
    workspace_id BINARY(16) NOT NULL,
    CONSTRAINT pk_sequenceinfo PRIMARY KEY (id)
);

CREATE TABLE source
(
    id           BINARY(16) NOT NULL,
    workspace_id BINARY(16) NOT NULL,
    name         VARCHAR(100) NOT NULL,
    short_name   VARCHAR(255) NOT NULL,
    custom_id    VARCHAR(50) NULL,
    active       BIT(1)       NOT NULL,
    CONSTRAINT pk_source PRIMARY KEY (id)
);

CREATE TABLE substance
(
    id           BINARY(16) NOT NULL,
    workspace_id BINARY(16) NOT NULL,
    name         VARCHAR(255) NOT NULL,
    short_name   VARCHAR(255) NOT NULL,
    line         SMALLINT     NOT NULL,
    active       BIT(1)       NOT NULL,
    custom_id    VARCHAR(50) NULL,
    CONSTRAINT pk_substance PRIMARY KEY (id)
);

CREATE TABLE substances_resistpattern
(
    resistance_pattern_id BINARY(16) NOT NULL,
    substances_id         BINARY(16) NOT NULL
);

CREATE TABLE sys_user
(
    id                   BINARY(16) NOT NULL,
    login                VARCHAR(30) NOT NULL,
    name                 VARCHAR(80) NOT NULL,
    password             VARCHAR(32) NULL,
    email                VARCHAR(80) NOT NULL,
    active               BIT(1)      NOT NULL,
    password_expired     BIT(1)      NOT NULL,
    email_confirmed      BIT(1)      NOT NULL,
    defaultworkspace_id  BINARY(16) NULL,
    time_zone            VARCHAR(50) NULL,
    comments             VARCHAR(200) NULL,
    parentuser_id        BINARY(16) NULL,
    registration_date    datetime NULL,
    custom_id            VARCHAR(30) NULL,
    send_system_messages BIT(1)      NOT NULL,
    ula_accepted         BIT(1)      NOT NULL,
    password_reset_token VARCHAR(255) NULL,
    mobile               VARCHAR(255) NULL,
    language             VARCHAR(10) NULL,
    CONSTRAINT pk_sys_user PRIMARY KEY (id)
);

CREATE TABLE systemconfig
(
    id                 INT    NOT NULL,
    systemurl          VARCHAR(250) NULL,
    allow_reg_page     BIT(1) NOT NULL,
    workspace_id       BINARY(16) NULL,
    userprofile_id     BINARY(16) NULL,
    unit_id            BINARY(16) NULL,
    admin_mail         VARCHAR(100) NULL,
    update_site        VARCHAR(250) NULL,
    pubds_workspace_id BINARY(16) NULL,
    ula_active         BIT(1) NOT NULL,
    client_mode        BIT(1) NOT NULL,
    serverurl          VARCHAR(250) NULL,
    version            INT NULL,
    sync_unit_id       BINARY(16) NULL,
    CONSTRAINT pk_systemconfig PRIMARY KEY (id)
);

CREATE TABLE tag
(
    id                BINARY(16) NOT NULL,
    workspace_id      BINARY(16) NOT NULL,
    name              VARCHAR(100) NOT NULL,
    sql_condition     LONGTEXT NULL,
    consistency_check BIT(1)       NOT NULL,
    active            BIT(1)       NOT NULL,
    daily_update      BIT(1)       NOT NULL,
    CONSTRAINT pk_tag PRIMARY KEY (id)
);

CREATE TABLE tags_case
(
    case_id BINARY(16) NOT NULL,
    tag_id  BINARY(16) NOT NULL
);

CREATE TABLE tbcase
(
    id                          BINARY(16) NOT NULL,
    workspace_id                BINARY(16) NOT NULL,
    suspect_classification      SMALLINT NULL,
    registration_number         VARCHAR(50) NULL,
    case_number                 VARCHAR(255) NULL,
    patient_id                  BINARY(16) NOT NULL,
    age                         INT NULL,
    registration_date           date     NOT NULL,
    diagnosis_date              date NULL,
    outcome_date                date NULL,
    regimen_id                  BINARY(16) NULL,
    moved_to_individualized     BIT(1)   NOT NULL,
    owner_unit_id               BINARY(16) NOT NULL,
    transfer_out_unit_id        BINARY(16) NULL,
    state                       SMALLINT NOT NULL,
    validated                   BIT(1)   NOT NULL,
    registration_group          VARCHAR(255) NULL,
    case_definition             SMALLINT NULL,
    diagnosis_type              SMALLINT NULL,
    drug_resistance_type        VARCHAR(255) NULL,
    classification              SMALLINT NOT NULL,
    infection_site              SMALLINT NULL,
    pulmonary_type              VARCHAR(50) NULL,
    extrapulmonary_type         VARCHAR(50) NULL,
    extrapulmonary_type2        VARCHAR(50) NULL,
    registration_group_other    VARCHAR(100) NULL,
    nationality                 VARCHAR(50) NULL,
    outcome                     VARCHAR(50) NULL,
    transferring                BIT(1)   NOT NULL,
    other_outcome               VARCHAR(100) NULL,
    custom_id                   VARCHAR(50) NULL,
    notification_unit_id        BINARY(16) NULL,
    moved_second_line_treatment BIT(1)   NOT NULL,
    patient_contact_name        VARCHAR(100) NULL,
    notif_localitytype          SMALLINT NULL,
    phone_number                VARCHAR(50) NULL,
    mobile_number               VARCHAR(50) NULL,
    sec_drugs_received          SMALLINT NULL,
    last_bmu_date_tb_register   date NULL,
    last_bmu_tb_regist_number   VARCHAR(50) NULL,
    ini_treatment_date          date NULL,
    end_treatment_date          date NULL,
    notif_address               VARCHAR(255) NULL,
    notif_complement            VARCHAR(255) NULL,
    notif_zipcode               VARCHAR(255) NULL,
    notif_adminunit_id          BINARY(16) NULL,
    curr_address                VARCHAR(255) NULL,
    curr_complement             VARCHAR(255) NULL,
    curr_zipcode                VARCHAR(255) NULL,
    curr_adminunit_id           BINARY(16) NULL,
    CONSTRAINT pk_tbcase PRIMARY KEY (id)
);

CREATE TABLE transfer
(
    id                 BINARY(16) NOT NULL,
    shipping_date      date     NOT NULL,
    receiving_date     date NULL,
    status             SMALLINT NOT NULL,
    unit_id_from       BINARY(16) NOT NULL,
    unit_id_to         BINARY(16) NOT NULL,
    user_from_id       BINARY(16) NOT NULL,
    user_to_id         BINARY(16) NULL,
    comments_from      LONGTEXT NULL,
    comments_to        LONGTEXT NULL,
    cancel_reason      VARCHAR(200) NULL,
    consignment_number VARCHAR(255) NULL,
    CONSTRAINT pk_transfer PRIMARY KEY (id)
);

CREATE TABLE transferbatch
(
    id                BINARY(16) NOT NULL,
    batch_id          BINARY(16) NOT NULL,
    transferitem_id   BINARY(16) NOT NULL,
    quantity          INT NOT NULL,
    quantity_received INT NULL,
    CONSTRAINT pk_transferbatch PRIMARY KEY (id)
);

CREATE TABLE transferitem
(
    id          BINARY(16) NOT NULL,
    transfer_id BINARY(16) NOT NULL,
    source_id   BINARY(16) NOT NULL,
    product_id  BINARY(16) NOT NULL,
    mov_out_id  BINARY(16) NULL,
    mov_in_id   BINARY(16) NULL,
    CONSTRAINT pk_transferitem PRIMARY KEY (id)
);

CREATE TABLE treatmenthealthunit
(
    id           BINARY(16) NOT NULL,
    case_id      BINARY(16) NOT NULL,
    unit_id      BINARY(16) NOT NULL,
    transferring BIT(1) NOT NULL,
    ini_date     date NULL,
    end_date     date NULL,
    CONSTRAINT pk_treatmenthealthunit PRIMARY KEY (id)
);

CREATE TABLE treatmentmonitoring
(
    id          BINARY(16) NOT NULL,
    case_id     BINARY(16) NOT NULL,
    month_treat INT NULL,
    year_treat  INT NULL,
    day1        SMALLINT NULL,
    day2        SMALLINT NULL,
    day3        SMALLINT NULL,
    day4        SMALLINT NULL,
    day5        SMALLINT NULL,
    day6        SMALLINT NULL,
    day7        SMALLINT NULL,
    day8        SMALLINT NULL,
    day9        SMALLINT NULL,
    day10       SMALLINT NULL,
    day11       SMALLINT NULL,
    day12       SMALLINT NULL,
    day13       SMALLINT NULL,
    day14       SMALLINT NULL,
    day15       SMALLINT NULL,
    day16       SMALLINT NULL,
    day17       SMALLINT NULL,
    day18       SMALLINT NULL,
    day19       SMALLINT NULL,
    day20       SMALLINT NULL,
    day21       SMALLINT NULL,
    day22       SMALLINT NULL,
    day23       SMALLINT NULL,
    day24       SMALLINT NULL,
    day25       SMALLINT NULL,
    day26       SMALLINT NULL,
    day27       SMALLINT NULL,
    day28       SMALLINT NULL,
    day29       SMALLINT NULL,
    day30       SMALLINT NULL,
    day31       SMALLINT NULL,
    CONSTRAINT pk_treatmentmonitoring PRIMARY KEY (id)
);

CREATE TABLE unit
(
    id                        BINARY(16) NOT NULL,
    discriminator             VARCHAR(31) NULL,
    workspace_id              BINARY(16) NOT NULL,
    name                      VARCHAR(250) NOT NULL,
    custom_id                 VARCHAR(50) NULL,
    active                    BIT(1)       NOT NULL,
    ship_contact_name         VARCHAR(200) NULL,
    ship_contact_phone        VARCHAR(200) NULL,
    supplier_id               BINARY(16) NULL,
    authorizerunit_id         BINARY(16) NULL,
    receive_from_manufacturer BIT(1)       NOT NULL,
    inventory_start_date      date NULL,
    inventory_close_date      date NULL,
    address                   VARCHAR(255) NULL,
    address_compl             VARCHAR(255) NULL,
    zipcode                   VARCHAR(255) NULL,
    adminunit_id              BINARY(16) NULL,
    ship_address              VARCHAR(255) NULL,
    ship_address_compl        VARCHAR(255) NULL,
    ship_zip_code             VARCHAR(255) NULL,
    ship_adminunit_id         BINARY(16) NULL,
    tb_facility               BIT(1)       NOT NULL,
    drtb_facility             BIT(1)       NOT NULL,
    ntm_facility              BIT(1)       NOT NULL,
    notification_unit         BIT(1)       NOT NULL,
    num_days_order            INT NULL,
    perform_culture           BIT(1)       NOT NULL,
    perform_microscopy        BIT(1)       NOT NULL,
    perform_dst               BIT(1)       NOT NULL,
    perform_xpert             BIT(1)       NOT NULL,
    CONSTRAINT pk_unit PRIMARY KEY (id)
);

CREATE TABLE userlog
(
    id   BINARY(16) NOT NULL,
    name VARCHAR(100) NOT NULL,
    CONSTRAINT pk_userlog PRIMARY KEY (id)
);

CREATE TABLE userlogin
(
    id           BINARY(16) NOT NULL,
    user_id      BINARY(16) NOT NULL,
    login_date   datetime NOT NULL,
    logout_date  datetime NULL,
    last_access  datetime NULL,
    application  VARCHAR(200) NULL,
    ip_address   VARCHAR(16) NULL,
    workspace_id BINARY(16) NOT NULL,
    CONSTRAINT pk_userlogin PRIMARY KEY (id)
);

CREATE TABLE userpermission
(
    id         BINARY(16) NOT NULL,
    permission VARCHAR(255) NOT NULL,
    profile_id BINARY(16) NOT NULL,
    can_change BIT(1)       NOT NULL,
    CONSTRAINT pk_userpermission PRIMARY KEY (id)
);

CREATE TABLE userprofile
(
    id           BINARY(16) NOT NULL,
    workspace_id BINARY(16) NOT NULL,
    name         VARCHAR(100) NOT NULL,
    custom_id    VARCHAR(50) NULL,
    CONSTRAINT pk_userprofile PRIMARY KEY (id)
);

CREATE TABLE userworkspace
(
    id               BINARY(16) NOT NULL,
    workspace_id     BINARY(16) NOT NULL,
    unit_id          BINARY(16) NULL,
    user_id          BINARY(16) NOT NULL,
    administrator    BIT(1)   NOT NULL,
    user_view        SMALLINT NOT NULL,
    adminunit_id     BINARY(16) NOT NULL,
    play_other_units BIT(1)   NOT NULL,
    CONSTRAINT pk_userworkspace PRIMARY KEY (id)
);

CREATE TABLE userworkspace_profiles
(
    userprofile_id   BINARY(16) NOT NULL,
    userworkspace_id BINARY(16) NOT NULL
);

CREATE TABLE workspace
(
    id                                BINARY(16) NOT NULL,
    name                              VARCHAR(50) NOT NULL,
    view_id                           BINARY(16) NULL,
    patient_name_composition          SMALLINT NULL,
    case_validationtb                 SMALLINT NULL,
    case_validationdrtb               SMALLINT NULL,
    case_validationntm                SMALLINT NULL,
    suspect_case_number               SMALLINT NULL,
    confirmed_case_number             SMALLINT NULL,
    send_system_messages              BIT(1)      NOT NULL,
    months_to_alert_expired_medicines INT NULL,
    min_stock_on_hand                 INT NULL,
    max_stock_on_hand                 INT NULL,
    custom_id                         VARCHAR(255) NULL,
    CONSTRAINT pk_workspace PRIMARY KEY (id)
);

CREATE TABLE workspacelog
(
    id   BINARY(16) NOT NULL,
    name VARCHAR(100) NOT NULL,
    CONSTRAINT pk_workspacelog PRIMARY KEY (id)
);

CREATE TABLE workspaceview
(
    id                   BINARY(16) NOT NULL,
    picture              BLOB NULL,
    logo_image           VARCHAR(200) NULL,
    picture_content_type VARCHAR(20) NULL,
    CONSTRAINT pk_workspaceview PRIMARY KEY (id)
);

ALTER TABLE administrativeunit
    ADD CONSTRAINT FK_ADMINISTRATIVEUNIT_ON_COUNTRYSTRUCTURE FOREIGN KEY (countrystructure_id) REFERENCES countrystructure (id);

ALTER TABLE administrativeunit
    ADD CONSTRAINT FK_ADMINISTRATIVEUNIT_ON_WORKSPACE FOREIGN KEY (workspace_id) REFERENCES workspace (id);

ALTER TABLE agerange
    ADD CONSTRAINT FK_AGERANGE_ON_WORKSPACE FOREIGN KEY (workspace_id) REFERENCES workspace (id);

ALTER TABLE batchdispensing
    ADD CONSTRAINT FK_BATCHDISPENSING_ON_BATCH FOREIGN KEY (batch_id) REFERENCES batch (id);

ALTER TABLE batchdispensing
    ADD CONSTRAINT FK_BATCHDISPENSING_ON_DISPENSING FOREIGN KEY (dispensing_id) REFERENCES medicinedispensing (id);

ALTER TABLE batchdispensing
    ADD CONSTRAINT FK_BATCHDISPENSING_ON_SOURCE FOREIGN KEY (source_id) REFERENCES source (id);

ALTER TABLE batchmovement
    ADD CONSTRAINT FK_BATCHMOVEMENT_ON_BATCH FOREIGN KEY (batch_id) REFERENCES batch (id);

ALTER TABLE batchmovement
    ADD CONSTRAINT FK_BATCHMOVEMENT_ON_MOVEMENT FOREIGN KEY (movement_id) REFERENCES movement (id);

ALTER TABLE batch
    ADD CONSTRAINT FK_BATCH_ON_MEDICINE FOREIGN KEY (medicine_id) REFERENCES product (id);

ALTER TABLE batch
    ADD CONSTRAINT FK_BATCH_ON_WORKSPACE FOREIGN KEY (workspace_id) REFERENCES workspace (id);

ALTER TABLE cacheddata
    ADD CONSTRAINT FK_CACHEDDATA_ON_WORKSPACE FOREIGN KEY (workspace_id) REFERENCES workspace (id);

ALTER TABLE casecomment
    ADD CONSTRAINT FK_CASECOMMENT_ON_CASE FOREIGN KEY (case_id) REFERENCES tbcase (id);

ALTER TABLE casecomment
    ADD CONSTRAINT FK_CASECOMMENT_ON_USER FOREIGN KEY (user_id) REFERENCES sys_user (id);

ALTER TABLE casecomorbidities
    ADD CONSTRAINT FK_CASECOMORBIDITIES_ON_CASE FOREIGN KEY (case_id) REFERENCES tbcase (id);

ALTER TABLE casecontact
    ADD CONSTRAINT FK_CASECONTACT_ON_CASE FOREIGN KEY (case_id) REFERENCES tbcase (id);

ALTER TABLE caseresistancepattern
    ADD CONSTRAINT FK_CASERESISTANCEPATTERN_ON_CASE FOREIGN KEY (case_id) REFERENCES tbcase (id);

ALTER TABLE caseresistancepattern
    ADD CONSTRAINT FK_CASERESISTANCEPATTERN_ON_RESISTPATTERN FOREIGN KEY (resistpattern_id) REFERENCES resistancepattern (id);

ALTER TABLE casesideeffect
    ADD CONSTRAINT FK_CASESIDEEFFECT_ON_CASE FOREIGN KEY (case_id) REFERENCES tbcase (id);

ALTER TABLE casesideeffect
    ADD CONSTRAINT FK_CASESIDEEFFECT_ON_SUBSTANCE FOREIGN KEY (substance_id) REFERENCES substance (id);

ALTER TABLE casesideeffect
    ADD CONSTRAINT FK_CASESIDEEFFECT_ON_SUBSTANCE2 FOREIGN KEY (substance2_id) REFERENCES substance (id);

ALTER TABLE commandhistory
    ADD CONSTRAINT FK_COMMANDHISTORY_ON_UNIT FOREIGN KEY (unit_id) REFERENCES unit (id);

ALTER TABLE commandhistory
    ADD CONSTRAINT FK_COMMANDHISTORY_ON_USERLOG FOREIGN KEY (userlog_id) REFERENCES userlog (id);

ALTER TABLE commandhistory
    ADD CONSTRAINT FK_COMMANDHISTORY_ON_WORKSPACELOG FOREIGN KEY (workspacelog_id) REFERENCES workspacelog (id);

ALTER TABLE countrystructure
    ADD CONSTRAINT FK_COUNTRYSTRUCTURE_ON_WORKSPACE FOREIGN KEY (workspace_id) REFERENCES workspace (id);

ALTER TABLE examculture
    ADD CONSTRAINT FK_EXAMCULTURE_ON_CASE FOREIGN KEY (case_id) REFERENCES tbcase (id);

ALTER TABLE examculture
    ADD CONSTRAINT FK_EXAMCULTURE_ON_LABORATORY FOREIGN KEY (laboratory_id) REFERENCES unit (id);

ALTER TABLE examculture
    ADD CONSTRAINT FK_EXAMCULTURE_ON_REQUEST FOREIGN KEY (request_id) REFERENCES examrequest (id);

ALTER TABLE examdst
    ADD CONSTRAINT FK_EXAMDST_ON_CASE FOREIGN KEY (case_id) REFERENCES tbcase (id);

ALTER TABLE examdst
    ADD CONSTRAINT FK_EXAMDST_ON_LABORATORY FOREIGN KEY (laboratory_id) REFERENCES unit (id);

ALTER TABLE examdst
    ADD CONSTRAINT FK_EXAMDST_ON_REQUEST FOREIGN KEY (request_id) REFERENCES examrequest (id);

ALTER TABLE examhiv
    ADD CONSTRAINT FK_EXAMHIV_ON_CASE FOREIGN KEY (case_id) REFERENCES tbcase (id);

ALTER TABLE exammicroscopy
    ADD CONSTRAINT FK_EXAMMICROSCOPY_ON_CASE FOREIGN KEY (case_id) REFERENCES tbcase (id);

ALTER TABLE exammicroscopy
    ADD CONSTRAINT FK_EXAMMICROSCOPY_ON_LABORATORY FOREIGN KEY (laboratory_id) REFERENCES unit (id);

ALTER TABLE exammicroscopy
    ADD CONSTRAINT FK_EXAMMICROSCOPY_ON_REQUEST FOREIGN KEY (request_id) REFERENCES examrequest (id);

ALTER TABLE examrequest
    ADD CONSTRAINT FK_EXAMREQUEST_ON_CASE FOREIGN KEY (case_id) REFERENCES tbcase (id);

ALTER TABLE examrequest
    ADD CONSTRAINT FK_EXAMREQUEST_ON_LABORATORY FOREIGN KEY (laboratory_id) REFERENCES unit (id);

ALTER TABLE examrequest
    ADD CONSTRAINT FK_EXAMREQUEST_ON_UNIT FOREIGN KEY (unit_id) REFERENCES unit (id);

ALTER TABLE examrequest
    ADD CONSTRAINT FK_EXAMREQUEST_ON_USER FOREIGN KEY (user_id) REFERENCES sys_user (id);

ALTER TABLE examxpert
    ADD CONSTRAINT FK_EXAMXPERT_ON_CASE FOREIGN KEY (case_id) REFERENCES tbcase (id);

ALTER TABLE examxpert
    ADD CONSTRAINT FK_EXAMXPERT_ON_LABORATORY FOREIGN KEY (laboratory_id) REFERENCES unit (id);

ALTER TABLE examxpert
    ADD CONSTRAINT FK_EXAMXPERT_ON_REQUEST FOREIGN KEY (request_id) REFERENCES examrequest (id);

ALTER TABLE examxray
    ADD CONSTRAINT FK_EXAMXRAY_ON_CASE FOREIGN KEY (case_id) REFERENCES tbcase (id);

ALTER TABLE formdata
    ADD CONSTRAINT FK_FORMDATA_ON_WORKSPACE FOREIGN KEY (workspace_id) REFERENCES workspace (id);

ALTER TABLE issuefollowup
    ADD CONSTRAINT FK_ISSUEFOLLOWUP_ON_ISSUE FOREIGN KEY (issue_id) REFERENCES issue (id);

ALTER TABLE issuefollowup
    ADD CONSTRAINT FK_ISSUEFOLLOWUP_ON_UNIT FOREIGN KEY (unit_id) REFERENCES unit (id);

ALTER TABLE issuefollowup
    ADD CONSTRAINT FK_ISSUEFOLLOWUP_ON_USER FOREIGN KEY (user_id) REFERENCES sys_user (id);

ALTER TABLE issue
    ADD CONSTRAINT FK_ISSUE_ON_CASE FOREIGN KEY (case_id) REFERENCES tbcase (id);

ALTER TABLE issue
    ADD CONSTRAINT FK_ISSUE_ON_UNIT FOREIGN KEY (unit_id) REFERENCES unit (id);

ALTER TABLE issue
    ADD CONSTRAINT FK_ISSUE_ON_USER FOREIGN KEY (user_id) REFERENCES sys_user (id);

ALTER TABLE medicalexamination
    ADD CONSTRAINT FK_MEDICALEXAMINATION_ON_CASE FOREIGN KEY (case_id) REFERENCES tbcase (id);

ALTER TABLE medicinedispensingcase
    ADD CONSTRAINT FK_MEDICINEDISPENSINGCASE_ON_BATCH FOREIGN KEY (batch_id) REFERENCES batch (id);

ALTER TABLE medicinedispensingcase
    ADD CONSTRAINT FK_MEDICINEDISPENSINGCASE_ON_CASE FOREIGN KEY (case_id) REFERENCES tbcase (id);

ALTER TABLE medicinedispensingcase
    ADD CONSTRAINT FK_MEDICINEDISPENSINGCASE_ON_DISPENSING FOREIGN KEY (dispensing_id) REFERENCES medicinedispensing (id);

ALTER TABLE medicinedispensingcase
    ADD CONSTRAINT FK_MEDICINEDISPENSINGCASE_ON_SOURCE FOREIGN KEY (source_id) REFERENCES source (id);

ALTER TABLE medicinedispensing
    ADD CONSTRAINT FK_MEDICINEDISPENSING_ON_UNIT FOREIGN KEY (unit_id) REFERENCES unit (id);

ALTER TABLE medicineregimen
    ADD CONSTRAINT FK_MEDICINEREGIMEN_ON_MEDICINE FOREIGN KEY (medicine_id) REFERENCES product (id);

ALTER TABLE medicineregimen
    ADD CONSTRAINT FK_MEDICINEREGIMEN_ON_REGIMEN FOREIGN KEY (regimen_id) REFERENCES regimen (id);

ALTER TABLE movement
    ADD CONSTRAINT FK_MOVEMENT_ON_PRODUCT FOREIGN KEY (product_id) REFERENCES product (id);

ALTER TABLE movement
    ADD CONSTRAINT FK_MOVEMENT_ON_SOURCE FOREIGN KEY (source_id) REFERENCES source (id);

ALTER TABLE movement
    ADD CONSTRAINT FK_MOVEMENT_ON_UNIT FOREIGN KEY (unit_id) REFERENCES unit (id);

ALTER TABLE orderbatch
    ADD CONSTRAINT FK_ORDERBATCH_ON_BATCH FOREIGN KEY (batch_id) REFERENCES batch (id);

ALTER TABLE orderbatch
    ADD CONSTRAINT FK_ORDERBATCH_ON_ORDERITEM FOREIGN KEY (orderitem_id) REFERENCES orderitem (id);

ALTER TABLE ordercase
    ADD CONSTRAINT FK_ORDERCASE_ON_CASE FOREIGN KEY (case_id) REFERENCES tbcase (id);

ALTER TABLE ordercase
    ADD CONSTRAINT FK_ORDERCASE_ON_ORDERITEM FOREIGN KEY (orderitem_id) REFERENCES orderitem (id);

ALTER TABLE ordercomment
    ADD CONSTRAINT FK_ORDERCOMMENT_ON_ORDER FOREIGN KEY (order_id) REFERENCES productorder (id);

ALTER TABLE ordercomment
    ADD CONSTRAINT FK_ORDERCOMMENT_ON_USER_CREATOR FOREIGN KEY (user_creator_id) REFERENCES sys_user (id);

ALTER TABLE orderitem
    ADD CONSTRAINT FK_ORDERITEM_ON_MOVEMENT_IN FOREIGN KEY (movement_in_id) REFERENCES movement (id);

ALTER TABLE orderitem
    ADD CONSTRAINT FK_ORDERITEM_ON_MOVEMENT_OUT FOREIGN KEY (movement_out_id) REFERENCES movement (id);

ALTER TABLE orderitem
    ADD CONSTRAINT FK_ORDERITEM_ON_ORDER FOREIGN KEY (order_id) REFERENCES productorder (id);

ALTER TABLE orderitem
    ADD CONSTRAINT FK_ORDERITEM_ON_PRODUCT FOREIGN KEY (product_id) REFERENCES product (id);

ALTER TABLE orderitem
    ADD CONSTRAINT FK_ORDERITEM_ON_SOURCE FOREIGN KEY (source_id) REFERENCES source (id);

ALTER TABLE patient
    ADD CONSTRAINT FK_PATIENT_ON_WORKSPACE FOREIGN KEY (workspace_id) REFERENCES workspace (id);

ALTER TABLE prescribedmedicine
    ADD CONSTRAINT FK_PRESCRIBEDMEDICINE_ON_CASE FOREIGN KEY (case_id) REFERENCES tbcase (id);

ALTER TABLE prescribedmedicine
    ADD CONSTRAINT FK_PRESCRIBEDMEDICINE_ON_PRODUCT FOREIGN KEY (product_id) REFERENCES product (id);

ALTER TABLE prevtbtreatment
    ADD CONSTRAINT FK_PREVTBTREATMENT_ON_CASE FOREIGN KEY (case_id) REFERENCES tbcase (id);

ALTER TABLE productorder
    ADD CONSTRAINT FK_PRODUCTORDER_ON_AUTHORIZER_UNIT FOREIGN KEY (authorizer_unit_id) REFERENCES unit (id);

ALTER TABLE productorder
    ADD CONSTRAINT FK_PRODUCTORDER_ON_SHIP_ADMINUNIT FOREIGN KEY (ship_adminunit_id) REFERENCES administrativeunit (id);

ALTER TABLE productorder
    ADD CONSTRAINT FK_PRODUCTORDER_ON_UNIT_FROM FOREIGN KEY (unit_from_id) REFERENCES unit (id);

ALTER TABLE productorder
    ADD CONSTRAINT FK_PRODUCTORDER_ON_UNIT_TO FOREIGN KEY (unit_to_id) REFERENCES unit (id);

ALTER TABLE productorder
    ADD CONSTRAINT FK_PRODUCTORDER_ON_USER_CREATOR FOREIGN KEY (user_creator_id) REFERENCES sys_user (id);

ALTER TABLE productorder
    ADD CONSTRAINT FK_PRODUCTORDER_ON_WORKSPACE FOREIGN KEY (workspace_id) REFERENCES workspace (id);

ALTER TABLE productreceiving
    ADD CONSTRAINT FK_PRODUCTRECEIVING_ON_SOURCE FOREIGN KEY (source_id) REFERENCES source (id);

ALTER TABLE productreceiving
    ADD CONSTRAINT FK_PRODUCTRECEIVING_ON_UNIT FOREIGN KEY (unit_id) REFERENCES unit (id);

ALTER TABLE product
    ADD CONSTRAINT FK_PRODUCT_ON_WORKSPACE FOREIGN KEY (workspace_id) REFERENCES workspace (id);

ALTER TABLE regimen
    ADD CONSTRAINT FK_REGIMEN_ON_WORKSPACE FOREIGN KEY (workspace_id) REFERENCES workspace (id);

ALTER TABLE report
    ADD CONSTRAINT FK_REPORT_ON_WORKSPACE FOREIGN KEY (workspace_id) REFERENCES workspace (id);

ALTER TABLE resistancepattern
    ADD CONSTRAINT FK_RESISTANCEPATTERN_ON_WORKSPACE FOREIGN KEY (workspace_id) REFERENCES workspace (id);

ALTER TABLE searchable
    ADD CONSTRAINT FK_SEARCHABLE_ON_UNIT FOREIGN KEY (unit_id) REFERENCES unit (id);

ALTER TABLE searchable
    ADD CONSTRAINT FK_SEARCHABLE_ON_WORKSPACE FOREIGN KEY (workspace_id) REFERENCES workspace (id);

ALTER TABLE sequenceinfo
    ADD CONSTRAINT FK_SEQUENCEINFO_ON_WORKSPACE FOREIGN KEY (workspace_id) REFERENCES workspace (id);

ALTER TABLE source
    ADD CONSTRAINT FK_SOURCE_ON_WORKSPACE FOREIGN KEY (workspace_id) REFERENCES workspace (id);

ALTER TABLE substance
    ADD CONSTRAINT FK_SUBSTANCE_ON_WORKSPACE FOREIGN KEY (workspace_id) REFERENCES workspace (id);

ALTER TABLE systemconfig
    ADD CONSTRAINT FK_SYSTEMCONFIG_ON_PUBDS_WORKSPACE FOREIGN KEY (pubds_workspace_id) REFERENCES workspace (id);

ALTER TABLE systemconfig
    ADD CONSTRAINT FK_SYSTEMCONFIG_ON_SYNC_UNIT FOREIGN KEY (sync_unit_id) REFERENCES unit (id);

ALTER TABLE systemconfig
    ADD CONSTRAINT FK_SYSTEMCONFIG_ON_UNIT FOREIGN KEY (unit_id) REFERENCES unit (id);

ALTER TABLE systemconfig
    ADD CONSTRAINT FK_SYSTEMCONFIG_ON_USERPROFILE FOREIGN KEY (userprofile_id) REFERENCES userprofile (id);

ALTER TABLE systemconfig
    ADD CONSTRAINT FK_SYSTEMCONFIG_ON_WORKSPACE FOREIGN KEY (workspace_id) REFERENCES workspace (id);

ALTER TABLE sys_user
    ADD CONSTRAINT FK_SYS_USER_ON_DEFAULTWORKSPACE FOREIGN KEY (defaultworkspace_id) REFERENCES userworkspace (id);

ALTER TABLE sys_user
    ADD CONSTRAINT FK_SYS_USER_ON_PARENTUSER FOREIGN KEY (parentuser_id) REFERENCES sys_user (id);

ALTER TABLE tag
    ADD CONSTRAINT FK_TAG_ON_WORKSPACE FOREIGN KEY (workspace_id) REFERENCES workspace (id);

ALTER TABLE tbcase
    ADD CONSTRAINT FK_TBCASE_ON_CURR_ADMINUNIT FOREIGN KEY (curr_adminunit_id) REFERENCES administrativeunit (id);

ALTER TABLE tbcase
    ADD CONSTRAINT FK_TBCASE_ON_NOTIFICATION_UNIT FOREIGN KEY (notification_unit_id) REFERENCES unit (id);

ALTER TABLE tbcase
    ADD CONSTRAINT FK_TBCASE_ON_NOTIF_ADMINUNIT FOREIGN KEY (notif_adminunit_id) REFERENCES administrativeunit (id);

ALTER TABLE tbcase
    ADD CONSTRAINT FK_TBCASE_ON_OWNER_UNIT FOREIGN KEY (owner_unit_id) REFERENCES unit (id);

ALTER TABLE tbcase
    ADD CONSTRAINT FK_TBCASE_ON_PATIENT FOREIGN KEY (patient_id) REFERENCES patient (id);

ALTER TABLE tbcase
    ADD CONSTRAINT FK_TBCASE_ON_REGIMEN FOREIGN KEY (regimen_id) REFERENCES regimen (id);

ALTER TABLE tbcase
    ADD CONSTRAINT FK_TBCASE_ON_TRANSFER_OUT_UNIT FOREIGN KEY (transfer_out_unit_id) REFERENCES unit (id);

ALTER TABLE tbcase
    ADD CONSTRAINT FK_TBCASE_ON_WORKSPACE FOREIGN KEY (workspace_id) REFERENCES workspace (id);

ALTER TABLE transferbatch
    ADD CONSTRAINT FK_TRANSFERBATCH_ON_BATCH FOREIGN KEY (batch_id) REFERENCES batch (id);

ALTER TABLE transferbatch
    ADD CONSTRAINT FK_TRANSFERBATCH_ON_TRANSFERITEM FOREIGN KEY (transferitem_id) REFERENCES transferitem (id);

ALTER TABLE transferitem
    ADD CONSTRAINT FK_TRANSFERITEM_ON_MOV_IN FOREIGN KEY (mov_in_id) REFERENCES movement (id);

ALTER TABLE transferitem
    ADD CONSTRAINT FK_TRANSFERITEM_ON_MOV_OUT FOREIGN KEY (mov_out_id) REFERENCES movement (id);

ALTER TABLE transferitem
    ADD CONSTRAINT FK_TRANSFERITEM_ON_PRODUCT FOREIGN KEY (product_id) REFERENCES product (id);

ALTER TABLE transferitem
    ADD CONSTRAINT FK_TRANSFERITEM_ON_SOURCE FOREIGN KEY (source_id) REFERENCES source (id);

ALTER TABLE transferitem
    ADD CONSTRAINT FK_TRANSFERITEM_ON_TRANSFER FOREIGN KEY (transfer_id) REFERENCES transfer (id);

ALTER TABLE transfer
    ADD CONSTRAINT FK_TRANSFER_ON_UNIT_ID_FROM FOREIGN KEY (unit_id_from) REFERENCES unit (id);

ALTER TABLE transfer
    ADD CONSTRAINT FK_TRANSFER_ON_UNIT_ID_TO FOREIGN KEY (unit_id_to) REFERENCES unit (id);

ALTER TABLE transfer
    ADD CONSTRAINT FK_TRANSFER_ON_USER_FROM FOREIGN KEY (user_from_id) REFERENCES sys_user (id);

ALTER TABLE transfer
    ADD CONSTRAINT FK_TRANSFER_ON_USER_TO FOREIGN KEY (user_to_id) REFERENCES sys_user (id);

ALTER TABLE treatmenthealthunit
    ADD CONSTRAINT FK_TREATMENTHEALTHUNIT_ON_CASE FOREIGN KEY (case_id) REFERENCES tbcase (id);

ALTER TABLE treatmenthealthunit
    ADD CONSTRAINT FK_TREATMENTHEALTHUNIT_ON_UNIT FOREIGN KEY (unit_id) REFERENCES unit (id);

ALTER TABLE treatmentmonitoring
    ADD CONSTRAINT FK_TREATMENTMONITORING_ON_CASE FOREIGN KEY (case_id) REFERENCES tbcase (id);

ALTER TABLE unit
    ADD CONSTRAINT FK_UNIT_ON_ADMINUNIT FOREIGN KEY (adminunit_id) REFERENCES administrativeunit (id);

ALTER TABLE unit
    ADD CONSTRAINT FK_UNIT_ON_AUTHORIZERUNIT FOREIGN KEY (authorizerunit_id) REFERENCES unit (id);

ALTER TABLE unit
    ADD CONSTRAINT FK_UNIT_ON_SHIP_ADMINUNIT FOREIGN KEY (ship_adminunit_id) REFERENCES administrativeunit (id);

ALTER TABLE unit
    ADD CONSTRAINT FK_UNIT_ON_SUPPLIER FOREIGN KEY (supplier_id) REFERENCES unit (id);

ALTER TABLE unit
    ADD CONSTRAINT FK_UNIT_ON_WORKSPACE FOREIGN KEY (workspace_id) REFERENCES workspace (id);

ALTER TABLE userlogin
    ADD CONSTRAINT FK_USERLOGIN_ON_USER FOREIGN KEY (user_id) REFERENCES sys_user (id);

ALTER TABLE userlogin
    ADD CONSTRAINT FK_USERLOGIN_ON_WORKSPACE FOREIGN KEY (workspace_id) REFERENCES workspace (id);

ALTER TABLE userpermission
    ADD CONSTRAINT FK_USERPERMISSION_ON_PROFILE FOREIGN KEY (profile_id) REFERENCES userprofile (id);

ALTER TABLE userprofile
    ADD CONSTRAINT FK_USERPROFILE_ON_WORKSPACE FOREIGN KEY (workspace_id) REFERENCES workspace (id);

ALTER TABLE userworkspace
    ADD CONSTRAINT FK_USERWORKSPACE_ON_ADMINUNIT FOREIGN KEY (adminunit_id) REFERENCES administrativeunit (id);

ALTER TABLE userworkspace
    ADD CONSTRAINT FK_USERWORKSPACE_ON_UNIT FOREIGN KEY (unit_id) REFERENCES unit (id);

ALTER TABLE userworkspace
    ADD CONSTRAINT FK_USERWORKSPACE_ON_USER FOREIGN KEY (user_id) REFERENCES sys_user (id);

ALTER TABLE userworkspace
    ADD CONSTRAINT FK_USERWORKSPACE_ON_WORKSPACE FOREIGN KEY (workspace_id) REFERENCES workspace (id);

ALTER TABLE workspace
    ADD CONSTRAINT FK_WORKSPACE_ON_VIEW FOREIGN KEY (view_id) REFERENCES workspaceview (id);

ALTER TABLE medicine_substances
    ADD CONSTRAINT fk_medsub_on_medicine FOREIGN KEY (medicine_id) REFERENCES product (id);

ALTER TABLE medicine_substances
    ADD CONSTRAINT fk_medsub_on_substance FOREIGN KEY (substance_id) REFERENCES substance (id);

ALTER TABLE movements_dispensing
    ADD CONSTRAINT fk_movdis_on_medicine_dispensing FOREIGN KEY (dispensing_id) REFERENCES medicinedispensing (id);

ALTER TABLE movements_dispensing
    ADD CONSTRAINT fk_movdis_on_movement FOREIGN KEY (movement_id) REFERENCES movement (id);

ALTER TABLE movements_receiving
    ADD CONSTRAINT fk_movrec_on_movement FOREIGN KEY (movement_id) REFERENCES movement (id);

ALTER TABLE movements_receiving
    ADD CONSTRAINT fk_movrec_on_product_receiving FOREIGN KEY (receiving_id) REFERENCES productreceiving (id);

ALTER TABLE substances_resistpattern
    ADD CONSTRAINT fk_subres_on_resistance_pattern FOREIGN KEY (resistance_pattern_id) REFERENCES resistancepattern (id);

ALTER TABLE substances_resistpattern
    ADD CONSTRAINT fk_subres_on_substance FOREIGN KEY (substances_id) REFERENCES substance (id);

ALTER TABLE tags_case
    ADD CONSTRAINT fk_tags_case_on_tag FOREIGN KEY (tag_id) REFERENCES tag (id);

ALTER TABLE tags_case
    ADD CONSTRAINT fk_tags_case_on_tb_case FOREIGN KEY (case_id) REFERENCES tbcase (id);

ALTER TABLE userworkspace_profiles
    ADD CONSTRAINT fk_usepro_on_user_profile FOREIGN KEY (userprofile_id) REFERENCES userprofile (id);

ALTER TABLE userworkspace_profiles
    ADD CONSTRAINT fk_usepro_on_user_workspace FOREIGN KEY (userworkspace_id) REFERENCES userworkspace (id);