" @keywords standardlistitem standard list item sap.m standardlistitemwrapping toolbar title toolbarspacer togglebutton
" @summary This sample demonstrates the wrapping behavior of the title text and the description text. In desktop mode, the character limit is set to 300 characters, whereas in the phone mode, the character limit is set to 100 characters.
CLASS z2ui5_cl_smpc_app_376 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_name,
        title         TYPE string,
        desc          TYPE string,
        icon          TYPE string,
        highlight     TYPE string,
        info          TYPE string,
        infoicon      TYPE string,
        wrapcharlimit TYPE i,
      END OF ty_s_name.
    DATA t_names TYPE STANDARD TABLE OF ty_s_name WITH DEFAULT KEY.

    DATA wrapping TYPE abap_bool.
    DATA inverted TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_376 IMPLEMENTATION.

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
            )->a( n = `id`    v = `myList`
            )->a( n = `mode`  v = `MultiSelect`
            )->a( n = `items` v = |\{ path: '{ client->_bind_path( t_names ) }' \}|

            )->ele( `headerToolbar`
                )->ele( `Toolbar`
                    )->tag( `Title`
                        )->a( n = `text` v = `Wrapping texts`
                    )->tag( `ToolbarSpacer`
                    )->tag( `ToggleButton`
                        )->a( n = `text`    v = `Toggle Wrapping`
                        )->a( n = `pressed` v = client->_bind( wrapping )
                    )->tag( `ToggleButton`
                        )->a( n = `text`    v = `Toggle Inverted`
                        )->a( n = `pressed` v = client->_bind( inverted )

                )->end(
            )->end(

            )->ele( `items`
                )->tag( `StandardListItem`
                    )->a( n = `title`             v = `{TITLE}`
                    )->a( n = `description`       v = `{DESC}`
                    )->a( n = `icon`              v = `{ICON}`
                    )->a( n = `iconInset`         v = `false`
                    )->a( n = `highlight`         v = `{HIGHLIGHT}`
                    )->a( n = `info`              v = `{INFO}`
                    )->a( n = `infoState`         v = `{HIGHLIGHT}`
                    " infoIcon is UI5 1.150 - kept for the 1:1 port (POST_171)
                    )->a( n = `infoIcon`          v = `{INFOICON}`
                    " the two toggles live at the model ROOT, so both bind absolutely
                    " even inside the row template (app 207 lesson).
                    " infoStateInverted is UI5 1.74 - kept for the 1:1 port (POST_171)
                    )->a( n = `infoStateInverted` v = client->_bind( inverted )
                    )->a( n = `type`              v = `Detail`
                    )->a( n = `wrapping`          v = client->_bind( wrapping )
                    " wrapCharLimit is UI5 1.94 - kept for the 1:1 port (POST_171)
                    )->a( n = `wrapCharLimit`     v = `{WRAPCHARLIMIT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.
    DATA temp1 LIKE t_names.
    DATA temp2 LIKE LINE OF temp1.

    " Data of the inline JSON model defined in the original sample controller.
    " The original seeds only wrapping: false; /inverted starts out undefined,
    " which UI5 reads as not pressed - abap_false here.
    wrapping = abap_false.
    inverted = abap_false.

    
    CLEAR temp1.
    
    temp2-title = `Short title`.
    temp2-icon = `sap-icon://favorite`.
    temp2-highlight = `Success`.
    temp2-info = `Available`.
    temp2-infoicon = `sap-icon://accept`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Short title with long info text`.
    temp2-icon = `sap-icon://employee`.
    temp2-highlight = `Error`.
    temp2-info = `This is a very long information status text that demonstrates truncation and wrapping behavior`.
    temp2-infoicon = `sap-icon://decline`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `wrapCharLimit is set to Default. Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ` &&
`ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita ` &&
`kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, ` &&
`sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. Lorem ipsum dolor sit amet, ` &&
`consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat.`.
    temp2-desc = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam ` &&
`erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata ` &&
`sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor ` &&
`invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed ` &&
`diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat.`.
    temp2-icon = `sap-icon://favorite`.
    temp2-highlight = `Success`.
    temp2-info = `Completed`.
    temp2-infoicon = `sap-icon://accept`.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `wrapCharLimit is set to 100. Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut ` &&
`labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd ` &&
`gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed ` &&
`diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. Lorem ipsum dolor sit amet, ` &&
`consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat.`.
    temp2-desc = `Lorem ipsum dolor st amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam ` &&
`erat, sed diam voluptua.`.
    temp2-icon = `sap-icon://employee`.
    temp2-highlight = `Error`.
    temp2-info = `Incomplete`.
    temp2-infoicon = `sap-icon://decline`.
    temp2-wrapcharlimit = 100.
    INSERT temp2 INTO TABLE temp1.
    temp2-title = `Title text`.
    temp2-desc = `Description text`.
    temp2-icon = `sap-icon://accept`.
    temp2-highlight = `Information`.
    temp2-info = `Information`.
    temp2-infoicon = `sap-icon://information`.
    temp2-wrapcharlimit = 10.
    INSERT temp2 INTO TABLE temp1.
    t_names = temp1.

  ENDMETHOD.

ENDCLASS.
