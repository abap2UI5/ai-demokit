" @keywords cssgrid sap.ui.layout.cssgrid css grid autoflow html togglebutton panel overflowtoolbar title radiobuttongroup radiobutton
" @summary Example of setting the gridAutoFlow property.
CLASS z2ui5_cl_smpc_app_145 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA selected_index TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_145 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " the original's onRadioButtonSelected switches the CSSGrid gridAutoFlow per
    " selected index in JS; rebuilt on the client as a two-way bound
    " selectedIndex plus the same switch as a gridAutoFlow expression binding -
    " no round-trip. The Reveal Grid ToggleButton loses its press (see sidecar)
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:grid` v = `sap.ui.layout.cssgrid`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        " the sample's own css/main.css - without it the ten demoBox tiles render as bare text instead of the blue rounded boxes the sample is a picture of
        " \{ \} escaped: the XMLView parser reads an unescaped brace as a binding
        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.sapMFlexBox.demoBox\{border-radius:10px;background-color:#427cac;text-align:center\}` &&
                                    `.demoBox .sapMText\{color:#fff\}</style>`

        )->tag( `ToggleButton`
            )->a( n = `id`    v = `revealGrid`
            )->a( n = `text`  v = `Reveal Grid`
            )->a( n = `class` v = `sapUiSmallMargin`

        )->ele( `Panel`
            )->a( n = `width`  v = `100%`
            )->a( n = `height` v = `100%`

            )->ele( `headerToolbar`
                )->ele( `OverflowToolbar`
                    )->a( n = `height` v = `3rem`
                    )->tag( `Title`
                        )->a( n = `text` v = `gridAutoFlow property example`

                )->end(
            )->end(

            )->ele( `RadioButtonGroup`
                )->a( n = `class`         v = `sapUiSmallMargin`
                )->a( n = `selectedIndex` v = client->_bind( selected_index )
                )->tag( `RadioButton`
                    )->a( n = `text` v = `Column - Vertical placement in columns`
                )->tag( `RadioButton`
                    )->a( n = `text` v = `ColumnDense - Vertical placement in columns and filling empty spaces`
                )->tag( `RadioButton`
                    )->a( n = `text` v = `Row - Horizontal placement in rows`
                )->tag( `RadioButton`
                    )->a( n = `text` v = `RowDense - Horizontal placement in rows and filling empty spaces`

            )->end(

            )->ele( n = `CSSGrid` ns = `grid`
                )->a( n = `id`                  v = `grid1`
                )->a( n = `gridAutoFlow`        v = |\{= ${ client->_bind( selected_index ) } === 0 ? 'Column'| &&
                                                    | : (${ client->_bind( selected_index ) } === 1 ? 'ColumnDense'| &&
                                                    | : (${ client->_bind( selected_index ) } === 2 ? 'Row' : 'RowDense')) \}|
                )->a( n = `gridTemplateColumns` v = `repeat(7, 1fr)`
                )->a( n = `gridTemplateRows`    v = `repeat(2, 5rem)`
                )->a( n = `gridAutoRows`        v = `5rem`
                )->a( n = `gridAutoColumns`     v = `1fr`
                )->a( n = `gridGap`             v = `0.5rem`

                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`
                    )->ele( `layoutData`
                        )->tag( n = `GridItemLayoutData` ns = `grid`
                            )->a( n = `gridRow` v = `span 2`

                    )->end(
                    )->tag( `Text`
                        )->a( n = `text`     v = `One (2 rows)`
                        )->a( n = `wrapping` v = `true`

                )->end(
                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`
                    )->tag( `Text`
                        )->a( n = `text`     v = `Two`
                        )->a( n = `wrapping` v = `true`

                )->end(
                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`
                    )->ele( `layoutData`
                        )->tag( n = `GridItemLayoutData` ns = `grid`
                            )->a( n = `gridRow` v = `span 2`

                    )->end(
                    )->tag( `Text`
                        )->a( n = `text`     v = `Three (2 rows)`
                        )->a( n = `wrapping` v = `true`

                )->end(
                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`
                    )->ele( `layoutData`
                        )->tag( n = `GridItemLayoutData` ns = `grid`
                            )->a( n = `gridColumn` v = `span 2`

                    )->end(
                    )->tag( `Text`
                        )->a( n = `text`     v = `Four (2 columns)`
                        )->a( n = `wrapping` v = `true`

                )->end(
                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`
                    )->tag( `Text`
                        )->a( n = `text`     v = `Five`
                        )->a( n = `wrapping` v = `true`

                )->end(
                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`
                    )->ele( `layoutData`
                        )->tag( n = `GridItemLayoutData` ns = `grid`
                            )->a( n = `gridColumn` v = `span 2`

                    )->end(
                    )->tag( `Text`
                        )->a( n = `text`     v = `Six (2 columns)`
                        )->a( n = `wrapping` v = `true`

                )->end(
                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`
                    )->tag( `Text`
                        )->a( n = `text`     v = `Seven`
                        )->a( n = `wrapping` v = `true`

                )->end(
                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`
                    )->tag( `Text`
                        )->a( n = `text`     v = `Eight`
                        )->a( n = `wrapping` v = `true`

                )->end(
                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`
                    )->tag( `Text`
                        )->a( n = `text`     v = `Nine`
                        )->a( n = `wrapping` v = `true`

                )->end(
                )->ele( `VBox`
                    )->a( n = `class` v = `demoBox`
                    )->tag( `Text`
                        )->a( n = `text`     v = `Ten`
                        )->a( n = `wrapping` v = `true` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the original's gridAutoFlow="Column" is the first radio button
    selected_index = 0.

  ENDMETHOD.

ENDCLASS.
