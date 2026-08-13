CLASS z2ui5_cl_smpc_app_349 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " the width Slider - the Panel's width is an expression binding over it
    DATA slider_value TYPE i.

    " the two template ComboBoxes: each one is two-way bound and the CSSGrid
    " binds the matching property to the SAME field, so picking a template
    " reaches the grid without the controller's setGridTemplateRows/-Columns
    DATA rowstemplate    TYPE string.
    DATA columnstemplate TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_349 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " the gridTemplateRows / gridTemplateColumns demo: the Panel width follows
    " the Slider through an expression binding, and each ComboBox value is
    " bound to the same field the CSSGrid binds, so both controller handlers
    " become plain bindings. css/main.css is injected as a core:HTML style leaf.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:grid` v = `sap.ui.layout.cssgrid`
        )->a( n = `xmlns:form` v = `sap.ui.layout.form`

        )->leaf( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.sapMFlexBox.demoBox\{border-radius:10px;background-color:#427cac;text-align:center\}` &&
                                    `.demoBox .sapMTitle,.demoBox .sapMText\{color:#fff\}</style>`

        )->leaf( `Slider`
            )->a( n = `value` v = client->_bind( slider_value )
            )->a( n = `class` v = `sapUiSmallMarginBottom`

        )->open( `Panel`
            )->a( n = `width` v = |\{= ${ client->_bind( slider_value ) } + '%'\}|
            )->a( n = `id`    v = `panelCSSGrid`

            )->open( `headerToolbar`
                )->open( `OverflowToolbar`
                    )->a( n = `height` v = `3rem`

                    )->leaf( `Title`
                        )->a( n = `text` v = `Properties gridTemplateRows and gridTemplateColumns example`

                )->shut(
            )->shut(
            )->open( n = `SimpleForm` ns = `form`
                )->a( n = `editable`    v = `true`
                )->a( n = `layout`      v = `ResponsiveGridLayout`
                )->a( n = `labelSpanXL` v = `3`
                )->a( n = `labelSpanL`  v = `3`
                )->a( n = `labelSpanM`  v = `4`
                )->a( n = `labelSpanS`  v = `12`

                )->leaf( `Label`
                    )->a( n = `text` v = `Change the value of Rows Template`

                )->open( `ComboBox`
                    )->a( n = `id`          v = `rTem`
                    )->a( n = `width`       v = `40%`
                    )->a( n = `selectedKey` v = `rFr`
                    )->a( n = `value`       v = client->_bind( rowstemplate )

                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `text` v = `1fr 2fr 1fr`
                        )->a( n = `key`  v = `rFr`

                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `text` v = `1fr 3fr 1fr`

                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `text` v = `1fr 2fr 3fr`

                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `text` v = `auto`

                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `text` v = `40px 4em 40px`

                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `text` v = `25% 40% 25%`

                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `text` v = `minmax(10px, 100px) auto auto`

                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `text` v = `repeat(3, 50px)`

                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `text` v = `repeat(3, minmax(40px, 60px))`

                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `text` v = `repeat(auto-fill, 50px)`

                )->shut(
                )->leaf( `Label`
                    )->a( n = `text` v = `Change the value of Columns Template`

                )->open( `ComboBox`
                    )->a( n = `id`          v = `cTem`
                    )->a( n = `width`       v = `40%`
                    )->a( n = `selectedKey` v = `cFr`
                    )->a( n = `value`       v = client->_bind( columnstemplate )

                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `text` v = `1fr 1fr`
                        )->a( n = `key`  v = `cFr`

                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `text` v = `1fr 2fr`

                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `text` v = `auto`

                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `text` v = `400px auto`

                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `text` v = `25% 50%`

                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `text` v = `minmax(100px, 200px) auto`

                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `text` v = `repeat(2, 150px)`

                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `text` v = `repeat(2, minmax(120px, 1fr))`

                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `text` v = `repeat(auto-fill, 200px)`

                )->shut(
            )->shut(
            )->open( n = `CSSGrid` ns = `grid`
                )->a( n = `id`                  v = `grid1`
                )->a( n = `gridTemplateRows`    v = client->_bind( rowstemplate )
                )->a( n = `gridTemplateColumns` v = client->_bind( columnstemplate )
                )->a( n = `gridGap`             v = `1rem`

                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Title`
                        )->a( n = `text`     v = `A Box`
                        )->a( n = `wrapping` v = `true`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `A Box subtitle`
                        )->a( n = `wrapping` v = `true`

                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Title`
                        )->a( n = `text`     v = `B Box`
                        )->a( n = `wrapping` v = `true`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `B Box subtitle`
                        )->a( n = `wrapping` v = `true`

                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Title`
                        )->a( n = `text`     v = `C Box`
                        )->a( n = `wrapping` v = `true`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `C Box subtitle`
                        )->a( n = `wrapping` v = `true`

                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Title`
                        )->a( n = `text`     v = `D Box`
                        )->a( n = `wrapping` v = `true`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `D Box subtitle`
                        )->a( n = `wrapping` v = `true`

                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Title`
                        )->a( n = `text`     v = `E Box`
                        )->a( n = `wrapping` v = `true`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `E Box subtitle`
                        )->a( n = `wrapping` v = `true`

                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `demoBox`

                    )->leaf( `Title`
                        )->a( n = `text`     v = `F Box`
                        )->a( n = `wrapping` v = `true`

                    )->leaf( `Text`
                        )->a( n = `text`     v = `F Box subtitle`
                        )->a( n = `wrapping` v = `true`

                )->shut(
            )->shut(
        )->shut(
    )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the original's initial values: Slider 100, and the two ComboBoxes on
    " their preselected keys rFr / cFr, whose item texts are the templates
    slider_value    = 100.
    rowstemplate    = `1fr 2fr 1fr`.
    columnstemplate = `1fr 1fr`.

  ENDMETHOD.

ENDCLASS.
