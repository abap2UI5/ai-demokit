CLASS z2ui5_cl_ai_app_112 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_112 IMPLEMENTATION.

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
        )->a( n = `xmlns`     v = `sap.ui.unified`
        )->a( n = `xmlns:m`   v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `height`    v = `100%`

        )->open( n = `Page` ns = `m`
            )->a( n = `showHeader`    v = `false`
            )->a( n = `class`         v = `sapUiContentPadding`
            )->a( n = `showNavButton` v = `false`

            )->open( n = `VBox` ns = `m`
                )->a( n = `class` v = `sapUiSmallMargin`

                )->leaf( `ColorPicker`
                    )->a( n = `id`          v = `cp`
                    )->a( n = `mode`        v = `HSL`
                    )->a( n = `displayMode` v = `Simplified`
                )->leaf( n = `Button` ns = `m`
                    )->a( n = `text`  v = `Open ColorPicker in a ResponsivePopover`
                    )->a( n = `press` v = client->_event( `OPEN_POPOVER` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `OPEN_POPOVER`.
        client->message_toast_display( `ColorPicker popover requested` ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
