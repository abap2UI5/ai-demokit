" @keywords navcontainer nav container sap.m vbox overflowtoolbar button hbox flexitemdata select
" @summary The Nav Container stacks multiple pages and offers an API to switch between them with some animation. Typically application developers would use the App control which inherits from NavContainer.
CLASS z2ui5_cl_smpc_app_242 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " the animation Select's selectedKey is two-way bound so the backend knows
    " which transition to hand navCon.to(); seeded to the first item's key
    DATA animation TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_242 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      animation = `slide`.
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`

        " the sample's style.css (border around the NavContainer), injected via a
        " core:HTML content attribute (see CAPABILITIES.md); braces escaped \{ \}
        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.navContainerControl\{border-color:#888;border-style:solid;border-width:0.0625em;\}</style>`

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin`

            )->ele( `NavContainer`
                )->a( n = `id`     v = `navCon`
                )->a( n = `width`  v = `98%`
                )->a( n = `height` v = `16em`
                )->a( n = `class`  v = `navContainerControl sapUiSmallMarginBottom`
                " onNavigationFinished: MessageToast.show("Navigation to page '" + to.getTitle() + "' finished")
                " - client-composed toast, the {0} placeholder filled by the resolved page title
                )->a( n = `navigationFinished` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                             t_arg = VALUE #( ( `MESSAGE_TOAST` )
                                                                                           ( `show` )
                                                                                           ( `Navigation to page '{0}' finished` )
                                                                                           ( `${$parameters>/to}.getTitle()` ) ) )

                )->ele( `Page`
                    )->a( n = `id`    v = `p1`
                    )->a( n = `title` v = `Page 1`

                    )->ele( `footer`
                        )->ele( `OverflowToolbar`
                            )->tag( `Button`
                                )->a( n = `text` v = `Action 1`

                        )->end(
                    )->end(
                )->end(
                )->ele( `Page`
                    )->a( n = `id`    v = `p2`
                    )->a( n = `title` v = `Page 2`

                    )->ele( `footer`
                        )->ele( `OverflowToolbar`
                            )->tag( `Button`
                                )->a( n = `text` v = `Action 2`

                        )->end(
                    )->end(
                )->end(
                )->ele( `Page`
                    )->a( n = `id`    v = `p3`
                    )->a( n = `title` v = `Page 3`

                    )->ele( `footer`
                        )->ele( `OverflowToolbar`
                            )->tag( `Button`
                                )->a( n = `text` v = `Action 3`

                        )->end(
                    )->end(
                )->end(
                )->ele( `Page`
                    )->a( n = `id`    v = `p4`
                    )->a( n = `title` v = `Page 4`

                    )->ele( `footer`
                        )->ele( `OverflowToolbar`
                            )->tag( `Button`
                                )->a( n = `text` v = `Action 4`

                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( `HBox`
                )->ele( `Button`
                    )->a( n = `text`  v = `To 1`
                    )->a( n = `press` v = client->_event( val = `NAV` t_arg = VALUE #( ( `p1` ) ) )

                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->end(

                    )->ele( `customData`
                        )->tag( n = `CustomData` ns = `core`
                            )->a( n = `key`   v = `target`
                            )->a( n = `value` v = `p1`

                    )->end(
                )->end(
                )->ele( `Button`
                    )->a( n = `text`  v = `To 2`
                    )->a( n = `press` v = client->_event( val = `NAV` t_arg = VALUE #( ( `p2` ) ) )

                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->end(

                    )->ele( `customData`
                        )->tag( n = `CustomData` ns = `core`
                            )->a( n = `key`   v = `target`
                            )->a( n = `value` v = `p2`

                    )->end(
                )->end(
                )->ele( `Button`
                    )->a( n = `text`  v = `To 3`
                    )->a( n = `press` v = client->_event( val = `NAV` t_arg = VALUE #( ( `p3` ) ) )

                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->end(

                    )->ele( `customData`
                        )->tag( n = `CustomData` ns = `core`
                            )->a( n = `key`   v = `target`
                            )->a( n = `value` v = `p3`

                    )->end(
                )->end(
                )->ele( `Button`
                    )->a( n = `text`  v = `To 4`
                    )->a( n = `press` v = client->_event( val = `NAV` t_arg = VALUE #( ( `p4` ) ) )

                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->end(

                    )->ele( `customData`
                        )->tag( n = `CustomData` ns = `core`
                            )->a( n = `key`   v = `target`
                            )->a( n = `value` v = `p4`

                    )->end(
                )->end(
            )->end(

            )->ele( `HBox`
                )->ele( `Button`
                    )->a( n = `text`  v = `Back`
                    )->a( n = `type`  v = `Back`
                    )->a( n = `press` v = client->_event( `NAV_BACK` )

                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->end(
                )->end(
                )->ele( `Select`
                    )->a( n = `id`          v = `animationSelect`
                    )->a( n = `selectedKey` v = client->_bind( animation )

                    )->tag( n = `Item` ns = `core`
                        )->a( n = `text` v = `Slide animation`
                        )->a( n = `key`  v = `slide`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `text` v = `Base slide animation`
                        )->a( n = `key`  v = `baseSlide`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `text` v = `Fade animation`
                        )->a( n = `key`  v = `fade`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `text` v = `Flip animation`
                        )->a( n = `key`  v = `flip`
                    )->tag( n = `Item` ns = `core`
                        )->a( n = `text` v = `Show animation`
                        )->a( n = `key`  v = `show`

                    )->ele( `layoutData`
                        )->tag( `FlexItemData`
                            )->a( n = `growFactor` v = `1`

                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `NAV`.
        " handleNav (with a target): navCon.to( byId(target), animationSelect.getSelectedKey() )
        " - the target page id rides the button's event arg, the transition is the
        " two-way bound Select value applied before this handler runs
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `navCon` ) ( `to` ) ( client->get_event_arg( ) ) ( animation ) ) ).

      WHEN `NAV_BACK`.
        " handleNav (no target): navCon.back()
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `navCon` ) ( `back` ) ) ).

    ENDCASE.

  ENDMETHOD.

ENDCLASS.
