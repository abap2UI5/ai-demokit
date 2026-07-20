CLASS z2ui5_cl_ai_app_002 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_002 IMPLEMENTATION.

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

        )->open( `Page`
            )->a( n = `title`         v = `Title`
            )->a( n = `class`         v = `sapUiContentPadding sapUiResponsivePadding--header sapUiResponsivePadding--subHeader sapUiResponsivePadding--content sapUiResponsivePadding--footer`
            )->a( n = `showNavButton` v = `true`

            )->open( `headerContent`
                )->leaf( `Button`
                    )->a( n = `icon`    v = `sap-icon://action`
                    )->a( n = `tooltip` v = `Share`

            )->shut(
            )->open( `subHeader`
                )->open( `OverflowToolbar`
                    )->leaf( `SearchField`

                )->shut(
            )->shut(
            )->open( `content`
                )->open( `VBox`
                    )->leaf( `Text`
                        )->a( n = `text`
                                 v = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
                                     `At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ` &&
                                     `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
                                     `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat`

                )->shut(
            )->shut(
            )->open( `footer`
                )->open( `OverflowToolbar`
                    )->leaf( `ToolbarSpacer`
                    )->leaf( `Button`
                        )->a( n = `text` v = `Accept`
                        )->a( n = `type` v = `Accept`
                    )->leaf( `Button`
                        )->a( n = `text` v = `Reject`
                        )->a( n = `type` v = `Reject`
                    )->leaf( `Button`
                        )->a( n = `text` v = `Edit`
                    )->leaf( `Button`
                        )->a( n = `text` v = `Delete`

                )->shut(
            )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
