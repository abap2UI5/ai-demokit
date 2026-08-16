CLASS z2ui5_cl_smpc_app_090 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_090 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`
            )->ele( n = `content` ns = `l`
                )->tag( `Button`
                    )->a( n = `text`  v = `Show Dialog with Search`
                    )->a( n = `press` v = client->_event( `OPEN` )
                    )->a( n = `class` v = `sapUiSmallMarginBottom`

            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `OPEN`.
      " the original loads Dialog.fragment.xml and opens it - rebuilt 1:1 and shown via popup_display; its bindElement /ProductCollection/0 is a no-op (static content) and dropped
      DATA(popup) = z2ui5_cl_ui5_view_builder=>factory( ).
      popup->ele( n = `FragmentDefinition` ns = `core`
          )->a( n = `xmlns`      v = `sap.m`
          )->a( n = `xmlns:core` v = `sap.ui.core`
          )->ele( `Dialog`
              )->a( n = `title` v = `Dialog with Search`
              )->a( n = `class` v = `sapUiContentPadding`
              )->ele( `subHeader`
                  )->ele( `Toolbar`
                      )->tag( `SearchField`
                          )->a( n = `width` v = `90%`

                  )->end(
              )->end(
              )->ele( `content`
                  )->tag( `Text`
                      )->a( n = `width` v = `300px`
                      )->a( n = `text`  v = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna ` &&
                                           `aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est`

              )->end(
              )->ele( `beginButton`
                  )->tag( `Button`
                      )->a( n = `text`  v = `Close`
                      )->a( n = `press` v = client->follow_up_action( client->cs_event-popup_close )

              )->end(
          )->end( ).
      client->popup_display( popup->stringify( ) ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
