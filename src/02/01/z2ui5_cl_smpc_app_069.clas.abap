CLASS z2ui5_cl_smpc_app_069 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_069 IMPLEMENTATION.

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

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`
            )->tag( `Label`
                )->a( n = `text`     v = `Default RadioButton use`
                )->a( n = `labelFor` v = `GroupA`
            )->ele( `RadioButtonGroup`
                )->a( n = `id` v = `GroupA`
                )->tag( `RadioButton`
                    )->a( n = `text`     v = `Option 1`
                    )->a( n = `selected` v = `true`
                )->tag( `RadioButton`
                    )->a( n = `text` v = `Option 2`
                )->tag( `RadioButton`
                    )->a( n = `text` v = `Option 3`
                )->tag( `RadioButton`
                    )->a( n = `text` v = `Option 4`
                )->tag( `RadioButton`
                    )->a( n = `text` v = `Option 5`

            )->end(
        )->end(

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`
            )->tag( `Label`
                )->a( n = `text` v = `RadioButton in various ValueState variants`
            )->ele( `HBox`
                )->a( n = `class` v = `sapUiTinyMarginTopBottom`

                )->ele( `VBox`
                    )->a( n = `class` v = `sapUiMediumMarginEnd`
                    )->tag( `Label`
                        )->a( n = `text`     v = `Success`
                        )->a( n = `labelFor` v = `groupB`
                    )->ele( `RadioButtonGroup`
                        )->a( n = `id`         v = `groupB`
                        )->a( n = `valueState` v = `Success`
                        )->tag( `RadioButton`
                            )->a( n = `text`     v = `Option 1`
                            )->a( n = `selected` v = `true`
                        )->tag( `RadioButton`
                            )->a( n = `text` v = `Option 2`

                    )->end(
                )->end(
                )->ele( `VBox`
                    )->a( n = `class` v = `sapUiMediumMarginEnd`
                    )->tag( `Label`
                        )->a( n = `text`     v = `Error`
                        )->a( n = `labelFor` v = `groupC`
                    )->ele( `RadioButtonGroup`
                        )->a( n = `id`         v = `groupC`
                        )->a( n = `valueState` v = `Error`
                        )->tag( `RadioButton`
                            )->a( n = `text`     v = `Option 1`
                            )->a( n = `selected` v = `true`
                        )->tag( `RadioButton`
                            )->a( n = `text` v = `Option 2`

                    )->end(
                )->end(
                )->ele( `VBox`
                    )->a( n = `class` v = `sapUiMediumMarginEnd`
                    )->tag( `Label`
                        )->a( n = `text`     v = `Warning`
                        )->a( n = `labelFor` v = `groupD`
                    )->ele( `RadioButtonGroup`
                        )->a( n = `id`         v = `groupD`
                        )->a( n = `valueState` v = `Warning`
                        )->tag( `RadioButton`
                            )->a( n = `text`     v = `Option 1`
                            )->a( n = `selected` v = `true`
                        )->tag( `RadioButton`
                            )->a( n = `text` v = `Option 2`

                    )->end(
                )->end(
                )->ele( `VBox`
                    )->a( n = `class` v = `sapUiMediumMarginEnd`
                    )->tag( `Label`
                        )->a( n = `text`     v = `Information`
                        )->a( n = `labelFor` v = `groupE`
                    )->ele( `RadioButtonGroup`
                        )->a( n = `id`         v = `groupE`
                        )->a( n = `valueState` v = `Information`
                        )->tag( `RadioButton`
                            )->a( n = `text`     v = `Option 1`
                            )->a( n = `selected` v = `true`
                        )->tag( `RadioButton`
                            )->a( n = `text` v = `Option 2`

                    )->end(
                )->end(
            )->end(
        )->end(

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`
            )->tag( `Label`
                )->a( n = `text`     v = `RadioButton Wrapping`
                )->a( n = `labelFor` v = `groupF`
            )->ele( `RadioButtonGroup`
                )->a( n = `id` v = `groupF`
                " POST-1.71: wrapping and wrappingType (since UI5 1.126) kept 1:1
                )->tag( `RadioButton`
                    )->a( n = `width`        v = `240px`
                    )->a( n = `wrapping`     v = `true`
                    )->a( n = `wrappingType` v = `Normal`
                    )->a( n = `text`         v = `Long text with "wrapping" set to "true" and "wrappingType" set to "Normal"`
                    )->a( n = `selected`     v = `true`
                )->tag( `RadioButton`
                    )->a( n = `width`        v = `120px`
                    )->a( n = `wrapping`     v = `true`
                    )->a( n = `wrappingType` v = `Hyphenated`
                    )->a( n = `text`         v = `Long text with "wrapping" set to "true" and "wrappingType" set to "Hyphenated"`

            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
