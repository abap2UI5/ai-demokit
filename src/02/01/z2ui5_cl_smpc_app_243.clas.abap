CLASS z2ui5_cl_smpc_app_243 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " both popovers bindElement("/ProductCollection/0") - a single record; its
    " fields are seeded at the default-model root so the fragments' relative
    " {NAME}/{PRODUCTPICURL} bindings resolve against the model root
    DATA name         TYPE string.
    DATA productpicurl TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_243 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->ele( n = `content` ns = `l`
                )->tag( `Button`
                    )->a( n = `text`         v = `Show Dialog (phone) or Popover (Other)`
                    " handleResponsivePopoverPress: Fragment.load(Popover) -> openBy(button)
                    )->a( n = `press`        v = client->_event( val   = `SHOW_POPOVER`
                                                                 t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
                    )->a( n = `ariaHasPopup` v = `Dialog`
                )->tag( `Button`
                    )->a( n = `text`         v = `Popover with Custom Footer`
                    " handleResponsivePopoverFooterPress: Fragment.load(PopoverFooter) -> openBy(button)
                    )->a( n = `press`        v = client->_event( val   = `SHOW_POPOVER_FOOTER`
                                                                 t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
                    )->a( n = `ariaHasPopup` v = `Dialog`

            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `SHOW_POPOVER`.
        " Popover.fragment.xml: a ResponsivePopover with begin/end action buttons,
        " built server-side and shown anchored to the pressed button
        " ($event.oSource.sId); bindElement("/ProductCollection/0") is folded to
        " the root-seeded fields (relative {NAME}/{PRODUCTPICURL} resolve there)
        DATA(popover) = z2ui5_cl_ui5_view_builder=>factory( ).
        popover->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core`

            )->ele( `ResponsivePopover`
                )->a( n = `id`        v = `myPopover`
                )->a( n = `title`     v = client->_bind( name )
                )->a( n = `class`     v = `sapUiContentPadding`
                )->a( n = `placement` v = `Bottom`

                )->ele( `beginButton`
                    )->tag( `Button`
                        )->a( n = `text`  v = `Action-A`
                        )->a( n = `press` v = client->_event( `CLOSE` )

                )->end(

                )->ele( `endButton`
                    )->tag( `Button`
                        )->a( n = `text`  v = `Action-B`
                        )->a( n = `press` v = client->_event( `CLOSE` )

                )->end(

                )->ele( `content`
                    )->tag( `Image`
                        )->a( n = `src`   v = client->_bind( productpicurl )
                        )->a( n = `width` v = `15em`

                )->end(
            )->end( ).
        client->popover_display( xml   = popover->stringify( )
                                 by_id = client->get_event_arg( ) ).

      WHEN `SHOW_POPOVER_FOOTER`.
        " PopoverFooter.fragment.xml: a ResponsivePopover with a custom footer
        " OverflowToolbar (OK / Cancel), same anchoring + root-seeded record
        DATA(footer) = z2ui5_cl_ui5_view_builder=>factory( ).
        footer->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core`

            )->ele( `ResponsivePopover`
                )->a( n = `id`                 v = `myFooterPopover`
                )->a( n = `title`              v = client->_bind( name )
                )->a( n = `class`              v = `sapUiContentPadding`
                )->a( n = `placement`          v = `Bottom`
                )->a( n = `contentWidth`       v = `320px`
                )->a( n = `horizontalScrolling` v = `false`

                )->ele( `content`
                    )->tag( `Image`
                        )->a( n = `src`   v = client->_bind( productpicurl )
                        )->a( n = `width` v = `15em`

                )->end(

                )->ele( `footer`
                    )->ele( `OverflowToolbar`
                        )->ele( `content`
                            )->tag( `ToolbarSpacer`
                            )->tag( `Button`
                                )->a( n = `text` v = `OK`
                            )->tag( `Button`
                                )->a( n = `text`  v = `Cancel`
                                )->a( n = `press` v = client->_event( `CLOSE` )

                        )->end(
                    )->end(
                )->end(
            )->end( ).
        client->popover_display( xml   = footer->stringify( )
                                 by_id = client->get_event_arg( ) ).

      WHEN `CLOSE`.
        " handleCloseButton / handleCloseFooterButton: byId(...).close() - one
        " popover slot is open at a time, so a single popover_close covers both
        client->follow_up_action( client->cs_event-popover_close ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " /ProductCollection/0 of ui5/mock/products.json - the single record both
    " popovers bindElement to; the picture URL points at the OpenUI5 host
    name          = `Notebook Basic 15`.
    productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`.

  ENDMETHOD.

ENDCLASS.
