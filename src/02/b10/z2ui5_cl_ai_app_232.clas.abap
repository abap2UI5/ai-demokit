CLASS z2ui5_cl_ai_app_232 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_country,
             key  TYPE string,
             text TYPE string,
           END OF ty_s_country.
    DATA t_countries TYPE STANDARD TABLE OF ty_s_country WITH EMPTY KEY.
    DATA value    TYPE string.
    DATA selected TYPE string.
    " the sample's $cmd> command model (CommandExecution enabled/visible) has no
    " abap2UI5 equivalent - modeled here as default-model booleans the switches
    " toggle two-way and the popover command-buttons bind their enabled/visible to
    DATA save_enabled   TYPE abap_bool.
    DATA delete_enabled TYPE abap_bool.
    DATA save_visible   TYPE abap_bool.
    DATA delete_visible TYPE abap_bool.
    DATA psave_enabled  TYPE abap_bool.
    DATA psave_visible  TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_232 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`   v = `sap.ui.core`
        )->a( n = `displayBlock` v = `true`

        )->open( `App`
            )->a( n = `id` v = `commands`

            )->open( `Page`
                )->a( n = `id`    v = `page`
                )->a( n = `title` v = `Commands`

                )->open( `dependents`
                    " the two core:CommandExecution controls (CE_SAVE/CE_DELETE) that
                    " sat here are DROPPED - no abap2UI5 equivalent for a command /
                    " keyboard-shortcut binding (see meta deviations + friction log)
                    )->open( `Popover`
                        )->a( n = `id`    v = `popoverCommand`
                        )->a( n = `title` v = `Popover`
                        )->a( n = `class` v = `sapUiContentPadding`

                        " the inner core:CommandExecution CE_SAVE_POPOVER is DROPPED too;
                        " the popover Save button binds enabled/visible to the popover flags
                        )->open( `footer`
                            )->open( `Toolbar`
                                )->leaf( `Button`
                                    )->a( n = `text`    v = `Delete`
                                    )->a( n = `enabled` v = client->_bind( delete_enabled )
                                    )->a( n = `visible` v = client->_bind( delete_visible )
                                    )->a( n = `press`   v = client->_event_client( val   = client->cs_event-control_global
                                                                                   t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `CTRL+D: Delete triggered on controller` ) ) )
                                )->leaf( `ToolbarSpacer`
                                )->leaf( `Button`
                                    )->a( n = `text`    v = `Save`
                                    )->a( n = `enabled` v = client->_bind( psave_enabled )
                                    )->a( n = `visible` v = client->_bind( psave_visible )
                                    )->a( n = `press`   v = client->_event_client( val   = client->cs_event-control_global
                                                                                   t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `CTRL+S: save triggered on controller` ) ) )

                            )->shut(
                        )->shut(
                        )->leaf( `Input`
                            )->a( n = `value` v = client->_bind( value )

                    )->shut(
                    )->open( `Popover`
                        )->a( n = `id`    v = `popover`
                        )->a( n = `title` v = `Popover`
                        )->a( n = `class` v = `sapUiContentPadding`

                        )->open( `footer`
                            )->open( `Toolbar`
                                )->leaf( `Button`
                                    )->a( n = `text`    v = `Delete`
                                    )->a( n = `enabled` v = client->_bind( delete_enabled )
                                    )->a( n = `visible` v = client->_bind( delete_visible )
                                    )->a( n = `press`   v = client->_event_client( val   = client->cs_event-control_global
                                                                                   t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `CTRL+D: Delete triggered on controller` ) ) )
                                )->leaf( `ToolbarSpacer`
                                )->leaf( `Button`
                                    )->a( n = `text`    v = `Save`
                                    )->a( n = `enabled` v = client->_bind( save_enabled )
                                    )->a( n = `visible` v = client->_bind( save_visible )
                                    )->a( n = `press`   v = client->_event_client( val   = client->cs_event-control_global
                                                                                   t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `CTRL+S: save triggered on controller` ) ) )

                            )->shut(
                        )->shut(
                        )->leaf( `Input`
                            )->a( n = `value` v = client->_bind( value )

                    )->shut(
                )->shut(

                )->open( `Panel`
                    )->a( n = `headerText` v = `Button`

                    )->leaf( `Button`
                        )->a( n = `text`  v = `Save`
                        )->a( n = `press` v = client->_event_client( val   = client->cs_event-control_global
                                                                     t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `CTRL+S: save triggered on controller` ) ) )

                )->shut(

                )->open( `Panel`
                    )->a( n = `headerText` v = `sap.m.Input`

                    )->leaf( `Input`
                        )->a( n = `id`    v = `myInput`
                        )->a( n = `value` v = client->_bind( value )

                )->shut(

                )->open( `Panel`
                    )->a( n = `headerText` v = `sap.m.ComboBox`

                    )->open( `ComboBox`
                        )->a( n = `items`       v = client->_bind( t_countries )
                        )->a( n = `selectedKey` v = client->_bind( selected )

                        )->leaf( n = `Item` ns = `core`
                            )->a( n = `key`  v = `{KEY}`
                            )->a( n = `text` v = `{TEXT}`

                    )->shut(
                )->shut(

                )->open( `Panel`
                    )->a( n = `headerText` v = `sap.m.Select`

                    )->open( `Select`
                        )->a( n = `selectedKey` v = client->_bind( selected )
                        )->a( n = `items`       v = |\{ path: '{ client->_bind( val = t_countries path = abap_true ) }', sorter: \{ path: 'TEXT' \} \}|

                        )->leaf( n = `Item` ns = `core`
                            )->a( n = `key`  v = `{KEY}`
                            )->a( n = `text` v = `{TEXT}`

                    )->shut(
                )->shut(

                )->open( `Panel`
                    )->a( n = `headerText` v = `Popover - CommandExecution defined on underlying content`

                    )->leaf( `Button`
                        )->a( n = `text`         v = `Open Popover`
                        )->a( n = `ariaHasPopup` v = `Dialog`
                        )->a( n = `press`        v = client->_event_client( val   = client->cs_event-control_by_id
                                                                            t_arg = VALUE #( ( `popover` ) ( `openBy` ) ( `$event.oSource.sId` ) ) )

                )->shut(

                )->open( `Panel`
                    )->a( n = `headerText` v = `Popover - CommandExecution defined in Popup content`

                    )->leaf( `Button`
                        )->a( n = `text`         v = `Open Popover`
                        )->a( n = `ariaHasPopup` v = `Dialog`
                        )->a( n = `press`        v = client->_event_client( val   = client->cs_event-control_by_id
                                                                            t_arg = VALUE #( ( `popoverCommand` ) ( `openBy` ) ( `$event.oSource.sId` ) ) )

                )->shut(

                )->open( `Panel`
                    )->a( n = `headerText` v = `toggle enabled/visibility for CommandExecution in Page`

                    )->open( `Panel`
                        )->a( n = `headerText` v = `enabled`

                        )->leaf( `Label`
                            )->a( n = `text` v = `Save:`
                        )->leaf( `Switch`
                            )->a( n = `state` v = client->_bind( save_enabled )
                        )->leaf( `Label`
                            )->a( n = `text` v = `Delete:`
                        )->leaf( `Switch`
                            )->a( n = `state` v = client->_bind( delete_enabled )

                    )->shut(
                    )->open( `Panel`
                        )->a( n = `headerText` v = `visible`

                        )->leaf( `Label`
                            )->a( n = `text` v = `Save:`
                        )->leaf( `Switch`
                            )->a( n = `state` v = client->_bind( save_visible )
                        )->leaf( `Label`
                            )->a( n = `text` v = `Delete:`
                        )->leaf( `Switch`
                            )->a( n = `state` v = client->_bind( delete_visible )

                    )->shut(
                )->shut(

                )->open( `Panel`
                    )->a( n = `headerText` v = `toggle enabled/visibility for CommandExecution in Popover`

                    )->open( `Panel`
                        )->a( n = `headerText` v = `enabled`

                        )->leaf( `Label`
                            )->a( n = `text` v = `Save:`
                        )->leaf( `Switch`
                            )->a( n = `state` v = client->_bind( psave_enabled )

                    )->shut(
                    )->open( `Panel`
                        )->a( n = `headerText` v = `visible`

                        )->leaf( `Label`
                            )->a( n = `text` v = `Save:`
                        )->leaf( `Switch`
                            )->a( n = `state` v = client->_bind( psave_visible )

                    )->shut(
                )->shut(
            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    value    = `HelloWorld!`.
    selected = ``.

    save_enabled   = abap_true.
    delete_enabled = abap_true.
    save_visible   = abap_true.
    delete_visible = abap_true.
    psave_enabled  = abap_true.
    psave_visible  = abap_true.

    t_countries = VALUE #( ( key = `DZ` text = `Algeria` )
                           ( key = `AR` text = `Argentina` ) ).

  ENDMETHOD.

ENDCLASS.
