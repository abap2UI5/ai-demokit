CLASS z2ui5_cl_ai_app_163 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA isnophone          TYPE abap_bool.
    DATA isnotphoneortablet TYPE abap_bool.
    DATA istablet           TYPE abap_bool.
    DATA isphoneortablet    TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_163 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " The original drives the overflow toolbar's button visibility from a
    " separate 'range' media model ({range>/isNoPhone} ...). abap2UI5 has one
    " default model, so those flags live flat in it and visible binds them
    " directly (the 'range>' prefix is dropped - last path segment identical,
    " which structural-diff matches).
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `height`    v = `100%`

        )->open( `Page`
            )->a( n = `showHeader` v = `false`

            )->open( `content`
                )->leaf( `Text`
                    )->a( n = `text`  v = `See the actions in the footer toolbar.`
                    )->a( n = `class` v = `sapUiSmallMargin`

            )->shut(

            )->open( `footer`
                )->open( `Toolbar`
                    )->leaf( `ToolbarSpacer`
                    )->leaf( `Button`
                        )->a( n = `text`  v = `Approve`
                        )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Approve` ) ) )
                        )->a( n = `type`  v = `Accept`
                    )->leaf( `Button`
                        )->a( n = `text`  v = `Reject`
                        )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Reject` ) ) )
                        )->a( n = `type`  v = `Reject`
                    )->leaf( `Button`
                        )->a( n = `text`    v = `Mark as Favorite`
                        )->a( n = `press`   v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Mark as Favorite` ) ) )
                        )->a( n = `visible` v = client->_bind( isnophone )
                    )->leaf( `Button`
                        )->a( n = `text`    v = `Send Email`
                        )->a( n = `press`   v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Send Email` ) ) )
                        )->a( n = `visible` v = client->_bind( isnophone )
                    )->leaf( `Button`
                        )->a( n = `text`    v = `Share`
                        )->a( n = `press`   v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Share` ) ) )
                        )->a( n = `visible` v = client->_bind( isnophone )
                    )->leaf( `Button`
                        )->a( n = `text`    v = `Print`
                        )->a( n = `press`   v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Print` ) ) )
                        )->a( n = `visible` v = client->_bind( isnotphoneortablet )
                    )->leaf( `Button`
                        )->a( n = `icon`    v = `sap-icon://print`
                        )->a( n = `press`   v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Print` ) ) )
                        )->a( n = `visible` v = client->_bind( istablet )
                    )->leaf( `Button`
                        )->a( n = `text`    v = `Export as Excel`
                        )->a( n = `press`   v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Export as Excel` ) ) )
                        )->a( n = `visible` v = client->_bind( isnotphoneortablet )
                    )->leaf( `Button`
                        )->a( n = `icon`    v = `sap-icon://overflow`
                        )->a( n = `press`   v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Overflow` ) ) )
                        )->a( n = `visible` v = client->_bind( isphoneortablet ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " original fills the 'range' model from Device.media ranges; the desktop
    " ranges are used here (a client-only decision in the original).
    isnophone          = abap_true.
    isnotphoneortablet = abap_true.
    istablet           = abap_false.
    isphoneortablet    = abap_false.

  ENDMETHOD.

ENDCLASS.
