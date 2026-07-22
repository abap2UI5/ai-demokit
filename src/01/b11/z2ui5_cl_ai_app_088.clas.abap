CLASS z2ui5_cl_ai_app_088 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_088 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->leaf( `Text`
            )->a( n = `text`  v = `Panels below illustrate the four standard margin sizes 'tiny', 'small', 'medium' and 'large'.`
            )->a( n = `class` v = `sapUiExploredNoMarginInfo`

        )->open( `Panel`
            )->a( n = `width` v = `auto`
            )->a( n = `class` v = `sapUiTinyMargin`
            )->open( `content`
                )->leaf( `Text`
                    )->a( n = `text`  v = `This panel uses margin class 'sapUiTinyMargin' to clear a 8px (0.5rem) space all around.`
                    )->a( n = `class` v = `sapMH4FontSize`
                )->leaf( `Text`
                    )->a( n = `text` v = `Since panels have a default width of 100%, horizontal margins are not displayed appropriately. Therefore we need to set the panel's 'width' property to 'auto'.`

            )->shut(
        )->shut(

        )->open( `Panel`
            )->a( n = `width` v = `auto`
            )->a( n = `class` v = `sapUiSmallMargin`
            )->open( `content`
                )->leaf( `Text`
                    )->a( n = `text`  v = `This panel uses margin class 'sapUiSmallMargin' to clear a 16px (1rem) space all around.`
                    )->a( n = `class` v = `sapMH4FontSize`

            )->shut(
        )->shut(

        )->open( `Panel`
            )->a( n = `width` v = `auto`
            )->a( n = `class` v = `sapUiMediumMargin`
            )->open( `content`
                )->leaf( `Text`
                    )->a( n = `text`  v = `This panel uses margin class 'sapUiMediumMargin' to clear a 32px (2rem) space all around.`
                    )->a( n = `class` v = `sapMH4FontSize`

            )->shut(
        )->shut(

        )->open( `Panel`
            )->a( n = `width` v = `auto`
            )->a( n = `class` v = `sapUiLargeMargin`
            )->open( `content`
                )->leaf( `Text`
                    )->a( n = `text`  v = `This panel uses margin class 'sapUiLargeMargin' to clear a 48px (3rem) space all around.`
                    )->a( n = `class` v = `sapMH4FontSize`

            )->shut(
        )->shut(

        )->leaf( `Text`
            )->a( n = `text`  v = `Each of the panels above has a margin all around. Please notice that this margins do not add up. Instead, they 'collapse'.`
            )->a( n = `class` v = `sapUiExploredNoMarginInfo` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
