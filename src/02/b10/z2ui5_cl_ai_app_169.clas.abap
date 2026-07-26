CLASS z2ui5_cl_ai_app_169 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_169 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " sap.ui.layout.Grid / GridData sample. Pure declarative layout: eight
    " l:Grid demos of the l:GridData responsive layoutData (span / indent /
    " linebreak / visibility). The grid cells are core:HTML divs, exactly as in
    " the original. The sample's style.css is injected via a core:HTML <style>
    " (abap2UI5 ships no separate css file) - CSS braces escaped \{ \} so the
    " XMLView parser does not read them as bindings.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `class`      v = `GridDataSample`

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `width` v = `100%`

            )->leaf( n = `HTML` ns = `core`
                )->a( n = `content` v = `<style>.GridDataSample .exampleDiv\{height:7rem;width:100%;background-color:#A9EAFF\}` &&
                                        `.GridDataSample .exampleDiv>p,.GridDataSample .propertiesDisplay\{position:relative;top:50%;transform:translateY(-50%)\}` &&
                                        `.GridDataSample p\{margin:0;text-align:center;line-height:150%\}</style>`

            )->leaf( `MessageStrip`
                )->a( n = `class`    v = `sapUiTinyMargin`
                )->a( n = `text`     v = `Use the sliders to resize the grids and observe their behaviour.`
                )->a( n = `type`     v = `Information`
                )->a( n = `showIcon` v = `true`

            )->leaf( `Title`
                )->a( n = `level`      v = `H1`
                )->a( n = `titleStyle` v = `H1`
                )->a( n = `text`       v = `Individual span sizing`
                )->a( n = `class`      v = `sapUiLargeMarginTop sapUiMediumMarginBottom sapUiSmallMarginBegin`

            )->leaf( `MessageStrip`
                )->a( n = `class`    v = `sapUiTinyMarginBottom sapUiSmallMarginBegin`
                )->a( n = `text`     v = `The second child will always be 6 columns wide, regardless of the screen size.`
                )->a( n = `type`     v = `Information`
                )->a( n = `showIcon` v = `true`

            )->leaf( `Slider`
                )->a( n = `value` v = `100`
                )->a( n = `class` v = `sapUiSmallMarginBottom`

            )->open( n = `VerticalLayout` ns = `l`
                )->a( n = `width` v = `100%`
                )->a( n = `class` v = `gridWrapper`
                )->open( n = `Grid` ns = `l`
                    )->a( n = `containerQuery` v = `true`

                    )->leaf( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv"></div>`

                    )->open( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv"><p>span: XL6 L6 M6 S6</p></div>`
                        )->open( n = `layoutData` ns = `core`
                            )->leaf( n = `GridData` ns = `l`
                                )->a( n = `span` v = `XL6 L6 M6 S6`

                    )->shut(
                    )->shut(
                )->shut(
            )->shut(

            )->leaf( `Title`
                )->a( n = `level`      v = `H1`
                )->a( n = `titleStyle` v = `H1`
                )->a( n = `text`       v = `Overriding individual span sizing`
                )->a( n = `class`      v = `sapUiLargeMarginTop sapUiMediumMarginBottom sapUiSmallMarginBegin`

            )->leaf( `MessageStrip`
                )->a( n = `class`    v = `sapUiTinyMarginBottom sapUiSmallMarginBegin`
                )->a( n = `text`     v = `Set both children to always be 6 columns wide and then reset the second one.`
                )->a( n = `type`     v = `Information`
                )->a( n = `showIcon` v = `true`

            )->leaf( `Slider`
                )->a( n = `value` v = `100`
                )->a( n = `class` v = `sapUiSmallMarginBottom`

            )->open( n = `VerticalLayout` ns = `l`
                )->a( n = `width` v = `100%`
                )->a( n = `class` v = `gridWrapper`
                )->open( n = `Grid` ns = `l`
                    )->a( n = `containerQuery` v = `true`

                    )->open( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv"><p>span: XL6 L6 M6 S6</p></div>`
                        )->open( n = `layoutData` ns = `core`
                            )->leaf( n = `GridData` ns = `l`
                                )->a( n = `span` v = `XL6 L6 M6 S6`

                    )->shut(
                    )->shut(

                    )->open( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv"><div class="propertiesDisplay"><p>span: XL6 L6 M6 S6</p><p>spanL/XL: 3</p><p>spanM: 6</p><p>spanS: 12</p></div></div>`
                        )->open( n = `layoutData` ns = `core`
                            )->leaf( n = `GridData` ns = `l`
                                )->a( n = `span`   v = `XL6 L6 M6 S6`
                                )->a( n = `spanXL` v = `3`
                                )->a( n = `spanL`  v = `3`
                                )->a( n = `spanM`  v = `6`
                                )->a( n = `spanS`  v = `12`

                    )->shut(
                    )->shut(
                )->shut(
            )->shut(

            )->leaf( `Title`
                )->a( n = `level`      v = `H1`
                )->a( n = `titleStyle` v = `H1`
                )->a( n = `text`       v = `Individual indentation`
                )->a( n = `class`      v = `sapUiLargeMarginTop sapUiMediumMarginBottom sapUiSmallMarginBegin`

            )->leaf( `MessageStrip`
                )->a( n = `class`    v = `sapUiTinyMarginBottom sapUiSmallMarginBegin`
                )->a( n = `text`     v = `The second child will be indented by 2 columns on XL screens and by 6 columns on L screens.`
                )->a( n = `type`     v = `Information`
                )->a( n = `showIcon` v = `true`

            )->leaf( `Slider`
                )->a( n = `value` v = `100`
                )->a( n = `class` v = `sapUiSmallMarginBottom`

            )->open( n = `VerticalLayout` ns = `l`
                )->a( n = `width` v = `100%`
                )->a( n = `class` v = `gridWrapper`
                )->open( n = `Grid` ns = `l`
                    )->a( n = `containerQuery` v = `true`

                    )->leaf( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv"></div>`

                    )->open( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv"><p>indent: XL2 L6</p></div>`
                        )->open( n = `layoutData` ns = `core`
                            )->leaf( n = `GridData` ns = `l`
                                )->a( n = `indent` v = `XL2 L6`

                    )->shut(
                    )->shut(
                )->shut(
            )->shut(

            )->leaf( `Title`
                )->a( n = `level`      v = `H1`
                )->a( n = `titleStyle` v = `H1`
                )->a( n = `text`       v = `Overriding individual indentation`
                )->a( n = `class`      v = `sapUiLargeMarginTop sapUiMediumMarginBottom sapUiSmallMarginBegin`

            )->leaf( `MessageStrip`
                )->a( n = `class`    v = `sapUiTinyMarginBottom sapUiSmallMarginBegin`
                )->a( n = `text`     v = `Add indentation on the first child for M screens initially and then modify it to apply for larger screens too.`
                )->a( n = `type`     v = `Information`
                )->a( n = `showIcon` v = `true`

            )->leaf( `Slider`
                )->a( n = `value` v = `100`
                )->a( n = `class` v = `sapUiSmallMarginBottom`

            )->open( n = `VerticalLayout` ns = `l`
                )->a( n = `width` v = `100%`
                )->a( n = `class` v = `gridWrapper`
                )->open( n = `Grid` ns = `l`
                    )->a( n = `containerQuery` v = `true`

                    )->open( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv"><div class="propertiesDisplay"><p>indent: M4</p><p>indentL/XL: 4</p></div></div>`
                        )->open( n = `layoutData` ns = `core`
                            )->leaf( n = `GridData` ns = `l`
                                )->a( n = `indent`   v = `M4`
                                )->a( n = `indentXL` v = `4`
                                )->a( n = `indentL`  v = `4`

                    )->shut(
                    )->shut(

                    )->leaf( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv"></div>`

                )->shut(
            )->shut(

            )->leaf( `Title`
                )->a( n = `level`      v = `H1`
                )->a( n = `titleStyle` v = `H1`
                )->a( n = `text`       v = `Linebreaking`
                )->a( n = `class`      v = `sapUiLargeMarginTop sapUiMediumMarginBottom sapUiSmallMarginBegin`

            )->leaf( `MessageStrip`
                )->a( n = `class`    v = `sapUiTinyMarginBottom sapUiSmallMarginBegin`
                )->a( n = `text`     v = `The second child will cause a linebreak, regardless of other children's width.`
                )->a( n = `type`     v = `Information`
                )->a( n = `showIcon` v = `true`

            )->leaf( `Slider`
                )->a( n = `value` v = `100`
                )->a( n = `class` v = `sapUiSmallMarginBottom`

            )->open( n = `VerticalLayout` ns = `l`
                )->a( n = `width` v = `100%`
                )->a( n = `class` v = `gridWrapper`
                )->open( n = `Grid` ns = `l`
                    )->a( n = `containerQuery` v = `true`

                    )->leaf( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv"></div>`

                    )->open( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv"><p>linebreak: true</p></div>`
                        )->open( n = `layoutData` ns = `core`
                            )->leaf( n = `GridData` ns = `l`
                                )->a( n = `linebreak` v = `true`

                    )->shut(
                    )->shut(

                    )->leaf( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv"></div>`

                )->shut(
            )->shut(

            )->leaf( `FormattedText`
                )->a( n = `htmlText` v = `<pre>defaultSpan: XL4 L4 M4 S4</pre>`
                )->a( n = `class`    v = `sapUiSmallMarginBegin sapUiLargeMarginTop`

            )->leaf( `MessageStrip`
                )->a( n = `class`    v = `sapUiTinyMarginBottom sapUiSmallMarginBegin`
                )->a( n = `text`     v = `Grid children will be 4 columns wide on all screen sizes for demo purposes.`
                )->a( n = `type`     v = `Information`
                )->a( n = `showIcon` v = `true`

            )->leaf( `MessageStrip`
                )->a( n = `class`    v = `sapUiTinyMarginBottom sapUiSmallMarginBegin`
                )->a( n = `text`     v = `The middle child will cause a linebreak only on M screens.`
                )->a( n = `type`     v = `Information`
                )->a( n = `showIcon` v = `true`

            )->leaf( `Slider`
                )->a( n = `value` v = `100`
                )->a( n = `class` v = `sapUiSmallMarginBottom`

            )->open( n = `VerticalLayout` ns = `l`
                )->a( n = `width` v = `100%`
                )->a( n = `class` v = `gridWrapper`
                )->open( n = `Grid` ns = `l`
                    )->a( n = `containerQuery` v = `true`
                    )->a( n = `defaultSpan`    v = `XL4 L4 M4 S4`

                    )->leaf( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv"></div>`

                    )->open( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv"><p>linebreakM: true</p></div>`
                        )->open( n = `layoutData` ns = `core`
                            )->leaf( n = `GridData` ns = `l`
                                )->a( n = `linebreakM` v = `true`

                    )->shut(
                    )->shut(

                    )->leaf( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv"></div>`

                )->shut(
            )->shut(

            )->leaf( `Title`
                )->a( n = `level`      v = `H1`
                )->a( n = `titleStyle` v = `H1`
                )->a( n = `text`       v = `Visibility`
                )->a( n = `class`      v = `sapUiLargeMarginTop sapUiMediumMarginBottom sapUiSmallMarginBegin`

            )->leaf( `MessageStrip`
                )->a( n = `class`    v = `sapUiTinyMarginBottom sapUiSmallMarginBegin sapUiLargeMarginTop`
                )->a( n = `text`     v = `This example shows three children, the middle of which is hidden. When it disappears from the screen, the next child will take it's place`
                )->a( n = `type`     v = `Information`
                )->a( n = `showIcon` v = `true`

            )->leaf( `Slider`
                )->a( n = `value` v = `100`
                )->a( n = `class` v = `sapUiSmallMarginBottom`

            )->open( n = `VerticalLayout` ns = `l`
                )->a( n = `width` v = `100%`
                )->a( n = `class` v = `gridWrapper`
                )->open( n = `Grid` ns = `l`
                    )->a( n = `containerQuery` v = `true`

                    )->leaf( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv"></div>`

                    )->open( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv"><div class="propertiesDisplay"><p>visibleS: false</p><p>visibleM: false</p><p>visibleL: false</p><p>visibleXL: false</p></div></div>`
                        )->open( n = `layoutData` ns = `core`
                            )->leaf( n = `GridData` ns = `l`
                                )->a( n = `visibleS`  v = `false`
                                )->a( n = `visibleM`  v = `false`
                                )->a( n = `visibleL`  v = `false`
                                )->a( n = `visibleXL` v = `false`

                    )->shut(
                    )->shut(

                    )->leaf( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv"></div>`

                )->shut(
            )->shut(

            )->leaf( `MessageStrip`
                )->a( n = `class`    v = `sapUiTinyMarginBottom sapUiSmallMarginBegin sapUiLargeMarginTop`
                )->a( n = `text`     v = `The children will be hidden one by one while the screen size gets smaller.`
                )->a( n = `type`     v = `Information`
                )->a( n = `showIcon` v = `true`

            )->leaf( `Slider`
                )->a( n = `value` v = `100`
                )->a( n = `class` v = `sapUiSmallMarginBottom`

            )->open( n = `VerticalLayout` ns = `l`
                )->a( n = `width` v = `100%`
                )->a( n = `class` v = `gridWrapper`
                )->open( n = `Grid` ns = `l`
                    )->a( n = `containerQuery` v = `true`

                    )->leaf( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv"></div>`

                    )->open( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv"><p>visibleS: false</p></div>`
                        )->open( n = `layoutData` ns = `core`
                            )->leaf( n = `GridData` ns = `l`
                                )->a( n = `visibleS` v = `false`

                    )->shut(
                    )->shut(

                    )->open( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv"><div class="propertiesDisplay"><p>visibleS: false</p><p>visibleM: false</p></div></div>`
                        )->open( n = `layoutData` ns = `core`
                            )->leaf( n = `GridData` ns = `l`
                                )->a( n = `visibleS` v = `false`
                                )->a( n = `visibleM` v = `false`

                    )->shut(
                    )->shut(

                    )->open( n = `HTML` ns = `core`
                        )->a( n = `content` v = `<div class="exampleDiv"><div class="propertiesDisplay"><p>visibleS: false</p><p>visibleM: false</p><p>visibleL: false</p></div></div>`
                        )->open( n = `layoutData` ns = `core`
                            )->leaf( n = `GridData` ns = `l`
                                )->a( n = `visibleS` v = `false`
                                )->a( n = `visibleM` v = `false`
                                )->a( n = `visibleL` v = `false`

                    )->shut(
                    )->shut(
                )->shut(
            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
