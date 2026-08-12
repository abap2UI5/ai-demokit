CLASS z2ui5_cl_dmo_app_215 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        productid      TYPE string,
        name           TYPE string,
        suppliername   TYPE string,
        width          TYPE string,
        depth          TYPE string,
        height         TYPE string,
        dimunit        TYPE string,
        weightmeasure  TYPE string,
        weightunit     TYPE string,
        price          TYPE p LENGTH 14 DECIMALS 2,
        currencycode   TYPE string,
        description    TYPE string,
      END OF ty_s_product.
    DATA t_product_collection TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_215 IMPLEMENTATION.

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
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`   v = `sap.ui.layout`
        )->a( n = `height`    v = `100%`

        )->open( n = `FixFlex` ns = `l`
            )->a( n = `minFlexSize` v = `400`

            )->open( n = `fixContent` ns = `l`
                )->open( `ObjectHeader`
                    )->a( n = `responsive`          v = `true`
                    )->a( n = `fullScreenOptimized` v = `true`
                    )->a( n = `binding`             v = |\{{ client->_bind( val = t_product_collection path = abap_true ) }/0\}|
                    )->a( n = `intro`               v = `{DESCRIPTION}`
                    )->a( n = `title`               v = `Long title truncated to 80 chars on all devices and to 50 chars on phone portrait`
                    )->a( n = `number`              v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCYCODE'\}], type:'sap.ui.model.type.Currency', formatOptions:\{showMeasure:false\} \}|
                    )->a( n = `numberUnit`          v = `{CURRENCYCODE}`
                    )->a( n = `numberState`         v = `Success`
                    )->a( n = `backgroundDesign`    v = `Translucent`

                    )->open( `attributes`
                        )->leaf( `ObjectAttribute`
                            )->a( n = `title` v = `Manufacturer`
                            )->a( n = `text`  v = `{SUPPLIERNAME}`

                    )->shut(

                    )->open( `statuses`
                        )->leaf( `ObjectStatus`
                            )->a( n = `title` v = `Approval`
                            )->a( n = `text`  v = `Pending`
                            )->a( n = `state` v = `Warning`

                    )->shut(

                    )->open( `markers`
                        )->leaf( `ObjectMarker`
                            )->a( n = `type` v = `Flagged`
                        )->leaf( `ObjectMarker`
                            )->a( n = `type` v = `Favorite`

                    )->shut(
                )->shut(
            )->shut(

            )->open( n = `flexContent` ns = `l`
                )->open( `Table`
                    )->a( n = `id`               v = `idProductsTable`
                    )->a( n = `items`            v = |\{ path: '{ client->_bind( val = t_product_collection path = abap_true ) }', sorter: \{ path: 'NAME' \} \}|
                    )->a( n = `growing`          v = `true`
                    )->a( n = `growingThreshold` v = `50`

                    )->open( `headerToolbar`
                        )->open( `OverflowToolbar`
                            )->leaf( `Title`
                                )->a( n = `text`  v = `Products`
                                )->a( n = `level` v = `H2`

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
                            )->a( n = `minScreenWidth` v = `Tablet`
                            )->a( n = `demandPopin`    v = `true`
                            )->a( n = `hAlign`         v = `Right`

                            )->leaf( `Text`
                                )->a( n = `text` v = `Dimensions`

                        )->shut(
                        )->open( `Column`
                            )->a( n = `minScreenWidth` v = `Tablet`
                            )->a( n = `demandPopin`    v = `true`
                            )->a( n = `hAlign`         v = `Center`

                            )->leaf( `Text`
                                )->a( n = `text` v = `Weight`

                        )->shut(
                        )->open( `Column`
                            )->a( n = `hAlign` v = `Right`

                            )->leaf( `Text`
                                )->a( n = `text` v = `Price`

                        )->shut(
                    )->shut(

                    )->open( `items`
                        )->open( `ColumnListItem`
                            )->open( `cells`
                                )->leaf( `ObjectIdentifier`
                                    )->a( n = `title` v = `{NAME}`
                                    )->a( n = `text`  v = `{PRODUCTID}`
                                )->leaf( `Text`
                                    )->a( n = `text` v = `{SUPPLIERNAME}`
                                )->leaf( `Text`
                                    )->a( n = `text` v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIMUNIT}`
                                )->leaf( `ObjectNumber`
                                    )->a( n = `number` v = `{WEIGHTMEASURE}`
                                    )->a( n = `unit`   v = `{WEIGHTUNIT}`
                                )->leaf( `ObjectNumber`
                                    )->a( n = `number` v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCYCODE'\}], type:'sap.ui.model.type.Currency', formatOptions:\{showMeasure:false\} \}|
                                    )->a( n = `unit`   v = `{CURRENCYCODE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection (sap/ui/demo/mock/products.json) of the original sample
    t_product_collection = VALUE #(
      ( productid      = `HT-1000`
        name           = `Notebook Basic 15`
        suppliername   = `Very Best Screens`
        width          = `30`
        depth          = `18`
        height         = `3`
        dimunit        = `cm`
        weightmeasure  = `4.2`
        weightunit     = `KG`
        price          = `956`
        currencycode   = `EUR`
        description    = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro` )
      ( productid      = `HT-1001`
        name           = `Notebook Basic 17`
        suppliername   = `Very Best Screens`
        width          = `29`
        depth          = `17`
        height         = `3.1`
        dimunit        = `cm`
        weightmeasure  = `4.5`
        weightunit     = `KG`
        price          = `1249`
        currencycode   = `EUR`
        description    = `Notebook Basic 17 with 2,80 GHz quad core, 17" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro` )
      ( productid      = `HT-1002`
        name           = `Notebook Basic 18`
        suppliername   = `Very Best Screens`
        width          = `28`
        depth          = `19`
        height         = `2.5`
        dimunit        = `cm`
        weightmeasure  = `4.2`
        weightunit     = `KG`
        price          = `1570`
        currencycode   = `EUR`
        description    = `Notebook Basic 18 with 2,80 GHz quad core, 18" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro` )
      ( productid      = `HT-1003`
        name           = `Notebook Basic 19`
        suppliername   = `Smartcards`
        width          = `32`
        depth          = `21`
        height         = `4`
        dimunit        = `cm`
        weightmeasure  = `4.2`
        weightunit     = `KG`
        price          = `1650`
        currencycode   = `EUR`
        description    = `Notebook Basic 19 with 2,80 GHz quad core, 19" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro` )
      ( productid      = `HT-1007`
        name           = `ITelO Vault`
        suppliername   = `Technocom`
        width          = `32`
        depth          = `22`
        height         = `3`
        dimunit        = `cm`
        weightmeasure  = `0.2`
        weightunit     = `KG`
        price          = `299`
        currencycode   = `EUR`
        description    = `Digital Organizer with State-of-the-Art Storage Encryption` )
      ( productid      = `HT-1010`
        name           = `Notebook Professional 15`
        suppliername   = `Very Best Screens`
        width          = `33`
        depth          = `20`
        height         = `3`
        dimunit        = `cm`
        weightmeasure  = `4.3`
        weightunit     = `KG`
        price          = `1999`
        currencycode   = `EUR`
        description    = `Notebook Professional 15 with 2,80 GHz quad core, 15" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro` )
      ( productid      = `HT-1011`
        name           = `Notebook Professional 17`
        suppliername   = `Very Best Screens`
        width          = `33`
        depth          = `23`
        height         = `2`
        dimunit        = `cm`
        weightmeasure  = `4.1`
        weightunit     = `KG`
        price          = `2299`
        currencycode   = `EUR`
        description    = `Notebook Professional 17 with 2,80 GHz quad core, 17" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro` )
      ( productid      = `HT-1020`
        name           = `ITelO Vault Net`
        suppliername   = `Technocom`
        width          = `10`
        depth          = `1.8`
        height         = `17`
        dimunit        = `cm`
        weightmeasure  = `0.16`
        weightunit     = `KG`
        price          = `459`
        currencycode   = `EUR`
        description    = `Digital Organizer with State-of-the-Art Encryption for Storage and Network Communications` )
      ( productid      = `HT-1021`
        name           = `ITelO Vault SAT`
        suppliername   = `Technocom`
        width          = `11`
        depth          = `1.7`
        height         = `18`
        dimunit        = `cm`
        weightmeasure  = `0.18`
        weightunit     = `KG`
        price          = `149`
        currencycode   = `EUR`
        description    = `Digital Organizer with State-of-the-Art Encryption for Storage and Secure Stellite Link` )
      ( productid      = `HT-1022`
        name           = `Comfort Easy`
        suppliername   = `Technocom`
        width          = `84`
        depth          = `1.5`
        height         = `14`
        dimunit        = `cm`
        weightmeasure  = `0.2`
        weightunit     = `KG`
        price          = `1679`
        currencycode   = `EUR`
        description    = `32 GB Digital Assistant with high-resolution color screen` )
      ( productid      = `HT-1023`
        name           = `Comfort Senior`
        suppliername   = `Technocom`
        width          = `80`
        depth          = `1.6`
        height         = `13`
        dimunit        = `cm`
        weightmeasure  = `0.8`
        weightunit     = `KG`
        price          = `512`
        currencycode   = `EUR`
        description    = `64 GB Digital Assistant with high-resolution color screen and synthesized voice output` )
      ( productid      = `HT-1030`
        name           = `Ergo Screen E-I`
        suppliername   = `Very Best Screens`
        width          = `37`
        depth          = `12`
        height         = `36`
        dimunit        = `cm`
        weightmeasure  = `21`
        weightunit     = `KG`
        price          = `230`
        currencycode   = `EUR`
        description    = `Optimum Hi-Resolution max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm` )
      ( productid      = `HT-1031`
        name           = `Ergo Screen E-II`
        suppliername   = `Very Best Screens`
        width          = `40.8`
        depth          = `19`
        height         = `43`
        dimunit        = `cm`
        weightmeasure  = `21`
        weightunit     = `KG`
        price          = `285`
        currencycode   = `EUR`
        description    = `Optimum Hi-Resolution max. 1920 x 1200 @ 85Hz, Dot Pitch: 0.26mm` )
      ( productid      = `HT-1032`
        name           = `Ergo Screen E-III`
        suppliername   = `Very Best Screens`
        width          = `40.8`
        depth          = `19`
        height         = `43`
        dimunit        = `cm`
        weightmeasure  = `21`
        weightunit     = `KG`
        price          = `345`
        currencycode   = `EUR`
        description    = `Optimum Hi-Resolution max. 2560 x 1440 @ 85Hz, Dot Pitch: 0.25mm` )
      ( productid      = `HT-1035`
        name           = `Flat Basic`
        suppliername   = `Very Best Screens`
        width          = `39`
        depth          = `20`
        height         = `41`
        dimunit        = `cm`
        weightmeasure  = `14`
        weightunit     = `KG`
        price          = `399`
        currencycode   = `EUR`
        description    = `Optimum Hi-Resolution max. 1600 x 1200 @ 85Hz, Dot Pitch: 0.24mm` )
      ( productid      = `HT-1036`
        name           = `Flat Future`
        suppliername   = `Very Best Screens`
        width          = `45`
        depth          = `26`
        height         = `46`
        dimunit        = `cm`
        weightmeasure  = `15`
        weightunit     = `KG`
        price          = `430`
        currencycode   = `EUR`
        description    = `Optimum Hi-Resolution max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.26mm` )
      ( productid      = `HT-1037`
        name           = `Flat XL`
        suppliername   = `Very Best Screens`
        width          = `54.5`
        depth          = `22.1`
        height         = `39.1`
        dimunit        = `cm`
        weightmeasure  = `17`
        weightunit     = `KG`
        price          = `1230`
        currencycode   = `EUR`
        description    = `Optimum Hi-Resolution max. 2016 x 1512 @ 85Hz, Dot Pitch: 0.24mm` )
      ( productid      = `HT-1040`
        name           = `Laser Professional Eco`
        suppliername   = `Alpha Printers`
        width          = `51`
        depth          = `46`
        height         = `30`
        dimunit        = `cm`
        weightmeasure  = `32`
        weightunit     = `KG`
        price          = `830`
        currencycode   = `EUR`
        description    = `Print 2400 dpi image quality color documents at speeds of up to 32 ppm (color) or 36 ppm (monochrome), letter/A4. Powerful 500 MHz processor, 512MB of memory` )
      ( productid      = `HT-1041`
        name           = `Laser Basic`
        suppliername   = `Alpha Printers`
        width          = `48`
        depth          = `42`
        height         = `26`
        dimunit        = `cm`
        weightmeasure  = `23`
        weightunit     = `KG`
        price          = `490`
        currencycode   = `EUR`
        description    = `Up to 22 ppm color or 24 ppm monochrome A4/letter, powerful 500 MHz processor and 128MB of memory` )
      ( productid      = `HT-1042`
        name           = `Laser Allround`
        suppliername   = `Alpha Printers`
        width          = `53`
        depth          = `50`
        height         = `65`
        dimunit        = `cm`
        weightmeasure  = `17`
        weightunit     = `KG`
        price          = `349`
        currencycode   = `EUR`
        description    = `Print up to 25 ppm letter and 24 ppm A4 color or monochrome, with Available first-page-out-time of less than 13 seconds for monochrome and less than 15 seconds for color` )
      ( productid      = `HT-1050`
        name           = `Ultra Jet Super Color`
        suppliername   = `Alpha Printers`
        width          = `41`
        depth          = `41`
        height         = `28`
        dimunit        = `cm`
        weightmeasure  = `3`
        weightunit     = `KG`
        price          = `139`
        currencycode   = `EUR`
        description    = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB, Ethernet` )
      ( productid      = `HT-1051`
        name           = `Ultra Jet Mobile`
        suppliername   = `Printer for All`
        width          = `46`
        depth          = `32`
        height         = `25`
        dimunit        = `cm`
        weightmeasure  = `1.9`
        weightunit     = `KG`
        price          = `99`
        currencycode   = `EUR`
        description    = `1000 dpi x 1000 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB - excellent dimensions for the small office` )
      ( productid      = `HT-1052`
        name           = `Ultra Jet Super Highspeed`
        suppliername   = `Printer for All`
        width          = `41`
        depth          = `41`
        height         = `28`
        dimunit        = `cm`
        weightmeasure  = `18`
        weightunit     = `KG`
        price          = `170`
        currencycode   = `EUR`
        description    = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB2.0, Ethernet` )
      ( productid      = `HT-1055`
        name           = `Multi Print`
        suppliername   = `Printer for All`
        width          = `55`
        depth          = `45`
        height         = `29`
        dimunit        = `cm`
        weightmeasure  = `6.3`
        weightunit     = `KG`
        price          = `99`
        currencycode   = `EUR`
        description    = `1000 dpi x 1000 dpi - up to 16 ppm (mono) / up to 15 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 1200dpi x 2400dpi)` )
      ( productid      = `HT-1056`
        name           = `Multi Color`
        suppliername   = `Printer for All`
        width          = `51`
        depth          = `41.3`
        height         = `22`
        dimunit        = `cm`
        weightmeasure  = `4.3`
        weightunit     = `KG`
        price          = `119`
        currencycode   = `EUR`
        description    = `1200 dpi x 1200 dpi - up to 25 ppm (mono) / up to 24 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 2400dpi x 4800dpi, high resolution)` )
      ( productid      = `HT-1060`
        name           = `Cordless Mouse`
        suppliername   = `Oxynum`
        width          = `6`
        depth          = `14.5`
        height         = `3.5`
        dimunit        = `cm`
        weightmeasure  = `0.09`
        weightunit     = `KG`
        price          = `9`
        currencycode   = `EUR`
        description    = `Cordless Optical USB Mice, Laptop, Color: Black, Plug&Play` )
      ( productid      = `HT-1061`
        name           = `Speed Mouse`
        suppliername   = `Oxynum`
        width          = `7`
        depth          = `15`
        height         = `3.1`
        dimunit        = `cm`
        weightmeasure  = `0.09`
        weightunit     = `KG`
        price          = `7`
        currencycode   = `EUR`
        description    = `Optical USB, PS/2 Mouse, Color: Blue, 3-button-functionality (incl. Scroll wheel)` )
      ( productid      = `HT-1062`
        name           = `Track Mouse`
        suppliername   = `Oxynum`
        width          = `3`
        depth          = `7`
        height         = `4`
        dimunit        = `cm`
        weightmeasure  = `0.03`
        weightunit     = `KG`
        price          = `11`
        currencycode   = `EUR`
        description    = `Optical USB Mouse, Color: Red, 5-button-functionality(incl. Scroll wheel), Plug&Play` )
      ( productid      = `HT-1063`
        name           = `Ergonomic Keyboard`
        suppliername   = `Oxynum`
        width          = `50`
        depth          = `21`
        height         = `3.5`
        dimunit        = `cm`
        weightmeasure  = `2.1`
        weightunit     = `KG`
        price          = `14`
        currencycode   = `EUR`
        description    = `Ergonomic USB Keyboard for Desktop, Plug&Play` )
      ( productid      = `HT-1064`
        name           = `Internet Keyboard`
        suppliername   = `Oxynum`
        width          = `52`
        depth          = `25`
        height         = `3`
        dimunit        = `cm`
        weightmeasure  = `1.8`
        weightunit     = `KG`
        price          = `16`
        currencycode   = `EUR`
        description    = `Corded Keyboard with special keys for Internet Usability, USB` )
      ( productid      = `HT-1065`
        name           = `Media Keyboard`
        suppliername   = `Oxynum`
        width          = `51.4`
        depth          = `23`
        height         = `4`
        dimunit        = `cm`
        weightmeasure  = `2.3`
        weightunit     = `KG`
        price          = `26`
        currencycode   = `EUR`
        description    = `Corded Ergonomic Keyboard with special keys for Media Usability, USB` )
      ( productid      = `HT-1066`
        name           = `Mousepad`
        suppliername   = `Oxynum`
        width          = `15`
        depth          = `6`
        height         = `0.2`
        dimunit        = `cm`
        weightmeasure  = `80`
        weightunit     = `G`
        price          = `6.99`
        currencycode   = `EUR`
        description    = `Nice mouse pad with ITelO Logo` )
      ( productid      = `HT-1067`
        name           = `Ergo Mousepad`
        suppliername   = `Oxynum`
        width          = `15`
        depth          = `6`
        height         = `0.2`
        dimunit        = `cm`
        weightmeasure  = `80`
        weightunit     = `G`
        price          = `8.99`
        currencycode   = `EUR`
        description    = `Ergonomic mouse pad with ITelO Logo` )
      ( productid      = `HT-1068`
        name           = `Designer Mousepad`
        suppliername   = `Fasttech`
        width          = `24`
        depth          = `24`
        height         = `0.6`
        dimunit        = `cm`
        weightmeasure  = `90`
        weightunit     = `G`
        price          = `12.99`
        currencycode   = `EUR`
        description    = `ITelO Mousepad Special Edition` )
      ( productid      = `HT-1069`
        name           = `Universal card reader`
        suppliername   = `Fasttech`
        width          = `6`
        depth          = `6`
        height         = `3`
        dimunit        = `cm`
        weightmeasure  = `45`
        weightunit     = `G`
        price          = `14`
        currencycode   = `EUR`
        description    = `Universal card reader` )
      ( productid      = `HT-1070`
        name           = `Proctra X`
        suppliername   = `Ultrasonic United`
        width          = `22`
        depth          = `35`
        height         = `17`
        dimunit        = `cm`
        weightmeasure  = `0.255`
        weightunit     = `KG`
        price          = `70.9`
        currencycode   = `EUR`
        description    = `Proctra X: PCI-E GDDR5 3072MB` )
      ( productid      = `HT-1071`
        name           = `Gladiator MX`
        suppliername   = `Ultrasonic United`
        width          = `22`
        depth          = `35`
        height         = `17`
        dimunit        = `cm`
        weightmeasure  = `0.3`
        weightunit     = `KG`
        price          = `81.7`
        currencycode   = `EUR`
        description    = `Gladiator XLN: PCI-E GDDR5 3072MB DVI Out, TV Out low-noise` )
      ( productid      = `HT-1072`
        name           = `Hurricane GX`
        suppliername   = `Ultrasonic United`
        width          = `22`
        depth          = `35`
        height         = `17`
        dimunit        = `cm`
        weightmeasure  = `0.4`
        weightunit     = `KG`
        price          = `101.2`
        currencycode   = `EUR`
        description    = `Hurricane GX: PCI-E 691 GFLOPS game-optimized` )
      ( productid      = `HT-1073`
        name           = `Hurricane GX/LN`
        suppliername   = `Smartcards`
        width          = `22`
        depth          = `35`
        height         = `17`
        dimunit        = `cm`
        weightmeasure  = `0.4`
        weightunit     = `KG`
        price          = `139.99`
        currencycode   = `EUR`
        description    = `Hurricane GX/LN: PCI-E 691 GFLOPS game-optimized, low-noise.` )
      ( productid      = `HT-1080`
        name           = `Photo Scan`
        suppliername   = `Printer for All`
        width          = `34`
        depth          = `48`
        height         = `5`
        dimunit        = `cm`
        weightmeasure  = `2.3`
        weightunit     = `KG`
        price          = `129`
        currencycode   = `EUR`
        description    = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - Hi-Speed USB - Bluetooth` )
      ( productid      = `HT-1081`
        name           = `Power Scan`
        suppliername   = `Printer for All`
        width          = `31`
        depth          = `43`
        height         = `7`
        dimunit        = `cm`
        weightmeasure  = `2.4`
        weightunit     = `KG`
        price          = `89`
        currencycode   = `EUR`
        description    = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - SCSI for backward compatibility` )
      ( productid      = `HT-1082`
        name           = `Jet Scan Professional`
        suppliername   = `Printer for All`
        width          = `33`
        depth          = `41`
        height         = `12`
        dimunit        = `cm`
        weightmeasure  = `3.2`
        weightunit     = `KG`
        price          = `169`
        currencycode   = `EUR`
        description    = `Flatbed scanner - Letter - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module` )
      ( productid      = `HT-1083`
        name           = `Jet Scan Professional`
        suppliername   = `Printer for All`
        width          = `35`
        depth          = `40`
        height         = `10`
        dimunit        = `cm`
        weightmeasure  = `3.2`
        weightunit     = `KG`
        price          = `189`
        currencycode   = `EUR`
        description    = `Flatbed scanner - A4 - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module` )
      ( productid      = `HT-1085`
        name           = `Copymaster`
        suppliername   = `Alpha Printers`
        width          = `45`
        depth          = `42`
        height         = `22`
        dimunit        = `cm`
        weightmeasure  = `23.2`
        weightunit     = `KG`
        price          = `1499`
        currencycode   = `EUR`
        description    = `Copymaster` )
      ( productid      = `HT-1090`
        name           = `Surround Sound`
        suppliername   = `Speaker Experts`
        width          = `12`
        depth          = `10`
        height         = `16`
        dimunit        = `cm`
        weightmeasure  = `3`
        weightunit     = `KG`
        price          = `39`
        currencycode   = `EUR`
        description    = `PC multimedia speakers - 5 Watt (Total)` )
      ( productid      = `HT-1091`
        name           = `Blaster Extreme`
        suppliername   = `Speaker Experts`
        width          = `13`
        depth          = `11`
        height         = `17.5`
        dimunit        = `cm`
        weightmeasure  = `1.4`
        weightunit     = `KG`
        price          = `26`
        currencycode   = `EUR`
        description    = `PC multimedia speakers - 10 Watt (Total) - 2-way` )
      ( productid      = `HT-1092`
        name           = `Sound Booster`
        suppliername   = `Speaker Experts`
        width          = `12.4`
        depth          = `10.4`
        height         = `18.1`
        dimunit        = `cm`
        weightmeasure  = `2.1`
        weightunit     = `KG`
        price          = `45`
        currencycode   = `EUR`
        description    = `PC multimedia speakers - optimized for Blutooth/A2DP` )
      ( productid      = `HT-1095`
        name           = `Lovely Sound 5.1 Wireless`
        suppliername   = `Fasttech`
        width          = `24`
        depth          = `19`
        height         = `23`
        dimunit        = `cm`
        weightmeasure  = `80`
        weightunit     = `G`
        price          = `49`
        currencycode   = `EUR`
        description    = `5.1 Headset, 40 Hz-20 kHz, Wireless` )
      ( productid      = `HT-1096`
        name           = `Lovely Sound 5.1`
        suppliername   = `Fasttech`
        width          = `25`
        depth          = `17`
        height         = `19`
        dimunit        = `cm`
        weightmeasure  = `130`
        weightunit     = `G`
        price          = `39`
        currencycode   = `EUR`
        description    = `5.1 Headset, 40 Hz-20 kHz, 3m cable` )
      ( productid      = `HT-1097`
        name           = `Lovely Sound Stereo`
        suppliername   = `Fasttech`
        width          = `21.3`
        depth          = `2.4`
        height         = `19.7`
        dimunit        = `cm`
        weightmeasure  = `60`
        weightunit     = `G`
        price          = `29`
        currencycode   = `EUR`
        description    = `5.1 Headset, 40 Hz-20 kHz, 1m cable` )
      ( productid      = `HT-1100`
        name           = `Smart Office`
        suppliername   = `Technocom`
        width          = `15`
        depth          = `6.5`
        height         = `2.1`
        dimunit        = `cm`
        weightmeasure  = `1.2`
        weightunit     = `KG`
        price          = `89.9`
        currencycode   = `EUR`
        description    = `Complete package, 1 User, Office Applications (word processing, spreadsheet, presentations)` )
      ( productid      = `HT-1101`
        name           = `Smart Design`
        suppliername   = `Technocom`
        width          = `14`
        depth          = `6.7`
        height         = `24`
        dimunit        = `cm`
        weightmeasure  = `0.8`
        weightunit     = `KG`
        price          = `79.9`
        currencycode   = `EUR`
        description    = `Complete package, 1 User, Image editing, processing` )
      ( productid      = `HT-1102`
        name           = `Smart Network`
        suppliername   = `Technocom`
        width          = `16`
        depth          = `6`
        height         = `27`
        dimunit        = `cm`
        weightmeasure  = `0.8`
        weightunit     = `KG`
        price          = `69`
        currencycode   = `EUR`
        description    = `Complete package, 1 User, Network Software Utilities, Useful Applications and Documentation` )
      ( productid      = `HT-1103`
        name           = `Smart Multimedia`
        suppliername   = `Technocom`
        width          = `11`
        depth          = `3.4`
        height         = `22`
        dimunit        = `cm`
        weightmeasure  = `0.8`
        weightunit     = `KG`
        price          = `77`
        currencycode   = `EUR`
        description    = `Complete package, 1 User, different Multimedia applications, playing music, watching DVDs, only with this Smart package` )
      ( productid      = `HT-1104`
        name           = `Smart Games`
        suppliername   = `Technocom`
        width          = `10`
        depth          = `3`
        height         = `30`
        dimunit        = `cm`
        weightmeasure  = `1.1`
        weightunit     = `KG`
        price          = `55`
        currencycode   = `EUR`
        description    = `Complete package, 1 User, various games for amusement, logic, action, jump&run` )
      ( productid      = `HT-1105`
        name           = `Smart Internet Antivirus`
        suppliername   = `Brainsoft`
        width          = `16`
        depth          = `4`
        height         = `21`
        dimunit        = `cm`
        weightmeasure  = `0.7`
        weightunit     = `KG`
        price          = `29`
        currencycode   = `EUR`
        description    = `Complete package, 1 User, highly recommended for internet users as anti-virus protection` )
      ( productid      = `HT-1106`
        name           = `Smart Firewall`
        suppliername   = `Brainsoft`
        width          = `17.9`
        depth          = `4.2`
        height         = `23.1`
        dimunit        = `cm`
        weightmeasure  = `0.9`
        weightunit     = `KG`
        price          = `34`
        currencycode   = `EUR`
        description    = `Complete package, 1 User, recommended for internet users, protect your PC against cyber-crime` )
      ( productid      = `HT-1107`
        name           = `Smart Money`
        suppliername   = `Brainsoft`
        width          = `12`
        depth          = `1.5`
        height         = `19`
        dimunit        = `cm`
        weightmeasure  = `0.5`
        weightunit     = `KG`
        price          = `29.9`
        currencycode   = `EUR`
        description    = `Complete package, 1 User, bring your money in your mind, see what you have and what you want` )
      ( productid      = `HT-1110`
        name           = `PC Lock`
        suppliername   = `Red Point Stores`
        width          = `20`
        depth          = `8`
        height         = `4.3`
        dimunit        = `cm`
        weightmeasure  = `0.03`
        weightunit     = `KG`
        price          = `8.9`
        currencycode   = `EUR`
        description    = `Robust 3m anti-burglary protection for your laptop computer` )
      ( productid      = `HT-1111`
        name           = `Notebook Lock`
        suppliername   = `Red Point Stores`
        width          = `31`
        depth          = `9`
        height         = `7`
        dimunit        = `cm`
        weightmeasure  = `0.02`
        weightunit     = `KG`
        price          = `6.9`
        currencycode   = `EUR`
        description    = `Robust 1m anti-burglary protection for your desktop computer` )
      ( productid      = `HT-1112`
        name           = `Web cam reality`
        suppliername   = `Red Point Stores`
        width          = `9`
        depth          = `8.2`
        height         = `1.3`
        dimunit        = `cm`
        weightmeasure  = `0.075`
        weightunit     = `KG`
        price          = `39`
        currencycode   = `EUR`
        description    = `Color webcam, color, High-Speed USB` )
      ( productid      = `HT-1113`
        name           = `Screen clean`
        suppliername   = `Red Point Stores`
        width          = `2`
        depth          = `2`
        height         = `0.1`
        dimunit        = `cm`
        weightmeasure  = `0.05`
        weightunit     = `KG`
        price          = `2.3`
        currencycode   = `EUR`
        description    = `10 separately packed screen wipes` )
      ( productid      = `HT-1114`
        name           = `Fabric bag professional`
        suppliername   = `Red Point Stores`
        width          = `42`
        depth          = `32`
        height         = `7`
        dimunit        = `cm`
        weightmeasure  = `1.8`
        weightunit     = `KG`
        price          = `31`
        currencycode   = `EUR`
        description    = `Notebook bag, plenty of room for stationery and writing materials` )
      ( productid      = `HT-1115`
        name           = `Wireless DSL Router`
        suppliername   = `Red Point Stores`
        width          = `19.3`
        depth          = `18`
        height         = `5`
        dimunit        = `cm`
        weightmeasure  = `0.45`
        weightunit     = `KG`
        price          = `49`
        currencycode   = `EUR`
        description    = `Wireless DSL Router (available in blue, black and silver)` )
      ( productid      = `HT-1116`
        name           = `Wireless DSL Router / Repeater`
        suppliername   = `Red Point Stores`
        width          = `19.3`
        depth          = `18`
        height         = `5`
        dimunit        = `cm`
        weightmeasure  = `0.45`
        weightunit     = `KG`
        price          = `59`
        currencycode   = `EUR`
        description    = `Wireless DSL Router / Repeater (available in blue, black and silver)` )
      ( productid      = `HT-1117`
        name           = `Wireless DSL Router / Repeater and Print Server`
        suppliername   = `Technocom`
        width          = `19.3`
        depth          = `18`
        height         = `5`
        dimunit        = `cm`
        weightmeasure  = `0.45`
        weightunit     = `KG`
        price          = `69`
        currencycode   = `EUR`
        description    = `Wireless DSL Router / Repeater and Print Server (available in blue, black and silver)` )
      ( productid      = `HT-1118`
        name           = `USB Stick`
        suppliername   = `Technocom`
        width          = `1.5`
        depth          = `8.7`
        height         = `1.2`
        dimunit        = `cm`
        weightmeasure  = `0.015`
        weightunit     = `KG`
        price          = `35`
        currencycode   = `EUR`
        description    = `USB 2.0 High-Speed 64 GB` )
      ( productid      = `HT-1119`
        name           = `Travel Adapter`
        suppliername   = `Titanium`
        width          = `2`
        depth          = `3.1`
        height         = `3.9`
        dimunit        = `cm`
        weightmeasure  = `88`
        weightunit     = `G`
        price          = `79`
        currencycode   = `EUR`
        description    = `Universal Travel Adapter` )
      ( productid      = `HT-1120`
        name           = `Cordless Bluetooth Keyboard, english international`
        suppliername   = `Technocom`
        width          = `51.4`
        depth          = `23`
        height         = `4`
        dimunit        = `cm`
        weightmeasure  = `1`
        weightunit     = `KG`
        price          = `29`
        currencycode   = `EUR`
        description    = `Cordless Bluetooth Keyboard with English keys` )
      ( productid      = `HT-1137`
        name           = `Flat XXL`
        suppliername   = `Technocom`
        width          = `54`
        depth          = `22`
        height         = `38`
        dimunit        = `cm`
        weightmeasure  = `18`
        weightunit     = `KG`
        price          = `1430`
        currencycode   = `EUR`
        description    = `Optimum Hi-Resolution max. 2048 × 1536 @ 85Hz, Dot Pitch: 0.24mm` )
      ( productid      = `HT-1138`
        name           = `Pocket Mouse`
        suppliername   = `Technocom`
        width          = `0.3`
        depth          = `0.5`
        height         = `1`
        dimunit        = `cm`
        weightmeasure  = `0.02`
        weightunit     = `KG`
        price          = `23`
        currencycode   = `EUR`
        description    = `Portable pocket Mouse with retracting cord` )
      ( productid      = `HT-1210`
        name           = `PC Power Station`
        suppliername   = `Technocom`
        width          = `28`
        depth          = `31`
        height         = `43`
        dimunit        = `cm`
        weightmeasure  = `2.3`
        weightunit     = `KG`
        price          = `2399`
        currencycode   = `EUR`
        description    = `PC Power Station with 3,4 Ghz quad-core, 32 GB DDR3 SDRAM, feels like Available PC, Windows 8 Pro` )
      ( productid      = `HT-1251`
        name           = `Astro Laptop 1516`
        suppliername   = `Ultrasonic United`
        width          = `30`
        depth          = `18`
        height         = `3`
        dimunit        = `cm`
        weightmeasure  = `4.2`
        weightunit     = `KG`
        price          = `989`
        currencycode   = `EUR`
        description    = `Flexible Laptop with 2,5 GHz Quad Core, 15" HD TN, 16 GB DDR SDRAM, 256 GB SSD, Windows 10 Pro` )
      ( productid      = `HT-1252`
        name           = `Astro Phone 6`
        suppliername   = `Ultrasonic United`
        width          = `8`
        depth          = `6`
        height         = `1.5`
        dimunit        = `cm`
        weightmeasure  = `0.75`
        weightunit     = `KG`
        price          = `649`
        currencycode   = `EUR`
        description    = `6 inch 1280x800 HD display (216 ppi), Quad-core processor, 8 GB internal storage (actual formatted capacity will be less), 3050 mAh battery (Up to 8 hours of active use), grey or black` )
      ( productid      = `HT-1253`
        name           = `Benda Laptop 1408`
        suppliername   = `Ultrasonic United`
        width          = `30`
        depth          = `18`
        height         = `3`
        dimunit        = `cm`
        weightmeasure  = `4.2`
        weightunit     = `KG`
        price          = `976`
        currencycode   = `EUR`
        description    = `Flexible Laptop with 2,5 GHz Dual Core, 14" HD+ TN, 8 GB DDR SDRAM, 324 GB SSD, Windows 10 Pro` )
      ( productid      = `HT-1254`
        name           = `Bending Screen 21HD`
        suppliername   = `Ultrasonic United`
        width          = `37`
        depth          = `12`
        height         = `36`
        dimunit        = `cm`
        weightmeasure  = `15`
        weightunit     = `KG`
        price          = `250`
        currencycode   = `EUR`
        description    = `Optimum Hi-Resolution Widescreen max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub` )
      ( productid      = `HT-1255`
        name           = `Broad Screen 22HD`
        suppliername   = `Ultrasonic United`
        width          = `39`
        depth          = `12`
        height         = `38`
        dimunit        = `cm`
        weightmeasure  = `16`
        weightunit     = `KG`
        price          = `270`
        currencycode   = `EUR`
        description    = `Optimum Hi-Resolution Widescreen max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub` )
      ( productid      = `HT-1256`
        name           = `Cerdik Phone 7`
        suppliername   = `Ultrasonic United`
        width          = `9`
        depth          = `15`
        height         = `1.5`
        dimunit        = `cm`
        weightmeasure  = `0.75`
        weightunit     = `KG`
        price          = `549`
        currencycode   = `EUR`
        description    = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black` )
      ( productid      = `HT-1257`
        name           = `Cepat Tablet 10.5`
        suppliername   = `Ultrasonic United`
        width          = `48`
        depth          = `31`
        height         = `4.5`
        dimunit        = `cm`
        weightmeasure  = `2.8`
        weightunit     = `KG`
        price          = `549`
        currencycode   = `EUR`
        description    = `10.5-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor` )
      ( productid      = `HT-1258`
        name           = `Cepat Tablet 8`
        suppliername   = `Ultrasonic United`
        width          = `38`
        depth          = `21`
        height         = `3.5`
        dimunit        = `cm`
        weightmeasure  = `2.5`
        weightunit     = `KG`
        price          = `529`
        currencycode   = `EUR`
        description    = `8-inch Multitouch HD Screen (2000 x 1500) 32GB Internal Memory, Wireless N Wi-Fi, Bluetooth, GPS Enabled, 1.5 GHz Quad-Core Processor` )
      ( productid      = `HT-1500`
        name           = `Server Basic`
        suppliername   = `Technocom`
        width          = `34`
        depth          = `35`
        height         = `23`
        dimunit        = `cm`
        weightmeasure  = `18`
        weightunit     = `KG`
        price          = `5000`
        currencycode   = `EUR`
        description    = `Dual socket, quad-core processing server with 1333 MHz Front Side Bus with 10Gb connectivity` )
      ( productid      = `HT-1501`
        name           = `Server Professional`
        suppliername   = `Technocom`
        width          = `29`
        depth          = `30`
        height         = `27`
        dimunit        = `cm`
        weightmeasure  = `25`
        weightunit     = `KG`
        price          = `15000`
        currencycode   = `EUR`
        description    = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 10Gb connectivity` )
      ( productid      = `HT-1502`
        name           = `Server Power Pro`
        suppliername   = `Technocom`
        width          = `22`
        depth          = `27.3`
        height         = `37`
        dimunit        = `cm`
        weightmeasure  = `35`
        weightunit     = `KG`
        price          = `25000`
        currencycode   = `EUR`
        description    = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 100Gb connectivity` )
      ( productid      = `HT-1600`
        name           = `Family PC Basic`
        suppliername   = `Titanium`
        width          = `21.4`
        depth          = `29`
        height         = `38`
        dimunit        = `cm`
        weightmeasure  = `4.8`
        weightunit     = `KG`
        price          = `600`
        currencycode   = `EUR`
        description    = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Graphic Card: Proctra X, Windows 8` )
      ( productid      = `HT-1601`
        name           = `Family PC Pro`
        suppliername   = `Titanium`
        width          = `25`
        depth          = `31.7`
        height         = `40.2`
        dimunit        = `cm`
        weightmeasure  = `5.3`
        weightunit     = `KG`
        price          = `900`
        currencycode   = `EUR`
        description    = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8` )
      ( productid      = `HT-1602`
        name           = `Gaming Monster`
        suppliername   = `Titanium`
        width          = `26.5`
        depth          = `34`
        height         = `47`
        dimunit        = `cm`
        weightmeasure  = `5.9`
        weightunit     = `KG`
        price          = `1200`
        currencycode   = `EUR`
        description    = `3,4 Ghz quad core, 8 GB DDR3 SDRAM, 2000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8` )
      ( productid      = `HT-1603`
        name           = `Gaming Monster Pro`
        suppliername   = `Titanium`
        width          = `27`
        depth          = `28`
        height         = `42`
        dimunit        = `cm`
        weightmeasure  = `6.8`
        weightunit     = `KG`
        price          = `1700`
        currencycode   = `EUR`
        description    = `3,4 Ghz quad core, 16 GB DDR3 SDRAM, 4000 GB Hard Disc, Graphic Card: Hurricane GX, Windows 8` )
      ( productid      = `HT-2000`
        name           = `7" Widescreen Portable DVD Player w MP3`
        suppliername   = `Titanium`
        width          = `21.4`
        depth          = `19`
        height         = `27.6`
        dimunit        = `cm`
        weightmeasure  = `0.79`
        weightunit     = `KG`
        price          = `249.99`
        currencycode   = `EUR`
        description    = `7" LCD Screen, storage battery holds up to 6 hours!` )
      ( productid      = `HT-2001`
        name           = `10" Portable DVD player`
        suppliername   = `Titanium`
        width          = `24`
        depth          = `19.5`
        height         = `29`
        dimunit        = `cm`
        weightmeasure  = `0.84`
        weightunit     = `KG`
        price          = `449.99`
        currencycode   = `EUR`
        description    = `10" LCD Screen, storage battery holds up to 8 hours` )
      ( productid      = `HT-2002`
        name           = `Portable DVD Player with 9" LCD Monitor`
        suppliername   = `Technocom`
        width          = `21`
        depth          = `16.5`
        height         = `14`
        dimunit        = `cm`
        weightmeasure  = `0.72`
        weightunit     = `KG`
        price          = `853.99`
        currencycode   = `EUR`
        description    = `9" LCD Screen, storage holds up to 8 hours, 2 speakers included` )
      ( productid      = `HT-2025`
        name           = `CD/DVD case: 264 sleeves`
        suppliername   = `Titanium`
        width          = `13`
        depth          = `13`
        height         = `20`
        dimunit        = `cm`
        weightmeasure  = `0.65`
        weightunit     = `KG`
        price          = `44.99`
        currencycode   = `EUR`
        description    = `Organizer and protective case for 264 CDs and DVDs` )
      ( productid      = `HT-2026`
        name           = `Audio/Video Cable Kit - 4m`
        suppliername   = `Titanium`
        width          = `21`
        depth          = `10.2`
        height         = `13`
        dimunit        = `cm`
        weightmeasure  = `0.2`
        weightunit     = `KG`
        price          = `29.99`
        currencycode   = `EUR`
        description    = `Quality cables for notebooks and projectors` )
      ( productid      = `HT-2027`
        name           = `Removable CD/DVD Laser Labels`
        suppliername   = `Titanium`
        width          = `5.5`
        depth          = `2`
        height         = `2`
        dimunit        = `cm`
        weightmeasure  = `0.15`
        weightunit     = `KG`
        price          = `8.99`
        currencycode   = `EUR`
        description    = `Removable jewel case labels, zero residues (100)` )
      ( productid      = `HT-6100`
        name           = `Beam Breaker B-1`
        suppliername   = `Titanium`
        width          = `30.4`
        depth          = `23.1`
        height         = `23`
        dimunit        = `cm`
        weightmeasure  = `1.7`
        weightunit     = `KG`
        price          = `469`
        currencycode   = `EUR`
        description    = `720p, DLP Projector max. 8,45 Meter, 2D` )
      ( productid      = `HT-6101`
        name           = `Beam Breaker B-2`
        suppliername   = `Technocom`
        width          = `30.4`
        depth          = `23.1`
        height         = `23`
        dimunit        = `cm`
        weightmeasure  = `2`
        weightunit     = `KG`
        price          = `679`
        currencycode   = `EUR`
        description    = `1080p, DLP max.9,34 Meter, 2D-ready` )
      ( productid      = `HT-6102`
        name           = `Beam Breaker B-3`
        suppliername   = `Technocom`
        width          = `30.4`
        depth          = `23.1`
        height         = `23`
        dimunit        = `cm`
        weightmeasure  = `2.5`
        weightunit     = `KG`
        price          = `889`
        currencycode   = `EUR`
        description    = `1080p, DLP max. 12,3 Meter, 3D-ready` )
      ( productid      = `HT-6110`
        name           = `Play Movie`
        suppliername   = `Fasttech`
        width          = `37`
        depth          = `24`
        height         = `6`
        dimunit        = `cm`
        weightmeasure  = `2.4`
        weightunit     = `KG`
        price          = `130`
        currencycode   = `EUR`
        description    = `CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid` )
      ( productid      = `HT-6111`
        name           = `Record Movie`
        suppliername   = `Fasttech`
        width          = `38`
        depth          = `26`
        height         = `6.2`
        dimunit        = `cm`
        weightmeasure  = `3.1`
        weightunit     = `KG`
        price          = `288`
        currencycode   = `EUR`
        description    = `160 GB HDD, CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid` )
      ( productid      = `HT-6120`
        name           = `ITelo MusicStick`
        suppliername   = `Fasttech`
        width          = `1.5`
        depth          = `6`
        height         = `1`
        dimunit        = `cm`
        weightmeasure  = `134`
        weightunit     = `G`
        price          = `45`
        currencycode   = `EUR`
        description    = `64 GB USB Music-on-Available-Stick` )
      ( productid      = `HT-6121`
        name           = `ITelo Jog-Mate`
        suppliername   = `Fasttech`
        width          = `5.1`
        depth          = `8`
        height         = `9.2`
        dimunit        = `cm`
        weightmeasure  = `134`
        weightunit     = `G`
        price          = `63`
        currencycode   = `EUR`
        description    = `ITelo Jog-Mate 64 GB HDD and Color Display, can play movies` )
      ( productid      = `HT-6122`
        name           = `Power Pro Player 40`
        suppliername   = `Fasttech`
        width          = `5.1`
        depth          = `8`
        height         = `9.2`
        dimunit        = `cm`
        weightmeasure  = `266`
        weightunit     = `G`
        price          = `167`
        currencycode   = `EUR`
        description    = `MP3-Player with 40 GB HDD and Color Display, can play movies` )
      ( productid      = `HT-6123`
        name           = `Power Pro Player 80`
        suppliername   = `Fasttech`
        width          = `4`
        depth          = `6`
        height         = `0.8`
        dimunit        = `cm`
        weightmeasure  = `267`
        weightunit     = `G`
        price          = `299`
        currencycode   = `EUR`
        description    = `MP3-Player with 80 GB SSD and Color Display, can play movies` )
      ( productid      = `HT-6130`
        name           = `Flat Watch HD32`
        suppliername   = `Very Best Screens`
        width          = `78`
        depth          = `22.1`
        height         = `55`
        dimunit        = `cm`
        weightmeasure  = `2.6`
        weightunit     = `KG`
        price          = `1459`
        currencycode   = `EUR`
        description    = `32-inch, 1366x768 Pixel, 16:9, HDTV ready` )
      ( productid      = `HT-6131`
        name           = `Flat Watch HD37`
        suppliername   = `Very Best Screens`
        width          = `99.1`
        depth          = `26`
        height         = `61`
        dimunit        = `cm`
        weightmeasure  = `2.2`
        weightunit     = `KG`
        price          = `1199`
        currencycode   = `EUR`
        description    = `37-inch, 1366x768 Pixel, 16:9, HDTV ready` )
      ( productid      = `HT-6132`
        name           = `Flat Watch HD41`
        suppliername   = `Very Best Screens`
        width          = `128`
        depth          = `23`
        height         = `79.1`
        dimunit        = `cm`
        weightmeasure  = `1.8`
        weightunit     = `KG`
        price          = `899`
        currencycode   = `EUR`
        description    = `41-inch, 1366x768 Pixel, 16:9, HDTV ready` )
      ( productid      = `HT-7000`
        name           = `Copperberry`
        suppliername   = `Fasttech`
        width          = `8.1`
        depth          = `13`
        height         = `12.1`
        dimunit        = `cm`
        weightmeasure  = `0.5`
        weightunit     = `KG`
        price          = `549`
        currencycode   = `EUR`
        description    = `Our new multifunctional Handheld with phone function in copper` )
      ( productid      = `HT-7010`
        name           = `Silverberry`
        suppliername   = `Fasttech`
        width          = `8.1`
        depth          = `13`
        height         = `12.1`
        dimunit        = `cm`
        weightmeasure  = `0.5`
        weightunit     = `KG`
        price          = `549`
        currencycode   = `EUR`
        description    = `Our new multifunctional Handheld with phone function in silver` )
      ( productid      = `HT-7020`
        name           = `Goldberry`
        suppliername   = `Fasttech`
        width          = `8.1`
        depth          = `13`
        height         = `12.1`
        dimunit        = `cm`
        weightmeasure  = `0.5`
        weightunit     = `KG`
        price          = `549`
        currencycode   = `EUR`
        description    = `Our new multifunctional Handheld with phone function in gold` )
      ( productid      = `HT-7030`
        name           = `Platinberry`
        suppliername   = `Fasttech`
        width          = `8.1`
        depth          = `13`
        height         = `12.1`
        dimunit        = `cm`
        weightmeasure  = `0.5`
        weightunit     = `KG`
        price          = `549`
        currencycode   = `EUR`
        description    = `Our new multifunctional Handheld with phone function in platinum` )
      ( productid      = `HT-8000`
        name           = `ITelO FlexTop I4000`
        suppliername   = `Titanium`
        width          = `31`
        depth          = `19`
        height         = `3.1`
        dimunit        = `cm`
        weightmeasure  = `4`
        weightunit     = `KG`
        price          = `799`
        currencycode   = `EUR`
        description    = `Notebook with 2,80 GHz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8` )
      ( productid      = `HT-8001`
        name           = `ITelO FlexTop I6300c`
        suppliername   = `Titanium`
        width          = `32`
        depth          = `20`
        height         = `3.4`
        dimunit        = `cm`
        weightmeasure  = `4.2`
        weightunit     = `KG`
        price          = `799`
        currencycode   = `EUR`
        description    = `Notebook with 2,80 GHz dual core, 8 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8` )
      ( productid      = `HT-8002`
        name           = `ITelO FlexTop I9100`
        suppliername   = `Titanium`
        width          = `38`
        depth          = `21`
        height         = `4.1`
        dimunit        = `cm`
        weightmeasure  = `3.5`
        weightunit     = `KG`
        price          = `1199`
        currencycode   = `EUR`
        description    = `Notebook with 2,80 GHz quad core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8` )
      ( productid      = `HT-8003`
        name           = `ITelO FlexTop I9800`
        suppliername   = `Titanium`
        width          = `48`
        depth          = `31`
        height         = `4.5`
        dimunit        = `cm`
        weightmeasure  = `3.8`
        weightunit     = `KG`
        price          = `1388`
        currencycode   = `EUR`
        description    = `Notebook with 2,80 GHz quad core, 8 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8` )
      ( productid      = `HT-9991`
        name           = `Smartphone Leather Case`
        suppliername   = `Ultrasonic United`
        width          = `48`
        depth          = `31`
        height         = `4.5`
        dimunit        = `cm`
        weightmeasure  = `0.02`
        weightunit     = `KG`
        price          = `25`
        currencycode   = `EUR`
        description    = `Button Clasp, Quality Material, 100% Leather, compatible with many smartphone models` )
      ( productid      = `HT-9992`
        name           = `Smartphone Alpha`
        suppliername   = `Ultrasonic United`
        width          = `48`
        depth          = `31`
        height         = `4.5`
        dimunit        = `cm`
        weightmeasure  = `0.75`
        weightunit     = `KG`
        price          = `599`
        currencycode   = `EUR`
        description    = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black` )
      ( productid      = `HT-9993`
        name           = `Mini Tablet`
        suppliername   = `Ultrasonic United`
        width          = `48`
        depth          = `31`
        height         = `4.5`
        dimunit        = `cm`
        weightmeasure  = `3.8`
        weightunit     = `KG`
        price          = `833`
        currencycode   = `EUR`
        description    = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage, 4325 mAh battery (Up to 8 hours of active use)` )
      ( productid      = `HT-9994`
        name           = `Camcorder View`
        suppliername   = `Ultrasonic United`
        width          = `48`
        depth          = `31`
        height         = `27`
        dimunit        = `cm`
        weightmeasure  = `3.8`
        weightunit     = `KG`
        price          = `1388`
        currencycode   = `EUR`
        description    = `1920x1080 Full HD, image stabilization reduces blur, 27x Optical / 32x Extended Zoom, wide angle Lens, 2.7" wide LCD display` )
      ( productid      = `HT-9995`
        name           = `Tablet Pouch`
        suppliername   = `Titanium`
        width          = `25`
        depth          = `40`
        height         = `4.5`
        dimunit        = `cm`
        weightmeasure  = `0.03`
        weightunit     = `KG`
        price          = `20`
        currencycode   = `EUR`
        description    = `Stylish tablet pouch, protects from scratches, color: black` )
      ( productid      = `HT-9996`
        name           = `Tablet Pouch`
        suppliername   = `Titanium`
        width          = `25`
        depth          = `40`
        height         = `4.5`
        dimunit        = `cm`
        weightmeasure  = `0.03`
        weightunit     = `KG`
        price          = `20`
        currencycode   = `EUR`
        description    = `Stylish tablet pouch, protects from scratches, color: black` )
      ( productid      = `HT-9997`
        name           = `e-Book Reader ReadMe`
        suppliername   = `Titanium`
        width          = `48`
        depth          = `31`
        height         = `4.5`
        dimunit        = `cm`
        weightmeasure  = `3.8`
        weightunit     = `KG`
        price          = `33`
        currencycode   = `EUR`
        description    = `6-Inch E Ink Screen, Access To e-book Store, Adjustable Font Styles and Sizes, Stores Up To 1,000 Books` )
      ( productid      = `HT-9998`
        name           = `Smartphone Beta`
        suppliername   = `Titanium`
        width          = `48`
        depth          = `31`
        height         = `4.5`
        dimunit        = `cm`
        weightmeasure  = `0.75`
        weightunit     = `KG`
        price          = `30`
        currencycode   = `EUR`
        description    = `5 Megapixel Camera, Wi-Fi 802.11 b/g/n, Bluetooth, GPS Available-GPS support` )
      ( productid      = `HT-9999`
        name           = `Maxi Tablet`
        suppliername   = `Titanium`
        width          = `48`
        depth          = `31`
        height         = `4.5`
        dimunit        = `cm`
        weightmeasure  = `3.8`
        weightunit     = `KG`
        price          = `749`
        currencycode   = `EUR`
        description    = `10.1-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor` )
      ( productid      = `PF-1000`
        name           = `Flyer`
        suppliername   = `Titanium`
        width          = `46`
        depth          = `30`
        height         = `3`
        dimunit        = `cm`
        weightmeasure  = `0.01`
        weightunit     = `KG`
        price          = `0`
        currencycode   = `EUR`
        description    = `Flyer for our product palette` )
      ).

  ENDMETHOD.

ENDCLASS.
