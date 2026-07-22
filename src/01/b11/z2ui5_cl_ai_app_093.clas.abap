CLASS z2ui5_cl_ai_app_093 DEFINITION PUBLIC.

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

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_093 IMPLEMENTATION.

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
            )->a( n = `itemClose`         v = client->_event( `CLOSE` )

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
        " the original prevents the default close and would confirm first; here a toast (the tab is not removed)
        client->message_toast_display( `Close requested` ).
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
