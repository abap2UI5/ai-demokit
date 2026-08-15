CLASS z2ui5_cl_smpc_app_155 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_155 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:f`   v = `sap.ui.layout.form`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `VBox`
            )->tag( `CheckBox`
            )->tag( `CheckBox`
                )->a( n = `text`     v = `Option a`
                )->a( n = `selected` v = `true`
            )->tag( `CheckBox`
                )->a( n = `text` v = `Option b`
            )->tag( `CheckBox`
                )->a( n = `text`     v = `Option c`
                )->a( n = `selected` v = `true`
            )->tag( `CheckBox`
                )->a( n = `text` v = `Option d`
            )->tag( `CheckBox`
                )->a( n = `text`    v = `Option e`
                )->a( n = `enabled` v = `false`
            )->tag( `CheckBox`
                )->a( n = `text`              v = `Option partially selected`
                )->a( n = `selected`          v = `true`
                )->a( n = `partiallySelected` v = `true`
            )->tag( `CheckBox`
                )->a( n = `text`     v = `Required option`
                " required is @since 1.121 - kept 1:1 (POST_171)
                )->a( n = `required` v = `true`
            )->tag( `CheckBox`
                )->a( n = `text`       v = `Warning`
                )->a( n = `valueState` v = `Warning`
            )->tag( `CheckBox`
                )->a( n = `text`       v = `Warning disabled`
                )->a( n = `valueState` v = `Warning`
                )->a( n = `enabled`    v = `false`
                )->a( n = `selected`   v = `true`
            )->tag( `CheckBox`
                )->a( n = `text`       v = `Error`
                )->a( n = `valueState` v = `Error`
            )->tag( `CheckBox`
                )->a( n = `text`       v = `Error disabled`
                )->a( n = `valueState` v = `Error`
                )->a( n = `enabled`    v = `false`
                )->a( n = `selected`   v = `true`
            )->tag( `CheckBox`
                )->a( n = `text`       v = `Information`
                )->a( n = `valueState` v = `Information`
            )->tag( `CheckBox`
                )->a( n = `text`       v = `Information disabled`
                )->a( n = `valueState` v = `Information`
                )->a( n = `enabled`    v = `false`
                )->a( n = `selected`   v = `true`
            )->tag( `CheckBox`
                )->a( n = `text`     v = `Checkbox with wrapping='true' and long text`
                )->a( n = `wrapping` v = `true`
                )->a( n = `width`    v = `150px`

        )->end(

        )->ele( n = `SimpleForm` ns = `f`
            )->a( n = `editable`   v = `true`
            )->a( n = `layout`     v = `ResponsiveGridLayout`
            )->a( n = `labelSpanL` v = `4`
            )->a( n = `labelSpanM` v = `4`

            )->ele( n = `content` ns = `f`
                )->tag( `Label`
                    )->a( n = `text` v = `Clearing with Customer`
                )->tag( `CheckBox`
                    )->a( n = `text` v = `Option`
                )->ele( `CheckBox`
                    )->a( n = `text`     v = `Option 2`
                    )->a( n = `selected` v = `true`
                    )->ele( `layoutData`
                        )->tag( n = `GridData` ns = `l`
                            )->a( n = `linebreak` v = `true`
                            )->a( n = `indentL`   v = `4`
                            )->a( n = `indentM`   v = `4`

                    )->end(
                )->end(
                )->ele( `CheckBox`
                    )->a( n = `id`   v = `focusMe`
                    )->a( n = `text` v = `Option 3`
                    )->ele( `layoutData`
                        )->tag( n = `GridData` ns = `l`
                            )->a( n = `linebreak` v = `true`
                            )->a( n = `indentL`   v = `4`
                            )->a( n = `indentM`   v = `4`

                    )->end(
                )->end(
                )->ele( `CheckBox`
                    )->a( n = `text`     v = `Checkbox with wrapping='true' and long text placed in a form`
                    )->a( n = `wrapping` v = `true`
                    )->a( n = `width`    v = `200px`
                    )->ele( `layoutData`
                        )->tag( n = `GridData` ns = `l`
                            )->a( n = `linebreak` v = `true`
                            )->a( n = `indentL`   v = `4`
                            )->a( n = `indentM`   v = `4` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
