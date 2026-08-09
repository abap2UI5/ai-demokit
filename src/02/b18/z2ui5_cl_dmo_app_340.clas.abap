CLASS z2ui5_cl_dmo_app_340 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_340 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `displayBlock` v = `true`
        )->a( n = `xmlns:l`      v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns`        v = `sap.m`

        )->open( `App`
            )->open( n = `Splitter` ns = `l`
                )->a( n = `height` v = `500px`
                )->a( n = `width`  v = `100%`

                )->open( `Button`
                    )->a( n = `width` v = `100%`
                    )->a( n = `text`  v = `Content 1`

                    )->open( `layoutData`
                        )->leaf( n = `SplitterLayoutData` ns = `l`
                            )->a( n = `size` v = `300px`

                    )->shut(
                )->shut(
                )->open( `Button`
                    )->a( n = `width` v = `100%`
                    )->a( n = `text`  v = `Content 2`

                    )->open( `layoutData`
                        )->leaf( n = `SplitterLayoutData` ns = `l`
                            )->a( n = `size` v = `auto`

                    )->shut(
                )->shut(
                )->open( `Button`
                    )->a( n = `width` v = `100%`
                    )->a( n = `text`  v = `Content 3`

                    )->open( `layoutData`
                        )->leaf( n = `SplitterLayoutData` ns = `l`
                            )->a( n = `size`    v = `30%`
                            " the original writes minSize="200px", but the property is
                            " typed int - the numeric value it means is used (declared)
                            )->a( n = `minSize` v = `200` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
