CLASS z2ui5_cl_ai_app_198 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_198 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `List`
            )->a( n = `headerText` v = `Products`

            )->open( `ObjectListItem`
                )->a( n = `title`      v = `Gladiator MX`
                )->a( n = `type`       v = `Active`
                " the controller's MessageToast.show("Pressed : " + getSource().getTitle()) is composed roundtrip-free on the client
                )->a( n = `press`      v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Pressed : {0}` ) ( `${$source>/title}` ) ) )
                )->a( n = `number`     v = `87.50`
                )->a( n = `numberUnit` v = `EUR`

                )->open( `firstStatus`
                    )->leaf( `ObjectStatus`
                        )->a( n = `text`  v = `Available`
                        )->a( n = `state` v = `Success`

                )->shut(
                )->leaf( `ObjectAttribute`
                    )->a( n = `text` v = `125 g`
                )->leaf( `ObjectAttribute`
                    )->a( n = `text` v = `145 x 140 x 360 cm`

                )->open( `markers`
                    )->leaf( `ObjectMarker`
                        )->a( n = `type` v = `Favorite`
                    )->leaf( `ObjectMarker`
                        )->a( n = `type` v = `Flagged`

                )->shut(
            )->shut(
            )->open( `ObjectListItem`
                )->a( n = `title`      v = `Hurricane GX`
                )->a( n = `type`       v = `Active`
                )->a( n = `press`      v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Pressed : {0}` ) ( `${$source>/title}` ) ) )
                )->a( n = `number`     v = `235`
                )->a( n = `numberUnit` v = `EUR`

                )->open( `firstStatus`
                    )->leaf( `ObjectStatus`
                        )->a( n = `text`  v = `Out of stock`
                        )->a( n = `state` v = `Warning`

                )->shut(
                )->leaf( `ObjectAttribute`
                    )->a( n = `text` v = `34 g`
                )->leaf( `ObjectAttribute`
                    )->a( n = `text` v = `45 x 14 x 36 cm`

                )->open( `markers`
                    )->leaf( `ObjectMarker`
                        )->a( n = `type` v = `Flagged`
                    )->leaf( `ObjectMarker`
                        )->a( n = `type` v = `Locked`

                )->shut(
            )->shut(
            )->open( `ObjectListItem`
                )->a( n = `title`      v = `Power Projector 4713`
                )->a( n = `type`       v = `Active`
                )->a( n = `press`      v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Pressed : {0}` ) ( `${$source>/title}` ) ) )
                )->a( n = `number`     v = `135`
                )->a( n = `numberUnit` v = `EUR`

                )->open( `firstStatus`
                    )->leaf( `ObjectStatus`
                        )->a( n = `text`  v = `Discontinued`
                        )->a( n = `state` v = `Error`

                )->shut(
                )->leaf( `ObjectAttribute`
                    )->a( n = `text` v = `67 g`
                )->leaf( `ObjectAttribute`
                    )->a( n = `text` v = `425 x 35 x 30 cm`

                )->open( `markers`
                    )->leaf( `ObjectMarker`
                        )->a( n = `type` v = `Favorite`
                    )->leaf( `ObjectMarker`
                        )->a( n = `type` v = `Locked`
                    )->leaf( `ObjectMarker`
                        )->a( n = `type` v = `Draft`

                )->shut(
            )->shut(
            )->open( `ObjectListItem`
                )->a( n = `title`      v = `Webcam`
                )->a( n = `type`       v = `Active`
                )->a( n = `press`      v = client->_event_client( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Pressed : {0}` ) ( `${$source>/title}` ) ) )
                )->a( n = `number`     v = `15`
                )->a( n = `numberUnit` v = `EUR`

                )->open( `firstStatus`
                    )->leaf( `ObjectStatus`
                        )->a( n = `text` v = `New`

                )->shut(
                )->leaf( `ObjectAttribute`
                    )->a( n = `text` v = `67 g`
                )->leaf( `ObjectAttribute`
                    )->a( n = `text` v = `15 x 15 x 10 cm`

                )->open( `markers`
                    )->leaf( `ObjectMarker`
                        )->a( n = `type` v = `Unsaved` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
