" @keywords splitter sap.ui.layout splitternested1 app splitterlayoutdata button
" @summary Nested Splitter example with 7 content areas
CLASS z2ui5_cl_smpc_app_266 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_266 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " a fully static sample: nested Splitters whose panes carry their own
    " SplitterLayoutData (size/minSize). The outer aggregation is the default
    " contentAreas one - written as a bare l:contentAreas open where the
    " original names it, and implicitly where it does not
    view->ele( n = `View` ns = `mvc`
        )->a( n = `displayBlock` v = `true`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:l`      v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`

        )->ele( `App`
            )->ele( n = `Splitter` ns = `l`
                )->a( n = `height`      v = `500px`
                )->a( n = `orientation` v = `Vertical`

                )->ele( n = `Splitter` ns = `l`
                    )->ele( n = `layoutData` ns = `l`
                        )->tag( n = `SplitterLayoutData` ns = `l`
                            )->a( n = `size` v = `50px`

                    )->end(

                    )->ele( n = `contentAreas` ns = `l`
                        )->ele( `Button`
                            )->a( n = `width` v = `100%`
                            )->a( n = `text`  v = `Content 1`

                            )->ele( `layoutData`
                                )->tag( n = `SplitterLayoutData` ns = `l`
                                    )->a( n = `size` v = `auto`

                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( n = `Splitter` ns = `l`
                    )->ele( n = `layoutData` ns = `l`
                        )->tag( n = `SplitterLayoutData` ns = `l`
                            )->a( n = `size` v = `auto`

                    )->end(

                    )->ele( n = `contentAreas` ns = `l`
                        )->ele( `Button`
                            )->a( n = `width` v = `100%`
                            )->a( n = `text`  v = `Content 2`

                            )->ele( `layoutData`
                                )->tag( n = `SplitterLayoutData` ns = `l`
                                    )->a( n = `size` v = `300px`

                            )->end(
                        )->end(

                        )->ele( n = `Splitter` ns = `l`
                            )->a( n = `orientation` v = `Vertical`

                            )->ele( `Button`
                                )->a( n = `width` v = `100%`
                                )->a( n = `text`  v = `Content 3`

                                )->ele( `layoutData`
                                    )->tag( n = `SplitterLayoutData` ns = `l`
                                        )->a( n = `size` v = `auto`

                                )->end(
                            )->end(

                            )->ele( `Button`
                                )->a( n = `width` v = `100%`
                                )->a( n = `text`  v = `Content 4`

                                )->ele( `layoutData`
                                    )->tag( n = `SplitterLayoutData` ns = `l`
                                        )->a( n = `size` v = `10%`

                                )->end(
                            )->end(
                        )->end(

                        )->ele( `Button`
                            )->a( n = `width` v = `100%`
                            )->a( n = `text`  v = `Content 5`

                            )->ele( `layoutData`
                                )->tag( n = `SplitterLayoutData` ns = `l`
                                    )->a( n = `size`    v = `30%`
                                    )->a( n = `minSize` v = `200`

                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->ele( n = `Splitter` ns = `l`
                    )->ele( n = `layoutData` ns = `l`
                        )->tag( n = `SplitterLayoutData` ns = `l`
                            )->a( n = `size` v = `50px`

                    )->end(

                    )->ele( n = `contentAreas` ns = `l`
                        )->ele( `Button`
                            )->a( n = `width` v = `100%`
                            )->a( n = `text`  v = `Content 6`

                            )->ele( `layoutData`
                                )->tag( n = `SplitterLayoutData` ns = `l`
                                    )->a( n = `size` v = `auto`

                            )->end(
                        )->end(

                        )->ele( `Button`
                            )->a( n = `width` v = `100%`
                            )->a( n = `text`  v = `Content 7`

                            )->ele( `layoutData`
                                )->tag( n = `SplitterLayoutData` ns = `l`
                                    )->a( n = `size` v = `auto`

                                ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
