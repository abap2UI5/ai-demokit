" @keywords standardmargins standard margins sap.ui.core standardmarginscollapse panel text
" @summary See how adjacent margins collapse to a single margin.
CLASS z2ui5_cl_smpc_app_469 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_469 IMPLEMENTATION.

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

        )->ele( `Panel`
            )->a( n = `class` v = `sapUiSmallMarginBottom`

            )->ele( `content`
                )->tag( `Text`
                    )->a( n = `text` v = `This panel has a 16px (1rem) bottom margin.`

            )->end(
        )->end(

        )->ele( `Panel`
            )->a( n = `width` v = `auto`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->ele( `content`
                )->tag( `Text`
                    )->a( n = `text` v = `This panel has a 16px margin all around. As you can see, the margins do not add ` &&
                                         `to the margins of the bottom or top panel.`

            )->end(
        )->end(

        )->ele( `Panel`
            )->a( n = `class` v = `sapUiSmallMarginTop`

            )->ele( `content`
                )->tag( `Text`
                    )->a( n = `text` v = `This panel has a 16px top margin.` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
