" @keywords standardlistitem standard list item sap.m standardlistiteminfostateinverted
" @summary This sample demonstrates the inverted rendering behavior of the info text and the info state of the StandardListItem control.
CLASS z2ui5_cl_smpc_app_204 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_name,
        title     TYPE string,
        desc      TYPE string,
        icon      TYPE string,
        highlight TYPE string,
        info      TYPE string,
      END OF ty_s_name.
    DATA t_names TYPE STANDARD TABLE OF ty_s_name WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_204 IMPLEMENTATION.

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
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `List`
            )->a( n = `id`         v = `myList`
            )->a( n = `mode`       v = `MultiSelect`
            )->a( n = `headerText` v = `Inverted Info State`
            )->a( n = `items`      v = client->_bind( t_names )

            )->ele( `items`
                )->tag( `StandardListItem`
                    )->a( n = `title`             v = `{TITLE}`
                    )->a( n = `description`       v = `{DESC}`
                    )->a( n = `icon`              v = `{ICON}`
                    )->a( n = `iconInset`         v = `false`
                    )->a( n = `highlight`         v = `{HIGHLIGHT}`
                    )->a( n = `info`              v = `{INFO}`
                    )->a( n = `infoState`         v = `{HIGHLIGHT}`
                    " POST-1.71: infoStateInverted (since 1.74) kept 1:1
                    )->a( n = `infoStateInverted` v = `true` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " inline JSON mock (/names) of the original sample's controller (onInit)
    DATA temp1 LIKE t_names.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-title = `Title text`.
    temp2-desc = `Description text`.
    temp2-icon = `sap-icon://favorite`.
    temp2-highlight = `Success`.
    temp2-info = `Completed`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Title text`.
    temp2-desc = `Description text`.
    temp2-icon = `sap-icon://employee`.
    temp2-highlight = `Error`.
    temp2-info = `Incomplete`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Title text`.
    temp2-desc = ``.
    temp2-icon = `sap-icon://accept`.
    temp2-highlight = `Information`.
    temp2-info = `Information`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Title text`.
    temp2-desc = ``.
    temp2-icon = `sap-icon://activities`.
    temp2-highlight = `None`.
    temp2-info = `None`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Title text`.
    temp2-desc = `Description text`.
    temp2-icon = `sap-icon://badge`.
    temp2-highlight = `Warning`.
    temp2-info = `Warning`.
    INSERT temp2 INTO TABLE temp1.
    t_names = temp1.

  ENDMETHOD.

ENDCLASS.
