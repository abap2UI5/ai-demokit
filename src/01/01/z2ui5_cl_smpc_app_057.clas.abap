" @keywords inputlistitem input list item sap.m items hosting switch checkbox radiobutton select hbox
CLASS z2ui5_cl_smpc_app_057 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_057 IMPLEMENTATION.

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
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( `List`
            )->a( n = `headerText` v = `Input`

            )->ele( `InputListItem`
                )->a( n = `label` v = `WLAN`
                )->tag( `Switch`
                    )->a( n = `state` v = `true`

            )->end(

            )->ele( `InputListItem`
                )->a( n = `label` v = `Flight Mode`
                )->tag( `CheckBox`
                    )->a( n = `selected` v = `true`

            )->end(

            )->ele( `InputListItem`
                )->a( n = `label` v = `High Performance`
                )->tag( `RadioButton`
                    )->a( n = `groupName` v = `GroupInputListItem`
                    )->a( n = `selected`  v = `true`

            )->end(

            )->ele( `InputListItem`
                )->a( n = `label` v = `Battery Saving`
                )->tag( `RadioButton`
                    )->a( n = `groupName` v = `GroupInputListItem`

            )->end(

            )->ele( `InputListItem`
                )->a( n = `label` v = `Price (EUR)`
                )->tag( `Input`
                    )->a( n = `placeholder` v = `Price`
                    )->a( n = `value`       v = `799`
                    )->a( n = `type`        v = `Number`

            )->end(

            )->ele( `InputListItem`
                )->a( n = `label` v = `Address`
                )->tag( `Input`
                    )->a( n = `placeholder` v = `Address`
                    )->a( n = `value`       v = `Main Rd, Manchester`

            )->end(

            )->ele( `InputListItem`
                )->a( n = `label` v = `Country`
                )->ele( `Select`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `GR`
                        )->a( n = `text` v = `Greece`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `MX`
                        )->a( n = `text` v = `Mexico`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `NO`
                        )->a( n = `text` v = `Norway`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `NZ`
                        )->a( n = `text` v = `New Zealand`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `NL`
                        )->a( n = `text` v = `Netherlands`

                )->end(
            )->end(

            )->ele( `InputListItem`
                )->a( n = `label` v = `Volume`
                )->ele( `HBox`
                    )->a( n = `justifyContent` v = `End`
                    )->tag( `Slider`
                        )->a( n = `min`   v = `0`
                        )->a( n = `max`   v = `10`
                        )->a( n = `value` v = `7`
                        )->a( n = `width` v = `200px`

                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
