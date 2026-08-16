" @keywords menu sap.ui.unified menuitemeventing button
" @summary Menu with Item Eventing
CLASS z2ui5_cl_smpc_app_227 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_227 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:u`   v = `sap.ui.unified`
        )->a( n = `class`     v = `viewPadding`

        )->ele( n = `HorizontalLayout` ns = `l`

            )->ele( `Button`
                )->a( n = `id`           v = `openMenu`
                )->a( n = `text`         v = `Open Menu`
                )->a( n = `ariaHasPopup` v = `Menu`
                " the sample opens the Menu anchored to the button via oMenu.open( kbd, button, ... );
                " sap.ui.unified.Menu has no openBy and open cannot receive the anchor - see pr/ (no-op today)
                )->a( n = `press`        v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                       t_arg = VALUE #( ( `theMenu` ) ( `openBy` ) ( `$event.oSource.sId` ) ) )

                )->ele( `dependents`
                    )->ele( n = `Menu` ns = `u`
                        )->a( n = `id` v = `theMenu`

                        )->tag( n = `MenuItem` ns = `u`
                            )->a( n = `text`   v = `My 1st Item`
                            )->a( n = `icon`   v = `sap-icon://save`
                            " compose the toast on the frontend (1:1 with MessageToast.show("'" + item.getText() + "' pressed"))
                            )->a( n = `select` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                             t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `'{0}' pressed` ) ( `${$parameters>/item}.getText()` ) ) )
                        )->tag( n = `MenuItem` ns = `u`
                            )->a( n = `text`   v = `My 2nd Item`
                            )->a( n = `select` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                             t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `'{0}' pressed` ) ( `${$parameters>/item}.getText()` ) ) )

                        )->ele( n = `MenuItem` ns = `u`
                            )->a( n = `text` v = `My 3rd Item`

                            )->ele( n = `Menu` ns = `u`

                                )->tag( n = `MenuItem` ns = `u`
                                    )->a( n = `text`   v = `1st Sub Item`
                                    )->a( n = `select` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                     t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `'{0}' pressed` ) ( `${$parameters>/item}.getText()` ) ) )
                                )->tag( n = `MenuItem` ns = `u`
                                    )->a( n = `text`   v = `2nd Sub Item`
                                    )->a( n = `select` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                     t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `'{0}' pressed` ) ( `${$parameters>/item}.getText()` ) ) )
                                )->tag( n = `MenuItem` ns = `u`
                                    )->a( n = `text`    v = `3rd Sub Item but inactive`
                                    )->a( n = `enabled` v = `false`

                            )->end(
                        )->end(
                        )->tag( n = `MenuItem` ns = `u`
                            )->a( n = `text`          v = `My 4th Item`
                            )->a( n = `startsSection` v = `true`
                            )->a( n = `select`        v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                    t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `'{0}' pressed` ) ( `${$parameters>/item}.getText()` ) ) )
                        )->tag( n = `MenuItem` ns = `u`
                            )->a( n = `text`   v = `My 5th Item`
                            )->a( n = `select` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                             t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `'{0}' pressed` ) ( `${$parameters>/item}.getText()` ) ) )

                        )->tag( n = `MenuTextFieldItem` ns = `u`
                            )->a( n = `label`         v = `Find`
                            )->a( n = `enabled`       v = `true`
                            )->a( n = `startsSection` v = `true`
                            )->a( n = `icon`          v = `sap-icon://filter`
                            " 1:1 with MessageToast.show("'" + item.getValue() + "' entered")
                            )->a( n = `select`        v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                    t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `'{0}' entered` ) ( `${$parameters>/item}.getValue()` ) ) )

                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
