"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.Panel - PanelExpanded
"! https://sdk.openui5.org/entity/sap.m.Panel/sample/sap.m.sample.PanelExpanded
"! NOTES (generation):
"! - IMPROVISED: the original controller toggles the third panel imperatively
"!   (onOverflowToolbarPress -> oPanel.setExpanded(!oPanel.getExpanded())). It is
"!   reproduced with a two-way bound `expanded` property plus a TOOLBAR_PRESSED
"!   event that flips it - the view therefore carries an `expanded` binding and a
"!   `press` the original view.xml does not have.
CLASS z2ui5_cl_api_app_471 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA expanded TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_471 IMPLEMENTATION.

  METHOD view_display.

    " placeholder text reused by all three panels of the original sample
    DATA(lorem) = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
      `At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ` &&
      `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
      `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat`.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `Panel`
            )->a( n = `expandable` v = `true`
            )->a( n = `headerText` v = `Panel with a header text`
            )->a( n = `width`      v = `auto`
            )->a( n = `class`      v = `sapUiResponsiveMargin`

            )->open( `content`
                )->leaf( `Text`
                    )->a( n = `text` v = lorem

            )->shut(
        )->shut(
        )->open( `Panel`
            )->a( n = `expandable` v = `true`
            )->a( n = `width`      v = `auto`
            )->a( n = `class`      v = `sapUiResponsiveMargin`

            )->open( `headerToolbar`
                )->open( `OverflowToolbar`
                    )->a( n = `style` v = `Clear`

                    )->leaf( `Title`
                        )->a( n = `text` v = `Custom Toolbar with a header text`
                    )->leaf( `ToolbarSpacer`
                    )->leaf( `Button`
                        )->a( n = `icon` v = `sap-icon://settings`
                    )->leaf( `Button`
                        )->a( n = `icon` v = `sap-icon://drop-down-list`

                )->shut(
            )->shut(
            )->open( `content`
                )->leaf( `Text`
                    )->a( n = `text` v = lorem

            )->shut(
        )->shut(
        )->open( `Panel`
            )->a( n = `id`         v = `expandablePanel`
            )->a( n = `expandable` v = `true`
            " original: onOverflowToolbarPress toggles the panel's expanded state
            )->a( n = `expanded`   v = client->_bind_edit( expanded )
            )->a( n = `width`      v = `auto`
            )->a( n = `class`      v = `sapUiResponsiveMargin`

            )->open( `headerToolbar`
                )->open( `OverflowToolbar`
                    )->a( n = `active` v = `true`
                    )->a( n = `press`  v = client->_event( `TOOLBAR_PRESSED` )

                    )->leaf( `Title`
                        )->a( n = `text` v = `Clickable Custom Toolbar with a header text`
                    )->leaf( `ToolbarSpacer`
                    )->leaf( `Button`
                        )->a( n = `icon` v = `sap-icon://settings`
                    )->leaf( `Button`
                        )->a( n = `icon` v = `sap-icon://drop-down-list`

                )->shut(
            )->shut(
            )->open( `content`
                )->leaf( `Text`
                    )->a( n = `text` v = lorem ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `TOOLBAR_PRESSED`.
        expanded = xsdbool( expanded = abap_false ).
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
