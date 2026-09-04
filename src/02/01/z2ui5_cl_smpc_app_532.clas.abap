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
        DATA origin TYPE string.
          DATA temp1 TYPE z2ui5_cl_smpc_app_532=>ty_s_page.
          DATA temp2 TYPE z2ui5_cl_smpc_app_532=>ty_s_page.
          DATA employee LIKE temp1.
            FIELD-SYMBOLS <temp3> LIKE LINE OF t_pages.
            DATA temp4 LIKE sy-tabix.

    CASE client->get_event( ).

      WHEN `QUICK_VIEW`.
        popup_quickview_display( ).

      WHEN `NAVIGATE`.
        " onNavigate splices the EMPLOYEE record the clicked link names into
        " page 2 of the card model - the same swap, one round-trip
        
        origin = client->get_event_arg( ).
        IF origin IS NOT INITIAL.
          
          CLEAR temp1.
          
          READ TABLE t_employees INTO temp2 WITH KEY title = origin.
          IF sy-subrc = 0.
            temp1 = temp2.
          ENDIF.
          
          employee = temp1.
          IF employee IS NOT INITIAL.
            
            
            temp4 = sy-tabix.
            READ TABLE t_pages INDEX 2 ASSIGNING <temp3>.
            sy-tabix = temp4.
            IF sy-subrc <> 0.
              ASSERT 1 = 0.
            ENDIF.
            <temp3> = employee.
          ENDIF.
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD popup_quickview_display.

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    popup = z2ui5_cl_ui5_view_builder=>factory( ).

    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `QuickView`
            )->a( n = `id`    v = `quickViewNavOrigin`
            )->a( n = `pages` v = |\{ path: '{ client->_bind_path( t_pages ) }', templateShareable: true \}|
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

    client->popover_display( xml = popup->stringify( ) by_id = `quickViewBtn` ).

  ENDMETHOD.


  METHOD model_init.

    " CardData.json: the bank page plus an EMPTY contactPage placeholder that
    " onNavigate replaces with the employee the clicked link names
    " target seeds the UI5 default '_blank' explicitly - a serialized empty
    " string would override the QuickViewGroupElement.target default
    DATA temp5 TYPE z2ui5_cl_smpc_app_532=>ty_t_page.
    DATA temp6 LIKE LINE OF temp5.
    DATA temp1 TYPE z2ui5_cl_smpc_app_532=>ty_t_group.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp15 TYPE z2ui5_cl_smpc_app_532=>ty_t_element.
    DATA temp16 LIKE LINE OF temp15.
    DATA temp17 TYPE z2ui5_cl_smpc_app_532=>ty_t_element.
    DATA temp18 LIKE LINE OF temp17.
    DATA temp7 TYPE z2ui5_cl_smpc_app_532=>ty_t_page.
    DATA temp8 LIKE LINE OF temp7.
    DATA temp3 TYPE z2ui5_cl_smpc_app_532=>ty_t_group.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp19 TYPE z2ui5_cl_smpc_app_532=>ty_t_element.
    DATA temp20 LIKE LINE OF temp19.
    DATA temp21 TYPE z2ui5_cl_smpc_app_532=>ty_t_element.
    DATA temp22 LIKE LINE OF temp21.
    DATA temp9 TYPE z2ui5_cl_smpc_app_532=>ty_t_group.
    DATA temp10 LIKE LINE OF temp9.
    DATA temp23 TYPE z2ui5_cl_smpc_app_532=>ty_t_element.
    DATA temp24 LIKE LINE OF temp23.
    DATA temp25 TYPE z2ui5_cl_smpc_app_532=>ty_t_element.
    DATA temp26 LIKE LINE OF temp25.
    DATA temp11 TYPE z2ui5_cl_smpc_app_532=>ty_t_group.
    DATA temp12 LIKE LINE OF temp11.
    DATA temp27 TYPE z2ui5_cl_smpc_app_532=>ty_t_element.
    DATA temp28 LIKE LINE OF temp27.
    DATA temp29 TYPE z2ui5_cl_smpc_app_532=>ty_t_element.
    DATA temp30 LIKE LINE OF temp29.
    DATA temp13 TYPE z2ui5_cl_smpc_app_532=>ty_t_group.
    DATA temp14 LIKE LINE OF temp13.
    DATA temp31 TYPE z2ui5_cl_smpc_app_532=>ty_t_element.
    DATA temp32 LIKE LINE OF temp31.
    DATA temp33 TYPE z2ui5_cl_smpc_app_532=>ty_t_element.
    DATA temp34 LIKE LINE OF temp33.
    CLEAR temp5.
    
    temp6-pageid = `bankPage`.
    temp6-header = `Company Info`.
    temp6-title = `SAP SE`.
    temp6-icon = `sap-icon://building`.
    temp6-displayshape = `Square`.
    temp6-description = `Founded in 1972`.
    
    CLEAR temp1.
    
    temp2-heading = `Office`.
    
    CLEAR temp15.
    
    temp16-label = `Headquarters`.
    temp16-value = `Walldorf, Germany`.
    temp16-elementtype = `text`.
    temp16-target = `_blank`.
    INSERT temp16 INTO TABLE temp15.
    temp16-label = `Phone`.
    temp16-value = `+001 6101 34869-0`.
    temp16-elementtype = `phone`.
    temp16-target = `_blank`.
    INSERT temp16 INTO TABLE temp15.
    temp2-elements = temp15.
    INSERT temp2 INTO TABLE temp1.
    temp2-heading = `Contacts`.
    
    CLEAR temp17.
    
    temp18-label = `Name`.
    temp18-value = `Johnny Cash`.
    temp18-elementtype = `pageLink`.
    temp18-pagelinkid = `contactPage`.
    temp18-target = `_blank`.
    INSERT temp18 INTO TABLE temp17.
    temp18-label = `Name`.
    temp18-value = `James Bonus`.
    temp18-elementtype = `pageLink`.
    temp18-pagelinkid = `contactPage`.
    temp18-target = `_blank`.
    INSERT temp18 INTO TABLE temp17.
    temp18-label = `Name`.
    temp18-value = `Maria Leasing`.
    temp18-elementtype = `pageLink`.
    temp18-pagelinkid = `contactPage`.
    temp18-target = `_blank`.
    INSERT temp18 INTO TABLE temp17.
    temp18-label = `Name`.
    temp18-value = `Claudia Credit`.
    temp18-elementtype = `pageLink`.
    temp18-pagelinkid = `contactPage`.
    temp18-target = `_blank`.
    INSERT temp18 INTO TABLE temp17.
    temp2-elements = temp17.
    INSERT temp2 INTO TABLE temp1.
    temp6-groups = temp1.
    INSERT temp6 INTO TABLE temp5.
    temp6-pageid = `contactPage`.
    temp6-displayshape = `Circle`.
    INSERT temp6 INTO TABLE temp5.
    t_pages = temp5.

    " EmployeeData.json, keyed by the employee name the link carries
    
    CLEAR temp7.
    
    temp8-pageid = `contactPage`.
    temp8-header = `Employee Info`.
    temp8-title = `Johnny Cash`.
    temp8-icon = `sap-icon://person-placeholder`.
    temp8-displayshape = `Circle`.
    temp8-description = `Department Manager`.
    
    CLEAR temp3.
    
    temp4-heading = `Contact Info`.
    
    CLEAR temp19.
    
    temp20-label = `Address`.
    temp20-value = `550 Larkin Street, 4F, Mountain View, CA, 94102 San Francisco USA`.
    temp20-elementtype = `text`.
    temp20-target = `_blank`.
    INSERT temp20 INTO TABLE temp19.
    temp20-label = `Email`.
    temp20-value = `johnny.cash@sapbank.com`.
    temp20-emailsubject = `Give me cash`.
    temp20-elementtype = `email`.
    temp20-target = `_blank`.
    INSERT temp20 INTO TABLE temp19.
    temp20-label = `Phone`.
    temp20-value = `+359 888 888 888`.
    temp20-elementtype = `phone`.
    temp20-target = `_blank`.
    INSERT temp20 INTO TABLE temp19.
    temp4-elements = temp19.
    INSERT temp4 INTO TABLE temp3.
    temp4-heading = `Additional Info`.
    
    CLEAR temp21.
    
    temp22-label = `Major`.
    temp22-value = `Cash operations`.
    temp22-elementtype = `text`.
    temp22-target = `_blank`.
    INSERT temp22 INTO TABLE temp21.
    temp4-elements = temp21.
    INSERT temp4 INTO TABLE temp3.
    temp8-groups = temp3.
    INSERT temp8 INTO TABLE temp7.
    temp8-pageid = `contactPage`.
    temp8-header = `Employee Info`.
    temp8-title = `James Bonus`.
    temp8-icon = `sap-icon://person-placeholder`.
    temp8-displayshape = `Circle`.
    temp8-description = `Department Manager`.
    
    CLEAR temp9.
    
    temp10-heading = `Contact Info`.
    
    CLEAR temp23.
    
    temp24-label = `Address`.
    temp24-value = `550 Larkin Street, 4F, Mountain View, CA, 94102 San Francisco USA`.
    temp24-elementtype = `text`.
    temp24-target = `_blank`.
    INSERT temp24 INTO TABLE temp23.
    temp24-label = `Email`.
    temp24-value = `james.bonus@sapbank.com`.
    temp24-emailsubject = `Bonus interest`.
    temp24-elementtype = `email`.
    temp24-target = `_blank`.
    INSERT temp24 INTO TABLE temp23.
    temp24-label = `Phone`.
    temp24-value = `+359 777 777 777`.
    temp24-elementtype = `phone`.
    temp24-target = `_blank`.
    INSERT temp24 INTO TABLE temp23.
    temp10-elements = temp23.
    INSERT temp10 INTO TABLE temp9.
    temp10-heading = `Additional Info`.
    
    CLEAR temp25.
    
    temp26-label = `Major`.
    temp26-value = `Bonuses for loyal customers`.
    temp26-elementtype = `text`.
    temp26-target = `_blank`.
    INSERT temp26 INTO TABLE temp25.
    temp10-elements = temp25.
    INSERT temp10 INTO TABLE temp9.
    temp8-groups = temp9.
    INSERT temp8 INTO TABLE temp7.
    temp8-pageid = `contactPage`.
    temp8-header = `Employee Info`.
    temp8-title = `Maria Leasing`.
    temp8-icon = `sap-icon://person-placeholder`.
    temp8-displayshape = `Circle`.
    temp8-description = `Department Manager`.
    
    CLEAR temp11.
    
    temp12-heading = `Contact Info`.
    
    CLEAR temp27.
    
    temp28-label = `Address`.
    temp28-value = `550 Larkin Street, 4F, Mountain View, CA, 94102 San Francisco USA`.
    temp28-elementtype = `text`.
    temp28-target = `_blank`.
    INSERT temp28 INTO TABLE temp27.
    temp28-label = `Email`.
    temp28-value = `maria.leasing@sapbank.com`.
    temp28-emailsubject = `Leasing`.
    temp28-elementtype = `email`.
    temp28-target = `_blank`.
    INSERT temp28 INTO TABLE temp27.
    temp28-label = `Phone`.
    temp28-value = `+359 555 555 555`.
    temp28-elementtype = `phone`.
    temp28-target = `_blank`.
    INSERT temp28 INTO TABLE temp27.
    temp12-elements = temp27.
    INSERT temp12 INTO TABLE temp11.
    temp12-heading = `Additional Info`.
    
    CLEAR temp29.
    
    temp30-label = `Major`.
    temp30-value = `Financial leasing`.
    temp30-elementtype = `text`.
    temp30-target = `_blank`.
    INSERT temp30 INTO TABLE temp29.
    temp12-elements = temp29.
    INSERT temp12 INTO TABLE temp11.
    temp8-groups = temp11.
    INSERT temp8 INTO TABLE temp7.
    temp8-pageid = `contactPage`.
    temp8-header = `Employee Info`.
    temp8-title = `Claudia Credit`.
    temp8-icon = `sap-icon://person-placeholder`.
    temp8-displayshape = `Circle`.
    temp8-description = `Department Manager`.
    
    CLEAR temp13.
    
    temp14-heading = `Contact Info`.
    
    CLEAR temp31.
    
    temp32-label = `Address`.
    temp32-value = `550 Larkin Street, 4F, Mountain View, CA, 94102 San Francisco USA`.
    temp32-elementtype = `text`.
    temp32-target = `_blank`.
    INSERT temp32 INTO TABLE temp31.
    temp32-label = `Email`.
    temp32-value = `claudia.credit@sapbank.com`.
    temp32-emailsubject = `Credit`.
    temp32-elementtype = `email`.
    temp32-target = `_blank`.
    INSERT temp32 INTO TABLE temp31.
    temp32-label = `Phone`.
    temp32-value = `+359 666 666 666`.
    temp32-elementtype = `phone`.
    temp32-target = `_blank`.
    INSERT temp32 INTO TABLE temp31.
    temp14-elements = temp31.
    INSERT temp14 INTO TABLE temp13.
    temp14-heading = `Additional Info`.
    
    CLEAR temp33.
    
    temp34-label = `Major`.
    temp34-value = `Real estate & investment credits`.
    temp34-elementtype = `text`.
    temp34-target = `_blank`.
    INSERT temp34 INTO TABLE temp33.
    temp14-elements = temp33.
    INSERT temp14 INTO TABLE temp13.
    temp8-groups = temp13.
    INSERT temp8 INTO TABLE temp7.
    t_employees = temp7.

  ENDMETHOD.

ENDCLASS.
