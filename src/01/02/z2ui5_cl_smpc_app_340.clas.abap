" @keywords splitter sap.ui.layout splitter4 app button splitterlayoutdata
" @summary Simple splitter example with three content areas
CLASS z2ui5_cl_smpc_app_340 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_340 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `displayBlock` v = `true`
        )->a( n = `xmlns:l`      v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns`        v = `sap.m`

        )->ele( `App`
            )->ele( n = `Splitter` ns = `l`
                )->a( n = `height` v = `500px`
                )->a( n = `width`  v = `100%`

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
                            )->a( n = `size` v = `auto`

                    )->end(
                )->end(
                )->ele( `Button`
                    )->a( n = `width` v = `100%`
                    )->a( n = `text`  v = `Content 3`

                    )->ele( `layoutData`
                        )->tag( n = `SplitterLayoutData` ns = `l`
                            )->a( n = `size`    v = `30%`
                            " the original writes minSize="200px", but the property is
                            " typed int - the numeric value it means is used (declared)
                            )->a( n = `minSize` v = `200` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
