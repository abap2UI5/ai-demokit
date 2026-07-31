CLASS z2ui5_cl_ai_app_266 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_266 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " a fully static sample: nested Splitters whose panes carry their own
    " SplitterLayoutData (size/minSize). The outer aggregation is the default
    " contentAreas one - written as a bare l:contentAreas open where the
    " original names it, and implicitly where it does not
    view->open( n = `View` ns = `mvc`
        )->a( n = `displayBlock` v = `true`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:l`      v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`

        )->open( `App`
            )->open( n = `Splitter` ns = `l`
                )->a( n = `height`      v = `500px`
                )->a( n = `orientation` v = `Vertical`

                )->open( n = `Splitter` ns = `l`
                    )->open( n = `layoutData` ns = `l`
                        )->leaf( n = `SplitterLayoutData` ns = `l`
                            )->a( n = `size` v = `50px`

                    )->shut(

                    )->open( n = `contentAreas` ns = `l`
                        )->open( `Button`
                            )->a( n = `width` v = `100%`
                            )->a( n = `text`  v = `Content 1`

                            )->open( `layoutData`
                                )->leaf( n = `SplitterLayoutData` ns = `l`
                                    )->a( n = `size` v = `auto`

                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(

                )->open( n = `Splitter` ns = `l`
                    )->open( n = `layoutData` ns = `l`
                        )->leaf( n = `SplitterLayoutData` ns = `l`
                            )->a( n = `size` v = `auto`

                    )->shut(

                    )->open( n = `contentAreas` ns = `l`
                        )->open( `Button`
                            )->a( n = `width` v = `100%`
                            )->a( n = `text`  v = `Content 2`

                            )->open( `layoutData`
                                )->leaf( n = `SplitterLayoutData` ns = `l`
                                    )->a( n = `size` v = `300px`

                            )->shut(
                        )->shut(

                        )->open( n = `Splitter` ns = `l`
                            )->a( n = `orientation` v = `Vertical`

                            )->open( `Button`
                                )->a( n = `width` v = `100%`
                                )->a( n = `text`  v = `Content 3`

                                )->open( `layoutData`
                                    )->leaf( n = `SplitterLayoutData` ns = `l`
                                        )->a( n = `size` v = `auto`

                                )->shut(
                            )->shut(

                            )->open( `Button`
                                )->a( n = `width` v = `100%`
                                )->a( n = `text`  v = `Content 4`

                                )->open( `layoutData`
                                    )->leaf( n = `SplitterLayoutData` ns = `l`
                                        )->a( n = `size` v = `10%`

                                )->shut(
                            )->shut(
                        )->shut(

                        )->open( `Button`
                            )->a( n = `width` v = `100%`
                            )->a( n = `text`  v = `Content 5`

                            )->open( `layoutData`
                                )->leaf( n = `SplitterLayoutData` ns = `l`
                                    )->a( n = `size`    v = `30%`
                                    )->a( n = `minSize` v = `200px`

                            )->shut(
                        )->shut(
                    )->shut(
                )->shut(

                )->open( n = `Splitter` ns = `l`
                    )->open( n = `layoutData` ns = `l`
                        )->leaf( n = `SplitterLayoutData` ns = `l`
                            )->a( n = `size` v = `50px`

                    )->shut(

                    )->open( n = `contentAreas` ns = `l`
                        )->open( `Button`
                            )->a( n = `width` v = `100%`
                            )->a( n = `text`  v = `Content 6`

                            )->open( `layoutData`
                                )->leaf( n = `SplitterLayoutData` ns = `l`
                                    )->a( n = `size` v = `auto`

                            )->shut(
                        )->shut(

                        )->open( `Button`
                            )->a( n = `width` v = `100%`
                            )->a( n = `text`  v = `Content 7`

                            )->open( `layoutData`
                                )->leaf( n = `SplitterLayoutData` ns = `l`
                                    )->a( n = `size` v = `auto`

                                ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
