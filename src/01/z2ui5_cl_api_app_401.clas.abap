"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.FacetFilter - FacetFilterLight
"! https://sdk.openui5.org/entity/sap.m.FacetFilter/sample/sap.m.sample.FacetFilterLight
CLASS z2ui5_cl_api_app_401 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name           TYPE string,
        category       TYPE string,
        supplier_name  TYPE string,
        dimensions     TYPE string,
        weight_measure TYPE string,
        weight_unit    TYPE string,
        weight_state   TYPE string,
        price          TYPE string,
        currency_code  TYPE string,
      END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.
    TYPES:
      BEGIN OF ty_s_facet,
        text  TYPE string,
        count TYPE i,
      END OF ty_s_facet.
    TYPES ty_t_facet TYPE STANDARD TABLE OF ty_s_facet WITH EMPTY KEY.
    DATA t_products   TYPE ty_t_product.
    DATA t_categories TYPE ty_t_facet.
    DATA t_suppliers  TYPE ty_t_facet.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.
    " not bound - kept out of PUBLIC so the round-trip model scan stays small
    DATA t_products_all   TYPE ty_t_product.
    DATA t_range_category TYPE RANGE OF string.
    DATA t_range_supplier TYPE RANGE OF string.

    METHODS data_init.
    METHODS view_display.
    METHODS on_event.
    METHODS on_event_list_close
      IMPORTING
        facet TYPE string.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_401 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      data_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD data_init.

    " Data taken from the shared mock data sap/ui/demo/mock/products.json of the original sample
    t_products = VALUE #(
        ( name = `Comfort Easy` category = `Accessories` supplier_name = `Technocom` dimensions = `84 x 1.5 x 14 cm` weight_measure = `0.2` weight_unit = `KG` weight_state = `Success` price = `1679.00` currency_code = `EUR` )
        ( name = `Comfort Senior` category = `Accessories` supplier_name = `Technocom` dimensions = `80 x 1.6 x 13 cm` weight_measure = `0.8` weight_unit = `KG` weight_state = `Success` price = `512.00` currency_code = `EUR` )
        ( name = `Ergo Screen E-I` category = `Flat Screen Monitors` supplier_name = `Very Best Screens` dimensions = `37 x 12 x 36 cm` weight_measure = `21` weight_unit = `KG` weight_state = `Error` price = `230.00` currency_code = `EUR` )
        ( name = `ITelO Vault` category = `Accessories` supplier_name = `Technocom` dimensions = `32 x 22 x 3 cm` weight_measure = `0.2` weight_unit = `KG` weight_state = `Success` price = `299.00` currency_code = `EUR` )
        ( name = `ITelO Vault Net` category = `Accessories` supplier_name = `Technocom` dimensions = `10 x 1.8 x 17 cm` weight_measure = `0.16` weight_unit = `KG` weight_state = `Success` price = `459.00` currency_code = `EUR` )
        ( name = `ITelO Vault SAT` category = `Accessories` supplier_name = `Technocom` dimensions = `11 x 1.7 x 18 cm` weight_measure = `0.18` weight_unit = `KG` weight_state = `Success` price = `149.00` currency_code = `EUR` )
        ( name = `Notebook Basic 15` category = `Laptops` supplier_name = `Very Best Screens` dimensions = `30 x 18 x 3 cm` weight_measure = `4.2` weight_unit = `KG` weight_state = `Warning` price = `956.00` currency_code = `EUR` )
        ( name = `Notebook Basic 17` category = `Laptops` supplier_name = `Very Best Screens` dimensions = `29 x 17 x 3.1 cm` weight_measure = `4.5` weight_unit = `KG` weight_state = `Warning` price = `1249.00` currency_code = `EUR` )
        ( name = `Notebook Basic 19` category = `Laptops` supplier_name = `Smartcards` dimensions = `32 x 21 x 4 cm` weight_measure = `4.2` weight_unit = `KG` weight_state = `Warning` price = `1650.00` currency_code = `EUR` )
        ( name = `Notebook Professional 15` category = `Accessories` supplier_name = `Very Best Screens` dimensions = `33 x 20 x 3 cm` weight_measure = `4.3` weight_unit = `KG` weight_state = `Warning` price = `1999.00` currency_code = `EUR` ) ).

    SORT t_products BY name.
    t_products_all = t_products.

    " Facet values with counters as delivered precomputed in /ProductCollectionStats/Filters
    t_categories = VALUE #(
        ( text = `Accessories` count = 6 )
        ( text = `Flat Screen Monitors` count = 1 )
        ( text = `Laptops` count = 3 ) ).
    t_suppliers = VALUE #(
        ( text = `Smartcards` count = 1 )
        ( text = `Technocom` count = 5 )
        ( text = `Very Best Screens` count = 4 ) ).

  ENDMETHOD.


  METHOD view_display.

    " The bound lists collection of the original is unrolled into two static facet filter lists;
    " the original controller appends the demo table of sap.m.sample.Table with an adjusted first column.
    DATA(view) = z2ui5_cl_api_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->open( `VBox`
            )->a( n = `id` v = `idVBox`

            )->open( `FacetFilter`
                )->a( n = `id`                  v = `idFacetFilter`
                )->a( n = `type`                v = `Light`
                )->a( n = `showPersonalization` v = `true`
                )->a( n = `showReset`           v = `true`
                )->a( n = `reset`               v = client->_event( `RESET` )

                )->open( `FacetFilterList`
                    )->a( n = `title`     v = `Category`
                    )->a( n = `key`       v = `Category`
                    )->a( n = `mode`      v = `MultiSelect`
                    )->a( n = `listClose` v = client->_event( val   = `LIST_CLOSE_CATEGORY`
                                                                 t_arg = VALUE #( ( `$event.mParameters.selectedItems` ) ) )
                    )->a( n = `items`     v = client->_bind_edit( t_categories )

                    )->leaf( `FacetFilterItem`
                        )->a( n = `text`    v = `{TEXT}`
                        )->a( n = `key`     v = `{TEXT}`
                        )->a( n = `counter` v = `{COUNT}`

                )->shut(
                )->open( `FacetFilterList`
                    )->a( n = `title`     v = `SupplierName`
                    )->a( n = `key`       v = `SupplierName`
                    )->a( n = `mode`      v = `MultiSelect`
                    )->a( n = `listClose` v = client->_event( val   = `LIST_CLOSE_SUPPLIER`
                                                                 t_arg = VALUE #( ( `$event.mParameters.selectedItems` ) ) )
                    )->a( n = `items`     v = client->_bind_edit( t_suppliers )

                    )->leaf( `FacetFilterItem`
                        )->a( n = `text`    v = `{TEXT}`
                        )->a( n = `key`     v = `{TEXT}`
                        )->a( n = `counter` v = `{COUNT}`

                )->shut(
            )->shut(

            )->open( `Table`
                )->a( n = `id`    v = `idProductsTable`
                )->a( n = `inset` v = `false`
                )->a( n = `items` v = client->_bind_edit( t_products )

                )->open( `headerToolbar`
                    )->open( `OverflowToolbar`
                        )->leaf( `Title`
                            )->a( n = `text`  v = `Products`
                            )->a( n = `level` v = `H2`
                        )->leaf( `ToolbarSpacer`

                    )->shut(
                )->shut(

                )->open( `columns`
                    )->open( `Column`
                        )->a( n = `width` v = `12em`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Product`

                    )->shut(
                    )->open( `Column`
                        )->a( n = `minScreenWidth` v = `Tablet`
                        )->a( n = `demandPopin`    v = `true`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Supplier`

                    )->shut(
                    )->open( `Column`
                        )->a( n = `minScreenWidth` v = `Desktop`
                        )->a( n = `demandPopin`    v = `true`
                        )->a( n = `hAlign`         v = `End`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Dimensions`

                    )->shut(
                    )->open( `Column`
                        )->a( n = `minScreenWidth` v = `Desktop`
                        )->a( n = `demandPopin`    v = `true`
                        )->a( n = `hAlign`         v = `Center`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Weight`

                    )->shut(
                    )->open( `Column`
                        )->a( n = `hAlign` v = `End`

                        )->leaf( `Text`
                            )->a( n = `text` v = `Price`

                    )->shut(
                )->shut(

                )->open( `items`
                    )->open( `ColumnListItem`
                        )->a( n = `vAlign` v = `Middle`

                        )->open( `cells`
                            )->leaf( `ObjectIdentifier`
                                )->a( n = `title` v = `{NAME}`
                                )->a( n = `text`  v = `{CATEGORY}`
                            )->leaf( `Text`
                                )->a( n = `text` v = `{SUPPLIER_NAME}`
                            )->leaf( `Text`
                                )->a( n = `text` v = `{DIMENSIONS}`
                            )->leaf( `ObjectNumber`
                                )->a( n = `number` v = `{WEIGHT_MEASURE}`
                                )->a( n = `unit`   v = `{WEIGHT_UNIT}`
                                )->a( n = `state`  v = `{WEIGHT_STATE}`
                            )->leaf( `ObjectNumber`
                                )->a( n = `number` v = `{PRICE}`
                                )->a( n = `unit`   v = `{CURRENCY_CODE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN `RESET`.
        t_range_category = VALUE #( ).
        t_range_supplier = VALUE #( ).
        t_products = t_products_all.
        client->view_model_update( ).

      WHEN `LIST_CLOSE_CATEGORY`.
        on_event_list_close( `CATEGORY` ).

      WHEN `LIST_CLOSE_SUPPLIER`.
        on_event_list_close( `SUPPLIER` ).

    ENDCASE.

  ENDMETHOD.


  METHOD on_event_list_close.

    DATA t_range TYPE RANGE OF string.

    TRY.
        DATA(t_arg) = client->get( )-t_event_arg.
        DATA(json) = z2ui5_cl_ajson=>parse( t_arg[ 1 ] ).

        LOOP AT json->members( `/` ) INTO DATA(member).
          APPEND VALUE #( sign   = `I`
                          option = `EQ`
                          low    = json->get( |/{ member }/mProperties/text| ) ) TO t_range.
        ENDLOOP.

      CATCH cx_root.
    ENDTRY.

    IF facet = `CATEGORY`.
      t_range_category = t_range.
    ELSE.
      t_range_supplier = t_range.
    ENDIF.

    t_products = t_products_all.
    DELETE t_products WHERE category NOT IN t_range_category OR supplier_name NOT IN t_range_supplier.

    client->view_model_update( ).

  ENDMETHOD.

ENDCLASS.
