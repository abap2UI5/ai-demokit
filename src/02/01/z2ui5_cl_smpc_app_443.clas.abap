" @keywords text sap.m textrenderwhitespace label switch slider panel
" @summary The Text control has a property allowing browsers to render whitespace and tabs.
CLASS z2ui5_cl_smpc_app_443 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA wrapping         TYPE abap_bool VALUE abap_true.
    DATA render_whitespace TYPE abap_bool VALUE abap_true.
    DATA width_pct        TYPE i VALUE 100.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_443 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " the sample's text carries the whitespace it demonstrates: line breaks
    " (&#xA;), tab runs (&#x9;) and space runs, written here as \n / \t in an
    " ABAP string template so the characters reach the attribute unchanged
    DATA(whitespace_text) = |Lorem ipsum dolor sit amet,(1 line break follows)\nconsetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt (2 line | &&
                                     |breaks follow)\n\nut labore et dolore magna aliquyam erat, (4 tabs follow)\t\t\t\tsed diam voluptua. At vero eos et accusam et | &&
                                     |justo duo dolores et ea rebum. (1 line break follows)\nStet clita kasd gubergren, no sea takimata sanctus est (7 spaces follow)   | &&
                                     |    Lorem ipsum dolor sit amet.Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut | &&
                                     |labore et dolore magna aliquyam erat,(7 spaces follow)       sed diam voluptua. At vero eos et accusam et justo duo dolores et ea | &&
                                     |rebum. (7 spaces follow)       Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.Lorem (6 tabs | &&
                                     |follow)\t\t\t\t\t\tipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore | &&
                                     |magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no | &&
                                     |sea takimata sanctus est Lorem ipsum dolor sit amet:|.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:f`      v = `sap.ui.layout.form`
        )->a( n = `displayBlock` v = `true`

        )->ele( n = `SimpleForm` ns = `f`
            )->a( n = `layout`          v = `ResponsiveGridLayout`
            )->a( n = `editable`        v = `true`
            )->a( n = `title`           v = `Text Properties`
            )->a( n = `adjustLabelSpan` v = `false`
            )->a( n = `labelSpanXL`     v = `2`
            )->a( n = `labelSpanL`      v = `2`
            )->a( n = `labelSpanM`      v = `2`
            )->a( n = `labelSpanS`      v = `4`
            )->a( n = `emptySpanXL`     v = `4`
            )->a( n = `emptySpanL`      v = `4`
            )->a( n = `emptySpanM`      v = `2`
            )->a( n = `emptySpanS`      v = `0`
            )->a( n = `columnsXL`       v = `2`
            )->a( n = `columnsL`        v = `2`
            )->a( n = `columnsM`        v = `2`

            )->tag( `Label`
                )->a( n = `text` v = `Wrapping`
            " onWrappingChange / onRenderWhitespaceChange flip the Text property the
            " Switch sits next to - both are two-way bound on Switch and Text instead
            )->tag( `Switch`
                )->a( n = `state` v = client->_bind( wrapping )
            )->tag( `Label`
                )->a( n = `text` v = `RenderWhitespace`
            )->tag( `Switch`
                )->a( n = `state` v = client->_bind( render_whitespace )
            )->tag( `Label`
                )->a( n = `text` v = `Container Width`
            " onSliderMoved sets the Panel width to value + '%' - an expression
            " binding over the two-way bound Slider value does the same
            )->tag( `Slider`
                )->a( n = `id`    v = `widthSlider`
                )->a( n = `value` v = client->_bind( width_pct )

        )->end(

        )->ele( `Panel`
            )->a( n = `id`         v = `containerLayout`
            )->a( n = `headerText` v = `Rendered Text in container`
            )->a( n = `width`      v = |\{= ${ client->_bind( width_pct ) } + '%' \}|

            )->tag( `Text`
                )->a( n = `id`               v = `text`
                )->a( n = `renderWhitespace` v = client->_bind( render_whitespace )
                )->a( n = `wrapping`         v = client->_bind( wrapping )
                )->a( n = `text`             v = whitespace_text ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
