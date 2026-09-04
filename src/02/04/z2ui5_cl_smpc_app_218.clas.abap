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
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

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
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `{0} search event is fired` INTO TABLE temp1.
    INSERT `$event.oSource.sId` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `MESSAGE_TOAST` INTO TABLE temp2.
    INSERT `show` INTO TABLE temp2.
    INSERT `{0} liveChange event value is: {1}` INTO TABLE temp2.
    INSERT `$event.oSource.sId` INTO TABLE temp2.
    INSERT `${$parameters>/newValue}` INTO TABLE temp2.
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
                    )->a( n = `search`            v = client->follow_up_action( val = client->cs_event-control_global t_arg = temp1 )
                    )->a( n = `liveChange`        v = client->follow_up_action( val = client->cs_event-control_global
                                                                                t_arg = temp2 )
                    )->a( n = `suggest`           v = client->_event( val = `SUGGEST` arg = `${$parameters>/suggestValue}` )
                    )->a( n = `enableSuggestions` v = `true`
                    )->a( n = `suggestionItems`   v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME' \} \}|

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
      DATA suggest_value TYPE string.
        DATA search_val LIKE suggest_value.
      DATA temp3 TYPE string_table.
      DATA temp5 TYPE string_table.

    IF client->get_event( ) = `SUGGEST`.
      
      suggest_value = client->get_event_arg( ).
      IF suggest_value IS INITIAL.
        json_groups = `[]`.
      ELSE.
        
        search_val = suggest_value.
        REPLACE ALL OCCURRENCES OF `\` IN search_val WITH `\\`.
        REPLACE ALL OCCURRENCES OF `"` IN search_val WITH `\"`.
        json_groups = |[[["PRODUCTID","Contains","{ search_val }"],["NAME","Contains","{ search_val }"]]]|.
      ENDIF.
      
      CLEAR temp3.
      INSERT `searchField` INTO TABLE temp3.
      INSERT `suggestionItems` INTO TABLE temp3.
      INSERT `filter` INTO TABLE temp3.
      INSERT json_groups INTO TABLE temp3.
      client->follow_up_action( val   = client->cs_event-binding_call
                                t_arg = temp3 ).
      " original: this.oSF.suggest() - reopen the suggestion popup after the
      " filter (a public non-denied method via the generalized allowlist)
      
      CLEAR temp5.
      INSERT `searchField` INTO TABLE temp5.
      INSERT `suggest` INTO TABLE temp5.
      client->follow_up_action( val   = client->cs_event-control_by_id
                                t_arg = temp5 ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection (sap/ui/demo/mock/products.json) of the original sample
    DATA temp7 LIKE t_products.
    DATA temp8 LIKE LINE OF temp7.
    CLEAR temp7.
    
    temp8-productid = `HT-1000`.
    temp8-category = `Laptops`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Very Best Screens`.
    temp8-weightmeasure = `4.2`.
    temp8-weightunit = `KG`.
    temp8-description = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.
    temp8-name = `Notebook Basic 15`.
    temp8-dateofsale = `2017-03-26`.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 10.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `956`.
    temp8-width = `30`.
    temp8-depth = `18`.
    temp8-height = `3`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1001`.
    temp8-category = `Laptops`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Very Best Screens`.
    temp8-weightmeasure = `4.5`.
    temp8-weightunit = `KG`.
    temp8-description = `Notebook Basic 17 with 2,80 GHz quad core, 17" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.
    temp8-name = `Notebook Basic 17`.
    temp8-dateofsale = `2017-04-17`.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 20.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `1249`.
    temp8-width = `29`.
    temp8-depth = `17`.
    temp8-height = `3.1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1002`.
    temp8-category = `Laptops`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Very Best Screens`.
    temp8-weightmeasure = `4.2`.
    temp8-weightunit = `KG`.
    temp8-description = `Notebook Basic 18 with 2,80 GHz quad core, 18" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`.
    temp8-name = `Notebook Basic 18`.
    temp8-dateofsale = `2017-01-07`.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 10.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `1570`.
    temp8-width = `28`.
    temp8-depth = `19`.
    temp8-height = `2.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1003`.
    temp8-category = `Laptops`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Smartcards`.
    temp8-weightmeasure = `4.2`.
    temp8-weightunit = `KG`.
    temp8-description = `Notebook Basic 19 with 2,80 GHz quad core, 19" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`.
    temp8-name = `Notebook Basic 19`.
    temp8-dateofsale = `2017-04-09`.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg`.
    temp8-status = `Out of Stock`.
    temp8-quantity = 15.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `1650`.
    temp8-width = `32`.
    temp8-depth = `21`.
    temp8-height = `4`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1007`.
    temp8-category = `Accessories`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Technocom`.
    temp8-weightmeasure = `0.2`.
    temp8-weightunit = `KG`.
    temp8-description = `Digital Organizer with State-of-the-Art Storage Encryption`.
    temp8-name = `ITelO Vault`.
    temp8-dateofsale = `2017-05-17`.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg`.
    temp8-status = `Out of Stock`.
    temp8-quantity = 15.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `299`.
    temp8-width = `32`.
    temp8-depth = `22`.
    temp8-height = `3`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1010`.
    temp8-category = `Accessories`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Very Best Screens`.
    temp8-weightmeasure = `4.3`.
    temp8-weightunit = `KG`.
    temp8-description = `Notebook Professional 15 with 2,80 GHz quad core, 15" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro`.
    temp8-name = `Notebook Professional 15`.
    temp8-dateofsale = `2017-02-22`.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg`.
    temp8-status = `Out of Stock`.
    temp8-quantity = 16.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `1999`.
    temp8-width = `33`.
    temp8-depth = `20`.
    temp8-height = `3`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1011`.
    temp8-category = `Laptops`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Very Best Screens`.
    temp8-weightmeasure = `4.1`.
    temp8-weightunit = `KG`.
    temp8-description = `Notebook Professional 17 with 2,80 GHz quad core, 17" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro`.
    temp8-name = `Notebook Professional 17`.
    temp8-dateofsale = `2017-01-02`.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg`.
    temp8-status = `Out of Stock`.
    temp8-quantity = 17.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `2299`.
    temp8-width = `33`.
    temp8-depth = `23`.
    temp8-height = `2`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1020`.
    temp8-category = `Accessories`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Technocom`.
    temp8-weightmeasure = `0.16`.
    temp8-weightunit = `KG`.
    temp8-description = `Digital Organizer with State-of-the-Art Encryption for Storage and Network Communications`.
    temp8-name = `ITelO Vault Net`.
    temp8-dateofsale = `2017-05-08`.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg`.
    temp8-status = `Discontinued`.
    temp8-quantity = 14.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `459`.
    temp8-width = `10`.
    temp8-depth = `1.8`.
    temp8-height = `17`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1021`.
    temp8-category = `Accessories`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Technocom`.
    temp8-weightmeasure = `0.18`.
    temp8-weightunit = `KG`.
    temp8-description = `Digital Organizer with State-of-the-Art Encryption for Storage and Secure Stellite Link`.
    temp8-name = `ITelO Vault SAT`.
    temp8-dateofsale = `2017-06-30`.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 50.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `149`.
    temp8-width = `11`.
    temp8-depth = `1.7`.
    temp8-height = `18`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1022`.
    temp8-category = `Accessories`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Technocom`.
    temp8-weightmeasure = `0.2`.
    temp8-weightunit = `KG`.
    temp8-description = `32 GB Digital Assistant with high-resolution color screen`.
    temp8-name = `Comfort Easy`.
    temp8-dateofsale = `2017-03-02`.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg`.
    temp8-status = `Out of Stock`.
    temp8-quantity = 30.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `1679`.
    temp8-width = `84`.
    temp8-depth = `1.5`.
    temp8-height = `14`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1023`.
    temp8-category = `Accessories`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Technocom`.
    temp8-weightmeasure = `0.8`.
    temp8-weightunit = `KG`.
    temp8-description = `64 GB Digital Assistant with high-resolution color screen and synthesized voice output`.
    temp8-name = `Comfort Senior`.
    temp8-dateofsale = `2017-02-25`.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 24.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `512`.
    temp8-width = `80`.
    temp8-depth = `1.6`.
    temp8-height = `13`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1030`.
    temp8-category = `Flat Screen Monitors`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Very Best Screens`.
    temp8-weightmeasure = `21`.
    temp8-weightunit = `KG`.
    temp8-description = `Optimum Hi-Resolution max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm`.
    temp8-name = `Ergo Screen E-I`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 14.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `230`.
    temp8-width = `37`.
    temp8-depth = `12`.
    temp8-height = `36`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1031`.
    temp8-category = `Flat Screen Monitors`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Very Best Screens`.
    temp8-weightmeasure = `21`.
    temp8-weightunit = `KG`.
    temp8-description = `Optimum Hi-Resolution max. 1920 x 1200 @ 85Hz, Dot Pitch: 0.26mm`.
    temp8-name = `Ergo Screen E-II`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 24.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `285`.
    temp8-width = `40.8`.
    temp8-depth = `19`.
    temp8-height = `43`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1032`.
    temp8-category = `Flat Screen Monitors`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Very Best Screens`.
    temp8-weightmeasure = `21`.
    temp8-weightunit = `KG`.
    temp8-description = `Optimum Hi-Resolution max. 2560 x 1440 @ 85Hz, Dot Pitch: 0.25mm`.
    temp8-name = `Ergo Screen E-III`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg`.
    temp8-status = `Out of Stock`.
    temp8-quantity = 50.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `345`.
    temp8-width = `40.8`.
    temp8-depth = `19`.
    temp8-height = `43`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1035`.
    temp8-category = `Flat Screen Monitors`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Very Best Screens`.
    temp8-weightmeasure = `14`.
    temp8-weightunit = `KG`.
    temp8-description = `Optimum Hi-Resolution max. 1600 x 1200 @ 85Hz, Dot Pitch: 0.24mm`.
    temp8-name = `Flat Basic`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 23.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `399`.
    temp8-width = `39`.
    temp8-depth = `20`.
    temp8-height = `41`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1036`.
    temp8-category = `Flat Screen Monitors`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Very Best Screens`.
    temp8-weightmeasure = `15`.
    temp8-weightunit = `KG`.
    temp8-description = `Optimum Hi-Resolution max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.26mm`.
    temp8-name = `Flat Future`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 22.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `430`.
    temp8-width = `45`.
    temp8-depth = `26`.
    temp8-height = `46`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1037`.
    temp8-category = `Flat Screen Monitors`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Very Best Screens`.
    temp8-weightmeasure = `17`.
    temp8-weightunit = `KG`.
    temp8-description = `Optimum Hi-Resolution max. 2016 x 1512 @ 85Hz, Dot Pitch: 0.24mm`.
    temp8-name = `Flat XL`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 23.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `1230`.
    temp8-width = `54.5`.
    temp8-depth = `22.1`.
    temp8-height = `39.1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1040`.
    temp8-category = `Printers`.
    temp8-maincategory = `Printers & Scanners`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Alpha Printers`.
    temp8-weightmeasure = `32`.
    temp8-weightunit = `KG`.
    temp8-description = `Print 2400 dpi image quality color documents at speeds of up to 32 ppm (color) or 36 ppm (monochrome), letter/A4. Powerful 500 MHz processor, 512MB of memory`.
    temp8-name = `Laser Professional Eco`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 21.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `830`.
    temp8-width = `51`.
    temp8-depth = `46`.
    temp8-height = `30`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1041`.
    temp8-category = `Printers`.
    temp8-maincategory = `Printers & Scanners`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Alpha Printers`.
    temp8-weightmeasure = `23`.
    temp8-weightunit = `KG`.
    temp8-description = `Up to 22 ppm color or 24 ppm monochrome A4/letter, powerful 500 MHz processor and 128MB of memory`.
    temp8-name = `Laser Basic`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 8.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `490`.
    temp8-width = `48`.
    temp8-depth = `42`.
    temp8-height = `26`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1042`.
    temp8-category = `Printers`.
    temp8-maincategory = `Printers & Scanners`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Alpha Printers`.
    temp8-weightmeasure = `17`.
    temp8-weightunit = `KG`.
    temp8-description = `Print up to 25 ppm letter and 24 ppm A4 color or monochrome, with Available first-page-out-time of less than 13 seconds for monochrome and less than 15 seconds for color`.
    temp8-name = `Laser Allround`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 9.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `349`.
    temp8-width = `53`.
    temp8-depth = `50`.
    temp8-height = `65`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1050`.
    temp8-category = `Printers`.
    temp8-maincategory = `Printers & Scanners`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Alpha Printers`.
    temp8-weightmeasure = `3`.
    temp8-weightunit = `KG`.
    temp8-description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB, Ethernet`.
    temp8-name = `Ultra Jet Super Color`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg`.
    temp8-status = `Discontinued`.
    temp8-quantity = 17.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `139`.
    temp8-width = `41`.
    temp8-depth = `41`.
    temp8-height = `28`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1051`.
    temp8-category = `Printers`.
    temp8-maincategory = `Printers & Scanners`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Printer for All`.
    temp8-weightmeasure = `1.9`.
    temp8-weightunit = `KG`.
    temp8-description = `1000 dpi x 1000 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB - excellent dimensions for the small office`.
    temp8-name = `Ultra Jet Mobile`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg`.
    temp8-status = `Discontinued`.
    temp8-quantity = 18.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `99`.
    temp8-width = `46`.
    temp8-depth = `32`.
    temp8-height = `25`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1052`.
    temp8-category = `Printers`.
    temp8-maincategory = `Printers & Scanners`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Printer for All`.
    temp8-weightmeasure = `18`.
    temp8-weightunit = `KG`.
    temp8-description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB2.0, Ethernet`.
    temp8-name = `Ultra Jet Super Highspeed`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 25.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `170`.
    temp8-width = `41`.
    temp8-depth = `41`.
    temp8-height = `28`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1055`.
    temp8-category = `Multifunction Printers`.
    temp8-maincategory = `Printers & Scanners`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Printer for All`.
    temp8-weightmeasure = `6.3`.
    temp8-weightunit = `KG`.
    temp8-description = `1000 dpi x 1000 dpi - up to 16 ppm (mono) / up to 15 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 1200dpi x 2400dpi)`.
    temp8-name = `Multi Print`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 16.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `99`.
    temp8-width = `55`.
    temp8-depth = `45`.
    temp8-height = `29`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1056`.
    temp8-category = `Multifunction Printers`.
    temp8-maincategory = `Printers & Scanners`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Printer for All`.
    temp8-weightmeasure = `4.3`.
    temp8-weightunit = `KG`.
    temp8-description = `1200 dpi x 1200 dpi - up to 25 ppm (mono) / up to 24 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 2400dpi x 4800dpi, high resolution)`.
    temp8-name = `Multi Color`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 5.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `119`.
    temp8-width = `51`.
    temp8-depth = `41.3`.
    temp8-height = `22`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1060`.
    temp8-category = `Mice`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Oxynum`.
    temp8-weightmeasure = `0.09`.
    temp8-weightunit = `KG`.
    temp8-description = `Cordless Optical USB Mice, Laptop, Color: Black, Plug&Play`.
    temp8-name = `Cordless Mouse`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 25.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `9`.
    temp8-width = `6`.
    temp8-depth = `14.5`.
    temp8-height = `3.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1061`.
    temp8-category = `Mice`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Oxynum`.
    temp8-weightmeasure = `0.09`.
    temp8-weightunit = `KG`.
    temp8-description = `Optical USB, PS/2 Mouse, Color: Blue, 3-button-functionality (incl. Scroll wheel)`.
    temp8-name = `Speed Mouse`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 12.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `7`.
    temp8-width = `7`.
    temp8-depth = `15`.
    temp8-height = `3.1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1062`.
    temp8-category = `Mice`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Oxynum`.
    temp8-weightmeasure = `0.03`.
    temp8-weightunit = `KG`.
    temp8-description = `Optical USB Mouse, Color: Red, 5-button-functionality(incl. Scroll wheel), Plug&Play`.
    temp8-name = `Track Mouse`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg`.
    temp8-status = `Discontinued`.
    temp8-quantity = 12.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `11`.
    temp8-width = `3`.
    temp8-depth = `7`.
    temp8-height = `4`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1063`.
    temp8-category = `Keyboards`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Oxynum`.
    temp8-weightmeasure = `2.1`.
    temp8-weightunit = `KG`.
    temp8-description = `Ergonomic USB Keyboard for Desktop, Plug&Play`.
    temp8-name = `Ergonomic Keyboard`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 50.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `14`.
    temp8-width = `50`.
    temp8-depth = `21`.
    temp8-height = `3.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1064`.
    temp8-category = `Keyboards`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Oxynum`.
    temp8-weightmeasure = `1.8`.
    temp8-weightunit = `KG`.
    temp8-description = `Corded Keyboard with special keys for Internet Usability, USB`.
    temp8-name = `Internet Keyboard`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg`.
    temp8-status = `Out of Stock`.
    temp8-quantity = 35.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `16`.
    temp8-width = `52`.
    temp8-depth = `25`.
    temp8-height = `3`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1065`.
    temp8-category = `Keyboards`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Oxynum`.
    temp8-weightmeasure = `2.3`.
    temp8-weightunit = `KG`.
    temp8-description = `Corded Ergonomic Keyboard with special keys for Media Usability, USB`.
    temp8-name = `Media Keyboard`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 26.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `26`.
    temp8-width = `51.4`.
    temp8-depth = `23`.
    temp8-height = `4`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1066`.
    temp8-category = `Mousepads`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Oxynum`.
    temp8-weightmeasure = `80`.
    temp8-weightunit = `G`.
    temp8-description = `Nice mouse pad with ITelO Logo`.
    temp8-name = `Mousepad`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 12.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `6.99`.
    temp8-width = `15`.
    temp8-depth = `6`.
    temp8-height = `0.2`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1067`.
    temp8-category = `Mousepads`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Oxynum`.
    temp8-weightmeasure = `80`.
    temp8-weightunit = `G`.
    temp8-description = `Ergonomic mouse pad with ITelO Logo`.
    temp8-name = `Ergo Mousepad`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg`.
    temp8-status = `Out of Stock`.
    temp8-quantity = 16.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `8.99`.
    temp8-width = `15`.
    temp8-depth = `6`.
    temp8-height = `0.2`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1068`.
    temp8-category = `Mousepads`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Fasttech`.
    temp8-weightmeasure = `90`.
    temp8-weightunit = `G`.
    temp8-description = `ITelO Mousepad Special Edition`.
    temp8-name = `Designer Mousepad`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 26.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `12.99`.
    temp8-width = `24`.
    temp8-depth = `24`.
    temp8-height = `0.6`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1069`.
    temp8-category = `Computer System Accessories`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Fasttech`.
    temp8-weightmeasure = `45`.
    temp8-weightunit = `G`.
    temp8-description = `Universal card reader`.
    temp8-name = `Universal card reader`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 22.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `14`.
    temp8-width = `6`.
    temp8-depth = `6`.
    temp8-height = `3`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1070`.
    temp8-category = `Graphic Cards`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Ultrasonic United`.
    temp8-weightmeasure = `0.255`.
    temp8-weightunit = `KG`.
    temp8-description = `Proctra X: PCI-E GDDR5 3072MB`.
    temp8-name = `Proctra X`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg`.
    temp8-status = `Out of Stock`.
    temp8-quantity = 15.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `70.9`.
    temp8-width = `22`.
    temp8-depth = `35`.
    temp8-height = `17`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1071`.
    temp8-category = `Graphic Cards`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Ultrasonic United`.
    temp8-weightmeasure = `0.3`.
    temp8-weightunit = `KG`.
    temp8-description = `Gladiator XLN: PCI-E GDDR5 3072MB DVI Out, TV Out low-noise`.
    temp8-name = `Gladiator MX`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg`.
    temp8-status = `Discontinued`.
    temp8-quantity = 16.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `81.7`.
    temp8-width = `22`.
    temp8-depth = `35`.
    temp8-height = `17`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1072`.
    temp8-category = `Graphic Cards`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Ultrasonic United`.
    temp8-weightmeasure = `0.4`.
    temp8-weightunit = `KG`.
    temp8-description = `Hurricane GX: PCI-E 691 GFLOPS game-optimized`.
    temp8-name = `Hurricane GX`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 13.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `101.2`.
    temp8-width = `22`.
    temp8-depth = `35`.
    temp8-height = `17`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1073`.
    temp8-category = `Graphic Cards`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Smartcards`.
    temp8-weightmeasure = `0.4`.
    temp8-weightunit = `KG`.
    temp8-description = `Hurricane GX/LN: PCI-E 691 GFLOPS game-optimized, low-noise.`.
    temp8-name = `Hurricane GX/LN`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg`.
    temp8-status = `Out of Stock`.
    temp8-quantity = 5.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `139.99`.
    temp8-width = `22`.
    temp8-depth = `35`.
    temp8-height = `17`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1080`.
    temp8-category = `Scanners`.
    temp8-maincategory = `Printers & Scanners`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Printer for All`.
    temp8-weightmeasure = `2.3`.
    temp8-weightunit = `KG`.
    temp8-description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - Hi-Speed USB - Bluetooth`.
    temp8-name = `Photo Scan`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg`.
    temp8-status = `Out of Stock`.
    temp8-quantity = 8.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `129`.
    temp8-width = `34`.
    temp8-depth = `48`.
    temp8-height = `5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1081`.
    temp8-category = `Scanners`.
    temp8-maincategory = `Printers & Scanners`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Printer for All`.
    temp8-weightmeasure = `2.4`.
    temp8-weightunit = `KG`.
    temp8-description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - SCSI for backward compatibility`.
    temp8-name = `Power Scan`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg`.
    temp8-status = `Out of Stock`.
    temp8-quantity = 11.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `89`.
    temp8-width = `31`.
    temp8-depth = `43`.
    temp8-height = `7`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1082`.
    temp8-category = `Scanners`.
    temp8-maincategory = `Printers & Scanners`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Printer for All`.
    temp8-weightmeasure = `3.2`.
    temp8-weightunit = `KG`.
    temp8-description = `Flatbed scanner - Letter - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module`.
    temp8-name = `Jet Scan Professional`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg`.
    temp8-status = `Out of Stock`.
    temp8-quantity = 13.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `169`.
    temp8-width = `33`.
    temp8-depth = `41`.
    temp8-height = `12`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1083`.
    temp8-category = `Scanners`.
    temp8-maincategory = `Printers & Scanners`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Printer for All`.
    temp8-weightmeasure = `3.2`.
    temp8-weightunit = `KG`.
    temp8-description = `Flatbed scanner - A4 - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module`.
    temp8-name = `Jet Scan Professional`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 10.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `189`.
    temp8-width = `35`.
    temp8-depth = `40`.
    temp8-height = `10`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1085`.
    temp8-category = `Multifunction Printers`.
    temp8-maincategory = `Printers & Scanners`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Alpha Printers`.
    temp8-weightmeasure = `23.2`.
    temp8-weightunit = `KG`.
    temp8-description = `Copymaster`.
    temp8-name = `Copymaster`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 10.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `1499`.
    temp8-width = `45`.
    temp8-depth = `42`.
    temp8-height = `22`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1090`.
    temp8-category = `Speakers`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Speaker Experts`.
    temp8-weightmeasure = `3`.
    temp8-weightunit = `KG`.
    temp8-description = `PC multimedia speakers - 5 Watt (Total)`.
    temp8-name = `Surround Sound`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 20.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `39`.
    temp8-width = `12`.
    temp8-depth = `10`.
    temp8-height = `16`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1091`.
    temp8-category = `Speakers`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Speaker Experts`.
    temp8-weightmeasure = `1.4`.
    temp8-weightunit = `KG`.
    temp8-description = `PC multimedia speakers - 10 Watt (Total) - 2-way`.
    temp8-name = `Blaster Extreme`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 15.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `26`.
    temp8-width = `13`.
    temp8-depth = `11`.
    temp8-height = `17.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1092`.
    temp8-category = `Speakers`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Speaker Experts`.
    temp8-weightmeasure = `2.1`.
    temp8-weightunit = `KG`.
    temp8-description = `PC multimedia speakers - optimized for Blutooth/A2DP`.
    temp8-name = `Sound Booster`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg`.
    temp8-status = `Discontinued`.
    temp8-quantity = 50.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `45`.
    temp8-width = `12.4`.
    temp8-depth = `10.4`.
    temp8-height = `18.1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1095`.
    temp8-category = `Accessories`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Fasttech`.
    temp8-weightmeasure = `80`.
    temp8-weightunit = `G`.
    temp8-description = `5.1 Headset, 40 Hz-20 kHz, Wireless`.
    temp8-name = `Lovely Sound 5.1 Wireless`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 12.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `49`.
    temp8-width = `24`.
    temp8-depth = `19`.
    temp8-height = `23`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1096`.
    temp8-category = `Accessories`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Fasttech`.
    temp8-weightmeasure = `130`.
    temp8-weightunit = `G`.
    temp8-description = `5.1 Headset, 40 Hz-20 kHz, 3m cable`.
    temp8-name = `Lovely Sound 5.1`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 18.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `39`.
    temp8-width = `25`.
    temp8-depth = `17`.
    temp8-height = `19`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1097`.
    temp8-category = `Accessories`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Fasttech`.
    temp8-weightmeasure = `60`.
    temp8-weightunit = `G`.
    temp8-description = `5.1 Headset, 40 Hz-20 kHz, 1m cable`.
    temp8-name = `Lovely Sound Stereo`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg`.
    temp8-status = `Out of Stock`.
    temp8-quantity = 21.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `29`.
    temp8-width = `21.3`.
    temp8-depth = `2.4`.
    temp8-height = `19.7`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1100`.
    temp8-category = `Software`.
    temp8-maincategory = `Software`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Technocom`.
    temp8-weightmeasure = `1.2`.
    temp8-weightunit = `KG`.
    temp8-description = `Complete package, 1 User, Office Applications (word processing, spreadsheet, presentations)`.
    temp8-name = `Smart Office`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg`.
    temp8-status = `Out of Stock`.
    temp8-quantity = 25.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `89.9`.
    temp8-width = `15`.
    temp8-depth = `6.5`.
    temp8-height = `2.1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1101`.
    temp8-category = `Software`.
    temp8-maincategory = `Software`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Technocom`.
    temp8-weightmeasure = `0.8`.
    temp8-weightunit = `KG`.
    temp8-description = `Complete package, 1 User, Image editing, processing`.
    temp8-name = `Smart Design`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 26.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `79.9`.
    temp8-width = `14`.
    temp8-depth = `6.7`.
    temp8-height = `24`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1102`.
    temp8-category = `Software`.
    temp8-maincategory = `Software`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Technocom`.
    temp8-weightmeasure = `0.8`.
    temp8-weightunit = `KG`.
    temp8-description = `Complete package, 1 User, Network Software Utilities, Useful Applications and Documentation`.
    temp8-name = `Smart Network`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 28.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `69`.
    temp8-width = `16`.
    temp8-depth = `6`.
    temp8-height = `27`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1103`.
    temp8-category = `Software`.
    temp8-maincategory = `Software`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Technocom`.
    temp8-weightmeasure = `0.8`.
    temp8-weightunit = `KG`.
    temp8-description = `Complete package, 1 User, different Multimedia applications, playing music, watching DVDs, only with this Smart package`.
    temp8-name = `Smart Multimedia`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 9.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `77`.
    temp8-width = `11`.
    temp8-depth = `3.4`.
    temp8-height = `22`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1104`.
    temp8-category = `Software`.
    temp8-maincategory = `Software`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Technocom`.
    temp8-weightmeasure = `1.1`.
    temp8-weightunit = `KG`.
    temp8-description = `Complete package, 1 User, various games for amusement, logic, action, jump&run`.
    temp8-name = `Smart Games`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 13.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `55`.
    temp8-width = `10`.
    temp8-depth = `3`.
    temp8-height = `30`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1105`.
    temp8-category = `Software`.
    temp8-maincategory = `Software`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Brainsoft`.
    temp8-weightmeasure = `0.7`.
    temp8-weightunit = `KG`.
    temp8-description = `Complete package, 1 User, highly recommended for internet users as anti-virus protection`.
    temp8-name = `Smart Internet Antivirus`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 17.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `29`.
    temp8-width = `16`.
    temp8-depth = `4`.
    temp8-height = `21`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1106`.
    temp8-category = `Software`.
    temp8-maincategory = `Software`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Brainsoft`.
    temp8-weightmeasure = `0.9`.
    temp8-weightunit = `KG`.
    temp8-description = `Complete package, 1 User, recommended for internet users, protect your PC against cyber-crime`.
    temp8-name = `Smart Firewall`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg`.
    temp8-status = `Discontinued`.
    temp8-quantity = 19.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `34`.
    temp8-width = `17.9`.
    temp8-depth = `4.2`.
    temp8-height = `23.1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1107`.
    temp8-category = `Software`.
    temp8-maincategory = `Software`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Brainsoft`.
    temp8-weightmeasure = `0.5`.
    temp8-weightunit = `KG`.
    temp8-description = `Complete package, 1 User, bring your money in your mind, see what you have and what you want`.
    temp8-name = `Smart Money`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg`.
    temp8-status = `Out of Stock`.
    temp8-quantity = 18.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `29.9`.
    temp8-width = `12`.
    temp8-depth = `1.5`.
    temp8-height = `19`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1110`.
    temp8-category = `Computer System Accessories`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Red Point Stores`.
    temp8-weightmeasure = `0.03`.
    temp8-weightunit = `KG`.
    temp8-description = `Robust 3m anti-burglary protection for your laptop computer`.
    temp8-name = `PC Lock`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 14.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `8.9`.
    temp8-width = `20`.
    temp8-depth = `8`.
    temp8-height = `4.3`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1111`.
    temp8-category = `Computer System Accessories`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Red Point Stores`.
    temp8-weightmeasure = `0.02`.
    temp8-weightunit = `KG`.
    temp8-description = `Robust 1m anti-burglary protection for your desktop computer`.
    temp8-name = `Notebook Lock`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 20.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `6.9`.
    temp8-width = `31`.
    temp8-depth = `9`.
    temp8-height = `7`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1112`.
    temp8-category = `Computer System Accessories`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Red Point Stores`.
    temp8-weightmeasure = `0.075`.
    temp8-weightunit = `KG`.
    temp8-description = `Color webcam, color, High-Speed USB`.
    temp8-name = `Web cam reality`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg`.
    temp8-status = `Out of Stock`.
    temp8-quantity = 27.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `39`.
    temp8-width = `9`.
    temp8-depth = `8.2`.
    temp8-height = `1.3`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1113`.
    temp8-category = `Computer System Accessories`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Red Point Stores`.
    temp8-weightmeasure = `0.05`.
    temp8-weightunit = `KG`.
    temp8-description = `10 separately packed screen wipes`.
    temp8-name = `Screen clean`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 17.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `2.3`.
    temp8-width = `2`.
    temp8-depth = `2`.
    temp8-height = `0.1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1114`.
    temp8-category = `Computer System Accessories`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Red Point Stores`.
    temp8-weightmeasure = `1.8`.
    temp8-weightunit = `KG`.
    temp8-description = `Notebook bag, plenty of room for stationery and writing materials`.
    temp8-name = `Fabric bag professional`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 14.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `31`.
    temp8-width = `42`.
    temp8-depth = `32`.
    temp8-height = `7`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1115`.
    temp8-category = `Telecommunications`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Red Point Stores`.
    temp8-weightmeasure = `0.45`.
    temp8-weightunit = `KG`.
    temp8-description = `Wireless DSL Router (available in blue, black and silver)`.
    temp8-name = `Wireless DSL Router`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 16.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `49`.
    temp8-width = `19.3`.
    temp8-depth = `18`.
    temp8-height = `5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1116`.
    temp8-category = `Telecommunications`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Red Point Stores`.
    temp8-weightmeasure = `0.45`.
    temp8-weightunit = `KG`.
    temp8-description = `Wireless DSL Router / Repeater (available in blue, black and silver)`.
    temp8-name = `Wireless DSL Router / Repeater`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg`.
    temp8-status = `Out of Stock`.
    temp8-quantity = 12.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `59`.
    temp8-width = `19.3`.
    temp8-depth = `18`.
    temp8-height = `5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1117`.
    temp8-category = `Telecommunications`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Technocom`.
    temp8-weightmeasure = `0.45`.
    temp8-weightunit = `KG`.
    temp8-description = `Wireless DSL Router / Repeater and Print Server (available in blue, black and silver)`.
    temp8-name = `Wireless DSL Router / Repeater and Print Server`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 12.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `69`.
    temp8-width = `19.3`.
    temp8-depth = `18`.
    temp8-height = `5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1118`.
    temp8-category = `Computer System Accessories`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Technocom`.
    temp8-weightmeasure = `0.015`.
    temp8-weightunit = `KG`.
    temp8-description = `USB 2.0 High-Speed 64 GB`.
    temp8-name = `USB Stick`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 14.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `35`.
    temp8-width = `1.5`.
    temp8-depth = `8.7`.
    temp8-height = `1.2`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1119`.
    temp8-category = `Accessories`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Titanium`.
    temp8-weightmeasure = `88`.
    temp8-weightunit = `G`.
    temp8-description = `Universal Travel Adapter`.
    temp8-name = `Travel Adapter`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg`.
    temp8-status = `Discontinued`.
    temp8-quantity = 10.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `79`.
    temp8-width = `2`.
    temp8-depth = `3.1`.
    temp8-height = `3.9`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1120`.
    temp8-category = `Keyboards`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Technocom`.
    temp8-weightmeasure = `1`.
    temp8-weightunit = `KG`.
    temp8-description = `Cordless Bluetooth Keyboard with English keys`.
    temp8-name = `Cordless Bluetooth Keyboard, english international`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg`.
    temp8-status = `Out of Stock`.
    temp8-quantity = 13.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `29`.
    temp8-width = `51.4`.
    temp8-depth = `23`.
    temp8-height = `4`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1137`.
    temp8-category = `Flat Screen Monitors`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Technocom`.
    temp8-weightmeasure = `18`.
    temp8-weightunit = `KG`.
    temp8-description = `Optimum Hi-Resolution max. 2048 × 1536 @ 85Hz, Dot Pitch: 0.24mm`.
    temp8-name = `Flat XXL`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg`.
    temp8-status = `Discontinued`.
    temp8-quantity = 10.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `1430`.
    temp8-width = `54`.
    temp8-depth = `22`.
    temp8-height = `38`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1138`.
    temp8-category = `Mice`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Technocom`.
    temp8-weightmeasure = `0.02`.
    temp8-weightunit = `KG`.
    temp8-description = `Portable pocket Mouse with retracting cord`.
    temp8-name = `Pocket Mouse`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 20.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `23`.
    temp8-width = `0.3`.
    temp8-depth = `0.5`.
    temp8-height = `1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1210`.
    temp8-category = `PCs`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Technocom`.
    temp8-weightmeasure = `2.3`.
    temp8-weightunit = `KG`.
    temp8-description = `PC Power Station with 3,4 Ghz quad-core, 32 GB DDR3 SDRAM, feels like Available PC, Windows 8 Pro`.
    temp8-name = `PC Power Station`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 22.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `2399`.
    temp8-width = `28`.
    temp8-depth = `31`.
    temp8-height = `43`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1251`.
    temp8-category = `Laptops`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Ultrasonic United`.
    temp8-weightmeasure = `4.2`.
    temp8-weightunit = `KG`.
    temp8-description = `Flexible Laptop with 2,5 GHz Quad Core, 15" HD TN, 16 GB DDR SDRAM, 256 GB SSD, Windows 10 Pro`.
    temp8-name = `Astro Laptop 1516`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 23.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `989`.
    temp8-width = `30`.
    temp8-depth = `18`.
    temp8-height = `3`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1252`.
    temp8-category = `Smartphones and Tablets`.
    temp8-maincategory = `Smartphones & Tablets`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Ultrasonic United`.
    temp8-weightmeasure = `0.75`.
    temp8-weightunit = `KG`.
    temp8-description = `6 inch 1280x800 HD display (216 ppi), Quad-core processor, 8 GB internal storage (actual formatted capacity will be less), 3050 mAh battery (Up to 8 hours of active use), grey or black`.
    temp8-name = `Astro Phone 6`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 28.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `649`.
    temp8-width = `8`.
    temp8-depth = `6`.
    temp8-height = `1.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1253`.
    temp8-category = `Laptops`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Ultrasonic United`.
    temp8-weightmeasure = `4.2`.
    temp8-weightunit = `KG`.
    temp8-description = `Flexible Laptop with 2,5 GHz Dual Core, 14" HD+ TN, 8 GB DDR SDRAM, 324 GB SSD, Windows 10 Pro`.
    temp8-name = `Benda Laptop 1408`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg`.
    temp8-status = `Discontinued`.
    temp8-quantity = 27.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `976`.
    temp8-width = `30`.
    temp8-depth = `18`.
    temp8-height = `3`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1254`.
    temp8-category = `Flat Screens`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Ultrasonic United`.
    temp8-weightmeasure = `15`.
    temp8-weightunit = `KG`.
    temp8-description = `Optimum Hi-Resolution Widescreen max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub`.
    temp8-name = `Bending Screen 21HD`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 23.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `250`.
    temp8-width = `37`.
    temp8-depth = `12`.
    temp8-height = `36`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1255`.
    temp8-category = `Flat Screens`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Ultrasonic United`.
    temp8-weightmeasure = `16`.
    temp8-weightunit = `KG`.
    temp8-description = `Optimum Hi-Resolution Widescreen max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub`.
    temp8-name = `Broad Screen 22HD`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg`.
    temp8-status = `Discontinued`.
    temp8-quantity = 5.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `270`.
    temp8-width = `39`.
    temp8-depth = `12`.
    temp8-height = `38`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1256`.
    temp8-category = `Smartphones and Tablets`.
    temp8-maincategory = `Smartphones & Tablets`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Ultrasonic United`.
    temp8-weightmeasure = `0.75`.
    temp8-weightunit = `KG`.
    temp8-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black`.
    temp8-name = `Cerdik Phone 7`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg`.
    temp8-status = `Discontinued`.
    temp8-quantity = 19.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `549`.
    temp8-width = `9`.
    temp8-depth = `15`.
    temp8-height = `1.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1257`.
    temp8-category = `Smartphones and Tablets`.
    temp8-maincategory = `Smartphones & Tablets`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Ultrasonic United`.
    temp8-weightmeasure = `2.8`.
    temp8-weightunit = `KG`.
    temp8-description = `10.5-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor`.
    temp8-name = `Cepat Tablet 10.5`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 17.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `549`.
    temp8-width = `48`.
    temp8-depth = `31`.
    temp8-height = `4.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1258`.
    temp8-category = `Smartphones and Tablets`.
    temp8-maincategory = `Smartphones & Tablets`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Ultrasonic United`.
    temp8-weightmeasure = `2.5`.
    temp8-weightunit = `KG`.
    temp8-description = `8-inch Multitouch HD Screen (2000 x 1500) 32GB Internal Memory, Wireless N Wi-Fi, Bluetooth, GPS Enabled, 1.5 GHz Quad-Core Processor`.
    temp8-name = `Cepat Tablet 8`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 24.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `529`.
    temp8-width = `38`.
    temp8-depth = `21`.
    temp8-height = `3.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1500`.
    temp8-category = `Servers`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Technocom`.
    temp8-weightmeasure = `18`.
    temp8-weightunit = `KG`.
    temp8-description = `Dual socket, quad-core processing server with 1333 MHz Front Side Bus with 10Gb connectivity`.
    temp8-name = `Server Basic`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 24.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `5000`.
    temp8-width = `34`.
    temp8-depth = `35`.
    temp8-height = `23`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1501`.
    temp8-category = `Servers`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Technocom`.
    temp8-weightmeasure = `25`.
    temp8-weightunit = `KG`.
    temp8-description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 10Gb connectivity`.
    temp8-name = `Server Professional`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg`.
    temp8-status = `Out of Stock`.
    temp8-quantity = 26.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `15000`.
    temp8-width = `29`.
    temp8-depth = `30`.
    temp8-height = `27`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1502`.
    temp8-category = `Servers`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Technocom`.
    temp8-weightmeasure = `35`.
    temp8-weightunit = `KG`.
    temp8-description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 100Gb connectivity`.
    temp8-name = `Server Power Pro`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 34.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `25000`.
    temp8-width = `22`.
    temp8-depth = `27.3`.
    temp8-height = `37`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1600`.
    temp8-category = `Desktop Computers`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Titanium`.
    temp8-weightmeasure = `4.8`.
    temp8-weightunit = `KG`.
    temp8-description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Graphic Card: Proctra X, Windows 8`.
    temp8-name = `Family PC Basic`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 10.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `600`.
    temp8-width = `21.4`.
    temp8-depth = `29`.
    temp8-height = `38`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1601`.
    temp8-category = `Desktop Computers`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Titanium`.
    temp8-weightmeasure = `5.3`.
    temp8-weightunit = `KG`.
    temp8-description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8`.
    temp8-name = `Family PC Pro`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 20.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `900`.
    temp8-width = `25`.
    temp8-depth = `31.7`.
    temp8-height = `40.2`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1602`.
    temp8-category = `Desktop Computers`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Titanium`.
    temp8-weightmeasure = `5.9`.
    temp8-weightunit = `KG`.
    temp8-description = `3,4 Ghz quad core, 8 GB DDR3 SDRAM, 2000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8`.
    temp8-name = `Gaming Monster`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 24.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `1200`.
    temp8-width = `26.5`.
    temp8-depth = `34`.
    temp8-height = `47`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1603`.
    temp8-category = `Desktop Computers`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Titanium`.
    temp8-weightmeasure = `6.8`.
    temp8-weightunit = `KG`.
    temp8-description = `3,4 Ghz quad core, 16 GB DDR3 SDRAM, 4000 GB Hard Disc, Graphic Card: Hurricane GX, Windows 8`.
    temp8-name = `Gaming Monster Pro`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg`.
    temp8-status = `Discontinued`.
    temp8-quantity = 25.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `1700`.
    temp8-width = `27`.
    temp8-depth = `28`.
    temp8-height = `42`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-2000`.
    temp8-category = `Accessories`.
    temp8-maincategory = `TV, Video & HiFi`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Titanium`.
    temp8-weightmeasure = `0.79`.
    temp8-weightunit = `KG`.
    temp8-description = `7" LCD Screen, storage battery holds up to 6 hours!`.
    temp8-name = `7" Widescreen Portable DVD Player w MP3`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 20.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `249.99`.
    temp8-width = `21.4`.
    temp8-depth = `19`.
    temp8-height = `27.6`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-2001`.
    temp8-category = `Accessories`.
    temp8-maincategory = `TV, Video & HiFi`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Titanium`.
    temp8-weightmeasure = `0.84`.
    temp8-weightunit = `KG`.
    temp8-description = `10" LCD Screen, storage battery holds up to 8 hours`.
    temp8-name = `10" Portable DVD player`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 21.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `449.99`.
    temp8-width = `24`.
    temp8-depth = `19.5`.
    temp8-height = `29`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-2002`.
    temp8-category = `Accessories`.
    temp8-maincategory = `TV, Video & HiFi`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Technocom`.
    temp8-weightmeasure = `0.72`.
    temp8-weightunit = `KG`.
    temp8-description = `9" LCD Screen, storage holds up to 8 hours, 2 speakers included`.
    temp8-name = `Portable DVD Player with 9" LCD Monitor`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 50.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `853.99`.
    temp8-width = `21`.
    temp8-depth = `16.5`.
    temp8-height = `14`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-2025`.
    temp8-category = `Accessories`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Titanium`.
    temp8-weightmeasure = `0.65`.
    temp8-weightunit = `KG`.
    temp8-description = `Organizer and protective case for 264 CDs and DVDs`.
    temp8-name = `CD/DVD case: 264 sleeves`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg`.
    temp8-status = `Discontinued`.
    temp8-quantity = 26.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `44.99`.
    temp8-width = `13`.
    temp8-depth = `13`.
    temp8-height = `20`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-2026`.
    temp8-category = `Accessories`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Titanium`.
    temp8-weightmeasure = `0.2`.
    temp8-weightunit = `KG`.
    temp8-description = `Quality cables for notebooks and projectors`.
    temp8-name = `Audio/Video Cable Kit - 4m`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 16.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `29.99`.
    temp8-width = `21`.
    temp8-depth = `10.2`.
    temp8-height = `13`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-2027`.
    temp8-category = `Accessories`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Titanium`.
    temp8-weightmeasure = `0.15`.
    temp8-weightunit = `KG`.
    temp8-description = `Removable jewel case labels, zero residues (100)`.
    temp8-name = `Removable CD/DVD Laser Labels`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg`.
    temp8-status = `Discontinued`.
    temp8-quantity = 25.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `8.99`.
    temp8-width = `5.5`.
    temp8-depth = `2`.
    temp8-height = `2`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6100`.
    temp8-category = `Accessories`.
    temp8-maincategory = `TV, Video & HiFi`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Titanium`.
    temp8-weightmeasure = `1.7`.
    temp8-weightunit = `KG`.
    temp8-description = `720p, DLP Projector max. 8,45 Meter, 2D`.
    temp8-name = `Beam Breaker B-1`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg`.
    temp8-status = `Out of Stock`.
    temp8-quantity = 32.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `469`.
    temp8-width = `30.4`.
    temp8-depth = `23.1`.
    temp8-height = `23`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6101`.
    temp8-category = `Accessories`.
    temp8-maincategory = `TV, Video & HiFi`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Technocom`.
    temp8-weightmeasure = `2`.
    temp8-weightunit = `KG`.
    temp8-description = `1080p, DLP max.9,34 Meter, 2D-ready`.
    temp8-name = `Beam Breaker B-2`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 18.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `679`.
    temp8-width = `30.4`.
    temp8-depth = `23.1`.
    temp8-height = `23`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6102`.
    temp8-category = `Accessories`.
    temp8-maincategory = `TV, Video & HiFi`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Technocom`.
    temp8-weightmeasure = `2.5`.
    temp8-weightunit = `KG`.
    temp8-description = `1080p, DLP max. 12,3 Meter, 3D-ready`.
    temp8-name = `Beam Breaker B-3`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg`.
    temp8-status = `Out of Stock`.
    temp8-quantity = 16.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `889`.
    temp8-width = `30.4`.
    temp8-depth = `23.1`.
    temp8-height = `23`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6110`.
    temp8-category = `Accessories`.
    temp8-maincategory = `TV, Video & HiFi`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Fasttech`.
    temp8-weightmeasure = `2.4`.
    temp8-weightunit = `KG`.
    temp8-description = `CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid`.
    temp8-name = `Play Movie`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 15.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `130`.
    temp8-width = `37`.
    temp8-depth = `24`.
    temp8-height = `6`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6111`.
    temp8-category = `Accessories`.
    temp8-maincategory = `TV, Video & HiFi`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Fasttech`.
    temp8-weightmeasure = `3.1`.
    temp8-weightunit = `KG`.
    temp8-description = `160 GB HDD, CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid`.
    temp8-name = `Record Movie`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg`.
    temp8-status = `Discontinued`.
    temp8-quantity = 24.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `288`.
    temp8-width = `38`.
    temp8-depth = `26`.
    temp8-height = `6.2`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6120`.
    temp8-category = `Accessories`.
    temp8-maincategory = `TV, Video & HiFi`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Fasttech`.
    temp8-weightmeasure = `134`.
    temp8-weightunit = `G`.
    temp8-description = `64 GB USB Music-on-Available-Stick`.
    temp8-name = `ITelo MusicStick`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 15.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `45`.
    temp8-width = `1.5`.
    temp8-depth = `6`.
    temp8-height = `1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6121`.
    temp8-category = `Accessories`.
    temp8-maincategory = `TV, Video & HiFi`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Fasttech`.
    temp8-weightmeasure = `134`.
    temp8-weightunit = `G`.
    temp8-description = `ITelo Jog-Mate 64 GB HDD and Color Display, can play movies`.
    temp8-name = `ITelo Jog-Mate`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 24.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `63`.
    temp8-width = `5.1`.
    temp8-depth = `8`.
    temp8-height = `9.2`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6122`.
    temp8-category = `Accessories`.
    temp8-maincategory = `TV, Video & HiFi`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Fasttech`.
    temp8-weightmeasure = `266`.
    temp8-weightunit = `G`.
    temp8-description = `MP3-Player with 40 GB HDD and Color Display, can play movies`.
    temp8-name = `Power Pro Player 40`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 23.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `167`.
    temp8-width = `5.1`.
    temp8-depth = `8`.
    temp8-height = `9.2`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6123`.
    temp8-category = `Accessories`.
    temp8-maincategory = `TV, Video & HiFi`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Fasttech`.
    temp8-weightmeasure = `267`.
    temp8-weightunit = `G`.
    temp8-description = `MP3-Player with 80 GB SSD and Color Display, can play movies`.
    temp8-name = `Power Pro Player 80`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 13.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `299`.
    temp8-width = `4`.
    temp8-depth = `6`.
    temp8-height = `0.8`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6130`.
    temp8-category = `Flat Screen TVs`.
    temp8-maincategory = `TV, Video & HiFi`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Very Best Screens`.
    temp8-weightmeasure = `2.6`.
    temp8-weightunit = `KG`.
    temp8-description = `32-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    temp8-name = `Flat Watch HD32`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 16.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `1459`.
    temp8-width = `78`.
    temp8-depth = `22.1`.
    temp8-height = `55`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6131`.
    temp8-category = `Flat Screen TVs`.
    temp8-maincategory = `TV, Video & HiFi`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Very Best Screens`.
    temp8-weightmeasure = `2.2`.
    temp8-weightunit = `KG`.
    temp8-description = `37-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    temp8-name = `Flat Watch HD37`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 14.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `1199`.
    temp8-width = `99.1`.
    temp8-depth = `26`.
    temp8-height = `61`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6132`.
    temp8-category = `Flat Screen TVs`.
    temp8-maincategory = `TV, Video & HiFi`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Very Best Screens`.
    temp8-weightmeasure = `1.8`.
    temp8-weightunit = `KG`.
    temp8-description = `41-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    temp8-name = `Flat Watch HD41`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg`.
    temp8-status = `Discontinued`.
    temp8-quantity = 13.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `899`.
    temp8-width = `128`.
    temp8-depth = `23`.
    temp8-height = `79.1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-7000`.
    temp8-category = `Accessories`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Fasttech`.
    temp8-weightmeasure = `0.5`.
    temp8-weightunit = `KG`.
    temp8-description = `Our new multifunctional Handheld with phone function in copper`.
    temp8-name = `Copperberry`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg`.
    temp8-status = `Discontinued`.
    temp8-quantity = 5.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `549`.
    temp8-width = `8.1`.
    temp8-depth = `13`.
    temp8-height = `12.1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-7010`.
    temp8-category = `Accessories`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Fasttech`.
    temp8-weightmeasure = `0.5`.
    temp8-weightunit = `KG`.
    temp8-description = `Our new multifunctional Handheld with phone function in silver`.
    temp8-name = `Silverberry`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg`.
    temp8-status = `Discontinued`.
    temp8-quantity = 9.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `549`.
    temp8-width = `8.1`.
    temp8-depth = `13`.
    temp8-height = `12.1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-7020`.
    temp8-category = `Accessories`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Fasttech`.
    temp8-weightmeasure = `0.5`.
    temp8-weightunit = `KG`.
    temp8-description = `Our new multifunctional Handheld with phone function in gold`.
    temp8-name = `Goldberry`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 11.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `549`.
    temp8-width = `8.1`.
    temp8-depth = `13`.
    temp8-height = `12.1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-7030`.
    temp8-category = `Accessories`.
    temp8-maincategory = `Computer Components`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Fasttech`.
    temp8-weightmeasure = `0.5`.
    temp8-weightunit = `KG`.
    temp8-description = `Our new multifunctional Handheld with phone function in platinum`.
    temp8-name = `Platinberry`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 12.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `549`.
    temp8-width = `8.1`.
    temp8-depth = `13`.
    temp8-height = `12.1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-8000`.
    temp8-category = `Laptops`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Titanium`.
    temp8-weightmeasure = `4`.
    temp8-weightunit = `KG`.
    temp8-description = `Notebook with 2,80 GHz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8`.
    temp8-name = `ITelO FlexTop I4000`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 11.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `799`.
    temp8-width = `31`.
    temp8-depth = `19`.
    temp8-height = `3.1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-8001`.
    temp8-category = `Laptops`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Titanium`.
    temp8-weightmeasure = `4.2`.
    temp8-weightunit = `KG`.
    temp8-description = `Notebook with 2,80 GHz dual core, 8 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8`.
    temp8-name = `ITelO FlexTop I6300c`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg`.
    temp8-status = `Discontinued`.
    temp8-quantity = 20.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `799`.
    temp8-width = `32`.
    temp8-depth = `20`.
    temp8-height = `3.4`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-8002`.
    temp8-category = `Laptops`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Titanium`.
    temp8-weightmeasure = `3.5`.
    temp8-weightunit = `KG`.
    temp8-description = `Notebook with 2,80 GHz quad core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8`.
    temp8-name = `ITelO FlexTop I9100`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 20.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `1199`.
    temp8-width = `38`.
    temp8-depth = `21`.
    temp8-height = `4.1`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-8003`.
    temp8-category = `Laptops`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Titanium`.
    temp8-weightmeasure = `3.8`.
    temp8-weightunit = `KG`.
    temp8-description = `Notebook with 2,80 GHz quad core, 8 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8`.
    temp8-name = `ITelO FlexTop I9800`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 22.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `1388`.
    temp8-width = `48`.
    temp8-depth = `31`.
    temp8-height = `4.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-9991`.
    temp8-category = `Accessories`.
    temp8-maincategory = `Smartphones & Tablets`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Ultrasonic United`.
    temp8-weightmeasure = `0.02`.
    temp8-weightunit = `KG`.
    temp8-description = `Button Clasp, Quality Material, 100% Leather, compatible with many smartphone models`.
    temp8-name = `Smartphone Leather Case`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 12.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `25`.
    temp8-width = `48`.
    temp8-depth = `31`.
    temp8-height = `4.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-9992`.
    temp8-category = `Smartphones and Tablets`.
    temp8-maincategory = `Smartphones & Tablets`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Ultrasonic United`.
    temp8-weightmeasure = `0.75`.
    temp8-weightunit = `KG`.
    temp8-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black`.
    temp8-name = `Smartphone Alpha`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg`.
    temp8-status = `Out of Stock`.
    temp8-quantity = 13.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `599`.
    temp8-width = `48`.
    temp8-depth = `31`.
    temp8-height = `4.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-9993`.
    temp8-category = `Smartphones and Tablets`.
    temp8-maincategory = `Smartphones & Tablets`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Ultrasonic United`.
    temp8-weightmeasure = `3.8`.
    temp8-weightunit = `KG`.
    temp8-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage, 4325 mAh battery (Up to 8 hours of active use)`.
    temp8-name = `Mini Tablet`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 10.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `833`.
    temp8-width = `48`.
    temp8-depth = `31`.
    temp8-height = `4.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-9994`.
    temp8-category = `Accessories`.
    temp8-maincategory = `TV, Video & HiFi`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Ultrasonic United`.
    temp8-weightmeasure = `3.8`.
    temp8-weightunit = `KG`.
    temp8-description = `1920x1080 Full HD, image stabilization reduces blur, 27x Optical / 32x Extended Zoom, wide angle Lens, 2.7" wide LCD display`.
    temp8-name = `Camcorder View`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg`.
    temp8-status = `Out of Stock`.
    temp8-quantity = 50.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `1388`.
    temp8-width = `48`.
    temp8-depth = `31`.
    temp8-height = `27`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-9995`.
    temp8-category = `Accessories`.
    temp8-maincategory = `Smartphones & Tablets`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Titanium`.
    temp8-weightmeasure = `0.03`.
    temp8-weightunit = `KG`.
    temp8-description = `Stylish tablet pouch, protects from scratches, color: black`.
    temp8-name = `Tablet Pouch`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 34.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `20`.
    temp8-width = `25`.
    temp8-depth = `40`.
    temp8-height = `4.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-9996`.
    temp8-category = `Accessories`.
    temp8-maincategory = `Smartphones & Tablets`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Titanium`.
    temp8-weightmeasure = `0.03`.
    temp8-weightunit = `KG`.
    temp8-description = `Stylish tablet pouch, protects from scratches, color: black`.
    temp8-name = `Tablet Pouch`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 34.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `20`.
    temp8-width = `25`.
    temp8-depth = `40`.
    temp8-height = `4.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-9997`.
    temp8-category = `Smartphones and Tablets`.
    temp8-maincategory = `Smartphones & Tablets`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Titanium`.
    temp8-weightmeasure = `3.8`.
    temp8-weightunit = `KG`.
    temp8-description = `6-Inch E Ink Screen, Access To e-book Store, Adjustable Font Styles and Sizes, Stores Up To 1,000 Books`.
    temp8-name = `e-Book Reader ReadMe`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 23.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `33`.
    temp8-width = `48`.
    temp8-depth = `31`.
    temp8-height = `4.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-9998`.
    temp8-category = `Smartphones and Tablets`.
    temp8-maincategory = `Smartphones & Tablets`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Titanium`.
    temp8-weightmeasure = `0.75`.
    temp8-weightunit = `KG`.
    temp8-description = `5 Megapixel Camera, Wi-Fi 802.11 b/g/n, Bluetooth, GPS Available-GPS support`.
    temp8-name = `Smartphone Beta`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 21.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `30`.
    temp8-width = `48`.
    temp8-depth = `31`.
    temp8-height = `4.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-9999`.
    temp8-category = `Tablets`.
    temp8-maincategory = `Smartphones & Tablets`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Titanium`.
    temp8-weightmeasure = `3.8`.
    temp8-weightunit = `KG`.
    temp8-description = `10.1-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor`.
    temp8-name = `Maxi Tablet`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg`.
    temp8-status = `Available`.
    temp8-quantity = 20.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `749`.
    temp8-width = `48`.
    temp8-depth = `31`.
    temp8-height = `4.5`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `PF-1000`.
    temp8-category = `Accessories`.
    temp8-maincategory = `Computer Systems`.
    temp8-taxtarifcode = `1`.
    temp8-suppliername = `Titanium`.
    temp8-weightmeasure = `0.01`.
    temp8-weightunit = `KG`.
    temp8-description = `Flyer for our product palette`.
    temp8-name = `Flyer`.
    temp8-dateofsale = ``.
    temp8-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg`.
    temp8-status = `Out of Stock`.
    temp8-quantity = 33.
    temp8-uom = `PC`.
    temp8-currencycode = `EUR`.
    temp8-price = `0`.
    temp8-width = `46`.
    temp8-depth = `30`.
    temp8-height = `3`.
    temp8-dimunit = `cm`.
    INSERT temp8 INTO TABLE temp7.
    t_products = temp7.

  ENDMETHOD.

ENDCLASS.
