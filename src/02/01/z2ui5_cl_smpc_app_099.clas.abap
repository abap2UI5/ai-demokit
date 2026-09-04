" @keywords quickviewcard quick card sap.m inline links button panel quickviewpage avatar quickviewgroup quickviewgroupelement
" @summary QuickViewCard embedded in container
CLASS z2ui5_cl_smpc_app_099 DEFINITION PUBLIC.

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
             pageid       TYPE string,
             header       TYPE string,
             title        TYPE string,
             titleurl     TYPE string,
             icon         TYPE string,
             displayshape TYPE string,
             description  TYPE string,
             groups       TYPE ty_t_group,
           END OF ty_s_page.
    TYPES temp1_6920209e76 TYPE STANDARD TABLE OF ty_s_page WITH DEFAULT KEY.
DATA t_pages TYPE temp1_6920209e76.
    DATA back_enabled TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_099 IMPLEMENTATION.

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
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `height`     v = `100%`

        )->ele( `Page`
            )->a( n = `showHeader`    v = `false`
            )->a( n = `showNavButton` v = `false`
            )->a( n = `class`         v = `sapUiContentPadding`

            )->tag( `Button`
                )->a( n = `id`      v = `buttonBack`
                )->a( n = `enabled` v = client->_bind( back_enabled )
                )->a( n = `text`    v = `Navigate Back`
                )->a( n = `press`   v = client->_event( `BACK` )
                )->a( n = `class`   v = `sapUiSmallMarginBottom`

            " the QuickViewCard fragment is inlined into the main view (no separate core:Fragment include)
            )->ele( `Panel`
                )->a( n = `id`     v = `quickViewCardContainer`
                )->a( n = `width`  v = `auto`
                )->a( n = `height` v = `650px`

                )->ele( `QuickViewCard`
                    )->a( n = `id`            v = `quickViewCard`
                    )->a( n = `pages`         v = client->_bind( t_pages )
                    " onNavigate reads the navOrigin link and names it in the toast;
                    " a BACK navigation has no navOrigin, which the ternary reproduces
                    )->a( n = `navigate`      v = client->_event( val = `NAVIGATE` arg = `${$parameters>/navOrigin} ? ${$parameters>/navOrigin}.getText() : ''` )
                    )->a( n = `afterNavigate` v = client->_event( val = `AFTER_NAV` arg = `${$parameters>/isTopPage}` )

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
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp1 TYPE string_table.
        DATA origin TYPE string.
        DATA temp3 TYPE string.
        DATA temp2 TYPE xsdboolean.

    CASE client->get_event( ).

      WHEN `BACK`.
        
        CLEAR temp1.
        INSERT `quickViewCard` INTO TABLE temp1.
        INSERT `navigateBack` INTO TABLE temp1.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = temp1 ).

      WHEN `NAVIGATE`.
        " onNavigate: the clicked link's text, or the back button
        
        origin = client->get_event_arg( ).
        
        IF origin IS NOT INITIAL.
          temp3 = |Link '{ origin }' was clicked|.
        ELSE.
          temp3 = `Back button was clicked`.
        ENDIF.
        client->message_toast_display( temp3 ).

      WHEN `AFTER_NAV`.
        " enable the back button while the card is not on its top page (original afterNavigate isTopPage)
        
        temp2 = boolc( client->get_event_arg( ) = abap_false ).
        back_enabled = temp2.

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " target seeds the UI5 default '_blank' explicitly - a serialized empty
    " string would override the QuickViewGroupElement.target default
    DATA temp4 LIKE t_pages.
    DATA temp5 LIKE LINE OF temp4.
    DATA temp1 TYPE z2ui5_cl_smpc_app_099=>ty_t_group.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp7 TYPE z2ui5_cl_smpc_app_099=>ty_t_element.
    DATA temp8 LIKE LINE OF temp7.
    DATA temp9 TYPE z2ui5_cl_smpc_app_099=>ty_t_element.
    DATA temp10 LIKE LINE OF temp9.
    DATA temp3 TYPE z2ui5_cl_smpc_app_099=>ty_t_group.
    DATA temp6 LIKE LINE OF temp3.
    DATA temp11 TYPE z2ui5_cl_smpc_app_099=>ty_t_element.
    DATA temp12 LIKE LINE OF temp11.
    DATA temp13 TYPE z2ui5_cl_smpc_app_099=>ty_t_element.
    DATA temp14 LIKE LINE OF temp13.
    CLEAR temp4.
    
    temp5-pageid = `companyPageId`.
    temp5-header = `Company info`.
    temp5-title = `Adventure Company`.
    temp5-titleurl = `http://sap.com`.
    temp5-icon = `sap-icon://building`.
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
    temp10-label = `Additional info`.
    temp10-value = ``.
    temp10-elementtype = `text`.
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
    temp5-displayshape = `Circle`.
    temp5-description = `Department Manager`.
    
    CLEAR temp3.
    
    temp6-heading = `Company`.
    
    CLEAR temp11.
    
    temp12-label = `Name`.
    temp12-value = `Adventure Company`.
    temp12-url = `http://sap.com`.
    temp12-elementtype = `link`.
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
