" @keywords overflowtoolbar overflow toolbar sap.m toolbarenabled invisibletext checkbox button toolbarspacer input radiobutton
" @summary The Enabled property can be used to enable or disable all the controls inside the OverflowToolbar/Toolbar.
CLASS z2ui5_cl_smpc_app_425 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA enabled TYPE abap_bool VALUE abap_true.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_425 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `height`     v = `100%`

        )->tag( n = `InvisibleText` ns = `core`
            )->a( n = `id`   v = `text1`
            )->a( n = `text` v = `Label text`

        " onCheckBoxSelect calls toolbar.setEnabled( selected ) - reproduced roundtrip-free
        " by two-way binding the same flag on CheckBox.selected and OverflowToolbar.enabled
        " (the CheckBox select attribute is dropped)
        )->tag( `CheckBox`
            )->a( n = `text`     v = `Enabled`
            )->a( n = `selected` v = client->_bind( enabled )

        )->ele( `OverflowToolbar`
            )->a( n = `id`      v = `toolbar`
            )->a( n = `enabled` v = client->_bind( enabled )

            )->tag( `Button`
                )->a( n = `text` v = `Accept`
                )->a( n = `type` v = `Accept`
            )->tag( `ToolbarSpacer`
            )->tag( `CheckBox`
                )->a( n = `text` v = `CheckBox`
            )->tag( `ToolbarSpacer`
            )->tag( `Input`
                )->a( n = `ariaLabelledBy` v = `text1`
                )->a( n = `width`          v = `100px`
                )->a( n = `value`          v = `Input`
            )->tag( `ToolbarSpacer`
            )->tag( `RadioButton`
                )->a( n = `text` v = `RadioButton`
            )->tag( `ToolbarSpacer`
            )->tag( `Button`
                )->a( n = `text` v = `Reject`
                )->a( n = `type` v = `Reject` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
