" @keywords headercontainer header container sap.m provides toolbar label select item feedcontent input numericcontent
" @summary The Header Container with horizontal layout. It provides horizontal scrolling on mobile devices (tablet and phone). On a desktop, it provides scroll left and scroll right buttons.
CLASS z2ui5_cl_smpc_app_029 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA selected_key TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_029 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`

        )->ele( `Toolbar`
            )->tag( `Label`
                )->a( n = `text` v = `Scroll options`

            " selectedKey bound two-way (original: literal "1"); scrollStepByItem is a
            " pure function of it (px -> 0, else the number), so the change round-trip
            " is dropped in favour of the expression binding below
            )->ele( `Select`
                )->a( n = `selectedKey` v = client->_bind( selected_key )

                )->tag( n = `Item` ns = `core`
                    )->a( n = `text` v = `1 item`
                    )->a( n = `key`  v = `1`
                )->tag( n = `Item` ns = `core`
                    )->a( n = `text` v = `2 items`
                    )->a( n = `key`  v = `2`
                )->tag( n = `Item` ns = `core`
                    )->a( n = `text` v = `3 items`
                    )->a( n = `key`  v = `3`
                )->tag( n = `Item` ns = `core`
                    )->a( n = `text` v = `200px`
                    )->a( n = `key`  v = `px`

            )->end(
        )->end(
        )->ele( `HeaderContainer`
            )->a( n = `scrollStep`       v = `200`
            )->a( n = `id`               v = `container1`
            " the controller's setScrollStepByItem(0 | Number(key)) expressed as an
            " expression binding over the two-way selectedKey - no round-trip
            )->a( n = `scrollStepByItem` v = |\{= ${ client->_bind( selected_key ) } === 'px' ? 0 : +${ client->_bind( selected_key ) } \}|

            )->tag( `FeedContent`
                )->a( n = `contentText` v = `@@notify Great outcome of the Presentation today. The new functionality and the new design was well received.`
                )->a( n = `subheader`   v = `about 1 minute ago in Computer Market`
            )->tag( `Input`
            )->tag( `NumericContent`
                )->a( n = `scale`      v = `M`
                )->a( n = `value`      v = `1.75`
                )->a( n = `valueColor` v = `Good`
                )->a( n = `indicator`  v = `Up`
                )->a( n = `press`      v = client->follow_up_action( val   = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Fire press` ) ) )
            )->tag( `NumericContent`
                )->a( n = `scale`      v = `M`
                )->a( n = `value`      v = `0.57`
                )->a( n = `valueColor` v = `Error`
                )->a( n = `indicator`  v = `Down`
                )->a( n = `press`      v = client->follow_up_action( val   = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Fire press` ) ) )
            )->tag( `NumericContent`
                )->a( n = `value` v = `1762`
                )->a( n = `icon`  v = `sap-icon://line-charts`
            )->tag( `NumericContent`
                )->a( n = `value` v = `1762`
                )->a( n = `icon`  v = `sap-icon://area-chart`
            )->tag( `NumericContent`
                )->a( n = `scale`      v = `M`
                )->a( n = `value`      v = `1.04`
                )->a( n = `valueColor` v = `Neutral`
                )->a( n = `indicator`  v = `Up`
                )->a( n = `press`      v = client->follow_up_action( val   = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Fire press` ) ) )
            )->tag( `NumericContent`
                )->a( n = `scale`      v = `M`
                )->a( n = `value`      v = `3.65`
                )->a( n = `valueColor` v = `Good`
                )->a( n = `indicator`  v = `Up`
                )->a( n = `press`      v = client->follow_up_action( val   = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Fire press` ) ) )
            )->tag( `NumericContent`
                )->a( n = `value` v = `1762`
                )->a( n = `icon`  v = `sap-icon://bar-chart`
            )->tag( `NumericContent`
                )->a( n = `scale`      v = `M`
                )->a( n = `value`      v = `0.73`
                )->a( n = `valueColor` v = `Error`
                )->a( n = `indicator`  v = `Down`
                )->a( n = `press`      v = client->follow_up_action( val   = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Fire press` ) ) )

        )->end(
        )->ele( `HeaderContainer`
            )->a( n = `id`               v = `container2`
            )->a( n = `scrollStep`       v = `200`
            " same scrollStepByItem expression binding as on container1
            )->a( n = `scrollStepByItem` v = |\{= ${ client->_bind( selected_key ) } === 'px' ? 0 : +${ client->_bind( selected_key ) } \}|

            )->ele( `TileContent`
                )->a( n = `unit`   v = `EUR`
                )->a( n = `footer` v = `Current Quarter`

                )->ele( `content`
                    )->tag( `NumericContent`
                        )->a( n = `value`      v = `1.96`
                        )->a( n = `valueColor` v = `Error`
                        )->a( n = `indicator`  v = `Down`
                        )->a( n = `press`      v = client->follow_up_action( val   = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Fire press` ) ) )

                )->end(
            )->end(
            )->ele( `TileContent`
                )->a( n = `footer` v = `Leave Requests`

                )->ele( `content`
                    )->tag( `NumericContent`
                        )->a( n = `value` v = `35`
                        )->a( n = `icon`  v = `sap-icon://travel-expense`

                )->end(
            )->end(
            )->ele( `TileContent`
                )->a( n = `footer` v = `Hours since last Activity`

                )->ele( `content`
                    )->tag( `NumericContent`
                        )->a( n = `value` v = `9`
                        )->a( n = `icon`  v = `sap-icon://horizontal-bar-chart`

                )->end(
            )->end(
            )->ele( `TileContent`
                )->a( n = `unit`   v = `EUR`
                )->a( n = `footer` v = `Current Quarter`

                )->ele( `content`
                    )->tag( `NumericContent`
                        )->a( n = `scale`      v = `M`
                        )->a( n = `value`      v = `88`
                        )->a( n = `valueColor` v = `Good`
                        )->a( n = `indicator`  v = `Up`

                )->end(
            )->end(
            )->ele( `TileContent`
                )->a( n = `unit`   v = `Unit`
                )->a( n = `footer` v = `Footer Text`

                )->ele( `content`
                    )->tag( `NumericContent`
                        )->a( n = `value` v = `1522`
                        )->a( n = `icon`  v = `sap-icon://bubble-chart` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    selected_key = `1`.

  ENDMETHOD.

ENDCLASS.
