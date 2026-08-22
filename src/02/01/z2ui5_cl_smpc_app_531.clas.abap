CLASS z2ui5_cl_smpc_app_531 DEFINITION PUBLIC.

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
             pageid          TYPE string,
             header          TYPE string,
             title           TYPE string,
             titleurl        TYPE string,
             description     TYPE string,
             icon            TYPE string,
             displayshape    TYPE string,
             fallbackicon    TYPE string,
             initials        TYPE string,
             backgroundcolor TYPE string,
             badgeicon       TYPE string,
             groups          TYPE ty_t_group,
           END OF ty_s_page.
    TYPES ty_t_page TYPE STANDARD TABLE OF ty_s_page WITH EMPTY KEY.

    DATA t_pages TYPE ty_t_page.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_quickview_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_531 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `height`    v = `100%`

        )->ele( `Page`
            )->a( n = `showHeader`    v = `false`
            )->a( n = `showNavButton` v = `false`
            )->a( n = `class`         v = `sapUiContentPadding`

            )->tag( `Button`
                )->a( n = `id`           v = `showQuickView`
                )->a( n = `text`         v = `Employee QuickView`
                )->a( n = `width`        v = `200px`
                )->a( n = `press`        v = client->_event( `QUICK_VIEW` )
                )->a( n = `class`        v = `sapUiSmallMarginBottom`
                )->a( n = `ariaHasPopup` v = `Dialog` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `QUICK_VIEW`.
      popup_quickview_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD popup_quickview_display.

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory( ).

    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `QuickView`
            )->a( n = `id`    v = `quickView`
            )->a( n = `pages` v = |\{ path: '{ client->_bind( val = t_pages path = abap_true ) }', templateShareable: false \}|

            )->ele( `QuickViewPage`
                )->a( n = `pageId`      v = `{PAGEID}`
                )->a( n = `header`      v = `{HEADER}`
                )->a( n = `title`       v = `{TITLE}`
                )->a( n = `titleUrl`    v = `{TITLEURL}`
                )->a( n = `groups`      v = `{path: 'GROUPS', templateShareable: false}`
                )->a( n = `description` v = `{DESCRIPTION}`

                )->ele( `avatar`
                    )->tag( `Avatar`
                        )->a( n = `src`             v = `{ICON}`
                        )->a( n = `displayShape`    v = `{DISPLAYSHAPE}`
                        )->a( n = `fallbackIcon`    v = `{FALLBACKICON}`
                        )->a( n = `initials`        v = `{INITIALS}`
                        )->a( n = `backgroundColor` v = `{BACKGROUNDCOLOR}`
                        " formatBadgeIcon returns the edit icon only for the employee
                        " page - resolved per row in model_init (see sidecar)
                        )->a( n = `badgeIcon`       v = `{BADGEICON}`
                        )->a( n = `press`           v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                  t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Avatar was pressed` ) ) )

                )->end(
                )->ele( `QuickViewGroup`
                    )->a( n = `heading`  v = `{HEADING}`
                    )->a( n = `elements` v = `{path: 'ELEMENTS', templateShareable: false}`

                    )->tag( `QuickViewGroupElement`
                        )->a( n = `label`        v = `{LABEL}`
                        )->a( n = `value`        v = `{VALUE}`
                        )->a( n = `url`          v = `{URL}`
                        )->a( n = `type`         v = `{ELEMENTTYPE}`
                        )->a( n = `pageLinkId`   v = `{PAGELINKID}`
                        )->a( n = `emailSubject` v = `{EMAILSUBJECT}`
                        )->a( n = `target`       v = `{TARGET}`

                )->end(
            )->end(
        )->end( ).

    client->popover_display( xml   = popup->stringify( )
                             by_id = `showQuickView` ).

  ENDMETHOD.


  METHOD model_init.

    " target seeds the UI5 default '_blank' explicitly - a serialized empty
    " string would override the QuickViewGroupElement.target default
    t_pages = VALUE #(
      ( pageid       = `companyPageId`
        header       = `Company Info`
        title        = `SAP SE`
        titleurl     = `http://sap.com`
        description  = `Founded in 1972`
        icon         = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/QuickViewAvatarConfiguration/sap-logo.png`
        fallbackicon = `sap-icon://building`
        displayshape = `Square`
        groups       = VALUE #(
          ( heading  = `Office`
            elements = VALUE #(
              ( label = `Headquarters` value = `Walldorf, Germany`  elementtype = `text`  target = `_blank` )
              ( label = `Phone`        value = `+001 6101 34869-0`  elementtype = `phone` target = `_blank` ) ) )
          ( heading  = `Main Contact`
            elements = VALUE #(
              ( label = `Name`   value = `John Doe`           elementtype = `pageLink` pagelinkid = `companyEmployeePageId` target = `_blank` )
              ( label = `Mobile` value = `+001 6101 34869-0`  elementtype = `mobile`   target = `_blank` )
              ( label = `Phone`  value = `+001 6101 34869-0`  elementtype = `phone`    target = `_blank` )
              ( label = `Email`  value = `main.contact@company.com` emailsubject = `Subject` elementtype = `email` target = `_blank` ) ) ) ) )

      ( pageid          = `companyEmployeePageId`
        header          = `Employee Info`
        title           = `John Doe`
        initials        = `JD`
        displayshape    = `Circle`
        backgroundcolor = `Accent8`
        description     = `Department Manager`
        badgeicon       = `sap-icon://edit`
        groups          = VALUE #(
          ( heading  = `Company`
            elements = VALUE #(
              ( label = `Name`    value = `Adventure Company` url = `http://sap.com` elementtype = `link` target = `_blank` )
              ( label = `Address` value = `Sofia, Boris III, 136A` target = `_blank` )
              ( label = `Slogan`  value = `Innovation through technology` target = `_blank` ) ) )
          ( heading  = `Other`
            elements = VALUE #(
              ( label = `Email` value = `john.doe@sap.com` emailsubject = `Subject` elementtype = `email` target = `_blank` )
              ( label = `Phone` value = `+359 888 888 888` elementtype = `phone` target = `_blank` ) ) ) ) ) ).

  ENDMETHOD.

ENDCLASS.
