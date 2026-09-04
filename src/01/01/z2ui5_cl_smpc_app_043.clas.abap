" @keywords panel sap.m panels possibility expand col text overflowtoolbar title toolbarspacer button
" @summary Panels also have the possibility to expand/collapse their content (including the infoToolbar if available). [since rel. 1.22]
CLASS z2ui5_cl_smpc_app_043 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.
    " two-way bound to the third panel's expanded property (original:
    " oPanel.setExpanded(!oPanel.getExpanded())) - PUBLIC, because only
    " public attributes are serialized into the model; bound as PROTECTED
    " it fails the first roundtrip with BINDING_ERROR (caught by the e2e
    " interaction that closed this port's LIVE_TEST, 2026-08-04)
    DATA expanded TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_043 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " placeholder text reused by all three panels of the original sample
    DATA lorem TYPE string.
    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    lorem = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
      `At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. ` &&
      `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. ` &&
      `Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat`.

    
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->ele( `Panel`
            )->a( n = `expandable` v = `true`
            )->a( n = `headerText` v = `Panel with a header text`
            )->a( n = `width`      v = `auto`
            )->a( n = `class`      v = `sapUiResponsiveMargin`

            )->ele( `content`
                )->tag( `Text`
                    )->a( n = `text` v = lorem

            )->end(
        )->end(
        )->ele( `Panel`
            )->a( n = `expandable` v = `true`
            )->a( n = `width`      v = `auto`
            )->a( n = `class`      v = `sapUiResponsiveMargin`

            )->ele( `headerToolbar`
                )->ele( `OverflowToolbar`
                    )->a( n = `style` v = `Clear`

                    )->tag( `Title`
                        )->a( n = `text` v = `Custom Toolbar with a header text`
                    )->tag( `ToolbarSpacer`
                    )->tag( `Button`
                        )->a( n = `icon` v = `sap-icon://settings`
                    )->tag( `Button`
                        )->a( n = `icon` v = `sap-icon://drop-down-list`

                )->end(
            )->end(
            )->ele( `content`
                )->tag( `Text`
                    )->a( n = `text` v = lorem

            )->end(
        )->end(
        )->ele( `Panel`
            )->a( n = `id`         v = `expandablePanel`
            )->a( n = `expandable` v = `true`
            )->a( n = `expanded`   v = client->_bind( expanded )
            )->a( n = `width`      v = `auto`
            )->a( n = `class`      v = `sapUiResponsiveMargin`

            )->ele( `headerToolbar`
                )->ele( `OverflowToolbar`
                    )->a( n = `active` v = `true`
                    )->a( n = `press`  v = client->_event( `TOOLBAR_PRESSED` )

                    )->tag( `Title`
                        )->a( n = `text` v = `Clickable Custom Toolbar with a header text`
                    )->tag( `ToolbarSpacer`
                    )->tag( `Button`
                        )->a( n = `icon` v = `sap-icon://settings`
                    )->tag( `Button`
                        )->a( n = `icon` v = `sap-icon://drop-down-list`

                )->end(
            )->end(
            )->ele( `content`
                )->tag( `Text`
                    )->a( n = `text` v = lorem ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
      DATA temp1 TYPE xsdboolean.

    IF client->get_event( ) = `TOOLBAR_PRESSED`.
      " original: oPanel.setExpanded(!oPanel.getExpanded()). Panel.expanded is
      " a bindable property, so the flag is bound two-way and only flipped
      " here - no frontend action, and the state survives a view rebuild
      
      temp1 = boolc( expanded = abap_false ).
      expanded = temp1.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
