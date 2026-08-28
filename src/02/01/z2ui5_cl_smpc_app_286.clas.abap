" @keywords breadcrumbs sap.m breadcrumbswithcurrentpagelink verticallayout title link
" @summary Breadcrumbs sample with current page set as aggregation, resulting in a link
CLASS z2ui5_cl_smpc_app_286 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_286 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " every Link toasts its own text; the original composes that on the client
    " (MessageToast.show(evt.getSource().getText() + ' has been clicked')), so
    " the port keeps it there - roundtrip-free, the text comes from the source
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->tag( `Title`
                )->a( n = `text` v = `Breadcrumbs with current page aggregation set`

            )->ele( `Breadcrumbs`

                )->tag( `Link`
                    )->a( n = `text`  v = `Home`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                    t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} has been clicked` ) ( `${$source>/text}` ) ) )
                )->tag( `Link`
                    )->a( n = `text`  v = `Page 1`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                    t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} has been clicked` ) ( `${$source>/text}` ) ) )
                )->tag( `Link`
                    )->a( n = `text`  v = `Page 2`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                    t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} has been clicked` ) ( `${$source>/text}` ) ) )
                )->tag( `Link`
                    )->a( n = `text`  v = `Page 3`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                    t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} has been clicked` ) ( `${$source>/text}` ) ) )
                )->tag( `Link`
                    )->a( n = `text`  v = `Page 4`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                    t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} has been clicked` ) ( `${$source>/text}` ) ) )
                )->tag( `Link`
                    )->a( n = `text`  v = `Page 5`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                    t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} has been clicked` ) ( `${$source>/text}` ) ) )

                )->ele( `currentLocation`
                    )->tag( `Link`
                        )->a( n = `text`  v = `Page 6`
                        )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                        t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} has been clicked` ) ( `${$source>/text}` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
