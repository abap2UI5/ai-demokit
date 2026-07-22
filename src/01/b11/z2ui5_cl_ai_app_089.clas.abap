CLASS z2ui5_cl_ai_app_089 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name           TYPE string,
        price          TYPE p LENGTH 8 DECIMALS 2,
        currency_code  TYPE string,
        weight_measure TYPE string,
        weight_unit    TYPE string,
        width          TYPE string,
        depth          TYPE string,
        height         TYPE string,
        dim_unit       TYPE string,
      END OF ty_s_product.
    DATA s_product TYPE ty_s_product.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_089 IMPLEMENTATION.

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
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:f`    v = `sap.ui.layout.form`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->open( `Page`
            )->a( n = `id`      v = `idPage`
            )->a( n = `title`   v = ` Product XY`
            )->a( n = `class`   v = `sapUiResponsivePadding--header`
            " element binding kept 1:1 - a one-record structure /S_PRODUCT instead of {/ProductCollection/0}
            )->a( n = `binding` v = client->_bind( s_product )

            )->open( `content`
                )->open( `ObjectHeader`
                    )->a( n = `title`            v = `{NAME}`
                    )->a( n = `backgroundDesign` v = `Solid`
                    )->a( n = `number`           v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCY_CODE'\}], type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
                    )->a( n = `numberUnit`       v = `{CURRENCY_CODE}`
                    )->open( `attributes`
                        )->leaf( `ObjectAttribute`
                            )->a( n = `title` v = `Weight`
                            )->a( n = `text`  v = `{WEIGHT_MEASURE} {WEIGHT_UNIT}`
                        )->leaf( `ObjectAttribute`
                            )->a( n = `title` v = `Dimensions`
                            )->a( n = `text`  v = `{WIDTH} x {DEPTH} X {HEIGHT} {DIM_UNIT}`

                    )->shut(
                    )->open( `statuses`
                        )->leaf( `ObjectStatus`
                            )->a( n = `title` v = `Status`
                            )->a( n = `text`  v = `In Stock`
                            )->a( n = `state` v = `Success`

                    )->shut(
                )->shut(

                )->open( `IconTabBar`
                    )->a( n = `expanded` v = `{device>/isNoPhone}`
                    )->a( n = `class`    v = `sapUiSmallMarginBottom sapUiResponsiveContentPadding`
                    )->open( `items`
                        )->open( `IconTabFilter`
                            )->a( n = `key`  v = `info`
                            )->a( n = `text` v = `Info`
                            )->open( n = `SimpleForm` ns = `f`
                                )->a( n = `layout` v = `ResponsiveGridLayout`
                                )->open( n = `title` ns = `f`
                                    )->leaf( n = `Title` ns = `core`
                                        )->a( n = `text` v = `A Form`

                                )->shut(
                                )->leaf( `Label`
                                    )->a( n = `text` v = `Label`
                                )->leaf( `Text`
                                    )->a( n = `text` v = `Value`

                            )->shut(
                        )->shut(
                        )->open( `IconTabFilter`
                            )->a( n = `key`  v = `attachments`
                            )->a( n = `text` v = `Attachments`
                            )->leaf( `List`
                                )->a( n = `headerText`     v = `A List`
                                )->a( n = `showSeparators` v = `Inner`

                        )->shut(
                        )->open( `IconTabFilter`
                            )->a( n = `key`  v = `notes`
                            )->a( n = `text` v = `Notes`
                            )->leaf( `FeedInput`

                        )->shut(
                    )->shut(
                )->shut(

                )->open( n = `SimpleForm` ns = `f`
                    )->a( n = `layout` v = `ResponsiveGridLayout`
                    )->a( n = `class`  v = `sapUiForceWidthAuto sapUiResponsiveMargin`
                    )->open( n = `title` ns = `f`
                        )->leaf( n = `Title` ns = `core`
                            )->a( n = `text` v = `A Form`

                    )->shut(
                    )->leaf( `Label`
                        )->a( n = `text` v = `Label`
                    )->leaf( `Text`
                        )->a( n = `text` v = `Value`

                )->shut(

                )->leaf( `List`
                    )->a( n = `headerText`       v = `A List`
                    )->a( n = `backgroundDesign` v = `Translucent`
                    )->a( n = `width`            v = `auto`
                    )->a( n = `class`            v = `sapUiResponsiveMargin`
                )->leaf( `Table`
                    )->a( n = `headerText` v = `A Table`
                    )->a( n = `width`      v = `auto`
                    )->a( n = `class`      v = `sapUiResponsiveMargin`
                )->leaf( `Panel`
                    )->a( n = `headerText` v = `A Panel`
                    )->a( n = `width`      v = `auto`
                    )->a( n = `class`      v = `sapUiResponsiveMargin`

            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the bound record /ProductCollection/0 (Notebook Basic 15) of ui5/mock/products.json, verbatim
    s_product = VALUE #( name           = `Notebook Basic 15`
                         price          = '956.00'
                         currency_code  = `EUR`
                         weight_measure = `4.2` weight_unit = `KG`
                         width          = `30`  depth       = `18`
                         height         = `3`   dim_unit    = `cm` ).

  ENDMETHOD.

ENDCLASS.
