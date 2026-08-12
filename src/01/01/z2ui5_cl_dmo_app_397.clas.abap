CLASS z2ui5_cl_dmo_app_397 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_397 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " fixed value of the original img JSONModel (img>/products/pic1)
    DATA(pic1) = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7777-large.jpg`.

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( `Panel`
            )->a( n = `width`          v = `auto`
            )->a( n = `class`          v = `sapUiResponsiveMargin`
            )->a( n = `accessibleRole` v = `Region`

            )->open( `headerToolbar`
                )->open( `OverflowToolbar`
                    )->leaf( `Title`
                        )->a( n = `text` v = `Panel with picture`

                )->shut(
            )->shut(

            )->open( `content`
                )->open( n = `HorizontalLayout` ns = `l`
                    )->leaf( `Image`
                        )->a( n = `src`   v = pic1
                        )->a( n = `width` v = `10em`

                )->shut(

                )->leaf( `Text`
                    )->a( n = `text`
                             v = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam ` &&
                                 `voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ` &&
                                 `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam ` &&
                                 `voluptua. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat`

            )->shut(
        )->shut(

        )->open( `Panel`
            )->a( n = `width` v = `auto`
            )->a( n = `class` v = `sapUiResponsiveMargin`

            )->open( `headerToolbar`
                )->open( `OverflowToolbar`
                    )->leaf( `Title`
                        )->a( n = `text` v = `Header`
                    )->leaf( `ToolbarSpacer`
                    )->leaf( `Button`
                        )->a( n = `icon` v = `sap-icon://settings`
                    )->leaf( `Button`
                        )->a( n = `icon` v = `sap-icon://drop-down-list`

                )->shut(
            )->shut(

            )->open( `content`
                )->leaf( `Text`
                    )->a( n = `text`
                             v = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam ` &&
                                 `voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ` &&
                                 `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam ` &&
                                 `voluptua. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
