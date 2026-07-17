CLASS z2ui5_cl_api_app_460 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_460 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_api_xml.
    DATA temp1 TYPE string_table.
    view = z2ui5_cl_api_xml=>factory( ).

    " binding {/ProductCollection/0} + field bindings resolved to literals (see NOTES)
    
    CLEAR temp1.
    INSERT `http://www.sap.com` INTO TABLE temp1.
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `ObjectHeader`
            )->a( n = `title`      v = `Notebook Basic 15`
            )->a( n = `number`     v = `956.00`
            )->a( n = `numberUnit` v = `EUR`
            )->a( n = `class`      v = `sapUiResponsivePadding--header`

            )->open( `statuses`
                )->leaf( `ObjectStatus`
                    )->a( n = `text`  v = `Some Damaged`
                    )->a( n = `state` v = `Error`
                )->leaf( `ObjectStatus`
                    )->a( n = `text`  v = `In Stock`
                    )->a( n = `state` v = `Success`

            )->shut(

            )->leaf( `ObjectAttribute`
                )->a( n = `text` v = `4.2 KG`
            )->leaf( `ObjectAttribute`
                )->a( n = `text` v = `30 x 18 x 3 cm`
            )->leaf( `ObjectAttribute`
                )->a( n = `text` v = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`
            )->leaf( `ObjectAttribute`
                )->a( n = `text`   v = `www.sap.com`
                )->a( n = `active` v = `true`
                )->a( n = `press`  v = client->_event_client( val   = client->cs_event-open_new_tab
                                                              t_arg = temp1 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
