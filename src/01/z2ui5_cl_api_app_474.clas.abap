"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.SegmentedButton - SegmentedButton
"! https://sdk.openui5.org/entity/sap.m.SegmentedButton/sample/sap.m.sample.SegmentedButton
CLASS z2ui5_cl_api_app_474 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA selected_item_text TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_474 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->attr( n = `height`    v = `100%`
        )->attr( n = `xmlns`     v = `sap.m`
        )->attr( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `Page`
            )->attr( n = `showHeader` v = `false`
            )->attr( n = `class`      v = `sapUiContentPadding`

            )->open( `subHeader`
                )->open( `OverflowToolbar`
                    )->leaf( `ToolbarSpacer`

                    )->open( `SegmentedButton`
                        )->attr( n = `selectedKey` v = `kids`

                        )->open( `items`
                            )->leaf( `SegmentedButtonItem`
                                )->attr( n = `text` v = `Kids`
                                )->attr( n = `key`  v = `kids`
                            )->leaf( `SegmentedButtonItem`
                                )->attr( n = `text` v = `Adults`
                            )->leaf( `SegmentedButtonItem`
                                )->attr( n = `text` v = `Seniors`

                        )->shut(
                    )->shut(
                    )->leaf( `ToolbarSpacer`

                )->shut(
            )->shut(

            )->open( `VBox`
                )->attr( n = `width` v = `100%`

                )->open( `SegmentedButton`
                    )->attr( n = `selectedKey` v = `satellite`
                    )->attr( n = `class`       v = `sapUiSmallMarginBottom`

                    )->open( `items`
                        )->leaf( `SegmentedButtonItem`
                            )->attr( n = `text` v = `Map`
                        )->leaf( `SegmentedButtonItem`
                            )->attr( n = `text` v = `Satellite`
                            )->attr( n = `key`  v = `satellite`
                        )->leaf( `SegmentedButtonItem`
                            )->attr( n = `text` v = `Hybrid`

                    )->shut(
                )->shut(
                )->open( `SegmentedButton`
                    )->attr( n = `selectedKey` v = `competitor`
                    )->attr( n = `class`       v = `sapUiSmallMarginBottom`

                    )->open( `items`
                        )->leaf( `SegmentedButtonItem`
                            )->attr( n = `icon` v = `sap-icon://taxi`
                        )->leaf( `SegmentedButtonItem`
                            )->attr( n = `icon` v = `sap-icon://lab`
                        )->leaf( `SegmentedButtonItem`
                            )->attr( n = `icon` v = `sap-icon://competitor`
                            )->attr( n = `key`  v = `competitor`

                    )->shut(
                )->shut(
                )->open( `SegmentedButton`
                    )->attr( n = `class` v = `sapUiSmallMarginBottom`

                    )->open( `items`
                        )->leaf( `SegmentedButtonItem`
                            )->attr( n = `text` v = `Selected`
                        )->leaf( `SegmentedButtonItem`
                            )->attr( n = `text` v = `Enabled`
                        )->leaf( `SegmentedButtonItem`
                            )->attr( n = `text`    v = `Disabled`
                            )->attr( n = `enabled` v = `false`

                    )->shut(
                )->shut(
                )->leaf( `Label`
                    )->attr( n = `text` v = `Fire selectionChange event`

                )->open( `SegmentedButton`
                    )->attr( n = `selectionChange` v = client->_event( val   = `SELECTION_CHANGE`
                                                                       t_arg = VALUE #( ( `${$parameters>/item/mProperties/text}` ) ) )

                    )->open( `items`
                        )->leaf( `SegmentedButtonItem`
                            )->attr( n = `text` v = `One`
                        )->leaf( `SegmentedButtonItem`
                            )->attr( n = `text` v = `Two`
                        )->leaf( `SegmentedButtonItem`
                            )->attr( n = `text` v = `Three`

                    )->shut(
                )->shut(
                )->leaf( `Text`
                    )->attr( n = `text` v = client->_bind( selected_item_text )

            )->shut(

            )->open( `footer`
                )->open( `OverflowToolbar`
                    )->leaf( `ToolbarSpacer`

                    )->open( `SegmentedButton`
                        )->attr( n = `selectedKey` v = `small`

                        )->open( `items`
                            )->leaf( `SegmentedButtonItem`
                                )->attr( n = `text` v = `Small`
                                )->attr( n = `key`  v = `small`
                            )->leaf( `SegmentedButtonItem`
                                )->attr( n = `text` v = `Medium`
                            )->leaf( `SegmentedButtonItem`
                                )->attr( n = `text` v = `Large`

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
        client->message_toast_display( |oEvent.getParameter('item').getText(): '{ client->get_event_arg( 1 ) }' selected| ).
        selected_item_text = |getSelectedItem(): { client->get_event_arg( 1 ) }|.
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
