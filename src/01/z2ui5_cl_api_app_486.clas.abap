"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.Toolbar - ToolbarShrinkable
"! https://sdk.openui5.org/entity/sap.m.Toolbar/sample/sap.m.sample.ToolbarShrinkable
"! NOTES (generation):
"! - IMPROVISED: the sample's controller onSliderLiveChange resizes the toolbars
"!   in JS; there is no width in the source XML. Rebuilt as a bound width on each
"!   Toolbar fed by the SLIDER_CHANGE liveChange event - this width binding is an
"!   addition not present in Toolbar.view.xml.
CLASS z2ui5_cl_api_app_486 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA toolbar_width TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS model_init.
    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_486 IMPLEMENTATION.

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

    toolbar_width = `100%`.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `Page`
            )->a( n = `showHeader` v = `false`

            )->leaf( `Slider`
                )->a( n = `liveChange` v = client->_event( val   = `SLIDER_CHANGE`
                                                              t_arg = VALUE #( ( `${$parameters>/value}` ) ) )
                )->a( n = `step`       v = `20`
                )->a( n = `value`      v = `100`

            )->leaf( `MessageStrip`
                )->a( n = `text`  v = `By default, Toolbar items are shrinkable if they have percent-based width (e.g. Input, Slider)` &&
                                        ` or implement the IShrinkable interface (e.g. Text, Label).`
                )->a( n = `class` v = `sapUiTinyMargin`

            )->open( `Toolbar`
                )->a( n = `class` v = `sapUiMediumMarginTop`
                )->a( n = `id`    v = `toolbar1`
                )->a( n = `width` v = client->_bind_edit( toolbar_width )

                )->leaf( `Label`
                    )->a( n = `text` v = `I am a text control, so I will shrink whenever the toolbar overflows.`
                )->leaf( `ToolbarSpacer`
                )->leaf( `Button`
                    )->a( n = `text` v = `Non-shrinkable button`
                )->leaf( `ToolbarSpacer`
                )->leaf( `SearchField`
                    )->a( n = `width`       v = `100%`
                    )->a( n = `placeholder` v = `My width is 100%, so I should shrink.`

            )->shut(

            )->leaf( `MessageStrip`
                )->a( n = `text`  v = `You can configure the item's shrinking-related properties by providing ToolbarLayoutData.`
                )->a( n = `class` v = `sapUiTinyMargin`

            )->open( `Toolbar`
                )->a( n = `class` v = `sapUiMediumMarginTop`
                )->a( n = `id`    v = `toolbar2`
                )->a( n = `width` v = client->_bind_edit( toolbar_width )

                )->open( `Label`
                    )->a( n = `text` v = `I am a non-shrinkable text.`

                    )->open( `layoutData`
                        )->leaf( `ToolbarLayoutData`
                            )->a( n = `shrinkable` v = `false`

                    )->shut(
                )->shut(
                )->leaf( `ToolbarSpacer`
                )->open( `Button`
                    )->a( n = `text` v = `I am a shrinkable button, so I will shrink whenever the toolbar overflows.`

                    )->open( `layoutData`
                        )->leaf( `ToolbarLayoutData`
                            )->a( n = `shrinkable` v = `true`

                    )->shut(
                )->shut(
                )->leaf( `ToolbarSpacer`
                )->leaf( `SearchField`
                    )->a( n = `width`       v = `200px`
                    )->a( n = `placeholder` v = `I have a fixed width (200px), so I cannot shrink.`

            )->shut(

            )->leaf( `MessageStrip`
                )->a( n = `text`  v = `You can determine to what extent an item shrinks by setting minWidth/maxWidth via ToolbarLayoutData.` &&
                                        ` By default, minWidth is 48px in the Blue Crystal theme.`
                )->a( n = `class` v = `sapUiTinyMargin`

            )->open( `Toolbar`
                )->a( n = `class` v = `sapUiMediumMarginTop`
                )->a( n = `id`    v = `toolbar3`
                )->a( n = `width` v = client->_bind_edit( toolbar_width )

                )->open( `Label`
                    )->a( n = `text` v = `I should not shrink by more than 200px, because I am an important text.`

                    )->open( `layoutData`
                        )->leaf( `ToolbarLayoutData`
                            )->a( n = `shrinkable` v = `true`
                            )->a( n = `minWidth`   v = `200px`

                    )->shut(
                )->shut(
                )->leaf( `ToolbarSpacer`
                )->open( `Button`
                    )->a( n = `text` v = `I cannot be wider than 400px, but I can shrink up to the theme's default minimum width.`

                    )->open( `layoutData`
                        )->leaf( `ToolbarLayoutData`
                            )->a( n = `shrinkable` v = `true`
                            )->a( n = `maxWidth`   v = `400px`

                    )->shut(
                )->shut(

            )->shut(

        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `SLIDER_CHANGE`.
        toolbar_width = |{ client->get_event_arg( 1 ) }%|.
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
