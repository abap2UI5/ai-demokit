CLASS z2ui5_cl_ai_app_069 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_069 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`
            )->leaf( `Label`
                )->a( n = `text`     v = `Default RadioButton use`
                )->a( n = `labelFor` v = `GroupA`
            )->open( `RadioButtonGroup`
                )->a( n = `id` v = `GroupA`
                )->leaf( `RadioButton`
                    )->a( n = `text`     v = `Option 1`
                    )->a( n = `selected` v = `true`
                )->leaf( `RadioButton`
                    )->a( n = `text` v = `Option 2`
                )->leaf( `RadioButton`
                    )->a( n = `text` v = `Option 3`
                )->leaf( `RadioButton`
                    )->a( n = `text` v = `Option 4`
                )->leaf( `RadioButton`
                    )->a( n = `text` v = `Option 5`

            )->shut(
        )->shut(

        )->open( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`
            )->leaf( `Label`
                )->a( n = `text` v = `RadioButton in various ValueState variants`
            )->open( `HBox`
                )->a( n = `class` v = `sapUiTinyMarginTopBottom`

                )->open( `VBox`
                    )->a( n = `class` v = `sapUiMediumMarginEnd`
                    )->leaf( `Label`
                        )->a( n = `text`     v = `Success`
                        )->a( n = `labelFor` v = `groupB`
                    )->open( `RadioButtonGroup`
                        )->a( n = `id`         v = `groupB`
                        )->a( n = `valueState` v = `Success`
                        )->leaf( `RadioButton`
                            )->a( n = `text`     v = `Option 1`
                            )->a( n = `selected` v = `true`
                        )->leaf( `RadioButton`
                            )->a( n = `text` v = `Option 2`

                    )->shut(
                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `sapUiMediumMarginEnd`
                    )->leaf( `Label`
                        )->a( n = `text`     v = `Error`
                        )->a( n = `labelFor` v = `groupC`
                    )->open( `RadioButtonGroup`
                        )->a( n = `id`         v = `groupC`
                        )->a( n = `valueState` v = `Error`
                        )->leaf( `RadioButton`
                            )->a( n = `text`     v = `Option 1`
                            )->a( n = `selected` v = `true`
                        )->leaf( `RadioButton`
                            )->a( n = `text` v = `Option 2`

                    )->shut(
                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `sapUiMediumMarginEnd`
                    )->leaf( `Label`
                        )->a( n = `text`     v = `Warning`
                        )->a( n = `labelFor` v = `groupD`
                    )->open( `RadioButtonGroup`
                        )->a( n = `id`         v = `groupD`
                        )->a( n = `valueState` v = `Warning`
                        )->leaf( `RadioButton`
                            )->a( n = `text`     v = `Option 1`
                            )->a( n = `selected` v = `true`
                        )->leaf( `RadioButton`
                            )->a( n = `text` v = `Option 2`

                    )->shut(
                )->shut(
                )->open( `VBox`
                    )->a( n = `class` v = `sapUiMediumMarginEnd`
                    )->leaf( `Label`
                        )->a( n = `text`     v = `Information`
                        )->a( n = `labelFor` v = `groupE`
                    )->open( `RadioButtonGroup`
                        )->a( n = `id`         v = `groupE`
                        )->a( n = `valueState` v = `Information`
                        )->leaf( `RadioButton`
                            )->a( n = `text`     v = `Option 1`
                            )->a( n = `selected` v = `true`
                        )->leaf( `RadioButton`
                            )->a( n = `text` v = `Option 2`

                    )->shut(
                )->shut(
            )->shut(
        )->shut(

        )->open( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`
            )->leaf( `Label`
                )->a( n = `text`     v = `RadioButton Wrapping`
                )->a( n = `labelFor` v = `groupF`
            )->open( `RadioButtonGroup`
                )->a( n = `id` v = `groupF`
                )->leaf( `RadioButton`
                    )->a( n = `width`        v = `240px`
                    )->a( n = `wrapping`     v = `true`
                    )->a( n = `wrappingType` v = `Normal`
                    )->a( n = `text`         v = `Long text with "wrapping" set to "true" and "wrappingType" set to "Normal"`
                    )->a( n = `selected`     v = `true`
                )->leaf( `RadioButton`
                    )->a( n = `width`        v = `120px`
                    )->a( n = `wrapping`     v = `true`
                    )->a( n = `wrappingType` v = `Hyphenated`
                    )->a( n = `text`         v = `Long text with "wrapping" set to "true" and "wrappingType" set to "Hyphenated"`

            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
