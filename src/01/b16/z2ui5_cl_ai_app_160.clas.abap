CLASS z2ui5_cl_ai_app_160 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_160 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " handleLinkPress opens a MessageBox in the original; here a client toast
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->open( n = `content` ns = `l`
                )->leaf( `Link`
                    )->a( n = `text`  v = `Open message box`
                    )->a( n = `press` v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Link pressed` ) ) )
                )->leaf( `Link`
                    )->a( n = `text`    v = `Disabled link`
                    )->a( n = `enabled` v = `false`
                )->leaf( `Link`
                    )->a( n = `text`   v = `Open SAP Homepage`
                    )->a( n = `target` v = `_blank`
                    )->a( n = `href`   v = `http://www.sap.com`

        )->shut(

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->open( n = `content` ns = `l`
                )->leaf( `Label`
                    )->a( n = `text`     v = `Links with Icons`
                    )->a( n = `design`   v = `Bold`
                    )->a( n = `wrapping` v = `true`
                    )->a( n = `class`    v = `sapUiSmallMarginTop`
                )->leaf( `Link`
                    )->a( n = `text`    v = `Show more information`
                    )->a( n = `endIcon` v = `sap-icon://inspect`
                    )->a( n = `press`   v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Link pressed` ) ) )
                )->leaf( `Link`
                    )->a( n = `text`    v = `Disabled link with icon`
                    )->a( n = `icon`    v = `sap-icon://cart`
                    )->a( n = `enabled` v = `false`
                )->leaf( `Link`
                    )->a( n = `text` v = `Open SAP Homepage`
                    )->a( n = `icon` v = `sap-icon://globe`
                    )->a( n = `href` v = `http://www.sap.com` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
