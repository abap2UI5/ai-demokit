" @keywords overflowtoolbar overflow toolbar sap.m responsive text toolbarspacer button actionsheet
" @summary Toolbar items can be displayed depending on the current device.
CLASS z2ui5_cl_smpc_app_163 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.


  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_163 IMPLEMENTATION.

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
    DATA temp2 TYPE string_table.
    DATA temp3 TYPE string_table.
    DATA temp4 TYPE string_table.
    DATA temp5 TYPE string_table.
    DATA temp6 TYPE string_table.
    DATA temp7 TYPE string_table.
    DATA temp8 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " The original drives the overflow toolbar's button visibility from a
    " separate 'range' media model ({range>/isNoPhone} ...). abap2UI5 has one
    " default model, so those flags live flat in it and visible binds them
    " directly (the 'range>' prefix is dropped - last path segment identical,
    " which structural-diff matches).
    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `{0}` INTO TABLE temp1.
    INSERT `${$source>/text}` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `MESSAGE_TOAST` INTO TABLE temp2.
    INSERT `show` INTO TABLE temp2.
    INSERT `{0}` INTO TABLE temp2.
    INSERT `${$source>/text}` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `MESSAGE_TOAST` INTO TABLE temp3.
    INSERT `show` INTO TABLE temp3.
    INSERT `{0}` INTO TABLE temp3.
    INSERT `${$source>/text}` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `MESSAGE_TOAST` INTO TABLE temp4.
    INSERT `show` INTO TABLE temp4.
    INSERT `{0}` INTO TABLE temp4.
    INSERT `${$source>/text}` INTO TABLE temp4.
    
    CLEAR temp5.
    INSERT `MESSAGE_TOAST` INTO TABLE temp5.
    INSERT `show` INTO TABLE temp5.
    INSERT `{0}` INTO TABLE temp5.
    INSERT `${$source>/text}` INTO TABLE temp5.
    
    CLEAR temp6.
    INSERT `MESSAGE_TOAST` INTO TABLE temp6.
    INSERT `show` INTO TABLE temp6.
    INSERT `{0}` INTO TABLE temp6.
    INSERT `${$source>/text}` INTO TABLE temp6.
    
    CLEAR temp7.
    INSERT `MESSAGE_TOAST` INTO TABLE temp7.
    INSERT `show` INTO TABLE temp7.
    INSERT `{0}` INTO TABLE temp7.
    INSERT `${$source>/text}` INTO TABLE temp7.
    
    CLEAR temp8.
    INSERT `MESSAGE_TOAST` INTO TABLE temp8.
    INSERT `show` INTO TABLE temp8.
    INSERT `{0}` INTO TABLE temp8.
    INSERT `${$source>/text}` INTO TABLE temp8.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `height`    v = `100%`

        )->ele( `Page`
            )->a( n = `showHeader` v = `false`

            )->ele( `content`
                )->tag( `Text`
                    )->a( n = `text`  v = `See the actions in the footer toolbar.`
                    )->a( n = `class` v = `sapUiSmallMargin`

            )->end(

            )->ele( `footer`
                )->ele( `Toolbar`
                    )->tag( `ToolbarSpacer`
                    )->tag( `Button`
                        )->a( n = `text`  v = `Approve`
                        )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp1 )
                        )->a( n = `type`  v = `Accept`
                    )->tag( `Button`
                        )->a( n = `text`  v = `Reject`
                        )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp2 )
                        )->a( n = `type`  v = `Reject`
                    )->tag( `Button`
                        )->a( n = `text`    v = `Mark as Favorite`
                        )->a( n = `press`   v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp3 )
                        )->a( n = `visible` v = `{= ${device>/media/range} !== 'Phone' }`
                    )->tag( `Button`
                        )->a( n = `text`    v = `Send Email`
                        )->a( n = `press`   v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp4 )
                        )->a( n = `visible` v = `{= ${device>/media/range} !== 'Phone' }`
                    )->tag( `Button`
                        )->a( n = `text`    v = `Share`
                        )->a( n = `press`   v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp5 )
                        )->a( n = `visible` v = `{= ${device>/media/range} !== 'Phone' }`
                    )->tag( `Button`
                        )->a( n = `text`    v = `Print`
                        )->a( n = `press`   v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp6 )
                        )->a( n = `visible` v = `{= ${device>/media/range} !== 'Phone' && ${device>/media/range} !== 'Tablet' }`
                    )->tag( `Button`
                        )->a( n = `icon`    v = `sap-icon://print`
                        )->a( n = `press`   v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp7 )
                        )->a( n = `visible` v = `{= ${device>/media/range} === 'Tablet' }`
                    )->tag( `Button`
                        )->a( n = `text`    v = `Export as Excel`
                        )->a( n = `press`   v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp8 )
                        )->a( n = `visible` v = `{= ${device>/media/range} !== 'Phone' && ${device>/media/range} !== 'Tablet' }`
                    )->tag( `Button`
                        )->a( n = `icon`    v = `sap-icon://overflow`
                        )->a( n = `press`   v = client->_event( val = `OPEN_SHEET` arg = `$event.oSource.sId` )
                        )->a( n = `visible` v = `{= ${device>/media/range} === 'Phone' || ${device>/media/range} === 'Tablet' }` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
      DATA sheet TYPE REF TO z2ui5_cl_ui5_view_builder.
      DATA temp3 TYPE string_table.
      DATA temp4 TYPE string_table.
      DATA temp5 TYPE string_table.
      DATA temp6 TYPE string_table.
      DATA temp7 TYPE string_table.

    IF client->get_event( ) = `OPEN_SHEET`.
      " onOpen: Fragment.load( ActionSheet.fragment.xml ) + openBy( button ) -
      " rebuilt 1:1 as a popover anchored to the pressed overflow button
      
      sheet = z2ui5_cl_ui5_view_builder=>factory( ).

      
      CLEAR temp3.
      INSERT `MESSAGE_TOAST` INTO TABLE temp3.
      INSERT `show` INTO TABLE temp3.
      INSERT `{0}` INTO TABLE temp3.
      INSERT `${$source>/text}` INTO TABLE temp3.
      
      CLEAR temp4.
      INSERT `MESSAGE_TOAST` INTO TABLE temp4.
      INSERT `show` INTO TABLE temp4.
      INSERT `{0}` INTO TABLE temp4.
      INSERT `${$source>/text}` INTO TABLE temp4.
      
      CLEAR temp5.
      INSERT `MESSAGE_TOAST` INTO TABLE temp5.
      INSERT `show` INTO TABLE temp5.
      INSERT `{0}` INTO TABLE temp5.
      INSERT `${$source>/text}` INTO TABLE temp5.
      
      CLEAR temp6.
      INSERT `MESSAGE_TOAST` INTO TABLE temp6.
      INSERT `show` INTO TABLE temp6.
      INSERT `{0}` INTO TABLE temp6.
      INSERT `${$source>/text}` INTO TABLE temp6.
      
      CLEAR temp7.
      INSERT `MESSAGE_TOAST` INTO TABLE temp7.
      INSERT `show` INTO TABLE temp7.
      INSERT `{0}` INTO TABLE temp7.
      INSERT `${$source>/text}` INTO TABLE temp7.
      sheet->ele( n = `FragmentDefinition` ns = `core`
          )->a( n = `xmlns`      v = `sap.m`
          )->a( n = `xmlns:core` v = `sap.ui.core`

          )->ele( `ActionSheet`
              )->a( n = `title`            v = `Menu`
              )->a( n = `showCancelButton` v = `true`
              )->a( n = `placement`        v = `Top`

              )->ele( `buttons`
                  )->tag( `Button`
                      )->a( n = `text`    v = `Mark as Favorite`
                      )->a( n = `icon`    v = `sap-icon://favorite`
                      )->a( n = `press`   v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp3 )
                      )->a( n = `visible` v = `{= ${device>/media/range} === 'Phone' }`
                  )->tag( `Button`
                      )->a( n = `text`    v = `Send Email`
                      )->a( n = `icon`    v = `sap-icon://email`
                      )->a( n = `press`   v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp4 )
                      )->a( n = `visible` v = `{= ${device>/media/range} === 'Phone' }`
                  )->tag( `Button`
                      )->a( n = `text`    v = `Share`
                      )->a( n = `icon`    v = `sap-icon://share-2`
                      )->a( n = `press`   v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp5 )
                      )->a( n = `visible` v = `{= ${device>/media/range} === 'Phone' }`
                  )->tag( `Button`
                      )->a( n = `text`    v = `Print`
                      )->a( n = `icon`    v = `sap-icon://print`
                      )->a( n = `press`   v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp6 )
                      )->a( n = `visible` v = `{= ${device>/media/range} === 'Phone' }`
                  )->tag( `Button`
                      )->a( n = `text`    v = `Export as Excel`
                      )->a( n = `icon`    v = `sap-icon://excel-attachment`
                      )->a( n = `press`   v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp7 )
                      )->a( n = `visible` v = `{= ${device>/media/range} === 'Phone' || ${device>/media/range} === 'Tablet' }` ).

      client->popover_display( xml   = sheet->stringify( )
                               by_id = client->get_event_arg( ) ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " the original's 'range' model - Device.media.getCurrentRange( 'Std' ) plus a
    " live attachHandler on the same range set - has no ABAP counterpart and needs
    " none: the framework publishes exactly that range as {device>/media/range},
    " from the same 'Std' set and refreshed on every resize, so the six flags are
    " expression bindings in the view. Seeding them here froze them at the desktop
    " values until 2026-08-23, which left the overflow Button permanently hidden
    " and the whole ActionSheet branch unreachable

  ENDMETHOD.

ENDCLASS.
