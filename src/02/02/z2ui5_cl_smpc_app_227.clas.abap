" @keywords menu sap.ui.unified menuitemeventing horizontallayout button menuitem menutextfielditem
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
    DATA temp8 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `theMenu` INTO TABLE temp1.
    INSERT `openBy` INTO TABLE temp1.
    INSERT `$event.oSource.sId` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `MESSAGE_TOAST` INTO TABLE temp2.
    INSERT `show` INTO TABLE temp2.
    INSERT `'{0}' pressed` INTO TABLE temp2.
    INSERT `${$parameters>/item}.getText()` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `MESSAGE_TOAST` INTO TABLE temp3.
    INSERT `show` INTO TABLE temp3.
    INSERT `'{0}' pressed` INTO TABLE temp3.
    INSERT `${$parameters>/item}.getText()` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `MESSAGE_TOAST` INTO TABLE temp4.
    INSERT `show` INTO TABLE temp4.
    INSERT `'{0}' pressed` INTO TABLE temp4.
    INSERT `${$parameters>/item}.getText()` INTO TABLE temp4.
    
    CLEAR temp5.
    INSERT `MESSAGE_TOAST` INTO TABLE temp5.
    INSERT `show` INTO TABLE temp5.
    INSERT `'{0}' pressed` INTO TABLE temp5.
    INSERT `${$parameters>/item}.getText()` INTO TABLE temp5.
    
    CLEAR temp6.
    INSERT `MESSAGE_TOAST` INTO TABLE temp6.
    INSERT `show` INTO TABLE temp6.
    INSERT `'{0}' pressed` INTO TABLE temp6.
    INSERT `${$parameters>/item}.getText()` INTO TABLE temp6.
    
    CLEAR temp7.
    INSERT `MESSAGE_TOAST` INTO TABLE temp7.
    INSERT `show` INTO TABLE temp7.
    INSERT `'{0}' pressed` INTO TABLE temp7.
    INSERT `${$parameters>/item}.getText()` INTO TABLE temp7.
    
    CLEAR temp8.
    INSERT `MESSAGE_TOAST` INTO TABLE temp8.
    INSERT `show` INTO TABLE temp8.
    INSERT `'{0}' entered` INTO TABLE temp8.
    INSERT `${$parameters>/item}.getValue()` INTO TABLE temp8.
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
                " sap.ui.unified.Menu has no openBy of its own; the frontend's openBy
                " falls back to open( false, anchor, 'begin top', 'begin bottom', anchor )
                " for exactly this control (pr/unified-menu-open-anchored, 2026-07-27) -
                " the "no-op today" this comment claimed until 2026-08-23 is long gone
                )->a( n = `press`        v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                       t_arg = temp1 )

                )->ele( `dependents`
                    )->ele( n = `Menu` ns = `u`
                        )->a( n = `id` v = `theMenu`

                        )->tag( n = `MenuItem` ns = `u`
                            )->a( n = `text`   v = `My 1st Item`
                            )->a( n = `icon`   v = `sap-icon://save`
                            " compose the toast on the frontend (1:1 with MessageToast.show("'" + item.getText() + "' pressed"))
                            )->a( n = `select` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                             t_arg = temp2 )
                        )->tag( n = `MenuItem` ns = `u`
                            )->a( n = `text`   v = `My 2nd Item`
                            )->a( n = `select` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                             t_arg = temp3 )

                        )->ele( n = `MenuItem` ns = `u`
                            )->a( n = `text` v = `My 3rd Item`

                            )->ele( n = `Menu` ns = `u`

                                )->tag( n = `MenuItem` ns = `u`
                                    )->a( n = `text`   v = `1st Sub Item`
                                    )->a( n = `select` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                     t_arg = temp4 )
                                )->tag( n = `MenuItem` ns = `u`
                                    )->a( n = `text`   v = `2nd Sub Item`
                                    )->a( n = `select` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                     t_arg = temp5 )
                                )->tag( n = `MenuItem` ns = `u`
                                    )->a( n = `text`    v = `3rd Sub Item but inactive`
                                    )->a( n = `enabled` v = `false`

                            )->end(
                        )->end(
                        )->tag( n = `MenuItem` ns = `u`
                            )->a( n = `text`          v = `My 4th Item`
                            )->a( n = `startsSection` v = `true`
                            )->a( n = `select`        v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                    t_arg = temp6 )
                        )->tag( n = `MenuItem` ns = `u`
                            )->a( n = `text`   v = `My 5th Item`
                            )->a( n = `select` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                             t_arg = temp7 )

                        )->tag( n = `MenuTextFieldItem` ns = `u`
                            )->a( n = `label`         v = `Find`
                            )->a( n = `enabled`       v = `true`
                            )->a( n = `startsSection` v = `true`
                            )->a( n = `icon`          v = `sap-icon://filter`
                            " 1:1 with MessageToast.show("'" + item.getValue() + "' entered")
                            )->a( n = `select`        v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                    t_arg = temp8 )

                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
