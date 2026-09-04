" @keywords toolbar sap.m items shrink expand too slider messagestrip label toolbarspacer button searchfield
" @summary Toolbar items can shrink/expand when the toolbar is resized. This behavior is enabled/disabled via the ToolbarLayoutData layout. It is also possible to set min/max width for shrinkable items.
CLASS z2ui5_cl_smpc_app_053 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA slider_value TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_053 IMPLEMENTATION.

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

    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->ele( `Page`
            )->a( n = `showHeader` v = `false`

            )->tag( `Slider`
                )->a( n = `step`  v = `20`
                )->a( n = `value` v = client->_bind( slider_value )

            )->tag( `MessageStrip`
                )->a( n = `text`  v = `By default, Toolbar items are shrinkable if they have percent-based width (e.g. Input, Slider)` &&
                                        ` or implement the IShrinkable interface (e.g. Text, Label).`
                )->a( n = `class` v = `sapUiTinyMargin`

            )->ele( `Toolbar`
                )->a( n = `class` v = `sapUiMediumMarginTop`
                )->a( n = `id`    v = `toolbar1`
                )->a( n = `width` v = |\{= ${ client->_bind( slider_value ) } + '%' \}|

                )->tag( `Label`
                    )->a( n = `text` v = `I am a text control, so I will shrink whenever the toolbar overflows.`
                )->tag( `ToolbarSpacer`
                )->tag( `Button`
                    )->a( n = `text` v = `Non-shrinkable button`
                )->tag( `ToolbarSpacer`
                )->tag( `SearchField`
                    )->a( n = `width`       v = `100%`
                    )->a( n = `placeholder` v = `My width is 100%, so I should shrink.`

            )->end(

            )->tag( `MessageStrip`
                )->a( n = `text`  v = `You can configure the item's shrinking-related properties by providing ToolbarLayoutData.`
                )->a( n = `class` v = `sapUiTinyMargin`

            )->ele( `Toolbar`
                )->a( n = `class` v = `sapUiMediumMarginTop`
                )->a( n = `id`    v = `toolbar2`
                )->a( n = `width` v = |\{= ${ client->_bind( slider_value ) } + '%' \}|

                )->ele( `Label`
                    )->a( n = `text` v = `I am a non-shrinkable text.`

                    )->ele( `layoutData`
                        )->tag( `ToolbarLayoutData`
                            )->a( n = `shrinkable` v = `false`

                    )->end(
                )->end(
                )->tag( `ToolbarSpacer`
                )->ele( `Button`
                    )->a( n = `text` v = `I am a shrinkable button, so I will shrink whenever the toolbar overflows.`

                    )->ele( `layoutData`
                        )->tag( `ToolbarLayoutData`
                            )->a( n = `shrinkable` v = `true`

                    )->end(
                )->end(
                )->tag( `ToolbarSpacer`
                )->tag( `SearchField`
                    )->a( n = `width`       v = `200px`
                    )->a( n = `placeholder` v = `I have a fixed width (200px), so I cannot shrink.`

            )->end(

            )->tag( `MessageStrip`
                )->a( n = `text`  v = `You can determine to what extent an item shrinks by setting minWidth/maxWidth via ToolbarLayoutData.` &&
                                        ` By default, minWidth is 48px in the Blue Crystal theme.`
                )->a( n = `class` v = `sapUiTinyMargin`

            )->ele( `Toolbar`
                )->a( n = `class` v = `sapUiMediumMarginTop`
                )->a( n = `id`    v = `toolbar3`
                )->a( n = `width` v = |\{= ${ client->_bind( slider_value ) } + '%' \}|

                )->ele( `Label`
                    )->a( n = `text` v = `I should not shrink by more than 200px, because I am an important text.`

                    )->ele( `layoutData`
                        )->tag( `ToolbarLayoutData`
                            )->a( n = `shrinkable` v = `true`
                            )->a( n = `minWidth`   v = `200px`

                    )->end(
                )->end(
                )->tag( `ToolbarSpacer`
                )->ele( `Button`
                    )->a( n = `text` v = `I cannot be wider than 400px, but I can shrink up to the theme's default minimum width.`

                    )->ele( `layoutData`
                        )->tag( `ToolbarLayoutData`
                            )->a( n = `shrinkable` v = `true`
                            )->a( n = `maxWidth`   v = `400px`

                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    slider_value = 100.

  ENDMETHOD.

ENDCLASS.
