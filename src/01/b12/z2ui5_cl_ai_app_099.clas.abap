CLASS z2ui5_cl_ai_app_099 DEFINITION PUBLIC.

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
    DATA t_pages TYPE STANDARD TABLE OF ty_s_page WITH EMPTY KEY.
    DATA back_enabled TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_099 IMPLEMENTATION.

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
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `height`     v = `100%`

        )->open( `Page`
            )->a( n = `showHeader`    v = `false`
            )->a( n = `showNavButton` v = `false`
            )->a( n = `class`         v = `sapUiContentPadding`

            )->leaf( `Button`
                )->a( n = `id`      v = `buttonBack`
                )->a( n = `enabled` v = client->_bind( back_enabled )
                )->a( n = `text`    v = `Navigate Back`
                )->a( n = `press`   v = client->_event( `BACK` )
                )->a( n = `class`   v = `sapUiSmallMarginBottom`

            " the QuickViewCard fragment is inlined into the main view (no separate core:Fragment include)
            )->open( `Panel`
                )->a( n = `id`     v = `quickViewCardContainer`
                )->a( n = `width`  v = `auto`
                )->a( n = `height` v = `650px`

                )->open( `QuickViewCard`
                    )->a( n = `id`            v = `quickViewCard`
                    )->a( n = `pages`         v = client->_bind( t_pages )
                    )->a( n = `navigate`      v = client->_event( `NAVIGATE` )
                    )->a( n = `afterNavigate` v = client->_event( val = `AFTER_NAV` t_arg = VALUE #( ( `${$parameters>/isTopPage}` ) ) )

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
                )->shut(
            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `BACK`.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `quickViewCard` ) ( `navigateBack` ) ) ).

      WHEN `NAVIGATE`.
        client->message_toast_display( `A QuickViewCard link was clicked` ).

      WHEN `AFTER_NAV`.
        " enable the back button while the card is not on its top page (original afterNavigate isTopPage)
        back_enabled = xsdbool( client->get_event_arg( ) = abap_false ).
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    t_pages = VALUE #(
      ( pageid       = `companyPageId`
        header       = `Company info`
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
              ( label = `Name`            value = `John Doe`                  elementtype = `pageLink` pagelinkid = `companyEmployeePageId` )
              ( label = `Mobile`          value = `+001 6101 34869-0`         elementtype = `mobile` )
              ( label = `Phone`           value = `+001 6101 34869-0`         elementtype = `phone` )
              ( label = `Email`           value = `main.contact@company.com`  elementtype = `email` emailsubject = `Subject` )
              ( label = `Additional info` value = ``                          elementtype = `text` ) ) ) ) )
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
              ( label = `Email` value = `john.doe@sap.com` elementtype = `email` emailsubject = `Subject` )
              ( label = `Phone` value = `+359 888 888 888`  elementtype = `mobile` ) ) ) ) ) ).

  ENDMETHOD.

ENDCLASS.
