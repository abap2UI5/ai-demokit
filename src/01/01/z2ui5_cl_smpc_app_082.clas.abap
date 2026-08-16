" @keywords slidetile slide tile sap.m sliding generic tiles generictile tilecontent newscontent
CLASS z2ui5_cl_smpc_app_082 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_082 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " the sample's images are served from the demo kit sample folder; resolved to absolute OpenUI5 URLs
    DATA(img) = `https://sdk.openui5.org/test-resources/sap/m/demokit/sample/SlideTile/images/`.

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`

        )->ele( n = `VerticalLayout` ns = `l`

            )->ele( `SlideTile`
                )->a( n = `class` v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
                )->ele( `GenericTile`
                    )->a( n = `backgroundImage` v = |{ img }NewsImage2.png|
                    )->a( n = `frameType`       v = `TwoByOne`
                    )->a( n = `press`           v = client->_event( `PRESS_ONE` )
                    )->ele( `TileContent`
                        )->a( n = `footer` v = `August 21, 2016`
                        )->tag( `NewsContent`
                            )->a( n = `contentText` v = `SAP Unveils Powerful New Player Comparision Tool Exclusively on NFL.com`
                            )->a( n = `subheader`   v = `Today, SAP News`

                    )->end(
                )->end(
                )->ele( `GenericTile`
                    )->a( n = `backgroundImage` v = |{ img }NewsImage1.png|
                    )->a( n = `frameType`       v = `TwoByOne`
                    )->a( n = `press`           v = client->_event( `PRESS_TWO` )
                    )->ele( `TileContent`
                        )->a( n = `footer` v = `August 21, 2016`
                        )->tag( `NewsContent`
                            )->a( n = `contentText` v = `Wind Map: Monitoring Real-Time and Forecasted Wind Conditions across the Globe`
                            )->a( n = `subheader`   v = `Today, SAP News`

                    )->end(
                )->end(
            )->end(

            )->ele( `SlideTile`
                )->a( n = `class`          v = `sapUiTinyMarginBegin sapUiTinyMarginTop`
                )->a( n = `transitionTime` v = `250`
                )->a( n = `displayTime`    v = `2500`
                )->ele( `GenericTile`
                    )->a( n = `backgroundImage` v = |{ img }NewsImage1.png|
                    )->a( n = `frameType`       v = `TwoByOne`
                    )->a( n = `press`           v = client->_event( `PRESS_ONE` )
                    )->ele( `TileContent`
                        )->a( n = `footer` v = `August 21, 2016`
                        )->tag( `NewsContent`
                            )->a( n = `contentText` v = `Wind Map: Monitoring Real-Time and Forecasted Wind Conditions across the Globe`
                            )->a( n = `subheader`   v = `Today, SAP News`

                    )->end(
                )->end(
                )->ele( `GenericTile`
                    )->a( n = `backgroundImage` v = |{ img }NewsImage2.png|
                    )->a( n = `frameType`       v = `TwoByOne`
                    )->a( n = `state`           v = `Failed`
                    )->ele( `TileContent`
                        )->a( n = `footer` v = `August 21, 2016`
                        )->tag( `NewsContent`
                            )->a( n = `contentText` v = `SAP Unveils Powerful New Player Comparision Tool Exclusively on NFL.com`
                            )->a( n = `subheader`   v = `Today, SAP News`

                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).
      WHEN `PRESS_ONE`.
        client->message_toast_display( `The generic tile one pressed.` ).
      WHEN `PRESS_TWO`.
        client->message_toast_display( `The generic tile two pressed.` ).
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
