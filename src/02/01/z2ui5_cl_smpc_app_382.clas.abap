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
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->leaf( `Label`
            )->a( n = `wrapping` v = `true`
            )->a( n = `text`
                     v = `IconTabBar with filters with own content and sub tabs. The click area is split to allow the user to display the content or ` &&
                         `alternatively to expand/collapse the sub tabs.`
            )->a( n = `class`    v = `sapUiSmallMargin`

        )->open( `IconTabBar`
            )->a( n = `class` v = `sapUiResponsiveContentPadding`

            )->open( `items`
                )->open( `IconTabFilter`
                    )->a( n = `key`  v = `info`
                    )->a( n = `text` v = `Info`

                    )->open( `items`
                        )->open( `IconTabFilter`
                            )->a( n = `text` v = `Info one`

                            )->leaf( `Text`
                                )->a( n = `text` v = `Info one content goes here...`
                            )->leaf( `Text`
                                )->a( n = `text` v = `Select another sub tab to see its content...`

                        )->shut(
                        )->open( `IconTabFilter`
                            )->a( n = `text` v = `Info two`

                            )->leaf( `Text`
                                )->a( n = `text` v = `Info two content goes here...`

                        )->shut(
                        )->open( `IconTabFilter`
                            )->a( n = `text` v = `Info three`

                            )->leaf( `Text`
                                )->a( n = `text` v = `Info three content goes here...`

                        )->shut(
                        )->open( `IconTabFilter`
                            )->a( n = `text` v = `Info four`

                            )->leaf( `Text`
                                )->a( n = `text` v = `Info four content goes here...`

                        )->shut(
                    )->shut(

                    )->leaf( `Text`
                        )->a( n = `text` v = `Info own content goes here...`
                    )->leaf( `Text`
                        )->a( n = `text` v = `Select a sub tab to see its content...`

                )->shut(

                )->open( `IconTabFilter`
                    )->a( n = `key`  v = `attachments`
                    )->a( n = `text` v = `Attachments`

                    )->open( `items`
                        )->open( `IconTabFilter`
                            )->a( n = `text` v = `Attachment one`

                            )->leaf( `Text`
                                )->a( n = `text` v = `Attachment one goes here...`

                        )->shut(
                        )->open( `IconTabFilter`
                            )->a( n = `text` v = `Attachment two`

                            )->leaf( `Text`
                                )->a( n = `text` v = `Attachment two goes here...`

                        )->shut(
                    )->shut(

                    )->leaf( `Text`
                        )->a( n = `text` v = `Attachments own content goes here...`

                )->shut(

                )->open( `IconTabFilter`
                    )->a( n = `key`  v = `notes`
                    )->a( n = `text` v = `Notes`

                    )->open( `items`
                        )->open( `IconTabFilter`
                            )->a( n = `text` v = `Note one`

                            )->leaf( `Text`
                                )->a( n = `text` v = `Note one goes here...`

                        )->shut(
                        )->open( `IconTabFilter`
                            )->a( n = `text` v = `Note two`

                            )->leaf( `Text`
                                )->a( n = `text` v = `Note two goes here...`

                        )->shut(
                    )->shut(

                    )->leaf( `Text`
                        )->a( n = `text` v = `Notes own content goes here...`

                )->shut(
            )->shut(
        )->shut(

        )->leaf( `Label`
            )->a( n = `wrapping` v = `true`
            )->a( n = `text`     v = `IconTabBar with filters without own content - only sub tabs`
            )->a( n = `class`    v = `sapUiSmallMargin`

        )->open( `IconTabBar`
            )->a( n = `class` v = `sapUiResponsiveContentPadding`

            )->open( `items`
                )->open( `IconTabFilter`
                    )->a( n = `key`  v = `info`
                    )->a( n = `text` v = `Info`

                    )->open( `items`
                        )->open( `IconTabFilter`
                            )->a( n = `text` v = `Info one`

                            )->leaf( `Text`
                                )->a( n = `text` v = `Info one content goes here...`

                        )->shut(
                        )->open( `IconTabFilter`
                            )->a( n = `text` v = `Info two`

                            )->leaf( `Text`
                                )->a( n = `text` v = `Info two content goes here...`

                        )->shut(
                        )->open( `IconTabFilter`
                            )->a( n = `text` v = `Info three`

                            )->leaf( `Text`
                                )->a( n = `text` v = `Info three content goes here...`

                        )->shut(
                        )->open( `IconTabFilter`
                            )->a( n = `text` v = `Info four`

                            )->leaf( `Text`
                                )->a( n = `text` v = `Info four content goes here...`

                        )->shut(
                    )->shut(
                )->shut(

                )->open( `IconTabFilter`
                    )->a( n = `key`  v = `attachments`
                    )->a( n = `text` v = `Attachments`

                    )->open( `items`
                        )->open( `IconTabFilter`
                            )->a( n = `text` v = `Attachment one`

                            )->leaf( `Text`
                                )->a( n = `text` v = `Attachment one goes here...`

                        )->shut(
                        )->open( `IconTabFilter`
                            )->a( n = `text` v = `Attachment two`

                            )->leaf( `Text`
                                )->a( n = `text` v = `Attachment two goes here...`

                        )->shut(
                    )->shut(
                )->shut(

                )->open( `IconTabFilter`
                    )->a( n = `key`  v = `notes`
                    )->a( n = `text` v = `Notes`

                    )->open( `items`
                        )->open( `IconTabFilter`
                            )->a( n = `text` v = `Note one`

                            )->leaf( `Text`
                                )->a( n = `text` v = `Note one content goes here...`

                        )->shut(
                        )->open( `IconTabFilter`
                            )->a( n = `text` v = `Note two`

                            )->leaf( `Text`
                                )->a( n = `text` v = `Note two content goes here...` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
