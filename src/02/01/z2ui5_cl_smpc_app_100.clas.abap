" @keywords quickview quick sap.m popover entity pages vbox button quickviewpage avatar quickviewgroup quickviewgroupelement
" @summary QuickView basic samples.
CLASS z2ui5_cl_smpc_app_100 DEFINITION PUBLIC.

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
    TYPES ty_t_page TYPE STANDARD TABLE OF ty_s_page WITH DEFAULT KEY.
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


CLASS z2ui5_cl_smpc_app_100 IMPLEMENTATION.

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
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->tag( `Button`
                )->a( n = `id`           v = `employeeQuickView`
                )->a( n = `text`         v = `Employee QuickView`
                )->a( n = `width`        v = `200px`
                )->a( n = `press`        v = client->_event( `EMPLOYEE` )
                )->a( n = `class`        v = `sapUiSmallMarginBottom`
                )->a( n = `ariaHasPopup` v = `Dialog`
            )->tag( `Button`
                )->a( n = `id`           v = `showQuickView`
                )->a( n = `text`         v = `Company QuickView`
                )->a( n = `width`        v = `200px`
                )->a( n = `press`        v = client->_event( `COMPANY` )
                )->a( n = `class`        v = `sapUiSmallMarginBottom`
                )->a( n = `ariaHasPopup` v = `Dialog`
            )->tag( `Button`
                )->a( n = `id`           v = `genericQuickView`
                )->a( n = `text`         v = `Generic QuickView`
                )->a( n = `width`        v = `200px`
                )->a( n = `press`        v = client->_event( `GENERIC` )
                )->a( n = `class`        v = `sapUiSmallMarginBottom`
                )->a( n = `ariaHasPopup` v = `Dialog`
            )->tag( `Button`
                )->a( n = `id`           v = `genericQuickViewNoHeader`
                )->a( n = `text`         v = `Generic QuickView No Header Set`
                )->a( n = `width`        v = `250px`
                )->a( n = `press`        v = client->_event( `GENERIC_NOHEADER` )
                )->a( n = `class`        v = `sapUiSmallMarginBottom`
                )->a( n = `ariaHasPopup` v = `Dialog` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA lv_origin TYPE string.
        DATA temp1 TYPE string.

    CASE client->get_event( ).

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
        " onNavigate: the clicked link's text, or the back button
        
        lv_origin = client->get_event_arg( ).
        
        IF lv_origin IS NOT INITIAL.
          temp1 = |Link '{ lv_origin }' was clicked|.
        ELSE.
          temp1 = `Back button was clicked`.
        ENDIF.
        client->message_toast_display( temp1 ).

    ENDCASE.

  ENDMETHOD.


  METHOD popup_quickview_display.

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    popup = z2ui5_cl_ui5_view_builder=>factory( ).

    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `QuickView`
            )->a( n = `id`       v = `quickView`
            )->a( n = `pages`    v = client->_bind( t_pages )
            " onNavigate reads the navOrigin link and names it in the toast;
            " a BACK navigation has no navOrigin, which the ternary reproduces
            )->a( n = `navigate` v = client->_event( val = `NAVIGATE` arg = `${$parameters>/navOrigin} ? ${$parameters>/navOrigin}.getText() : ''` )

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

    client->popover_display( xml = popup->stringify( ) by_id = by_id ).

  ENDMETHOD.


  METHOD model_init.

    " target seeds the UI5 default '_blank' explicitly - a serialized empty
    " string would override the QuickViewGroupElement.target default
    DATA temp2 TYPE z2ui5_cl_smpc_app_100=>ty_t_page.
    DATA temp3 LIKE LINE OF temp2.
    DATA temp1 TYPE z2ui5_cl_smpc_app_100=>ty_t_group.
    DATA temp10 LIKE LINE OF temp1.
    DATA temp19 TYPE z2ui5_cl_smpc_app_100=>ty_t_element.
    DATA temp20 LIKE LINE OF temp19.
    DATA temp21 TYPE z2ui5_cl_smpc_app_100=>ty_t_element.
    DATA temp22 LIKE LINE OF temp21.
    DATA temp11 TYPE z2ui5_cl_smpc_app_100=>ty_t_group.
    DATA temp12 LIKE LINE OF temp11.
    DATA temp23 TYPE z2ui5_cl_smpc_app_100=>ty_t_element.
    DATA temp24 LIKE LINE OF temp23.
    DATA temp25 TYPE z2ui5_cl_smpc_app_100=>ty_t_element.
    DATA temp26 LIKE LINE OF temp25.
    DATA temp4 TYPE z2ui5_cl_smpc_app_100=>ty_t_page.
    DATA temp5 LIKE LINE OF temp4.
    DATA temp13 TYPE z2ui5_cl_smpc_app_100=>ty_t_group.
    DATA temp14 LIKE LINE OF temp13.
    DATA temp27 TYPE z2ui5_cl_smpc_app_100=>ty_t_element.
    DATA temp28 LIKE LINE OF temp27.
    DATA temp29 TYPE z2ui5_cl_smpc_app_100=>ty_t_element.
    DATA temp30 LIKE LINE OF temp29.
    DATA temp6 TYPE z2ui5_cl_smpc_app_100=>ty_t_page.
    DATA temp7 LIKE LINE OF temp6.
    DATA temp15 TYPE z2ui5_cl_smpc_app_100=>ty_t_group.
    DATA temp16 LIKE LINE OF temp15.
    DATA temp31 TYPE z2ui5_cl_smpc_app_100=>ty_t_element.
    DATA temp32 LIKE LINE OF temp31.
    DATA temp8 TYPE z2ui5_cl_smpc_app_100=>ty_t_page.
    DATA temp9 LIKE LINE OF temp8.
    DATA temp17 TYPE z2ui5_cl_smpc_app_100=>ty_t_group.
    DATA temp18 LIKE LINE OF temp17.
    DATA temp33 TYPE z2ui5_cl_smpc_app_100=>ty_t_element.
    DATA temp34 LIKE LINE OF temp33.
    CLEAR temp2.
    
    temp3-pageid = `companyPageId`.
    temp3-header = `Company Info`.
    temp3-title = `Adventure Company`.
    temp3-titleurl = `http://sap.com`.
    temp3-icon = `sap-icon://building`.
    temp3-displayshape = `Square`.
    temp3-description = `John Doe`.
    
    CLEAR temp1.
    
    temp10-heading = `Contact Details`.
    
    CLEAR temp19.
    
    temp20-label = `Phone`.
    temp20-value = `+001 6101 34869-0`.
    temp20-elementtype = `phone`.
    temp20-target = `_blank`.
    INSERT temp20 INTO TABLE temp19.
    temp20-label = `Address`.
    temp20-value = `550 Larkin Street, 4F, Mountain View, CA, 94102 San Francisco USA`.
    temp20-elementtype = `text`.
    temp20-target = `_blank`.
    INSERT temp20 INTO TABLE temp19.
    temp10-elements = temp19.
    INSERT temp10 INTO TABLE temp1.
    temp10-heading = `Main Contact`.
    
    CLEAR temp21.
    
    temp22-label = `Name`.
    temp22-value = `John Doe`.
    temp22-elementtype = `pageLink`.
    temp22-pagelinkid = `companyEmployeePageId`.
    temp22-target = `_blank`.
    INSERT temp22 INTO TABLE temp21.
    temp22-label = `Mobile`.
    temp22-value = `+001 6101 34869-0`.
    temp22-elementtype = `mobile`.
    temp22-target = `_blank`.
    INSERT temp22 INTO TABLE temp21.
    temp22-label = `Phone`.
    temp22-value = `+001 6101 34869-0`.
    temp22-elementtype = `phone`.
    temp22-target = `_blank`.
    INSERT temp22 INTO TABLE temp21.
    temp22-label = `Email`.
    temp22-value = `main.contact@company.com`.
    temp22-elementtype = `email`.
    temp22-emailsubject = `Subject`.
    temp22-target = `_blank`.
    INSERT temp22 INTO TABLE temp21.
    temp10-elements = temp21.
    INSERT temp10 INTO TABLE temp1.
    temp3-groups = temp1.
    INSERT temp3 INTO TABLE temp2.
    temp3-pageid = `companyEmployeePageId`.
    temp3-header = `Employee Info`.
    temp3-title = `John Doe`.
    temp3-icon = `sap-icon://person-placeholder`.
    temp3-displayshape = `Circle`.
    temp3-description = `Department Manager`.
    
    CLEAR temp11.
    
    temp12-heading = `Company`.
    
    CLEAR temp23.
    
    temp24-label = `Name`.
    temp24-value = `Adventure Company`.
    temp24-url = `http://sap.com`.
    temp24-elementtype = `link`.
    temp24-target = `_blank`.
    INSERT temp24 INTO TABLE temp23.
    temp24-label = `Address`.
    temp24-value = `Sofia, Boris III, 136A`.
    temp24-elementtype = `text`.
    temp24-target = `_blank`.
    INSERT temp24 INTO TABLE temp23.
    temp24-label = `Slogan`.
    temp24-value = `Innovation through technology`.
    temp24-elementtype = `text`.
    temp24-target = `_blank`.
    INSERT temp24 INTO TABLE temp23.
    temp12-elements = temp23.
    INSERT temp12 INTO TABLE temp11.
    temp12-heading = `Other`.
    
    CLEAR temp25.
    
    temp26-label = `Email`.
    temp26-value = `john.doe@sap.com`.
    temp26-elementtype = `email`.
    temp26-emailsubject = `Subject`.
    temp26-target = `_blank`.
    INSERT temp26 INTO TABLE temp25.
    temp26-label = `Phone`.
    temp26-value = `+359 888 888 888`.
    temp26-elementtype = `phone`.
    temp26-target = `_blank`.
    INSERT temp26 INTO TABLE temp25.
    temp12-elements = temp25.
    INSERT temp12 INTO TABLE temp11.
    temp3-groups = temp11.
    INSERT temp3 INTO TABLE temp2.
    t_company = temp2.

    
    CLEAR temp4.
    
    temp5-pageid = `employeePageId`.
    temp5-header = `Employee Info`.
    temp5-title = `Michael Muller`.
    temp5-icon = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/johnDoe.png`.
    temp5-displayshape = `Circle`.
    temp5-description = `Account Manager`.
    
    CLEAR temp13.
    
    temp14-heading = `Contact Details`.
    
    CLEAR temp27.
    
    temp28-label = `Mobile`.
    temp28-value = `+001 6101 34869-0`.
    temp28-elementtype = `mobile`.
    temp28-target = `_blank`.
    INSERT temp28 INTO TABLE temp27.
    temp28-label = `Phone`.
    temp28-value = `+001 6101 34869-1`.
    temp28-elementtype = `phone`.
    temp28-target = `_blank`.
    INSERT temp28 INTO TABLE temp27.
    temp28-label = `Email`.
    temp28-value = `main.contact@company.com`.
    temp28-elementtype = `email`.
    temp28-emailsubject = `Subject`.
    temp28-target = `_blank`.
    INSERT temp28 INTO TABLE temp27.
    temp14-elements = temp27.
    INSERT temp14 INTO TABLE temp13.
    temp14-heading = `Company`.
    
    CLEAR temp29.
    
    temp30-label = `Name`.
    temp30-value = `Adventure Company`.
    temp30-url = `http://sap.com`.
    temp30-elementtype = `link`.
    temp30-target = `_blank`.
    INSERT temp30 INTO TABLE temp29.
    temp30-label = `Address`.
    temp30-value = `Main Street 4572, Los Angeles USA`.
    temp30-elementtype = `text`.
    temp30-target = `_blank`.
    INSERT temp30 INTO TABLE temp29.
    temp14-elements = temp29.
    INSERT temp14 INTO TABLE temp13.
    temp5-groups = temp13.
    INSERT temp5 INTO TABLE temp4.
    t_employee = temp4.

    
    CLEAR temp6.
    
    temp7-pageid = `genericPageId`.
    temp7-header = `Process`.
    temp7-title = `Inventarisation`.
    temp7-titleurl = `http://de.wikipedia.org/wiki/Inventarisation`.
    temp7-icon = `sap-icon://camera`.
    temp7-displayshape = `Circle`.
    
    CLEAR temp15.
    
    
    CLEAR temp31.
    
    temp32-label = `Start Date`.
    temp32-value = `01/01/2015`.
    temp32-elementtype = `text`.
    temp32-target = `_blank`.
    INSERT temp32 INTO TABLE temp31.
    temp32-label = `End Date`.
    temp32-value = `31/12/2015`.
    temp32-elementtype = `text`.
    temp32-target = `_blank`.
    INSERT temp32 INTO TABLE temp31.
    temp32-label = `Occurrence`.
    temp32-value = `Weekly`.
    temp32-elementtype = `text`.
    temp32-target = `_blank`.
    INSERT temp32 INTO TABLE temp31.
    temp16-elements = temp31.
    INSERT temp16 INTO TABLE temp15.
    temp7-groups = temp15.
    INSERT temp7 INTO TABLE temp6.
    t_generic = temp6.

    
    CLEAR temp8.
    
    temp9-pageid = `genericPageId`.
    temp9-title = `Inventarisation`.
    temp9-titleurl = `http://de.wikipedia.org/wiki/Inventarisation`.
    temp9-icon = `sap-icon://camera`.
    temp9-displayshape = `Circle`.
    
    CLEAR temp17.
    
    
    CLEAR temp33.
    
    temp34-label = `Start Date`.
    temp34-value = `01/01/2015`.
    temp34-elementtype = `text`.
    temp34-target = `_blank`.
    INSERT temp34 INTO TABLE temp33.
    temp34-label = `End Date`.
    temp34-value = `31/12/2015`.
    temp34-elementtype = `text`.
    temp34-target = `_blank`.
    INSERT temp34 INTO TABLE temp33.
    temp34-label = `Occurrence`.
    temp34-value = `Weekly`.
    temp34-elementtype = `text`.
    temp34-target = `_blank`.
    INSERT temp34 INTO TABLE temp33.
    temp18-elements = temp33.
    INSERT temp18 INTO TABLE temp17.
    temp9-groups = temp17.
    INSERT temp9 INTO TABLE temp8.
    t_generic_noheader = temp8.

  ENDMETHOD.

ENDCLASS.
