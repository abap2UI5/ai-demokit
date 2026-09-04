" @keywords label sap.m properties: wrapping hyphenation simpleform switch slider scrollcontainer input panel messagestrip
" @summary This sample shows the different behaviors of a label.
CLASS z2ui5_cl_smpc_app_058 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA display_only  TYPE abap_bool.
    DATA wrapping      TYPE abap_bool.
    DATA hyphenation   TYPE abap_bool.
    DATA slider_value  TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_058 IMPLEMENTATION.

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
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:form` v = `sap.ui.layout.form`

        )->ele( n = `SimpleForm` ns = `form`
            )->a( n = `layout`          v = `ResponsiveGridLayout`
            )->a( n = `editable`        v = `true`
            )->a( n = `title`           v = `Properties`
            )->a( n = `adjustLabelSpan` v = `false`
            )->a( n = `labelSpanXL`     v = `2`
            )->a( n = `labelSpanL`      v = `2`
            )->a( n = `labelSpanM`      v = `2`
            )->a( n = `labelSpanS`      v = `5`

            )->tag( `Label`
                )->a( n = `text` v = `Display Only`
            " roundtrip-free rework: the controller handlers are replaced by two-way bindings, the change and liveChange events dropped (see sidecar)
            )->tag( `Switch`
                )->a( n = `state` v = client->_bind( display_only )
            )->tag( `Label`
                )->a( n = `text` v = `Wrapping`
            )->tag( `Switch`
                )->a( n = `id`    v = `wrappingSwitch`
                )->a( n = `state` v = client->_bind( wrapping )
            )->tag( `Label`
                )->a( n = `text` v = `Enable Hyphenation`
            )->tag( `Switch`
                )->a( n = `state` v = client->_bind( hyphenation )
            )->tag( `Label`
                )->a( n = `text` v = `Container Width`
            )->tag( `Slider`
                )->a( n = `value` v = client->_bind( slider_value )

        )->end(

        )->ele( `ScrollContainer`
            )->a( n = `id`         v = `containerForm`
            )->a( n = `width`      v = |\{= ${ client->_bind( slider_value ) } + '%'\}|
            )->a( n = `horizontal` v = `false`
            )->a( n = `vertical`   v = `false`

            )->ele( n = `SimpleForm` ns = `form`
                )->a( n = `layout`   v = `ResponsiveGridLayout`
                )->a( n = `editable` v = `true`
                )->a( n = `title`    v = `Result in a Form`

                )->tag( `Label`
                    )->a( n = `id`           v = `labelInForm`
                    )->a( n = `displayOnly`  v = client->_bind( display_only )
                    )->a( n = `wrapping`     v = client->_bind( wrapping )
                    )->a( n = `wrappingType` v = |\{= ${ client->_bind( hyphenation ) } ? 'Hyphenated' : 'Normal'\}|
                    )->a( n = `text`         v = `Labels are used as titles [long test word] forsinglecontrolsorgroups of controls. Label appearance can be influenced by properties`
                )->tag( `Input`

            )->end(
        )->end(

        )->ele( `Panel`
            )->a( n = `id`         v = `containerLayout`
            )->a( n = `headerText` v = `Result in a Container`
            )->a( n = `width`      v = |\{= ${ client->_bind( slider_value ) } + '%'\}|

            )->tag( `Label`
                )->a( n = `id`           v = `label`
                )->a( n = `labelFor`     v = `containerInput`
                )->a( n = `displayOnly`  v = client->_bind( display_only )
                )->a( n = `wrapping`     v = client->_bind( wrapping )
                )->a( n = `wrappingType` v = |\{= ${ client->_bind( hyphenation ) } ? 'Hyphenated' : 'Normal'\}|
                )->a( n = `text`         v = `Labels are used as titles [long test word] forsinglecontrolsorgroups of controls. Label appearance can be influenced by properties`
            )->tag( `Input`
                )->a( n = `id` v = `containerInput`

        )->end(

        )->tag( `MessageStrip`
            )->a( n = `type`  v = `Warning`
            )->a( n = `text`  v = `Note: Hyphenation is not possible when Wrapping is set to 'false'`
            )->a( n = `class` v = `sapUiSmallMarginBeginEnd sapUiSmallMarginTopBottom` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    display_only = abap_true.
    wrapping     = abap_true.
    hyphenation  = abap_false.
    slider_value = 100.

  ENDMETHOD.

ENDCLASS.
