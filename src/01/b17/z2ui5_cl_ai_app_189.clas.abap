CLASS z2ui5_cl_ai_app_189 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_189 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( `Page`
            )->a( n = `title`         v = `Bar can center a Title.`
            )->a( n = `titleLevel`    v = `H2`
            )->a( n = `class`         v = `sapUiContentPadding`
            )->a( n = `showNavButton` v = `true`

            )->open( `headerContent`
                )->leaf( `Button`
                    )->a( n = `icon` v = `sap-icon://action`

            )->shut(
            )->open( `subHeader`
                )->open( `Toolbar`
                    )->leaf( `Button`
                        )->a( n = `type`    v = `Back`
                        )->a( n = `tooltip` v = `Back`
                    )->leaf( `ToolbarSpacer`
                    )->leaf( `Title`
                        )->a( n = `text`  v = `Toolbar center`
                        )->a( n = `level` v = `H3`
                    )->leaf( `ToolbarSpacer`

                )->shut(
            )->shut(
            )->open( `content`
                )->leaf( `MessageStrip`
                    )->a( n = `text`  v = `A Toolbar's centering technique will be slightly off the center if there is a button on the left.`
                    )->a( n = `class` v = `sapUiTinyMargin`

                )->open( `Toolbar`
                    )->open( `Label`
                        )->a( n = `text` v = `Toolbar can shrink content in case of overflow.`

                        )->open( `layoutData`
                            )->leaf( `ToolbarLayoutData`
                                )->a( n = `shrinkable` v = `false`

                        )->shut(
                    )->shut(
                    )->open( `Button`
                        )->a( n = `text` v = `Accept`
                        )->a( n = `type` v = `Accept`

                        )->open( `layoutData`
                            )->leaf( `ToolbarLayoutData`
                                )->a( n = `shrinkable` v = `true`

                        )->shut(
                    )->shut(
                    )->open( `Label`
                        )->a( n = `text` v = `This is a long non-shrinkable label.`

                        )->open( `layoutData`
                            )->leaf( `ToolbarLayoutData`
                                )->a( n = `shrinkable` v = `false`

                        )->shut(
                    )->shut(
                    )->open( `Button`
                        )->a( n = `text` v = `Reject`
                        )->a( n = `type` v = `Reject`

                        )->open( `layoutData`
                            )->leaf( `ToolbarLayoutData`
                                )->a( n = `shrinkable` v = `true`

                        )->shut(
                    )->shut(
                    )->open( `Button`
                        )->a( n = `text` v = `Big Big Big Big Big Big Big Big Button`

                        )->open( `layoutData`
                            )->leaf( `ToolbarLayoutData`
                                )->a( n = `shrinkable` v = `true`

                        )->shut(
                    )->shut(
                )->shut(
                )->leaf( `Label`

                )->open( `Bar`
                    )->open( `contentLeft`
                        )->leaf( `Label`
                            )->a( n = `text` v = `Bar cannot really handle overflow it just cuts the content.`

                    )->shut(
                    )->open( `contentMiddle`
                        )->leaf( `Button`
                            )->a( n = `text` v = `Accept`
                            )->a( n = `type` v = `Accept`
                        )->leaf( `Label`
                            )->a( n = `text` v = `This is a long non-shrinkable label.`
                        )->leaf( `Button`
                            )->a( n = `text` v = `Reject`
                            )->a( n = `type` v = `Reject`
                        )->leaf( `Button`
                            )->a( n = `text` v = `Edit`
                        )->leaf( `Button`
                            )->a( n = `text` v = `Big Big Big Big Big Big Big Big Button`

                    )->shut(
                )->shut(
                )->leaf( `Label`

                )->open( `OverflowToolbar`
                    )->open( `Label`
                        )->a( n = `text` v = `OverflowToolbar provides a See more (...) button for overflow.`

                        )->open( `layoutData`
                            )->leaf( `ToolbarLayoutData`
                                )->a( n = `shrinkable` v = `false`

                        )->shut(
                    )->shut(
                    )->open( `Button`
                        )->a( n = `text` v = `Accept`
                        )->a( n = `type` v = `Accept`

                        )->open( `layoutData`
                            )->leaf( `ToolbarLayoutData`
                                )->a( n = `shrinkable` v = `true`

                        )->shut(
                    )->shut(
                    )->open( `Label`
                        )->a( n = `text` v = `This is a long non-shrinkable label`

                        )->open( `layoutData`
                            )->leaf( `ToolbarLayoutData`
                                )->a( n = `shrinkable` v = `false`

                        )->shut(
                    )->shut(
                    )->open( `Button`
                        )->a( n = `text` v = `Reject`
                        )->a( n = `type` v = `Reject`

                        )->open( `layoutData`
                            )->leaf( `ToolbarLayoutData`
                                )->a( n = `shrinkable` v = `true`

                        )->shut(
                    )->shut(
                    )->open( `Button`
                        )->a( n = `text` v = `Big Big Big Big Big Big Big Big Button`

                        )->open( `layoutData`
                            )->leaf( `ToolbarLayoutData`
                                )->a( n = `shrinkable` v = `true`

                        )->shut(
                    )->shut(
                )->shut(
            )->shut(
            )->open( `footer`
                )->open( `Toolbar`

                )->shut(
            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
