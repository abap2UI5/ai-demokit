"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.IconTabBar - IconTabBarStretchContent
"! https://sdk.openui5.org/entity/sap.m.IconTabBar/sample/sap.m.sample.IconTabBarStretchContent
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

    METHODS data_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_433 IMPLEMENTATION.

  " NOTES (generation):
  " - IMPROVISED: the IconTabBar property expanded="{device>/isNoPhone}" is
  "   dropped - abap2UI5 has no device model, so the phone/non-phone binding
  "   cannot be expressed. The tab bar stays expanded.

  METHOD data_init.

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
        )->attr( n = `xmlns`     v = `sap.m`
        )->attr( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `IconTabBar`
            )->attr( n = `id`                   v = `idIconTabBarStretchContent`
            )->attr( n = `stretchContentHeight` v = `true`
            )->attr( n = `backgroundDesign`     v = `Transparent`
            )->attr( n = `applyContentPadding`  v = `false`
            " expanded="{device>/isNoPhone}" omitted - device model binding not available in abap2UI5
            )->attr( n = `class`                v = `sapUiResponsiveContentPadding`

            )->open( `items`
                )->open( `IconTabFilter`
                    )->attr( n = `text` v = `Products`
                    )->attr( n = `key`  v = `products`

                    )->open( `ScrollContainer`
                        )->attr( n = `height`     v = `100%`
                        )->attr( n = `width`      v = `100%`
                        )->attr( n = `horizontal` v = `false`
                        )->attr( n = `vertical`   v = `true`

                        )->open( `List`
                            )->attr( n = `items` v = client->_bind( t_products )

                            )->leaf( `StandardListItem`
                                )->attr( n = `title`   v = `{NAME}`
                                )->attr( n = `counter` v = `{QUANTITY}`

                        )->shut(
                    )->shut(
                )->shut(
                )->open( `IconTabFilter`
                    )->attr( n = `text` v = `Attachments`
                    )->attr( n = `key`  v = `attachments`

                    )->leaf( `Text`
                        )->attr( n = `text` v = `Attachments go here ...`

                )->shut(
                )->open( `IconTabFilter`
                    )->attr( n = `text` v = `Notes`
                    )->attr( n = `key`  v = `notes`

                    )->leaf( `Text`
                        )->attr( n = `text` v = `Notes go here ...`

                )->shut(
                )->open( `IconTabFilter`
                    )->attr( n = `text` v = `People`
                    )->attr( n = `key`  v = `people`

                    )->leaf( `Text`
                        )->attr( n = `text` v = `People content goes here ...` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      data_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
