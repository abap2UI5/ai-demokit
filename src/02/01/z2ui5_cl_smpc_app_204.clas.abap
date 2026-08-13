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
    DATA t_names TYPE STANDARD TABLE OF ty_s_name WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_204 IMPLEMENTATION.

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
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->open( `List`
            )->a( n = `id`         v = `myList`
            )->a( n = `mode`       v = `MultiSelect`
            )->a( n = `headerText` v = `Inverted Info State`
            )->a( n = `items`      v = client->_bind( t_names )

            )->open( `items`
                )->leaf( `StandardListItem`
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
    t_names = VALUE #(
      ( title = `Title text` desc = `Description text` icon = `sap-icon://favorite`   highlight = `Success`     info = `Completed` )
      ( title = `Title text` desc = `Description text` icon = `sap-icon://employee`   highlight = `Error`       info = `Incomplete` )
      ( title = `Title text` desc = ``                 icon = `sap-icon://accept`     highlight = `Information` info = `Information` )
      ( title = `Title text` desc = ``                 icon = `sap-icon://activities` highlight = `None`        info = `None` )
      ( title = `Title text` desc = `Description text` icon = `sap-icon://badge`      highlight = `Warning`     info = `Warning` )
    ).

  ENDMETHOD.

ENDCLASS.
