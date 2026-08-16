" @keywords grid sap.ui.layout gridproperties messagestrip title formattedtext slider
CLASS z2ui5_cl_smpc_app_345 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " one field per demo Slider - each grid wrapper's width is an expression
    " binding over its own slider, so the resize needs no round-trip at all
    DATA slider01 TYPE i.
    DATA slider02 TYPE i.
    DATA slider03 TYPE i.
    DATA slider04 TYPE i.
    DATA slider05 TYPE i.
    DATA slider06 TYPE i.
    DATA slider07 TYPE i.
    DATA slider08 TYPE i.
    DATA slider09 TYPE i.
    DATA slider10 TYPE i.
    DATA slider11 TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_345 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " the eleven l:Grid demos, each with its own Slider and gridWrapper. The
    " original resizes the NEXT wrapper from the controller by walking the DOM
    " (oSlider.$().parent().next().find('.gridWrapper')) and calling setWidth;
    " here the wrapper's own width is an expression binding over the slider's
    " two-way bound value, so the resize happens on the client with no
    " round-trip and no DOM walk. resources/styles.css is injected through a
    " core:HTML style leaf (CSS braces escaped so the XMLView parser does not
    " read them as bindings).
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `class`      v = `GridPropertiesSample`

        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.GridPropertiesSample .exampleDiv\{height:6rem;width:100%;background-color:#A9EAFF\}` &&
                                    `.GridPropertiesSample .contrastColor\{background-color:#008000\}</style>`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `width` v = `100%`

            )->tag( `MessageStrip`
                )->a( n = `class`    v = `sapUiTinyMargin`
                )->a( n = `text`     v = `Use the sliders to resize the grids and observe their behaviour.`
                )->a( n = `type`     v = `Information`
                )->a( n = `showIcon` v = `true`

            )->tag( `Title`
                )->a( n = `level`      v = `H1`
                )->a( n = `titleStyle` v = `H1`
                )->a( n = `text`       v = `Children's size`
                )->a( n = `class`      v = `sapUiMediumMarginTopBottom sapUiSmallMarginBegin`

            )->tag( `FormattedText`
                )->a( n = `htmlText` v = `<pre>defaultSpan: XL3 L3 M6 S12 (Default)</pre>`
                )->a( n = `class`    v = `sapUiSmallMarginBegin`

            )->tag( `MessageStrip`
                )->a( n = `class`    v = `sapUiTinyMarginBottom sapUiSmallMarginBegin`
                )->a( n = `text`     v = `Each child should take 3 columns on XL and L screens, 6 columns on M screens and 12 columns on S screens.`
                )->a( n = `type`     v = `Information`
                )->a( n = `showIcon` v = `true`

            )->tag( `Slider`
                )->a( n = `value` v = client->_bind( slider01 )
                )->a( n = `class` v = `sapUiSmallMarginBottom`

            )->ele( n = `VerticalLayout` ns = `l`
                )->a( n = `width` v = |\{= ${ client->_bind( slider01 ) } + '%'\}|
                )->a( n = `class` v = `gridWrapper`

                )->ele( n = `Grid` ns = `l`
                    )->a( n = `containerQuery` v = `true`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                )->end(
            )->end(
            )->tag( `FormattedText`
                )->a( n = `htmlText` v = `<pre>defaultSpan: XL2 L4</pre>`
                )->a( n = `class`    v = `sapUiSmallMarginBegin sapUiMediumMarginTop`

            )->tag( `MessageStrip`
                )->a( n = `class`    v = `sapUiTinyMarginBottom sapUiSmallMarginBegin`
                )->a( n = `text`     v = `Modify children's size for only XL and L screens.`
                )->a( n = `type`     v = `Information`
                )->a( n = `showIcon` v = `true`

            )->tag( `Slider`
                )->a( n = `value` v = client->_bind( slider02 )
                )->a( n = `class` v = `sapUiSmallMarginBottom`

            )->ele( n = `VerticalLayout` ns = `l`
                )->a( n = `width` v = |\{= ${ client->_bind( slider02 ) } + '%'\}|
                )->a( n = `class` v = `gridWrapper`

                )->ele( n = `Grid` ns = `l`
                    )->a( n = `containerQuery` v = `true`
                    )->a( n = `defaultSpan`    v = `XL2 L4`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                )->end(
            )->end(
            )->tag( `Title`
                )->a( n = `level`      v = `H1`
                )->a( n = `titleStyle` v = `H1`
                )->a( n = `text`       v = `Empty columns before each child`
                )->a( n = `class`      v = `sapUiLargeMarginTop sapUiMediumMarginBottom sapUiSmallMarginBegin`

            )->tag( `FormattedText`
                )->a( n = `htmlText` v = `<pre>defaultIndent: L1 M4 S6</pre>`
                )->a( n = `class`    v = `sapUiSmallMarginBegin`

            )->tag( `MessageStrip`
                )->a( n = `class`    v = `sapUiSmallMarginBottom sapUiSmallMarginBegin`
                )->a( n = `text`     v = `Insert 1 empty column before each child on XL and L screens, 4 on M screens and 6 on S screens.`
                )->a( n = `type`     v = `Information`
                )->a( n = `showIcon` v = `true`

            )->tag( `FormattedText`
                )->a( n = `htmlText` v = `<pre>defaultSpan: L6 M6 S6</pre>`
                )->a( n = `class`    v = `sapUiSmallMarginBegin`

            )->tag( `MessageStrip`
                )->a( n = `class`    v = `sapUiTinyMarginBottom sapUiSmallMarginBegin`
                )->a( n = `text`     v = `For demo purposes children take 6 columns on all screens.`
                )->a( n = `type`     v = `Information`
                )->a( n = `showIcon` v = `true`

            )->tag( `Slider`
                )->a( n = `value` v = client->_bind( slider03 )
                )->a( n = `class` v = `sapUiSmallMarginBottom`

            )->ele( n = `VerticalLayout` ns = `l`
                )->a( n = `width` v = |\{= ${ client->_bind( slider03 ) } + '%'\}|
                )->a( n = `class` v = `gridWrapper`

                )->ele( n = `Grid` ns = `l`
                    )->a( n = `containerQuery` v = `true`
                    )->a( n = `defaultIndent`  v = `L1 M4 S6`
                    )->a( n = `defaultSpan`    v = `L6 M6 S6`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                )->end(
            )->end(
            )->tag( `FormattedText`
                )->a( n = `htmlText` v = `<pre>defaultIndent: L1 M3</pre>`
                )->a( n = `class`    v = `sapUiSmallMarginBegin sapUiMediumMarginTop`

            )->tag( `MessageStrip`
                )->a( n = `class`    v = `sapUiSmallMarginBottom sapUiSmallMarginBegin`
                )->a( n = `text`     v = `Insert 1 empty column on L and XL screens and 3 on M screens.`
                )->a( n = `type`     v = `Information`
                )->a( n = `showIcon` v = `true`

            )->tag( `FormattedText`
                )->a( n = `htmlText` v = `<pre>defaultSpan: L3 M3 S3</pre>`
                )->a( n = `class`    v = `sapUiSmallMarginBegin`

            )->tag( `MessageStrip`
                )->a( n = `class`    v = `sapUiTinyMarginBottom sapUiSmallMarginBegin`
                )->a( n = `text`     v = `For demo purposes, children take 3 columns on all screens.`
                )->a( n = `type`     v = `Information`
                )->a( n = `showIcon` v = `true`

            )->tag( `Slider`
                )->a( n = `value` v = client->_bind( slider04 )
                )->a( n = `class` v = `sapUiSmallMarginBottom`

            )->ele( n = `VerticalLayout` ns = `l`
                )->a( n = `width` v = |\{= ${ client->_bind( slider04 ) } + '%'\}|
                )->a( n = `class` v = `gridWrapper`

                )->ele( n = `Grid` ns = `l`
                    )->a( n = `containerQuery` v = `true`
                    )->a( n = `defaultIndent`  v = `L1 M3`
                    )->a( n = `defaultSpan`    v = `L3 M3 S3`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                )->end(
            )->end(
            )->tag( `Title`
                )->a( n = `level`      v = `H1`
                )->a( n = `titleStyle` v = `H1`
                )->a( n = `text`       v = `Horizontal Spacing`
                )->a( n = `class`      v = `sapUiLargeMarginTop sapUiMediumMarginBottom sapUiSmallMarginBegin`

            )->tag( `FormattedText`
                )->a( n = `htmlText` v = `<pre>hSpacing: 0</pre>`
                )->a( n = `class`    v = `sapUiSmallMarginBegin`

            )->tag( `MessageStrip`
                )->a( n = `class`    v = `sapUiTinyMarginBottom sapUiSmallMarginBegin`
                )->a( n = `text`     v = `Removes any horizontal spacing between children.`
                )->a( n = `type`     v = `Information`
                )->a( n = `showIcon` v = `true`

            )->tag( `Slider`
                )->a( n = `value` v = client->_bind( slider05 )
                )->a( n = `class` v = `sapUiSmallMarginBottom`

            )->ele( n = `VerticalLayout` ns = `l`
                )->a( n = `width` v = |\{= ${ client->_bind( slider05 ) } + '%'\}|
                )->a( n = `class` v = `gridWrapper`

                )->ele( n = `Grid` ns = `l`
                    )->a( n = `containerQuery` v = `true`
                    )->a( n = `hSpacing`       v = `0`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv contrastColor" />`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv contrastColor" />`

                )->end(
            )->end(
            )->tag( `FormattedText`
                )->a( n = `htmlText` v = `<pre>hSpacing: 2</pre>`
                )->a( n = `class`    v = `sapUiSmallMarginBegin sapUiMediumMarginTop`

            )->tag( `MessageStrip`
                )->a( n = `class`    v = `sapUiTinyMarginBottom sapUiSmallMarginBegin`
                )->a( n = `text`     v = `Increase the horizontal spacing between children.`
                )->a( n = `type`     v = `Information`
                )->a( n = `showIcon` v = `true`

            )->tag( `Slider`
                )->a( n = `value` v = client->_bind( slider06 )
                )->a( n = `class` v = `sapUiSmallMarginBottom`

            )->ele( n = `VerticalLayout` ns = `l`
                )->a( n = `width` v = |\{= ${ client->_bind( slider06 ) } + '%'\}|
                )->a( n = `class` v = `gridWrapper`

                )->ele( n = `Grid` ns = `l`
                    )->a( n = `containerQuery` v = `true`
                    )->a( n = `hSpacing`       v = `2`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                )->end(
            )->end(
            )->tag( `Title`
                )->a( n = `level`      v = `H1`
                )->a( n = `titleStyle` v = `H1`
                )->a( n = `text`       v = `Vertical Spacing`
                )->a( n = `class`      v = `sapUiLargeMarginTop sapUiMediumMarginBottom sapUiSmallMarginBegin`

            )->tag( `FormattedText`
                )->a( n = `htmlText` v = `<pre>vSpacing: 0</pre>`
                )->a( n = `class`    v = `sapUiSmallMarginBegin`

            )->tag( `MessageStrip`
                )->a( n = `class`    v = `sapUiSmallMarginBottom sapUiSmallMarginBegin`
                )->a( n = `text`     v = `Removes any vertical spacing between children.`
                )->a( n = `type`     v = `Information`
                )->a( n = `showIcon` v = `true`

            )->tag( `FormattedText`
                )->a( n = `htmlText` v = `<pre>defaultSpan: L12 M12 S12</pre>`
                )->a( n = `class`    v = `sapUiSmallMarginBegin`

            )->tag( `MessageStrip`
                )->a( n = `class`    v = `sapUiTinyMarginBottom sapUiSmallMarginBegin`
                )->a( n = `text`     v = `For demo purposes, children take 12 columns on all screen sizes.`
                )->a( n = `type`     v = `Information`
                )->a( n = `showIcon` v = `true`

            )->tag( `Slider`
                )->a( n = `value` v = client->_bind( slider07 )
                )->a( n = `class` v = `sapUiSmallMarginBottom`

            )->ele( n = `VerticalLayout` ns = `l`
                )->a( n = `width` v = |\{= ${ client->_bind( slider07 ) } + '%'\}|
                )->a( n = `class` v = `gridWrapper`

                )->ele( n = `Grid` ns = `l`
                    )->a( n = `containerQuery` v = `true`
                    )->a( n = `vSpacing`       v = `0`
                    )->a( n = `defaultSpan`    v = `L12 M12 S12`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv contrastColor" />`

                )->end(
            )->end(
            )->tag( `FormattedText`
                )->a( n = `htmlText` v = `<pre>vSpacing: 2</pre>`
                )->a( n = `class`    v = `sapUiSmallMarginBegin sapUiMediumMarginTop`

            )->tag( `MessageStrip`
                )->a( n = `class`    v = `sapUiSmallMarginBottom sapUiSmallMarginBegin`
                )->a( n = `text`     v = `Increase the vertical spacing between children.`
                )->a( n = `type`     v = `Information`
                )->a( n = `showIcon` v = `true`

            )->tag( `FormattedText`
                )->a( n = `htmlText` v = `<pre>defaultSpan: L12 M12 S12</pre>`
                )->a( n = `class`    v = `sapUiSmallMarginBegin`

            )->tag( `MessageStrip`
                )->a( n = `class`    v = `sapUiTinyMarginBottom sapUiSmallMarginBegin`
                )->a( n = `text`     v = `For demo purposes, children take 12 columns on all screen sizes.`
                )->a( n = `type`     v = `Information`
                )->a( n = `showIcon` v = `true`

            )->tag( `Slider`
                )->a( n = `value` v = client->_bind( slider08 )
                )->a( n = `class` v = `sapUiSmallMarginBottom`

            )->ele( n = `VerticalLayout` ns = `l`
                )->a( n = `width` v = |\{= ${ client->_bind( slider08 ) } + '%'\}|
                )->a( n = `class` v = `gridWrapper`

                )->ele( n = `Grid` ns = `l`
                    )->a( n = `containerQuery` v = `true`
                    )->a( n = `vSpacing`       v = `2`
                    )->a( n = `defaultSpan`    v = `L12 M12 S12`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                )->end(
            )->end(
            )->tag( `Title`
                )->a( n = `level`      v = `H1`
                )->a( n = `titleStyle` v = `H1`
                )->a( n = `text`       v = `Explicit width`
                )->a( n = `class`      v = `sapUiLargeMarginTop sapUiMediumMarginBottom sapUiSmallMarginBegin`

            )->tag( `FormattedText`
                )->a( n = `htmlText` v = `<pre>width: 65%</pre>`
                )->a( n = `class`    v = `sapUiSmallMarginBegin`

            )->tag( `MessageStrip`
                )->a( n = `class`    v = `sapUiTinyMarginBottom sapUiSmallMarginBegin`
                )->a( n = `text`     v = `The grid's width will be 65% of the parent container.`
                )->a( n = `type`     v = `Information`
                )->a( n = `showIcon` v = `true`

            )->tag( `Slider`
                )->a( n = `value` v = client->_bind( slider09 )
                )->a( n = `class` v = `sapUiSmallMarginBottom`

            )->ele( n = `VerticalLayout` ns = `l`
                )->a( n = `width` v = |\{= ${ client->_bind( slider09 ) } + '%'\}|
                )->a( n = `class` v = `gridWrapper`

                )->ele( n = `Grid` ns = `l`
                    )->a( n = `containerQuery` v = `true`
                    )->a( n = `width`          v = `65%`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                )->end(
            )->end(
            )->tag( `Title`
                )->a( n = `level`      v = `H1`
                )->a( n = `titleStyle` v = `H1`
                )->a( n = `text`       v = `Positioning`
                )->a( n = `class`      v = `sapUiLargeMarginTop sapUiMediumMarginBottom sapUiSmallMarginBegin`

            )->tag( `FormattedText`
                )->a( n = `htmlText` v = `<pre>position: Right</pre>`
                )->a( n = `class`    v = `sapUiSmallMarginBegin`

            )->tag( `MessageStrip`
                )->a( n = `class`    v = `sapUiSmallMarginBottom sapUiSmallMarginBegin`
                )->a( n = `text`     v = `The grid will be located on the right of the screen.`
                )->a( n = `type`     v = `Information`
                )->a( n = `showIcon` v = `true`

            )->tag( `FormattedText`
                )->a( n = `htmlText` v = `<pre>width: 65%</pre>`
                )->a( n = `class`    v = `sapUiSmallMarginBegin`

            )->tag( `MessageStrip`
                )->a( n = `class`    v = `sapUiTinyMarginBottom sapUiSmallMarginBegin`
                )->a( n = `text`     v = `For demo purposes, the grid's width will be only 65%.`
                )->a( n = `type`     v = `Information`
                )->a( n = `showIcon` v = `true`

            )->tag( `Slider`
                )->a( n = `value` v = client->_bind( slider10 )
                )->a( n = `class` v = `sapUiSmallMarginBottom`

            )->ele( n = `VerticalLayout` ns = `l`
                )->a( n = `width` v = |\{= ${ client->_bind( slider10 ) } + '%'\}|
                )->a( n = `class` v = `gridWrapper`

                )->ele( n = `Grid` ns = `l`
                    )->a( n = `containerQuery` v = `true`
                    )->a( n = `position`       v = `Right`
                    )->a( n = `width`          v = `65%`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                )->end(
            )->end(
            )->tag( `FormattedText`
                )->a( n = `htmlText` v = `<pre>position: Center</pre>`
                )->a( n = `class`    v = `sapUiSmallMarginBegin sapUiMediumMarginTop`

            )->tag( `MessageStrip`
                )->a( n = `class`    v = `sapUiSmallMarginBottom sapUiSmallMarginBegin`
                )->a( n = `text`     v = `The grid will be in the center of the screen.`
                )->a( n = `type`     v = `Information`
                )->a( n = `showIcon` v = `true`

            )->tag( `FormattedText`
                )->a( n = `htmlText` v = `<pre>width: 65%</pre>`
                )->a( n = `class`    v = `sapUiSmallMarginBegin`

            )->tag( `MessageStrip`
                )->a( n = `class`    v = `sapUiTinyMarginBottom sapUiSmallMarginBegin`
                )->a( n = `text`     v = `For demo purposes, the grid's width will be only 65%.`
                )->a( n = `type`     v = `Information`
                )->a( n = `showIcon` v = `true`

            )->tag( `Slider`
                )->a( n = `value` v = client->_bind( slider11 )
                )->a( n = `class` v = `sapUiSmallMarginBottom`

            )->ele( n = `VerticalLayout` ns = `l`
                )->a( n = `width` v = |\{= ${ client->_bind( slider11 ) } + '%'\}|
                )->a( n = `class` v = `gridWrapper`

                )->ele( n = `Grid` ns = `l`
                    )->a( n = `containerQuery` v = `true`
                    )->a( n = `position`       v = `Center`
                    )->a( n = `width`          v = `65%`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                    )->tag( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv" />`

                )->end(
            )->end(
        )->end(
    )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " every Slider starts at 100 (the original's value="100"), so every grid
    " wrapper starts at 100% width
    slider01 = 100.
    slider02 = 100.
    slider03 = 100.
    slider04 = 100.
    slider05 = 100.
    slider06 = 100.
    slider07 = 100.
    slider08 = 100.
    slider09 = 100.
    slider10 = 100.
    slider11 = 100.

  ENDMETHOD.

ENDCLASS.
