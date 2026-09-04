" @keywords popover sap.m popovernavcon verticallayout button navcontainer list standardlistitem objectheader objectattribute text
" @summary You can nest NavContainers in Popovers (and Dialogs) to navigate to further details in place.
CLASS z2ui5_cl_smpc_app_565 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        product_id    TYPE string,
        name          TYPE string,
        productpicurl TYPE string,
        weightmeasure TYPE string,
        weightunit    TYPE string,
        width         TYPE string,
        depth         TYPE string,
        height        TYPE string,
        dimunit       TYPE string,
        description   TYPE string,
      END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    DATA t_products TYPE ty_t_product.

    " what bindElement( ctx.getPath( ) ) puts under the detail page - the relative
    " bindings of the original resolve against the bound element, the port folds
    " them to root-seeded fields (app 229 idiom)
    DATA d_name          TYPE string.
    DATA d_weightmeasure TYPE string.
    DATA d_weightunit    TYPE string.
    DATA d_width         TYPE string.
    DATA d_depth         TYPE string.
    DATA d_height        TYPE string.
    DATA d_dimunit       TYPE string.
    DATA d_description   TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popover_display IMPORTING by_id TYPE string.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_565 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->ele( n = `content` ns = `l`
                )->tag( `Button`
                    )->a( n = `text`         v = `Open Popover`
                    )->a( n = `ariaHasPopup` v = `Dialog`
                    " onOpenPopover anchors the popover on the pressed button
                    )->a( n = `press`        v = client->_event( val = `OPEN_POPOVER` arg = `$event.oSource.sId` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD popover_display.

    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    popup = z2ui5_cl_ui5_view_builder=>factory( ).

    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `Popover`
            )->a( n = `id`             v = `myPopover`
            )->a( n = `showHeader`     v = `false`
            )->a( n = `contentWidth`   v = `320px`
            )->a( n = `contentHeight`  v = `500px`
            )->a( n = `placement`      v = `Bottom`
            )->a( n = `ariaLabelledBy` v = `master-title`

            )->ele( `NavContainer`
                )->a( n = `id` v = `navCon`

                )->ele( `Page`
                    )->a( n = `id`    v = `master`
                    )->a( n = `class` v = `sapUiResponsivePadding--header`
                    )->a( n = `title` v = `Products`

                    )->ele( `List`
                        )->a( n = `id`    v = `list`
                        )->a( n = `items` v = client->_bind( t_products )

                        )->tag( `StandardListItem`
                            )->a( n = `title`            v = `{NAME}`
                            )->a( n = `description`      v = `{PRODUCT_ID}`
                            )->a( n = `type`             v = `Active`
                            )->a( n = `icon`             v = `{PRODUCTPICURL}`
                            )->a( n = `iconDensityAware` v = `false`
                            )->a( n = `iconInset`        v = `false`
                            " onNavToProduct reads the pressed row's product id.
                            " $source> is UI5's CONTROL model: it sees the pressed
                            " control's PROPERTIES, not the row's model fields, so
                            " '${$source>/PRODUCT_ID}' resolved to null and the
                            " detail page stayed empty (e2e-caught 2026-08-22). The
                            " id is on the item as its bound description, which is
                            " what every other $source> wire in the corpus reads.
                            )->a( n = `press`            v = client->_event( val = `NAV_TO_PRODUCT` arg = `${$source>/description}` )

                    )->end(
                )->end(

                )->ele( `Page`
                    )->a( n = `id`             v = `detail`
                    )->a( n = `class`          v = `sapUiResponsivePadding--header`
                    )->a( n = `title`          v = `Product`
                    )->a( n = `showNavButton`  v = `true`
                    )->a( n = `navButtonPress` v = client->_event( `NAV_BACK` )

                    )->ele( `content`
                        )->ele( `ObjectHeader`
                            )->a( n = `title` v = client->_bind( d_name )

                            )->ele( `attributes`
                                )->tag( `ObjectAttribute`
                                    )->a( n = `text` v = |{ client->_bind( d_weightmeasure ) } { client->_bind( d_weightunit ) }|
                                )->tag( `ObjectAttribute`
                                    )->a( n = `text` v = |{ client->_bind( d_width ) } x { client->_bind( d_depth ) } x { client->_bind( d_height ) } { client->_bind( d_dimunit ) }|

                            )->end(
                        )->end(
                        )->tag( `Text`
                            )->a( n = `class` v = `sapUiSmallMargin`
                            )->a( n = `text`  v = client->_bind( d_description ) ).

    client->popover_display( xml = popup->stringify( ) by_id = by_id ).

  ENDMETHOD.


  METHOD on_event.
        DATA product_id TYPE string.
        FIELD-SYMBOLS <product> TYPE z2ui5_cl_smpc_app_565=>ty_s_product.
        DATA temp1 TYPE string_table.
        DATA temp3 TYPE string_table.

    CASE client->get_event( ).

      WHEN `OPEN_POPOVER`.
        popover_display( client->get_event_arg( ) ).

      WHEN `NAV_TO_PRODUCT`.
        " onNavToProduct: navigate to the detail page and bind it to the pressed row
        
        product_id = client->get_event_arg( ).
        
        READ TABLE t_products WITH KEY product_id = product_id ASSIGNING <product>.
        IF sy-subrc = 0.
          d_name          = <product>-name.
          d_weightmeasure = <product>-weightmeasure.
          d_weightunit    = <product>-weightunit.
          d_width         = <product>-width.
          d_depth         = <product>-depth.
          d_height        = <product>-height.
          d_dimunit       = <product>-dimunit.
          d_description   = <product>-description.
        ENDIF.
        
        CLEAR temp1.
        INSERT `navCon` INTO TABLE temp1.
        INSERT `to` INTO TABLE temp1.
        INSERT `detail` INTO TABLE temp1.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  view  = client->cs_view-popover
                                  t_arg = temp1 ).

      WHEN `NAV_BACK`.
        
        CLEAR temp3.
        INSERT `navCon` INTO TABLE temp3.
        INSERT `back` INTO TABLE temp3.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  view  = client->cs_view-popover
                                  t_arg = temp3 ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " the full mock /ProductCollection (sap/ui/demo/mock/products.json), all 123 rows
    DATA temp5 TYPE z2ui5_cl_smpc_app_565=>ty_t_product.
    DATA temp6 LIKE LINE OF temp5.
    CLEAR temp5.
    
    temp6-product_id = `HT-1000`.
    temp6-name = `Notebook Basic 15`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`.
    temp6-weightmeasure = `4.2`.
    temp6-weightunit = `KG`.
    temp6-width = `30`.
    temp6-depth = `18`.
    temp6-height = `3`.
    temp6-dimunit = `cm`.
    temp6-description = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1001`.
    temp6-name = `Notebook Basic 17`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg`.
    temp6-weightmeasure = `4.5`.
    temp6-weightunit = `KG`.
    temp6-width = `29`.
    temp6-depth = `17`.
    temp6-height = `3.1`.
    temp6-dimunit = `cm`.
    temp6-description = `Notebook Basic 17 with 2,80 GHz quad core, 17" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1002`.
    temp6-name = `Notebook Basic 18`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg`.
    temp6-weightmeasure = `4.2`.
    temp6-weightunit = `KG`.
    temp6-width = `28`.
    temp6-depth = `19`.
    temp6-height = `2.5`.
    temp6-dimunit = `cm`.
    temp6-description = `Notebook Basic 18 with 2,80 GHz quad core, 18" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1003`.
    temp6-name = `Notebook Basic 19`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg`.
    temp6-weightmeasure = `4.2`.
    temp6-weightunit = `KG`.
    temp6-width = `32`.
    temp6-depth = `21`.
    temp6-height = `4`.
    temp6-dimunit = `cm`.
    temp6-description = `Notebook Basic 19 with 2,80 GHz quad core, 19" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1007`.
    temp6-name = `ITelO Vault`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg`.
    temp6-weightmeasure = `0.2`.
    temp6-weightunit = `KG`.
    temp6-width = `32`.
    temp6-depth = `22`.
    temp6-height = `3`.
    temp6-dimunit = `cm`.
    temp6-description = `Digital Organizer with State-of-the-Art Storage Encryption`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1010`.
    temp6-name = `Notebook Professional 15`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg`.
    temp6-weightmeasure = `4.3`.
    temp6-weightunit = `KG`.
    temp6-width = `33`.
    temp6-depth = `20`.
    temp6-height = `3`.
    temp6-dimunit = `cm`.
    temp6-description = `Notebook Professional 15 with 2,80 GHz quad core, 15" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1011`.
    temp6-name = `Notebook Professional 17`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg`.
    temp6-weightmeasure = `4.1`.
    temp6-weightunit = `KG`.
    temp6-width = `33`.
    temp6-depth = `23`.
    temp6-height = `2`.
    temp6-dimunit = `cm`.
    temp6-description = `Notebook Professional 17 with 2,80 GHz quad core, 17" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1020`.
    temp6-name = `ITelO Vault Net`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg`.
    temp6-weightmeasure = `0.16`.
    temp6-weightunit = `KG`.
    temp6-width = `10`.
    temp6-depth = `1.8`.
    temp6-height = `17`.
    temp6-dimunit = `cm`.
    temp6-description = `Digital Organizer with State-of-the-Art Encryption for Storage and Network Communications`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1021`.
    temp6-name = `ITelO Vault SAT`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg`.
    temp6-weightmeasure = `0.18`.
    temp6-weightunit = `KG`.
    temp6-width = `11`.
    temp6-depth = `1.7`.
    temp6-height = `18`.
    temp6-dimunit = `cm`.
    temp6-description = `Digital Organizer with State-of-the-Art Encryption for Storage and Secure Stellite Link`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1022`.
    temp6-name = `Comfort Easy`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg`.
    temp6-weightmeasure = `0.2`.
    temp6-weightunit = `KG`.
    temp6-width = `84`.
    temp6-depth = `1.5`.
    temp6-height = `14`.
    temp6-dimunit = `cm`.
    temp6-description = `32 GB Digital Assistant with high-resolution color screen`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1023`.
    temp6-name = `Comfort Senior`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg`.
    temp6-weightmeasure = `0.8`.
    temp6-weightunit = `KG`.
    temp6-width = `80`.
    temp6-depth = `1.6`.
    temp6-height = `13`.
    temp6-dimunit = `cm`.
    temp6-description = `64 GB Digital Assistant with high-resolution color screen and synthesized voice output`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1030`.
    temp6-name = `Ergo Screen E-I`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg`.
    temp6-weightmeasure = `21`.
    temp6-weightunit = `KG`.
    temp6-width = `37`.
    temp6-depth = `12`.
    temp6-height = `36`.
    temp6-dimunit = `cm`.
    temp6-description = `Optimum Hi-Resolution max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1031`.
    temp6-name = `Ergo Screen E-II`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg`.
    temp6-weightmeasure = `21`.
    temp6-weightunit = `KG`.
    temp6-width = `40.8`.
    temp6-depth = `19`.
    temp6-height = `43`.
    temp6-dimunit = `cm`.
    temp6-description = `Optimum Hi-Resolution max. 1920 x 1200 @ 85Hz, Dot Pitch: 0.26mm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1032`.
    temp6-name = `Ergo Screen E-III`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg`.
    temp6-weightmeasure = `21`.
    temp6-weightunit = `KG`.
    temp6-width = `40.8`.
    temp6-depth = `19`.
    temp6-height = `43`.
    temp6-dimunit = `cm`.
    temp6-description = `Optimum Hi-Resolution max. 2560 x 1440 @ 85Hz, Dot Pitch: 0.25mm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1035`.
    temp6-name = `Flat Basic`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg`.
    temp6-weightmeasure = `14`.
    temp6-weightunit = `KG`.
    temp6-width = `39`.
    temp6-depth = `20`.
    temp6-height = `41`.
    temp6-dimunit = `cm`.
    temp6-description = `Optimum Hi-Resolution max. 1600 x 1200 @ 85Hz, Dot Pitch: 0.24mm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1036`.
    temp6-name = `Flat Future`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg`.
    temp6-weightmeasure = `15`.
    temp6-weightunit = `KG`.
    temp6-width = `45`.
    temp6-depth = `26`.
    temp6-height = `46`.
    temp6-dimunit = `cm`.
    temp6-description = `Optimum Hi-Resolution max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.26mm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1037`.
    temp6-name = `Flat XL`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg`.
    temp6-weightmeasure = `17`.
    temp6-weightunit = `KG`.
    temp6-width = `54.5`.
    temp6-depth = `22.1`.
    temp6-height = `39.1`.
    temp6-dimunit = `cm`.
    temp6-description = `Optimum Hi-Resolution max. 2016 x 1512 @ 85Hz, Dot Pitch: 0.24mm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1040`.
    temp6-name = `Laser Professional Eco`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg`.
    temp6-weightmeasure = `32`.
    temp6-weightunit = `KG`.
    temp6-width = `51`.
    temp6-depth = `46`.
    temp6-height = `30`.
    temp6-dimunit = `cm`.
    temp6-description = `Print 2400 dpi image quality color documents at speeds of up to 32 ppm (color) or 36 ppm (monochrome), letter/A4. Powerful 500 MHz processor, 512MB of memory`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1041`.
    temp6-name = `Laser Basic`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg`.
    temp6-weightmeasure = `23`.
    temp6-weightunit = `KG`.
    temp6-width = `48`.
    temp6-depth = `42`.
    temp6-height = `26`.
    temp6-dimunit = `cm`.
    temp6-description = `Up to 22 ppm color or 24 ppm monochrome A4/letter, powerful 500 MHz processor and 128MB of memory`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1042`.
    temp6-name = `Laser Allround`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg`.
    temp6-weightmeasure = `17`.
    temp6-weightunit = `KG`.
    temp6-width = `53`.
    temp6-depth = `50`.
    temp6-height = `65`.
    temp6-dimunit = `cm`.
    temp6-description = `Print up to 25 ppm letter and 24 ppm A4 color or monochrome, with Available first-page-out-time of less than 13 seconds for monochrome and less than 15 seconds for color`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1050`.
    temp6-name = `Ultra Jet Super Color`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg`.
    temp6-weightmeasure = `3`.
    temp6-weightunit = `KG`.
    temp6-width = `41`.
    temp6-depth = `41`.
    temp6-height = `28`.
    temp6-dimunit = `cm`.
    temp6-description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB, Ethernet`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1051`.
    temp6-name = `Ultra Jet Mobile`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg`.
    temp6-weightmeasure = `1.9`.
    temp6-weightunit = `KG`.
    temp6-width = `46`.
    temp6-depth = `32`.
    temp6-height = `25`.
    temp6-dimunit = `cm`.
    temp6-description = `1000 dpi x 1000 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB - excellent dimensions for the small office`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1052`.
    temp6-name = `Ultra Jet Super Highspeed`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg`.
    temp6-weightmeasure = `18`.
    temp6-weightunit = `KG`.
    temp6-width = `41`.
    temp6-depth = `41`.
    temp6-height = `28`.
    temp6-dimunit = `cm`.
    temp6-description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB2.0, Ethernet`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1055`.
    temp6-name = `Multi Print`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg`.
    temp6-weightmeasure = `6.3`.
    temp6-weightunit = `KG`.
    temp6-width = `55`.
    temp6-depth = `45`.
    temp6-height = `29`.
    temp6-dimunit = `cm`.
    temp6-description = `1000 dpi x 1000 dpi - up to 16 ppm (mono) / up to 15 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 1200dpi x 2400dpi)`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1056`.
    temp6-name = `Multi Color`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg`.
    temp6-weightmeasure = `4.3`.
    temp6-weightunit = `KG`.
    temp6-width = `51`.
    temp6-depth = `41.3`.
    temp6-height = `22`.
    temp6-dimunit = `cm`.
    temp6-description = `1200 dpi x 1200 dpi - up to 25 ppm (mono) / up to 24 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 2400dpi x 4800dpi, high resolution)`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1060`.
    temp6-name = `Cordless Mouse`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg`.
    temp6-weightmeasure = `0.09`.
    temp6-weightunit = `KG`.
    temp6-width = `6`.
    temp6-depth = `14.5`.
    temp6-height = `3.5`.
    temp6-dimunit = `cm`.
    temp6-description = `Cordless Optical USB Mice, Laptop, Color: Black, Plug&Play`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1061`.
    temp6-name = `Speed Mouse`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg`.
    temp6-weightmeasure = `0.09`.
    temp6-weightunit = `KG`.
    temp6-width = `7`.
    temp6-depth = `15`.
    temp6-height = `3.1`.
    temp6-dimunit = `cm`.
    temp6-description = `Optical USB, PS/2 Mouse, Color: Blue, 3-button-functionality (incl. Scroll wheel)`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1062`.
    temp6-name = `Track Mouse`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg`.
    temp6-weightmeasure = `0.03`.
    temp6-weightunit = `KG`.
    temp6-width = `3`.
    temp6-depth = `7`.
    temp6-height = `4`.
    temp6-dimunit = `cm`.
    temp6-description = `Optical USB Mouse, Color: Red, 5-button-functionality(incl. Scroll wheel), Plug&Play`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1063`.
    temp6-name = `Ergonomic Keyboard`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg`.
    temp6-weightmeasure = `2.1`.
    temp6-weightunit = `KG`.
    temp6-width = `50`.
    temp6-depth = `21`.
    temp6-height = `3.5`.
    temp6-dimunit = `cm`.
    temp6-description = `Ergonomic USB Keyboard for Desktop, Plug&Play`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1064`.
    temp6-name = `Internet Keyboard`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg`.
    temp6-weightmeasure = `1.8`.
    temp6-weightunit = `KG`.
    temp6-width = `52`.
    temp6-depth = `25`.
    temp6-height = `3`.
    temp6-dimunit = `cm`.
    temp6-description = `Corded Keyboard with special keys for Internet Usability, USB`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1065`.
    temp6-name = `Media Keyboard`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg`.
    temp6-weightmeasure = `2.3`.
    temp6-weightunit = `KG`.
    temp6-width = `51.4`.
    temp6-depth = `23`.
    temp6-height = `4`.
    temp6-dimunit = `cm`.
    temp6-description = `Corded Ergonomic Keyboard with special keys for Media Usability, USB`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1066`.
    temp6-name = `Mousepad`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg`.
    temp6-weightmeasure = `80`.
    temp6-weightunit = `G`.
    temp6-width = `15`.
    temp6-depth = `6`.
    temp6-height = `0.2`.
    temp6-dimunit = `cm`.
    temp6-description = `Nice mouse pad with ITelO Logo`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1067`.
    temp6-name = `Ergo Mousepad`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg`.
    temp6-weightmeasure = `80`.
    temp6-weightunit = `G`.
    temp6-width = `15`.
    temp6-depth = `6`.
    temp6-height = `0.2`.
    temp6-dimunit = `cm`.
    temp6-description = `Ergonomic mouse pad with ITelO Logo`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1068`.
    temp6-name = `Designer Mousepad`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg`.
    temp6-weightmeasure = `90`.
    temp6-weightunit = `G`.
    temp6-width = `24`.
    temp6-depth = `24`.
    temp6-height = `0.6`.
    temp6-dimunit = `cm`.
    temp6-description = `ITelO Mousepad Special Edition`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1069`.
    temp6-name = `Universal card reader`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg`.
    temp6-weightmeasure = `45`.
    temp6-weightunit = `G`.
    temp6-width = `6`.
    temp6-depth = `6`.
    temp6-height = `3`.
    temp6-dimunit = `cm`.
    temp6-description = `Universal card reader`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1070`.
    temp6-name = `Proctra X`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg`.
    temp6-weightmeasure = `0.255`.
    temp6-weightunit = `KG`.
    temp6-width = `22`.
    temp6-depth = `35`.
    temp6-height = `17`.
    temp6-dimunit = `cm`.
    temp6-description = `Proctra X: PCI-E GDDR5 3072MB`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1071`.
    temp6-name = `Gladiator MX`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg`.
    temp6-weightmeasure = `0.3`.
    temp6-weightunit = `KG`.
    temp6-width = `22`.
    temp6-depth = `35`.
    temp6-height = `17`.
    temp6-dimunit = `cm`.
    temp6-description = `Gladiator XLN: PCI-E GDDR5 3072MB DVI Out, TV Out low-noise`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1072`.
    temp6-name = `Hurricane GX`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg`.
    temp6-weightmeasure = `0.4`.
    temp6-weightunit = `KG`.
    temp6-width = `22`.
    temp6-depth = `35`.
    temp6-height = `17`.
    temp6-dimunit = `cm`.
    temp6-description = `Hurricane GX: PCI-E 691 GFLOPS game-optimized`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1073`.
    temp6-name = `Hurricane GX/LN`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg`.
    temp6-weightmeasure = `0.4`.
    temp6-weightunit = `KG`.
    temp6-width = `22`.
    temp6-depth = `35`.
    temp6-height = `17`.
    temp6-dimunit = `cm`.
    temp6-description = `Hurricane GX/LN: PCI-E 691 GFLOPS game-optimized, low-noise.`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1080`.
    temp6-name = `Photo Scan`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg`.
    temp6-weightmeasure = `2.3`.
    temp6-weightunit = `KG`.
    temp6-width = `34`.
    temp6-depth = `48`.
    temp6-height = `5`.
    temp6-dimunit = `cm`.
    temp6-description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - Hi-Speed USB - Bluetooth`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1081`.
    temp6-name = `Power Scan`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg`.
    temp6-weightmeasure = `2.4`.
    temp6-weightunit = `KG`.
    temp6-width = `31`.
    temp6-depth = `43`.
    temp6-height = `7`.
    temp6-dimunit = `cm`.
    temp6-description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - SCSI for backward compatibility`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1082`.
    temp6-name = `Jet Scan Professional`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg`.
    temp6-weightmeasure = `3.2`.
    temp6-weightunit = `KG`.
    temp6-width = `33`.
    temp6-depth = `41`.
    temp6-height = `12`.
    temp6-dimunit = `cm`.
    temp6-description = `Flatbed scanner - Letter - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1083`.
    temp6-name = `Jet Scan Professional`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg`.
    temp6-weightmeasure = `3.2`.
    temp6-weightunit = `KG`.
    temp6-width = `35`.
    temp6-depth = `40`.
    temp6-height = `10`.
    temp6-dimunit = `cm`.
    temp6-description = `Flatbed scanner - A4 - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1085`.
    temp6-name = `Copymaster`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg`.
    temp6-weightmeasure = `23.2`.
    temp6-weightunit = `KG`.
    temp6-width = `45`.
    temp6-depth = `42`.
    temp6-height = `22`.
    temp6-dimunit = `cm`.
    temp6-description = `Copymaster`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1090`.
    temp6-name = `Surround Sound`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg`.
    temp6-weightmeasure = `3`.
    temp6-weightunit = `KG`.
    temp6-width = `12`.
    temp6-depth = `10`.
    temp6-height = `16`.
    temp6-dimunit = `cm`.
    temp6-description = `PC multimedia speakers - 5 Watt (Total)`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1091`.
    temp6-name = `Blaster Extreme`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg`.
    temp6-weightmeasure = `1.4`.
    temp6-weightunit = `KG`.
    temp6-width = `13`.
    temp6-depth = `11`.
    temp6-height = `17.5`.
    temp6-dimunit = `cm`.
    temp6-description = `PC multimedia speakers - 10 Watt (Total) - 2-way`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1092`.
    temp6-name = `Sound Booster`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg`.
    temp6-weightmeasure = `2.1`.
    temp6-weightunit = `KG`.
    temp6-width = `12.4`.
    temp6-depth = `10.4`.
    temp6-height = `18.1`.
    temp6-dimunit = `cm`.
    temp6-description = `PC multimedia speakers - optimized for Blutooth/A2DP`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1095`.
    temp6-name = `Lovely Sound 5.1 Wireless`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg`.
    temp6-weightmeasure = `80`.
    temp6-weightunit = `G`.
    temp6-width = `24`.
    temp6-depth = `19`.
    temp6-height = `23`.
    temp6-dimunit = `cm`.
    temp6-description = `5.1 Headset, 40 Hz-20 kHz, Wireless`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1096`.
    temp6-name = `Lovely Sound 5.1`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg`.
    temp6-weightmeasure = `130`.
    temp6-weightunit = `G`.
    temp6-width = `25`.
    temp6-depth = `17`.
    temp6-height = `19`.
    temp6-dimunit = `cm`.
    temp6-description = `5.1 Headset, 40 Hz-20 kHz, 3m cable`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1097`.
    temp6-name = `Lovely Sound Stereo`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg`.
    temp6-weightmeasure = `60`.
    temp6-weightunit = `G`.
    temp6-width = `21.3`.
    temp6-depth = `2.4`.
    temp6-height = `19.7`.
    temp6-dimunit = `cm`.
    temp6-description = `5.1 Headset, 40 Hz-20 kHz, 1m cable`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1100`.
    temp6-name = `Smart Office`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg`.
    temp6-weightmeasure = `1.2`.
    temp6-weightunit = `KG`.
    temp6-width = `15`.
    temp6-depth = `6.5`.
    temp6-height = `2.1`.
    temp6-dimunit = `cm`.
    temp6-description = `Complete package, 1 User, Office Applications (word processing, spreadsheet, presentations)`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1101`.
    temp6-name = `Smart Design`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg`.
    temp6-weightmeasure = `0.8`.
    temp6-weightunit = `KG`.
    temp6-width = `14`.
    temp6-depth = `6.7`.
    temp6-height = `24`.
    temp6-dimunit = `cm`.
    temp6-description = `Complete package, 1 User, Image editing, processing`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1102`.
    temp6-name = `Smart Network`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg`.
    temp6-weightmeasure = `0.8`.
    temp6-weightunit = `KG`.
    temp6-width = `16`.
    temp6-depth = `6`.
    temp6-height = `27`.
    temp6-dimunit = `cm`.
    temp6-description = `Complete package, 1 User, Network Software Utilities, Useful Applications and Documentation`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1103`.
    temp6-name = `Smart Multimedia`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg`.
    temp6-weightmeasure = `0.8`.
    temp6-weightunit = `KG`.
    temp6-width = `11`.
    temp6-depth = `3.4`.
    temp6-height = `22`.
    temp6-dimunit = `cm`.
    temp6-description = `Complete package, 1 User, different Multimedia applications, playing music, watching DVDs, only with this Smart package`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1104`.
    temp6-name = `Smart Games`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg`.
    temp6-weightmeasure = `1.1`.
    temp6-weightunit = `KG`.
    temp6-width = `10`.
    temp6-depth = `3`.
    temp6-height = `30`.
    temp6-dimunit = `cm`.
    temp6-description = `Complete package, 1 User, various games for amusement, logic, action, jump&run`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1105`.
    temp6-name = `Smart Internet Antivirus`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg`.
    temp6-weightmeasure = `0.7`.
    temp6-weightunit = `KG`.
    temp6-width = `16`.
    temp6-depth = `4`.
    temp6-height = `21`.
    temp6-dimunit = `cm`.
    temp6-description = `Complete package, 1 User, highly recommended for internet users as anti-virus protection`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1106`.
    temp6-name = `Smart Firewall`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg`.
    temp6-weightmeasure = `0.9`.
    temp6-weightunit = `KG`.
    temp6-width = `17.9`.
    temp6-depth = `4.2`.
    temp6-height = `23.1`.
    temp6-dimunit = `cm`.
    temp6-description = `Complete package, 1 User, recommended for internet users, protect your PC against cyber-crime`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1107`.
    temp6-name = `Smart Money`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg`.
    temp6-weightmeasure = `0.5`.
    temp6-weightunit = `KG`.
    temp6-width = `12`.
    temp6-depth = `1.5`.
    temp6-height = `19`.
    temp6-dimunit = `cm`.
    temp6-description = `Complete package, 1 User, bring your money in your mind, see what you have and what you want`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1110`.
    temp6-name = `PC Lock`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg`.
    temp6-weightmeasure = `0.03`.
    temp6-weightunit = `KG`.
    temp6-width = `20`.
    temp6-depth = `8`.
    temp6-height = `4.3`.
    temp6-dimunit = `cm`.
    temp6-description = `Robust 3m anti-burglary protection for your laptop computer`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1111`.
    temp6-name = `Notebook Lock`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg`.
    temp6-weightmeasure = `0.02`.
    temp6-weightunit = `KG`.
    temp6-width = `31`.
    temp6-depth = `9`.
    temp6-height = `7`.
    temp6-dimunit = `cm`.
    temp6-description = `Robust 1m anti-burglary protection for your desktop computer`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1112`.
    temp6-name = `Web cam reality`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg`.
    temp6-weightmeasure = `0.075`.
    temp6-weightunit = `KG`.
    temp6-width = `9`.
    temp6-depth = `8.2`.
    temp6-height = `1.3`.
    temp6-dimunit = `cm`.
    temp6-description = `Color webcam, color, High-Speed USB`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1113`.
    temp6-name = `Screen clean`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg`.
    temp6-weightmeasure = `0.05`.
    temp6-weightunit = `KG`.
    temp6-width = `2`.
    temp6-depth = `2`.
    temp6-height = `0.1`.
    temp6-dimunit = `cm`.
    temp6-description = `10 separately packed screen wipes`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1114`.
    temp6-name = `Fabric bag professional`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg`.
    temp6-weightmeasure = `1.8`.
    temp6-weightunit = `KG`.
    temp6-width = `42`.
    temp6-depth = `32`.
    temp6-height = `7`.
    temp6-dimunit = `cm`.
    temp6-description = `Notebook bag, plenty of room for stationery and writing materials`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1115`.
    temp6-name = `Wireless DSL Router`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg`.
    temp6-weightmeasure = `0.45`.
    temp6-weightunit = `KG`.
    temp6-width = `19.3`.
    temp6-depth = `18`.
    temp6-height = `5`.
    temp6-dimunit = `cm`.
    temp6-description = `Wireless DSL Router (available in blue, black and silver)`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1116`.
    temp6-name = `Wireless DSL Router / Repeater`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg`.
    temp6-weightmeasure = `0.45`.
    temp6-weightunit = `KG`.
    temp6-width = `19.3`.
    temp6-depth = `18`.
    temp6-height = `5`.
    temp6-dimunit = `cm`.
    temp6-description = `Wireless DSL Router / Repeater (available in blue, black and silver)`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1117`.
    temp6-name = `Wireless DSL Router / Repeater and Print Server`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg`.
    temp6-weightmeasure = `0.45`.
    temp6-weightunit = `KG`.
    temp6-width = `19.3`.
    temp6-depth = `18`.
    temp6-height = `5`.
    temp6-dimunit = `cm`.
    temp6-description = `Wireless DSL Router / Repeater and Print Server (available in blue, black and silver)`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1118`.
    temp6-name = `USB Stick`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg`.
    temp6-weightmeasure = `0.015`.
    temp6-weightunit = `KG`.
    temp6-width = `1.5`.
    temp6-depth = `8.7`.
    temp6-height = `1.2`.
    temp6-dimunit = `cm`.
    temp6-description = `USB 2.0 High-Speed 64 GB`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1119`.
    temp6-name = `Travel Adapter`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg`.
    temp6-weightmeasure = `88`.
    temp6-weightunit = `G`.
    temp6-width = `2`.
    temp6-depth = `3.1`.
    temp6-height = `3.9`.
    temp6-dimunit = `cm`.
    temp6-description = `Universal Travel Adapter`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1120`.
    temp6-name = `Cordless Bluetooth Keyboard, english international`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg`.
    temp6-weightmeasure = `1`.
    temp6-weightunit = `KG`.
    temp6-width = `51.4`.
    temp6-depth = `23`.
    temp6-height = `4`.
    temp6-dimunit = `cm`.
    temp6-description = `Cordless Bluetooth Keyboard with English keys`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1137`.
    temp6-name = `Flat XXL`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg`.
    temp6-weightmeasure = `18`.
    temp6-weightunit = `KG`.
    temp6-width = `54`.
    temp6-depth = `22`.
    temp6-height = `38`.
    temp6-dimunit = `cm`.
    temp6-description = `Optimum Hi-Resolution max. 2048 × 1536 @ 85Hz, Dot Pitch: 0.24mm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1138`.
    temp6-name = `Pocket Mouse`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg`.
    temp6-weightmeasure = `0.02`.
    temp6-weightunit = `KG`.
    temp6-width = `0.3`.
    temp6-depth = `0.5`.
    temp6-height = `1`.
    temp6-dimunit = `cm`.
    temp6-description = `Portable pocket Mouse with retracting cord`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1210`.
    temp6-name = `PC Power Station`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg`.
    temp6-weightmeasure = `2.3`.
    temp6-weightunit = `KG`.
    temp6-width = `28`.
    temp6-depth = `31`.
    temp6-height = `43`.
    temp6-dimunit = `cm`.
    temp6-description = `PC Power Station with 3,4 Ghz quad-core, 32 GB DDR3 SDRAM, feels like Available PC, Windows 8 Pro`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1251`.
    temp6-name = `Astro Laptop 1516`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg`.
    temp6-weightmeasure = `4.2`.
    temp6-weightunit = `KG`.
    temp6-width = `30`.
    temp6-depth = `18`.
    temp6-height = `3`.
    temp6-dimunit = `cm`.
    temp6-description = `Flexible Laptop with 2,5 GHz Quad Core, 15" HD TN, 16 GB DDR SDRAM, 256 GB SSD, Windows 10 Pro`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1252`.
    temp6-name = `Astro Phone 6`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg`.
    temp6-weightmeasure = `0.75`.
    temp6-weightunit = `KG`.
    temp6-width = `8`.
    temp6-depth = `6`.
    temp6-height = `1.5`.
    temp6-dimunit = `cm`.
    temp6-description = `6 inch 1280x800 HD display (216 ppi), Quad-core processor, 8 GB internal storage (actual formatted capacity will be less), 3050 mAh battery (Up to 8 hours of active use), grey or black`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1253`.
    temp6-name = `Benda Laptop 1408`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg`.
    temp6-weightmeasure = `4.2`.
    temp6-weightunit = `KG`.
    temp6-width = `30`.
    temp6-depth = `18`.
    temp6-height = `3`.
    temp6-dimunit = `cm`.
    temp6-description = `Flexible Laptop with 2,5 GHz Dual Core, 14" HD+ TN, 8 GB DDR SDRAM, 324 GB SSD, Windows 10 Pro`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1254`.
    temp6-name = `Bending Screen 21HD`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg`.
    temp6-weightmeasure = `15`.
    temp6-weightunit = `KG`.
    temp6-width = `37`.
    temp6-depth = `12`.
    temp6-height = `36`.
    temp6-dimunit = `cm`.
    temp6-description = `Optimum Hi-Resolution Widescreen max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1255`.
    temp6-name = `Broad Screen 22HD`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg`.
    temp6-weightmeasure = `16`.
    temp6-weightunit = `KG`.
    temp6-width = `39`.
    temp6-depth = `12`.
    temp6-height = `38`.
    temp6-dimunit = `cm`.
    temp6-description = `Optimum Hi-Resolution Widescreen max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1256`.
    temp6-name = `Cerdik Phone 7`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg`.
    temp6-weightmeasure = `0.75`.
    temp6-weightunit = `KG`.
    temp6-width = `9`.
    temp6-depth = `15`.
    temp6-height = `1.5`.
    temp6-dimunit = `cm`.
    temp6-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1257`.
    temp6-name = `Cepat Tablet 10.5`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg`.
    temp6-weightmeasure = `2.8`.
    temp6-weightunit = `KG`.
    temp6-width = `48`.
    temp6-depth = `31`.
    temp6-height = `4.5`.
    temp6-dimunit = `cm`.
    temp6-description = `10.5-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1258`.
    temp6-name = `Cepat Tablet 8`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg`.
    temp6-weightmeasure = `2.5`.
    temp6-weightunit = `KG`.
    temp6-width = `38`.
    temp6-depth = `21`.
    temp6-height = `3.5`.
    temp6-dimunit = `cm`.
    temp6-description = `8-inch Multitouch HD Screen (2000 x 1500) 32GB Internal Memory, Wireless N Wi-Fi, Bluetooth, GPS Enabled, 1.5 GHz Quad-Core Processor`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1500`.
    temp6-name = `Server Basic`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg`.
    temp6-weightmeasure = `18`.
    temp6-weightunit = `KG`.
    temp6-width = `34`.
    temp6-depth = `35`.
    temp6-height = `23`.
    temp6-dimunit = `cm`.
    temp6-description = `Dual socket, quad-core processing server with 1333 MHz Front Side Bus with 10Gb connectivity`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1501`.
    temp6-name = `Server Professional`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg`.
    temp6-weightmeasure = `25`.
    temp6-weightunit = `KG`.
    temp6-width = `29`.
    temp6-depth = `30`.
    temp6-height = `27`.
    temp6-dimunit = `cm`.
    temp6-description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 10Gb connectivity`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1502`.
    temp6-name = `Server Power Pro`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg`.
    temp6-weightmeasure = `35`.
    temp6-weightunit = `KG`.
    temp6-width = `22`.
    temp6-depth = `27.3`.
    temp6-height = `37`.
    temp6-dimunit = `cm`.
    temp6-description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 100Gb connectivity`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1600`.
    temp6-name = `Family PC Basic`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg`.
    temp6-weightmeasure = `4.8`.
    temp6-weightunit = `KG`.
    temp6-width = `21.4`.
    temp6-depth = `29`.
    temp6-height = `38`.
    temp6-dimunit = `cm`.
    temp6-description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Graphic Card: Proctra X, Windows 8`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1601`.
    temp6-name = `Family PC Pro`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg`.
    temp6-weightmeasure = `5.3`.
    temp6-weightunit = `KG`.
    temp6-width = `25`.
    temp6-depth = `31.7`.
    temp6-height = `40.2`.
    temp6-dimunit = `cm`.
    temp6-description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1602`.
    temp6-name = `Gaming Monster`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg`.
    temp6-weightmeasure = `5.9`.
    temp6-weightunit = `KG`.
    temp6-width = `26.5`.
    temp6-depth = `34`.
    temp6-height = `47`.
    temp6-dimunit = `cm`.
    temp6-description = `3,4 Ghz quad core, 8 GB DDR3 SDRAM, 2000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-1603`.
    temp6-name = `Gaming Monster Pro`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg`.
    temp6-weightmeasure = `6.8`.
    temp6-weightunit = `KG`.
    temp6-width = `27`.
    temp6-depth = `28`.
    temp6-height = `42`.
    temp6-dimunit = `cm`.
    temp6-description = `3,4 Ghz quad core, 16 GB DDR3 SDRAM, 4000 GB Hard Disc, Graphic Card: Hurricane GX, Windows 8`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-2000`.
    temp6-name = `7" Widescreen Portable DVD Player w MP3`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg`.
    temp6-weightmeasure = `0.79`.
    temp6-weightunit = `KG`.
    temp6-width = `21.4`.
    temp6-depth = `19`.
    temp6-height = `27.6`.
    temp6-dimunit = `cm`.
    temp6-description = `7" LCD Screen, storage battery holds up to 6 hours!`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-2001`.
    temp6-name = `10" Portable DVD player`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg`.
    temp6-weightmeasure = `0.84`.
    temp6-weightunit = `KG`.
    temp6-width = `24`.
    temp6-depth = `19.5`.
    temp6-height = `29`.
    temp6-dimunit = `cm`.
    temp6-description = `10" LCD Screen, storage battery holds up to 8 hours`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-2002`.
    temp6-name = `Portable DVD Player with 9" LCD Monitor`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg`.
    temp6-weightmeasure = `0.72`.
    temp6-weightunit = `KG`.
    temp6-width = `21`.
    temp6-depth = `16.5`.
    temp6-height = `14`.
    temp6-dimunit = `cm`.
    temp6-description = `9" LCD Screen, storage holds up to 8 hours, 2 speakers included`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-2025`.
    temp6-name = `CD/DVD case: 264 sleeves`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg`.
    temp6-weightmeasure = `0.65`.
    temp6-weightunit = `KG`.
    temp6-width = `13`.
    temp6-depth = `13`.
    temp6-height = `20`.
    temp6-dimunit = `cm`.
    temp6-description = `Organizer and protective case for 264 CDs and DVDs`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-2026`.
    temp6-name = `Audio/Video Cable Kit - 4m`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg`.
    temp6-weightmeasure = `0.2`.
    temp6-weightunit = `KG`.
    temp6-width = `21`.
    temp6-depth = `10.2`.
    temp6-height = `13`.
    temp6-dimunit = `cm`.
    temp6-description = `Quality cables for notebooks and projectors`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-2027`.
    temp6-name = `Removable CD/DVD Laser Labels`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg`.
    temp6-weightmeasure = `0.15`.
    temp6-weightunit = `KG`.
    temp6-width = `5.5`.
    temp6-depth = `2`.
    temp6-height = `2`.
    temp6-dimunit = `cm`.
    temp6-description = `Removable jewel case labels, zero residues (100)`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-6100`.
    temp6-name = `Beam Breaker B-1`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg`.
    temp6-weightmeasure = `1.7`.
    temp6-weightunit = `KG`.
    temp6-width = `30.4`.
    temp6-depth = `23.1`.
    temp6-height = `23`.
    temp6-dimunit = `cm`.
    temp6-description = `720p, DLP Projector max. 8,45 Meter, 2D`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-6101`.
    temp6-name = `Beam Breaker B-2`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg`.
    temp6-weightmeasure = `2`.
    temp6-weightunit = `KG`.
    temp6-width = `30.4`.
    temp6-depth = `23.1`.
    temp6-height = `23`.
    temp6-dimunit = `cm`.
    temp6-description = `1080p, DLP max.9,34 Meter, 2D-ready`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-6102`.
    temp6-name = `Beam Breaker B-3`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg`.
    temp6-weightmeasure = `2.5`.
    temp6-weightunit = `KG`.
    temp6-width = `30.4`.
    temp6-depth = `23.1`.
    temp6-height = `23`.
    temp6-dimunit = `cm`.
    temp6-description = `1080p, DLP max. 12,3 Meter, 3D-ready`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-6110`.
    temp6-name = `Play Movie`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg`.
    temp6-weightmeasure = `2.4`.
    temp6-weightunit = `KG`.
    temp6-width = `37`.
    temp6-depth = `24`.
    temp6-height = `6`.
    temp6-dimunit = `cm`.
    temp6-description = `CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-6111`.
    temp6-name = `Record Movie`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg`.
    temp6-weightmeasure = `3.1`.
    temp6-weightunit = `KG`.
    temp6-width = `38`.
    temp6-depth = `26`.
    temp6-height = `6.2`.
    temp6-dimunit = `cm`.
    temp6-description = `160 GB HDD, CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-6120`.
    temp6-name = `ITelo MusicStick`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg`.
    temp6-weightmeasure = `134`.
    temp6-weightunit = `G`.
    temp6-width = `1.5`.
    temp6-depth = `6`.
    temp6-height = `1`.
    temp6-dimunit = `cm`.
    temp6-description = `64 GB USB Music-on-Available-Stick`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-6121`.
    temp6-name = `ITelo Jog-Mate`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg`.
    temp6-weightmeasure = `134`.
    temp6-weightunit = `G`.
    temp6-width = `5.1`.
    temp6-depth = `8`.
    temp6-height = `9.2`.
    temp6-dimunit = `cm`.
    temp6-description = `ITelo Jog-Mate 64 GB HDD and Color Display, can play movies`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-6122`.
    temp6-name = `Power Pro Player 40`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg`.
    temp6-weightmeasure = `266`.
    temp6-weightunit = `G`.
    temp6-width = `5.1`.
    temp6-depth = `8`.
    temp6-height = `9.2`.
    temp6-dimunit = `cm`.
    temp6-description = `MP3-Player with 40 GB HDD and Color Display, can play movies`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-6123`.
    temp6-name = `Power Pro Player 80`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg`.
    temp6-weightmeasure = `267`.
    temp6-weightunit = `G`.
    temp6-width = `4`.
    temp6-depth = `6`.
    temp6-height = `0.8`.
    temp6-dimunit = `cm`.
    temp6-description = `MP3-Player with 80 GB SSD and Color Display, can play movies`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-6130`.
    temp6-name = `Flat Watch HD32`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg`.
    temp6-weightmeasure = `2.6`.
    temp6-weightunit = `KG`.
    temp6-width = `78`.
    temp6-depth = `22.1`.
    temp6-height = `55`.
    temp6-dimunit = `cm`.
    temp6-description = `32-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-6131`.
    temp6-name = `Flat Watch HD37`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg`.
    temp6-weightmeasure = `2.2`.
    temp6-weightunit = `KG`.
    temp6-width = `99.1`.
    temp6-depth = `26`.
    temp6-height = `61`.
    temp6-dimunit = `cm`.
    temp6-description = `37-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-6132`.
    temp6-name = `Flat Watch HD41`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg`.
    temp6-weightmeasure = `1.8`.
    temp6-weightunit = `KG`.
    temp6-width = `128`.
    temp6-depth = `23`.
    temp6-height = `79.1`.
    temp6-dimunit = `cm`.
    temp6-description = `41-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-7000`.
    temp6-name = `Copperberry`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg`.
    temp6-weightmeasure = `0.5`.
    temp6-weightunit = `KG`.
    temp6-width = `8.1`.
    temp6-depth = `13`.
    temp6-height = `12.1`.
    temp6-dimunit = `cm`.
    temp6-description = `Our new multifunctional Handheld with phone function in copper`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-7010`.
    temp6-name = `Silverberry`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg`.
    temp6-weightmeasure = `0.5`.
    temp6-weightunit = `KG`.
    temp6-width = `8.1`.
    temp6-depth = `13`.
    temp6-height = `12.1`.
    temp6-dimunit = `cm`.
    temp6-description = `Our new multifunctional Handheld with phone function in silver`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-7020`.
    temp6-name = `Goldberry`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg`.
    temp6-weightmeasure = `0.5`.
    temp6-weightunit = `KG`.
    temp6-width = `8.1`.
    temp6-depth = `13`.
    temp6-height = `12.1`.
    temp6-dimunit = `cm`.
    temp6-description = `Our new multifunctional Handheld with phone function in gold`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-7030`.
    temp6-name = `Platinberry`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg`.
    temp6-weightmeasure = `0.5`.
    temp6-weightunit = `KG`.
    temp6-width = `8.1`.
    temp6-depth = `13`.
    temp6-height = `12.1`.
    temp6-dimunit = `cm`.
    temp6-description = `Our new multifunctional Handheld with phone function in platinum`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-8000`.
    temp6-name = `ITelO FlexTop I4000`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg`.
    temp6-weightmeasure = `4`.
    temp6-weightunit = `KG`.
    temp6-width = `31`.
    temp6-depth = `19`.
    temp6-height = `3.1`.
    temp6-dimunit = `cm`.
    temp6-description = `Notebook with 2,80 GHz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-8001`.
    temp6-name = `ITelO FlexTop I6300c`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg`.
    temp6-weightmeasure = `4.2`.
    temp6-weightunit = `KG`.
    temp6-width = `32`.
    temp6-depth = `20`.
    temp6-height = `3.4`.
    temp6-dimunit = `cm`.
    temp6-description = `Notebook with 2,80 GHz dual core, 8 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-8002`.
    temp6-name = `ITelO FlexTop I9100`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg`.
    temp6-weightmeasure = `3.5`.
    temp6-weightunit = `KG`.
    temp6-width = `38`.
    temp6-depth = `21`.
    temp6-height = `4.1`.
    temp6-dimunit = `cm`.
    temp6-description = `Notebook with 2,80 GHz quad core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-8003`.
    temp6-name = `ITelO FlexTop I9800`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg`.
    temp6-weightmeasure = `3.8`.
    temp6-weightunit = `KG`.
    temp6-width = `48`.
    temp6-depth = `31`.
    temp6-height = `4.5`.
    temp6-dimunit = `cm`.
    temp6-description = `Notebook with 2,80 GHz quad core, 8 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-9991`.
    temp6-name = `Smartphone Leather Case`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg`.
    temp6-weightmeasure = `0.02`.
    temp6-weightunit = `KG`.
    temp6-width = `48`.
    temp6-depth = `31`.
    temp6-height = `4.5`.
    temp6-dimunit = `cm`.
    temp6-description = `Button Clasp, Quality Material, 100% Leather, compatible with many smartphone models`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-9992`.
    temp6-name = `Smartphone Alpha`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg`.
    temp6-weightmeasure = `0.75`.
    temp6-weightunit = `KG`.
    temp6-width = `48`.
    temp6-depth = `31`.
    temp6-height = `4.5`.
    temp6-dimunit = `cm`.
    temp6-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-9993`.
    temp6-name = `Mini Tablet`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg`.
    temp6-weightmeasure = `3.8`.
    temp6-weightunit = `KG`.
    temp6-width = `48`.
    temp6-depth = `31`.
    temp6-height = `4.5`.
    temp6-dimunit = `cm`.
    temp6-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage, 4325 mAh battery (Up to 8 hours of active use)`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-9994`.
    temp6-name = `Camcorder View`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg`.
    temp6-weightmeasure = `3.8`.
    temp6-weightunit = `KG`.
    temp6-width = `48`.
    temp6-depth = `31`.
    temp6-height = `27`.
    temp6-dimunit = `cm`.
    temp6-description = `1920x1080 Full HD, image stabilization reduces blur, 27x Optical / 32x Extended Zoom, wide angle Lens, 2.7" wide LCD display`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-9995`.
    temp6-name = `Tablet Pouch`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg`.
    temp6-weightmeasure = `0.03`.
    temp6-weightunit = `KG`.
    temp6-width = `25`.
    temp6-depth = `40`.
    temp6-height = `4.5`.
    temp6-dimunit = `cm`.
    temp6-description = `Stylish tablet pouch, protects from scratches, color: black`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-9996`.
    temp6-name = `Tablet Pouch`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg`.
    temp6-weightmeasure = `0.03`.
    temp6-weightunit = `KG`.
    temp6-width = `25`.
    temp6-depth = `40`.
    temp6-height = `4.5`.
    temp6-dimunit = `cm`.
    temp6-description = `Stylish tablet pouch, protects from scratches, color: black`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-9997`.
    temp6-name = `e-Book Reader ReadMe`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg`.
    temp6-weightmeasure = `3.8`.
    temp6-weightunit = `KG`.
    temp6-width = `48`.
    temp6-depth = `31`.
    temp6-height = `4.5`.
    temp6-dimunit = `cm`.
    temp6-description = `6-Inch E Ink Screen, Access To e-book Store, Adjustable Font Styles and Sizes, Stores Up To 1,000 Books`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-9998`.
    temp6-name = `Smartphone Beta`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg`.
    temp6-weightmeasure = `0.75`.
    temp6-weightunit = `KG`.
    temp6-width = `48`.
    temp6-depth = `31`.
    temp6-height = `4.5`.
    temp6-dimunit = `cm`.
    temp6-description = `5 Megapixel Camera, Wi-Fi 802.11 b/g/n, Bluetooth, GPS Available-GPS support`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `HT-9999`.
    temp6-name = `Maxi Tablet`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg`.
    temp6-weightmeasure = `3.8`.
    temp6-weightunit = `KG`.
    temp6-width = `48`.
    temp6-depth = `31`.
    temp6-height = `4.5`.
    temp6-dimunit = `cm`.
    temp6-description = `10.1-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor`.
    INSERT temp6 INTO TABLE temp5.
    temp6-product_id = `PF-1000`.
    temp6-name = `Flyer`.
    temp6-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg`.
    temp6-weightmeasure = `0.01`.
    temp6-weightunit = `KG`.
    temp6-width = `46`.
    temp6-depth = `30`.
    temp6-height = `3`.
    temp6-dimunit = `cm`.
    temp6-description = `Flyer for our product palette`.
    INSERT temp6 INTO TABLE temp5.
    t_products = temp5.

  ENDMETHOD.

ENDCLASS.
