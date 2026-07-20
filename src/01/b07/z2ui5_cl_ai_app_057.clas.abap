CLASS z2ui5_cl_ai_app_057 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_057 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->open( `List`
            )->a( n = `headerText` v = `Input`

            )->open( `InputListItem`
                )->a( n = `label` v = `WLAN`
                )->leaf( `Switch`
                    )->a( n = `state` v = `true`

            )->shut(

            )->open( `InputListItem`
                )->a( n = `label` v = `Flight Mode`
                )->leaf( `CheckBox`
                    )->a( n = `selected` v = `true`

            )->shut(

            )->open( `InputListItem`
                )->a( n = `label` v = `High Performance`
                )->leaf( `RadioButton`
                    )->a( n = `groupName` v = `GroupInputListItem`
                    )->a( n = `selected`  v = `true`

            )->shut(

            )->open( `InputListItem`
                )->a( n = `label` v = `Battery Saving`
                )->leaf( `RadioButton`
                    )->a( n = `groupName` v = `GroupInputListItem`

            )->shut(

            )->open( `InputListItem`
                )->a( n = `label` v = `Price (EUR)`
                )->leaf( `Input`
                    )->a( n = `placeholder` v = `Price`
                    )->a( n = `value`       v = `799`
                    )->a( n = `type`        v = `Number`

            )->shut(

            )->open( `InputListItem`
                )->a( n = `label` v = `Address`
                )->leaf( `Input`
                    )->a( n = `placeholder` v = `Address`
                    )->a( n = `value`       v = `Main Rd, Manchester`

            )->shut(

            )->open( `InputListItem`
                )->a( n = `label` v = `Country`
                )->open( `Select`
                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `key`  v = `GR`
                        )->a( n = `text` v = `Greece`
                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `key`  v = `MX`
                        )->a( n = `text` v = `Mexico`
                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `key`  v = `NO`
                        )->a( n = `text` v = `Norway`
                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `key`  v = `NZ`
                        )->a( n = `text` v = `New Zealand`
                    )->leaf( n = `Item` ns = `core`
                        )->a( n = `key`  v = `NL`
                        )->a( n = `text` v = `Netherlands`

                )->shut(
            )->shut(

            )->open( `InputListItem`
                )->a( n = `label` v = `Volume`
                )->open( `HBox`
                    )->a( n = `justifyContent` v = `End`
                    )->leaf( `Slider`
                        )->a( n = `min`   v = `0`
                        )->a( n = `max`   v = `10`
                        )->a( n = `value` v = `7`
                        )->a( n = `width` v = `200px`

                )->shut(
            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
