"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.CheckBox - CheckBoxTriState
"! https://sdk.openui5.org/entity/sap.m.CheckBox/sample/sap.m.sample.CheckBoxTriState
"! CHECKED (2026-07-15): manually verified in a running system - the select-all
"! parent checkbox and its tri-state expression bindings behave like the original.
CLASS z2ui5_cl_api_app_421 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA child1 TYPE abap_bool.
    DATA child2 TYPE abap_bool.
    DATA child3 TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS model_init.
    METHODS view_display.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_421 IMPLEMENTATION.

  METHOD model_init.

    child1 = abap_true.
    child2 = abap_false.
    child3 = abap_true.

  ENDMETHOD.


  METHOD view_display.

    DATA(child1_bind) = client->_bind_edit( child1 ).
    DATA(child2_bind) = client->_bind_edit( child2 ).
    DATA(child3_bind) = client->_bind_edit( child3 ).

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns:c`   v = `sap.ui.core`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( n = `VerticalLayout` ns = `l`
            )->leaf( `Text`
                )->a( n = `text` v = `Which languages(s) do you speak?`
            )->leaf( `CheckBox`
                )->a( n = `text`              v = `select / deselect all`
                )->a( n = `selected`          v = |\{= ${ child1_bind } \|\| ${ child2_bind } \|\| ${ child3_bind } \}|
                )->a( n = `partiallySelected` v = |\{= !(${ child1_bind } && ${ child2_bind } && ${ child3_bind })\}|
                )->a( n = `select`            v = client->_event( val   = `PARENT_CLICKED`
                                                                     t_arg = VALUE #( ( `${$parameters>/selected}` ) ) )
            )->leaf( n = `HTML` ns = `c`
                )->a( n = `content` v = `<hr>`
            )->leaf( `CheckBox`
                )->a( n = `text`     v = `English`
                )->a( n = `selected` v = child1_bind
            )->leaf( `CheckBox`
                )->a( n = `text`     v = `German`
                )->a( n = `selected` v = child2_bind
            )->leaf( `CheckBox`
                )->a( n = `text`     v = `French`
                )->a( n = `selected` v = child3_bind ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `PARENT_CLICKED`.
        child1 = client->get_event_arg( 1 ).
        child2 = client->get_event_arg( 1 ).
        child3 = client->get_event_arg( 1 ).
        client->view_model_update( ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
