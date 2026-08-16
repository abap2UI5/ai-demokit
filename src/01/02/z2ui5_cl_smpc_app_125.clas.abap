CLASS z2ui5_cl_smpc_app_125 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_125 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `displayBlock` v = `true`
        )->a( n = `xmlns:l`      v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns`        v = `sap.m`

        )->ele( `App`
            )->ele( n = `Splitter` ns = `l`
                )->a( n = `height` v = `500px`

                )->ele( `Button`
                    )->a( n = `width` v = `100%`
                    )->a( n = `text`  v = `Content 1`
                    )->ele( `layoutData`
                        )->tag( n = `SplitterLayoutData` ns = `l`
                            )->a( n = `size` v = `300px`

                    )->end(
                )->end(
                )->ele( `Button`
                    )->a( n = `width` v = `100%`
                    )->a( n = `text`  v = `Content 2`
                    )->ele( `layoutData`
                        )->tag( n = `SplitterLayoutData` ns = `l`
                            )->a( n = `size` v = `auto` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
