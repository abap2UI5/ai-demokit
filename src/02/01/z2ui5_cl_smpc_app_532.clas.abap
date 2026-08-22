" @keywords quickview quick sap.m quickviewnavorigin button quickviewpage avatar quickviewgroup quickviewgroupelement
" @summary QuickView using navOrigin parameter when navigating.
CLASS z2ui5_cl_smpc_app_532 DEFINITION PUBLIC.

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
    DATA t_employees TYPE ty_t_page.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_quickview_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_532 IMPLEMENTATION.

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
                )->a( n = `id`           v = `quickViewBtn`
                )->a( n = `text`         v = `Open QuickView`
                )->a( n = `width`        v = `200px`
                )->a( n = `press`        v = client->_event( `QUICK_VIEW` )
                )->a( n = `class`        v = `sapUiSmallMarginBottom`
                )->a( n = `ariaHasPopup` v = `Dialog` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `QUICK_VIEW`.
        popup_quickview_display( ).

      WHEN `NAVIGATE`.
        " onNavigate splices the EMPLOYEE record the clicked link names into
        " page 2 of the card model - the same swap, one round-trip
        DATA(origin) = client->get_event_arg( ).
        IF origin IS NOT INITIAL.
          DATA(employee) = VALUE #( t_employees[ title = origin ] OPTIONAL ).
          IF employee IS NOT INITIAL.
            t_pages[ 2 ] = employee.
          ENDIF.
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD popup_quickview_display.

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory( ).

    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `QuickView`
            )->a( n = `id`    v = `quickViewNavOrigin`
            )->a( n = `pages` v = |\{ path: '{ client->_bind( val = t_pages path = abap_true ) }', templateShareable: true \}|
            )->a( n = `navigate` v = client->_event( val   = `NAVIGATE`
                                                     t_arg = VALUE #( ( `${$parameters>/navOrigin} ? ${$parameters>/navOrigin}.getText() : ''` ) ) )

            )->ele( `QuickViewPage`
                )->a( n = `pageId`      v = `{PAGEID}`
                )->a( n = `header`      v = `{HEADER}`
                )->a( n = `title`       v = `{TITLE}`
                )->a( n = `titleUrl`    v = `{TITLEURL}`
                )->a( n = `description` v = `{DESCRIPTION}`
                )->a( n = `groups`      v = `{path: 'GROUPS', templateShareable: true}`

                )->ele( `avatar`
                    )->tag( `Avatar`
                        )->a( n = `src`          v = `{ICON}`
                        )->a( n = `displayShape` v = `{DISPLAYSHAPE}`

                )->end(
                )->ele( `QuickViewGroup`
                    )->a( n = `heading`  v = `{HEADING}`
                    )->a( n = `elements` v = `{path: 'ELEMENTS', templateShareable: true}`

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
                             by_id = `quickViewBtn` ).

  ENDMETHOD.


  METHOD model_init.

    " CardData.json: the bank page plus an EMPTY contactPage placeholder that
    " onNavigate replaces with the employee the clicked link names
    " target seeds the UI5 default '_blank' explicitly - a serialized empty
    " string would override the QuickViewGroupElement.target default
    t_pages = VALUE #(
      ( pageid       = `bankPage`
        header       = `Company Info`
        title        = `SAP SE`
        icon         = `sap-icon://building`
        displayshape = `Square`
        description  = `Founded in 1972`
        groups       = VALUE #(
          ( heading  = `Office`
            elements = VALUE #(
              ( label = `Headquarters` value = `Walldorf, Germany` elementtype = `text`  target = `_blank` )
              ( label = `Phone`        value = `+001 6101 34869-0` elementtype = `phone` target = `_blank` ) ) )
          ( heading  = `Contacts`
            elements = VALUE #(
              ( label = `Name` value = `Johnny Cash`    elementtype = `pageLink` pagelinkid = `contactPage` target = `_blank` )
              ( label = `Name` value = `James Bonus`    elementtype = `pageLink` pagelinkid = `contactPage` target = `_blank` )
              ( label = `Name` value = `Maria Leasing`  elementtype = `pageLink` pagelinkid = `contactPage` target = `_blank` )
              ( label = `Name` value = `Claudia Credit` elementtype = `pageLink` pagelinkid = `contactPage` target = `_blank` ) ) ) ) )
      " the sample's placeholder page carries no displayShape; an empty string
      " would override the enum DEFAULT and reject the whole view
      ( pageid = `contactPage` displayshape = `Circle` ) ).

    " EmployeeData.json, keyed by the employee name the link carries
    t_employees = VALUE #(
      ( pageid       = `contactPage`
        header       = `Employee Info`
        title        = `Johnny Cash`
        icon         = `sap-icon://person-placeholder`
        displayshape = `Circle`
        description  = `Department Manager`
        groups       = VALUE #(
          ( heading  = `Contact Info`
            elements = VALUE #(
              ( label = `Address` value = `550 Larkin Street, 4F, Mountain View, CA, 94102 San Francisco USA` elementtype = `text` target = `_blank` )
              ( label = `Email`   value = `johnny.cash@sapbank.com` emailsubject = `Give me cash` elementtype = `email` target = `_blank` )
              ( label = `Phone`   value = `+359 888 888 888` elementtype = `phone` target = `_blank` ) ) )
          ( heading  = `Additional Info`
            elements = VALUE #(
              ( label = `Major` value = `Cash operations` elementtype = `text` target = `_blank` ) ) ) ) )

      ( pageid       = `contactPage`
        header       = `Employee Info`
        title        = `James Bonus`
        icon         = `sap-icon://person-placeholder`
        displayshape = `Circle`
        description  = `Department Manager`
        groups       = VALUE #(
          ( heading  = `Contact Info`
            elements = VALUE #(
              ( label = `Address` value = `550 Larkin Street, 4F, Mountain View, CA, 94102 San Francisco USA` elementtype = `text` target = `_blank` )
              ( label = `Email`   value = `james.bonus@sapbank.com` emailsubject = `Bonus interest` elementtype = `email` target = `_blank` )
              ( label = `Phone`   value = `+359 777 777 777` elementtype = `phone` target = `_blank` ) ) )
          ( heading  = `Additional Info`
            elements = VALUE #(
              ( label = `Major` value = `Bonuses for loyal customers` elementtype = `text` target = `_blank` ) ) ) ) )

      ( pageid       = `contactPage`
        header       = `Employee Info`
        title        = `Maria Leasing`
        icon         = `sap-icon://person-placeholder`
        displayshape = `Circle`
        description  = `Department Manager`
        groups       = VALUE #(
          ( heading  = `Contact Info`
            elements = VALUE #(
              ( label = `Address` value = `550 Larkin Street, 4F, Mountain View, CA, 94102 San Francisco USA` elementtype = `text` target = `_blank` )
              ( label = `Email`   value = `maria.leasing@sapbank.com` emailsubject = `Leasing` elementtype = `email` target = `_blank` )
              ( label = `Phone`   value = `+359 555 555 555` elementtype = `phone` target = `_blank` ) ) )
          ( heading  = `Additional Info`
            elements = VALUE #(
              ( label = `Major` value = `Financial leasing` elementtype = `text` target = `_blank` ) ) ) ) )

      ( pageid       = `contactPage`
        header       = `Employee Info`
        title        = `Claudia Credit`
        icon         = `sap-icon://person-placeholder`
        displayshape = `Circle`
        description  = `Department Manager`
        groups       = VALUE #(
          ( heading  = `Contact Info`
            elements = VALUE #(
              ( label = `Address` value = `550 Larkin Street, 4F, Mountain View, CA, 94102 San Francisco USA` elementtype = `text` target = `_blank` )
              ( label = `Email`   value = `claudia.credit@sapbank.com` emailsubject = `Credit` elementtype = `email` target = `_blank` )
              ( label = `Phone`   value = `+359 666 666 666` elementtype = `phone` target = `_blank` ) ) )
          ( heading  = `Additional Info`
            elements = VALUE #(
              ( label = `Major` value = `Real estate & investment credits` elementtype = `text` target = `_blank` ) ) ) ) ) ).

  ENDMETHOD.

ENDCLASS.
