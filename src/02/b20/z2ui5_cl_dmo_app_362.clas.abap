CLASS z2ui5_cl_dmo_app_362 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_362 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " TODO rebuild ui5/sap.ui.table/Sorting/*.view.xml 1:1 here (sap.ui.table.Table)
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `height`    v = `100%`

        )->open( `Page`
            )->a( n = `title` v = `Sorting`

            )->leaf( `Text`
                )->a( n = `text` v = `TODO: port sap.ui.table.sample.Sorting` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " TODO seed the default model (see the sample's controller / JSON mock)
    RETURN.

  ENDMETHOD.

ENDCLASS.
