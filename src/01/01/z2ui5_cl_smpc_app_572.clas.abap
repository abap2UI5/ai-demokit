" @keywords table sap.m tablelayout overflowtoolbar title toolbarspacer checkbox button column text columnlistitem dialog
" @summary You can use fixedLayout property to define the layout algorithm to be used for the table cells, rows, and columns. When fixedLayout property is set to false, the width of the table and its cells depends on the content thereof.
CLASS z2ui5_cl_smpc_app_572 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             productid    TYPE string,
             name         TYPE string,
             suppliername TYPE string,
             description  TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    DATA t_products     TYPE ty_t_product.
    " onCheckBoxSelect calls setFixedLayout on the table the CheckBox sits in;
    " the property is bindable, so each table has its own flag
    DATA fixed_layout   TYPE abap_bool VALUE abap_true.
    DATA dialog_fixed   TYPE abap_bool VALUE abap_true.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popup_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_572 IMPLEMENTATION.

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

        )->ele( `Table`
            )->a( n = `fixedLayout` v = client->_bind( fixed_layout )
            )->a( n = `items`       v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', sorter: \{ path: 'NAME' \} \}|

            )->ele( `headerToolbar`
                )->ele( `OverflowToolbar`
                    )->tag( `Title`
                        )->a( n = `text`  v = `Products`
                        )->a( n = `level` v = `H2`
                    )->tag( `ToolbarSpacer`
                    )->tag( `CheckBox`
                        )->a( n = `text`     v = `Fixed Layout`
                        )->a( n = `selected` v = client->_bind( fixed_layout )
                    )->tag( `Button`
                        )->a( n = `text`  v = `Open Dialog`
                        )->a( n = `press` v = client->_event( `OPEN_DIALOG` )

                )->end(
            )->end(
            )->ele( `columns`
                )->ele( `Column`

                    )->tag( `Text`
                        )->a( n = `text` v = `Product Name`

                )->end(
                )->ele( `Column`

                    )->tag( `Text`
                        )->a( n = `text` v = `Supplier Name`

                )->end(
                )->ele( `Column`

                    )->tag( `Text`
                        )->a( n = `text` v = `Description`

                )->end(
            )->end(
            )->ele( `items`
                )->ele( `ColumnListItem`
                    )->a( n = `vAlign` v = `Middle`
                    )->a( n = `type`   v = `Navigation`

                    )->ele( `cells`
                        )->tag( `Text`
                            )->a( n = `text`     v = `{NAME}`
                            )->a( n = `wrapping` v = `false`
                        )->tag( `Text`
                            )->a( n = `text`     v = `{SUPPLIERNAME}`
                            )->a( n = `wrapping` v = `false`
                        )->tag( `Text`
                            )->a( n = `text` v = `{DESCRIPTION}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD popup_display.

    DATA(popup) = z2ui5_cl_ui5_view_builder=>factory( ).

    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`

        )->ele( `Dialog`
            )->a( n = `title` v = `Table Dialog`
            )->a( n = `class` v = `sapUiContentPadding`

            )->ele( `content`
                )->ele( `Table`
                    )->a( n = `mode`        v = `MultiSelect`
                    )->a( n = `fixedLayout` v = client->_bind( dialog_fixed )
                    )->a( n = `items`       v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', sorter: \{ path: 'NAME' \} \}|

                    )->ele( `headerToolbar`
                        )->ele( `Toolbar`
                            )->tag( `Title`
                                )->a( n = `text`  v = `Products`
                                )->a( n = `level` v = `H2`
                            )->tag( `ToolbarSpacer`
                            )->tag( `CheckBox`
                                )->a( n = `text`     v = `Fixed Layout`
                                )->a( n = `selected` v = client->_bind( dialog_fixed )

                        )->end(
                    )->end(
                    )->ele( `columns`
                        )->ele( `Column`

                            )->tag( `Text`
                                )->a( n = `text` v = `Supplier Name`

                        )->end(
                        )->ele( `Column`
                            )->a( n = `hAlign` v = `End`

                            )->tag( `Text`
                                )->a( n = `text` v = `Product ID`

                        )->end(
                    )->end(
                    )->ele( `items`
                        )->ele( `ColumnListItem`
                            )->a( n = `vAlign` v = `Middle`
                            )->a( n = `type`   v = `Navigation`

                            )->ele( `cells`
                                )->tag( `Text`
                                    )->a( n = `text`     v = `{NAME}`
                                    )->a( n = `wrapping` v = `false`
                                )->tag( `Text`
                                    )->a( n = `text`     v = `{PRODUCTID}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( `beginButton`
                )->tag( `Button`
                    )->a( n = `text`  v = `Close`
                    )->a( n = `press` v = client->_event( `CLOSE_DIALOG` ) ).

    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `OPEN_DIALOG`.
        popup_display( ).

      WHEN `CLOSE_DIALOG`.
        client->popup_destroy( ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " the full mock /ProductCollection, in the mock order - the items binding
    " keeps its own sorter on NAME
    t_products = VALUE #(
      ( productid = `HT-1000` name = `Notebook Basic 15` suppliername = `Very Best Screens`
        description = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro` )
      ( productid = `HT-1001` name = `Notebook Basic 17` suppliername = `Very Best Screens`
        description = `Notebook Basic 17 with 2,80 GHz quad core, 17" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro` )
      ( productid = `HT-1002` name = `Notebook Basic 18` suppliername = `Very Best Screens`
        description = `Notebook Basic 18 with 2,80 GHz quad core, 18" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro` )
      ( productid = `HT-1003` name = `Notebook Basic 19` suppliername = `Smartcards`
        description = `Notebook Basic 19 with 2,80 GHz quad core, 19" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro` )
      ( productid = `HT-1007` name = `ITelO Vault` suppliername = `Technocom`
        description = `Digital Organizer with State-of-the-Art Storage Encryption` )
      ( productid = `HT-1010` name = `Notebook Professional 15` suppliername = `Very Best Screens`
        description = `Notebook Professional 15 with 2,80 GHz quad core, 15" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro` )
      ( productid = `HT-1011` name = `Notebook Professional 17` suppliername = `Very Best Screens`
        description = `Notebook Professional 17 with 2,80 GHz quad core, 17" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro` )
      ( productid = `HT-1020` name = `ITelO Vault Net` suppliername = `Technocom`
        description = `Digital Organizer with State-of-the-Art Encryption for Storage and Network Communications` )
      ( productid = `HT-1021` name = `ITelO Vault SAT` suppliername = `Technocom`
        description = `Digital Organizer with State-of-the-Art Encryption for Storage and Secure Stellite Link` )
      ( productid = `HT-1022` name = `Comfort Easy` suppliername = `Technocom`
        description = `32 GB Digital Assistant with high-resolution color screen` )
      ( productid = `HT-1023` name = `Comfort Senior` suppliername = `Technocom`
        description = `64 GB Digital Assistant with high-resolution color screen and synthesized voice output` )
      ( productid = `HT-1030` name = `Ergo Screen E-I` suppliername = `Very Best Screens`
        description = `Optimum Hi-Resolution max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm` )
      ( productid = `HT-1031` name = `Ergo Screen E-II` suppliername = `Very Best Screens`
        description = `Optimum Hi-Resolution max. 1920 x 1200 @ 85Hz, Dot Pitch: 0.26mm` )
      ( productid = `HT-1032` name = `Ergo Screen E-III` suppliername = `Very Best Screens`
        description = `Optimum Hi-Resolution max. 2560 x 1440 @ 85Hz, Dot Pitch: 0.25mm` )
      ( productid = `HT-1035` name = `Flat Basic` suppliername = `Very Best Screens`
        description = `Optimum Hi-Resolution max. 1600 x 1200 @ 85Hz, Dot Pitch: 0.24mm` )
      ( productid = `HT-1036` name = `Flat Future` suppliername = `Very Best Screens`
        description = `Optimum Hi-Resolution max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.26mm` )
      ( productid = `HT-1037` name = `Flat XL` suppliername = `Very Best Screens`
        description = `Optimum Hi-Resolution max. 2016 x 1512 @ 85Hz, Dot Pitch: 0.24mm` )
      ( productid = `HT-1040` name = `Laser Professional Eco` suppliername = `Alpha Printers`
        description = `Print 2400 dpi image quality color documents at speeds of up to 32 ppm (color) or 36 ppm (monochrome), letter/A4. Powerful 500 MHz processor, 512MB of memory` )
      ( productid = `HT-1041` name = `Laser Basic` suppliername = `Alpha Printers`
        description = `Up to 22 ppm color or 24 ppm monochrome A4/letter, powerful 500 MHz processor and 128MB of memory` )
      ( productid = `HT-1042` name = `Laser Allround` suppliername = `Alpha Printers`
        description = `Print up to 25 ppm letter and 24 ppm A4 color or monochrome, with Available first-page-out-time of less than 13 seconds for monochrome and less than 15 seconds for color` )
      ( productid = `HT-1050` name = `Ultra Jet Super Color` suppliername = `Alpha Printers`
        description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB, Ethernet` )
      ( productid = `HT-1051` name = `Ultra Jet Mobile` suppliername = `Printer for All`
        description = `1000 dpi x 1000 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB - excellent dimensions for the small office` )
      ( productid = `HT-1052` name = `Ultra Jet Super Highspeed` suppliername = `Printer for All`
        description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB2.0, Ethernet` )
      ( productid = `HT-1055` name = `Multi Print` suppliername = `Printer for All`
        description = `1000 dpi x 1000 dpi - up to 16 ppm (mono) / up to 15 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 1200dpi x 2400dpi)` )
      ( productid = `HT-1056` name = `Multi Color` suppliername = `Printer for All`
        description = `1200 dpi x 1200 dpi - up to 25 ppm (mono) / up to 24 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 2400dpi x 4800dpi, high resolution)` )
      ( productid = `HT-1060` name = `Cordless Mouse` suppliername = `Oxynum`
        description = `Cordless Optical USB Mice, Laptop, Color: Black, Plug&Play` )
      ( productid = `HT-1061` name = `Speed Mouse` suppliername = `Oxynum`
        description = `Optical USB, PS/2 Mouse, Color: Blue, 3-button-functionality (incl. Scroll wheel)` )
      ( productid = `HT-1062` name = `Track Mouse` suppliername = `Oxynum`
        description = `Optical USB Mouse, Color: Red, 5-button-functionality(incl. Scroll wheel), Plug&Play` )
      ( productid = `HT-1063` name = `Ergonomic Keyboard` suppliername = `Oxynum`
        description = `Ergonomic USB Keyboard for Desktop, Plug&Play` )
      ( productid = `HT-1064` name = `Internet Keyboard` suppliername = `Oxynum`
        description = `Corded Keyboard with special keys for Internet Usability, USB` )
      ( productid = `HT-1065` name = `Media Keyboard` suppliername = `Oxynum`
        description = `Corded Ergonomic Keyboard with special keys for Media Usability, USB` )
      ( productid = `HT-1066` name = `Mousepad` suppliername = `Oxynum`
        description = `Nice mouse pad with ITelO Logo` )
      ( productid = `HT-1067` name = `Ergo Mousepad` suppliername = `Oxynum`
        description = `Ergonomic mouse pad with ITelO Logo` )
      ( productid = `HT-1068` name = `Designer Mousepad` suppliername = `Fasttech`
        description = `ITelO Mousepad Special Edition` )
      ( productid = `HT-1069` name = `Universal card reader` suppliername = `Fasttech`
        description = `Universal card reader` )
      ( productid = `HT-1070` name = `Proctra X` suppliername = `Ultrasonic United`
        description = `Proctra X: PCI-E GDDR5 3072MB` )
      ( productid = `HT-1071` name = `Gladiator MX` suppliername = `Ultrasonic United`
        description = `Gladiator XLN: PCI-E GDDR5 3072MB DVI Out, TV Out low-noise` )
      ( productid = `HT-1072` name = `Hurricane GX` suppliername = `Ultrasonic United`
        description = `Hurricane GX: PCI-E 691 GFLOPS game-optimized` )
      ( productid = `HT-1073` name = `Hurricane GX/LN` suppliername = `Smartcards`
        description = `Hurricane GX/LN: PCI-E 691 GFLOPS game-optimized, low-noise.` )
      ( productid = `HT-1080` name = `Photo Scan` suppliername = `Printer for All`
        description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - Hi-Speed USB - Bluetooth` )
      ( productid = `HT-1081` name = `Power Scan` suppliername = `Printer for All`
        description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - SCSI for backward compatibility` )
      ( productid = `HT-1082` name = `Jet Scan Professional` suppliername = `Printer for All`
        description = `Flatbed scanner - Letter - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module` )
      ( productid = `HT-1083` name = `Jet Scan Professional` suppliername = `Printer for All`
        description = `Flatbed scanner - A4 - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module` )
      ( productid = `HT-1085` name = `Copymaster` suppliername = `Alpha Printers`
        description = `Copymaster` )
      ( productid = `HT-1090` name = `Surround Sound` suppliername = `Speaker Experts`
        description = `PC multimedia speakers - 5 Watt (Total)` )
      ( productid = `HT-1091` name = `Blaster Extreme` suppliername = `Speaker Experts`
        description = `PC multimedia speakers - 10 Watt (Total) - 2-way` )
      ( productid = `HT-1092` name = `Sound Booster` suppliername = `Speaker Experts`
        description = `PC multimedia speakers - optimized for Blutooth/A2DP` )
      ( productid = `HT-1095` name = `Lovely Sound 5.1 Wireless` suppliername = `Fasttech`
        description = `5.1 Headset, 40 Hz-20 kHz, Wireless` )
      ( productid = `HT-1096` name = `Lovely Sound 5.1` suppliername = `Fasttech`
        description = `5.1 Headset, 40 Hz-20 kHz, 3m cable` )
      ( productid = `HT-1097` name = `Lovely Sound Stereo` suppliername = `Fasttech`
        description = `5.1 Headset, 40 Hz-20 kHz, 1m cable` )
      ( productid = `HT-1100` name = `Smart Office` suppliername = `Technocom`
        description = `Complete package, 1 User, Office Applications (word processing, spreadsheet, presentations)` )
      ( productid = `HT-1101` name = `Smart Design` suppliername = `Technocom`
        description = `Complete package, 1 User, Image editing, processing` )
      ( productid = `HT-1102` name = `Smart Network` suppliername = `Technocom`
        description = `Complete package, 1 User, Network Software Utilities, Useful Applications and Documentation` )
      ( productid = `HT-1103` name = `Smart Multimedia` suppliername = `Technocom`
        description = `Complete package, 1 User, different Multimedia applications, playing music, watching DVDs, only with this Smart package` )
      ( productid = `HT-1104` name = `Smart Games` suppliername = `Technocom`
        description = `Complete package, 1 User, various games for amusement, logic, action, jump&run` )
      ( productid = `HT-1105` name = `Smart Internet Antivirus` suppliername = `Brainsoft`
        description = `Complete package, 1 User, highly recommended for internet users as anti-virus protection` )
      ( productid = `HT-1106` name = `Smart Firewall` suppliername = `Brainsoft`
        description = `Complete package, 1 User, recommended for internet users, protect your PC against cyber-crime` )
      ( productid = `HT-1107` name = `Smart Money` suppliername = `Brainsoft`
        description = `Complete package, 1 User, bring your money in your mind, see what you have and what you want` )
      ( productid = `HT-1110` name = `PC Lock` suppliername = `Red Point Stores`
        description = `Robust 3m anti-burglary protection for your laptop computer` )
      ( productid = `HT-1111` name = `Notebook Lock` suppliername = `Red Point Stores`
        description = `Robust 1m anti-burglary protection for your desktop computer` )
      ( productid = `HT-1112` name = `Web cam reality` suppliername = `Red Point Stores`
        description = `Color webcam, color, High-Speed USB` )
      ( productid = `HT-1113` name = `Screen clean` suppliername = `Red Point Stores`
        description = `10 separately packed screen wipes` )
      ( productid = `HT-1114` name = `Fabric bag professional` suppliername = `Red Point Stores`
        description = `Notebook bag, plenty of room for stationery and writing materials` )
      ( productid = `HT-1115` name = `Wireless DSL Router` suppliername = `Red Point Stores`
        description = `Wireless DSL Router (available in blue, black and silver)` )
      ( productid = `HT-1116` name = `Wireless DSL Router / Repeater` suppliername = `Red Point Stores`
        description = `Wireless DSL Router / Repeater (available in blue, black and silver)` )
      ( productid = `HT-1117` name = `Wireless DSL Router / Repeater and Print Server` suppliername = `Technocom`
        description = `Wireless DSL Router / Repeater and Print Server (available in blue, black and silver)` )
      ( productid = `HT-1118` name = `USB Stick` suppliername = `Technocom`
        description = `USB 2.0 High-Speed 64 GB` )
      ( productid = `HT-1119` name = `Travel Adapter` suppliername = `Titanium`
        description = `Universal Travel Adapter` )
      ( productid = `HT-1120` name = `Cordless Bluetooth Keyboard, english international` suppliername = `Technocom`
        description = `Cordless Bluetooth Keyboard with English keys` )
      ( productid = `HT-1137` name = `Flat XXL` suppliername = `Technocom`
        description = `Optimum Hi-Resolution max. 2048 × 1536 @ 85Hz, Dot Pitch: 0.24mm` )
      ( productid = `HT-1138` name = `Pocket Mouse` suppliername = `Technocom`
        description = `Portable pocket Mouse with retracting cord` )
      ( productid = `HT-1210` name = `PC Power Station` suppliername = `Technocom`
        description = `PC Power Station with 3,4 Ghz quad-core, 32 GB DDR3 SDRAM, feels like Available PC, Windows 8 Pro` )
      ( productid = `HT-1251` name = `Astro Laptop 1516` suppliername = `Ultrasonic United`
        description = `Flexible Laptop with 2,5 GHz Quad Core, 15" HD TN, 16 GB DDR SDRAM, 256 GB SSD, Windows 10 Pro` )
      ( productid = `HT-1252` name = `Astro Phone 6` suppliername = `Ultrasonic United`
        description = `6 inch 1280x800 HD display (216 ppi), Quad-core processor, 8 GB internal storage (actual formatted capacity will be less), 3050 mAh battery (Up to 8 hours of active use), grey or black` )
      ( productid = `HT-1253` name = `Benda Laptop 1408` suppliername = `Ultrasonic United`
        description = `Flexible Laptop with 2,5 GHz Dual Core, 14" HD+ TN, 8 GB DDR SDRAM, 324 GB SSD, Windows 10 Pro` )
      ( productid = `HT-1254` name = `Bending Screen 21HD` suppliername = `Ultrasonic United`
        description = `Optimum Hi-Resolution Widescreen max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub` )
      ( productid = `HT-1255` name = `Broad Screen 22HD` suppliername = `Ultrasonic United`
        description = `Optimum Hi-Resolution Widescreen max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub` )
      ( productid = `HT-1256` name = `Cerdik Phone 7` suppliername = `Ultrasonic United`
        description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black` )
      ( productid = `HT-1257` name = `Cepat Tablet 10.5` suppliername = `Ultrasonic United`
        description = `10.5-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor` )
      ( productid = `HT-1258` name = `Cepat Tablet 8` suppliername = `Ultrasonic United`
        description = `8-inch Multitouch HD Screen (2000 x 1500) 32GB Internal Memory, Wireless N Wi-Fi, Bluetooth, GPS Enabled, 1.5 GHz Quad-Core Processor` )
      ( productid = `HT-1500` name = `Server Basic` suppliername = `Technocom`
        description = `Dual socket, quad-core processing server with 1333 MHz Front Side Bus with 10Gb connectivity` )
      ( productid = `HT-1501` name = `Server Professional` suppliername = `Technocom`
        description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 10Gb connectivity` )
      ( productid = `HT-1502` name = `Server Power Pro` suppliername = `Technocom`
        description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 100Gb connectivity` )
      ( productid = `HT-1600` name = `Family PC Basic` suppliername = `Titanium`
        description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Graphic Card: Proctra X, Windows 8` )
      ( productid = `HT-1601` name = `Family PC Pro` suppliername = `Titanium`
        description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8` )
      ( productid = `HT-1602` name = `Gaming Monster` suppliername = `Titanium`
        description = `3,4 Ghz quad core, 8 GB DDR3 SDRAM, 2000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8` )
      ( productid = `HT-1603` name = `Gaming Monster Pro` suppliername = `Titanium`
        description = `3,4 Ghz quad core, 16 GB DDR3 SDRAM, 4000 GB Hard Disc, Graphic Card: Hurricane GX, Windows 8` )
      ( productid = `HT-2000` name = `7" Widescreen Portable DVD Player w MP3` suppliername = `Titanium`
        description = `7" LCD Screen, storage battery holds up to 6 hours!` )
      ( productid = `HT-2001` name = `10" Portable DVD player` suppliername = `Titanium`
        description = `10" LCD Screen, storage battery holds up to 8 hours` )
      ( productid = `HT-2002` name = `Portable DVD Player with 9" LCD Monitor` suppliername = `Technocom`
        description = `9" LCD Screen, storage holds up to 8 hours, 2 speakers included` )
      ( productid = `HT-2025` name = `CD/DVD case: 264 sleeves` suppliername = `Titanium`
        description = `Organizer and protective case for 264 CDs and DVDs` )
      ( productid = `HT-2026` name = `Audio/Video Cable Kit - 4m` suppliername = `Titanium`
        description = `Quality cables for notebooks and projectors` )
      ( productid = `HT-2027` name = `Removable CD/DVD Laser Labels` suppliername = `Titanium`
        description = `Removable jewel case labels, zero residues (100)` )
      ( productid = `HT-6100` name = `Beam Breaker B-1` suppliername = `Titanium`
        description = `720p, DLP Projector max. 8,45 Meter, 2D` )
      ( productid = `HT-6101` name = `Beam Breaker B-2` suppliername = `Technocom`
        description = `1080p, DLP max.9,34 Meter, 2D-ready` )
      ( productid = `HT-6102` name = `Beam Breaker B-3` suppliername = `Technocom`
        description = `1080p, DLP max. 12,3 Meter, 3D-ready` )
      ( productid = `HT-6110` name = `Play Movie` suppliername = `Fasttech`
        description = `CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid` )
      ( productid = `HT-6111` name = `Record Movie` suppliername = `Fasttech`
        description = `160 GB HDD, CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid` )
      ( productid = `HT-6120` name = `ITelo MusicStick` suppliername = `Fasttech`
        description = `64 GB USB Music-on-Available-Stick` )
      ( productid = `HT-6121` name = `ITelo Jog-Mate` suppliername = `Fasttech`
        description = `ITelo Jog-Mate 64 GB HDD and Color Display, can play movies` )
      ( productid = `HT-6122` name = `Power Pro Player 40` suppliername = `Fasttech`
        description = `MP3-Player with 40 GB HDD and Color Display, can play movies` )
      ( productid = `HT-6123` name = `Power Pro Player 80` suppliername = `Fasttech`
        description = `MP3-Player with 80 GB SSD and Color Display, can play movies` )
      ( productid = `HT-6130` name = `Flat Watch HD32` suppliername = `Very Best Screens`
        description = `32-inch, 1366x768 Pixel, 16:9, HDTV ready` )
      ( productid = `HT-6131` name = `Flat Watch HD37` suppliername = `Very Best Screens`
        description = `37-inch, 1366x768 Pixel, 16:9, HDTV ready` )
      ( productid = `HT-6132` name = `Flat Watch HD41` suppliername = `Very Best Screens`
        description = `41-inch, 1366x768 Pixel, 16:9, HDTV ready` )
      ( productid = `HT-7000` name = `Copperberry` suppliername = `Fasttech`
        description = `Our new multifunctional Handheld with phone function in copper` )
      ( productid = `HT-7010` name = `Silverberry` suppliername = `Fasttech`
        description = `Our new multifunctional Handheld with phone function in silver` )
      ( productid = `HT-7020` name = `Goldberry` suppliername = `Fasttech`
        description = `Our new multifunctional Handheld with phone function in gold` )
      ( productid = `HT-7030` name = `Platinberry` suppliername = `Fasttech`
        description = `Our new multifunctional Handheld with phone function in platinum` )
      ( productid = `HT-8000` name = `ITelO FlexTop I4000` suppliername = `Titanium`
        description = `Notebook with 2,80 GHz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8` )
      ( productid = `HT-8001` name = `ITelO FlexTop I6300c` suppliername = `Titanium`
        description = `Notebook with 2,80 GHz dual core, 8 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8` )
      ( productid = `HT-8002` name = `ITelO FlexTop I9100` suppliername = `Titanium`
        description = `Notebook with 2,80 GHz quad core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8` )
      ( productid = `HT-8003` name = `ITelO FlexTop I9800` suppliername = `Titanium`
        description = `Notebook with 2,80 GHz quad core, 8 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8` )
      ( productid = `HT-9991` name = `Smartphone Leather Case` suppliername = `Ultrasonic United`
        description = `Button Clasp, Quality Material, 100% Leather, compatible with many smartphone models` )
      ( productid = `HT-9992` name = `Smartphone Alpha` suppliername = `Ultrasonic United`
        description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black` )
      ( productid = `HT-9993` name = `Mini Tablet` suppliername = `Ultrasonic United`
        description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage, 4325 mAh battery (Up to 8 hours of active use)` )
      ( productid = `HT-9994` name = `Camcorder View` suppliername = `Ultrasonic United`
        description = `1920x1080 Full HD, image stabilization reduces blur, 27x Optical / 32x Extended Zoom, wide angle Lens, 2.7" wide LCD display` )
      ( productid = `HT-9995` name = `Tablet Pouch` suppliername = `Titanium`
        description = `Stylish tablet pouch, protects from scratches, color: black` )
      ( productid = `HT-9996` name = `Tablet Pouch` suppliername = `Titanium`
        description = `Stylish tablet pouch, protects from scratches, color: black` )
      ( productid = `HT-9997` name = `e-Book Reader ReadMe` suppliername = `Titanium`
        description = `6-Inch E Ink Screen, Access To e-book Store, Adjustable Font Styles and Sizes, Stores Up To 1,000 Books` )
      ( productid = `HT-9998` name = `Smartphone Beta` suppliername = `Titanium`
        description = `5 Megapixel Camera, Wi-Fi 802.11 b/g/n, Bluetooth, GPS Available-GPS support` )
      ( productid = `HT-9999` name = `Maxi Tablet` suppliername = `Titanium`
        description = `10.1-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor` )
      ( productid = `PF-1000` name = `Flyer` suppliername = `Titanium`
        description = `Flyer for our product palette` ) ).

  ENDMETHOD.

ENDCLASS.
