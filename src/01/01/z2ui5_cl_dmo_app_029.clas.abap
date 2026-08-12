CLASS z2ui5_cl_dmo_app_029 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA selected_key TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_029 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`

        )->open( `Toolbar`
            )->leaf( `Label`
                )->a( n = `text` v = `Scroll options`

            " selectedKey bound two-way (original: literal "1"); scrollStepByItem is a
            " pure function of it (px -> 0, else the number), so the change round-trip
            " is dropped in favour of the expression binding below
            )->open( `Select`
                )->a( n = `selectedKey` v = client->_bind( selected_key )

                )->leaf( n = `Item` ns = `core`
                    )->a( n = `text` v = `1 item`
                    )->a( n = `key`  v = `1`
                )->leaf( n = `Item` ns = `core`
                    )->a( n = `text` v = `2 items`
                    )->a( n = `key`  v = `2`
                )->leaf( n = `Item` ns = `core`
                    )->a( n = `text` v = `3 items`
                    )->a( n = `key`  v = `3`
                )->leaf( n = `Item` ns = `core`
                    )->a( n = `text` v = `200px`
                    )->a( n = `key`  v = `px`

            )->shut(
        )->shut(
        )->open( `HeaderContainer`
            )->a( n = `scrollStep`       v = `200`
            )->a( n = `id`               v = `container1`
            " the controller's setScrollStepByItem(0 | Number(key)) expressed as an
            " expression binding over the two-way selectedKey - no round-trip
            )->a( n = `scrollStepByItem` v = |\{= ${ client->_bind( selected_key ) } === 'px' ? 0 : +${ client->_bind( selected_key ) } \}|

            )->leaf( `FeedContent`
                )->a( n = `contentText` v = `@@notify Great outcome of the Presentation today. The new functionality and the new design was well received.`
                )->a( n = `subheader`   v = `about 1 minute ago in Computer Market`
            )->leaf( `Input`
            )->leaf( `NumericContent`
                )->a( n = `scale`      v = `M`
                )->a( n = `value`      v = `1.75`
                )->a( n = `valueColor` v = `Good`
                )->a( n = `indicator`  v = `Up`
                )->a( n = `press`      v = client->follow_up_action( val   = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Fire press` ) ) )
            )->leaf( `NumericContent`
                )->a( n = `scale`      v = `M`
                )->a( n = `value`      v = `0.57`
                )->a( n = `valueColor` v = `Error`
                )->a( n = `indicator`  v = `Down`
                )->a( n = `press`      v = client->follow_up_action( val   = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Fire press` ) ) )
            )->leaf( `NumericContent`
                )->a( n = `value` v = `1762`
                )->a( n = `icon`  v = `sap-icon://line-charts`
            )->leaf( `NumericContent`
                )->a( n = `value` v = `1762`
                )->a( n = `icon`  v = `sap-icon://area-chart`
            )->leaf( `NumericContent`
                )->a( n = `scale`      v = `M`
                )->a( n = `value`      v = `1.04`
                )->a( n = `valueColor` v = `Neutral`
                )->a( n = `indicator`  v = `Up`
                )->a( n = `press`      v = client->follow_up_action( val   = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Fire press` ) ) )
            )->leaf( `NumericContent`
                )->a( n = `scale`      v = `M`
                )->a( n = `value`      v = `3.65`
                )->a( n = `valueColor` v = `Good`
                )->a( n = `indicator`  v = `Up`
                )->a( n = `press`      v = client->follow_up_action( val   = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Fire press` ) ) )
            )->leaf( `NumericContent`
                )->a( n = `value` v = `1762`
                )->a( n = `icon`  v = `sap-icon://bar-chart`
            )->leaf( `NumericContent`
                )->a( n = `scale`      v = `M`
                )->a( n = `value`      v = `0.73`
                )->a( n = `valueColor` v = `Error`
                )->a( n = `indicator`  v = `Down`
                )->a( n = `press`      v = client->follow_up_action( val   = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Fire press` ) ) )

        )->shut(
        )->open( `HeaderContainer`
            )->a( n = `id`               v = `container2`
            )->a( n = `scrollStep`       v = `200`
            " same scrollStepByItem expression binding as on container1
            )->a( n = `scrollStepByItem` v = |\{= ${ client->_bind( selected_key ) } === 'px' ? 0 : +${ client->_bind( selected_key ) } \}|

            )->open( `TileContent`
                )->a( n = `unit`   v = `EUR`
                )->a( n = `footer` v = `Current Quarter`

                )->open( `content`
                    )->leaf( `NumericContent`
                        )->a( n = `value`      v = `1.96`
                        )->a( n = `valueColor` v = `Error`
                        )->a( n = `indicator`  v = `Down`
                        )->a( n = `press`      v = client->follow_up_action( val   = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Fire press` ) ) )

                )->shut(
            )->shut(
            )->open( `TileContent`
                )->a( n = `footer` v = `Leave Requests`

                )->open( `content`
                    )->leaf( `NumericContent`
                        )->a( n = `value` v = `35`
                        )->a( n = `icon`  v = `sap-icon://travel-expense`

                )->shut(
            )->shut(
            )->open( `TileContent`
                )->a( n = `footer` v = `Hours since last Activity`

                )->open( `content`
                    )->leaf( `NumericContent`
                        )->a( n = `value` v = `9`
                        )->a( n = `icon`  v = `sap-icon://horizontal-bar-chart`

                )->shut(
            )->shut(
            )->open( `TileContent`
                )->a( n = `unit`   v = `EUR`
                )->a( n = `footer` v = `Current Quarter`

                )->open( `content`
                    )->leaf( `NumericContent`
                        )->a( n = `scale`      v = `M`
                        )->a( n = `value`      v = `88`
                        )->a( n = `valueColor` v = `Good`
                        )->a( n = `indicator`  v = `Up`

                )->shut(
            )->shut(
            )->open( `TileContent`
                )->a( n = `unit`   v = `Unit`
                )->a( n = `footer` v = `Footer Text`

                )->open( `content`
                    )->leaf( `NumericContent`
                        )->a( n = `value` v = `1522`
                        )->a( n = `icon`  v = `sap-icon://bubble-chart` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    selected_key = `1`.

  ENDMETHOD.

ENDCLASS.
