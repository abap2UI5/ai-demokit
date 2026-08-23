" @keywords overflowtoolbar overflow toolbar sap.m toolbaractive checkbox text toolbarspacer icon
" @summary Making an OverflowToolbar or a Toolbar active allows them to react to the click event.
CLASS z2ui5_cl_smpc_app_424 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA active TYPE abap_bool VALUE abap_true.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_424 IMPLEMENTATION.

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
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        " onCheckBoxSelect calls toolbar.setActive( selected ) - reproduced roundtrip-free
        " by two-way binding the same flag on CheckBox.selected and OverflowToolbar.active
        " (the CheckBox select attribute is dropped)
        )->tag( `CheckBox`
            )->a( n = `text`     v = `Active`
            )->a( n = `selected` v = client->_bind( active )

        )->ele( `OverflowToolbar`
            )->a( n = `id`             v = `toolbar`
            )->a( n = `active`         v = client->_bind( active )
            )->a( n = `design`         v = `Info`
            )->a( n = `height`         v = `2rem`
            " onToolbarPress shows a MessageToast with a constant text - composed on the
            " client (control_global MESSAGE_TOAST), so the press needs no round-trip
            )->a( n = `press`          v = client->follow_up_action( val   = client->cs_event-control_global
                                                                     t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `OverflowToolbar is clicked` ) ) )
            )->a( n = `ariaLabelledBy` v = `myText`

            )->tag( `Text`
                )->a( n = `id`   v = `myText`
                )->a( n = `text` v = `If you click here, while the OverflowToolbar is active, an event will be fired.`
            )->tag( `Text`
                )->a( n = `id`   v = `myText1`
                )->a( n = `text` v = `There should be no interactive elements in the toolbar.`
            )->tag( `ToolbarSpacer`
            )->tag( n = `Icon` ns = `core`
                )->a( n = `src`   v = `sap-icon://undo`
                )->a( n = `width` v = `2rem` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
