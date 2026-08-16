CLASS z2ui5_cl_smpc_app_112 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_112 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.ui.unified`
        )->a( n = `xmlns:m`   v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `height`    v = `100%`

        )->ele( n = `Page` ns = `m`
            )->a( n = `showHeader`    v = `false`
            )->a( n = `class`         v = `sapUiContentPadding`
            )->a( n = `showNavButton` v = `false`

            )->ele( n = `VBox` ns = `m`
                )->a( n = `class` v = `sapUiSmallMargin`

                )->tag( `ColorPicker`
                    )->a( n = `id`          v = `cp`
                    )->a( n = `mode`        v = `HSL`
                    )->a( n = `displayMode` v = `Simplified`
                )->tag( n = `Button` ns = `m`
                    )->a( n = `text`  v = `Open ColorPicker in a ResponsivePopover`
                    )->a( n = `press` v = client->_event( val   = `OPEN_POPOVER`
                                                          t_arg = VALUE #( ( `$event.oSource.sId` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `OPEN_POPOVER`.
      " original openPopover: a controller-built ResponsivePopover with an
      " HSL/Simplified ColorPicker, opened by the pressed button; the
      " Device.system.phone branch (Submit/Cancel buttons vs no header) is
      " expressed via device> model bindings instead of a JS branch
      DATA(popover) = z2ui5_cl_ui5_view_builder=>factory( ).

      popover->ele( n = `FragmentDefinition` ns = `core`
          )->a( n = `xmlns:core` v = `sap.ui.core`
          )->a( n = `xmlns:u`    v = `sap.ui.unified`
          )->a( n = `xmlns`      v = `sap.m`

          )->ele( `ResponsivePopover`
              )->a( n = `title`      v = `Color Picker`
              )->a( n = `showHeader` v = `{device>/system/phone}`

              )->ele( `content`
                  )->tag( n = `ColorPicker` ns = `u`
                      )->a( n = `mode`        v = `HSL`
                      )->a( n = `displayMode` v = `Simplified`

              )->end(
              )->ele( `beginButton`
                  )->tag( `Button`
                      )->a( n = `text`    v = `Submit`
                      )->a( n = `visible` v = `{device>/system/phone}`
                      )->a( n = `press`   v = client->follow_up_action( client->cs_event-popover_close )

              )->end(
              )->ele( `endButton`
                  )->tag( `Button`
                      )->a( n = `text`    v = `Cancel`
                      )->a( n = `visible` v = `{device>/system/phone}`
                      )->a( n = `press`   v = client->follow_up_action( client->cs_event-popover_close ) ).

      client->popover_display( xml   = popover->stringify( )
                               by_id = client->get_event_arg( ) ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
