CLASS z2ui5_cl_ai_app_550 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA selected_key TYPE string.
    DATA scroll_step_by_item TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS model_init.
    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_550 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    selected_key = `1`.
    scroll_step_by_item = 0.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`

        )->open( `Toolbar`
            )->leaf( `Label`
                )->a( n = `text` v = `Scroll options`

            " selectedKey bound two-way (original: literal "1") so the change handler can read the key
            )->open( `Select`
                )->a( n = `selectedKey` v = client->_bind( selected_key )
                )->a( n = `change`      v = client->_event( `SCROLL_CHANGED` )

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
            " the controller's setScrollStepByItem call, expressed as a two-way property binding
            )->a( n = `scrollStepByItem` v = client->_bind( scroll_step_by_item )

            )->leaf( `FeedContent`
                )->a( n = `contentText` v = `@@notify Great outcome of the Presentation today. The new functionality and the new design was well received.`
                )->a( n = `subheader`   v = `about 1 minute ago in Computer Market`
            )->leaf( `Input`
            )->leaf( `NumericContent`
                )->a( n = `scale`      v = `M`
                )->a( n = `value`      v = `1.75`
                )->a( n = `valueColor` v = `Good`
                )->a( n = `indicator`  v = `Up`
                )->a( n = `press`      v = client->_event( `PRESS` )
            )->leaf( `NumericContent`
                )->a( n = `scale`      v = `M`
                )->a( n = `value`      v = `0.57`
                )->a( n = `valueColor` v = `Error`
                )->a( n = `indicator`  v = `Down`
                )->a( n = `press`      v = client->_event( `PRESS` )
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
                )->a( n = `press`      v = client->_event( `PRESS` )
            )->leaf( `NumericContent`
                )->a( n = `scale`      v = `M`
                )->a( n = `value`      v = `3.65`
                )->a( n = `valueColor` v = `Good`
                )->a( n = `indicator`  v = `Up`
                )->a( n = `press`      v = client->_event( `PRESS` )
            )->leaf( `NumericContent`
                )->a( n = `value` v = `1762`
                )->a( n = `icon`  v = `sap-icon://bar-chart`
            )->leaf( `NumericContent`
                )->a( n = `scale`      v = `M`
                )->a( n = `value`      v = `0.73`
                )->a( n = `valueColor` v = `Error`
                )->a( n = `indicator`  v = `Down`
                )->a( n = `press`      v = client->_event( `PRESS` )

        )->shut(
        )->open( `HeaderContainer`
            )->a( n = `id`               v = `container2`
            )->a( n = `scrollStep`       v = `200`
            " same two-way scrollStepByItem binding as on container1
            )->a( n = `scrollStepByItem` v = client->_bind( scroll_step_by_item )

            )->open( `TileContent`
                )->a( n = `unit`   v = `EUR`
                )->a( n = `footer` v = `Current Quarter`

                )->open( `content`
                    )->leaf( `NumericContent`
                        )->a( n = `value`      v = `1.96`
                        )->a( n = `valueColor` v = `Error`
                        )->a( n = `indicator`  v = `Down`
                        )->a( n = `press`      v = client->_event( `PRESS` )

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


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `PRESS`.
        client->message_toast_display( `Fire press` ).

      WHEN `SCROLL_CHANGED`.
        IF selected_key = `px`.
          scroll_step_by_item = 0.
        ELSE.
          scroll_step_by_item = selected_key.
        ENDIF.
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
