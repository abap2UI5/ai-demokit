" @keywords colorpicker color picker sap.ui.unified colorpickerlarge vbox button responsivepopover
" @summary Basic example of Color Picker. Note that you have to set the Color Picker mode to HSL to take advantage of the responsiveness of the control on a mobile device.
CLASS z2ui5_cl_smpc_app_310 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popover_colorpicker_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_310 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns`     v = `sap.ui.unified`
        )->a( n = `xmlns:m`   v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->ele( n = `Page` ns = `m`
            )->a( n = `showHeader`    v = `false`
            )->a( n = `class`         v = `sapUiContentPadding`
            )->a( n = `showNavButton` v = `false`

            )->ele( n = `VBox` ns = `m`
                )->a( n = `class` v = `sapUiSmallMargin`

                )->tag( `ColorPicker`
                    )->a( n = `id`   v = `cp`
                    )->a( n = `mode`        v = `HSL`
                    )->a( n = `displayMode` v = `Large`

                )->tag( n = `Button` ns = `m`
                    )->a( n = `text`  v = `Open ColorPicker in a ResponsivePopover`
                    )->a( n = `press` v = client->_event( val = `OPEN_POPOVER` arg = `$event.oSource.sId` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `OPEN_POPOVER`.
      popover_colorpicker_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD popover_colorpicker_display.

    " openPopover builds the ResponsivePopover imperatively (new ResponsivePopover({...}).openBy(button));
    " expressed as a core:FragmentDefinition shown anchored via popover_display( xml by_id )
    DATA popover TYPE REF TO z2ui5_cl_ui5_view_builder.
    popover = z2ui5_cl_ui5_view_builder=>factory( ).

    popover->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:u`    v = `sap.ui.unified`

        )->ele( `ResponsivePopover`
            )->a( n = `title`      v = `Color Picker`
            " the phone branch stays a branch: the device> model is served on every
            " view slot, so showHeader and the two buttons follow the real device
            )->a( n = `showHeader` v = `{= ${device>/system/phone}}`

            )->ele( `content`
                )->tag( n = `ColorPicker` ns = `u`
                    )->a( n = `mode`        v = `HSL`
                    )->a( n = `displayMode` v = `Large`

            )->end(
            )->ele( `beginButton`
                )->tag( `Button`
                    )->a( n = `text`    v = `Submit`
                    )->a( n = `visible` v = `{= ${device>/system/phone}}`
                    )->a( n = `press`   v = client->follow_up_action( client->cs_event-popover_close )

            )->end(
            )->ele( `endButton`
                )->tag( `Button`
                    )->a( n = `text`    v = `Cancel`
                    )->a( n = `visible` v = `{= ${device>/system/phone}}`
                    )->a( n = `press`   v = client->follow_up_action( client->cs_event-popover_close ) ).

    client->popover_display( xml   = popover->stringify( )
                             by_id = client->get_event_arg( ) ).

  ENDMETHOD.

ENDCLASS.
