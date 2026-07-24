CLASS z2ui5_cl_ai_app_100 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_element,
             label        TYPE string,
             value        TYPE string,
             url          TYPE string,
             elementtype  TYPE string,
             pagelinkid   TYPE string,
             emailsubject TYPE string,
             target       TYPE string,
           END OF ty_s_element.
    TYPES ty_t_element TYPE STANDARD TABLE OF ty_s_element WITH EMPTY KEY.
    TYPES: BEGIN OF ty_s_group,
             heading  TYPE string,
             elements TYPE ty_t_element,
           END OF ty_s_group.
    TYPES ty_t_group TYPE STANDARD TABLE OF ty_s_group WITH EMPTY KEY.
    TYPES: BEGIN OF ty_s_page,
             pageid       TYPE string,
             header       TYPE string,
             title        TYPE string,
             titleurl     TYPE string,
             icon         TYPE string,
             displayshape TYPE string,
             description  TYPE string,
             groups       TYPE ty_t_group,
           END OF ty_s_page.
    TYPES ty_t_page TYPE STANDARD TABLE OF ty_s_page WITH EMPTY KEY.
    DATA t_pages TYPE ty_t_page.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    DATA t_company TYPE ty_t_page.
    DATA t_employee TYPE ty_t_page.
    DATA t_generic TYPE ty_t_page.
    DATA t_generic_noheader TYPE ty_t_page.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_quickview_display IMPORTING by_id TYPE string.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_100 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->leaf( `Button`
                )->a( n = `id`           v = `employeeQuickView`
                )->a( n = `text`         v = `Employee QuickView`
                )->a( n = `width`        v = `200px`
                )->a( n = `press`        v = client->_event( `EMPLOYEE` )
                )->a( n = `class`        v = `sapUiSmallMarginBottom`
                )->a( n = `ariaHasPopup` v = `Dialog`
            )->leaf( `Button`
                )->a( n = `id`           v = `showQuickView`
                )->a( n = `text`         v = `Company QuickView`
                )->a( n = `width`        v = `200px`
                )->a( n = `press`        v = client->_event( `COMPANY` )
                )->a( n = `class`        v = `sapUiSmallMarginBottom`
                )->a( n = `ariaHasPopup` v = `Dialog`
            )->leaf( `Button`
                )->a( n = `id`           v = `genericQuickView`
                )->a( n = `text`         v = `Generic QuickView`
                )->a( n = `width`        v = `200px`
                )->a( n = `press`        v = client->_event( `GENERIC` )
                )->a( n = `class`        v = `sapUiSmallMarginBottom`
                )->a( n = `ariaHasPopup` v = `Dialog`
            )->leaf( `Button`
                )->a( n = `id`           v = `genericQuickViewNoHeader`
                )->a( n = `text`         v = `Generic QuickView No Header Set`
                )->a( n = `width`        v = `250px`
                )->a( n = `press`        v = client->_event( `GENERIC_NOHEADER` )
                )->a( n = `class`        v = `sapUiSmallMarginBottom`
                )->a( n = `ariaHasPopup` v = `Dialog` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `EMPLOYEE`.
        t_pages = t_employee.
        popup_quickview_display( `employeeQuickView` ).

      WHEN `COMPANY`.
        t_pages = t_company.
        popup_quickview_display( `showQuickView` ).

      WHEN `GENERIC`.
        t_pages = t_generic.
        popup_quickview_display( `genericQuickView` ).

      WHEN `GENERIC_NOHEADER`.
        t_pages = t_generic_noheader.
        popup_quickview_display( `genericQuickViewNoHeader` ).

      WHEN `NAVIGATE`.
        client->message_toast_display( `A QuickView link was clicked` ).

    ENDCASE.

  ENDMETHOD.


  METHOD popup_quickview_display.

    DATA(popup) = z2ui5_cl_ai_xml=>factory( ).

    popup->open( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->open( `QuickView`
            )->a( n = `id`       v = `quickView`
            )->a( n = `pages`    v = client->_bind( t_pages )
            )->a( n = `navigate` v = client->_event( `NAVIGATE` )

            )->open( `QuickViewPage`
                )->a( n = `pageId`      v = `{PAGEID}`
                )->a( n = `header`      v = `{HEADER}`
                )->a( n = `title`       v = `{TITLE}`
                )->a( n = `titleUrl`    v = `{TITLEURL}`
                )->a( n = `description` v = `{DESCRIPTION}`
                )->a( n = `groups`      v = `{path: 'GROUPS', templateShareable: true}`

                )->open( `avatar`
                    )->leaf( `Avatar`
                        )->a( n = `src`          v = `{ICON}`
                        )->a( n = `displayShape` v = `{DISPLAYSHAPE}`

                )->shut(
                )->open( `QuickViewGroup`
                    )->a( n = `heading`  v = `{HEADING}`
                    )->a( n = `elements` v = `{path: 'ELEMENTS', templateShareable: true}`

                    )->leaf( `QuickViewGroupElement`
                        )->a( n = `label`        v = `{LABEL}`
                        )->a( n = `value`        v = `{VALUE}`
                        )->a( n = `url`          v = `{URL}`
                        )->a( n = `type`         v = `{ELEMENTTYPE}`
                        )->a( n = `pageLinkId`   v = `{PAGELINKID}`
                        )->a( n = `emailSubject` v = `{EMAILSUBJECT}`
                        )->a( n = `target`       v = `{TARGET}`

                )->shut(
            )->shut(
        )->shut( ).

    client->popover_display( xml   = popup->stringify( )
                             by_id = by_id ).

  ENDMETHOD.


  METHOD model_init.

    t_company = VALUE #(
      ( pageid       = `companyPageId`
        header       = `Company Info`
        title        = `Adventure Company`
        titleurl     = `http://sap.com`
        icon         = `sap-icon://building`
        displayshape = `Square`
        description  = `John Doe`
        groups       = VALUE #(
          ( heading  = `Contact Details`
            elements = VALUE #(
              ( label = `Phone`   value = `+001 6101 34869-0` elementtype = `phone` )
              ( label = `Address` value = `550 Larkin Street, 4F, Mountain View, CA, 94102 San Francisco USA` elementtype = `text` ) ) )
          ( heading  = `Main Contact`
            elements = VALUE #(
              ( label = `Name`   value = `John Doe`                 elementtype = `pageLink` pagelinkid = `companyEmployeePageId` )
              ( label = `Mobile` value = `+001 6101 34869-0`        elementtype = `mobile` )
              ( label = `Phone`  value = `+001 6101 34869-0`        elementtype = `phone` )
              ( label = `Email`  value = `main.contact@company.com` elementtype = `email` emailsubject = `Subject` ) ) ) ) )
      ( pageid       = `companyEmployeePageId`
        header       = `Employee Info`
        title        = `John Doe`
        icon         = `sap-icon://person-placeholder`
        displayshape = `Circle`
        description  = `Department Manager`
        groups       = VALUE #(
          ( heading  = `Company`
            elements = VALUE #(
              ( label = `Name`    value = `Adventure Company`             url = `http://sap.com` elementtype = `link` )
              ( label = `Address` value = `Sofia, Boris III, 136A`        elementtype = `text` )
              ( label = `Slogan`  value = `Innovation through technology` elementtype = `text` ) ) )
          ( heading  = `Other`
            elements = VALUE #(
              ( label = `Email` value = `john.doe@sap.com`  elementtype = `email` emailsubject = `Subject` )
              ( label = `Phone` value = `+359 888 888 888`  elementtype = `phone` ) ) ) ) ) ).

    t_employee = VALUE #(
      ( pageid       = `employeePageId`
        header       = `Employee Info`
        title        = `Michael Muller`
        icon         = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/johnDoe.png`
        displayshape = `Circle`
        description  = `Account Manager`
        groups       = VALUE #(
          ( heading  = `Contact Details`
            elements = VALUE #(
              ( label = `Mobile` value = `+001 6101 34869-0`        elementtype = `mobile` )
              ( label = `Phone`  value = `+001 6101 34869-1`        elementtype = `phone` )
              ( label = `Email`  value = `main.contact@company.com` elementtype = `email` emailsubject = `Subject` ) ) )
          ( heading  = `Company`
            elements = VALUE #(
              ( label = `Name`    value = `Adventure Company`               url = `http://sap.com` elementtype = `link` )
              ( label = `Address` value = `Main Street 4572, Los Angeles USA` elementtype = `text` ) ) ) ) ) ).

    t_generic = VALUE #(
      ( pageid       = `genericPageId`
        header       = `Process`
        title        = `Inventarisation`
        titleurl     = `http://de.wikipedia.org/wiki/Inventarisation`
        icon         = `sap-icon://camera`
        displayshape = `Circle`
        groups       = VALUE #(
          ( elements = VALUE #(
              ( label = `Start Date` value = `01/01/2015` elementtype = `text` )
              ( label = `End Date`   value = `31/12/2015` elementtype = `text` )
              ( label = `Occurrence` value = `Weekly`     elementtype = `text` ) ) ) ) ) ).

    t_generic_noheader = VALUE #(
      ( pageid       = `genericPageId`
        title        = `Inventarisation`
        titleurl     = `http://de.wikipedia.org/wiki/Inventarisation`
        icon         = `sap-icon://camera`
        displayshape = `Circle`
        groups       = VALUE #(
          ( elements = VALUE #(
              ( label = `Start Date` value = `01/01/2015` elementtype = `text` )
              ( label = `End Date`   value = `31/12/2015` elementtype = `text` )
              ( label = `Occurrence` value = `Weekly`     elementtype = `text` ) ) ) ) ) ).

  ENDMETHOD.

ENDCLASS.
