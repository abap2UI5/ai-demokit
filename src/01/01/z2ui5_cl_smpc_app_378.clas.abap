" @keywords icontabbar icon tab bar sap.m icontabbarfiori2 icontabfilter text
" @summary In this example, the Icon Tab Bar tabs display text and corresponding count.
CLASS z2ui5_cl_smpc_app_378 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_378 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `IconTabBar`
            )->a( n = `id`       v = `idIconTabBarFiori2`
            " device> exposes raw sap.ui.Device, so !phone expresses the
            " demo kit helper model's isNoPhone (app 030 precedent)
            )->a( n = `expanded` v = `{= !${device>/system/phone} }`
            )->a( n = `class`    v = `sapUiResponsiveContentPadding`

            )->ele( `items`
                )->ele( `IconTabFilter`
                    )->a( n = `text`  v = `Info`
                    )->a( n = `key`   v = `info`
                    )->a( n = `count` v = `3`

                    )->tag( `Text`
                        )->a( n = `text` v = `Info content goes here ...`

                )->end(
                )->ele( `IconTabFilter`
                    )->a( n = `text`  v = `Attachments`
                    )->a( n = `key`   v = `attachments`
                    )->a( n = `count` v = `4321`

                    )->tag( `Text`
                        )->a( n = `text` v = `Attachments go here ...`

                )->end(
                )->ele( `IconTabFilter`
                    )->a( n = `text`  v = `Notes`
                    )->a( n = `key`   v = `notes`
                    )->a( n = `count` v = `333`

                    )->tag( `Text`
                        )->a( n = `text` v = `Notes go here ...`

                )->end(
                )->ele( `IconTabFilter`
                    )->a( n = `text`  v = `People`
                    )->a( n = `key`   v = `people`
                    )->a( n = `count` v = `34`

                    )->tag( `Text`
                        )->a( n = `text` v = `People content goes here ...` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
