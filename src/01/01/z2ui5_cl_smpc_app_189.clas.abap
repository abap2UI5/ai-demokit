CLASS z2ui5_cl_smpc_app_189 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_189 IMPLEMENTATION.

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
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `Page`
            )->a( n = `title`         v = `Bar can center a Title.`
            )->a( n = `titleLevel`    v = `H2`
            )->a( n = `class`         v = `sapUiContentPadding`
            )->a( n = `showNavButton` v = `true`

            )->ele( `headerContent`
                )->tag( `Button`
                    )->a( n = `icon` v = `sap-icon://action`

            )->end(
            )->ele( `subHeader`
                )->ele( `Toolbar`
                    )->tag( `Button`
                        )->a( n = `type`    v = `Back`
                        )->a( n = `tooltip` v = `Back`
                    )->tag( `ToolbarSpacer`
                    )->tag( `Title`
                        )->a( n = `text`  v = `Toolbar center`
                        )->a( n = `level` v = `H3`
                    )->tag( `ToolbarSpacer`

                )->end(
            )->end(
            )->ele( `content`
                )->tag( `MessageStrip`
                    )->a( n = `text`  v = `A Toolbar's centering technique will be slightly off the center if there is a button on the left.`
                    )->a( n = `class` v = `sapUiTinyMargin`

                )->ele( `Toolbar`
                    )->ele( `Label`
                        )->a( n = `text` v = `Toolbar can shrink content in case of overflow.`

                        )->ele( `layoutData`
                            )->tag( `ToolbarLayoutData`
                                )->a( n = `shrinkable` v = `false`

                        )->end(
                    )->end(
                    )->ele( `Button`
                        )->a( n = `text` v = `Accept`
                        )->a( n = `type` v = `Accept`

                        )->ele( `layoutData`
                            )->tag( `ToolbarLayoutData`
                                )->a( n = `shrinkable` v = `true`

                        )->end(
                    )->end(
                    )->ele( `Label`
                        )->a( n = `text` v = `This is a long non-shrinkable label.`

                        )->ele( `layoutData`
                            )->tag( `ToolbarLayoutData`
                                )->a( n = `shrinkable` v = `false`

                        )->end(
                    )->end(
                    )->ele( `Button`
                        )->a( n = `text` v = `Reject`
                        )->a( n = `type` v = `Reject`

                        )->ele( `layoutData`
                            )->tag( `ToolbarLayoutData`
                                )->a( n = `shrinkable` v = `true`

                        )->end(
                    )->end(
                    )->ele( `Button`
                        )->a( n = `text` v = `Big Big Big Big Big Big Big Big Button`

                        )->ele( `layoutData`
                            )->tag( `ToolbarLayoutData`
                                )->a( n = `shrinkable` v = `true`

                        )->end(
                    )->end(
                )->end(
                )->tag( `Label`

                )->ele( `Bar`
                    )->ele( `contentLeft`
                        )->tag( `Label`
                            )->a( n = `text` v = `Bar cannot really handle overflow it just cuts the content.`

                    )->end(
                    )->ele( `contentMiddle`
                        )->tag( `Button`
                            )->a( n = `text` v = `Accept`
                            )->a( n = `type` v = `Accept`
                        )->tag( `Label`
                            )->a( n = `text` v = `This is a long non-shrinkable label.`
                        )->tag( `Button`
                            )->a( n = `text` v = `Reject`
                            )->a( n = `type` v = `Reject`
                        )->tag( `Button`
                            )->a( n = `text` v = `Edit`
                        )->tag( `Button`
                            )->a( n = `text` v = `Big Big Big Big Big Big Big Big Button`

                    )->end(
                )->end(
                )->tag( `Label`

                )->ele( `OverflowToolbar`
                    )->ele( `Label`
                        )->a( n = `text` v = `OverflowToolbar provides a See more (...) button for overflow.`

                        )->ele( `layoutData`
                            )->tag( `ToolbarLayoutData`
                                )->a( n = `shrinkable` v = `false`

                        )->end(
                    )->end(
                    )->ele( `Button`
                        )->a( n = `text` v = `Accept`
                        )->a( n = `type` v = `Accept`

                        )->ele( `layoutData`
                            )->tag( `ToolbarLayoutData`
                                )->a( n = `shrinkable` v = `true`

                        )->end(
                    )->end(
                    )->ele( `Label`
                        )->a( n = `text` v = `This is a long non-shrinkable label`

                        )->ele( `layoutData`
                            )->tag( `ToolbarLayoutData`
                                )->a( n = `shrinkable` v = `false`

                        )->end(
                    )->end(
                    )->ele( `Button`
                        )->a( n = `text` v = `Reject`
                        )->a( n = `type` v = `Reject`

                        )->ele( `layoutData`
                            )->tag( `ToolbarLayoutData`
                                )->a( n = `shrinkable` v = `true`

                        )->end(
                    )->end(
                    )->ele( `Button`
                        )->a( n = `text` v = `Big Big Big Big Big Big Big Big Button`

                        )->ele( `layoutData`
                            )->tag( `ToolbarLayoutData`
                                )->a( n = `shrinkable` v = `true`

                        )->end(
                    )->end(
                )->end(
            )->end(
            )->ele( `footer`
                )->ele( `Toolbar`

                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
