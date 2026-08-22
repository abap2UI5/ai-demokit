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
    TYPES ty_t_row TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.

    TYPES: BEGIN OF ty_s_employee,
             firstname TYPE string,
             lastname  TYPE string,
             birthdate TYPE string,
           END OF ty_s_employee.
    TYPES ty_t_employee TYPE STANDARD TABLE OF ty_s_employee WITH EMPTY KEY.

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
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " onBorderReached toasts '<panel header> border reached' and moves the focus
    " into the neighbouring grid; the toast is composed on the client here (the
    " focus hand-off has no counterpart - see sidecar)
    DATA(border) = `MESSAGE_TOAST`.

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
                                                                                 t_arg = VALUE #( ( border ) ( `show` ) ( `Group 1 border reached` ) ) )

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
                                                                                t_arg = VALUE #( ( border ) ( `show` ) ( `Group 2 border reached` ) ) )

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
                                                                                t_arg = VALUE #( ( border ) ( `show` ) ( `Group 3 border reached` ) ) )

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
                                                                                        t_arg = VALUE #( ( `TRIGGER_TEL` ) ( `+1 202 34869-0` ) ) )
                                    )->tag( `DisplayListItem`
                                        )->a( n = `label` v = `Phone`
                                        )->a( n = `value` v = `+1 202 555 5555`
                                        )->a( n = `type`  v = `Active`
                                        )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-urlhelper
                                                                                        t_arg = VALUE #( ( `TRIGGER_TEL` ) ( `+1 202 555 5555` ) ) )
                                    )->tag( `DisplayListItem`
                                        )->a( n = `label` v = `Email`
                                        )->a( n = `value` v = `donna@peachvalley.com`
                                        )->a( n = `type`  v = `Active`
                                        )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-urlhelper
                                                                                        t_arg = VALUE #( ( `TRIGGER_EMAIL` ) ( `donna@peachvalley.com` ) ) )

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
                                                                                t_arg = VALUE #( ( border ) ( `show` ) ( `Group 4 border reached` ) ) )

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
                                                                                         t_arg = VALUE #( ( `REDIRECT` ) ( |\{ URL: 'https://www.sap.com', NEW_WINDOW: true \}| ) ) )

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
    t_orders = VALUE #(
      ( title = `Teico Inc.`  description = `Sun Valley, Idaho`    info = `246` infostate = `Error` )
      ( title = `Scrum LTD.`  description = `Dayville, Oregon`     info = `164` infostate = `Warning` )
      ( title = `Lean Co.`    description = `Raymond, California`  info = `73`  infostate = `None` ) ).

    " tableContent/employees
    t_employees = VALUE #(
      ( firstname = `Donna` lastname = `Moore`     birthdate = `1986-08-11` )
      ( firstname = `John`  lastname = `Miller`    birthdate = `1984-05-13` )
      ( firstname = `Alain` lastname = `Chevalier` birthdate = `1993-02-01` )
      ( firstname = `Elena` lastname = `Petrova`   birthdate = `1976-09-19` ) ).

    " listContent/tasks
    t_tasks = VALUE #(
      ( title = `Call Simone`    icon = `sap-icon://call`  infostate = `Error` )
      ( title = `Write to Elena` icon = `sap-icon://email` infostate = `Warning` ) ).

    " listContent/contacts
    t_contacts = VALUE #(
      ( title = `Alain Chevalier` icon = `sap-icon://person-placeholder` )
      ( title = `Monique Legrand` icon = `sap-icon://account` )
      ( title = `Elena Petrova`   icon = `sap-icon://business-card` )
      ( title = `Monique Legrand` icon = `sap-icon://account` )
      ( title = `Alain Chevalier` icon = `sap-icon://account` )
      ( title = `Elena Petrova`   icon = `sap-icon://business-card` ) ).

    " listContent/withAction
    t_withaction = VALUE #(
      ( title = `Notebook Basic 15`
        description = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`
        icon = `sap-icon://laptop` highlight = `Information` info = `27.45 EUR` infostate = `Success` )
      ( title = `Notebook Basic 17`
        description = `Notebook Basic 17 with 2,80 GHz quad core, 17" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`
        icon = `sap-icon://laptop` highlight = `Success` info = `27.45 EUR` infostate = `Success` ) ).

  ENDMETHOD.

ENDCLASS.
