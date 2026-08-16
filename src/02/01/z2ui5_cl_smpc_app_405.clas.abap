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
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:c`   v = `sap.ui.core`
        )->a( n = `xmlns:t`   v = `sap.ui.table`
        )->a( n = `xmlns:trm` v = `sap.ui.table.rowmodes`
        )->a( n = `xmlns:f`   v = `sap.ui.layout.form`
        )->a( n = `height`    v = `100%`

        )->ele( `Page`
            )->a( n = `enableScrolling` v = `true`
            )->a( n = `title`           v = `Title`
            )->a( n = `class`           v = `sapUiResponsivePadding--header sapUiResponsivePadding--footer`

            )->ele( `content`
                )->ele( `VBox`
                    )->a( n = `fitContainer` v = `true`

                    )->ele( n = `SimpleForm` ns = `f`
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

                        )->ele( n = `content` ns = `f`
                            )->tag( n = `Title` ns = `c`
                                )->a( n = `text` v = `Office`
                            )->tag( `Label`
                                )->a( n = `text` v = `Name`
                            )->tag( `Text`
                                )->a( n = `text` v = `Red Point Stores`
                            )->tag( `Label`
                                )->a( n = `text` v = `Street/No.`
                            )->tag( `Text`
                                )->a( n = `text` v = `Main St 1618`
                            )->tag( `Label`
                                )->a( n = `text` v = `ZIP Code/City`
                            )->tag( `Text`
                                )->a( n = `text` v = `31415 Maintown`
                            )->tag( `Label`
                                )->a( n = `text` v = `Country`
                            )->tag( `Text`
                                )->a( n = `text` v = `Germany`
                            )->tag( n = `Title` ns = `c`
                                )->a( n = `text` v = `Online`
                            )->tag( `Label`
                                )->a( n = `text` v = `Web`
                            )->tag( `Text`
                                )->a( n = `text` v = `http://www.sap.com`
                            )->tag( `Label`
                                )->a( n = `text` v = `Twitter`
                            )->tag( `Text`
                                )->a( n = `text` v = `@sap`

                        )->end(

                        )->ele( n = `layoutData` ns = `f`
                            )->tag( `FlexItemData`
                                )->a( n = `shrinkFactor`     v = `0`
                                )->a( n = `backgroundDesign` v = `Solid`
                                )->a( n = `styleClass`       v = `sapContrastPlus`

                        )->end(
                    )->end(

                    )->ele( n = `AnalyticalTable` ns = `t`
                        )->a( n = `selectionMode` v = `MultiToggle`

                        )->ele( n = `rowMode` ns = `t`
                            " sap.ui.table rowmodes.Auto (@since 1.119) - kept 1:1, see the POST_171 deviation
                            )->tag( n = `Auto` ns = `trm`
                                )->a( n = `rowContentHeight` v = `32`

                        )->end(

                        )->ele( n = `extension` ns = `t`
                            )->ele( `OverflowToolbar`
                                )->tag( `Title`
                                    )->a( n = `text` v = `Title Bar Here`
                                )->tag( `ToolbarSpacer`
                                )->tag( `SearchField`
                                    )->a( n = `width` v = `12rem`

                                )->ele( `SegmentedButton`
                                    )->ele( `items`
                                        )->tag( `SegmentedButtonItem`
                                            )->a( n = `icon` v = `sap-icon://table-view`
                                        )->tag( `SegmentedButtonItem`
                                            )->a( n = `icon` v = `sap-icon://bar-chart`

                                    )->end(
                                )->end(

                                )->tag( `Button`
                                    )->a( n = `icon` v = `sap-icon://group-2`
                                    )->a( n = `type` v = `Transparent`
                                )->tag( `Button`
                                    )->a( n = `icon` v = `sap-icon://action-settings`
                                    )->a( n = `type` v = `Transparent`

                            )->end(
                        )->end(

                        )->ele( n = `columns` ns = `t`
                            )->tag( n = `AnalyticalColumn` ns = `t`
                            )->tag( n = `AnalyticalColumn` ns = `t`
                            )->tag( n = `AnalyticalColumn` ns = `t`

                        )->end(

                        )->ele( n = `layoutData` ns = `t`
                            )->tag( `FlexItemData`
                                )->a( n = `growFactor` v = `1`
                                )->a( n = `baseSize`   v = `0%`
                                )->a( n = `styleClass` v = `sapUiResponsiveContentPadding`

                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( `footer`
                )->ele( `OverflowToolbar`
                    )->ele( `content`
                        )->tag( `ToolbarSpacer`
                        )->tag( `Button`
                            )->a( n = `text` v = `Grouped View`
                        )->tag( `Button`
                            )->a( n = `text` v = `Classical Table` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
