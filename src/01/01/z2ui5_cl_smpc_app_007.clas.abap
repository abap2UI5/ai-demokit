" @keywords checkbox check box sap.m reflects verticallayout text html
" @summary In this sample, the CheckBox reflects the selection states of its dependent input fields - selected, not selected, and partially selected.
CLASS z2ui5_cl_smpc_app_007 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA child1 TYPE abap_bool.
    DATA child2 TYPE abap_bool.
    DATA child3 TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_007 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
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
        )->a( n = `xmlns:c`   v = `sap.ui.core`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( n = `VerticalLayout` ns = `l`
            )->tag( `Text`
                )->a( n = `text` v = `Which languages(s) do you speak?`
            )->tag( `CheckBox`
                )->a( n = `text`              v = `select / deselect all`
                )->a( n = `selected`          v = |\{= ${ client->_bind( child1 ) } \|\| ${ client->_bind( child2 ) } \|\| ${ client->_bind( child3 ) } \}|
                )->a( n = `partiallySelected` v = |\{= !(${ client->_bind( child1 ) } && ${ client->_bind( child2 ) } && ${ client->_bind( child3 ) })\}|
                )->a( n = `select`            v = client->_event( val   = `PARENT_CLICKED`
                                                                  t_arg = VALUE #( ( `${$parameters>/selected}` ) ) )
            )->tag( n = `HTML` ns = `c`
                )->a( n = `content` v = `<hr>`
            )->tag( `CheckBox`
                )->a( n = `text`     v = `English`
                )->a( n = `selected` v = client->_bind( child1 )
            )->tag( `CheckBox`
                )->a( n = `text`     v = `German`
                )->a( n = `selected` v = client->_bind( child2 )
            )->tag( `CheckBox`
                )->a( n = `text`     v = `French`
                )->a( n = `selected` v = client->_bind( child3 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `PARENT_CLICKED`.
      child1 = client->get_event_arg( ).
      child2 = client->get_event_arg( ).
      child3 = client->get_event_arg( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    child1 = abap_true.
    child2 = abap_false.
    child3 = abap_true.

  ENDMETHOD.

ENDCLASS.
