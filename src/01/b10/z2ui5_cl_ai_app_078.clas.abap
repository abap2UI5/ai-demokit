CLASS z2ui5_cl_ai_app_078 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_078 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`

        )->open( n = `Grid` ns = `l`
            )->a( n = `containerQuery` v = `true`
            )->a( n = `class`          v = `sapUiSmallMarginTop`

            )->open( `TileContent`
                )->a( n = `footer` v = `Current Quarter`
                )->a( n = `unit`   v = `EUR`
                )->a( n = `class`  v = `sapUiSmallMargin`
                )->leaf( `NumericContent`
                    )->a( n = `scale`      v = `M`
                    )->a( n = `value`      v = `1.96`
                    )->a( n = `valueColor` v = `Error`
                    )->a( n = `indicator`  v = `Up`

            )->shut(
            )->open( `TileContent`
                )->a( n = `footer` v = `Leave Requests`
                )->a( n = `class`  v = `sapUiSmallMargin`
                )->leaf( `NumericContent`
                    )->a( n = `value` v = `3`
                    )->a( n = `icon`  v = `sap-icon://travel-expense`

            )->shut(
            )->open( `TileContent`
                )->a( n = `footer` v = `Hours since last Activity`
                )->a( n = `class`  v = `sapUiSmallMargin`
                )->leaf( `NumericContent`
                    )->a( n = `value` v = `9`
                    )->a( n = `icon`  v = `sap-icon://locked`

            )->shut(
            )->open( `TileContent`
                )->a( n = `footer` v = `New Notifications`
                )->a( n = `class`  v = `sapUiSmallMargin`
                )->leaf( `FeedContent`
                    )->a( n = `contentText` v = `@@notify Great outcome of the Presentation today. The new functionality and the new design was well received.`
                    )->a( n = `subheader`   v = `about 1 minute ago in Computer Market`
                    )->a( n = `value`       v = `132`

            )->shut(
            )->open( `TileContent`
                )->a( n = `footer` v = `August 21, 2013`
                )->a( n = `class`  v = `sapUiSmallMargin`
                )->leaf( `NewsContent`
                    )->a( n = `contentText` v = `SAP Unveils Powerful New Player Comparison Tool Exclusively on NFL.com`
                    )->a( n = `subheader`   v = `SAP News`

            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
