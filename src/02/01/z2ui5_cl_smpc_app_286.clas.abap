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
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    DATA temp3 TYPE string_table.
    DATA temp4 TYPE string_table.
    DATA temp5 TYPE string_table.
    DATA temp6 TYPE string_table.
    DATA temp7 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " every Link toasts its own text; the original composes that on the client
    " (MessageToast.show(evt.getSource().getText() + ' has been clicked')), so
    " the port keeps it there - roundtrip-free, the text comes from the source
    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `{0} has been clicked` INTO TABLE temp1.
    INSERT `${$source>/text}` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `MESSAGE_TOAST` INTO TABLE temp2.
    INSERT `show` INTO TABLE temp2.
    INSERT `{0} has been clicked` INTO TABLE temp2.
    INSERT `${$source>/text}` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `MESSAGE_TOAST` INTO TABLE temp3.
    INSERT `show` INTO TABLE temp3.
    INSERT `{0} has been clicked` INTO TABLE temp3.
    INSERT `${$source>/text}` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `MESSAGE_TOAST` INTO TABLE temp4.
    INSERT `show` INTO TABLE temp4.
    INSERT `{0} has been clicked` INTO TABLE temp4.
    INSERT `${$source>/text}` INTO TABLE temp4.
    
    CLEAR temp5.
    INSERT `MESSAGE_TOAST` INTO TABLE temp5.
    INSERT `show` INTO TABLE temp5.
    INSERT `{0} has been clicked` INTO TABLE temp5.
    INSERT `${$source>/text}` INTO TABLE temp5.
    
    CLEAR temp6.
    INSERT `MESSAGE_TOAST` INTO TABLE temp6.
    INSERT `show` INTO TABLE temp6.
    INSERT `{0} has been clicked` INTO TABLE temp6.
    INSERT `${$source>/text}` INTO TABLE temp6.
    
    CLEAR temp7.
    INSERT `MESSAGE_TOAST` INTO TABLE temp7.
    INSERT `show` INTO TABLE temp7.
    INSERT `{0} has been clicked` INTO TABLE temp7.
    INSERT `${$source>/text}` INTO TABLE temp7.
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
                                                                    t_arg = temp1 )
                )->tag( `Link`
                    )->a( n = `text`  v = `Page 1`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                    t_arg = temp2 )
                )->tag( `Link`
                    )->a( n = `text`  v = `Page 2`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                    t_arg = temp3 )
                )->tag( `Link`
                    )->a( n = `text`  v = `Page 3`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                    t_arg = temp4 )
                )->tag( `Link`
                    )->a( n = `text`  v = `Page 4`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                    t_arg = temp5 )
                )->tag( `Link`
                    )->a( n = `text`  v = `Page 5`
                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                    t_arg = temp6 )

                )->ele( `currentLocation`
                    )->tag( `Link`
                        )->a( n = `text`  v = `Page 6`
                        )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                        t_arg = temp7 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
