CLASS z2ui5_cl_smpc_app_152 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_152 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns`        v = `sap.f`
        )->a( n = `xmlns:m`      v = `sap.m`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `height`       v = `100%`

        )->open( `ShellBar`
            )->a( n = `id`                  v = `sapFShellBarSample`
            )->a( n = `title`               v = `Application Title`
            )->a( n = `secondTitle`         v = `Short description`
            " homeIcon absolutized to the OpenUI5 host (original: ./resources/...)
            )->a( n = `homeIcon`            v = `https://sdk.openui5.org/resources/sap/ui/documentation/sdk/images/logo_sap.png`
            )->a( n = `showCopilot`         v = `true`
            )->a( n = `showSearch`          v = `true`
            )->a( n = `showMenuButton`      v = `true`
            )->a( n = `showNavButton`       v = `true`
            )->a( n = `showNotifications`   v = `true`
            )->a( n = `class`               v = `sapFShellBarFCLFPHeader`
            )->a( n = `notificationsNumber` v = `2`

            )->open( `profile`
                " sap.m.Avatar is @since 1.73 - kept 1:1 (POST_171)
                )->leaf( n = `Avatar` ns = `m`
                    )->a( n = `initials` v = `UI` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
