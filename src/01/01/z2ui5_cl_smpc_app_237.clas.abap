" @keywords objectmarker object marker sap.m table column text columnlistitem objectidentifier
" @summary The ObjectMarker is a small building block representing an object by an icon or text and icon. Often it is used in a table.
CLASS z2ui5_cl_smpc_app_237 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_modeldata,
             product        TYPE string,
             type           TYPE string,
             additionalinfo TYPE string,
           END OF ty_s_modeldata.
    DATA t_modeldata TYPE STANDARD TABLE OF ty_s_modeldata WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_237 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `{0} marker pressed!` INTO TABLE temp1.
    INSERT `${$parameters>/type}` INTO TABLE temp1.
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
                    )->a( n = `press`          v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp1 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    DATA temp3 LIKE t_modeldata.
    DATA temp4 LIKE LINE OF temp3.
    CLEAR temp3.
    
    temp4-product = `Power Projector 4713`.
    temp4-type = `Locked`.
    temp4-additionalinfo = ``.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `Power Projector 4713`.
    temp4-type = `LockedBy`.
    temp4-additionalinfo = `John Doe`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `Power Projector 4713`.
    temp4-type = `LockedBy`.
    temp4-additionalinfo = ``.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `Gladiator MX`.
    temp4-type = `Draft`.
    temp4-additionalinfo = ``.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `Hurricane GX`.
    temp4-type = `Unsaved`.
    temp4-additionalinfo = ``.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `Hurricane GX`.
    temp4-type = `UnsavedBy`.
    temp4-additionalinfo = `John Doe`.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `Hurricane GX`.
    temp4-type = `UnsavedBy`.
    temp4-additionalinfo = ``.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `Hurricane GX`.
    temp4-type = `Unsaved`.
    temp4-additionalinfo = ``.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `Webcam`.
    temp4-type = `Favorite`.
    temp4-additionalinfo = ``.
    INSERT temp4 INTO TABLE temp3.
    temp4-product = `Deskjet Super Highspeed`.
    temp4-type = `Flagged`.
    temp4-additionalinfo = ``.
    INSERT temp4 INTO TABLE temp3.
    t_modeldata = temp3.

  ENDMETHOD.

ENDCLASS.
