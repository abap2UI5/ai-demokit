CLASS z2ui5_cl_smpc_app_229 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " the sample binds both popovers to /ProductCollection/0 (a single record);
    " row-0 fields are seeded at the default-model root so the popover's relative
    " child bindings ({NAME}, {PRODUCTPICURL}) resolve against the model root
    DATA name          TYPE string.
    DATA productpicurl TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_229 IMPLEMENTATION.

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
                    )->a( n = `text`         v = `Show Popover`
                    " handlePopoverPress: the popover is built + anchored to the pressed button
                    )->a( n = `press`        v = client->_event( val   = `SHOW_POPOVER`
                                                                 t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
                    )->a( n = `ariaHasPopup` v = `Dialog`
                )->tag( `Button`
                    )->a( n = `press`        v = client->_event( val   = `SHOW_RESIZABLE`
                                                                 t_arg = VALUE #( ( `$event.oSource.sId` ) ) )
                    )->a( n = `text`         v = `Show Resizable Popover`
                    )->a( n = `ariaHasPopup` v = `Dialog`

            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `SHOW_POPOVER`.
        " handlePopoverPress: Fragment.load(Popover) -> openBy(button). The
        " popover is built server-side and shown anchored to the pressed button
        " ($event.oSource.sId); bindElement("/ProductCollection/0") is folded to
        " the root-seeded fields (relative {NAME}/{PRODUCTPICURL} resolve there)
        DATA(popover) = z2ui5_cl_ui5_view_builder=>factory( ).
        popover->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core`
            )->ele( `Popover`
                )->a( n = `id`           v = `myPopover`
                )->a( n = `title`        v = client->_bind( name )
                )->a( n = `class`        v = `sapUiResponsivePadding--header sapUiResponsivePadding--footer`
                )->a( n = `placement`    v = `Bottom`
                )->a( n = `initialFocus` v = `email`
                )->ele( `footer`
                    )->ele( `OverflowToolbar`
                        )->tag( `ToolbarSpacer`
                        )->tag( `Button`
                            )->a( n = `id`    v = `email`
                            )->a( n = `text`  v = `Email`
                            )->a( n = `press` v = client->_event( `EMAIL` )

                    )->end(
                )->end(
                )->tag( `Image`
                    )->a( n = `src`          v = client->_bind( productpicurl )
                    )->a( n = `width`        v = `15em`
                    )->a( n = `densityAware` v = `false`

            )->end( ).
        client->popover_display( xml   = popover->stringify( )
                                 by_id = client->get_event_arg( ) ).

      WHEN `SHOW_RESIZABLE`.
        " handleResizablePopoverPress: the resizable variant, same anchoring
        DATA(resizable) = z2ui5_cl_ui5_view_builder=>factory( ).
        resizable->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core`
            )->ele( `Popover`
                )->a( n = `id`           v = `myResizablePopover`
                )->a( n = `title`        v = client->_bind( name )
                )->a( n = `class`        v = `sapUiResponsivePadding--header sapUiResponsivePadding--footer`
                )->a( n = `placement`    v = `Right`
                )->a( n = `resizable`    v = `true`
                )->a( n = `initialFocus` v = `close`
                )->ele( `footer`
                    )->ele( `OverflowToolbar`
                        )->tag( `ToolbarSpacer`
                        )->tag( `Button`
                            )->a( n = `id`    v = `close`
                            )->a( n = `text`  v = `Close`
                            )->a( n = `press` v = client->_event( `CLOSE` )

                    )->end(
                )->end(
                )->tag( `Image`
                    )->a( n = `src`          v = client->_bind( productpicurl )
                    )->a( n = `width`        v = `15em`
                    )->a( n = `densityAware` v = `false`

            )->end( ).
        client->popover_display( xml   = resizable->stringify( )
                                 by_id = client->get_event_arg( ) ).

      WHEN `EMAIL`.
        " handleEmailPress: byId("myPopover").close() + MessageToast.show
        client->message_toast_display( `E-Mail has been sent` ).
        client->follow_up_action( client->cs_event-popover_close ).

      WHEN `CLOSE`.
        " handleClose: byId("myResizablePopover").close()
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
