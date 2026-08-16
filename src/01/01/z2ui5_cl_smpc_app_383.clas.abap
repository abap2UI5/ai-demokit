CLASS z2ui5_cl_smpc_app_383 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_383 IMPLEMENTATION.

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

        )->tag( `Label`
            )->a( n = `wrapping` v = `true`
            )->a( n = `text`     v = `No icon(='') used as separator, the separator will be a vertical line.`
            )->a( n = `class`    v = `sapUiSmallMargin`

        )->ele( `IconTabBar`
            )->a( n = `id`       v = `idIconTabBarSeparatorNoIcon`
            )->a( n = `expanded` v = `false`
            )->a( n = `class`    v = `sapUiResponsiveContentPadding`

            )->ele( `items`
                )->ele( `IconTabFilter`
                    )->a( n = `key`       v = `info`
                    )->a( n = `icon`      v = `sap-icon://hint`
                    )->a( n = `iconColor` v = `Positive`

                    )->tag( `Text`
                        )->a( n = `text` v = `Info content goes here ...`

                )->end(
                )->tag( `IconTabSeparator`
                    )->a( n = `icon` v = ``
                )->ele( `IconTabFilter`
                    )->a( n = `key`       v = `attachments`
                    )->a( n = `icon`      v = `sap-icon://attachment`
                    )->a( n = `iconColor` v = `Neutral`
                    )->a( n = `count`     v = `3`

                    )->tag( `Text`
                        )->a( n = `text` v = `Attachments go here ...`

                )->end(
                )->ele( `IconTabFilter`
                    )->a( n = `key`   v = `notes`
                    )->a( n = `icon`  v = `sap-icon://notes`
                    )->a( n = `count` v = `12`

                    )->tag( `Text`
                        )->a( n = `text` v = `Notes go here ...`

                )->end(
                )->tag( `IconTabSeparator`
                    )->a( n = `icon` v = ``
                )->ele( `IconTabFilter`
                    )->a( n = `key`       v = `people`
                    )->a( n = `icon`      v = `sap-icon://group`
                    )->a( n = `iconColor` v = `Negative`

                    )->tag( `Text`
                        )->a( n = `text` v = `People content goes here ...`

                )->end(
            )->end(
        )->end(

        )->tag( `Label`
            )->a( n = `wrapping` v = `true`
            )->a( n = `text`     v = `Icon used as separator, you are free to choose an icon you want.`
            )->a( n = `class`    v = `sapUiSmallMargin`

        )->ele( `IconTabBar`
            )->a( n = `id`       v = `idIconTabBarSeparatorIcon`
            )->a( n = `expanded` v = `false`
            )->a( n = `class`    v = `sapUiResponsiveContentPadding`

            )->ele( `items`
                )->ele( `IconTabFilter`
                    )->a( n = `key`       v = `info`
                    )->a( n = `icon`      v = `sap-icon://hint`
                    )->a( n = `iconColor` v = `Neutral`

                    )->tag( `Text`
                        )->a( n = `text` v = `Info content goes here ...`

                )->end(
                )->ele( `IconTabFilter`
                    )->a( n = `key`       v = `attachments`
                    )->a( n = `icon`      v = `sap-icon://attachment`
                    )->a( n = `iconColor` v = `Neutral`
                    )->a( n = `count`     v = `3`

                    )->tag( `Text`
                        )->a( n = `text` v = `Attachments go here ...`

                )->end(
                )->tag( `IconTabSeparator`
                    )->a( n = `icon` v = `sap-icon://process`
                )->ele( `IconTabFilter`
                    )->a( n = `key`       v = `notes`
                    )->a( n = `icon`      v = `sap-icon://notes`
                    )->a( n = `iconColor` v = `Positive`
                    )->a( n = `count`     v = `12`

                    )->tag( `Text`
                        )->a( n = `text` v = `Notes go here ...`

                )->end(
                )->tag( `IconTabSeparator`
                    )->a( n = `icon` v = `sap-icon://process`
                )->ele( `IconTabFilter`
                    )->a( n = `key`       v = `people`
                    )->a( n = `icon`      v = `sap-icon://group`
                    )->a( n = `iconColor` v = `Negative`

                    )->tag( `Text`
                        )->a( n = `text` v = `People content goes here ...`

                )->end(
            )->end(
        )->end(

        )->tag( `Label`
            )->a( n = `wrapping` v = `true`
            )->a( n = `text`     v = `Different separators used.`
            )->a( n = `class`    v = `sapUiSmallMargin`

        )->ele( `IconTabBar`
            )->a( n = `id`       v = `idIconTabBarSeparatorMixed`
            )->a( n = `expanded` v = `false`
            )->a( n = `class`    v = `sapUiResponsiveContentPadding`

            )->ele( `items`
                )->ele( `IconTabFilter`
                    )->a( n = `key`       v = `info`
                    )->a( n = `icon`      v = `sap-icon://hint`
                    )->a( n = `iconColor` v = `Critical`

                    )->tag( `Text`
                        )->a( n = `text` v = `Info content goes here ...`

                )->end(
                )->tag( `IconTabSeparator`
                    )->a( n = `icon` v = ``
                )->ele( `IconTabFilter`
                    )->a( n = `key`       v = `attachments`
                    )->a( n = `icon`      v = `sap-icon://attachment`
                    )->a( n = `iconColor` v = `Neutral`
                    )->a( n = `count`     v = `3`

                    )->tag( `Text`
                        )->a( n = `text` v = `Attachments go here ...`

                )->end(
                )->tag( `IconTabSeparator`
                    )->a( n = `icon` v = `sap-icon://vertical-grip`
                )->ele( `IconTabFilter`
                    )->a( n = `key`       v = `notes`
                    )->a( n = `icon`      v = `sap-icon://notes`
                    )->a( n = `iconColor` v = `Positive`
                    )->a( n = `count`     v = `12`

                    )->tag( `Text`
                        )->a( n = `text` v = `Notes go here ...`

                )->end(
                )->tag( `IconTabSeparator`
                    )->a( n = `icon` v = `sap-icon://process`
                )->ele( `IconTabFilter`
                    )->a( n = `key`       v = `people`
                    )->a( n = `icon`      v = `sap-icon://group`
                    )->a( n = `iconColor` v = `Negative`

                    )->tag( `Text`
                        )->a( n = `text` v = `People content goes here ...` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
