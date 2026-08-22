CLASS z2ui5_cl_smpc_app_491 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_491 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " TODO rebuild ui5/sap.m/MultiComboBoxClearIcon/*.view.xml 1:1 here (sap.m.MultiComboBox)
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `height`    v = `100%`

        )->ele( `Page`
            )->a( n = `title` v = `MultiComboBoxClearIcon`

            )->tag( `Text`
                )->a( n = `text` v = `TODO: port sap.m.sample.MultiComboBoxClearIcon` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " TODO seed the default model (see the sample's controller / JSON mock)
    RETURN.

  ENDMETHOD.

ENDCLASS.
