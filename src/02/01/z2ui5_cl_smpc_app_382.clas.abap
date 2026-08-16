CLASS z2ui5_cl_smpc_app_382 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_382 IMPLEMENTATION.

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
            )->a( n = `text`
                     v = `IconTabBar with filters with own content and sub tabs. The click area is split to allow the user to display the content or ` &&
                         `alternatively to expand/collapse the sub tabs.`
            )->a( n = `class`    v = `sapUiSmallMargin`

        )->ele( `IconTabBar`
            )->a( n = `class` v = `sapUiResponsiveContentPadding`

            )->ele( `items`
                )->ele( `IconTabFilter`
                    )->a( n = `key`  v = `info`
                    )->a( n = `text` v = `Info`

                    )->ele( `items`
                        )->ele( `IconTabFilter`
                            )->a( n = `text` v = `Info one`

                            )->tag( `Text`
                                )->a( n = `text` v = `Info one content goes here...`
                            )->tag( `Text`
                                )->a( n = `text` v = `Select another sub tab to see its content...`

                        )->end(
                        )->ele( `IconTabFilter`
                            )->a( n = `text` v = `Info two`

                            )->tag( `Text`
                                )->a( n = `text` v = `Info two content goes here...`

                        )->end(
                        )->ele( `IconTabFilter`
                            )->a( n = `text` v = `Info three`

                            )->tag( `Text`
                                )->a( n = `text` v = `Info three content goes here...`

                        )->end(
                        )->ele( `IconTabFilter`
                            )->a( n = `text` v = `Info four`

                            )->tag( `Text`
                                )->a( n = `text` v = `Info four content goes here...`

                        )->end(
                    )->end(

                    )->tag( `Text`
                        )->a( n = `text` v = `Info own content goes here...`
                    )->tag( `Text`
                        )->a( n = `text` v = `Select a sub tab to see its content...`

                )->end(

                )->ele( `IconTabFilter`
                    )->a( n = `key`  v = `attachments`
                    )->a( n = `text` v = `Attachments`

                    )->ele( `items`
                        )->ele( `IconTabFilter`
                            )->a( n = `text` v = `Attachment one`

                            )->tag( `Text`
                                )->a( n = `text` v = `Attachment one goes here...`

                        )->end(
                        )->ele( `IconTabFilter`
                            )->a( n = `text` v = `Attachment two`

                            )->tag( `Text`
                                )->a( n = `text` v = `Attachment two goes here...`

                        )->end(
                    )->end(

                    )->tag( `Text`
                        )->a( n = `text` v = `Attachments own content goes here...`

                )->end(

                )->ele( `IconTabFilter`
                    )->a( n = `key`  v = `notes`
                    )->a( n = `text` v = `Notes`

                    )->ele( `items`
                        )->ele( `IconTabFilter`
                            )->a( n = `text` v = `Note one`

                            )->tag( `Text`
                                )->a( n = `text` v = `Note one goes here...`

                        )->end(
                        )->ele( `IconTabFilter`
                            )->a( n = `text` v = `Note two`

                            )->tag( `Text`
                                )->a( n = `text` v = `Note two goes here...`

                        )->end(
                    )->end(

                    )->tag( `Text`
                        )->a( n = `text` v = `Notes own content goes here...`

                )->end(
            )->end(
        )->end(

        )->tag( `Label`
            )->a( n = `wrapping` v = `true`
            )->a( n = `text`     v = `IconTabBar with filters without own content - only sub tabs`
            )->a( n = `class`    v = `sapUiSmallMargin`

        )->ele( `IconTabBar`
            )->a( n = `class` v = `sapUiResponsiveContentPadding`

            )->ele( `items`
                )->ele( `IconTabFilter`
                    )->a( n = `key`  v = `info`
                    )->a( n = `text` v = `Info`

                    )->ele( `items`
                        )->ele( `IconTabFilter`
                            )->a( n = `text` v = `Info one`

                            )->tag( `Text`
                                )->a( n = `text` v = `Info one content goes here...`

                        )->end(
                        )->ele( `IconTabFilter`
                            )->a( n = `text` v = `Info two`

                            )->tag( `Text`
                                )->a( n = `text` v = `Info two content goes here...`

                        )->end(
                        )->ele( `IconTabFilter`
                            )->a( n = `text` v = `Info three`

                            )->tag( `Text`
                                )->a( n = `text` v = `Info three content goes here...`

                        )->end(
                        )->ele( `IconTabFilter`
                            )->a( n = `text` v = `Info four`

                            )->tag( `Text`
                                )->a( n = `text` v = `Info four content goes here...`

                        )->end(
                    )->end(
                )->end(

                )->ele( `IconTabFilter`
                    )->a( n = `key`  v = `attachments`
                    )->a( n = `text` v = `Attachments`

                    )->ele( `items`
                        )->ele( `IconTabFilter`
                            )->a( n = `text` v = `Attachment one`

                            )->tag( `Text`
                                )->a( n = `text` v = `Attachment one goes here...`

                        )->end(
                        )->ele( `IconTabFilter`
                            )->a( n = `text` v = `Attachment two`

                            )->tag( `Text`
                                )->a( n = `text` v = `Attachment two goes here...`

                        )->end(
                    )->end(
                )->end(

                )->ele( `IconTabFilter`
                    )->a( n = `key`  v = `notes`
                    )->a( n = `text` v = `Notes`

                    )->ele( `items`
                        )->ele( `IconTabFilter`
                            )->a( n = `text` v = `Note one`

                            )->tag( `Text`
                                )->a( n = `text` v = `Note one content goes here...`

                        )->end(
                        )->ele( `IconTabFilter`
                            )->a( n = `text` v = `Note two`

                            )->tag( `Text`
                                )->a( n = `text` v = `Note two content goes here...` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
