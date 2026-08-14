CLASS z2ui5_cl_smpc_app_237 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_modeldata,
             product        TYPE string,
             type           TYPE string,
             additionalinfo TYPE string,
           END OF ty_s_modeldata.
    DATA t_modeldata TYPE STANDARD TABLE OF ty_s_modeldata WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_237 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `Table`
            )->a( n = `id`    v = `idProductsTable`
            )->a( n = `items` v = client->_bind( t_modeldata )

            )->ele( `columns`
                )->ele( `Column`
                    )->tag( `Text`
                        )->a( n = `text` v = `Products`

                )->end(
                )->ele( `Column`
                    )->tag( `Text`
                        )->a( n = `text` v = `Status`

                )->end(
                )->ele( `Column`
                    )->tag( `Text`
                        )->a( n = `text` v = `Status (active)`

            )->end(
            )->end(
            )->ele( `ColumnListItem`
                )->tag( `ObjectIdentifier`
                    )->a( n = `text` v = `{PRODUCT}`

                )->tag( `ObjectMarker`
                    )->a( n = `type`           v = `{TYPE}`
                    )->a( n = `additionalInfo` v = `{ADDITIONALINFO}`

                " the original onPress does MessageToast.show( evt.getParameter( "type" ) + " marker pressed!" );
                " reproduced roundtrip-free as a client-composed toast, {0} filled by the press event's type parameter
                )->tag( `ObjectMarker`
                    )->a( n = `type`           v = `{TYPE}`
                    )->a( n = `additionalInfo` v = `{ADDITIONALINFO}`
                    )->a( n = `press`          v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} marker pressed!` ) ( `${$parameters>/type}` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    t_modeldata = VALUE #(
      ( product = `Power Projector 4713`     type = `Locked`   additionalinfo = `` )
      ( product = `Power Projector 4713`     type = `LockedBy` additionalinfo = `John Doe` )
      ( product = `Power Projector 4713`     type = `LockedBy` additionalinfo = `` )
      ( product = `Gladiator MX`             type = `Draft`    additionalinfo = `` )
      ( product = `Hurricane GX`             type = `Unsaved`  additionalinfo = `` )
      ( product = `Hurricane GX`             type = `UnsavedBy` additionalinfo = `John Doe` )
      ( product = `Hurricane GX`             type = `UnsavedBy` additionalinfo = `` )
      ( product = `Hurricane GX`             type = `Unsaved`  additionalinfo = `` )
      ( product = `Webcam`                   type = `Favorite` additionalinfo = `` )
      ( product = `Deskjet Super Highspeed`  type = `Flagged`  additionalinfo = `` ) ).

  ENDMETHOD.

ENDCLASS.
