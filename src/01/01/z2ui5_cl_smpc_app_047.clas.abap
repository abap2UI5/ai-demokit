" @keywords segmentedbutton segmented button sap.m allows user overflowtoolbar toolbarspacer segmentedbuttonitem vbox label text
CLASS z2ui5_cl_smpc_app_047 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_smpc_app_047 IMPLEMENTATION.

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

    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->ele( `Page`
            )->a( n = `showHeader` v = `false`
            )->a( n = `class`      v = `sapUiContentPadding`

            )->ele( `subHeader`
                )->ele( `OverflowToolbar`
                    )->tag( `ToolbarSpacer`

                    )->ele( `SegmentedButton`
                        )->a( n = `selectedKey` v = `kids`

                        )->ele( `items`
                            )->tag( `SegmentedButtonItem`
                                )->a( n = `text` v = `Kids`
                                )->a( n = `key`  v = `kids`
                            )->tag( `SegmentedButtonItem`
                                )->a( n = `text` v = `Adults`
                            )->tag( `SegmentedButtonItem`
                                )->a( n = `text` v = `Seniors`

                        )->end(
                    )->end(
                    )->tag( `ToolbarSpacer`

                )->end(
            )->end(

            )->ele( `VBox`
                )->a( n = `width` v = `100%`

                )->ele( `SegmentedButton`
                    )->a( n = `selectedKey` v = `satellite`
                    )->a( n = `class`       v = `sapUiSmallMarginBottom`

                    )->ele( `items`
                        )->tag( `SegmentedButtonItem`
                            )->a( n = `text` v = `Map`
                        )->tag( `SegmentedButtonItem`
                            )->a( n = `text` v = `Satellite`
                            )->a( n = `key`  v = `satellite`
                        )->tag( `SegmentedButtonItem`
                            )->a( n = `text` v = `Hybrid`

                    )->end(
                )->end(
                )->ele( `SegmentedButton`
                    )->a( n = `selectedKey` v = `competitor`
                    )->a( n = `class`       v = `sapUiSmallMarginBottom`

                    )->ele( `items`
                        )->tag( `SegmentedButtonItem`
                            )->a( n = `icon` v = `sap-icon://taxi`
                        )->tag( `SegmentedButtonItem`
                            )->a( n = `icon` v = `sap-icon://lab`
                        )->tag( `SegmentedButtonItem`
                            )->a( n = `icon` v = `sap-icon://competitor`
                            )->a( n = `key`  v = `competitor`

                    )->end(
                )->end(
                )->ele( `SegmentedButton`
                    )->a( n = `class` v = `sapUiSmallMarginBottom`

                    )->ele( `items`
                        )->tag( `SegmentedButtonItem`
                            )->a( n = `text` v = `Selected`
                        )->tag( `SegmentedButtonItem`
                            )->a( n = `text` v = `Enabled`
                        )->tag( `SegmentedButtonItem`
                            )->a( n = `text`    v = `Disabled`
                            )->a( n = `enabled` v = `false`

                    )->end(
                )->end(
                )->tag( `Label`
                    )->a( n = `text` v = `Fire selectionChange event`

                " selectedKey two-way bound + item keys (port addition) - selection read server-side without a private event path
                )->ele( `SegmentedButton`
                    )->a( n = `id`              v = `SB1`
                    )->a( n = `selectedKey`     v = client->_bind( selected_key )
                    )->a( n = `selectionChange` v = client->_event( `SELECTION_CHANGE` )

                    )->ele( `items`
                        )->tag( `SegmentedButtonItem`
                            )->a( n = `key`  v = `one`
                            )->a( n = `text` v = `One`
                        )->tag( `SegmentedButtonItem`
                            )->a( n = `key`  v = `two`
                            )->a( n = `text` v = `Two`
                        )->tag( `SegmentedButtonItem`
                            )->a( n = `key`  v = `three`
                            )->a( n = `text` v = `Three`

                    )->end(
                )->end(
                )->tag( `Text`
                    )->a( n = `id`   v = `selectedItemPreview`
                    )->a( n = `text` v = client->_bind( selected_item_text )

            )->end(

            )->ele( `footer`
                )->ele( `OverflowToolbar`
                    )->tag( `ToolbarSpacer`

                    )->ele( `SegmentedButton`
                        )->a( n = `selectedKey` v = `small`

                        )->ele( `items`
                            )->tag( `SegmentedButtonItem`
                                )->a( n = `text` v = `Small`
                                )->a( n = `key`  v = `small`
                            )->tag( `SegmentedButtonItem`
                                )->a( n = `text` v = `Medium`
                            )->tag( `SegmentedButtonItem`
                                )->a( n = `text` v = `Large`

                        )->end(
                    )->end(
                    )->tag( `ToolbarSpacer`

                )->end(
            )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `SELECTION_CHANGE`.
      " map the two-way bound key back to the item text
      DATA(text) = SWITCH string( selected_key
                     WHEN `one`   THEN `One`
                     WHEN `two`   THEN `Two`
                     WHEN `three` THEN `Three` ).
      client->message_toast_display( |oEvent.getParameter('item').getText(): '{ text }' selected| ).
      selected_item_text = |getSelectedItem(): { text }|.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
