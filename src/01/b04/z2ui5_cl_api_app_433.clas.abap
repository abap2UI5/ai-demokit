CLASS z2ui5_cl_api_app_433 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name     TYPE string,
        quantity TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS model_init.
    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_433 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " Data taken from the shared mock data sap/ui/demo/mock/products.json of the original sample
    DATA temp1 LIKE t_products.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-name = `Notebook Basic 15`.
    temp2-quantity = `10`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 17`.
    temp2-quantity = `20`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 18`.
    temp2-quantity = `10`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Basic 19`.
    temp2-quantity = `15`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault`.
    temp2-quantity = `15`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Professional 15`.
    temp2-quantity = `16`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Notebook Professional 17`.
    temp2-quantity = `17`.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `ITelO Vault Net`.
    temp2-quantity = `14`.
    INSERT temp2 INTO TABLE temp1.
    t_products = temp1.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_api_xml.
    view = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `IconTabBar`
            )->a( n = `id`                   v = `idIconTabBarStretchContent`
            )->a( n = `stretchContentHeight` v = `true`
            )->a( n = `backgroundDesign`     v = `Transparent`
            )->a( n = `applyContentPadding`  v = `false`
            " the sample's device model isNoPhone is a demo-kit helper; the framework's
            " device> model exposes raw sap.ui.Device, so !phone expresses the same
            )->a( n = `expanded`             v = `{= !${device>/system/phone} }`
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

ENDCLASS.
