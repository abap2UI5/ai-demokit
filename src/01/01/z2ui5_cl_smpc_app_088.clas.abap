" @keywords standardmargins standard margins sap.ui.core margin classes text panel
" @summary Use standard margin classes 'sapUiTinyMargin', 'sapUiSmallMargin', 'sapUiMediumMargin' or 'sapUiLargeMargin' to add a 8px (0.5rem), 16px (1rem), 32px (2rem) or 48px (3rem) margin to your control.
CLASS z2ui5_cl_smpc_app_088 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_088 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->tag( `Text`
            )->a( n = `text`  v = `Panels below illustrate the four standard margin sizes 'tiny', 'small', 'medium' and 'large'.`
            )->a( n = `class` v = `sapUiExploredNoMarginInfo`

        )->ele( `Panel`
            )->a( n = `width` v = `auto`
            )->a( n = `class` v = `sapUiTinyMargin`
            )->ele( `content`
                )->tag( `Text`
                    )->a( n = `text`  v = `This panel uses margin class 'sapUiTinyMargin' to clear a 8px (0.5rem) space all around.`
                    )->a( n = `class` v = `sapMH4FontSize`
                )->tag( `Text`
                    )->a( n = `text` v = `Since panels have a default width of 100%, horizontal margins are not displayed appropriately. Therefore we need to set the panel's 'width' property to 'auto'.`

            )->end(
        )->end(

        )->ele( `Panel`
            )->a( n = `width` v = `auto`
            )->a( n = `class` v = `sapUiSmallMargin`
            )->ele( `content`
                )->tag( `Text`
                    )->a( n = `text`  v = `This panel uses margin class 'sapUiSmallMargin' to clear a 16px (1rem) space all around.`
                    )->a( n = `class` v = `sapMH4FontSize`

            )->end(
        )->end(

        )->ele( `Panel`
            )->a( n = `width` v = `auto`
            )->a( n = `class` v = `sapUiMediumMargin`
            )->ele( `content`
                )->tag( `Text`
                    )->a( n = `text`  v = `This panel uses margin class 'sapUiMediumMargin' to clear a 32px (2rem) space all around.`
                    )->a( n = `class` v = `sapMH4FontSize`

            )->end(
        )->end(

        )->ele( `Panel`
            )->a( n = `width` v = `auto`
            )->a( n = `class` v = `sapUiLargeMargin`
            )->ele( `content`
                )->tag( `Text`
                    )->a( n = `text`  v = `This panel uses margin class 'sapUiLargeMargin' to clear a 48px (3rem) space all around.`
                    )->a( n = `class` v = `sapMH4FontSize`

            )->end(
        )->end(

        )->tag( `Text`
            )->a( n = `text`  v = `Each of the panels above has a margin all around. Please notice that this margins do not add up. Instead, they 'collapse'.`
            )->a( n = `class` v = `sapUiExploredNoMarginInfo` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
