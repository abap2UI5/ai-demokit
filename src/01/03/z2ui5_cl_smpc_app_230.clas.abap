" @keywords modelmapping model mapping sap.uxap boundmodelmapping text
CLASS z2ui5_cl_smpc_app_230 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA firstname TYPE string.
    DATA lastname  TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_230 IMPLEMENTATION.

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

    " Named-model fold + BlockBase inline: the original main view holds a custom
    " BlockBase control (sample:ModelMappingBlock) carrying a uxap:ModelMapping
    " config element that maps the external named model jsonModel (at
    " {jsonModel>/externalPath} = /Employee) onto the block's internal named
    " model Contact. abap2UI5 serves one default model (pr/named-json-models
    " declined), so both named models are folded into the default one: the
    " ModelMappingBlock's own view content (a SimpleForm) is inlined and the
    " Contact> fields are bound on the root ({/FIRSTNAME} / {/LASTNAME}).
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`       v = `sap.m`
        )->a( n = `xmlns:mvc`   v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core`  v = `sap.ui.core`
        )->a( n = `xmlns:forms` v = `sap.ui.layout.form`

        )->ele( n = `SimpleForm` ns = `forms`
            )->a( n = `maxContainerCols` v = `2`
            )->a( n = `editable`         v = `false`
            )->a( n = `layout`           v = `ResponsiveGridLayout`

            )->tag( n = `Title` ns = `core`
                )->a( n = `text` v = `My name`

            )->tag( `Text`
                )->a( n = `text` v = client->_bind( firstname )
            )->tag( `Text`
                )->a( n = `text` v = client->_bind( lastname ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " jsonModel>/Employee row-0 values, folded onto the default-model root
    firstname = `John`.
    lastname  = `Miller`.

  ENDMETHOD.

ENDCLASS.
