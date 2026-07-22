CLASS z2ui5_cl_ai_app_090 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_090 IMPLEMENTATION.

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

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`
            )->open( n = `content` ns = `l`
                )->leaf( `Button`
                    )->a( n = `text`  v = `Show Dialog with Search`
                    )->a( n = `press` v = client->_event( `OPEN` )
                    )->a( n = `class` v = `sapUiSmallMarginBottom`

            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `OPEN`.
        DATA(popup) = z2ui5_cl_ai_xml=>factory( ).
        popup->open( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core`
            )->open( `Dialog`
                )->a( n = `title` v = `Dialog with Search`
                )->a( n = `class` v = `sapUiContentPadding`
                )->open( `subHeader`
                    )->open( `Toolbar`
                        )->leaf( `SearchField`
                            )->a( n = `width` v = `90%`

                    )->shut(
                )->shut(
                )->open( `content`
                    )->leaf( `Text`
                        )->a( n = `width` v = `300px`
                        )->a( n = `text`  v = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna ` &&
                                             `aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est`

                )->shut(
                )->open( `beginButton`
                    )->leaf( `Button`
                        )->a( n = `text`  v = `Close`
                        )->a( n = `press` v = client->_event_client( client->cs_event-popup_close )

                )->shut(
            )->shut( ).
        client->popup_display( popup->stringify( ) ).
    ENDCASE.

  ENDMETHOD.

ENDCLASS.
