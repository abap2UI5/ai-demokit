" @keywords standardmargins standard margins sap.ui.core standardmarginssinglesided panel text
" @summary Clear the space to the left, right, top or bottom of your control. Choose a size ('Tiny', 'Small', 'Medium' or 'Large', which stands for 8px (0.
CLASS z2ui5_cl_smpc_app_430 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_430 IMPLEMENTATION.

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
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `height`    v = `100%`

        )->ele( `Panel`
            )->a( n = `width` v = `auto`
            )->a( n = `class` v = `sapUiLargeMarginBegin sapUiLargeMarginBottom`

            )->ele( `content`
                )->tag( `Text`
                    )->a( n = `text`  v = `This panel uses margin classes 'sapUiLargeMarginBegin' and 'sapUiLargeMarginBottom' ` &&
                                          `to clear a 48px (3rem) space to the left and bottom.`
                    )->a( n = `class` v = `sapMH4FontSize`
                )->tag( `Text`
                    )->a( n = `text` v = `Since panels have a default width of 100%, horizontal margins are not displayed ` &&
                                         `appropriately. Therefore we need to set the panel's 'width' property to 'auto'.`

            )->end(
        )->end(

        )->tag( `Text`
            )->a( n = `text`  v = `To see what happens in Right-To-Left mode open 'Settings' by pressing the cog wheel ` &&
                                  `button next to 'Entities'.`
            )->a( n = `class` v = `sapUiExploredNoMarginInfo` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
