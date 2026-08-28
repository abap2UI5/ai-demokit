" @keywords standardmargins standard margins sap.ui.core standardmarginsresponsive panel text
" @summary Clear the space around your control, where the margin depends on the device your are using.
CLASS z2ui5_cl_smpc_app_472 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_472 IMPLEMENTATION.

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

        )->ele( `Panel`
            )->a( n = `width` v = `auto`
            )->a( n = `class` v = `sapUiResponsiveMargin`

            )->ele( `content`
                )->tag( `Text`
                    )->a( n = `text` v = `All panels on this page use css class 'sapUiResponsiveMargin' to clear space all around, depending on the ` &&
                                         `available width.`

            )->end(
        )->end(

        )->ele( `Panel`
            )->a( n = `width` v = `auto`
            )->a( n = `class` v = `sapUiResponsiveMargin`

            )->ele( `content`
                )->tag( `Text`
                    )->a( n = `text` v = `Please resize the browser window and/or use the 'Full Screen' button to see how the margins change.`

            )->end(
        )->end(

        )->ele( `Panel`
            )->a( n = `width` v = `auto`
            )->a( n = `class` v = `sapUiResponsiveMargin`

            )->ele( `content`
                )->tag( `Text`
                    )->a( n = `text` v = `Since panels have a default width of 100%, horizontal margins are not displayed appropriately.`

            )->end(
        )->end(

        )->ele( `Panel`
            )->a( n = `width` v = `auto`
            )->a( n = `class` v = `sapUiResponsiveMargin`

            )->ele( `content`
                )->tag( `Text`
                    )->a( n = `text` v = `Therefore we need to set each panel's 'width' property to 'auto'.`

            )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
