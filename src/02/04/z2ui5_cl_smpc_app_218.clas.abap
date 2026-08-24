" @keywords shellbar shell bar sap.f shellbarwithsearch menu menuitem avatar searchmanager suggestionitem
" @summary Shell Bar example with configured search functionality.
CLASS z2ui5_cl_smpc_app_218 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             productid     TYPE string,
             category      TYPE string,
             maincategory  TYPE string,
             taxtarifcode  TYPE string,
             suppliername  TYPE string,
             weightmeasure TYPE string,
             weightunit    TYPE string,
             description   TYPE string,
             name          TYPE string,
             dateofsale    TYPE string,
             productpicurl TYPE string,
             status        TYPE string,
             quantity      TYPE i,
             uom           TYPE string,
             currencycode  TYPE string,
             price         TYPE string,
             width         TYPE string,
             depth         TYPE string,
             height        TYPE string,
             dimunit       TYPE string,
           END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_218 IMPLEMENTATION.

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
        )->a( n = `xmlns`     v = `sap.f`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`   v = `sap.m`
        )->a( n = `height`    v = `100%`

        )->ele( `ShellBar`
            )->a( n = `title`               v = `Application Title`
            )->a( n = `secondTitle`         v = `Short description`
            )->a( n = `homeIcon`            v = `https://sdk.openui5.org/resources/sap/ui/documentation/sdk/images/logo_sap.png`
            )->a( n = `showCopilot`         v = `true`
            )->a( n = `showNotifications`   v = `true`
            )->a( n = `notificationsNumber` v = `2`

            )->ele( `menu`
                )->ele( n = `Menu` ns = `m`
                    )->tag( n = `MenuItem` ns = `m`
                        )->a( n = `text` v = `Flight booking`
                        )->a( n = `icon` v = `sap-icon://flight`
                    )->tag( n = `MenuItem` ns = `m`
                        )->a( n = `text` v = `Car rental`
                        )->a( n = `icon` v = `sap-icon://car-rental`

                )->end(
            )->end(

            )->ele( `profile`
                )->tag( n = `Avatar` ns = `m`
                    )->a( n = `initials` v = `UI`

            )->end(

            )->ele( `searchManager`
                )->ele( `SearchManager`
                    )->a( n = `id`                v = `searchField`
                    )->a( n = `search`            v = client->follow_up_action( val = client->cs_event-control_global t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} search event is fired` ) ( `$event.oSource.sId` ) ) )
                    )->a( n = `liveChange`        v = client->follow_up_action( val = client->cs_event-control_global
                                                                                t_arg = VALUE #( ( `MESSAGE_TOAST` ) ( `show` ) ( `{0} liveChange event value is: {1}` ) ( `$event.oSource.sId` ) ( `${$parameters>/newValue}` ) ) )
                    )->a( n = `suggest`           v = client->_event( val = `SUGGEST` t_arg = VALUE #( ( `${$parameters>/suggestValue}` ) ) )
                    )->a( n = `enableSuggestions` v = `true`
                    )->a( n = `suggestionItems`   v = |\{ path: '{ client->_bind( val = t_products path = abap_true ) }', sorter: \{ path: 'NAME' \} \}|

                    )->ele( `suggestionItems`
                        )->tag( n = `SuggestionItem` ns = `m`
                            )->a( n = `text`        v = `{NAME}`
                            )->a( n = `description` v = `{PRICE} {CURRENCYCODE}`
                            )->a( n = `key`         v = `{PRODUCTID}`

                    )->end(
                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    DATA json_groups TYPE string.

    IF client->get_event( ) = `SUGGEST`.
      DATA(suggest_value) = client->get_event_arg( ).
      IF suggest_value IS INITIAL.
        json_groups = `[]`.
      ELSE.
        DATA(search_val) = suggest_value.
        REPLACE ALL OCCURRENCES OF `\` IN search_val WITH `\\`.
        REPLACE ALL OCCURRENCES OF `"` IN search_val WITH `\"`.
        json_groups = |[[["PRODUCTID","Contains","{ search_val }"],["NAME","Contains","{ search_val }"]]]|.
      ENDIF.
      client->follow_up_action( val   = client->cs_event-binding_call
                                t_arg = VALUE #( ( `searchField` ) ( `suggestionItems` ) ( `filter` ) ( json_groups ) ) ).
      " original: this.oSF.suggest() - reopen the suggestion popup after the
      " filter (a public non-denied method via the generalized allowlist)
      client->follow_up_action( val   = client->cs_event-control_by_id
                                t_arg = VALUE #( ( `searchField` ) ( `suggest` ) ) ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection (sap/ui/demo/mock/products.json) of the original sample
    t_products = VALUE #(
        ( productid = `HT-1000` category = `Laptops` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Very Best Screens` weightmeasure = `4.2` weightunit = `KG`
          description = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro` name = `Notebook Basic 15` dateofsale = `2017-03-26`
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg` status = `Available` quantity = 10 uom = `PC` currencycode = `EUR` price = `956` width = `30` depth = `18` height = `3` dimunit = `cm` )
        ( productid = `HT-1001` category = `Laptops` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Very Best Screens` weightmeasure = `4.5` weightunit = `KG`
          description = `Notebook Basic 17 with 2,80 GHz quad core, 17" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro` name = `Notebook Basic 17` dateofsale = `2017-04-17`
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg` status = `Available` quantity = 20 uom = `PC` currencycode = `EUR` price = `1249` width = `29` depth = `17` height = `3.1` dimunit = `cm` )
        ( productid = `HT-1002` category = `Laptops` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Very Best Screens` weightmeasure = `4.2` weightunit = `KG`
          description = `Notebook Basic 18 with 2,80 GHz quad core, 18" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro` name = `Notebook Basic 18` dateofsale = `2017-01-07`
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg` status = `Available` quantity = 10 uom = `PC` currencycode = `EUR` price = `1570` width = `28` depth = `19` height = `2.5` dimunit = `cm` )
        ( productid = `HT-1003` category = `Laptops` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Smartcards` weightmeasure = `4.2` weightunit = `KG`
          description = `Notebook Basic 19 with 2,80 GHz quad core, 19" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro` name = `Notebook Basic 19` dateofsale = `2017-04-09`
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg` status = `Out of Stock` quantity = 15 uom = `PC` currencycode = `EUR` price = `1650` width = `32` depth = `21` height = `4` dimunit = `cm` )
        ( productid = `HT-1007` category = `Accessories` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Technocom` weightmeasure = `0.2` weightunit = `KG`
          description = `Digital Organizer with State-of-the-Art Storage Encryption` name = `ITelO Vault` dateofsale = `2017-05-17` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg`
          status = `Out of Stock` quantity = 15
          uom = `PC` currencycode = `EUR` price = `299` width = `32` depth = `22` height = `3` dimunit = `cm` )
        ( productid = `HT-1010` category = `Accessories` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Very Best Screens` weightmeasure = `4.3` weightunit = `KG`
          description = `Notebook Professional 15 with 2,80 GHz quad core, 15" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro` name = `Notebook Professional 15` dateofsale = `2017-02-22`
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg` status = `Out of Stock` quantity = 16 uom = `PC` currencycode = `EUR` price = `1999` width = `33` depth = `20` height = `3` dimunit = `cm` )
        ( productid = `HT-1011` category = `Laptops` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Very Best Screens` weightmeasure = `4.1` weightunit = `KG`
          description = `Notebook Professional 17 with 2,80 GHz quad core, 17" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro` name = `Notebook Professional 17` dateofsale = `2017-01-02`
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg` status = `Out of Stock` quantity = 17 uom = `PC` currencycode = `EUR` price = `2299` width = `33` depth = `23` height = `2` dimunit = `cm` )
        ( productid = `HT-1020` category = `Accessories` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Technocom` weightmeasure = `0.16` weightunit = `KG`
          description = `Digital Organizer with State-of-the-Art Encryption for Storage and Network Communications` name = `ITelO Vault Net` dateofsale = `2017-05-08`
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg`
          status = `Discontinued` quantity = 14 uom = `PC` currencycode = `EUR` price = `459` width = `10` depth = `1.8` height = `17` dimunit = `cm` )
        ( productid = `HT-1021` category = `Accessories` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Technocom` weightmeasure = `0.18` weightunit = `KG`
          description = `Digital Organizer with State-of-the-Art Encryption for Storage and Secure Stellite Link` name = `ITelO Vault SAT` dateofsale = `2017-06-30`
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg`
          status = `Available` quantity = 50 uom = `PC` currencycode = `EUR` price = `149` width = `11` depth = `1.7` height = `18` dimunit = `cm` )
        ( productid = `HT-1022` category = `Accessories` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Technocom` weightmeasure = `0.2` weightunit = `KG`
          description = `32 GB Digital Assistant with high-resolution color screen` name = `Comfort Easy` dateofsale = `2017-03-02` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg`
          status = `Out of Stock` quantity = 30
          uom = `PC` currencycode = `EUR` price = `1679` width = `84` depth = `1.5` height = `14` dimunit = `cm` )
        ( productid = `HT-1023` category = `Accessories` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Technocom` weightmeasure = `0.8` weightunit = `KG`
          description = `64 GB Digital Assistant with high-resolution color screen and synthesized voice output` name = `Comfort Senior` dateofsale = `2017-02-25`
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg`
          status = `Available` quantity = 24 uom = `PC` currencycode = `EUR` price = `512` width = `80` depth = `1.6` height = `13` dimunit = `cm` )
        ( productid = `HT-1030` category = `Flat Screen Monitors` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Very Best Screens` weightmeasure = `21` weightunit = `KG`
          description = `Optimum Hi-Resolution max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm` name = `Ergo Screen E-I` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg` status = `Available`
          quantity = 14
          uom = `PC` currencycode = `EUR` price = `230` width = `37` depth = `12` height = `36` dimunit = `cm` )
        ( productid = `HT-1031` category = `Flat Screen Monitors` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Very Best Screens` weightmeasure = `21` weightunit = `KG`
          description = `Optimum Hi-Resolution max. 1920 x 1200 @ 85Hz, Dot Pitch: 0.26mm` name = `Ergo Screen E-II` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg` status = `Available`
          quantity = 24
          uom = `PC` currencycode = `EUR` price = `285` width = `40.8` depth = `19` height = `43` dimunit = `cm` )
        ( productid = `HT-1032` category = `Flat Screen Monitors` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Very Best Screens` weightmeasure = `21` weightunit = `KG`
          description = `Optimum Hi-Resolution max. 2560 x 1440 @ 85Hz, Dot Pitch: 0.25mm` name = `Ergo Screen E-III` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg`
          status = `Out of Stock` quantity = 50
          uom = `PC` currencycode = `EUR` price = `345` width = `40.8` depth = `19` height = `43` dimunit = `cm` )
        ( productid = `HT-1035` category = `Flat Screen Monitors` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Very Best Screens` weightmeasure = `14` weightunit = `KG`
          description = `Optimum Hi-Resolution max. 1600 x 1200 @ 85Hz, Dot Pitch: 0.24mm` name = `Flat Basic` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg` status = `Available`
          quantity = 23 uom = `PC`
          currencycode = `EUR` price = `399` width = `39` depth = `20` height = `41` dimunit = `cm` )
        ( productid = `HT-1036` category = `Flat Screen Monitors` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Very Best Screens` weightmeasure = `15` weightunit = `KG`
          description = `Optimum Hi-Resolution max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.26mm` name = `Flat Future` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg` status = `Available`
          quantity = 22 uom = `PC`
          currencycode = `EUR` price = `430` width = `45` depth = `26` height = `46` dimunit = `cm` )
        ( productid = `HT-1037` category = `Flat Screen Monitors` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Very Best Screens` weightmeasure = `17` weightunit = `KG`
          description = `Optimum Hi-Resolution max. 2016 x 1512 @ 85Hz, Dot Pitch: 0.24mm` name = `Flat XL` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg` status = `Available`
          quantity = 23 uom = `PC`
          currencycode = `EUR` price = `1230` width = `54.5` depth = `22.1` height = `39.1` dimunit = `cm` )
        ( productid = `HT-1040` category = `Printers` maincategory = `Printers & Scanners` taxtarifcode = `1` suppliername = `Alpha Printers` weightmeasure = `32` weightunit = `KG`
          description = `Print 2400 dpi image quality color documents at speeds of up to 32 ppm (color) or 36 ppm (monochrome), letter/A4. Powerful 500 MHz processor, 512MB of memory` name = `Laser Professional Eco` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg` status = `Available` quantity = 21 uom = `PC` currencycode = `EUR` price = `830` width = `51` depth = `46` height = `30` dimunit = `cm` )
        ( productid = `HT-1041` category = `Printers` maincategory = `Printers & Scanners` taxtarifcode = `1` suppliername = `Alpha Printers` weightmeasure = `23` weightunit = `KG`
          description = `Up to 22 ppm color or 24 ppm monochrome A4/letter, powerful 500 MHz processor and 128MB of memory` name = `Laser Basic` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg`
          status = `Available` quantity = 8 uom = `PC` currencycode = `EUR` price = `490` width = `48` depth = `42` height = `26` dimunit = `cm` )
        ( productid = `HT-1042` category = `Printers` maincategory = `Printers & Scanners` taxtarifcode = `1` suppliername = `Alpha Printers` weightmeasure = `17` weightunit = `KG`
          description = `Print up to 25 ppm letter and 24 ppm A4 color or monochrome, with Available first-page-out-time of less than 13 seconds for monochrome and less than 15 seconds for color` name = `Laser Allround` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg` status = `Available` quantity = 9 uom = `PC` currencycode = `EUR` price = `349` width = `53` depth = `50` height = `65` dimunit = `cm` )
        ( productid = `HT-1050` category = `Printers` maincategory = `Printers & Scanners` taxtarifcode = `1` suppliername = `Alpha Printers` weightmeasure = `3` weightunit = `KG`
          description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB, Ethernet` name = `Ultra Jet Super Color` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg` status = `Discontinued` quantity = 17 uom = `PC` currencycode = `EUR` price = `139` width = `41` depth = `41` height = `28` dimunit = `cm` )
        ( productid = `HT-1051` category = `Printers` maincategory = `Printers & Scanners` taxtarifcode = `1` suppliername = `Printer for All` weightmeasure = `1.9` weightunit = `KG`
          description = `1000 dpi x 1000 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB - excellent dimensions for the small office` name = `Ultra Jet Mobile` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg` status = `Discontinued` quantity = 18 uom = `PC` currencycode = `EUR` price = `99` width = `46` depth = `32` height = `25` dimunit = `cm` )
        ( productid = `HT-1052` category = `Printers` maincategory = `Printers & Scanners` taxtarifcode = `1` suppliername = `Printer for All` weightmeasure = `18` weightunit = `KG`
          description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB2.0, Ethernet` name = `Ultra Jet Super Highspeed` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg` status = `Available` quantity = 25 uom = `PC` currencycode = `EUR` price = `170` width = `41` depth = `41` height = `28` dimunit = `cm` )
        ( productid = `HT-1055` category = `Multifunction Printers` maincategory = `Printers & Scanners` taxtarifcode = `1` suppliername = `Printer for All` weightmeasure = `6.3` weightunit = `KG`
          description = `1000 dpi x 1000 dpi - up to 16 ppm (mono) / up to 15 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 1200dpi x 2400dpi)` name = `Multi Print` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg` status = `Available` quantity = 16 uom = `PC` currencycode = `EUR` price = `99` width = `55` depth = `45` height = `29` dimunit = `cm` )
        ( productid = `HT-1056` category = `Multifunction Printers` maincategory = `Printers & Scanners` taxtarifcode = `1` suppliername = `Printer for All` weightmeasure = `4.3` weightunit = `KG`
          description = `1200 dpi x 1200 dpi - up to 25 ppm (mono) / up to 24 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 2400dpi x 4800dpi, high resolution)` name = `Multi Color` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg` status = `Available` quantity = 5 uom = `PC` currencycode = `EUR` price = `119` width = `51` depth = `41.3` height = `22` dimunit = `cm` )
        ( productid = `HT-1060` category = `Mice` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Oxynum` weightmeasure = `0.09` weightunit = `KG` description = `Cordless Optical USB Mice, Laptop, Color: Black, Plug&Play`
          name = `Cordless Mouse` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg` status = `Available` quantity = 25 uom = `PC` currencycode = `EUR` price = `9` width = `6`
          depth = `14.5` height = `3.5`
          dimunit = `cm` )
        ( productid = `HT-1061` category = `Mice` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Oxynum` weightmeasure = `0.09` weightunit = `KG`
          description = `Optical USB, PS/2 Mouse, Color: Blue, 3-button-functionality (incl. Scroll wheel)` name = `Speed Mouse` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg`
          status = `Available`
          quantity = 12 uom = `PC` currencycode = `EUR` price = `7` width = `7` depth = `15` height = `3.1` dimunit = `cm` )
        ( productid = `HT-1062` category = `Mice` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Oxynum` weightmeasure = `0.03` weightunit = `KG`
          description = `Optical USB Mouse, Color: Red, 5-button-functionality(incl. Scroll wheel), Plug&Play` name = `Track Mouse` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg`
          status = `Discontinued`
          quantity = 12 uom = `PC` currencycode = `EUR` price = `11` width = `3` depth = `7` height = `4` dimunit = `cm` )
        ( productid = `HT-1063` category = `Keyboards` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Oxynum` weightmeasure = `2.1` weightunit = `KG` description = `Ergonomic USB Keyboard for Desktop, Plug&Play`
          name = `Ergonomic Keyboard` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg` status = `Available` quantity = 50 uom = `PC` currencycode = `EUR` price = `14` width = `50`
          depth = `21`
          height = `3.5` dimunit = `cm` )
        ( productid = `HT-1064` category = `Keyboards` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Oxynum` weightmeasure = `1.8` weightunit = `KG`
          description = `Corded Keyboard with special keys for Internet Usability, USB` name = `Internet Keyboard` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg` status = `Out of Stock`
          quantity = 35
          uom = `PC` currencycode = `EUR` price = `16` width = `52` depth = `25` height = `3` dimunit = `cm` )
        ( productid = `HT-1065` category = `Keyboards` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Oxynum` weightmeasure = `2.3` weightunit = `KG`
          description = `Corded Ergonomic Keyboard with special keys for Media Usability, USB` name = `Media Keyboard` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg`
          status = `Available` quantity = 26
          uom = `PC` currencycode = `EUR` price = `26` width = `51.4` depth = `23` height = `4` dimunit = `cm` )
        ( productid = `HT-1066` category = `Mousepads` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Oxynum` weightmeasure = `80` weightunit = `G` description = `Nice mouse pad with ITelO Logo` name = `Mousepad`
          dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg` status = `Available` quantity = 12 uom = `PC` currencycode = `EUR` price = `6.99` width = `15` depth = `6` height = `0.2`
          dimunit = `cm` )
        ( productid = `HT-1067` category = `Mousepads` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Oxynum` weightmeasure = `80` weightunit = `G` description = `Ergonomic mouse pad with ITelO Logo` name = `Ergo Mousepad`
          dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg` status = `Out of Stock` quantity = 16 uom = `PC` currencycode = `EUR` price = `8.99` width = `15` depth = `6` height = `0.2`
          dimunit = `cm` )
        ( productid = `HT-1068` category = `Mousepads` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Fasttech` weightmeasure = `90` weightunit = `G` description = `ITelO Mousepad Special Edition` name = `Designer Mousepad`
          dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg` status = `Available` quantity = 26 uom = `PC` currencycode = `EUR` price = `12.99` width = `24` depth = `24` height = `0.6`
          dimunit = `cm` )
        ( productid = `HT-1069` category = `Computer System Accessories` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Fasttech` weightmeasure = `45` weightunit = `G` description = `Universal card reader`
          name = `Universal card reader` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg` status = `Available` quantity = 22 uom = `PC` currencycode = `EUR` price = `14` width = `6`
          depth = `6` height = `3`
          dimunit = `cm` )
        ( productid = `HT-1070` category = `Graphic Cards` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Ultrasonic United` weightmeasure = `0.255` weightunit = `KG` description = `Proctra X: PCI-E GDDR5 3072MB`
          name = `Proctra X` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg` status = `Out of Stock` quantity = 15 uom = `PC` currencycode = `EUR` price = `70.9` width = `22`
          depth = `35` height = `17`
          dimunit = `cm` )
        ( productid = `HT-1071` category = `Graphic Cards` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Ultrasonic United` weightmeasure = `0.3` weightunit = `KG`
          description = `Gladiator XLN: PCI-E GDDR5 3072MB DVI Out, TV Out low-noise` name = `Gladiator MX` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg` status = `Discontinued`
          quantity = 16 uom = `PC`
          currencycode = `EUR` price = `81.7` width = `22` depth = `35` height = `17` dimunit = `cm` )
        ( productid = `HT-1072` category = `Graphic Cards` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Ultrasonic United` weightmeasure = `0.4` weightunit = `KG`
          description = `Hurricane GX: PCI-E 691 GFLOPS game-optimized` name = `Hurricane GX` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg` status = `Available` quantity = 13
          uom = `PC`
          currencycode = `EUR` price = `101.2` width = `22` depth = `35` height = `17` dimunit = `cm` )
        ( productid = `HT-1073` category = `Graphic Cards` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Smartcards` weightmeasure = `0.4` weightunit = `KG`
          description = `Hurricane GX/LN: PCI-E 691 GFLOPS game-optimized, low-noise.` name = `Hurricane GX/LN` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg` status = `Out of Stock`
          quantity = 5
          uom = `PC` currencycode = `EUR` price = `139.99` width = `22` depth = `35` height = `17` dimunit = `cm` )
        ( productid = `HT-1080` category = `Scanners` maincategory = `Printers & Scanners` taxtarifcode = `1` suppliername = `Printer for All` weightmeasure = `2.3` weightunit = `KG`
          description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - Hi-Speed USB - Bluetooth` name = `Photo Scan` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg`
          status = `Out of Stock`
          quantity = 8 uom = `PC` currencycode = `EUR` price = `129` width = `34` depth = `48` height = `5` dimunit = `cm` )
        ( productid = `HT-1081` category = `Scanners` maincategory = `Printers & Scanners` taxtarifcode = `1` suppliername = `Printer for All` weightmeasure = `2.4` weightunit = `KG`
          description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - SCSI for backward compatibility` name = `Power Scan` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg`
          status = `Out of Stock`
          quantity = 11 uom = `PC` currencycode = `EUR` price = `89` width = `31` depth = `43` height = `7` dimunit = `cm` )
        ( productid = `HT-1082` category = `Scanners` maincategory = `Printers & Scanners` taxtarifcode = `1` suppliername = `Printer for All` weightmeasure = `3.2` weightunit = `KG`
          description = `Flatbed scanner - Letter - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module` name = `Jet Scan Professional` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg`
          status = `Out of Stock` quantity = 13 uom = `PC` currencycode = `EUR` price = `169` width = `33` depth = `41` height = `12` dimunit = `cm` )
        ( productid = `HT-1083` category = `Scanners` maincategory = `Printers & Scanners` taxtarifcode = `1` suppliername = `Printer for All` weightmeasure = `3.2` weightunit = `KG`
          description = `Flatbed scanner - A4 - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module` name = `Jet Scan Professional` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg`
          status = `Available`
          quantity = 10 uom = `PC` currencycode = `EUR` price = `189` width = `35` depth = `40` height = `10` dimunit = `cm` )
        ( productid = `HT-1085` category = `Multifunction Printers` maincategory = `Printers & Scanners` taxtarifcode = `1` suppliername = `Alpha Printers` weightmeasure = `23.2` weightunit = `KG` description = `Copymaster` name = `Copymaster`
          dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg` status = `Available` quantity = 10 uom = `PC` currencycode = `EUR` price = `1499` width = `45` depth = `42` height = `22`
          dimunit = `cm` )
        ( productid = `HT-1090` category = `Speakers` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Speaker Experts` weightmeasure = `3` weightunit = `KG` description = `PC multimedia speakers - 5 Watt (Total)`
          name = `Surround Sound` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg` status = `Available` quantity = 20 uom = `PC` currencycode = `EUR` price = `39` width = `12`
          depth = `10` height = `16`
          dimunit = `cm` )
        ( productid = `HT-1091` category = `Speakers` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Speaker Experts` weightmeasure = `1.4` weightunit = `KG` description = `PC multimedia speakers - 10 Watt (Total) - 2-way`
          name = `Blaster Extreme` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg` status = `Available` quantity = 15 uom = `PC` currencycode = `EUR` price = `26` width = `13`
          depth = `11` height = `17.5`
          dimunit = `cm` )
        ( productid = `HT-1092` category = `Speakers` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Speaker Experts` weightmeasure = `2.1` weightunit = `KG`
          description = `PC multimedia speakers - optimized for Blutooth/A2DP` name = `Sound Booster` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg` status = `Discontinued`
          quantity = 50 uom = `PC`
          currencycode = `EUR` price = `45` width = `12.4` depth = `10.4` height = `18.1` dimunit = `cm` )
        ( productid = `HT-1095` category = `Accessories` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Fasttech` weightmeasure = `80` weightunit = `G` description = `5.1 Headset, 40 Hz-20 kHz, Wireless`
          name = `Lovely Sound 5.1 Wireless` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg` status = `Available` quantity = 12 uom = `PC` currencycode = `EUR` price = `49` width = `24`
          depth = `19`
          height = `23` dimunit = `cm` )
        ( productid = `HT-1096` category = `Accessories` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Fasttech` weightmeasure = `130` weightunit = `G` description = `5.1 Headset, 40 Hz-20 kHz, 3m cable`
          name = `Lovely Sound 5.1` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg` status = `Available` quantity = 18 uom = `PC` currencycode = `EUR` price = `39` width = `25`
          depth = `17` height = `19`
          dimunit = `cm` )
        ( productid = `HT-1097` category = `Accessories` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Fasttech` weightmeasure = `60` weightunit = `G` description = `5.1 Headset, 40 Hz-20 kHz, 1m cable`
          name = `Lovely Sound Stereo` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg` status = `Out of Stock` quantity = 21 uom = `PC` currencycode = `EUR` price = `29` width = `21.3`
          depth = `2.4`
          height = `19.7` dimunit = `cm` )
        ( productid = `HT-1100` category = `Software` maincategory = `Software` taxtarifcode = `1` suppliername = `Technocom` weightmeasure = `1.2` weightunit = `KG`
          description = `Complete package, 1 User, Office Applications (word processing, spreadsheet, presentations)` name = `Smart Office` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg`
          status = `Out of Stock` quantity = 25 uom = `PC` currencycode = `EUR` price = `89.9` width = `15` depth = `6.5` height = `2.1` dimunit = `cm` )
        ( productid = `HT-1101` category = `Software` maincategory = `Software` taxtarifcode = `1` suppliername = `Technocom` weightmeasure = `0.8` weightunit = `KG` description = `Complete package, 1 User, Image editing, processing`
          name = `Smart Design` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg` status = `Available` quantity = 26 uom = `PC` currencycode = `EUR` price = `79.9` width = `14`
          depth = `6.7` height = `24`
          dimunit = `cm` )
        ( productid = `HT-1102` category = `Software` maincategory = `Software` taxtarifcode = `1` suppliername = `Technocom` weightmeasure = `0.8` weightunit = `KG`
          description = `Complete package, 1 User, Network Software Utilities, Useful Applications and Documentation` name = `Smart Network` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg`
          status = `Available` quantity = 28 uom = `PC` currencycode = `EUR` price = `69` width = `16` depth = `6` height = `27` dimunit = `cm` )
        ( productid = `HT-1103` category = `Software` maincategory = `Software` taxtarifcode = `1` suppliername = `Technocom` weightmeasure = `0.8` weightunit = `KG`
          description = `Complete package, 1 User, different Multimedia applications, playing music, watching DVDs, only with this Smart package` name = `Smart Multimedia` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg` status = `Available` quantity = 9 uom = `PC` currencycode = `EUR` price = `77` width = `11` depth = `3.4` height = `22` dimunit = `cm` )
        ( productid = `HT-1104` category = `Software` maincategory = `Software` taxtarifcode = `1` suppliername = `Technocom` weightmeasure = `1.1` weightunit = `KG`
          description = `Complete package, 1 User, various games for amusement, logic, action, jump&run` name = `Smart Games` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg`
          status = `Available`
          quantity = 13 uom = `PC` currencycode = `EUR` price = `55` width = `10` depth = `3` height = `30` dimunit = `cm` )
        ( productid = `HT-1105` category = `Software` maincategory = `Software` taxtarifcode = `1` suppliername = `Brainsoft` weightmeasure = `0.7` weightunit = `KG`
          description = `Complete package, 1 User, highly recommended for internet users as anti-virus protection` name = `Smart Internet Antivirus` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg`
          status = `Available` quantity = 17 uom = `PC` currencycode = `EUR` price = `29` width = `16` depth = `4` height = `21` dimunit = `cm` )
        ( productid = `HT-1106` category = `Software` maincategory = `Software` taxtarifcode = `1` suppliername = `Brainsoft` weightmeasure = `0.9` weightunit = `KG`
          description = `Complete package, 1 User, recommended for internet users, protect your PC against cyber-crime` name = `Smart Firewall` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg`
          status = `Discontinued` quantity = 19 uom = `PC` currencycode = `EUR` price = `34` width = `17.9` depth = `4.2` height = `23.1` dimunit = `cm` )
        ( productid = `HT-1107` category = `Software` maincategory = `Software` taxtarifcode = `1` suppliername = `Brainsoft` weightmeasure = `0.5` weightunit = `KG`
          description = `Complete package, 1 User, bring your money in your mind, see what you have and what you want` name = `Smart Money` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg`
          status = `Out of Stock` quantity = 18 uom = `PC` currencycode = `EUR` price = `29.9` width = `12` depth = `1.5` height = `19` dimunit = `cm` )
        ( productid = `HT-1110` category = `Computer System Accessories` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Red Point Stores` weightmeasure = `0.03` weightunit = `KG`
          description = `Robust 3m anti-burglary protection for your laptop computer` name = `PC Lock` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg` status = `Available` quantity = 14
          uom = `PC`
          currencycode = `EUR` price = `8.9` width = `20` depth = `8` height = `4.3` dimunit = `cm` )
        ( productid = `HT-1111` category = `Computer System Accessories` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Red Point Stores` weightmeasure = `0.02` weightunit = `KG`
          description = `Robust 1m anti-burglary protection for your desktop computer` name = `Notebook Lock` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg` status = `Available`
          quantity = 20 uom = `PC`
          currencycode = `EUR` price = `6.9` width = `31` depth = `9` height = `7` dimunit = `cm` )
        ( productid = `HT-1112` category = `Computer System Accessories` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Red Point Stores` weightmeasure = `0.075` weightunit = `KG`
          description = `Color webcam, color, High-Speed USB` name = `Web cam reality` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg` status = `Out of Stock` quantity = 27 uom = `PC`
          currencycode = `EUR`
          price = `39` width = `9` depth = `8.2` height = `1.3` dimunit = `cm` )
        ( productid = `HT-1113` category = `Computer System Accessories` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Red Point Stores` weightmeasure = `0.05` weightunit = `KG` description = `10 separately packed screen wipes`
          name = `Screen clean` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg` status = `Available` quantity = 17 uom = `PC` currencycode = `EUR` price = `2.3` width = `2` depth = `2`
          height = `0.1`
          dimunit = `cm` )
        ( productid = `HT-1114` category = `Computer System Accessories` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Red Point Stores` weightmeasure = `1.8` weightunit = `KG`
          description = `Notebook bag, plenty of room for stationery and writing materials` name = `Fabric bag professional` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg`
          status = `Available`
          quantity = 14 uom = `PC` currencycode = `EUR` price = `31` width = `42` depth = `32` height = `7` dimunit = `cm` )
        ( productid = `HT-1115` category = `Telecommunications` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Red Point Stores` weightmeasure = `0.45` weightunit = `KG`
          description = `Wireless DSL Router (available in blue, black and silver)` name = `Wireless DSL Router` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg` status = `Available`
          quantity = 16
          uom = `PC` currencycode = `EUR` price = `49` width = `19.3` depth = `18` height = `5` dimunit = `cm` )
        ( productid = `HT-1116` category = `Telecommunications` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Red Point Stores` weightmeasure = `0.45` weightunit = `KG`
          description = `Wireless DSL Router / Repeater (available in blue, black and silver)` name = `Wireless DSL Router / Repeater` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg`
          status = `Out of Stock` quantity = 12 uom = `PC` currencycode = `EUR` price = `59` width = `19.3` depth = `18` height = `5` dimunit = `cm` )
        ( productid = `HT-1117` category = `Telecommunications` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Technocom` weightmeasure = `0.45` weightunit = `KG`
          description = `Wireless DSL Router / Repeater and Print Server (available in blue, black and silver)` name = `Wireless DSL Router / Repeater and Print Server` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg` status = `Available` quantity = 12 uom = `PC` currencycode = `EUR` price = `69` width = `19.3` depth = `18` height = `5` dimunit = `cm` )
        ( productid = `HT-1118` category = `Computer System Accessories` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Technocom` weightmeasure = `0.015` weightunit = `KG` description = `USB 2.0 High-Speed 64 GB`
          name = `USB Stick` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg` status = `Available` quantity = 14 uom = `PC` currencycode = `EUR` price = `35` width = `1.5` depth = `8.7`
          height = `1.2`
          dimunit = `cm` )
        ( productid = `HT-1119` category = `Accessories` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Titanium` weightmeasure = `88` weightunit = `G` description = `Universal Travel Adapter` name = `Travel Adapter`
          dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg` status = `Discontinued` quantity = 10 uom = `PC` currencycode = `EUR` price = `79` width = `2` depth = `3.1` height = `3.9`
          dimunit = `cm` )
        ( productid = `HT-1120` category = `Keyboards` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Technocom` weightmeasure = `1` weightunit = `KG` description = `Cordless Bluetooth Keyboard with English keys`
          name = `Cordless Bluetooth Keyboard, english international` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg` status = `Out of Stock` quantity = 13 uom = `PC`
          currencycode = `EUR` price = `29`
          width = `51.4` depth = `23` height = `4` dimunit = `cm` )
        ( productid = `HT-1137` category = `Flat Screen Monitors` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Technocom` weightmeasure = `18` weightunit = `KG`
          description = `Optimum Hi-Resolution max. 2048 × 1536 @ 85Hz, Dot Pitch: 0.24mm` name = `Flat XXL` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg` status = `Discontinued`
          quantity = 10 uom = `PC`
          currencycode = `EUR` price = `1430` width = `54` depth = `22` height = `38` dimunit = `cm` )
        ( productid = `HT-1138` category = `Mice` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Technocom` weightmeasure = `0.02` weightunit = `KG` description = `Portable pocket Mouse with retracting cord`
          name = `Pocket Mouse` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg` status = `Available` quantity = 20 uom = `PC` currencycode = `EUR` price = `23` width = `0.3`
          depth = `0.5` height = `1`
          dimunit = `cm` )
        ( productid = `HT-1210` category = `PCs` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Technocom` weightmeasure = `2.3` weightunit = `KG`
          description = `PC Power Station with 3,4 Ghz quad-core, 32 GB DDR3 SDRAM, feels like Available PC, Windows 8 Pro` name = `PC Power Station` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg`
          status = `Available` quantity = 22 uom = `PC` currencycode = `EUR` price = `2399` width = `28` depth = `31` height = `43` dimunit = `cm` )
        ( productid = `HT-1251` category = `Laptops` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Ultrasonic United` weightmeasure = `4.2` weightunit = `KG`
          description = `Flexible Laptop with 2,5 GHz Quad Core, 15" HD TN, 16 GB DDR SDRAM, 256 GB SSD, Windows 10 Pro` name = `Astro Laptop 1516` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg`
          status = `Available` quantity = 23 uom = `PC` currencycode = `EUR` price = `989` width = `30` depth = `18` height = `3` dimunit = `cm` )
        ( productid = `HT-1252` category = `Smartphones and Tablets` maincategory = `Smartphones & Tablets` taxtarifcode = `1` suppliername = `Ultrasonic United` weightmeasure = `0.75` weightunit = `KG`
          description = `6 inch 1280x800 HD display (216 ppi), Quad-core processor, 8 GB internal storage (actual formatted capacity will be less), 3050 mAh battery (Up to 8 hours of active use), grey or black` name = `Astro Phone 6` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg` status = `Available` quantity = 28 uom = `PC` currencycode = `EUR` price = `649` width = `8` depth = `6` height = `1.5` dimunit = `cm` )
        ( productid = `HT-1253` category = `Laptops` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Ultrasonic United` weightmeasure = `4.2` weightunit = `KG`
          description = `Flexible Laptop with 2,5 GHz Dual Core, 14" HD+ TN, 8 GB DDR SDRAM, 324 GB SSD, Windows 10 Pro` name = `Benda Laptop 1408` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg`
          status = `Discontinued` quantity = 27 uom = `PC` currencycode = `EUR` price = `976` width = `30` depth = `18` height = `3` dimunit = `cm` )
        ( productid = `HT-1254` category = `Flat Screens` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Ultrasonic United` weightmeasure = `15` weightunit = `KG`
          description = `Optimum Hi-Resolution Widescreen max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub` name = `Bending Screen 21HD` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg`
          status = `Available` quantity = 23 uom = `PC` currencycode = `EUR` price = `250` width = `37` depth = `12` height = `36` dimunit = `cm` )
        ( productid = `HT-1255` category = `Flat Screens` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Ultrasonic United` weightmeasure = `16` weightunit = `KG`
          description = `Optimum Hi-Resolution Widescreen max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub` name = `Broad Screen 22HD` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg`
          status = `Discontinued` quantity = 5 uom = `PC` currencycode = `EUR` price = `270` width = `39` depth = `12` height = `38` dimunit = `cm` )
        ( productid = `HT-1256` category = `Smartphones and Tablets` maincategory = `Smartphones & Tablets` taxtarifcode = `1` suppliername = `Ultrasonic United` weightmeasure = `0.75` weightunit = `KG`
          description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black` name = `Cerdik Phone 7`
          dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg` status = `Discontinued` quantity = 19 uom = `PC` currencycode = `EUR` price = `549` width = `9` depth = `15` height = `1.5`
          dimunit = `cm` )
        ( productid = `HT-1257` category = `Smartphones and Tablets` maincategory = `Smartphones & Tablets` taxtarifcode = `1` suppliername = `Ultrasonic United` weightmeasure = `2.8` weightunit = `KG`
          description = `10.5-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor` name = `Cepat Tablet 10.5` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg` status = `Available` quantity = 17 uom = `PC` currencycode = `EUR` price = `549` width = `48` depth = `31` height = `4.5` dimunit = `cm` )
        ( productid = `HT-1258` category = `Smartphones and Tablets` maincategory = `Smartphones & Tablets` taxtarifcode = `1` suppliername = `Ultrasonic United` weightmeasure = `2.5` weightunit = `KG`
          description = `8-inch Multitouch HD Screen (2000 x 1500) 32GB Internal Memory, Wireless N Wi-Fi, Bluetooth, GPS Enabled, 1.5 GHz Quad-Core Processor` name = `Cepat Tablet 8` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg` status = `Available` quantity = 24 uom = `PC` currencycode = `EUR` price = `529` width = `38` depth = `21` height = `3.5` dimunit = `cm` )
        ( productid = `HT-1500` category = `Servers` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Technocom` weightmeasure = `18` weightunit = `KG`
          description = `Dual socket, quad-core processing server with 1333 MHz Front Side Bus with 10Gb connectivity` name = `Server Basic` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg`
          status = `Available` quantity = 24 uom = `PC` currencycode = `EUR` price = `5000` width = `34` depth = `35` height = `23` dimunit = `cm` )
        ( productid = `HT-1501` category = `Servers` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Technocom` weightmeasure = `25` weightunit = `KG`
          description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 10Gb connectivity` name = `Server Professional` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg`
          status = `Out of Stock` quantity = 26 uom = `PC` currencycode = `EUR` price = `15000` width = `29` depth = `30` height = `27` dimunit = `cm` )
        ( productid = `HT-1502` category = `Servers` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Technocom` weightmeasure = `35` weightunit = `KG`
          description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 100Gb connectivity` name = `Server Power Pro` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg`
          status = `Available` quantity = 34 uom = `PC` currencycode = `EUR` price = `25000` width = `22` depth = `27.3` height = `37` dimunit = `cm` )
        ( productid = `HT-1600` category = `Desktop Computers` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Titanium` weightmeasure = `4.8` weightunit = `KG`
          description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Graphic Card: Proctra X, Windows 8` name = `Family PC Basic` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg`
          status = `Available` quantity = 10 uom = `PC` currencycode = `EUR` price = `600` width = `21.4` depth = `29` height = `38` dimunit = `cm` )
        ( productid = `HT-1601` category = `Desktop Computers` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Titanium` weightmeasure = `5.3` weightunit = `KG`
          description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8` name = `Family PC Pro` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg`
          status = `Available` quantity = 20 uom = `PC` currencycode = `EUR` price = `900` width = `25` depth = `31.7` height = `40.2` dimunit = `cm` )
        ( productid = `HT-1602` category = `Desktop Computers` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Titanium` weightmeasure = `5.9` weightunit = `KG`
          description = `3,4 Ghz quad core, 8 GB DDR3 SDRAM, 2000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8` name = `Gaming Monster` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg`
          status = `Available` quantity = 24 uom = `PC` currencycode = `EUR` price = `1200` width = `26.5` depth = `34` height = `47` dimunit = `cm` )
        ( productid = `HT-1603` category = `Desktop Computers` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Titanium` weightmeasure = `6.8` weightunit = `KG`
          description = `3,4 Ghz quad core, 16 GB DDR3 SDRAM, 4000 GB Hard Disc, Graphic Card: Hurricane GX, Windows 8` name = `Gaming Monster Pro` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg`
          status = `Discontinued` quantity = 25 uom = `PC` currencycode = `EUR` price = `1700` width = `27` depth = `28` height = `42` dimunit = `cm` )
        ( productid = `HT-2000` category = `Accessories` maincategory = `TV, Video & HiFi` taxtarifcode = `1` suppliername = `Titanium` weightmeasure = `0.79` weightunit = `KG` description = `7" LCD Screen, storage battery holds up to 6 hours!`
          name = `7" Widescreen Portable DVD Player w MP3` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg` status = `Available` quantity = 20 uom = `PC` currencycode = `EUR`
          price = `249.99` width = `21.4`
          depth = `19` height = `27.6` dimunit = `cm` )
        ( productid = `HT-2001` category = `Accessories` maincategory = `TV, Video & HiFi` taxtarifcode = `1` suppliername = `Titanium` weightmeasure = `0.84` weightunit = `KG` description = `10" LCD Screen, storage battery holds up to 8 hours`
          name = `10" Portable DVD player` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg` status = `Available` quantity = 21 uom = `PC` currencycode = `EUR` price = `449.99`
          width = `24` depth = `19.5`
          height = `29` dimunit = `cm` )
        ( productid = `HT-2002` category = `Accessories` maincategory = `TV, Video & HiFi` taxtarifcode = `1` suppliername = `Technocom` weightmeasure = `0.72` weightunit = `KG`
          description = `9" LCD Screen, storage holds up to 8 hours, 2 speakers included` name = `Portable DVD Player with 9" LCD Monitor` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg`
          status = `Available` quantity = 50 uom = `PC` currencycode = `EUR` price = `853.99` width = `21` depth = `16.5` height = `14` dimunit = `cm` )
        ( productid = `HT-2025` category = `Accessories` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Titanium` weightmeasure = `0.65` weightunit = `KG` description = `Organizer and protective case for 264 CDs and DVDs`
          name = `CD/DVD case: 264 sleeves` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg` status = `Discontinued` quantity = 26 uom = `PC` currencycode = `EUR` price = `44.99`
          width = `13` depth = `13`
          height = `20` dimunit = `cm` )
        ( productid = `HT-2026` category = `Accessories` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Titanium` weightmeasure = `0.2` weightunit = `KG` description = `Quality cables for notebooks and projectors`
          name = `Audio/Video Cable Kit - 4m` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg` status = `Available` quantity = 16 uom = `PC` currencycode = `EUR` price = `29.99`
          width = `21` depth = `10.2`
          height = `13` dimunit = `cm` )
        ( productid = `HT-2027` category = `Accessories` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Titanium` weightmeasure = `0.15` weightunit = `KG` description = `Removable jewel case labels, zero residues (100)`
          name = `Removable CD/DVD Laser Labels` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg` status = `Discontinued` quantity = 25 uom = `PC` currencycode = `EUR` price = `8.99`
          width = `5.5`
          depth = `2` height = `2` dimunit = `cm` )
        ( productid = `HT-6100` category = `Accessories` maincategory = `TV, Video & HiFi` taxtarifcode = `1` suppliername = `Titanium` weightmeasure = `1.7` weightunit = `KG` description = `720p, DLP Projector max. 8,45 Meter, 2D`
          name = `Beam Breaker B-1` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg` status = `Out of Stock` quantity = 32 uom = `PC` currencycode = `EUR` price = `469` width = `30.4`
          depth = `23.1`
          height = `23` dimunit = `cm` )
        ( productid = `HT-6101` category = `Accessories` maincategory = `TV, Video & HiFi` taxtarifcode = `1` suppliername = `Technocom` weightmeasure = `2` weightunit = `KG` description = `1080p, DLP max.9,34 Meter, 2D-ready`
          name = `Beam Breaker B-2` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg` status = `Available` quantity = 18 uom = `PC` currencycode = `EUR` price = `679` width = `30.4`
          depth = `23.1`
          height = `23` dimunit = `cm` )
        ( productid = `HT-6102` category = `Accessories` maincategory = `TV, Video & HiFi` taxtarifcode = `1` suppliername = `Technocom` weightmeasure = `2.5` weightunit = `KG` description = `1080p, DLP max. 12,3 Meter, 3D-ready`
          name = `Beam Breaker B-3` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg` status = `Out of Stock` quantity = 16 uom = `PC` currencycode = `EUR` price = `889` width = `30.4`
          depth = `23.1`
          height = `23` dimunit = `cm` )
        ( productid = `HT-6110` category = `Accessories` maincategory = `TV, Video & HiFi` taxtarifcode = `1` suppliername = `Fasttech` weightmeasure = `2.4` weightunit = `KG`
          description = `CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid` name = `Play Movie` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg`
          status = `Available` quantity = 15
          uom = `PC` currencycode = `EUR` price = `130` width = `37` depth = `24` height = `6` dimunit = `cm` )
        ( productid = `HT-6111` category = `Accessories` maincategory = `TV, Video & HiFi` taxtarifcode = `1` suppliername = `Fasttech` weightmeasure = `3.1` weightunit = `KG`
          description = `160 GB HDD, CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid` name = `Record Movie` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg`
          status = `Discontinued` quantity = 24 uom = `PC` currencycode = `EUR` price = `288` width = `38` depth = `26` height = `6.2` dimunit = `cm` )
        ( productid = `HT-6120` category = `Accessories` maincategory = `TV, Video & HiFi` taxtarifcode = `1` suppliername = `Fasttech` weightmeasure = `134` weightunit = `G` description = `64 GB USB Music-on-Available-Stick`
          name = `ITelo MusicStick` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg` status = `Available` quantity = 15 uom = `PC` currencycode = `EUR` price = `45` width = `1.5`
          depth = `6` height = `1`
          dimunit = `cm` )
        ( productid = `HT-6121` category = `Accessories` maincategory = `TV, Video & HiFi` taxtarifcode = `1` suppliername = `Fasttech` weightmeasure = `134` weightunit = `G` description = `ITelo Jog-Mate 64 GB HDD and Color Display, can play movies`
          name = `ITelo Jog-Mate` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg` status = `Available` quantity = 24 uom = `PC` currencycode = `EUR` price = `63` width = `5.1`
          depth = `8` height = `9.2`
          dimunit = `cm` )
        ( productid = `HT-6122` category = `Accessories` maincategory = `TV, Video & HiFi` taxtarifcode = `1` suppliername = `Fasttech` weightmeasure = `266` weightunit = `G`
          description = `MP3-Player with 40 GB HDD and Color Display, can play movies` name = `Power Pro Player 40` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg` status = `Available`
          quantity = 23
          uom = `PC` currencycode = `EUR` price = `167` width = `5.1` depth = `8` height = `9.2` dimunit = `cm` )
        ( productid = `HT-6123` category = `Accessories` maincategory = `TV, Video & HiFi` taxtarifcode = `1` suppliername = `Fasttech` weightmeasure = `267` weightunit = `G`
          description = `MP3-Player with 80 GB SSD and Color Display, can play movies` name = `Power Pro Player 80` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg` status = `Available`
          quantity = 13
          uom = `PC` currencycode = `EUR` price = `299` width = `4` depth = `6` height = `0.8` dimunit = `cm` )
        ( productid = `HT-6130` category = `Flat Screen TVs` maincategory = `TV, Video & HiFi` taxtarifcode = `1` suppliername = `Very Best Screens` weightmeasure = `2.6` weightunit = `KG` description = `32-inch, 1366x768 Pixel, 16:9, HDTV ready`
          name = `Flat Watch HD32` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg` status = `Available` quantity = 16 uom = `PC` currencycode = `EUR` price = `1459` width = `78`
          depth = `22.1`
          height = `55` dimunit = `cm` )
        ( productid = `HT-6131` category = `Flat Screen TVs` maincategory = `TV, Video & HiFi` taxtarifcode = `1` suppliername = `Very Best Screens` weightmeasure = `2.2` weightunit = `KG` description = `37-inch, 1366x768 Pixel, 16:9, HDTV ready`
          name = `Flat Watch HD37` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg` status = `Available` quantity = 14 uom = `PC` currencycode = `EUR` price = `1199` width = `99.1`
          depth = `26`
          height = `61` dimunit = `cm` )
        ( productid = `HT-6132` category = `Flat Screen TVs` maincategory = `TV, Video & HiFi` taxtarifcode = `1` suppliername = `Very Best Screens` weightmeasure = `1.8` weightunit = `KG` description = `41-inch, 1366x768 Pixel, 16:9, HDTV ready`
          name = `Flat Watch HD41` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg` status = `Discontinued` quantity = 13 uom = `PC` currencycode = `EUR` price = `899` width = `128`
          depth = `23`
          height = `79.1` dimunit = `cm` )
        ( productid = `HT-7000` category = `Accessories` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Fasttech` weightmeasure = `0.5` weightunit = `KG`
          description = `Our new multifunctional Handheld with phone function in copper` name = `Copperberry` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg` status = `Discontinued`
          quantity = 5 uom = `PC`
          currencycode = `EUR` price = `549` width = `8.1` depth = `13` height = `12.1` dimunit = `cm` )
        ( productid = `HT-7010` category = `Accessories` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Fasttech` weightmeasure = `0.5` weightunit = `KG`
          description = `Our new multifunctional Handheld with phone function in silver` name = `Silverberry` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg` status = `Discontinued`
          quantity = 9 uom = `PC`
          currencycode = `EUR` price = `549` width = `8.1` depth = `13` height = `12.1` dimunit = `cm` )
        ( productid = `HT-7020` category = `Accessories` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Fasttech` weightmeasure = `0.5` weightunit = `KG`
          description = `Our new multifunctional Handheld with phone function in gold` name = `Goldberry` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg` status = `Available`
          quantity = 11 uom = `PC`
          currencycode = `EUR` price = `549` width = `8.1` depth = `13` height = `12.1` dimunit = `cm` )
        ( productid = `HT-7030` category = `Accessories` maincategory = `Computer Components` taxtarifcode = `1` suppliername = `Fasttech` weightmeasure = `0.5` weightunit = `KG`
          description = `Our new multifunctional Handheld with phone function in platinum` name = `Platinberry` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg` status = `Available`
          quantity = 12 uom = `PC`
          currencycode = `EUR` price = `549` width = `8.1` depth = `13` height = `12.1` dimunit = `cm` )
        ( productid = `HT-8000` category = `Laptops` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Titanium` weightmeasure = `4` weightunit = `KG`
          description = `Notebook with 2,80 GHz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8` name = `ITelO FlexTop I4000` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg`
          status = `Available`
          quantity = 11 uom = `PC` currencycode = `EUR` price = `799` width = `31` depth = `19` height = `3.1` dimunit = `cm` )
        ( productid = `HT-8001` category = `Laptops` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Titanium` weightmeasure = `4.2` weightunit = `KG`
          description = `Notebook with 2,80 GHz dual core, 8 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8` name = `ITelO FlexTop I6300c` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg`
          status = `Discontinued` quantity = 20 uom = `PC` currencycode = `EUR` price = `799` width = `32` depth = `20` height = `3.4` dimunit = `cm` )
        ( productid = `HT-8002` category = `Laptops` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Titanium` weightmeasure = `3.5` weightunit = `KG`
          description = `Notebook with 2,80 GHz quad core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8` name = `ITelO FlexTop I9100` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg`
          status = `Available`
          quantity = 20 uom = `PC` currencycode = `EUR` price = `1199` width = `38` depth = `21` height = `4.1` dimunit = `cm` )
        ( productid = `HT-8003` category = `Laptops` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Titanium` weightmeasure = `3.8` weightunit = `KG`
          description = `Notebook with 2,80 GHz quad core, 8 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8` name = `ITelO FlexTop I9800` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg`
          status = `Available`
          quantity = 22 uom = `PC` currencycode = `EUR` price = `1388` width = `48` depth = `31` height = `4.5` dimunit = `cm` )
        ( productid = `HT-9991` category = `Accessories` maincategory = `Smartphones & Tablets` taxtarifcode = `1` suppliername = `Ultrasonic United` weightmeasure = `0.02` weightunit = `KG`
          description = `Button Clasp, Quality Material, 100% Leather, compatible with many smartphone models` name = `Smartphone Leather Case` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg`
          status = `Available` quantity = 12 uom = `PC` currencycode = `EUR` price = `25` width = `48` depth = `31` height = `4.5` dimunit = `cm` )
        ( productid = `HT-9992` category = `Smartphones and Tablets` maincategory = `Smartphones & Tablets` taxtarifcode = `1` suppliername = `Ultrasonic United` weightmeasure = `0.75` weightunit = `KG`
          description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black` name = `Smartphone Alpha`
          dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg` status = `Out of Stock` quantity = 13 uom = `PC` currencycode = `EUR` price = `599` width = `48` depth = `31` height = `4.5`
          dimunit = `cm` )
        ( productid = `HT-9993` category = `Smartphones and Tablets` maincategory = `Smartphones & Tablets` taxtarifcode = `1` suppliername = `Ultrasonic United` weightmeasure = `3.8` weightunit = `KG`
          description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage, 4325 mAh battery (Up to 8 hours of active use)` name = `Mini Tablet` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg` status = `Available` quantity = 10 uom = `PC` currencycode = `EUR` price = `833` width = `48` depth = `31` height = `4.5` dimunit = `cm` )
        ( productid = `HT-9994` category = `Accessories` maincategory = `TV, Video & HiFi` taxtarifcode = `1` suppliername = `Ultrasonic United` weightmeasure = `3.8` weightunit = `KG`
          description = `1920x1080 Full HD, image stabilization reduces blur, 27x Optical / 32x Extended Zoom, wide angle Lens, 2.7" wide LCD display` name = `Camcorder View` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg` status = `Out of Stock` quantity = 50 uom = `PC` currencycode = `EUR` price = `1388` width = `48` depth = `31` height = `27` dimunit = `cm` )
        ( productid = `HT-9995` category = `Accessories` maincategory = `Smartphones & Tablets` taxtarifcode = `1` suppliername = `Titanium` weightmeasure = `0.03` weightunit = `KG`
          description = `Stylish tablet pouch, protects from scratches, color: black` name = `Tablet Pouch` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg` status = `Available`
          quantity = 34 uom = `PC`
          currencycode = `EUR` price = `20` width = `25` depth = `40` height = `4.5` dimunit = `cm` )
        ( productid = `HT-9996` category = `Accessories` maincategory = `Smartphones & Tablets` taxtarifcode = `1` suppliername = `Titanium` weightmeasure = `0.03` weightunit = `KG`
          description = `Stylish tablet pouch, protects from scratches, color: black` name = `Tablet Pouch` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg` status = `Available`
          quantity = 34 uom = `PC`
          currencycode = `EUR` price = `20` width = `25` depth = `40` height = `4.5` dimunit = `cm` )
        ( productid = `HT-9997` category = `Smartphones and Tablets` maincategory = `Smartphones & Tablets` taxtarifcode = `1` suppliername = `Titanium` weightmeasure = `3.8` weightunit = `KG`
          description = `6-Inch E Ink Screen, Access To e-book Store, Adjustable Font Styles and Sizes, Stores Up To 1,000 Books` name = `e-Book Reader ReadMe` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg` status = `Available` quantity = 23 uom = `PC` currencycode = `EUR` price = `33` width = `48` depth = `31` height = `4.5` dimunit = `cm` )
        ( productid = `HT-9998` category = `Smartphones and Tablets` maincategory = `Smartphones & Tablets` taxtarifcode = `1` suppliername = `Titanium` weightmeasure = `0.75` weightunit = `KG`
          description = `5 Megapixel Camera, Wi-Fi 802.11 b/g/n, Bluetooth, GPS Available-GPS support` name = `Smartphone Beta` dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg`
          status = `Available`
          quantity = 21 uom = `PC` currencycode = `EUR` price = `30` width = `48` depth = `31` height = `4.5` dimunit = `cm` )
        ( productid = `HT-9999` category = `Tablets` maincategory = `Smartphones & Tablets` taxtarifcode = `1` suppliername = `Titanium` weightmeasure = `3.8` weightunit = `KG`
          description = `10.1-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor` name = `Maxi Tablet` dateofsale = ``
          productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg` status = `Available` quantity = 20 uom = `PC` currencycode = `EUR` price = `749` width = `48` depth = `31` height = `4.5` dimunit = `cm` )
        ( productid = `PF-1000` category = `Accessories` maincategory = `Computer Systems` taxtarifcode = `1` suppliername = `Titanium` weightmeasure = `0.01` weightunit = `KG` description = `Flyer for our product palette` name = `Flyer`
          dateofsale = `` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg` status = `Out of Stock` quantity = 33 uom = `PC` currencycode = `EUR` price = `0` width = `46` depth = `30` height = `3`
          dimunit = `cm` )
    ).

  ENDMETHOD.

ENDCLASS.
