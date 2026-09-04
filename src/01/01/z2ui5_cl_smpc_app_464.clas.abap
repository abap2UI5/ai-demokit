" @keywords standardmargins standard margins sap.ui.core standardmarginstwosided text panel
" @summary Clear the space to the left and right, top and bottom of your control.
CLASS z2ui5_cl_smpc_app_464 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_464 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->tag( `Text`
            )->a( n = `text`  v = `This sample demonstrates convenience classes which let you set a margin at two opposite ` &&
                                  `sides (top/bottom and begin/end).`
            )->a( n = `class` v = `sapUiExploredNoMarginInfo`

        )->ele( `Panel`
            )->a( n = `class` v = `sapUiMediumMarginTopBottom`

            )->ele( `content`
                )->tag( `Text`
                    )->a( n = `text`  v = `This panel uses margin class 'sapUiMediumMarginTopBottom' to clear a 32px (2rem) ` &&
                                          `space at the panel's top and bottom.`
                    )->a( n = `class` v = `sapMH4FontSize`
                )->tag( `Text`
                    )->a( n = `text` v = `Since we do not apply horizontal margins in this case, we do not need to reset the ` &&
                                         `panel's default width in this case. Therefore it is NOT necessary to set the modify ` &&
                                         `the panel's 'width' property.`

            )->end(
        )->end(

        )->ele( `Panel`
            )->a( n = `width` v = `auto`
            )->a( n = `class` v = `sapUiMediumMarginBeginEnd`

            )->ele( `content`
                )->tag( `Text`
                    )->a( n = `text`  v = `This panel uses margin class 'sapUiMediumMarginBeginEnd' to clear a 32px space at ` &&
                                          `the panel's left and right side.`
                    )->a( n = `class` v = `sapMH4FontSize`
                )->tag( `Text`
                    )->a( n = `text` v = `Since we do apply horizontal margins in this case, we have to set the panel's width to 'auto'.` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
