CLASS z2ui5_cl_dmo_app_195 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA name          TYPE string.
    DATA productid     TYPE string.
    DATA productpicurl TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_195 IMPLEMENTATION.

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
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `List`
            )->a( n = `headerText` v = `Products`
            )->a( n = `footerText` v = `This is the footer text`

            )->leaf( `StandardListItem`
                )->a( n = `title`            v = client->_bind( name )
                )->a( n = `description`      v = client->_bind( productid )
                )->a( n = `icon`             v = client->_bind( productpicurl )
                )->a( n = `iconDensityAware` v = `false`
                )->a( n = `iconInset`        v = `false` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " original controller loads the shared demo products.json and element-binds a
    " single record (List binding="{/ProductCollection/0}"); flattened here to
    " top-level default-model fields the {…} bindings resolve against (products.json
    " row 0). ProductPicUrl points at the OpenUI5 host per the asset-URL rule
    name          = `Notebook Basic 15`.
    productid     = `HT-1000`.
    productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`.

  ENDMETHOD.

ENDCLASS.
