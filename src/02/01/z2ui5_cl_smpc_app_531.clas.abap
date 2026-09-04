" @keywords quickview quick sap.m quickviewavatarconfiguration button quickviewpage avatar quickviewgroup quickviewgroupelement
" @summary QuickView with fallback icon, initials, display shape and other avatar properties.
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
    TYPES ty_t_element TYPE STANDARD TABLE OF ty_s_element WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_s_group,
             heading  TYPE string,
             elements TYPE ty_t_element,
           END OF ty_s_group.
    TYPES ty_t_group TYPE STANDARD TABLE OF ty_s_group WITH DEFAULT KEY.
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
    TYPES ty_t_page TYPE STANDARD TABLE OF ty_s_page WITH DEFAULT KEY.

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

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    popup = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `Avatar was pressed` INTO TABLE temp1.
    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `QuickView`
            )->a( n = `id`    v = `quickView`
            )->a( n = `pages` v = |\{ path: '{ client->_bind_path( t_pages ) }', templateShareable: false \}|

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
                                                                                  t_arg = temp1 )

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

    client->popover_display( xml = popup->stringify( ) by_id = `showQuickView` ).

  ENDMETHOD.


  METHOD model_init.

    " target seeds the UI5 default '_blank' explicitly - a serialized empty
    " string would override the QuickViewGroupElement.target default
    DATA temp3 TYPE z2ui5_cl_smpc_app_531=>ty_t_page.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp1 TYPE z2ui5_cl_smpc_app_531=>ty_t_group.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp7 TYPE z2ui5_cl_smpc_app_531=>ty_t_element.
    DATA temp8 LIKE LINE OF temp7.
    DATA temp9 TYPE z2ui5_cl_smpc_app_531=>ty_t_element.
    DATA temp10 LIKE LINE OF temp9.
    DATA temp5 TYPE z2ui5_cl_smpc_app_531=>ty_t_group.
    DATA temp6 LIKE LINE OF temp5.
    DATA temp11 TYPE z2ui5_cl_smpc_app_531=>ty_t_element.
    DATA temp12 LIKE LINE OF temp11.
    DATA temp13 TYPE z2ui5_cl_smpc_app_531=>ty_t_element.
    DATA temp14 LIKE LINE OF temp13.
    CLEAR temp3.
    
    temp4-pageid = `companyPageId`.
    temp4-header = `Company Info`.
    temp4-title = `SAP SE`.
    temp4-titleurl = `http://sap.com`.
    temp4-description = `Founded in 1972`.
    temp4-backgroundcolor = `Accent6`.
    temp4-icon = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/QuickViewAvatarConfiguration/sap-logo.png`.
    temp4-fallbackicon = `sap-icon://building`.
    temp4-displayshape = `Square`.
    
    CLEAR temp1.
    
    temp2-heading = `Office`.
    
    CLEAR temp7.
    
    temp8-label = `Headquarters`.
    temp8-value = `Walldorf, Germany`.
    temp8-elementtype = `text`.
    temp8-target = `_blank`.
    INSERT temp8 INTO TABLE temp7.
    temp8-label = `Phone`.
    temp8-value = `+001 6101 34869-0`.
    temp8-elementtype = `phone`.
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
    temp10-emailsubject = `Subject`.
    temp10-elementtype = `email`.
    temp10-target = `_blank`.
    INSERT temp10 INTO TABLE temp9.
    temp2-elements = temp9.
    INSERT temp2 INTO TABLE temp1.
    temp4-groups = temp1.
    INSERT temp4 INTO TABLE temp3.
    temp4-pageid = `companyEmployeePageId`.
    temp4-header = `Employee Info`.
    temp4-title = `John Doe`.
    temp4-initials = `JD`.
    temp4-displayshape = `Circle`.
    temp4-backgroundcolor = `Accent8`.
    temp4-description = `Department Manager`.
    temp4-badgeicon = `sap-icon://edit`.
    
    CLEAR temp5.
    
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
    INSERT temp6 INTO TABLE temp5.
    temp6-heading = `Other`.
    
    CLEAR temp13.
    
    temp14-label = `Email`.
    temp14-value = `john.doe@sap.com`.
    temp14-emailsubject = `Subject`.
    temp14-elementtype = `email`.
    temp14-target = `_blank`.
    INSERT temp14 INTO TABLE temp13.
    temp14-label = `Phone`.
    temp14-value = `+359 888 888 888`.
    temp14-elementtype = `phone`.
    temp14-target = `_blank`.
    INSERT temp14 INTO TABLE temp13.
    temp6-elements = temp13.
    INSERT temp6 INTO TABLE temp5.
    temp4-groups = temp5.
    INSERT temp4 INTO TABLE temp3.
    t_pages = temp3.

  ENDMETHOD.

ENDCLASS.
