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
    TYPES ty_t_element TYPE STANDARD TABLE OF ty_s_element WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_s_group,
             heading  TYPE string,
             elements TYPE ty_t_element,
           END OF ty_s_group.
    TYPES ty_t_group TYPE STANDARD TABLE OF ty_s_group WITH DEFAULT KEY.
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
    TYPES temp1_e88d5807c6 TYPE STANDARD TABLE OF ty_s_page WITH DEFAULT KEY.
DATA t_pages TYPE temp1_e88d5807c6.
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
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `quickViewCard` INTO TABLE temp1.
    INSERT `navigateBack` INTO TABLE temp1.
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
                                                                  t_arg = temp1 )
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
                    )->a( n = `change` v = client->_event( val = `HEADER_TOGGLE` arg = `${$parameters>/state}` )
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
                    )->a( n = `pages`                 v = |\{ path: '{ client->_bind_path( t_pages ) }', templateShareable: true \}|
                    )->a( n = `showVerticalScrollBar` v = client->_bind( show_scroll )
                    " isTopPage travels as the string tokens top/sub: the transpiled
                    " runtime hands a JSON boolean arg through as 'false' where a real
                    " system normalizes it to abap_bool, so a token is the one form
                    " both runtimes read the same
                    )->a( n = `afterNavigate`         v = client->_event( val = `AFTER_NAV` arg = `${$parameters>/isTopPage} ? 'top' : 'sub'` )

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
        DATA temp3 TYPE abap_bool.
        DATA header_on LIKE temp3.
        FIELD-SYMBOLS <s_page> TYPE z2ui5_cl_smpc_app_421=>ty_s_page.
        DATA temp1 TYPE xsdboolean.

    CASE client->get_event( ).

      WHEN `SCROLL_TOGGLE`.
        " the card re-renders on its first page - no need of the Back button
        back_enabled = abap_false.

      WHEN `HEADER_TOGGLE`.
        " onHeaderSwitchChange: show/clear the first page's header data
        
        temp3 = client->get_event_arg( ).
        
        header_on = temp3.
        
        READ TABLE t_pages INDEX 1 ASSIGNING <s_page>.
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
        
        temp1 = boolc( client->get_event_arg( ) = `sub` ).
        back_enabled = temp1.

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " /pages of model/data.json - target seeds the UI5 default '_blank' explicitly
    " (a serialized empty string would override the QuickViewGroupElement.target
    " default), elements without an elementType get the enum default 'text', and
    " page 2 seeds iconVisibility=true (Avatar.visible defaults to true where the
    " mock omits the flag)
    DATA temp4 LIKE t_pages.
    DATA temp5 LIKE LINE OF temp4.
    DATA temp1 TYPE z2ui5_cl_smpc_app_421=>ty_t_group.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp7 TYPE z2ui5_cl_smpc_app_421=>ty_t_element.
    DATA temp8 LIKE LINE OF temp7.
    DATA temp9 TYPE z2ui5_cl_smpc_app_421=>ty_t_element.
    DATA temp10 LIKE LINE OF temp9.
    DATA temp3 TYPE z2ui5_cl_smpc_app_421=>ty_t_group.
    DATA temp6 LIKE LINE OF temp3.
    DATA temp11 TYPE z2ui5_cl_smpc_app_421=>ty_t_element.
    DATA temp12 LIKE LINE OF temp11.
    DATA temp13 TYPE z2ui5_cl_smpc_app_421=>ty_t_element.
    DATA temp14 LIKE LINE OF temp13.
    CLEAR temp4.
    
    temp5-pageid = `companyPageId`.
    temp5-header = `Company info`.
    temp5-title = `Adventure Company`.
    temp5-titleurl = `http://sap.com`.
    temp5-icon = `sap-icon://building`.
    temp5-iconvisibility = abap_true.
    temp5-displayshape = `Square`.
    temp5-description = `John Doe`.
    
    CLEAR temp1.
    
    temp2-heading = `Contact Details`.
    
    CLEAR temp7.
    
    temp8-label = `Phone`.
    temp8-value = `+001 6101 34869-0`.
    temp8-elementtype = `phone`.
    temp8-target = `_blank`.
    INSERT temp8 INTO TABLE temp7.
    temp8-label = `Address`.
    temp8-value = `550 Larkin Street, 4F, Mountain View, CA, 94102 San Francisco USA`.
    temp8-elementtype = `text`.
    temp8-target = `_blank`.
    INSERT temp8 INTO TABLE temp7.
    temp2-elements = temp7.
    INSERT temp2 INTO TABLE temp1.
    temp2-heading = `Main Contact`.
    
    CLEAR temp9.
    
    temp10-label = `Name`.
    temp10-value = `John Doe`.
    temp10-elementtype = `pageLink`.
    temp10-pagelinkid = `companyEmployeePageId`.
    temp10-target = `_blank`.
    INSERT temp10 INTO TABLE temp9.
    temp10-label = `Mobile`.
    temp10-value = `+001 6101 34869-0`.
    temp10-elementtype = `mobile`.
    temp10-target = `_blank`.
    INSERT temp10 INTO TABLE temp9.
    temp10-label = `Phone`.
    temp10-value = `+001 6101 34869-0`.
    temp10-elementtype = `phone`.
    temp10-target = `_blank`.
    INSERT temp10 INTO TABLE temp9.
    temp10-label = `Email`.
    temp10-value = `main.contact@company.com`.
    temp10-elementtype = `email`.
    temp10-emailsubject = `Subject`.
    temp10-target = `_blank`.
    INSERT temp10 INTO TABLE temp9.
    temp2-elements = temp9.
    INSERT temp2 INTO TABLE temp1.
    temp5-groups = temp1.
    INSERT temp5 INTO TABLE temp4.
    temp5-pageid = `companyEmployeePageId`.
    temp5-header = `Employee Info`.
    temp5-title = `John Doe`.
    temp5-icon = `sap-icon://person-placeholder`.
    temp5-iconvisibility = abap_true.
    temp5-displayshape = `Circle`.
    temp5-description = `Department Manager`.
    
    CLEAR temp3.
    
    temp6-heading = `Company`.
    
    CLEAR temp11.
    
    temp12-label = `Name`.
    temp12-value = `Adventure Company`.
    temp12-elementtype = `link`.
    temp12-url = `http://sap.com`.
    temp12-target = `_blank`.
    INSERT temp12 INTO TABLE temp11.
    temp12-label = `Address`.
    temp12-value = `Sofia, Boris III, 136A`.
    temp12-elementtype = `text`.
    temp12-target = `_blank`.
    INSERT temp12 INTO TABLE temp11.
    temp12-label = `Slogan`.
    temp12-value = `Innovation through technology`.
    temp12-elementtype = `text`.
    temp12-target = `_blank`.
    INSERT temp12 INTO TABLE temp11.
    temp6-elements = temp11.
    INSERT temp6 INTO TABLE temp3.
    temp6-heading = `Other`.
    
    CLEAR temp13.
    
    temp14-label = `Email`.
    temp14-value = `john.doe@sap.com`.
    temp14-elementtype = `email`.
    temp14-emailsubject = `Subject`.
    temp14-target = `_blank`.
    INSERT temp14 INTO TABLE temp13.
    temp14-label = `Phone`.
    temp14-value = `+359 888 888 888`.
    temp14-elementtype = `mobile`.
    temp14-target = `_blank`.
    INSERT temp14 INTO TABLE temp13.
    temp6-elements = temp13.
    INSERT temp6 INTO TABLE temp3.
    temp5-groups = temp3.
    INSERT temp5 INTO TABLE temp4.
    t_pages = temp4.

  ENDMETHOD.

ENDCLASS.
