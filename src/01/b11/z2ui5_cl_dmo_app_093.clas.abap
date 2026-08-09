CLASS z2ui5_cl_dmo_app_093 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_emp,
        name           TYPE string,
        modified       TYPE abap_bool,
        emp_first_name TYPE string,
        emp_last_name  TYPE string,
        salary         TYPE p LENGTH 8 DECIMALS 2,
      END OF ty_s_emp.
    DATA t_employees TYPE STANDARD TABLE OF ty_s_emp WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    " the tab pending the close confirmation (name + row index), kept across
    " the MessageBox round-trip
    DATA close_name  TYPE string.
    DATA close_index TYPE i.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_093 IMPLEMENTATION.

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

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( `TabContainer`
            )->a( n = `items`             v = client->_bind( t_employees )
            )->a( n = `id`                v = `myTabContainer`
            )->a( n = `showAddNewButton`  v = `true`
            )->a( n = `class`             v = `sapUiResponsiveContentPadding sapUiResponsivePadding--header`
            )->a( n = `addNewButtonPress` v = client->_event( `ADD` )
            " itemCloseHandler: oEvent.preventDefault() unconditionally, then a
            " MessageBox.confirm decides - the eBP wire cancels the built-in close
            " and transports the tab name + its row index for the server decision
            )->a( n = `itemClose`         v = client->_event( val    = `CLOSE`
                                                              t_arg  = VALUE #( ( `${$parameters>/item}.getName()` ) ( `${$parameters>/item/oParent}.indexOfItem(${$parameters>/item})` ) )
                                                              s_ctrl = VALUE #( check_prevent_default = abap_true ) )

            )->open( `items`
                )->open( `TabContainerItem`
                    )->a( n = `name`     v = `{NAME}`
                    )->a( n = `modified` v = `{MODIFIED}`
                    )->open( `content`
                        )->leaf( `Label`
                            )->a( n = `text` v = `First Name:`
                        )->leaf( `Input`
                            )->a( n = `value` v = `{EMP_FIRST_NAME}`
                        )->leaf( `Label`
                            )->a( n = `text` v = `Last Name:`
                        )->leaf( `Input`
                            )->a( n = `value` v = `{EMP_LAST_NAME}`
                        )->leaf( `Label`
                            )->a( n = `text` v = `Salary:`
                        )->leaf( `Input`
                            )->a( n = `value`       v = `{SALARY}`
                            )->a( n = `description` v = `EUR`

                    )->shut(
                )->shut(
            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `ADD`.
        " addNewButtonPressHandler: add a new, empty employee tab
        APPEND VALUE #( name = `New employee` modified = abap_false ) TO t_employees.
        client->view_model_update( ).
      WHEN `CLOSE`.
        " itemCloseHandler: confirm before closing; the answer comes back as
        " the CLOSE_DECIDE event's action argument
        close_name  = client->get_event_arg( ).
        close_index = client->get_event_arg( 2 ).
        client->message_box_display( text    = |Do you want to close the tab '{ close_name }'?|
                                     type    = `confirm`
                                     onclose = `CLOSE_DECIDE` ).

      WHEN `CLOSE_DECIDE`.
        " OK removes the tab row (the bound-aggregation form of removeItem)
        IF client->get_event_arg( ) = `OK`.
          IF close_index >= 0 AND close_index < lines( t_employees ).
            DELETE t_employees INDEX close_index + 1.
            client->view_model_update( ).
          ENDIF.
          client->message_toast_display( text = |Item closed: { close_name }| duration = `500` ).
        ELSE.
          client->message_toast_display( text = |Item close canceled: { close_name }| duration = `500` ).
        ENDIF.
    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    t_employees = VALUE #(
      ( name = `Jean Doe`       emp_first_name = `Jean`     emp_last_name = `Doe`     salary = '1455.22' )
      ( name = `John Smith`     emp_first_name = `John`     emp_last_name = `Smith`   salary = '1390.77' modified = abap_true )
      ( name = `Particia Clark` emp_first_name = `Particia` emp_last_name = `Clark`   salary = '1189.00' )
      ( name = `Tim McAfeed`    emp_first_name = `Tim`      emp_last_name = `McAfeed` salary = '1235.37' ) ).

  ENDMETHOD.

ENDCLASS.
