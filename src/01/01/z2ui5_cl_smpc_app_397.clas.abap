CLASS z2ui5_cl_smpc_app_397 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_397 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " fixed value of the original img JSONModel (img>/products/pic1)
    DATA(pic1) = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7777-large.jpg`.

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `Panel`
            )->a( n = `width`          v = `auto`
            )->a( n = `class`          v = `sapUiResponsiveMargin`
            )->a( n = `accessibleRole` v = `Region`

            )->ele( `headerToolbar`
                )->ele( `OverflowToolbar`
                    )->tag( `Title`
                        )->a( n = `text` v = `Panel with picture`

                )->end(
            )->end(

            )->ele( `content`
                )->ele( n = `HorizontalLayout` ns = `l`
                    )->tag( `Image`
                        )->a( n = `src`   v = pic1
                        )->a( n = `width` v = `10em`

                )->end(

                )->tag( `Text`
                    )->a( n = `text`
                             v = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam ` &&
                                 `voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ` &&
                                 `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam ` &&
                                 `voluptua. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat`

            )->end(
        )->end(

        )->ele( `Panel`
            )->a( n = `width` v = `auto`
            )->a( n = `class` v = `sapUiResponsiveMargin`

            )->ele( `headerToolbar`
                )->ele( `OverflowToolbar`
                    )->tag( `Title`
                        )->a( n = `text` v = `Header`
                    )->tag( `ToolbarSpacer`
                    )->tag( `Button`
                        )->a( n = `icon` v = `sap-icon://settings`
                    )->tag( `Button`
                        )->a( n = `icon` v = `sap-icon://drop-down-list`

                )->end(
            )->end(

            )->ele( `content`
                )->tag( `Text`
                    )->a( n = `text`
                             v = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam ` &&
                                 `voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ` &&
                                 `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam ` &&
                                 `voluptua. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
