" @keywords messagepopover message popover sap.m async handling overflowtoolbar button messageitem link toolbarspacer
" @summary The message handling concept sample shows how you can use callback functions for resolving a promise after a link or descriptions have been asynchronously validated.
CLASS z2ui5_cl_smpc_app_067 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_smpc_app_067 IMPLEMENTATION.

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
    DATA temp4 TYPE string_table.
    DATA temp5 TYPE string_table.
    DATA temp3 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `messagePopover` INTO TABLE temp1.
    INSERT `toggleBy` INTO TABLE temp1.
    INSERT `$event.oSource.sId` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `MESSAGE_TOAST` INTO TABLE temp2.
    INSERT `show` INTO TABLE temp2.
    INSERT `Active title is pressed` INTO TABLE temp2.
    
    CLEAR temp4.
    INSERT `MESSAGE_TOAST` INTO TABLE temp4.
    INSERT `show` INTO TABLE temp4.
    INSERT `URL validation has been performed.` INTO TABLE temp4.
    
    CLEAR temp5.
    INSERT `MESSAGE_TOAST` INTO TABLE temp5.
    INSERT `show` INTO TABLE temp5.
    INSERT `Description validation has been performed.` INTO TABLE temp5.
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
                                )->a( n = `id`               v = `messagePopover`
                                )->a( n = `items`            v = client->_bind( t_messages )
                                )->a( n = `activeTitlePress` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                           t_arg = temp2 )
                                " added wire (declared): the original attaches urlValidated in the
                                " controller and toasts after each async URL validation
                                )->a( n = `urlValidated`     v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                           t_arg = temp4 )
                                " added wire (declared): the original attaches longtextLoaded in
                                " the controller. MessageView fires it unconditionally on every
                                " drill-down (_navigateToDetails), so it is NOT gated on a
                                " longtextUrl the way setAsyncDescriptionHandler is
                                )->a( n = `longtextLoaded`   v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                           t_arg = temp5 )

                                )->ele( `MessageItem`
                                    )->a( n = `type`              v = `{TYPE}`
                                    )->a( n = `title`             v = `{TITLE}`
                                    )->a( n = `activeTitle`       v = `{ACTIVE}`
                                    )->a( n = `description`       v = `{DESCRIPTION}`
                                    )->a( n = `subtitle`          v = `{SUBTITLE}`
                                    )->a( n = `counter`           v = `{COUNTER}`
                                    )->a( n = `markupDescription` v = `true`

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

    " original setAsyncURLHandler: allowed = url.lastIndexOf('http', 0) < 0 -
    " the framework's built-in RELATIVE_ONLY policy (relative links allowed,
    " absolute ones disabled) covers the demo's exact case declaratively
    
    CLEAR temp3.
    INSERT `messagePopover` INTO TABLE temp3.
    INSERT `setAsyncURLHandler` INTO TABLE temp3.
    INSERT `RELATIVE_ONLY` INTO TABLE temp3.
    client->follow_up_action( val   = client->cs_event-control_by_id
                              t_arg = temp3 ).

  ENDMETHOD.


  METHOD model_init.

    DATA temp5 LIKE t_messages.
    DATA temp6 LIKE LINE OF temp5.
    CLEAR temp5.
    
    temp6-type = `Error`.
    temp6-title = `Error message`.
    temp6-active = abap_true.
    temp6-counter = 1.
    temp6-subtitle = `Example of subtitle`.
    temp6-description = `<h2>Heading h2</h2><p>Paragraph. At vero eos et accusamus et iusto odio dignissimos ducimus qui ...</p>` &&
`<ul><li>Unordered list item 1 <a href="http://sap.com/some/url">Absolute URL that is disabled after validation.</a></li>` &&
`<li>Unordered list item 2</li></ul>` &&
`<ol><li>Ordered list item 1 <a href="#">Relative URL that is allowed after validation.</a></li>` &&
`<li>Ordered list item 2</li></ol>`.
    INSERT temp6 INTO TABLE temp5.
    temp6-type = `Warning`.
    temp6-title = `Warning without description`.
    temp6-description = ``.
    INSERT temp6 INTO TABLE temp5.
    temp6-type = `Success`.
    temp6-title = `Success message`.
    temp6-counter = 1.
    temp6-subtitle = `Example of subtitle`.
    temp6-description = `First Success message description`.
    INSERT temp6 INTO TABLE temp5.
    temp6-type = `Error`.
    temp6-title = `Error message`.
    temp6-counter = 2.
    temp6-subtitle = `Example of subtitle`.
    temp6-description = `Second Error message description`.
    INSERT temp6 INTO TABLE temp5.
    temp6-type = `Information`.
    temp6-title = `Information message`.
    temp6-counter = 1.
    temp6-subtitle = `Example of subtitle`.
    temp6-description = `First Information message description`.
    INSERT temp6 INTO TABLE temp5.
    t_messages = temp5.

    highest_icon  = `sap-icon://error`.
    highest_type  = `Negative`.
    highest_count = 2.

  ENDMETHOD.

ENDCLASS.
