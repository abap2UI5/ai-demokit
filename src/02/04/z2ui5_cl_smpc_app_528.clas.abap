" @keywords gridcontainer grid container sap.f gridcontainersnavigation scrollcontainer togglebutton hbox panel flexitemdata generictile gridcontaineritemlayoutdata
" @summary This sample demonstrates the keyboard navigation between multiple grids
CLASS z2ui5_cl_smpc_app_528 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_row,
             title       TYPE string,
             description TYPE string,
             icon        TYPE string,
             info        TYPE string,
             infostate   TYPE string,
             highlight   TYPE string,
           END OF ty_s_row.
    TYPES ty_t_row TYPE STANDARD TABLE OF ty_s_row WITH DEFAULT KEY.

    TYPES: BEGIN OF ty_s_employee,
             firstname TYPE string,
             lastname  TYPE string,
             birthdate TYPE string,
           END OF ty_s_employee.
    TYPES ty_t_employee TYPE STANDARD TABLE OF ty_s_employee WITH DEFAULT KEY.

    DATA t_orders     TYPE ty_t_row.
    DATA t_employees  TYPE ty_t_employee.
    DATA t_tasks      TYPE ty_t_row.
    DATA t_contacts   TYPE ty_t_row.
    DATA t_withaction TYPE ty_t_row.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_528 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA border TYPE string.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    DATA temp3 TYPE string_table.
    DATA temp4 TYPE string_table.
    DATA temp5 LIKE LINE OF temp4.
    DATA temp6 TYPE string_table.
    DATA temp7 LIKE LINE OF temp6.
    DATA temp8 TYPE string_table.
    DATA temp9 LIKE LINE OF temp8.
    DATA temp10 TYPE string_table.
    DATA temp11 TYPE string_table.
    DATA temp12 LIKE LINE OF temp11.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " onBorderReached toasts '<panel header> border reached' and moves the focus
    " into the neighbouring grid; the toast is composed on the client here (the
    " focus hand-off has no counterpart - see sidecar)
    
    border = `MESSAGE_TOAST`.

    
    CLEAR temp1.
    INSERT border INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `Group 1 border reached` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT border INTO TABLE temp2.
    INSERT `show` INTO TABLE temp2.
    INSERT `Group 2 border reached` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT border INTO TABLE temp3.
    INSERT `show` INTO TABLE temp3.
    INSERT `Group 3 border reached` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `TRIGGER_TEL` INTO TABLE temp4.
    
    temp5 = |\{ TEL: '+1 202 34869-0' \}|.
    INSERT temp5 INTO TABLE temp4.
    
    CLEAR temp6.
    INSERT `TRIGGER_TEL` INTO TABLE temp6.
    
    temp7 = |\{ TEL: '+1 202 555 5555' \}|.
    INSERT temp7 INTO TABLE temp6.
    
    CLEAR temp8.
    INSERT `TRIGGER_EMAIL` INTO TABLE temp8.
    
    temp9 = |\{ EMAIL: 'donna@peachvalley.com' \}|.
    INSERT temp9 INTO TABLE temp8.
    
    CLEAR temp10.
    INSERT border INTO TABLE temp10.
    INSERT `show` INTO TABLE temp10.
    INSERT `Group 4 border reached` INTO TABLE temp10.
    
    CLEAR temp11.
    INSERT `REDIRECT` INTO TABLE temp11.
    
    temp12 = |\{ URL: 'https://www.sap.com', NEW_WINDOW: true \}|.
    INSERT temp12 INTO TABLE temp11.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:f`      v = `sap.f`
        )->a( n = `xmlns:card`   v = `sap.f.cards`
        )->a( n = `displayBlock` v = `true`
        )->a( n = `height`       v = `100%`

        )->ele( `ScrollContainer`
            )->a( n = `height`   v = `100%`
            )->a( n = `width`    v = `100%`
            )->a( n = `vertical` v = `true`

            " press wire dropped (declared): RevealGrid is a sample-local JS
            " helper module (grid outline overlay) with no declarative equivalent
            )->tag( `ToggleButton`
                )->a( n = `id`    v = `revealGrid`
                )->a( n = `text`  v = `Reveal Grids`
                )->a( n = `class` v = `sapUiSmallMargin`

            )->ele( `HBox`

                )->ele( `Panel`
                    )->a( n = `headerText` v = `Group 1`
                    )->a( n = `height`     v = `100%`

                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `baseSize` v = `50%`

                    )->end(

                    )->ele( n = `GridContainer` ns = `f`
                        )->a( n = `id`             v = `grid1`
                        )->a( n = `borderReached`  v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                 t_arg = temp1 )

                        )->ele( `GenericTile`
                            )->a( n = `header`    v = `Cumulative Totals`
                            )->a( n = `subheader` v = `Expenses`

                            )->ele( `layoutData`
                                )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                    )->a( n = `minRows` v = `2`
                                    )->a( n = `columns` v = `2`

                            )->end(
                            )->ele( `TileContent`
                                )->a( n = `unit`   v = `Unit`
                                )->a( n = `footer` v = `Footer Text`
                                )->tag( `NumericContent`
                                    )->a( n = `value` v = `1762`
                                    )->a( n = `icon`  v = `sap-icon://line-charts`

                            )->end(
                        )->end(

                        " listContent/orders, rebuilt declaratively (see sidecar)
                        )->ele( n = `Card` ns = `f`

                            )->ele( n = `layoutData` ns = `f`
                                )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                    )->a( n = `columns` v = `3`

                            )->end(
                            )->ele( n = `header` ns = `f`
                                )->tag( n = `Header` ns = `card`
                                    )->a( n = `title`      v = `Orders in the last 24 hours`
                                    )->a( n = `statusText` v = `3 of 3`

                            )->end(
                            )->ele( n = `content` ns = `f`
                                )->ele( `List`
                                    )->a( n = `showSeparators` v = `None`
                                    )->a( n = `items`          v = client->_bind( t_orders )
                                    )->tag( `StandardListItem`
                                        )->a( n = `title`       v = `{TITLE}`
                                        )->a( n = `description` v = `{DESCRIPTION}`
                                        )->a( n = `info`        v = `{INFO}`
                                        )->a( n = `infoState`   v = `{INFOSTATE}`

                                )->end(
                            )->end(
                        )->end(

                        )->ele( `GenericTile`
                            )->a( n = `header`    v = `Manage Activity Master Data Type`
                            )->a( n = `subheader` v = `Subtitle`

                            )->ele( `layoutData`
                                )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                    )->a( n = `minRows` v = `2`
                                    )->a( n = `columns` v = `2`

                            )->end(
                            )->ele( `TileContent`
                                )->tag( `ImageContent`
                                    )->a( n = `src` v = `sap-icon://activities`

                            )->end(
                        )->end(

                        " tableContent/employees, rebuilt declaratively
                        )->ele( n = `Card` ns = `f`

                            )->ele( n = `layoutData` ns = `f`
                                )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                    )->a( n = `minRows` v = `3`
                                    )->a( n = `columns` v = `4`

                            )->end(
                            )->ele( n = `header` ns = `f`
                                )->tag( n = `Header` ns = `card`
                                    )->a( n = `title`    v = `Employees Info`
                                    )->a( n = `subtitle` v = `Birthdates of Employees`

                            )->end(
                            )->ele( n = `content` ns = `f`
                                )->ele( `Table`
                                    )->a( n = `items` v = client->_bind( t_employees )

                                    )->ele( `columns`
                                        )->ele( `Column`
                                            )->tag( `Text`
                                                )->a( n = `text` v = `First Name`

                                        )->end(
                                        )->ele( `Column`
                                            )->tag( `Text`
                                                )->a( n = `text` v = `Last Name`

                                        )->end(
                                        )->ele( `Column`
                                            )->tag( `Text`
                                                )->a( n = `text` v = `Birthdate`

                                        )->end(
                                    )->end(
                                    )->ele( `items`
                                        )->ele( `ColumnListItem`
                                            )->ele( `cells`
                                                )->tag( `Text`
                                                    )->a( n = `text` v = `{FIRSTNAME}`
                                                )->tag( `Text`
                                                    )->a( n = `text` v = `{LASTNAME}`
                                                )->tag( `Text`
                                                    )->a( n = `text` v = `{BIRTHDATE}`

                                            )->end(
                                        )->end(
                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `Panel`
                    )->a( n = `headerText` v = `Group 2`
                    )->a( n = `height`     v = `100%`

                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `baseSize` v = `50%`

                    )->end(

                    )->ele( n = `GridContainer` ns = `f`
                        )->a( n = `id`            v = `grid2`
                        )->a( n = `borderReached` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                t_arg = temp2 )

                        " listContent/tasks, rebuilt declaratively
                        )->ele( n = `Card` ns = `f`

                            )->ele( n = `layoutData` ns = `f`
                                )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                    )->a( n = `minRows` v = `2`
                                    )->a( n = `columns` v = `3`

                            )->end(
                            )->ele( n = `header` ns = `f`
                                )->tag( n = `Header` ns = `card`
                                    )->a( n = `title`    v = `Tasks`
                                    )->a( n = `subtitle` v = `Upcoming`
                                    )->a( n = `iconSrc`  v = `sap-icon://activities`

                            )->end(
                            )->ele( n = `content` ns = `f`
                                )->ele( `List`
                                    )->a( n = `showSeparators` v = `None`
                                    )->a( n = `items`          v = client->_bind( t_tasks )
                                    )->tag( `StandardListItem`
                                        )->a( n = `title`     v = `{TITLE}`
                                        )->a( n = `icon`      v = `{ICON}`
                                        )->a( n = `infoState` v = `{INFOSTATE}`

                                )->end(
                            )->end(
                        )->end(

                        )->ele( `GenericTile`
                            )->a( n = `header`    v = `Account`
                            )->a( n = `subheader` v = `Your personal information`

                            )->ele( `layoutData`
                                )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                    )->a( n = `rows`    v = `2`
                                    )->a( n = `columns` v = `2`

                            )->end(
                            )->ele( `TileContent`
                                )->tag( `ImageContent`
                                    )->a( n = `src` v = `sap-icon://account`

                            )->end(
                        )->end(

                        )->ele( `GenericTile`
                            )->a( n = `header` v = `Profit Margin`

                            )->ele( `layoutData`
                                )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                    )->a( n = `minRows` v = `2`
                                    )->a( n = `columns` v = `2`

                            )->end(
                            )->ele( `TileContent`
                                )->a( n = `unit` v = `Unit`
                                )->tag( `NumericContent`
                                    )->a( n = `scale`      v = `%`
                                    )->a( n = `value`      v = `12`
                                    )->a( n = `valueColor` v = `Critical`
                                    )->a( n = `indicator`  v = `Up`

                            )->end(
                        )->end(

                        " listContent/contacts, rebuilt declaratively
                        )->ele( n = `Card` ns = `f`

                            )->ele( n = `layoutData` ns = `f`
                                )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                    )->a( n = `minRows` v = `4`
                                    )->a( n = `columns` v = `3`

                            )->end(
                            )->ele( n = `header` ns = `f`
                                )->tag( n = `Header` ns = `card`
                                    )->a( n = `title`    v = `Contacts`
                                    )->a( n = `subtitle` v = `Recent`
                                    )->a( n = `iconSrc`  v = `sap-icon://activities`

                            )->end(
                            )->ele( n = `content` ns = `f`
                                )->ele( `List`
                                    )->a( n = `showSeparators` v = `None`
                                    )->a( n = `items`          v = client->_bind( t_contacts )
                                    )->tag( `StandardListItem`
                                        )->a( n = `title` v = `{TITLE}`
                                        )->a( n = `icon`  v = `{ICON}`

                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( `HBox`

                )->ele( `Panel`
                    )->a( n = `headerText` v = `Group 3`
                    )->a( n = `height`     v = `100%`

                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `baseSize` v = `50%`

                    )->end(

                    )->ele( n = `GridContainer` ns = `f`
                        )->a( n = `id`            v = `grid3`
                        )->a( n = `borderReached` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                t_arg = temp3 )

                        " objectContent/contact, rebuilt declaratively
                        )->ele( n = `Card` ns = `f`

                            )->ele( n = `layoutData` ns = `f`
                                )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                    )->a( n = `minRows` v = `4`
                                    )->a( n = `columns` v = `3`

                            )->end(
                            )->ele( n = `header` ns = `f`
                                )->tag( n = `Header` ns = `card`
                                    )->a( n = `title`    v = `Donna Mendez`
                                    )->a( n = `subtitle` v = `Managing Partner`

                            )->end(
                            )->ele( n = `content` ns = `f`
                                )->ele( `List`
                                    )->a( n = `showSeparators` v = `None`
                                    )->a( n = `headerText`     v = `Peach Valley Inc.`

                                    )->tag( `DisplayListItem`
                                        )->a( n = `label` v = `Mobile`
                                        )->a( n = `value` v = `+1 202 34869-0`
                                        )->a( n = `type`  v = `Active`
                                        )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-urlhelper
                                                                                        t_arg = temp4 )
                                    )->tag( `DisplayListItem`
                                        )->a( n = `label` v = `Phone`
                                        )->a( n = `value` v = `+1 202 555 5555`
                                        )->a( n = `type`  v = `Active`
                                        )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-urlhelper
                                                                                        t_arg = temp6 )
                                    )->tag( `DisplayListItem`
                                        )->a( n = `label` v = `Email`
                                        )->a( n = `value` v = `donna@peachvalley.com`
                                        )->a( n = `type`  v = `Active`
                                        )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-urlhelper
                                                                                        t_arg = temp8 )

                                )->end(
                            )->end(
                        )->end(

                        )->ele( `GenericTile`
                            )->a( n = `header` v = `Appointments management`

                            )->ele( `layoutData`
                                )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                    )->a( n = `rows`    v = `2`
                                    )->a( n = `columns` v = `2`

                            )->end(
                            )->ele( `TileContent`
                                )->a( n = `unit`   v = `EUR`
                                )->a( n = `footer` v = `Current Quarter`
                                )->tag( `ImageContent`
                                    )->a( n = `src` v = `sap-icon://appointment`

                            )->end(
                        )->end(

                        )->ele( `GenericTile`
                            )->a( n = `header`    v = `Sales Fulfillment Application Title`
                            )->a( n = `subheader` v = `Subtitle`

                            )->ele( `layoutData`
                                )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                    )->a( n = `rows`    v = `2`
                                    )->a( n = `columns` v = `2`

                            )->end(
                            )->ele( `TileContent`
                                )->a( n = `unit`   v = `EUR`
                                )->a( n = `footer` v = `Current Quarter`
                                )->tag( `ImageContent`
                                    )->a( n = `src` v = `sap-icon://home-share`

                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( `Panel`
                    )->a( n = `headerText` v = `Group 4`
                    )->a( n = `height`     v = `100%`

                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `baseSize` v = `50%`

                    )->end(

                    )->ele( n = `GridContainer` ns = `f`
                        )->a( n = `id`            v = `grid4`
                        )->a( n = `borderReached` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                t_arg = temp10 )

                        )->ele( `GenericTile`
                            )->a( n = `header` v = `Sales Fulfillment Application Title`

                            )->ele( `layoutData`
                                )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                    )->a( n = `minRows` v = `1`
                                    )->a( n = `columns` v = `2`

                            )->end(
                            )->tag( `TileContent`
                                )->a( n = `unit`   v = `EUR`
                                )->a( n = `footer` v = `Current Quarter`

                        )->end(

                        )->ele( `GenericTile`
                            )->a( n = `header`    v = `Travel and Expenses`
                            )->a( n = `subheader` v = `Access Concur`

                            )->ele( `layoutData`
                                )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                    )->a( n = `minRows` v = `2`
                                    )->a( n = `columns` v = `2`

                            )->end(
                            )->ele( `TileContent`
                                )->tag( `ImageContent`
                                    )->a( n = `src` v = `sap-icon://travel-expense`

                            )->end(
                        )->end(

                        " adaptiveContent/summary, rebuilt declaratively
                        )->ele( n = `Card` ns = `f`

                            )->ele( n = `layoutData` ns = `f`
                                )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                    )->a( n = `columns` v = `3`

                            )->end(
                            )->ele( n = `header` ns = `f`
                                )->tag( n = `Header` ns = `card`
                                    )->a( n = `title`    v = `Short Summary`
                                    )->a( n = `subtitle` v = `With a link to more details`
                                    )->a( n = `iconSrc`  v = `sap-icon://business-card`

                            )->end(
                            )->ele( n = `content` ns = `f`
                                )->ele( `VBox`
                                    )->a( n = `class` v = `sapUiSmallMargin`

                                    )->tag( `Text`
                                        )->a( n = `text` v = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, ` &&
                                                             `sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum.`
                                    )->tag( `Link`
                                        )->a( n = `text`   v = `Go to page`
                                        )->a( n = `href`   v = `https://www.sap.com`
                                        )->a( n = `target` v = `_blank`
                                        )->a( n = `class`  v = `sapUiSmallMarginTop`

                                )->end(
                            )->end(
                        )->end(

                        " listContent/withAction, rebuilt declaratively
                        )->ele( n = `Card` ns = `f`

                            )->ele( n = `layoutData` ns = `f`
                                )->tag( n = `GridContainerItemLayoutData` ns = `f`
                                    )->a( n = `minRows` v = `3`
                                    )->a( n = `columns` v = `3`

                            )->end(
                            )->ele( n = `header` ns = `f`
                                )->tag( n = `Header` ns = `card`
                                    )->a( n = `title`      v = `Integration Card with action`
                                    )->a( n = `subtitle`   v = `Card subtitle`
                                    )->a( n = `iconSrc`    v = `sap-icon://activities`
                                    )->a( n = `statusText` v = `100 of 200`
                                    )->a( n = `press`      v = client->follow_up_action( val   = client->cs_event-urlhelper
                                                                                         t_arg = temp11 )

                            )->end(
                            )->ele( n = `content` ns = `f`
                                )->ele( `List`
                                    )->a( n = `showSeparators` v = `None`
                                    )->a( n = `items`          v = client->_bind( t_withaction )
                                    )->tag( `StandardListItem`
                                        )->a( n = `title`       v = `{TITLE}`
                                        )->a( n = `description` v = `{DESCRIPTION}`
                                        )->a( n = `icon`        v = `{ICON}`
                                        )->a( n = `highlight`   v = `{HIGHLIGHT}`
                                        )->a( n = `info`        v = `{INFO}`
                                        )->a( n = `infoState`   v = `{INFOSTATE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " cardManifests.json listContent/orders
    DATA temp3 TYPE z2ui5_cl_smpc_app_528=>ty_t_row.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp5 TYPE z2ui5_cl_smpc_app_528=>ty_t_employee.
    DATA temp6 LIKE LINE OF temp5.
    DATA temp7 TYPE z2ui5_cl_smpc_app_528=>ty_t_row.
    DATA temp8 LIKE LINE OF temp7.
    DATA temp9 TYPE z2ui5_cl_smpc_app_528=>ty_t_row.
    DATA temp10 LIKE LINE OF temp9.
    DATA temp11 TYPE z2ui5_cl_smpc_app_528=>ty_t_row.
    DATA temp12 LIKE LINE OF temp11.
    CLEAR temp3.
    
    temp4-title = `Teico Inc.`.
    temp4-description = `Sun Valley, Idaho`.
    temp4-info = `246`.
    temp4-infostate = `Error`.
    INSERT temp4 INTO TABLE temp3.
    temp4-title = `Scrum LTD.`.
    temp4-description = `Dayville, Oregon`.
    temp4-info = `164`.
    temp4-infostate = `Warning`.
    INSERT temp4 INTO TABLE temp3.
    temp4-title = `Lean Co.`.
    temp4-description = `Raymond, California`.
    temp4-info = `73`.
    temp4-infostate = `None`.
    INSERT temp4 INTO TABLE temp3.
    t_orders = temp3.

    " tableContent/employees
    
    CLEAR temp5.
    
    temp6-firstname = `Donna`.
    temp6-lastname = `Moore`.
    temp6-birthdate = `1986-08-11`.
    INSERT temp6 INTO TABLE temp5.
    temp6-firstname = `John`.
    temp6-lastname = `Miller`.
    temp6-birthdate = `1984-05-13`.
    INSERT temp6 INTO TABLE temp5.
    temp6-firstname = `Alain`.
    temp6-lastname = `Chevalier`.
    temp6-birthdate = `1993-02-01`.
    INSERT temp6 INTO TABLE temp5.
    temp6-firstname = `Elena`.
    temp6-lastname = `Petrova`.
    temp6-birthdate = `1976-09-19`.
    INSERT temp6 INTO TABLE temp5.
    t_employees = temp5.

    " listContent/tasks
    
    CLEAR temp7.
    
    temp8-title = `Call Simone`.
    temp8-icon = `sap-icon://call`.
    temp8-infostate = `Error`.
    INSERT temp8 INTO TABLE temp7.
    temp8-title = `Write to Elena`.
    temp8-icon = `sap-icon://email`.
    temp8-infostate = `Warning`.
    INSERT temp8 INTO TABLE temp7.
    t_tasks = temp7.

    " listContent/contacts
    
    CLEAR temp9.
    
    temp10-title = `Alain Chevalier`.
    temp10-icon = `sap-icon://person-placeholder`.
    INSERT temp10 INTO TABLE temp9.
    temp10-title = `Monique Legrand`.
    temp10-icon = `sap-icon://account`.
    INSERT temp10 INTO TABLE temp9.
    temp10-title = `Elena Petrova`.
    temp10-icon = `sap-icon://business-card`.
    INSERT temp10 INTO TABLE temp9.
    temp10-title = `Monique Legrand`.
    temp10-icon = `sap-icon://account`.
    INSERT temp10 INTO TABLE temp9.
    temp10-title = `Alain Chevalier`.
    temp10-icon = `sap-icon://account`.
    INSERT temp10 INTO TABLE temp9.
    temp10-title = `Elena Petrova`.
    temp10-icon = `sap-icon://business-card`.
    INSERT temp10 INTO TABLE temp9.
    t_contacts = temp9.

    " listContent/withAction
    
    CLEAR temp11.
    
    temp12-title = `Notebook Basic 15`.
    temp12-description = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.
    temp12-icon = `sap-icon://laptop`.
    temp12-highlight = `Information`.
    temp12-info = `27.45 EUR`.
    temp12-infostate = `Success`.
    INSERT temp12 INTO TABLE temp11.
    temp12-title = `Notebook Basic 17`.
    temp12-description = `Notebook Basic 17 with 2,80 GHz quad core, 17" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.
    temp12-icon = `sap-icon://laptop`.
    temp12-highlight = `Success`.
    temp12-info = `27.45 EUR`.
    temp12-infostate = `Success`.
    INSERT temp12 INTO TABLE temp11.
    t_withaction = temp11.

  ENDMETHOD.

ENDCLASS.
