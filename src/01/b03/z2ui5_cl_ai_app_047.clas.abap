CLASS z2ui5_cl_ai_app_047 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA selected_item_text TYPE string.
    DATA selected_key       TYPE string VALUE `one`.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_047 IMPLEMENTATION.

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

    view->open( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `Page`
            )->a( n = `showHeader` v = `false`
            )->a( n = `class`      v = `sapUiContentPadding`

            )->open( `subHeader`
                )->open( `OverflowToolbar`
                    )->leaf( `ToolbarSpacer`

                    )->open( `SegmentedButton`
                        )->a( n = `selectedKey` v = `kids`

                        )->open( `items`
                            )->leaf( `SegmentedButtonItem`
                                )->a( n = `text` v = `Kids`
                                )->a( n = `key`  v = `kids`
                            )->leaf( `SegmentedButtonItem`
                                )->a( n = `text` v = `Adults`
                            )->leaf( `SegmentedButtonItem`
                                )->a( n = `text` v = `Seniors`

                        )->shut(
                    )->shut(
                    )->leaf( `ToolbarSpacer`

                )->shut(
            )->shut(

            )->open( `VBox`
                )->a( n = `width` v = `100%`

                )->open( `SegmentedButton`
                    )->a( n = `selectedKey` v = `satellite`
                    )->a( n = `class`       v = `sapUiSmallMarginBottom`

                    )->open( `items`
                        )->leaf( `SegmentedButtonItem`
                            )->a( n = `text` v = `Map`
                        )->leaf( `SegmentedButtonItem`
                            )->a( n = `text` v = `Satellite`
                            )->a( n = `key`  v = `satellite`
                        )->leaf( `SegmentedButtonItem`
                            )->a( n = `text` v = `Hybrid`

                    )->shut(
                )->shut(
                )->open( `SegmentedButton`
                    )->a( n = `selectedKey` v = `competitor`
                    )->a( n = `class`       v = `sapUiSmallMarginBottom`

                    )->open( `items`
                        )->leaf( `SegmentedButtonItem`
                            )->a( n = `icon` v = `sap-icon://taxi`
                        )->leaf( `SegmentedButtonItem`
                            )->a( n = `icon` v = `sap-icon://lab`
                        )->leaf( `SegmentedButtonItem`
                            )->a( n = `icon` v = `sap-icon://competitor`
                            )->a( n = `key`  v = `competitor`

                    )->shut(
                )->shut(
                )->open( `SegmentedButton`
                    )->a( n = `class` v = `sapUiSmallMarginBottom`

                    )->open( `items`
                        )->leaf( `SegmentedButtonItem`
                            )->a( n = `text` v = `Selected`
                        )->leaf( `SegmentedButtonItem`
                            )->a( n = `text` v = `Enabled`
                        )->leaf( `SegmentedButtonItem`
                            )->a( n = `text`    v = `Disabled`
                            )->a( n = `enabled` v = `false`

                    )->shut(
                )->shut(
                )->leaf( `Label`
                    )->a( n = `text` v = `Fire selectionChange event`

                " selectedKey two-way bound + item keys (port addition) - selection read server-side without a private event path
                )->open( `SegmentedButton`
                    )->a( n = `id`              v = `SB1`
                    )->a( n = `selectedKey`     v = client->_bind( selected_key )
                    )->a( n = `selectionChange` v = client->_event( `SELECTION_CHANGE` )

                    )->open( `items`
                        )->leaf( `SegmentedButtonItem`
                            )->a( n = `key`  v = `one`
                            )->a( n = `text` v = `One`
                        )->leaf( `SegmentedButtonItem`
                            )->a( n = `key`  v = `two`
                            )->a( n = `text` v = `Two`
                        )->leaf( `SegmentedButtonItem`
                            )->a( n = `key`  v = `three`
                            )->a( n = `text` v = `Three`

                    )->shut(
                )->shut(
                )->leaf( `Text`
                    )->a( n = `id`   v = `selectedItemPreview`
                    )->a( n = `text` v = client->_bind( selected_item_text )

            )->shut(

            )->open( `footer`
                )->open( `OverflowToolbar`
                    )->leaf( `ToolbarSpacer`

                    )->open( `SegmentedButton`
                        )->a( n = `selectedKey` v = `small`

                        )->open( `items`
                            )->leaf( `SegmentedButtonItem`
                                )->a( n = `text` v = `Small`
                                )->a( n = `key`  v = `small`
                            )->leaf( `SegmentedButtonItem`
                                )->a( n = `text` v = `Medium`
                            )->leaf( `SegmentedButtonItem`
                                )->a( n = `text` v = `Large`

                        )->shut(
                    )->shut(
                    )->leaf( `ToolbarSpacer`

                )->shut(
            )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `SELECTION_CHANGE`.
        " map the two-way bound key back to the item text
        DATA(text) = SWITCH string( selected_key
                       WHEN `one`   THEN `One`
                       WHEN `two`   THEN `Two`
                       WHEN `three` THEN `Three` ).
        client->message_toast_display( |oEvent.getParameter('item').getText(): '{ text }' selected| ).
        selected_item_text = |getSelectedItem(): { text }|.
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
