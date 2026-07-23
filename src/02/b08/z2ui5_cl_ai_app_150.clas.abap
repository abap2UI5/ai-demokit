CLASS z2ui5_cl_ai_app_150 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_150 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:ce`  v = `sap.ui.codeeditor`
        )->a( n = `height`    v = `100%`

        )->open( `IconTabHeader`
            )->a( n = `id`          v = `iconTabHeader`
            )->a( n = `selectedKey` v = `invalidKey`
            )->a( n = `select`      v = client->_event( `SELECT_TAB` )
            )->open( `items`
                )->leaf( `IconTabFilter`
                    )->a( n = `text` v = `A`
                    )->a( n = `key`  v = `A`
                )->leaf( `IconTabFilter`
                    )->a( n = `text` v = `B`
                    )->a( n = `key`  v = `B`

        )->shut(
        )->shut(

        )->leaf( n = `CodeEditor` ns = `ce`
            )->a( n = `id`     v = `aCodeEditor`
            )->a( n = `height` v = `300px`
            )->a( n = `type`   v = `javascript` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
