" @keywords menu sap.ui.unified menumenueventing horizontallayout button menuitem menutextfielditem
" @summary Menu with Menu Eventing
CLASS z2ui5_cl_smpc_app_228 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_228 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD on_event.

    " handleMenuItemPress: a parent that only opens its submenu is skipped
    IF client->get_event( ) = `ITEM_SELECT` AND client->get_event_arg( ) <> `SUB`.
      client->message_toast_display( client->get_event_arg( 2 ) ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " the item branch of handleMenuItemPress. The message itself composes on the
    " client (a MenuTextFieldItem reports its VALUE, everything else its text),
    " but the SKIP cannot: the original returns before MessageToast.show for a
    " parent that only opens its submenu, and a client action that composes an
    " empty string still pops an empty toast - MessageToast.show('') has no
    " early return. So the decision travels: the flag and the message are two
    " event args and on_event toasts only when there is no submenu
    DATA item TYPE string.
    DATA has_submenu TYPE string.
    DATA item_message TYPE string.
    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    item = `${$parameters>/item}`.
    
    has_submenu = |{ item }.getSubmenu() ? 'SUB' : 'ITEM'|.
    
    item_message = |{ item }.getMetadata().getName() === 'sap.ui.unified.MenuTextFieldItem'| &&
                         | ? "'" + { item }.getValue() + "' entered"| &&
                         | : "'" + { item }.getText() + "' pressed"|.

    
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `theMenu` INTO TABLE temp1.
    INSERT `openBy` INTO TABLE temp1.
    INSERT `$event.oSource.sId` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT has_submenu INTO TABLE temp2.
    INSERT item_message INTO TABLE temp2.
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
                        " menu-level eventing: one handler for every item, composed on the frontend
                        " (1:1 with MessageToast.show("'" + item.getText() + "' pressed"))
                        " handleMenuItemPress branches on the runtime item: a parent that
                        " only opens its submenu is skipped, a MenuTextFieldItem reports its
                        " VALUE + ' entered', everything else its text + ' pressed'. All three
                        " fit in ONE expression arg - measured with
                        " scripts/probes/event-arg-expression-probe.mjs, a class-name ternary
                        " resolves - so the toast text is composed on the client 1:1
                        )->a( n = `itemSelect` v = client->_event( val   = `ITEM_SELECT`
                                                                   t_arg = temp2 )

                        )->tag( n = `MenuItem` ns = `u`
                            )->a( n = `text` v = `My 1st Item`
                            )->a( n = `icon` v = `sap-icon://save`
                        )->tag( n = `MenuItem` ns = `u`
                            )->a( n = `text` v = `My 2nd Item`

                        )->ele( n = `MenuItem` ns = `u`
                            )->a( n = `text` v = `My 3rd Item`

                            )->ele( n = `Menu` ns = `u`

                                )->tag( n = `MenuItem` ns = `u`
                                    )->a( n = `text` v = `1st Sub Item`
                                )->tag( n = `MenuItem` ns = `u`
                                    )->a( n = `text` v = `2nd Sub Item`
                                )->tag( n = `MenuItem` ns = `u`
                                    )->a( n = `text`    v = `3rd Sub Item but inactive`
                                    )->a( n = `enabled` v = `false`

                            )->end(
                        )->end(
                        )->tag( n = `MenuItem` ns = `u`
                            )->a( n = `text`          v = `My 4th Item`
                            )->a( n = `startsSection` v = `true`
                        )->tag( n = `MenuItem` ns = `u`
                            )->a( n = `text` v = `My 5th Item`

                        )->tag( n = `MenuTextFieldItem` ns = `u`
                            )->a( n = `label`         v = `Find`
                            )->a( n = `enabled`       v = `true`
                            )->a( n = `startsSection` v = `true`
                            )->a( n = `icon`          v = `sap-icon://filter`

                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
