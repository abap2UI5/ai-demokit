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

    " The original drives the overflow toolbar's button visibility from a
    " separate 'range' media model ({range>/isNoPhone} ...). abap2UI5 has one
    " default model, so those flags live flat in it and visible binds them
    " directly (the 'range>' prefix is dropped - last path segment identical,
    " which structural-diff matches).
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
                        )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0}` ) ( `${$source>/text}` ) ) )
                        )->a( n = `type`  v = `Accept`
                    )->tag( `Button`
                        )->a( n = `text`  v = `Reject`
                        )->a( n = `press` v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0}` ) ( `${$source>/text}` ) ) )
                        )->a( n = `type`  v = `Reject`
                    )->tag( `Button`
                        )->a( n = `text`    v = `Mark as Favorite`
                        )->a( n = `press`   v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0}` ) ( `${$source>/text}` ) ) )
                        )->a( n = `visible` v = `{= ${device>/media/range} !== 'Phone' }`
                    )->tag( `Button`
                        )->a( n = `text`    v = `Send Email`
                        )->a( n = `press`   v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0}` ) ( `${$source>/text}` ) ) )
                        )->a( n = `visible` v = `{= ${device>/media/range} !== 'Phone' }`
                    )->tag( `Button`
                        )->a( n = `text`    v = `Share`
                        )->a( n = `press`   v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0}` ) ( `${$source>/text}` ) ) )
                        )->a( n = `visible` v = `{= ${device>/media/range} !== 'Phone' }`
                    )->tag( `Button`
                        )->a( n = `text`    v = `Print`
                        )->a( n = `press`   v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0}` ) ( `${$source>/text}` ) ) )
                        )->a( n = `visible` v = `{= ${device>/media/range} !== 'Phone' && ${device>/media/range} !== 'Tablet' }`
                    )->tag( `Button`
                        )->a( n = `icon`    v = `sap-icon://print`
                        )->a( n = `press`   v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0}` ) ( `${$source>/text}` ) ) )
                        )->a( n = `visible` v = `{= ${device>/media/range} === 'Tablet' }`
                    )->tag( `Button`
                        )->a( n = `text`    v = `Export as Excel`
                        )->a( n = `press`   v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0}` ) ( `${$source>/text}` ) ) )
                        )->a( n = `visible` v = `{= ${device>/media/range} !== 'Phone' && ${device>/media/range} !== 'Tablet' }`
                    )->tag( `Button`
                        )->a( n = `icon`    v = `sap-icon://overflow`
                        )->a( n = `press`   v = client->_event( val = `OPEN_SHEET` arg = `$event.oSource.sId` )
                        )->a( n = `visible` v = `{= ${device>/media/range} === 'Phone' || ${device>/media/range} === 'Tablet' }` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `OPEN_SHEET`.
      " onOpen: Fragment.load( ActionSheet.fragment.xml ) + openBy( button ) -
      " rebuilt 1:1 as a popover anchored to the pressed overflow button
      DATA(sheet) = z2ui5_cl_ui5_view_builder=>factory( ).

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
                      )->a( n = `press`   v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0}` ) ( `${$source>/text}` ) ) )
                      )->a( n = `visible` v = `{= ${device>/media/range} === 'Phone' }`
                  )->tag( `Button`
                      )->a( n = `text`    v = `Send Email`
                      )->a( n = `icon`    v = `sap-icon://email`
                      )->a( n = `press`   v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0}` ) ( `${$source>/text}` ) ) )
                      )->a( n = `visible` v = `{= ${device>/media/range} === 'Phone' }`
                  )->tag( `Button`
                      )->a( n = `text`    v = `Share`
                      )->a( n = `icon`    v = `sap-icon://share-2`
                      )->a( n = `press`   v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0}` ) ( `${$source>/text}` ) ) )
                      )->a( n = `visible` v = `{= ${device>/media/range} === 'Phone' }`
                  )->tag( `Button`
                      )->a( n = `text`    v = `Print`
                      )->a( n = `icon`    v = `sap-icon://print`
                      )->a( n = `press`   v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0}` ) ( `${$source>/text}` ) ) )
                      )->a( n = `visible` v = `{= ${device>/media/range} === 'Phone' }`
                  )->tag( `Button`
                      )->a( n = `text`    v = `Export as Excel`
                      )->a( n = `icon`    v = `sap-icon://excel-attachment`
                      )->a( n = `press`   v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0}` ) ( `${$source>/text}` ) ) )
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
