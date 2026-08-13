CLASS z2ui5_cl_smpc_app_405 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_405 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:c`   v = `sap.ui.core`
        )->a( n = `xmlns:t`   v = `sap.ui.table`
        )->a( n = `xmlns:trm` v = `sap.ui.table.rowmodes`
        )->a( n = `xmlns:f`   v = `sap.ui.layout.form`
        )->a( n = `height`    v = `100%`

        )->open( `Page`
            )->a( n = `enableScrolling` v = `true`
            )->a( n = `title`           v = `Title`
            )->a( n = `class`           v = `sapUiResponsivePadding--header sapUiResponsivePadding--footer`

            )->open( `content`
                )->open( `VBox`
                    )->a( n = `fitContainer` v = `true`

                    )->open( n = `SimpleForm` ns = `f`
                        )->a( n = `id`         v = `SimpleFormDisplay480`
                        )->a( n = `editable`   v = `false`
                        )->a( n = `layout`     v = `ResponsiveGridLayout`
                        )->a( n = `title`      v = `Address`
                        )->a( n = `labelSpanL` v = `4`
                        )->a( n = `labelSpanM` v = `4`
                        )->a( n = `emptySpanL` v = `0`
                        )->a( n = `emptySpanM` v = `0`
                        )->a( n = `columnsL`   v = `2`
                        )->a( n = `columnsM`   v = `2`

                        )->open( n = `content` ns = `f`
                            )->leaf( n = `Title` ns = `c`
                                )->a( n = `text` v = `Office`
                            )->leaf( `Label`
                                )->a( n = `text` v = `Name`
                            )->leaf( `Text`
                                )->a( n = `text` v = `Red Point Stores`
                            )->leaf( `Label`
                                )->a( n = `text` v = `Street/No.`
                            )->leaf( `Text`
                                )->a( n = `text` v = `Main St 1618`
                            )->leaf( `Label`
                                )->a( n = `text` v = `ZIP Code/City`
                            )->leaf( `Text`
                                )->a( n = `text` v = `31415 Maintown`
                            )->leaf( `Label`
                                )->a( n = `text` v = `Country`
                            )->leaf( `Text`
                                )->a( n = `text` v = `Germany`
                            )->leaf( n = `Title` ns = `c`
                                )->a( n = `text` v = `Online`
                            )->leaf( `Label`
                                )->a( n = `text` v = `Web`
                            )->leaf( `Text`
                                )->a( n = `text` v = `http://www.sap.com`
                            )->leaf( `Label`
                                )->a( n = `text` v = `Twitter`
                            )->leaf( `Text`
                                )->a( n = `text` v = `@sap`

                        )->shut(

                        )->open( n = `layoutData` ns = `f`
                            )->leaf( `FlexItemData`
                                )->a( n = `shrinkFactor`     v = `0`
                                )->a( n = `backgroundDesign` v = `Solid`
                                )->a( n = `styleClass`       v = `sapContrastPlus`

                        )->shut(
                    )->shut(

                    )->open( n = `AnalyticalTable` ns = `t`
                        )->a( n = `selectionMode` v = `MultiToggle`

                        )->open( n = `rowMode` ns = `t`
                            " sap.ui.table rowmodes.Auto (@since 1.119) - kept 1:1, see the POST_171 deviation
                            )->leaf( n = `Auto` ns = `trm`
                                )->a( n = `rowContentHeight` v = `32`

                        )->shut(

                        )->open( n = `extension` ns = `t`
                            )->open( `OverflowToolbar`
                                )->leaf( `Title`
                                    )->a( n = `text` v = `Title Bar Here`
                                )->leaf( `ToolbarSpacer`
                                )->leaf( `SearchField`
                                    )->a( n = `width` v = `12rem`

                                )->open( `SegmentedButton`
                                    )->open( `items`
                                        )->leaf( `SegmentedButtonItem`
                                            )->a( n = `icon` v = `sap-icon://table-view`
                                        )->leaf( `SegmentedButtonItem`
                                            )->a( n = `icon` v = `sap-icon://bar-chart`

                                    )->shut(
                                )->shut(

                                )->leaf( `Button`
                                    )->a( n = `icon` v = `sap-icon://group-2`
                                    )->a( n = `type` v = `Transparent`
                                )->leaf( `Button`
                                    )->a( n = `icon` v = `sap-icon://action-settings`
                                    )->a( n = `type` v = `Transparent`

                            )->shut(
                        )->shut(

                        )->open( n = `columns` ns = `t`
                            )->leaf( n = `AnalyticalColumn` ns = `t`
                            )->leaf( n = `AnalyticalColumn` ns = `t`
                            )->leaf( n = `AnalyticalColumn` ns = `t`

                        )->shut(

                        )->open( n = `layoutData` ns = `t`
                            )->leaf( `FlexItemData`
                                )->a( n = `growFactor` v = `1`
                                )->a( n = `baseSize`   v = `0%`
                                )->a( n = `styleClass` v = `sapUiResponsiveContentPadding`

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(

            )->open( `footer`
                )->open( `OverflowToolbar`
                    )->open( `content`
                        )->leaf( `ToolbarSpacer`
                        )->leaf( `Button`
                            )->a( n = `text` v = `Grouped View`
                        )->leaf( `Button`
                            )->a( n = `text` v = `Classical Table` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
