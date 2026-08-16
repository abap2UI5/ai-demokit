" @keywords messagepopover message popover sap.m list overflowtoolbar button messageitem link toolbarspacer
CLASS z2ui5_cl_smpc_app_066 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_message,
        type        TYPE string,
        title       TYPE string,
        active      TYPE abap_bool,
        description TYPE string,
        subtitle    TYPE string,
        counter     TYPE i,
      END OF ty_s_message.

    DATA t_messages    TYPE STANDARD TABLE OF ty_s_message WITH EMPTY KEY.
    DATA highest_icon  TYPE string.
    DATA highest_type  TYPE string.
    DATA highest_count TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_066 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
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
            )->a( n = `showHeader` v = `false`

            )->ele( `footer`
                )->ele( `OverflowToolbar`

                    )->ele( `Button`
                        )->a( n = `id`           v = `messagePopoverBtn`
                        )->a( n = `icon`         v = client->_bind( highest_icon )
                        )->a( n = `type`         v = client->_bind( highest_type )
                        )->a( n = `text`         v = client->_bind( highest_count )
                        )->a( n = `ariaHasPopup` v = `Dialog`
                        )->a( n = `press`        v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                               t_arg = VALUE #( ( `messagePopover` ) ( `toggleBy` ) ( `messagePopoverBtn` ) ) )

                        )->ele( `dependents`
                            )->ele( `MessagePopover`
                                )->a( n = `id`              v = `messagePopover`
                                )->a( n = `items`           v = client->_bind( t_messages )
                                )->a( n = `activeTitlePress` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                           t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `Active title is pressed` ) ) )

                                )->ele( `MessageItem`
                                    )->a( n = `type`        v = `{TYPE}`
                                    )->a( n = `title`       v = `{TITLE}`
                                    )->a( n = `activeTitle` v = `{ACTIVE}`
                                    )->a( n = `description` v = `{DESCRIPTION}`
                                    )->a( n = `subtitle`    v = `{SUBTITLE}`
                                    )->a( n = `counter`     v = `{COUNTER}`

                                    )->ele( `link`
                                        )->tag( `Link`
                                            )->a( n = `text`   v = `Show more information`
                                            )->a( n = `href`   v = `http://sap.com`
                                            )->a( n = `target` v = `_blank`

                                    )->end(
                                )->end(
                            )->end(
                        )->end(
                    )->end(

                    )->tag( `ToolbarSpacer`

                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    t_messages = VALUE #(
      ( type = `Error` title = `Error message` active = abap_true counter = 1 subtitle = `Example of subtitle`
        description = `First Error message description. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod` &&
                      `tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo` &&
                      `consequat. Duis aute irure dolor in reprehenderit in voluptate velit essecillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non` &&
                      `proident, sunt in culpa qui officia deserunt mollit anim id est laborum.` )
      ( type = `Warning` title = `Warning without description` description = `` )
      ( type = `Success` title = `Success message` counter = 1 subtitle = `Example of subtitle`
        description = `First Success message description` )
      ( type = `Error` title = `Error message` counter = 2 subtitle = `Example of subtitle`
        description = `Second Error message description` )
      ( type = `Information` title = `Information message` counter = 1 subtitle = `Example of subtitle`
        description = `First Information message description` ) ).

    " the sample's three formatters render the button from the highest-severity message
    " (Error > Warning > Success > Info); the mock data is static, so the outcome is
    " precomputed here: two Error messages -> error icon, Negative type, count 2
    highest_icon  = `sap-icon://error`.
    highest_type  = `Negative`.
    highest_count = 2.

  ENDMETHOD.

ENDCLASS.
