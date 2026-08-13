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
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->leaf( `Label`
            )->a( n = `wrapping` v = `true`
            )->a( n = `text`     v = `No icon(='') used as separator, the separator will be a vertical line.`
            )->a( n = `class`    v = `sapUiSmallMargin`

        )->open( `IconTabBar`
            )->a( n = `id`       v = `idIconTabBarSeparatorNoIcon`
            )->a( n = `expanded` v = `false`
            )->a( n = `class`    v = `sapUiResponsiveContentPadding`

            )->open( `items`
                )->open( `IconTabFilter`
                    )->a( n = `key`       v = `info`
                    )->a( n = `icon`      v = `sap-icon://hint`
                    )->a( n = `iconColor` v = `Positive`

                    )->leaf( `Text`
                        )->a( n = `text` v = `Info content goes here ...`

                )->shut(
                )->leaf( `IconTabSeparator`
                    )->a( n = `icon` v = ``
                )->open( `IconTabFilter`
                    )->a( n = `key`       v = `attachments`
                    )->a( n = `icon`      v = `sap-icon://attachment`
                    )->a( n = `iconColor` v = `Neutral`
                    )->a( n = `count`     v = `3`

                    )->leaf( `Text`
                        )->a( n = `text` v = `Attachments go here ...`

                )->shut(
                )->open( `IconTabFilter`
                    )->a( n = `key`   v = `notes`
                    )->a( n = `icon`  v = `sap-icon://notes`
                    )->a( n = `count` v = `12`

                    )->leaf( `Text`
                        )->a( n = `text` v = `Notes go here ...`

                )->shut(
                )->leaf( `IconTabSeparator`
                    )->a( n = `icon` v = ``
                )->open( `IconTabFilter`
                    )->a( n = `key`       v = `people`
                    )->a( n = `icon`      v = `sap-icon://group`
                    )->a( n = `iconColor` v = `Negative`

                    )->leaf( `Text`
                        )->a( n = `text` v = `People content goes here ...`

                )->shut(
            )->shut(
        )->shut(

        )->leaf( `Label`
            )->a( n = `wrapping` v = `true`
            )->a( n = `text`     v = `Icon used as separator, you are free to choose an icon you want.`
            )->a( n = `class`    v = `sapUiSmallMargin`

        )->open( `IconTabBar`
            )->a( n = `id`       v = `idIconTabBarSeparatorIcon`
            )->a( n = `expanded` v = `false`
            )->a( n = `class`    v = `sapUiResponsiveContentPadding`

            )->open( `items`
                )->open( `IconTabFilter`
                    )->a( n = `key`       v = `info`
                    )->a( n = `icon`      v = `sap-icon://hint`
                    )->a( n = `iconColor` v = `Neutral`

                    )->leaf( `Text`
                        )->a( n = `text` v = `Info content goes here ...`

                )->shut(
                )->open( `IconTabFilter`
                    )->a( n = `key`       v = `attachments`
                    )->a( n = `icon`      v = `sap-icon://attachment`
                    )->a( n = `iconColor` v = `Neutral`
                    )->a( n = `count`     v = `3`

                    )->leaf( `Text`
                        )->a( n = `text` v = `Attachments go here ...`

                )->shut(
                )->leaf( `IconTabSeparator`
                    )->a( n = `icon` v = `sap-icon://process`
                )->open( `IconTabFilter`
                    )->a( n = `key`       v = `notes`
                    )->a( n = `icon`      v = `sap-icon://notes`
                    )->a( n = `iconColor` v = `Positive`
                    )->a( n = `count`     v = `12`

                    )->leaf( `Text`
                        )->a( n = `text` v = `Notes go here ...`

                )->shut(
                )->leaf( `IconTabSeparator`
                    )->a( n = `icon` v = `sap-icon://process`
                )->open( `IconTabFilter`
                    )->a( n = `key`       v = `people`
                    )->a( n = `icon`      v = `sap-icon://group`
                    )->a( n = `iconColor` v = `Negative`

                    )->leaf( `Text`
                        )->a( n = `text` v = `People content goes here ...`

                )->shut(
            )->shut(
        )->shut(

        )->leaf( `Label`
            )->a( n = `wrapping` v = `true`
            )->a( n = `text`     v = `Different separators used.`
            )->a( n = `class`    v = `sapUiSmallMargin`

        )->open( `IconTabBar`
            )->a( n = `id`       v = `idIconTabBarSeparatorMixed`
            )->a( n = `expanded` v = `false`
            )->a( n = `class`    v = `sapUiResponsiveContentPadding`

            )->open( `items`
                )->open( `IconTabFilter`
                    )->a( n = `key`       v = `info`
                    )->a( n = `icon`      v = `sap-icon://hint`
                    )->a( n = `iconColor` v = `Critical`

                    )->leaf( `Text`
                        )->a( n = `text` v = `Info content goes here ...`

                )->shut(
                )->leaf( `IconTabSeparator`
                    )->a( n = `icon` v = ``
                )->open( `IconTabFilter`
                    )->a( n = `key`       v = `attachments`
                    )->a( n = `icon`      v = `sap-icon://attachment`
                    )->a( n = `iconColor` v = `Neutral`
                    )->a( n = `count`     v = `3`

                    )->leaf( `Text`
                        )->a( n = `text` v = `Attachments go here ...`

                )->shut(
                )->leaf( `IconTabSeparator`
                    )->a( n = `icon` v = `sap-icon://vertical-grip`
                )->open( `IconTabFilter`
                    )->a( n = `key`       v = `notes`
                    )->a( n = `icon`      v = `sap-icon://notes`
                    )->a( n = `iconColor` v = `Positive`
                    )->a( n = `count`     v = `12`

                    )->leaf( `Text`
                        )->a( n = `text` v = `Notes go here ...`

                )->shut(
                )->leaf( `IconTabSeparator`
                    )->a( n = `icon` v = `sap-icon://process`
                )->open( `IconTabFilter`
                    )->a( n = `key`       v = `people`
                    )->a( n = `icon`      v = `sap-icon://group`
                    )->a( n = `iconColor` v = `Negative`

                    )->leaf( `Text`
                        )->a( n = `text` v = `People content goes here ...` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
