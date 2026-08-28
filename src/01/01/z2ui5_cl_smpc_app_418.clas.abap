" @keywords title sap.m titlewrapping simpleform label switch slider panel messagestrip
" @summary This sample shows the different behaviors of a title.
CLASS z2ui5_cl_smpc_app_418 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA wrapping  TYPE abap_bool VALUE abap_true.
    DATA hyphenate TYPE abap_bool.
    DATA width_pct TYPE i VALUE 100.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_418 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:f`      v = `sap.ui.layout.form`
        )->a( n = `displayBlock` v = `true`

        )->ele( n = `SimpleForm` ns = `f`
            )->a( n = `layout`          v = `ResponsiveGridLayout`
            )->a( n = `editable`        v = `true`
            )->a( n = `title`           v = `Title Properties`
            )->a( n = `adjustLabelSpan` v = `false`
            )->a( n = `labelSpanXL`     v = `2`
            )->a( n = `labelSpanL`      v = `2`
            )->a( n = `labelSpanM`      v = `2`
            )->a( n = `labelSpanS`      v = `5`

            )->tag( `Label`
                )->a( n = `text` v = `Wrapping`
            " onWrappingChange toggles Title.wrapping - reproduced roundtrip-free by
            " two-way binding the same flag on both controls (the change wire is dropped)
            )->tag( `Switch`
                )->a( n = `id`    v = `wrappingSwitch`
                )->a( n = `state` v = client->_bind( wrapping )
            )->tag( `Label`
                )->a( n = `text` v = `Enable Hyphenation`
            )->tag( `Switch`
                )->a( n = `state` v = client->_bind( hyphenate )
            )->tag( `Label`
                )->a( n = `text` v = `Container Width`
            " onSliderMoved sets the Panel width to value+'%' - the liveChange wire is
            " dropped, the Panel width follows the bound value in an expression binding
            )->tag( `Slider`
                )->a( n = `id`    v = `widthSlider`
                )->a( n = `value` v = client->_bind( width_pct )

        )->end(

        )->ele( `Panel`
            )->a( n = `id`         v = `containerLayout`
            )->a( n = `headerText` v = `Rendered Title in container`
            )->a( n = `width`      v = |\{= ${ client->_bind( width_pct ) } + '%' \}|

            )->tag( `Title`
                )->a( n = `id`           v = `WrappingTitle`
                )->a( n = `wrapping`     v = client->_bind( wrapping )
                " onHyphenationChange: wrappingType follows the second Switch
                )->a( n = `wrappingType` v = |\{= ${ client->_bind( hyphenate ) } ? 'Hyphenated' : 'Normal' \}|
                )->a( n = `text`         v = `The Title control represents a single line of text with explicit header / title semantics. ` &&
                                             `The Title control represents a single line of text with explicit header / title semantics.`

        )->end(

        )->tag( `MessageStrip`
            )->a( n = `class` v = `sapUiSmallMarginBeginEnd sapUiSmallMarginTopBottom`
            )->a( n = `type`  v = `Warning`
            )->a( n = `text`  v = `Note: Hyphenation is not possible when Wrapping is set to "false"` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
