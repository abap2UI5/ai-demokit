CLASS z2ui5_cl_dmo_app_310 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popover_colorpicker_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_310 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns`     v = `sap.ui.unified`
        )->a( n = `xmlns:m`   v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( n = `Page` ns = `m`
            )->a( n = `showHeader`    v = `false`
            )->a( n = `class`         v = `sapUiContentPadding`
            )->a( n = `showNavButton` v = `false`

            )->open( n = `VBox` ns = `m`
                )->a( n = `class` v = `sapUiSmallMargin`

                )->leaf( `ColorPicker`
                    )->a( n = `id`   v = `cp`
                    )->a( n = `mode`        v = `HSL`
                    )->a( n = `displayMode` v = `Large`

                )->leaf( n = `Button` ns = `m`
                    )->a( n = `text`  v = `Open ColorPicker in a ResponsivePopover`
                    )->a( n = `press` v = client->_event( val   = `OPEN_POPOVER`
                                                          t_arg = VALUE #( ( `$event.oSource.sId` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `OPEN_POPOVER`.
        popover_colorpicker_display( ).

    ENDCASE.

  ENDMETHOD.


  METHOD popover_colorpicker_display.

    " openPopover builds the ResponsivePopover imperatively (new ResponsivePopover({...}).openBy(button));
    " expressed as a core:FragmentDefinition shown anchored via popover_display( xml by_id )
    DATA(popover) = z2ui5_cl_ai_xml=>factory( ).

    popover->open( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:u`    v = `sap.ui.unified`

        )->open( `ResponsivePopover`
            )->a( n = `title`      v = `Color Picker`
            " the phone branch stays a branch: the device> model is served on every
            " view slot, so showHeader and the two buttons follow the real device
            )->a( n = `showHeader` v = `{= ${device>/system/phone}}`

            )->open( `content`
                )->leaf( n = `ColorPicker` ns = `u`
                    )->a( n = `mode`        v = `HSL`
                    )->a( n = `displayMode` v = `Large`

            )->shut(
            )->open( `beginButton`
                )->leaf( `Button`
                    )->a( n = `text`    v = `Submit`
                    )->a( n = `visible` v = `{= ${device>/system/phone}}`
                    )->a( n = `press`   v = client->follow_up_action( client->cs_event-popover_close )

            )->shut(
            )->open( `endButton`
                )->leaf( `Button`
                    )->a( n = `text`    v = `Cancel`
                    )->a( n = `visible` v = `{= ${device>/system/phone}}`
                    )->a( n = `press`   v = client->follow_up_action( client->cs_event-popover_close ) ).

    client->popover_display( xml   = popover->stringify( )
                             by_id = client->get_event_arg( ) ).

  ENDMETHOD.

ENDCLASS.
