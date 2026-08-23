" @keywords quickviewcard quick card sap.m quickviewcardscrollbar button grid label griddata switch panel quickviewpage
" @summary QuickViewCard embedded in container with scroll bar
CLASS z2ui5_cl_smpc_app_421 DEFINITION PUBLIC.

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
             pageid         TYPE string,
             header         TYPE string,
             title          TYPE string,
             titleurl       TYPE string,
             icon           TYPE string,
             iconvisibility TYPE abap_bool,
             displayshape   TYPE string,
             description    TYPE string,
             groups         TYPE ty_t_group,
           END OF ty_s_page.
    DATA t_pages TYPE STANDARD TABLE OF ty_s_page WITH EMPTY KEY.
    DATA back_enabled TYPE abap_bool.
    DATA show_scroll  TYPE abap_bool VALUE abap_true.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_421 IMPLEMENTATION.

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
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `height`     v = `100%`

        )->ele( `Page`
            )->a( n = `id`            v = `quickViewCardExamplePage`
            )->a( n = `showHeader`    v = `false`
            )->a( n = `class`         v = `sapUiContentPadding`
            )->a( n = `showNavButton` v = `false`

            )->tag( `Button`
                )->a( n = `id`      v = `buttonBack`
                )->a( n = `enabled` v = client->_bind( back_enabled )
                )->a( n = `text`    v = `Navigate Back`
                " onButtonBackClick drives the card 1:1 via navigateBack, roundtrip-free;
                " afterNavigate below keeps the enabled flag in sync
                )->a( n = `press`   v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                  t_arg = VALUE #( ( `quickViewCard` ) ( `navigateBack` ) ) )
                )->a( n = `class`   v = `sapUiSmallMarginBottom`

            )->ele( n = `Grid` ns = `l`
                )->a( n = `class`       v = `sapUiNoMarginBegin`
                )->a( n = `hSpacing`    v = `0`
                )->a( n = `vSpacing`    v = `0`
                )->a( n = `defaultSpan` v = `L6 M6 S10`

                )->ele( `Label`
                    )->a( n = `text`  v = `Show Vertical Scroll Bar`
                    )->a( n = `class` v = `sapUiSmallMarginTop`
                    )->ele( `layoutData`
                        )->tag( n = `GridData` ns = `l`
                            )->a( n = `span` v = `L3 M6 S8`

                    )->end(
                )->end(

                " onScrollSwitchChange: showVerticalScrollBar follows the two-way bound
                " state; the change event only resets the back button (the card
                " re-renders to its first page)
                )->ele( `Switch`
                    )->a( n = `id`     v = `showHideScrollSwitch`
                    )->a( n = `state`  v = client->_bind( show_scroll )
                    )->a( n = `class`  v = `sapUiSmallMarginBottom`
                    )->a( n = `change` v = client->_event( `SCROLL_TOGGLE` )
                    )->ele( `layoutData`
                        )->tag( n = `GridData` ns = `l`
                            )->a( n = `span` v = `L9 M6 S4`

                    )->end(
                )->end(

                )->ele( `Label`
                    )->a( n = `text`  v = `Show Header`
                    )->a( n = `class` v = `sapUiSmallMarginTop`
                    )->ele( `layoutData`
                        )->tag( n = `GridData` ns = `l`
                            )->a( n = `span` v = `L3 M6 S8`

                    )->end(
                )->end(

                " onHeaderSwitchChange mutates page 1 in the model server-side
                )->ele( `Switch`
                    )->a( n = `id`     v = `showHideHeaderSwitch`
                    )->a( n = `state`  v = `true`
                    )->a( n = `class`  v = `sapUiSmallMarginBottom`
                    )->a( n = `change` v = client->_event( val   = `HEADER_TOGGLE`
                                                           t_arg = VALUE #( ( `${$parameters>/state}` ) ) )
                    )->ele( `layoutData`
                        )->tag( n = `GridData` ns = `l`
                            )->a( n = `span` v = `L9 M6 S4`

                    )->end(
                )->end(
            )->end(

            " the QuickViewCard fragment is inlined into the main view (no separate core:Fragment include)
            )->ele( `Panel`
                )->a( n = `id`     v = `quickViewCardContainer`
                )->a( n = `width`  v = `auto`
                )->a( n = `height` v = `264px`

                )->ele( `QuickViewCard`
                    )->a( n = `id`                    v = `quickViewCard`
                    )->a( n = `pages`                 v = |\{ path: '{ client->_bind( val = t_pages path = abap_true ) }', templateShareable: true \}|
                    )->a( n = `showVerticalScrollBar` v = client->_bind( show_scroll )
                    " isTopPage travels as the string tokens top/sub: the transpiled
                    " runtime hands a JSON boolean arg through as 'false' where a real
                    " system normalizes it to abap_bool, so a token is the one form
                    " both runtimes read the same
                    )->a( n = `afterNavigate`         v = client->_event( val   = `AFTER_NAV`
                                                                          t_arg = VALUE #( ( `${$parameters>/isTopPage} ? 'top' : 'sub'` ) ) )

                    )->ele( `QuickViewPage`
                        )->a( n = `pageId`      v = `{PAGEID}`
                        )->a( n = `header`      v = `{HEADER}`
                        )->a( n = `title`       v = `{TITLE}`
                        )->a( n = `titleUrl`    v = `{TITLEURL}`
                        )->a( n = `description` v = `{DESCRIPTION}`
                        )->a( n = `groups`      v = `{ path : 'GROUPS', templateShareable : true }`

                        )->ele( `avatar`
                            )->tag( `Avatar`
                                )->a( n = `src`          v = `{ICON}`
                                )->a( n = `displayShape` v = `{DISPLAYSHAPE}`
                                )->a( n = `visible`      v = `{ICONVISIBILITY}`

                        )->end(

                        )->ele( `QuickViewGroup`
                            )->a( n = `heading`  v = `{HEADING}`
                            )->a( n = `elements` v = `{ path : 'ELEMENTS', templateShareable : true }`

                            )->tag( `QuickViewGroupElement`
                                )->a( n = `label`        v = `{LABEL}`
                                )->a( n = `value`        v = `{VALUE}`
                                )->a( n = `url`          v = `{URL}`
                                )->a( n = `type`         v = `{ELEMENTTYPE}`
                                )->a( n = `pageLinkId`   v = `{PAGELINKID}`
                                )->a( n = `emailSubject` v = `{EMAILSUBJECT}`
                                )->a( n = `target`       v = `{TARGET}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `SCROLL_TOGGLE`.
        " the card re-renders on its first page - no need of the Back button
        back_enabled = abap_false.

      WHEN `HEADER_TOGGLE`.
        " onHeaderSwitchChange: show/clear the first page's header data
        DATA(header_on) = CONV abap_bool( client->get_event_arg( ) ).
        ASSIGN t_pages[ 1 ] TO FIELD-SYMBOL(<s_page>).
        IF sy-subrc = 0.
          IF header_on = abap_true.
            <s_page>-iconvisibility = abap_true.
            <s_page>-title          = `Adventure Company`.
            <s_page>-description    = `John Doe`.
          ELSE.
            <s_page>-iconvisibility = abap_false.
            <s_page>-title          = ``.
            <s_page>-description    = ``.
          ENDIF.
        ENDIF.
        back_enabled = abap_false.

      WHEN `AFTER_NAV`.
        " enable the back button while the card is not on its top page (original afterNavigate isTopPage)
        back_enabled = xsdbool( client->get_event_arg( ) = `sub` ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " /pages of model/data.json - target seeds the UI5 default '_blank' explicitly
    " (a serialized empty string would override the QuickViewGroupElement.target
    " default), elements without an elementType get the enum default 'text', and
    " page 2 seeds iconVisibility=true (Avatar.visible defaults to true where the
    " mock omits the flag)
    t_pages = VALUE #(
        ( pageid         = `companyPageId`
          header         = `Company info`
          title          = `Adventure Company`
          titleurl       = `http://sap.com`
          icon           = `sap-icon://building`
          iconvisibility = abap_true
          displayshape   = `Square`
          description    = `John Doe`
          groups         = VALUE #(
              ( heading  = `Contact Details`
                elements = VALUE #(
                    ( label = `Phone`   value = `+001 6101 34869-0` elementtype = `phone` target = `_blank` )
                    ( label = `Address` value = `550 Larkin Street, 4F, Mountain View, CA, 94102 San Francisco USA` elementtype = `text` target = `_blank` ) ) )
              ( heading  = `Main Contact`
                elements = VALUE #(
                    ( label = `Name`   value = `John Doe`               elementtype = `pageLink` pagelinkid = `companyEmployeePageId` target = `_blank` )
                    ( label = `Mobile` value = `+001 6101 34869-0`      elementtype = `mobile`   target = `_blank` )
                    ( label = `Phone`  value = `+001 6101 34869-0`      elementtype = `phone`    target = `_blank` )
                    ( label = `Email`  value = `main.contact@company.com` elementtype = `email`  emailsubject = `Subject` target = `_blank` ) ) ) ) )
        ( pageid         = `companyEmployeePageId`
          header         = `Employee Info`
          title          = `John Doe`
          icon           = `sap-icon://person-placeholder`
          iconvisibility = abap_true
          displayshape   = `Circle`
          description    = `Department Manager`
          groups         = VALUE #(
              ( heading  = `Company`
                elements = VALUE #(
                    ( label = `Name`    value = `Adventure Company`              elementtype = `link` url = `http://sap.com` target = `_blank` )
                    ( label = `Address` value = `Sofia, Boris III, 136A`         elementtype = `text` target = `_blank` )
                    ( label = `Slogan`  value = `Innovation through technology`  elementtype = `text` target = `_blank` ) ) )
              ( heading  = `Other`
                elements = VALUE #(
                    ( label = `Email` value = `john.doe@sap.com`  elementtype = `email`  emailsubject = `Subject` target = `_blank` )
                    ( label = `Phone` value = `+359 888 888 888`  elementtype = `mobile` target = `_blank` ) ) ) ) ) ).

  ENDMETHOD.

ENDCLASS.
