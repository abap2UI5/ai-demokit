" @keywords messagepopover message popover sap.m list overflowtoolbar button messageitem link toolbarspacer
" @summary MessagePopover is a control that displays a summarized list of different types of messages (errors, warnings, success and information). It provides a handy and systemized way to navigate and explore details for every message.
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

    DATA t_messages    TYPE STANDARD TABLE OF ty_s_message WITH DEFAULT KEY.
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
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `messagePopover` INTO TABLE temp1.
    INSERT `toggleBy` INTO TABLE temp1.
    INSERT `messagePopoverBtn` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `MESSAGE_TOAST` INTO TABLE temp2.
    INSERT `show` INTO TABLE temp2.
    INSERT `Active title is pressed` INTO TABLE temp2.
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
                                                                               t_arg = temp1 )

                        )->ele( `dependents`
                            )->ele( `MessagePopover`
                                )->a( n = `id`              v = `messagePopover`
                                )->a( n = `items`           v = client->_bind( t_messages )
                                )->a( n = `activeTitlePress` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                           t_arg = temp2 )

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

    DATA temp3 LIKE t_messages.
    DATA temp4 LIKE LINE OF temp3.
    CLEAR temp3.
    
    temp4-type = `Error`.
    temp4-title = `Error message`.
    temp4-active = abap_true.
    temp4-counter = 1.
    temp4-subtitle = `Example of subtitle`.
    temp4-description = `First Error message description. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod` &&
`tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo` &&
`consequat. Duis aute irure dolor in reprehenderit in voluptate velit essecillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non` &&
`proident, sunt in culpa qui officia deserunt mollit anim id est laborum.`.
    INSERT temp4 INTO TABLE temp3.
    temp4-type = `Warning`.
    temp4-title = `Warning without description`.
    temp4-description = ``.
    INSERT temp4 INTO TABLE temp3.
    temp4-type = `Success`.
    temp4-title = `Success message`.
    temp4-counter = 1.
    temp4-subtitle = `Example of subtitle`.
    temp4-description = `First Success message description`.
    INSERT temp4 INTO TABLE temp3.
    temp4-type = `Error`.
    temp4-title = `Error message`.
    temp4-counter = 2.
    temp4-subtitle = `Example of subtitle`.
    temp4-description = `Second Error message description`.
    INSERT temp4 INTO TABLE temp3.
    temp4-type = `Information`.
    temp4-title = `Information message`.
    temp4-counter = 1.
    temp4-subtitle = `Example of subtitle`.
    temp4-description = `First Information message description`.
    INSERT temp4 INTO TABLE temp3.
    t_messages = temp3.

    " the sample's three formatters render the button from the highest-severity message
    " (Error > Warning > Success > Info); the mock data is static, so the outcome is
    " precomputed here: two Error messages -> error icon, Negative type, count 2
    highest_icon  = `sap-icon://error`.
    highest_type  = `Negative`.
    highest_count = 2.

  ENDMETHOD.

ENDCLASS.
