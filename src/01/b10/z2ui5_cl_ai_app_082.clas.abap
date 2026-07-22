CLASS z2ui5_cl_ai_app_082 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_082 IMPLEMENTATION.

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

    " the sample's images are served from the demo kit sample folder; resolved to absolute OpenUI5 URLs
    DATA(img) = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/SlideTile/images/`.

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`

        )->open( n = `VerticalLayout` ns = `l`

            )->open( `SlideTile`
                )->a( n = `class` v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
                )->open( `GenericTile`
                    )->a( n = `backgroundImage` v = |{ img }NewsImage2.png|
                    )->a( n = `frameType`       v = `TwoByOne`
                    )->a( n = `press`           v = client->_event( `PRESS_ONE` )
                    )->open( `TileContent`
                        )->a( n = `footer` v = `August 21, 2016`
                        )->leaf( `NewsContent`
                            )->a( n = `contentText` v = `SAP Unveils Powerful New Player Comparision Tool Exclusively on NFL.com`
                            )->a( n = `subheader`   v = `Today, SAP News`

                    )->shut(
                )->shut(
                )->open( `GenericTile`
                    )->a( n = `backgroundImage` v = |{ img }NewsImage1.png|
                    )->a( n = `frameType`       v = `TwoByOne`
                    )->a( n = `press`           v = client->_event( `PRESS_TWO` )
                    )->open( `TileContent`
                        )->a( n = `footer` v = `August 21, 2016`
                        )->leaf( `NewsContent`
                            )->a( n = `contentText` v = `Wind Map: Monitoring Real-Time and Forecasted Wind Conditions across the Globe`
                            )->a( n = `subheader`   v = `Today, SAP News`

                    )->shut(
                )->shut(
            )->shut(

            )->open( `SlideTile`
                )->a( n = `class`          v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
                )->a( n = `transitionTime` v = `250`
                )->a( n = `displayTime`    v = `2500`
                )->open( `GenericTile`
                    )->a( n = `backgroundImage` v = |{ img }NewsImage1.png|
                    )->a( n = `frameType`       v = `TwoByOne`
                    )->a( n = `press`           v = client->_event( `PRESS_ONE` )
                    )->open( `TileContent`
                        )->a( n = `footer` v = `August 21, 2016`
                        )->leaf( `NewsContent`
                            )->a( n = `contentText` v = `Wind Map: Monitoring Real-Time and Forecasted Wind Conditions across the Globe`
                            )->a( n = `subheader`   v = `Today, SAP News`

                    )->shut(
                )->shut(
                )->open( `GenericTile`
                    )->a( n = `backgroundImage` v = |{ img }NewsImage2.png|
                    )->a( n = `frameType`       v = `TwoByOne`
                    )->a( n = `state`           v = `Failed`
                    )->open( `TileContent`
                        )->a( n = `footer` v = `August 21, 2016`
                        )->leaf( `NewsContent`
                            )->a( n = `contentText` v = `SAP Unveils Powerful New Player Comparision Tool Exclusively on NFL.com`
                            )->a( n = `subheader`   v = `Today, SAP News`

                    )->shut(
                )->shut(
            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `PRESS_ONE`.
        client->message_toast_display( `The generic tile one pressed.` ).
      WHEN `PRESS_TWO`.
        client->message_toast_display( `The generic tile two pressed.` ).
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
