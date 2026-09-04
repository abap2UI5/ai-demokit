" @keywords bar sap.m header sub footer bars button overflowtoolbar searchfield vbox text toolbarspacer
" @summary Each screen of a mobile application is typically represented by a 'Page' consisting of a header, a scrollable content area and optionally a footer. The standard header offers a navigation button and a title.
CLASS z2ui5_cl_smpc_app_002 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_002 IMPLEMENTATION.

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

        )->ele( `Page`
            )->a( n = `title`         v = `Title`
            )->a( n = `class`         v = `sapUiContentPadding sapUiResponsivePadding--header sapUiResponsivePadding--subHeader sapUiResponsivePadding--content sapUiResponsivePadding--footer`
            )->a( n = `showNavButton` v = `true`

            )->ele( `headerContent`
                )->tag( `Button`
                    )->a( n = `icon`    v = `sap-icon://action`
                    )->a( n = `tooltip` v = `Share`

            )->end(
            )->ele( `subHeader`
                )->ele( `OverflowToolbar`
                    )->tag( `SearchField`

                )->end(
            )->end(
            )->ele( `content`
                )->ele( `VBox`
                    )->tag( `Text`
                        )->a( n = `text`
                                 v = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
                                     `At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ` &&
                                     `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
                                     `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat`

                )->end(
            )->end(
            )->ele( `footer`
                )->ele( `OverflowToolbar`
                    )->tag( `ToolbarSpacer`
                    )->tag( `Button`
                        )->a( n = `text` v = `Accept`
                        )->a( n = `type` v = `Accept`
                    )->tag( `Button`
                        )->a( n = `text` v = `Reject`
                        )->a( n = `type` v = `Reject`
                    )->tag( `Button`
                        )->a( n = `text` v = `Edit`
                    )->tag( `Button`
                        )->a( n = `text` v = `Delete`

                )->end(
            )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
