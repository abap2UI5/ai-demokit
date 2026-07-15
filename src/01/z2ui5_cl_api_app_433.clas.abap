"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.IconTabBar - IconTabBarStretchContent
"! https://sdk.openui5.org/entity/sap.m.IconTabBar/sample/sap.m.sample.IconTabBarStretchContent
"! NOTES (generation):
"! - IMPROVISED: the IconTabBar property expanded="{device>/isNoPhone}" is
"!   dropped - abap2UI5 has no device model, so the phone/non-phone binding
"!   cannot be expressed. The tab bar stays expanded.
CLASS z2ui5_cl_api_app_433 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name     TYPE string,
        quantity TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS model_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_433 IMPLEMENTATION.

  METHOD model_init.

    " Data taken from the shared mock data sap/ui/demo/mock/products.json of the original sample
    t_products = VALUE #(
        ( name = `Notebook Basic 15`        quantity = `10` )
        ( name = `Notebook Basic 17`        quantity = `20` )
        ( name = `Notebook Basic 18`        quantity = `10` )
        ( name = `Notebook Basic 19`        quantity = `15` )
        ( name = `ITelO Vault`              quantity = `15` )
        ( name = `Notebook Professional 15` quantity = `16` )
        ( name = `Notebook Professional 17` quantity = `17` )
        ( name = `ITelO Vault Net`          quantity = `14` ) ).

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `IconTabBar`
            )->a( n = `id`                   v = `idIconTabBarStretchContent`
            )->a( n = `stretchContentHeight` v = `true`
            )->a( n = `backgroundDesign`     v = `Transparent`
            )->a( n = `applyContentPadding`  v = `false`
            " expanded="{device>/isNoPhone}" omitted - device model binding not available in abap2UI5
            )->a( n = `class`                v = `sapUiResponsiveContentPadding`

            )->open( `items`
                )->open( `IconTabFilter`
                    )->a( n = `text` v = `Products`
                    )->a( n = `key`  v = `products`

                    )->open( `ScrollContainer`
                        )->a( n = `height`     v = `100%`
                        )->a( n = `width`      v = `100%`
                        )->a( n = `horizontal` v = `false`
                        )->a( n = `vertical`   v = `true`

                        )->open( `List`
                            )->a( n = `items` v = client->_bind_edit( t_products )

                            )->leaf( `StandardListItem`
                                )->a( n = `title`   v = `{NAME}`
                                )->a( n = `counter` v = `{QUANTITY}`

                        )->shut(
                    )->shut(
                )->shut(
                )->open( `IconTabFilter`
                    )->a( n = `text` v = `Attachments`
                    )->a( n = `key`  v = `attachments`

                    )->leaf( `Text`
                        )->a( n = `text` v = `Attachments go here ...`

                )->shut(
                )->open( `IconTabFilter`
                    )->a( n = `text` v = `Notes`
                    )->a( n = `key`  v = `notes`

                    )->leaf( `Text`
                        )->a( n = `text` v = `Notes go here ...`

                )->shut(
                )->open( `IconTabFilter`
                    )->a( n = `text` v = `People`
                    )->a( n = `key`  v = `people`

                    )->leaf( `Text`
                        )->a( n = `text` v = `People content goes here ...` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
