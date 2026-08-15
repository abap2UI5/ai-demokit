CLASS z2ui5_cl_smpc_app_110 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_110 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.f`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`      v = `sap.m`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `height`       v = `100%`

        )->ele( `ShellBar`
            )->a( n = `title`               v = `Application Title`
            )->a( n = `secondTitle`         v = `Short description`
            )->a( n = `homeIcon`            v = `https://sdk.openui5.org/resources/sap/ui/documentation/sdk/images/logo_sap.png`
            )->a( n = `showCopilot`         v = `true`
            )->a( n = `showSearch`          v = `true`
            )->a( n = `showNotifications`   v = `true`
            )->a( n = `notificationsNumber` v = `2`

            )->ele( `menu`
                )->ele( n = `Menu` ns = `m`
                    )->tag( n = `MenuItem` ns = `m`
                        )->a( n = `text` v = `Flight booking`
                        )->a( n = `icon` v = `sap-icon://flight`
                    )->tag( n = `MenuItem` ns = `m`
                        )->a( n = `text` v = `Car rental`
                        )->a( n = `icon` v = `sap-icon://car-rental`

                )->end(
            )->end(
            )->ele( `profile`
                )->tag( n = `Avatar` ns = `m`
                    )->a( n = `initials` v = `UI` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
