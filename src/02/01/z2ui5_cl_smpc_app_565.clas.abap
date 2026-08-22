" @keywords popover sap.m popovernavcon button navcontainer list standardlistitem objectheader objectattribute text
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
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

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
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

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
                    )->a( n = `press`        v = client->_event( val   = `OPEN_POPOVER`
                                                                 t_arg = VALUE #( ( `$event.oSource.sId` ) ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD popover_display.

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory( ).

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
                            )->a( n = `press`            v = client->_event( val   = `NAV_TO_PRODUCT`
                                                                             t_arg = VALUE #( ( `${$source>/description}` ) ) )

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

    client->popover_display( xml   = popup->stringify( )
                             by_id = by_id ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `OPEN_POPOVER`.
        popover_display( client->get_event_arg( ) ).

      WHEN `NAV_TO_PRODUCT`.
        " onNavToProduct: navigate to the detail page and bind it to the pressed row
        DATA(product_id) = client->get_event_arg( ).
        ASSIGN t_products[ product_id = product_id ] TO FIELD-SYMBOL(<product>).
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
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  view  = client->cs_view-popup
                                  t_arg = VALUE #( ( `navCon` ) ( `to` ) ( `detail` ) ) ).

      WHEN `NAV_BACK`.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  view  = client->cs_view-popup
                                  t_arg = VALUE #( ( `navCon` ) ( `back` ) ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " the full mock /ProductCollection (sap/ui/demo/mock/products.json), all 123 rows
    t_products = VALUE #(
      ( product_id = `HT-1000` name = `Notebook Basic 15` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`
        weightmeasure = `4.2` weightunit = `KG` width = `30` depth = `18` height = `3` dimunit = `cm`
        description = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro` )
      ( product_id = `HT-1001` name = `Notebook Basic 17` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg`
        weightmeasure = `4.5` weightunit = `KG` width = `29` depth = `17` height = `3.1` dimunit = `cm`
        description = `Notebook Basic 17 with 2,80 GHz quad core, 17" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro` )
      ( product_id = `HT-1002` name = `Notebook Basic 18` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg`
        weightmeasure = `4.2` weightunit = `KG` width = `28` depth = `19` height = `2.5` dimunit = `cm`
        description = `Notebook Basic 18 with 2,80 GHz quad core, 18" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro` )
      ( product_id = `HT-1003` name = `Notebook Basic 19` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg`
        weightmeasure = `4.2` weightunit = `KG` width = `32` depth = `21` height = `4` dimunit = `cm`
        description = `Notebook Basic 19 with 2,80 GHz quad core, 19" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro` )
      ( product_id = `HT-1007` name = `ITelO Vault` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg`
        weightmeasure = `0.2` weightunit = `KG` width = `32` depth = `22` height = `3` dimunit = `cm`
        description = `Digital Organizer with State-of-the-Art Storage Encryption` )
      ( product_id = `HT-1010` name = `Notebook Professional 15` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg`
        weightmeasure = `4.3` weightunit = `KG` width = `33` depth = `20` height = `3` dimunit = `cm`
        description = `Notebook Professional 15 with 2,80 GHz quad core, 15" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro` )
      ( product_id = `HT-1011` name = `Notebook Professional 17` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg`
        weightmeasure = `4.1` weightunit = `KG` width = `33` depth = `23` height = `2` dimunit = `cm`
        description = `Notebook Professional 17 with 2,80 GHz quad core, 17" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro` )
      ( product_id = `HT-1020` name = `ITelO Vault Net` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg`
        weightmeasure = `0.16` weightunit = `KG` width = `10` depth = `1.8` height = `17` dimunit = `cm`
        description = `Digital Organizer with State-of-the-Art Encryption for Storage and Network Communications` )
      ( product_id = `HT-1021` name = `ITelO Vault SAT` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg`
        weightmeasure = `0.18` weightunit = `KG` width = `11` depth = `1.7` height = `18` dimunit = `cm`
        description = `Digital Organizer with State-of-the-Art Encryption for Storage and Secure Stellite Link` )
      ( product_id = `HT-1022` name = `Comfort Easy` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg`
        weightmeasure = `0.2` weightunit = `KG` width = `84` depth = `1.5` height = `14` dimunit = `cm`
        description = `32 GB Digital Assistant with high-resolution color screen` )
      ( product_id = `HT-1023` name = `Comfort Senior` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg`
        weightmeasure = `0.8` weightunit = `KG` width = `80` depth = `1.6` height = `13` dimunit = `cm`
        description = `64 GB Digital Assistant with high-resolution color screen and synthesized voice output` )
      ( product_id = `HT-1030` name = `Ergo Screen E-I` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg`
        weightmeasure = `21` weightunit = `KG` width = `37` depth = `12` height = `36` dimunit = `cm`
        description = `Optimum Hi-Resolution max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm` )
      ( product_id = `HT-1031` name = `Ergo Screen E-II` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg`
        weightmeasure = `21` weightunit = `KG` width = `40.8` depth = `19` height = `43` dimunit = `cm`
        description = `Optimum Hi-Resolution max. 1920 x 1200 @ 85Hz, Dot Pitch: 0.26mm` )
      ( product_id = `HT-1032` name = `Ergo Screen E-III` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg`
        weightmeasure = `21` weightunit = `KG` width = `40.8` depth = `19` height = `43` dimunit = `cm`
        description = `Optimum Hi-Resolution max. 2560 x 1440 @ 85Hz, Dot Pitch: 0.25mm` )
      ( product_id = `HT-1035` name = `Flat Basic` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg`
        weightmeasure = `14` weightunit = `KG` width = `39` depth = `20` height = `41` dimunit = `cm`
        description = `Optimum Hi-Resolution max. 1600 x 1200 @ 85Hz, Dot Pitch: 0.24mm` )
      ( product_id = `HT-1036` name = `Flat Future` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg`
        weightmeasure = `15` weightunit = `KG` width = `45` depth = `26` height = `46` dimunit = `cm`
        description = `Optimum Hi-Resolution max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.26mm` )
      ( product_id = `HT-1037` name = `Flat XL` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg`
        weightmeasure = `17` weightunit = `KG` width = `54.5` depth = `22.1` height = `39.1` dimunit = `cm`
        description = `Optimum Hi-Resolution max. 2016 x 1512 @ 85Hz, Dot Pitch: 0.24mm` )
      ( product_id = `HT-1040` name = `Laser Professional Eco` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg`
        weightmeasure = `32` weightunit = `KG` width = `51` depth = `46` height = `30` dimunit = `cm`
        description = `Print 2400 dpi image quality color documents at speeds of up to 32 ppm (color) or 36 ppm (monochrome), letter/A4. Powerful 500 MHz processor, 512MB of memory` )
      ( product_id = `HT-1041` name = `Laser Basic` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg`
        weightmeasure = `23` weightunit = `KG` width = `48` depth = `42` height = `26` dimunit = `cm`
        description = `Up to 22 ppm color or 24 ppm monochrome A4/letter, powerful 500 MHz processor and 128MB of memory` )
      ( product_id = `HT-1042` name = `Laser Allround` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg`
        weightmeasure = `17` weightunit = `KG` width = `53` depth = `50` height = `65` dimunit = `cm`
        description = `Print up to 25 ppm letter and 24 ppm A4 color or monochrome, with Available first-page-out-time of less than 13 seconds for monochrome and less than 15 seconds for color` )
      ( product_id = `HT-1050` name = `Ultra Jet Super Color` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg`
        weightmeasure = `3` weightunit = `KG` width = `41` depth = `41` height = `28` dimunit = `cm`
        description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB, Ethernet` )
      ( product_id = `HT-1051` name = `Ultra Jet Mobile` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg`
        weightmeasure = `1.9` weightunit = `KG` width = `46` depth = `32` height = `25` dimunit = `cm`
        description = `1000 dpi x 1000 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB - excellent dimensions for the small office` )
      ( product_id = `HT-1052` name = `Ultra Jet Super Highspeed` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg`
        weightmeasure = `18` weightunit = `KG` width = `41` depth = `41` height = `28` dimunit = `cm`
        description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB2.0, Ethernet` )
      ( product_id = `HT-1055` name = `Multi Print` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg`
        weightmeasure = `6.3` weightunit = `KG` width = `55` depth = `45` height = `29` dimunit = `cm`
        description = `1000 dpi x 1000 dpi - up to 16 ppm (mono) / up to 15 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 1200dpi x 2400dpi)` )
      ( product_id = `HT-1056` name = `Multi Color` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg`
        weightmeasure = `4.3` weightunit = `KG` width = `51` depth = `41.3` height = `22` dimunit = `cm`
        description = `1200 dpi x 1200 dpi - up to 25 ppm (mono) / up to 24 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 2400dpi x 4800dpi, high resolution)` )
      ( product_id = `HT-1060` name = `Cordless Mouse` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg`
        weightmeasure = `0.09` weightunit = `KG` width = `6` depth = `14.5` height = `3.5` dimunit = `cm`
        description = `Cordless Optical USB Mice, Laptop, Color: Black, Plug&Play` )
      ( product_id = `HT-1061` name = `Speed Mouse` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg`
        weightmeasure = `0.09` weightunit = `KG` width = `7` depth = `15` height = `3.1` dimunit = `cm`
        description = `Optical USB, PS/2 Mouse, Color: Blue, 3-button-functionality (incl. Scroll wheel)` )
      ( product_id = `HT-1062` name = `Track Mouse` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg`
        weightmeasure = `0.03` weightunit = `KG` width = `3` depth = `7` height = `4` dimunit = `cm`
        description = `Optical USB Mouse, Color: Red, 5-button-functionality(incl. Scroll wheel), Plug&Play` )
      ( product_id = `HT-1063` name = `Ergonomic Keyboard` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg`
        weightmeasure = `2.1` weightunit = `KG` width = `50` depth = `21` height = `3.5` dimunit = `cm`
        description = `Ergonomic USB Keyboard for Desktop, Plug&Play` )
      ( product_id = `HT-1064` name = `Internet Keyboard` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg`
        weightmeasure = `1.8` weightunit = `KG` width = `52` depth = `25` height = `3` dimunit = `cm`
        description = `Corded Keyboard with special keys for Internet Usability, USB` )
      ( product_id = `HT-1065` name = `Media Keyboard` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg`
        weightmeasure = `2.3` weightunit = `KG` width = `51.4` depth = `23` height = `4` dimunit = `cm`
        description = `Corded Ergonomic Keyboard with special keys for Media Usability, USB` )
      ( product_id = `HT-1066` name = `Mousepad` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg`
        weightmeasure = `80` weightunit = `G` width = `15` depth = `6` height = `0.2` dimunit = `cm`
        description = `Nice mouse pad with ITelO Logo` )
      ( product_id = `HT-1067` name = `Ergo Mousepad` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg`
        weightmeasure = `80` weightunit = `G` width = `15` depth = `6` height = `0.2` dimunit = `cm`
        description = `Ergonomic mouse pad with ITelO Logo` )
      ( product_id = `HT-1068` name = `Designer Mousepad` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg`
        weightmeasure = `90` weightunit = `G` width = `24` depth = `24` height = `0.6` dimunit = `cm`
        description = `ITelO Mousepad Special Edition` )
      ( product_id = `HT-1069` name = `Universal card reader` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg`
        weightmeasure = `45` weightunit = `G` width = `6` depth = `6` height = `3` dimunit = `cm`
        description = `Universal card reader` )
      ( product_id = `HT-1070` name = `Proctra X` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg`
        weightmeasure = `0.255` weightunit = `KG` width = `22` depth = `35` height = `17` dimunit = `cm`
        description = `Proctra X: PCI-E GDDR5 3072MB` )
      ( product_id = `HT-1071` name = `Gladiator MX` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg`
        weightmeasure = `0.3` weightunit = `KG` width = `22` depth = `35` height = `17` dimunit = `cm`
        description = `Gladiator XLN: PCI-E GDDR5 3072MB DVI Out, TV Out low-noise` )
      ( product_id = `HT-1072` name = `Hurricane GX` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg`
        weightmeasure = `0.4` weightunit = `KG` width = `22` depth = `35` height = `17` dimunit = `cm`
        description = `Hurricane GX: PCI-E 691 GFLOPS game-optimized` )
      ( product_id = `HT-1073` name = `Hurricane GX/LN` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg`
        weightmeasure = `0.4` weightunit = `KG` width = `22` depth = `35` height = `17` dimunit = `cm`
        description = `Hurricane GX/LN: PCI-E 691 GFLOPS game-optimized, low-noise.` )
      ( product_id = `HT-1080` name = `Photo Scan` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg`
        weightmeasure = `2.3` weightunit = `KG` width = `34` depth = `48` height = `5` dimunit = `cm`
        description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - Hi-Speed USB - Bluetooth` )
      ( product_id = `HT-1081` name = `Power Scan` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg`
        weightmeasure = `2.4` weightunit = `KG` width = `31` depth = `43` height = `7` dimunit = `cm`
        description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - SCSI for backward compatibility` )
      ( product_id = `HT-1082` name = `Jet Scan Professional` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg`
        weightmeasure = `3.2` weightunit = `KG` width = `33` depth = `41` height = `12` dimunit = `cm`
        description = `Flatbed scanner - Letter - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module` )
      ( product_id = `HT-1083` name = `Jet Scan Professional` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg`
        weightmeasure = `3.2` weightunit = `KG` width = `35` depth = `40` height = `10` dimunit = `cm`
        description = `Flatbed scanner - A4 - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module` )
      ( product_id = `HT-1085` name = `Copymaster` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg`
        weightmeasure = `23.2` weightunit = `KG` width = `45` depth = `42` height = `22` dimunit = `cm`
        description = `Copymaster` )
      ( product_id = `HT-1090` name = `Surround Sound` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg`
        weightmeasure = `3` weightunit = `KG` width = `12` depth = `10` height = `16` dimunit = `cm`
        description = `PC multimedia speakers - 5 Watt (Total)` )
      ( product_id = `HT-1091` name = `Blaster Extreme` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg`
        weightmeasure = `1.4` weightunit = `KG` width = `13` depth = `11` height = `17.5` dimunit = `cm`
        description = `PC multimedia speakers - 10 Watt (Total) - 2-way` )
      ( product_id = `HT-1092` name = `Sound Booster` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg`
        weightmeasure = `2.1` weightunit = `KG` width = `12.4` depth = `10.4` height = `18.1` dimunit = `cm`
        description = `PC multimedia speakers - optimized for Blutooth/A2DP` )
      ( product_id = `HT-1095` name = `Lovely Sound 5.1 Wireless` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg`
        weightmeasure = `80` weightunit = `G` width = `24` depth = `19` height = `23` dimunit = `cm`
        description = `5.1 Headset, 40 Hz-20 kHz, Wireless` )
      ( product_id = `HT-1096` name = `Lovely Sound 5.1` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg`
        weightmeasure = `130` weightunit = `G` width = `25` depth = `17` height = `19` dimunit = `cm`
        description = `5.1 Headset, 40 Hz-20 kHz, 3m cable` )
      ( product_id = `HT-1097` name = `Lovely Sound Stereo` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg`
        weightmeasure = `60` weightunit = `G` width = `21.3` depth = `2.4` height = `19.7` dimunit = `cm`
        description = `5.1 Headset, 40 Hz-20 kHz, 1m cable` )
      ( product_id = `HT-1100` name = `Smart Office` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg`
        weightmeasure = `1.2` weightunit = `KG` width = `15` depth = `6.5` height = `2.1` dimunit = `cm`
        description = `Complete package, 1 User, Office Applications (word processing, spreadsheet, presentations)` )
      ( product_id = `HT-1101` name = `Smart Design` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg`
        weightmeasure = `0.8` weightunit = `KG` width = `14` depth = `6.7` height = `24` dimunit = `cm`
        description = `Complete package, 1 User, Image editing, processing` )
      ( product_id = `HT-1102` name = `Smart Network` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg`
        weightmeasure = `0.8` weightunit = `KG` width = `16` depth = `6` height = `27` dimunit = `cm`
        description = `Complete package, 1 User, Network Software Utilities, Useful Applications and Documentation` )
      ( product_id = `HT-1103` name = `Smart Multimedia` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg`
        weightmeasure = `0.8` weightunit = `KG` width = `11` depth = `3.4` height = `22` dimunit = `cm`
        description = `Complete package, 1 User, different Multimedia applications, playing music, watching DVDs, only with this Smart package` )
      ( product_id = `HT-1104` name = `Smart Games` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg`
        weightmeasure = `1.1` weightunit = `KG` width = `10` depth = `3` height = `30` dimunit = `cm`
        description = `Complete package, 1 User, various games for amusement, logic, action, jump&run` )
      ( product_id = `HT-1105` name = `Smart Internet Antivirus` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg`
        weightmeasure = `0.7` weightunit = `KG` width = `16` depth = `4` height = `21` dimunit = `cm`
        description = `Complete package, 1 User, highly recommended for internet users as anti-virus protection` )
      ( product_id = `HT-1106` name = `Smart Firewall` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg`
        weightmeasure = `0.9` weightunit = `KG` width = `17.9` depth = `4.2` height = `23.1` dimunit = `cm`
        description = `Complete package, 1 User, recommended for internet users, protect your PC against cyber-crime` )
      ( product_id = `HT-1107` name = `Smart Money` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg`
        weightmeasure = `0.5` weightunit = `KG` width = `12` depth = `1.5` height = `19` dimunit = `cm`
        description = `Complete package, 1 User, bring your money in your mind, see what you have and what you want` )
      ( product_id = `HT-1110` name = `PC Lock` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg`
        weightmeasure = `0.03` weightunit = `KG` width = `20` depth = `8` height = `4.3` dimunit = `cm`
        description = `Robust 3m anti-burglary protection for your laptop computer` )
      ( product_id = `HT-1111` name = `Notebook Lock` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg`
        weightmeasure = `0.02` weightunit = `KG` width = `31` depth = `9` height = `7` dimunit = `cm`
        description = `Robust 1m anti-burglary protection for your desktop computer` )
      ( product_id = `HT-1112` name = `Web cam reality` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg`
        weightmeasure = `0.075` weightunit = `KG` width = `9` depth = `8.2` height = `1.3` dimunit = `cm`
        description = `Color webcam, color, High-Speed USB` )
      ( product_id = `HT-1113` name = `Screen clean` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg`
        weightmeasure = `0.05` weightunit = `KG` width = `2` depth = `2` height = `0.1` dimunit = `cm`
        description = `10 separately packed screen wipes` )
      ( product_id = `HT-1114` name = `Fabric bag professional` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg`
        weightmeasure = `1.8` weightunit = `KG` width = `42` depth = `32` height = `7` dimunit = `cm`
        description = `Notebook bag, plenty of room for stationery and writing materials` )
      ( product_id = `HT-1115` name = `Wireless DSL Router` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg`
        weightmeasure = `0.45` weightunit = `KG` width = `19.3` depth = `18` height = `5` dimunit = `cm`
        description = `Wireless DSL Router (available in blue, black and silver)` )
      ( product_id = `HT-1116` name = `Wireless DSL Router / Repeater` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg`
        weightmeasure = `0.45` weightunit = `KG` width = `19.3` depth = `18` height = `5` dimunit = `cm`
        description = `Wireless DSL Router / Repeater (available in blue, black and silver)` )
      ( product_id = `HT-1117` name = `Wireless DSL Router / Repeater and Print Server` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg`
        weightmeasure = `0.45` weightunit = `KG` width = `19.3` depth = `18` height = `5` dimunit = `cm`
        description = `Wireless DSL Router / Repeater and Print Server (available in blue, black and silver)` )
      ( product_id = `HT-1118` name = `USB Stick` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg`
        weightmeasure = `0.015` weightunit = `KG` width = `1.5` depth = `8.7` height = `1.2` dimunit = `cm`
        description = `USB 2.0 High-Speed 64 GB` )
      ( product_id = `HT-1119` name = `Travel Adapter` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg`
        weightmeasure = `88` weightunit = `G` width = `2` depth = `3.1` height = `3.9` dimunit = `cm`
        description = `Universal Travel Adapter` )
      ( product_id = `HT-1120` name = `Cordless Bluetooth Keyboard, english international` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg`
        weightmeasure = `1` weightunit = `KG` width = `51.4` depth = `23` height = `4` dimunit = `cm`
        description = `Cordless Bluetooth Keyboard with English keys` )
      ( product_id = `HT-1137` name = `Flat XXL` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg`
        weightmeasure = `18` weightunit = `KG` width = `54` depth = `22` height = `38` dimunit = `cm`
        description = `Optimum Hi-Resolution max. 2048 × 1536 @ 85Hz, Dot Pitch: 0.24mm` )
      ( product_id = `HT-1138` name = `Pocket Mouse` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg`
        weightmeasure = `0.02` weightunit = `KG` width = `0.3` depth = `0.5` height = `1` dimunit = `cm`
        description = `Portable pocket Mouse with retracting cord` )
      ( product_id = `HT-1210` name = `PC Power Station` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg`
        weightmeasure = `2.3` weightunit = `KG` width = `28` depth = `31` height = `43` dimunit = `cm`
        description = `PC Power Station with 3,4 Ghz quad-core, 32 GB DDR3 SDRAM, feels like Available PC, Windows 8 Pro` )
      ( product_id = `HT-1251` name = `Astro Laptop 1516` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg`
        weightmeasure = `4.2` weightunit = `KG` width = `30` depth = `18` height = `3` dimunit = `cm`
        description = `Flexible Laptop with 2,5 GHz Quad Core, 15" HD TN, 16 GB DDR SDRAM, 256 GB SSD, Windows 10 Pro` )
      ( product_id = `HT-1252` name = `Astro Phone 6` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg`
        weightmeasure = `0.75` weightunit = `KG` width = `8` depth = `6` height = `1.5` dimunit = `cm`
        description = `6 inch 1280x800 HD display (216 ppi), Quad-core processor, 8 GB internal storage (actual formatted capacity will be less), 3050 mAh battery (Up to 8 hours of active use), grey or black` )
      ( product_id = `HT-1253` name = `Benda Laptop 1408` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg`
        weightmeasure = `4.2` weightunit = `KG` width = `30` depth = `18` height = `3` dimunit = `cm`
        description = `Flexible Laptop with 2,5 GHz Dual Core, 14" HD+ TN, 8 GB DDR SDRAM, 324 GB SSD, Windows 10 Pro` )
      ( product_id = `HT-1254` name = `Bending Screen 21HD` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg`
        weightmeasure = `15` weightunit = `KG` width = `37` depth = `12` height = `36` dimunit = `cm`
        description = `Optimum Hi-Resolution Widescreen max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub` )
      ( product_id = `HT-1255` name = `Broad Screen 22HD` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg`
        weightmeasure = `16` weightunit = `KG` width = `39` depth = `12` height = `38` dimunit = `cm`
        description = `Optimum Hi-Resolution Widescreen max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub` )
      ( product_id = `HT-1256` name = `Cerdik Phone 7` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg`
        weightmeasure = `0.75` weightunit = `KG` width = `9` depth = `15` height = `1.5` dimunit = `cm`
        description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black` )
      ( product_id = `HT-1257` name = `Cepat Tablet 10.5` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg`
        weightmeasure = `2.8` weightunit = `KG` width = `48` depth = `31` height = `4.5` dimunit = `cm`
        description = `10.5-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor` )
      ( product_id = `HT-1258` name = `Cepat Tablet 8` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg`
        weightmeasure = `2.5` weightunit = `KG` width = `38` depth = `21` height = `3.5` dimunit = `cm`
        description = `8-inch Multitouch HD Screen (2000 x 1500) 32GB Internal Memory, Wireless N Wi-Fi, Bluetooth, GPS Enabled, 1.5 GHz Quad-Core Processor` )
      ( product_id = `HT-1500` name = `Server Basic` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg`
        weightmeasure = `18` weightunit = `KG` width = `34` depth = `35` height = `23` dimunit = `cm`
        description = `Dual socket, quad-core processing server with 1333 MHz Front Side Bus with 10Gb connectivity` )
      ( product_id = `HT-1501` name = `Server Professional` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg`
        weightmeasure = `25` weightunit = `KG` width = `29` depth = `30` height = `27` dimunit = `cm`
        description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 10Gb connectivity` )
      ( product_id = `HT-1502` name = `Server Power Pro` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg`
        weightmeasure = `35` weightunit = `KG` width = `22` depth = `27.3` height = `37` dimunit = `cm`
        description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 100Gb connectivity` )
      ( product_id = `HT-1600` name = `Family PC Basic` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg`
        weightmeasure = `4.8` weightunit = `KG` width = `21.4` depth = `29` height = `38` dimunit = `cm`
        description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Graphic Card: Proctra X, Windows 8` )
      ( product_id = `HT-1601` name = `Family PC Pro` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg`
        weightmeasure = `5.3` weightunit = `KG` width = `25` depth = `31.7` height = `40.2` dimunit = `cm`
        description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8` )
      ( product_id = `HT-1602` name = `Gaming Monster` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg`
        weightmeasure = `5.9` weightunit = `KG` width = `26.5` depth = `34` height = `47` dimunit = `cm`
        description = `3,4 Ghz quad core, 8 GB DDR3 SDRAM, 2000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8` )
      ( product_id = `HT-1603` name = `Gaming Monster Pro` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg`
        weightmeasure = `6.8` weightunit = `KG` width = `27` depth = `28` height = `42` dimunit = `cm`
        description = `3,4 Ghz quad core, 16 GB DDR3 SDRAM, 4000 GB Hard Disc, Graphic Card: Hurricane GX, Windows 8` )
      ( product_id = `HT-2000` name = `7" Widescreen Portable DVD Player w MP3` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg`
        weightmeasure = `0.79` weightunit = `KG` width = `21.4` depth = `19` height = `27.6` dimunit = `cm`
        description = `7" LCD Screen, storage battery holds up to 6 hours!` )
      ( product_id = `HT-2001` name = `10" Portable DVD player` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg`
        weightmeasure = `0.84` weightunit = `KG` width = `24` depth = `19.5` height = `29` dimunit = `cm`
        description = `10" LCD Screen, storage battery holds up to 8 hours` )
      ( product_id = `HT-2002` name = `Portable DVD Player with 9" LCD Monitor` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg`
        weightmeasure = `0.72` weightunit = `KG` width = `21` depth = `16.5` height = `14` dimunit = `cm`
        description = `9" LCD Screen, storage holds up to 8 hours, 2 speakers included` )
      ( product_id = `HT-2025` name = `CD/DVD case: 264 sleeves` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg`
        weightmeasure = `0.65` weightunit = `KG` width = `13` depth = `13` height = `20` dimunit = `cm`
        description = `Organizer and protective case for 264 CDs and DVDs` )
      ( product_id = `HT-2026` name = `Audio/Video Cable Kit - 4m` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg`
        weightmeasure = `0.2` weightunit = `KG` width = `21` depth = `10.2` height = `13` dimunit = `cm`
        description = `Quality cables for notebooks and projectors` )
      ( product_id = `HT-2027` name = `Removable CD/DVD Laser Labels` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg`
        weightmeasure = `0.15` weightunit = `KG` width = `5.5` depth = `2` height = `2` dimunit = `cm`
        description = `Removable jewel case labels, zero residues (100)` )
      ( product_id = `HT-6100` name = `Beam Breaker B-1` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg`
        weightmeasure = `1.7` weightunit = `KG` width = `30.4` depth = `23.1` height = `23` dimunit = `cm`
        description = `720p, DLP Projector max. 8,45 Meter, 2D` )
      ( product_id = `HT-6101` name = `Beam Breaker B-2` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg`
        weightmeasure = `2` weightunit = `KG` width = `30.4` depth = `23.1` height = `23` dimunit = `cm`
        description = `1080p, DLP max.9,34 Meter, 2D-ready` )
      ( product_id = `HT-6102` name = `Beam Breaker B-3` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg`
        weightmeasure = `2.5` weightunit = `KG` width = `30.4` depth = `23.1` height = `23` dimunit = `cm`
        description = `1080p, DLP max. 12,3 Meter, 3D-ready` )
      ( product_id = `HT-6110` name = `Play Movie` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg`
        weightmeasure = `2.4` weightunit = `KG` width = `37` depth = `24` height = `6` dimunit = `cm`
        description = `CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid` )
      ( product_id = `HT-6111` name = `Record Movie` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg`
        weightmeasure = `3.1` weightunit = `KG` width = `38` depth = `26` height = `6.2` dimunit = `cm`
        description = `160 GB HDD, CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid` )
      ( product_id = `HT-6120` name = `ITelo MusicStick` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg`
        weightmeasure = `134` weightunit = `G` width = `1.5` depth = `6` height = `1` dimunit = `cm`
        description = `64 GB USB Music-on-Available-Stick` )
      ( product_id = `HT-6121` name = `ITelo Jog-Mate` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg`
        weightmeasure = `134` weightunit = `G` width = `5.1` depth = `8` height = `9.2` dimunit = `cm`
        description = `ITelo Jog-Mate 64 GB HDD and Color Display, can play movies` )
      ( product_id = `HT-6122` name = `Power Pro Player 40` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg`
        weightmeasure = `266` weightunit = `G` width = `5.1` depth = `8` height = `9.2` dimunit = `cm`
        description = `MP3-Player with 40 GB HDD and Color Display, can play movies` )
      ( product_id = `HT-6123` name = `Power Pro Player 80` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg`
        weightmeasure = `267` weightunit = `G` width = `4` depth = `6` height = `0.8` dimunit = `cm`
        description = `MP3-Player with 80 GB SSD and Color Display, can play movies` )
      ( product_id = `HT-6130` name = `Flat Watch HD32` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg`
        weightmeasure = `2.6` weightunit = `KG` width = `78` depth = `22.1` height = `55` dimunit = `cm`
        description = `32-inch, 1366x768 Pixel, 16:9, HDTV ready` )
      ( product_id = `HT-6131` name = `Flat Watch HD37` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg`
        weightmeasure = `2.2` weightunit = `KG` width = `99.1` depth = `26` height = `61` dimunit = `cm`
        description = `37-inch, 1366x768 Pixel, 16:9, HDTV ready` )
      ( product_id = `HT-6132` name = `Flat Watch HD41` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg`
        weightmeasure = `1.8` weightunit = `KG` width = `128` depth = `23` height = `79.1` dimunit = `cm`
        description = `41-inch, 1366x768 Pixel, 16:9, HDTV ready` )
      ( product_id = `HT-7000` name = `Copperberry` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg`
        weightmeasure = `0.5` weightunit = `KG` width = `8.1` depth = `13` height = `12.1` dimunit = `cm`
        description = `Our new multifunctional Handheld with phone function in copper` )
      ( product_id = `HT-7010` name = `Silverberry` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg`
        weightmeasure = `0.5` weightunit = `KG` width = `8.1` depth = `13` height = `12.1` dimunit = `cm`
        description = `Our new multifunctional Handheld with phone function in silver` )
      ( product_id = `HT-7020` name = `Goldberry` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg`
        weightmeasure = `0.5` weightunit = `KG` width = `8.1` depth = `13` height = `12.1` dimunit = `cm`
        description = `Our new multifunctional Handheld with phone function in gold` )
      ( product_id = `HT-7030` name = `Platinberry` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg`
        weightmeasure = `0.5` weightunit = `KG` width = `8.1` depth = `13` height = `12.1` dimunit = `cm`
        description = `Our new multifunctional Handheld with phone function in platinum` )
      ( product_id = `HT-8000` name = `ITelO FlexTop I4000` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg`
        weightmeasure = `4` weightunit = `KG` width = `31` depth = `19` height = `3.1` dimunit = `cm`
        description = `Notebook with 2,80 GHz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8` )
      ( product_id = `HT-8001` name = `ITelO FlexTop I6300c` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg`
        weightmeasure = `4.2` weightunit = `KG` width = `32` depth = `20` height = `3.4` dimunit = `cm`
        description = `Notebook with 2,80 GHz dual core, 8 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8` )
      ( product_id = `HT-8002` name = `ITelO FlexTop I9100` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg`
        weightmeasure = `3.5` weightunit = `KG` width = `38` depth = `21` height = `4.1` dimunit = `cm`
        description = `Notebook with 2,80 GHz quad core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8` )
      ( product_id = `HT-8003` name = `ITelO FlexTop I9800` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg`
        weightmeasure = `3.8` weightunit = `KG` width = `48` depth = `31` height = `4.5` dimunit = `cm`
        description = `Notebook with 2,80 GHz quad core, 8 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8` )
      ( product_id = `HT-9991` name = `Smartphone Leather Case` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg`
        weightmeasure = `0.02` weightunit = `KG` width = `48` depth = `31` height = `4.5` dimunit = `cm`
        description = `Button Clasp, Quality Material, 100% Leather, compatible with many smartphone models` )
      ( product_id = `HT-9992` name = `Smartphone Alpha` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg`
        weightmeasure = `0.75` weightunit = `KG` width = `48` depth = `31` height = `4.5` dimunit = `cm`
        description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black` )
      ( product_id = `HT-9993` name = `Mini Tablet` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg`
        weightmeasure = `3.8` weightunit = `KG` width = `48` depth = `31` height = `4.5` dimunit = `cm`
        description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage, 4325 mAh battery (Up to 8 hours of active use)` )
      ( product_id = `HT-9994` name = `Camcorder View` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg`
        weightmeasure = `3.8` weightunit = `KG` width = `48` depth = `31` height = `27` dimunit = `cm`
        description = `1920x1080 Full HD, image stabilization reduces blur, 27x Optical / 32x Extended Zoom, wide angle Lens, 2.7" wide LCD display` )
      ( product_id = `HT-9995` name = `Tablet Pouch` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg`
        weightmeasure = `0.03` weightunit = `KG` width = `25` depth = `40` height = `4.5` dimunit = `cm`
        description = `Stylish tablet pouch, protects from scratches, color: black` )
      ( product_id = `HT-9996` name = `Tablet Pouch` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg`
        weightmeasure = `0.03` weightunit = `KG` width = `25` depth = `40` height = `4.5` dimunit = `cm`
        description = `Stylish tablet pouch, protects from scratches, color: black` )
      ( product_id = `HT-9997` name = `e-Book Reader ReadMe` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg`
        weightmeasure = `3.8` weightunit = `KG` width = `48` depth = `31` height = `4.5` dimunit = `cm`
        description = `6-Inch E Ink Screen, Access To e-book Store, Adjustable Font Styles and Sizes, Stores Up To 1,000 Books` )
      ( product_id = `HT-9998` name = `Smartphone Beta` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg`
        weightmeasure = `0.75` weightunit = `KG` width = `48` depth = `31` height = `4.5` dimunit = `cm`
        description = `5 Megapixel Camera, Wi-Fi 802.11 b/g/n, Bluetooth, GPS Available-GPS support` )
      ( product_id = `HT-9999` name = `Maxi Tablet` productpicurl = `test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg`
        weightmeasure = `3.8` weightunit = `KG` width = `48` depth = `31` height = `4.5` dimunit = `cm`
        description = `10.1-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor` )
      ( product_id = `PF-1000` name = `Flyer` productpicurl = `test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg`
        weightmeasure = `0.01` weightunit = `KG` width = `46` depth = `30` height = `3` dimunit = `cm`
        description = `Flyer for our product palette` ) ).

  ENDMETHOD.

ENDCLASS.
