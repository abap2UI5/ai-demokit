CLASS z2ui5_cl_smpc_app_380 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_380 IMPLEMENTATION.

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
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `IconTabBar`
            )->a( n = `id`       v = `idIconTabBarMulti`
            " device> exposes raw sap.ui.Device, so !phone expresses the
            " demo kit helper model's isNoPhone (app 030 precedent)
            )->a( n = `expanded` v = `{= !${device>/system/phone} }`
            )->a( n = `class`    v = `sapUiResponsiveContentPadding`

            )->ele( `items`
                )->ele( `IconTabFilter`
                    )->a( n = `icon` v = `sap-icon://hint`
                    )->a( n = `key`  v = `info`

                    )->tag( `Text`
                        )->a( n = `text` v = `Info content goes here ...`

                )->end(
                )->ele( `IconTabFilter`
                    )->a( n = `icon`  v = `sap-icon://attachment`
                    )->a( n = `key`   v = `attachments`
                    )->a( n = `count` v = `3`

                    )->tag( `Text`
                        )->a( n = `text` v = `Attachments go here ...`

                )->end(
                )->ele( `IconTabFilter`
                    )->a( n = `icon`  v = `sap-icon://notes`
                    )->a( n = `key`   v = `notes`
                    )->a( n = `count` v = `12`

                    )->tag( `Text`
                        )->a( n = `text` v = `Notes go here ...`

                )->end(
                )->ele( `IconTabFilter`
                    )->a( n = `icon` v = `sap-icon://group`
                    )->a( n = `key`  v = `people`

                    )->tag( `Text`
                        )->a( n = `text` v = `People content goes here ...` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
