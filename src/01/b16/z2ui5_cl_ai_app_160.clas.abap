CLASS z2ui5_cl_ai_app_160 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_160 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " handleLinkPress opens MessageBox.alert('Link was clicked!'); the framework
    " expresses that 1:1 (client->message_box_display), so both wired Links go
    " through a backend event rather than being reduced to a toast
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
                    )->a( n = `press` v = client->_event( `LINK_PRESSED` )
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
                    " endIcon is @since 1.128 - kept 1:1 (POST_171)
                    )->a( n = `endIcon` v = `sap-icon://inspect`
                    )->a( n = `press`   v = client->_event( `LINK_PRESSED` )
                )->leaf( `Link`
                    )->a( n = `text`    v = `Disabled link with icon`
                    " icon is @since 1.128 - kept 1:1 (POST_171)
                    )->a( n = `icon`    v = `sap-icon://cart`
                    )->a( n = `enabled` v = `false`
                )->leaf( `Link`
                    )->a( n = `text` v = `Open SAP Homepage`
                    )->a( n = `icon` v = `sap-icon://globe`
                    )->a( n = `href` v = `http://www.sap.com` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `LINK_PRESSED`.
        " MessageBox.alert( ) - type 'alert' with the original's text, verbatim
        client->message_box_display( text = `Link was clicked!`
                                     type = `alert` ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
