" @keywords messagestrip message strip sap.m dynamicmessagestripgenerator verticallayout button
" @summary Generates MessageStrips with random properties.
CLASS z2ui5_cl_smpc_app_289 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA strip_visible TYPE abap_bool.
    DATA strip_text    TYPE string.
    " MessageStrip.type is an enum: an empty string is rejected by
    " validateProperty, so the field carries the control's own default
    DATA strip_type    TYPE string VALUE `Information`.
    DATA show_icon     TYPE abap_bool.
    DATA show_close    TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    " how often the button was pressed - drives the rotation that replaces the
    " original's Math.random( ); not bound, so it stays out of the model
    DATA press_count TYPE i.

    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_289 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " the original builds the MessageStrip in the controller and adds it to the
    " VerticalLayout (destroying the previous one first). Here it is part of the
    " view and its four varying properties are bound; visible keeps it out of
    " the layout until the button was pressed once
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `id`    v = `oVerticalContent`
            )->a( n = `width` v = `100%`

            )->ele( n = `content` ns = `l`
                )->tag( `Button`
                    )->a( n = `text`  v = `Generate MessageStrip`
                    )->a( n = `class` v = `sapUiSmallMarginBottom`
                    )->a( n = `press` v = client->_event( `GENERATE` )
                    )->a( n = `width` v = `250px`

                )->tag( `MessageStrip`
                    )->a( n = `id`              v = `msgStrip`
                    )->a( n = `visible`         v = client->_bind( strip_visible )
                    )->a( n = `text`            v = client->_bind( strip_text )
                    )->a( n = `type`            v = client->_bind( strip_type )
                    )->a( n = `showIcon`        v = client->_bind( show_icon )
                    )->a( n = `showCloseButton` v = client->_bind( show_close ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
      DATA temp1 TYPE string.
      DATA temp4 TYPE xsdboolean.
      DATA temp5 TYPE xsdboolean.
      DATA temp2 TYPE string_table.
      DATA temp3 LIKE LINE OF temp2.

    IF client->get_event( ) = `GENERATE`.
      " _generateMsgStrip picks type, showIcon and showCloseButton at random.
      " Randomness is a decision, so it is taken in ABAP - and taken
      " DETERMINISTICALLY: the press counter rotates through the four types
      " and through the two flag combinations, so every press still changes
      " the strip and the port stays reproducible
      press_count   = press_count + 1.
      strip_visible = abap_true.
      strip_text    = `Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua ut enim ` &&
                      `ad minim veniam, quis nostrud exercitation ullamco.`.
      
      CASE press_count MOD 4.
        WHEN 1.
          temp1 = `Information`.
        WHEN 2.
          temp1 = `Warning`.
        WHEN 3.
          temp1 = `Error`.
        WHEN 0.
          temp1 = `Success`.
      ENDCASE.
      strip_type    = temp1.
      
      temp4 = boolc( press_count MOD 2 = 1 ).
      show_icon     = temp4.
      
      temp5 = boolc( press_count MOD 3 <> 0 ).
      show_close    = temp5.

      " onInit takes an InvisibleMessage instance and _generateMsgStrip
      " announces the new strip assertively. InvisibleMessage is a singleton
      " with no control id, so the announcement goes through the global
      " target added for it (pr/invisible-message-announce)
      
      CLEAR temp2.
      INSERT `INVISIBLE_MESSAGE` INTO TABLE temp2.
      INSERT `announce` INTO TABLE temp2.
      
      temp3 = |New Information Bar of type { strip_type } { strip_text }|.
      INSERT temp3 INTO TABLE temp2.
      INSERT `Assertive` INTO TABLE temp2.
      client->follow_up_action( val   = client->cs_event-control_global
                                t_arg = temp2 ).

      " showMsgStrip DESTROYS the old strip and creates a new one, so a strip
      " the user closed always comes back. Rebinding cannot do that on its own:
      " MessageStrip.close( ) calls setVisible( false ) on the CONTROL, and the
      " model still holds abap_true - an unchanged value fires no binding
      " update, so the strip would stay invisible for the rest of the session
      " while text and type kept changing behind it. Re-rendering the view is
      " the destroy-and-create the original does
      view_display( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
