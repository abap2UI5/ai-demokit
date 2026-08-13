CLASS z2ui5_cl_smpc_app_381 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_381 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( `IconTabBar`
            )->a( n = `id`       v = `idIconTabBarNoIcons`
            " device> exposes raw sap.ui.Device, so !phone expresses the
            " demo kit helper model's isNoPhone (app 030 precedent)
            )->a( n = `expanded` v = `{= !${device>/system/phone} }`
            )->a( n = `class`    v = `sapUiResponsiveContentPadding`

            )->open( `items`
                )->open( `IconTabFilter`
                    )->a( n = `text` v = `Info`
                    )->a( n = `key`  v = `info`

                    )->leaf( `Text`
                        )->a( n = `text` v = `Info content goes here ...`

                )->shut(
                )->open( `IconTabFilter`
                    )->a( n = `text` v = `Attachments`
                    )->a( n = `key`  v = `attachments`

                    )->leaf( `Text`
                        )->a( n = `text` v = `Attachments go here ...`

                )->shut(
                )->open( `IconTabFilter`
                    )->a( n = `text` v = `Notes`
                    )->a( n = `key`  v = `notes`

                    )->leaf( `Text`
                        )->a( n = `text` v = `Notes go here ...`

                )->shut(
                )->open( `IconTabFilter`
                    )->a( n = `text` v = `People`
                    )->a( n = `key`  v = `people`

                    )->leaf( `Text`
                        )->a( n = `text` v = `People content goes here ...` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
