" @keywords headercontainer header container sap.m headercontainernodividers numericcontent invisibletext
" @summary The Header Container without divider lines.
CLASS z2ui5_cl_smpc_app_428 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_428 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`

        " onInit adds the eight InvisibleTexts to the HeaderContainer via
        " addAriaLabelledBy - the same association written statically here
        )->ele( `HeaderContainer`
            )->a( n = `id`             v = `headerContainer`
            )->a( n = `scrollStep`     v = `200`
            )->a( n = `showDividers`   v = `false`
            )->a( n = `ariaLabelledBy` v = `text1 text2 text3 text4 text5 text6 text7 text8`

            " press shows MessageToast.show('Fire press') - a constant text, composed on
            " the client (control_global MESSAGE_TOAST), so no press needs a round-trip
            )->tag( `NumericContent`
                )->a( n = `scale`      v = `M`
                )->a( n = `value`      v = `1.75`
                )->a( n = `valueColor` v = `Good`
                )->a( n = `indicator`  v = `Up`
                )->a( n = `press`      v = client->follow_up_action( val   = client->cs_event-control_global
                                                                     t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Fire press` ) ) )
            )->tag( `NumericContent`
                )->a( n = `scale`      v = `M`
                )->a( n = `value`      v = `0.57`
                )->a( n = `valueColor` v = `Error`
                )->a( n = `indicator`  v = `Down`
                )->a( n = `press`      v = client->follow_up_action( val   = client->cs_event-control_global
                                                                     t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Fire press` ) ) )
            )->tag( `NumericContent`
                )->a( n = `scale`      v = `M`
                )->a( n = `value`      v = `1.04`
                )->a( n = `valueColor` v = `Neutral`
                )->a( n = `indicator`  v = `Up`
                )->a( n = `press`      v = client->follow_up_action( val   = client->cs_event-control_global
                                                                     t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Fire press` ) ) )
            )->tag( `NumericContent`
                )->a( n = `scale`      v = `M`
                )->a( n = `value`      v = `3.65`
                )->a( n = `valueColor` v = `Good`
                )->a( n = `indicator`  v = `Up`
                )->a( n = `press`      v = client->follow_up_action( val   = client->cs_event-control_global
                                                                     t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Fire press` ) ) )
            )->tag( `NumericContent`
                )->a( n = `scale`      v = `M`
                )->a( n = `value`      v = `0.73`
                )->a( n = `valueColor` v = `Error`
                )->a( n = `indicator`  v = `Down`
                )->a( n = `press`      v = client->follow_up_action( val   = client->cs_event-control_global
                                                                     t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Fire press` ) ) )
            )->tag( `NumericContent`
                )->a( n = `scale`      v = `M`
                )->a( n = `value`      v = `1.01`
                )->a( n = `valueColor` v = `Critical`
                )->a( n = `indicator`  v = `Down`
                )->a( n = `press`      v = client->follow_up_action( val   = client->cs_event-control_global
                                                                     t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Fire press` ) ) )
            )->tag( `NumericContent`
                )->a( n = `scale`      v = `M`
                )->a( n = `value`      v = `1.42`
                )->a( n = `valueColor` v = `Good`
                )->a( n = `indicator`  v = `Up`
                )->a( n = `press`      v = client->follow_up_action( val   = client->cs_event-control_global
                                                                     t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Fire press` ) ) )
            )->tag( `NumericContent`
                )->a( n = `scale`      v = `M`
                )->a( n = `value`      v = `0.21`
                )->a( n = `valueColor` v = `Error`
                )->a( n = `indicator`  v = `Down`
                )->a( n = `press`      v = client->follow_up_action( val   = client->cs_event-control_global
                                                                     t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Fire press` ) ) )

        )->end(

        )->tag( n = `InvisibleText` ns = `core`
            )->a( n = `id`   v = `text1`
            )->a( n = `text` v = `1.75 millions`
        )->tag( n = `InvisibleText` ns = `core`
            )->a( n = `id`   v = `text2`
            )->a( n = `text` v = `0.57 millions`
        )->tag( n = `InvisibleText` ns = `core`
            )->a( n = `id`   v = `text3`
            )->a( n = `text` v = `1.04 millions`
        )->tag( n = `InvisibleText` ns = `core`
            )->a( n = `id`   v = `text4`
            )->a( n = `text` v = `3.65 millions`
        )->tag( n = `InvisibleText` ns = `core`
            )->a( n = `id`   v = `text5`
            )->a( n = `text` v = `0.73 millions`
        )->tag( n = `InvisibleText` ns = `core`
            )->a( n = `id`   v = `text6`
            )->a( n = `text` v = `1.01 millions`
        )->tag( n = `InvisibleText` ns = `core`
            )->a( n = `id`   v = `text7`
            )->a( n = `text` v = `1.42 millions`
        )->tag( n = `InvisibleText` ns = `core`
            )->a( n = `id`   v = `text8`
            )->a( n = `text` v = `0.21 millions` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
