" @keywords objectheader object header sap.m objectheadertitlesel objectattribute responsivepopover list standardlistitem
" @summary This is a Object Header with a title selection. This can be used to switch between variants of the business object being shown.
CLASS z2ui5_cl_smpc_app_502 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name          TYPE string,
             price         TYPE p LENGTH 8 DECIMALS 2,
             currencycode  TYPE string,
             weightmeasure TYPE string,
             weightunit    TYPE string,
             width         TYPE string,
             depth         TYPE string,
             height        TYPE string,
             dimunit       TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    DATA t_products TYPE ty_t_product.
    " the record the header shows - the original moves the ObjectHeader's binding
    " context to the selected row instead
    DATA sel_name          TYPE string.
    DATA sel_price         TYPE p LENGTH 8 DECIMALS 2.
    DATA sel_currencycode  TYPE string.
    DATA sel_weightmeasure TYPE string.
    DATA sel_weightunit    TYPE string.
    DATA sel_width         TYPE string.
    DATA sel_depth         TYPE string.
    DATA sel_height        TYPE string.
    DATA sel_dimunit       TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_502 IMPLEMENTATION.

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
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `ObjectHeader`
            )->a( n = `id`                 v = `idObjectHeader`
            )->a( n = `title`              v = client->_bind( sel_name )
            )->a( n = `showTitleSelector`  v = `true`
            " handleTitleSelectorPress loads Popover.fragment.xml and opens it by the
            " selector's domRef - the same popover is declared in dependents and opened
            " anchored to the pressed control
            )->a( n = `titleSelectorPress` v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                         t_arg = VALUE #( ( `myPopover` ) ( `openBy` ) ( `$event.oSource.sId` ) ) )
            )->a( n = `number`             v = |\{ parts:[\{path:'{ client->_bind( val = sel_price path = abap_true ) }'\},| &&
                                                |\{path:'{ client->_bind( val = sel_currencycode path = abap_true ) }'\}],| &&
                                                | type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
            )->a( n = `numberUnit`         v = client->_bind( sel_currencycode )
            )->a( n = `class`              v = `sapUiResponsivePadding--header`

            )->tag( `ObjectAttribute`
                )->a( n = `text` v = |{ client->_bind( sel_weightmeasure ) } { client->_bind( sel_weightunit ) }|
            )->tag( `ObjectAttribute`
                )->a( n = `text` v = |{ client->_bind( sel_width ) } x { client->_bind( sel_depth ) } x { client->_bind( sel_height ) } { client->_bind( sel_dimunit ) }|

            )->ele( `dependents`
                )->ele( `ResponsivePopover`
                    )->a( n = `id`        v = `myPopover`
                    )->a( n = `title`     v = `Select Product`
                    )->a( n = `placement` v = `Bottom`

                    )->ele( `List`
                        )->a( n = `mode`                   v = `SingleSelectMaster`
                        )->a( n = `includeItemInSelection` v = `true`
                        " handleItemSelect moves the header to the picked row and closes
                        " the popover - the row name travels, ABAP copies the record
                        )->a( n = `selectionChange`        v = client->_event( val   = `ITEM_SELECT`
                                                                               t_arg = VALUE #( ( `${$parameters>/listItem}.getTitle()` ) ) )
                        )->a( n = `items`                  v = client->_bind( t_products )

                        )->tag( `StandardListItem`
                            )->a( n = `title` v = `{NAME}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `ITEM_SELECT`.

      DATA(title) = client->get_event_arg( ).
      READ TABLE t_products INTO DATA(product) WITH KEY name = title.
      IF sy-subrc = 0.
        sel_name          = product-name.
        sel_price         = product-price.
        sel_currencycode  = product-currencycode.
        sel_weightmeasure = product-weightmeasure.
        sel_weightunit    = product-weightunit.
        sel_width         = product-width.
        sel_depth         = product-depth.
        sel_height        = product-height.
        sel_dimunit       = product-dimunit.
      ENDIF.

      " the original closes the popover from the same handler
      client->follow_up_action( val   = client->cs_event-control_by_id
                                t_arg = VALUE #( ( `myPopover` ) ( `close` ) ) ).

    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection of ui5/mock/products.json (the bound fields)
    t_products = VALUE #(
        ( name = `Notebook Basic 15`                                  price = `956`    currencycode = `EUR` weightmeasure = `4.2`   weightunit = `KG` width = `30`   depth = `18`   height = `3`    dimunit = `cm` )
        ( name = `Notebook Basic 17`                                  price = `1249`   currencycode = `EUR` weightmeasure = `4.5`   weightunit = `KG` width = `29`   depth = `17`   height = `3.1`  dimunit = `cm` )
        ( name = `Notebook Basic 18`                                  price = `1570`   currencycode = `EUR` weightmeasure = `4.2`   weightunit = `KG` width = `28`   depth = `19`   height = `2.5`  dimunit = `cm` )
        ( name = `Notebook Basic 19`                                  price = `1650`   currencycode = `EUR` weightmeasure = `4.2`   weightunit = `KG` width = `32`   depth = `21`   height = `4`    dimunit = `cm` )
        ( name = `ITelO Vault`                                        price = `299`    currencycode = `EUR` weightmeasure = `0.2`   weightunit = `KG` width = `32`   depth = `22`   height = `3`    dimunit = `cm` )
        ( name = `Notebook Professional 15`                           price = `1999`   currencycode = `EUR` weightmeasure = `4.3`   weightunit = `KG` width = `33`   depth = `20`   height = `3`    dimunit = `cm` )
        ( name = `Notebook Professional 17`                           price = `2299`   currencycode = `EUR` weightmeasure = `4.1`   weightunit = `KG` width = `33`   depth = `23`   height = `2`    dimunit = `cm` )
        ( name = `ITelO Vault Net`                                    price = `459`    currencycode = `EUR` weightmeasure = `0.16`  weightunit = `KG` width = `10`   depth = `1.8`  height = `17`   dimunit = `cm` )
        ( name = `ITelO Vault SAT`                                    price = `149`    currencycode = `EUR` weightmeasure = `0.18`  weightunit = `KG` width = `11`   depth = `1.7`  height = `18`   dimunit = `cm` )
        ( name = `Comfort Easy`                                       price = `1679`   currencycode = `EUR` weightmeasure = `0.2`   weightunit = `KG` width = `84`   depth = `1.5`  height = `14`   dimunit = `cm` )
        ( name = `Comfort Senior`                                     price = `512`    currencycode = `EUR` weightmeasure = `0.8`   weightunit = `KG` width = `80`   depth = `1.6`  height = `13`   dimunit = `cm` )
        ( name = `Ergo Screen E-I`                                    price = `230`    currencycode = `EUR` weightmeasure = `21`    weightunit = `KG` width = `37`   depth = `12`   height = `36`   dimunit = `cm` )
        ( name = `Ergo Screen E-II`                                   price = `285`    currencycode = `EUR` weightmeasure = `21`    weightunit = `KG` width = `40.8` depth = `19`   height = `43`   dimunit = `cm` )
        ( name = `Ergo Screen E-III`                                  price = `345`    currencycode = `EUR` weightmeasure = `21`    weightunit = `KG` width = `40.8` depth = `19`   height = `43`   dimunit = `cm` )
        ( name = `Flat Basic`                                         price = `399`    currencycode = `EUR` weightmeasure = `14`    weightunit = `KG` width = `39`   depth = `20`   height = `41`   dimunit = `cm` )
        ( name = `Flat Future`                                        price = `430`    currencycode = `EUR` weightmeasure = `15`    weightunit = `KG` width = `45`   depth = `26`   height = `46`   dimunit = `cm` )
        ( name = `Flat XL`                                            price = `1230`   currencycode = `EUR` weightmeasure = `17`    weightunit = `KG` width = `54.5` depth = `22.1` height = `39.1` dimunit = `cm` )
        ( name = `Laser Professional Eco`                             price = `830`    currencycode = `EUR` weightmeasure = `32`    weightunit = `KG` width = `51`   depth = `46`   height = `30`   dimunit = `cm` )
        ( name = `Laser Basic`                                        price = `490`    currencycode = `EUR` weightmeasure = `23`    weightunit = `KG` width = `48`   depth = `42`   height = `26`   dimunit = `cm` )
        ( name = `Laser Allround`                                     price = `349`    currencycode = `EUR` weightmeasure = `17`    weightunit = `KG` width = `53`   depth = `50`   height = `65`   dimunit = `cm` )
        ( name = `Ultra Jet Super Color`                              price = `139`    currencycode = `EUR` weightmeasure = `3`     weightunit = `KG` width = `41`   depth = `41`   height = `28`   dimunit = `cm` )
        ( name = `Ultra Jet Mobile`                                   price = `99`     currencycode = `EUR` weightmeasure = `1.9`   weightunit = `KG` width = `46`   depth = `32`   height = `25`   dimunit = `cm` )
        ( name = `Ultra Jet Super Highspeed`                          price = `170`    currencycode = `EUR` weightmeasure = `18`    weightunit = `KG` width = `41`   depth = `41`   height = `28`   dimunit = `cm` )
        ( name = `Multi Print`                                        price = `99`     currencycode = `EUR` weightmeasure = `6.3`   weightunit = `KG` width = `55`   depth = `45`   height = `29`   dimunit = `cm` )
        ( name = `Multi Color`                                        price = `119`    currencycode = `EUR` weightmeasure = `4.3`   weightunit = `KG` width = `51`   depth = `41.3` height = `22`   dimunit = `cm` )
        ( name = `Cordless Mouse`                                     price = `9`      currencycode = `EUR` weightmeasure = `0.09`  weightunit = `KG` width = `6`    depth = `14.5` height = `3.5`  dimunit = `cm` )
        ( name = `Speed Mouse`                                        price = `7`      currencycode = `EUR` weightmeasure = `0.09`  weightunit = `KG` width = `7`    depth = `15`   height = `3.1`  dimunit = `cm` )
        ( name = `Track Mouse`                                        price = `11`     currencycode = `EUR` weightmeasure = `0.03`  weightunit = `KG` width = `3`    depth = `7`    height = `4`    dimunit = `cm` )
        ( name = `Ergonomic Keyboard`                                 price = `14`     currencycode = `EUR` weightmeasure = `2.1`   weightunit = `KG` width = `50`   depth = `21`   height = `3.5`  dimunit = `cm` )
        ( name = `Internet Keyboard`                                  price = `16`     currencycode = `EUR` weightmeasure = `1.8`   weightunit = `KG` width = `52`   depth = `25`   height = `3`    dimunit = `cm` )
        ( name = `Media Keyboard`                                     price = `26`     currencycode = `EUR` weightmeasure = `2.3`   weightunit = `KG` width = `51.4` depth = `23`   height = `4`    dimunit = `cm` )
        ( name = `Mousepad`                                           price = `6.99`   currencycode = `EUR` weightmeasure = `80`    weightunit = `G`  width = `15`   depth = `6`    height = `0.2`  dimunit = `cm` )
        ( name = `Ergo Mousepad`                                      price = `8.99`   currencycode = `EUR` weightmeasure = `80`    weightunit = `G`  width = `15`   depth = `6`    height = `0.2`  dimunit = `cm` )
        ( name = `Designer Mousepad`                                  price = `12.99`  currencycode = `EUR` weightmeasure = `90`    weightunit = `G`  width = `24`   depth = `24`   height = `0.6`  dimunit = `cm` )
        ( name = `Universal card reader`                              price = `14`     currencycode = `EUR` weightmeasure = `45`    weightunit = `G`  width = `6`    depth = `6`    height = `3`    dimunit = `cm` )
        ( name = `Proctra X`                                          price = `70.9`   currencycode = `EUR` weightmeasure = `0.255` weightunit = `KG` width = `22`   depth = `35`   height = `17`   dimunit = `cm` )
        ( name = `Gladiator MX`                                       price = `81.7`   currencycode = `EUR` weightmeasure = `0.3`   weightunit = `KG` width = `22`   depth = `35`   height = `17`   dimunit = `cm` )
        ( name = `Hurricane GX`                                       price = `101.2`  currencycode = `EUR` weightmeasure = `0.4`   weightunit = `KG` width = `22`   depth = `35`   height = `17`   dimunit = `cm` )
        ( name = `Hurricane GX/LN`                                    price = `139.99` currencycode = `EUR` weightmeasure = `0.4`   weightunit = `KG` width = `22`   depth = `35`   height = `17`   dimunit = `cm` )
        ( name = `Photo Scan`                                         price = `129`    currencycode = `EUR` weightmeasure = `2.3`   weightunit = `KG` width = `34`   depth = `48`   height = `5`    dimunit = `cm` )
        ( name = `Power Scan`                                         price = `89`     currencycode = `EUR` weightmeasure = `2.4`   weightunit = `KG` width = `31`   depth = `43`   height = `7`    dimunit = `cm` )
        ( name = `Jet Scan Professional`                              price = `169`    currencycode = `EUR` weightmeasure = `3.2`   weightunit = `KG` width = `33`   depth = `41`   height = `12`   dimunit = `cm` )
        ( name = `Jet Scan Professional`                              price = `189`    currencycode = `EUR` weightmeasure = `3.2`   weightunit = `KG` width = `35`   depth = `40`   height = `10`   dimunit = `cm` )
        ( name = `Copymaster`                                         price = `1499`   currencycode = `EUR` weightmeasure = `23.2`  weightunit = `KG` width = `45`   depth = `42`   height = `22`   dimunit = `cm` )
        ( name = `Surround Sound`                                     price = `39`     currencycode = `EUR` weightmeasure = `3`     weightunit = `KG` width = `12`   depth = `10`   height = `16`   dimunit = `cm` )
        ( name = `Blaster Extreme`                                    price = `26`     currencycode = `EUR` weightmeasure = `1.4`   weightunit = `KG` width = `13`   depth = `11`   height = `17.5` dimunit = `cm` )
        ( name = `Sound Booster`                                      price = `45`     currencycode = `EUR` weightmeasure = `2.1`   weightunit = `KG` width = `12.4` depth = `10.4` height = `18.1` dimunit = `cm` )
        ( name = `Lovely Sound 5.1 Wireless`                          price = `49`     currencycode = `EUR` weightmeasure = `80`    weightunit = `G`  width = `24`   depth = `19`   height = `23`   dimunit = `cm` )
        ( name = `Lovely Sound 5.1`                                   price = `39`     currencycode = `EUR` weightmeasure = `130`   weightunit = `G`  width = `25`   depth = `17`   height = `19`   dimunit = `cm` )
        ( name = `Lovely Sound Stereo`                                price = `29`     currencycode = `EUR` weightmeasure = `60`    weightunit = `G`  width = `21.3` depth = `2.4`  height = `19.7` dimunit = `cm` )
        ( name = `Smart Office`                                       price = `89.9`   currencycode = `EUR` weightmeasure = `1.2`   weightunit = `KG` width = `15`   depth = `6.5`  height = `2.1`  dimunit = `cm` )
        ( name = `Smart Design`                                       price = `79.9`   currencycode = `EUR` weightmeasure = `0.8`   weightunit = `KG` width = `14`   depth = `6.7`  height = `24`   dimunit = `cm` )
        ( name = `Smart Network`                                      price = `69`     currencycode = `EUR` weightmeasure = `0.8`   weightunit = `KG` width = `16`   depth = `6`    height = `27`   dimunit = `cm` )
        ( name = `Smart Multimedia`                                   price = `77`     currencycode = `EUR` weightmeasure = `0.8`   weightunit = `KG` width = `11`   depth = `3.4`  height = `22`   dimunit = `cm` )
        ( name = `Smart Games`                                        price = `55`     currencycode = `EUR` weightmeasure = `1.1`   weightunit = `KG` width = `10`   depth = `3`    height = `30`   dimunit = `cm` )
        ( name = `Smart Internet Antivirus`                           price = `29`     currencycode = `EUR` weightmeasure = `0.7`   weightunit = `KG` width = `16`   depth = `4`    height = `21`   dimunit = `cm` )
        ( name = `Smart Firewall`                                     price = `34`     currencycode = `EUR` weightmeasure = `0.9`   weightunit = `KG` width = `17.9` depth = `4.2`  height = `23.1` dimunit = `cm` )
        ( name = `Smart Money`                                        price = `29.9`   currencycode = `EUR` weightmeasure = `0.5`   weightunit = `KG` width = `12`   depth = `1.5`  height = `19`   dimunit = `cm` )
        ( name = `PC Lock`                                            price = `8.9`    currencycode = `EUR` weightmeasure = `0.03`  weightunit = `KG` width = `20`   depth = `8`    height = `4.3`  dimunit = `cm` )
        ( name = `Notebook Lock`                                      price = `6.9`    currencycode = `EUR` weightmeasure = `0.02`  weightunit = `KG` width = `31`   depth = `9`    height = `7`    dimunit = `cm` )
        ( name = `Web cam reality`                                    price = `39`     currencycode = `EUR` weightmeasure = `0.075` weightunit = `KG` width = `9`    depth = `8.2`  height = `1.3`  dimunit = `cm` )
        ( name = `Screen clean`                                       price = `2.3`    currencycode = `EUR` weightmeasure = `0.05`  weightunit = `KG` width = `2`    depth = `2`    height = `0.1`  dimunit = `cm` )
        ( name = `Fabric bag professional`                            price = `31`     currencycode = `EUR` weightmeasure = `1.8`   weightunit = `KG` width = `42`   depth = `32`   height = `7`    dimunit = `cm` )
        ( name = `Wireless DSL Router`                                price = `49`     currencycode = `EUR` weightmeasure = `0.45`  weightunit = `KG` width = `19.3` depth = `18`   height = `5`    dimunit = `cm` )
        ( name = `Wireless DSL Router / Repeater`                     price = `59`     currencycode = `EUR` weightmeasure = `0.45`  weightunit = `KG` width = `19.3` depth = `18`   height = `5`    dimunit = `cm` )
        ( name = `Wireless DSL Router / Repeater and Print Server`    price = `69`     currencycode = `EUR` weightmeasure = `0.45`  weightunit = `KG` width = `19.3` depth = `18`   height = `5`    dimunit = `cm` )
        ( name = `USB Stick`                                          price = `35`     currencycode = `EUR` weightmeasure = `0.015` weightunit = `KG` width = `1.5`  depth = `8.7`  height = `1.2`  dimunit = `cm` )
        ( name = `Travel Adapter`                                     price = `79`     currencycode = `EUR` weightmeasure = `88`    weightunit = `G`  width = `2`    depth = `3.1`  height = `3.9`  dimunit = `cm` )
        ( name = `Cordless Bluetooth Keyboard, english international` price = `29`     currencycode = `EUR` weightmeasure = `1`     weightunit = `KG` width = `51.4` depth = `23`   height = `4`    dimunit = `cm` )
        ( name = `Flat XXL`                                           price = `1430`   currencycode = `EUR` weightmeasure = `18`    weightunit = `KG` width = `54`   depth = `22`   height = `38`   dimunit = `cm` )
        ( name = `Pocket Mouse`                                       price = `23`     currencycode = `EUR` weightmeasure = `0.02`  weightunit = `KG` width = `0.3`  depth = `0.5`  height = `1`    dimunit = `cm` )
        ( name = `PC Power Station`                                   price = `2399`   currencycode = `EUR` weightmeasure = `2.3`   weightunit = `KG` width = `28`   depth = `31`   height = `43`   dimunit = `cm` )
        ( name = `Astro Laptop 1516`                                  price = `989`    currencycode = `EUR` weightmeasure = `4.2`   weightunit = `KG` width = `30`   depth = `18`   height = `3`    dimunit = `cm` )
        ( name = `Astro Phone 6`                                      price = `649`    currencycode = `EUR` weightmeasure = `0.75`  weightunit = `KG` width = `8`    depth = `6`    height = `1.5`  dimunit = `cm` )
        ( name = `Benda Laptop 1408`                                  price = `976`    currencycode = `EUR` weightmeasure = `4.2`   weightunit = `KG` width = `30`   depth = `18`   height = `3`    dimunit = `cm` )
        ( name = `Bending Screen 21HD`                                price = `250`    currencycode = `EUR` weightmeasure = `15`    weightunit = `KG` width = `37`   depth = `12`   height = `36`   dimunit = `cm` )
        ( name = `Broad Screen 22HD`                                  price = `270`    currencycode = `EUR` weightmeasure = `16`    weightunit = `KG` width = `39`   depth = `12`   height = `38`   dimunit = `cm` )
        ( name = `Cerdik Phone 7`                                     price = `549`    currencycode = `EUR` weightmeasure = `0.75`  weightunit = `KG` width = `9`    depth = `15`   height = `1.5`  dimunit = `cm` )
        ( name = `Cepat Tablet 10.5`                                  price = `549`    currencycode = `EUR` weightmeasure = `2.8`   weightunit = `KG` width = `48`   depth = `31`   height = `4.5`  dimunit = `cm` )
        ( name = `Cepat Tablet 8`                                     price = `529`    currencycode = `EUR` weightmeasure = `2.5`   weightunit = `KG` width = `38`   depth = `21`   height = `3.5`  dimunit = `cm` )
        ( name = `Server Basic`                                       price = `5000`   currencycode = `EUR` weightmeasure = `18`    weightunit = `KG` width = `34`   depth = `35`   height = `23`   dimunit = `cm` )
        ( name = `Server Professional`                                price = `15000`  currencycode = `EUR` weightmeasure = `25`    weightunit = `KG` width = `29`   depth = `30`   height = `27`   dimunit = `cm` )
        ( name = `Server Power Pro`                                   price = `25000`  currencycode = `EUR` weightmeasure = `35`    weightunit = `KG` width = `22`   depth = `27.3` height = `37`   dimunit = `cm` )
        ( name = `Family PC Basic`                                    price = `600`    currencycode = `EUR` weightmeasure = `4.8`   weightunit = `KG` width = `21.4` depth = `29`   height = `38`   dimunit = `cm` )
        ( name = `Family PC Pro`                                      price = `900`    currencycode = `EUR` weightmeasure = `5.3`   weightunit = `KG` width = `25`   depth = `31.7` height = `40.2` dimunit = `cm` )
        ( name = `Gaming Monster`                                     price = `1200`   currencycode = `EUR` weightmeasure = `5.9`   weightunit = `KG` width = `26.5` depth = `34`   height = `47`   dimunit = `cm` )
        ( name = `Gaming Monster Pro`                                 price = `1700`   currencycode = `EUR` weightmeasure = `6.8`   weightunit = `KG` width = `27`   depth = `28`   height = `42`   dimunit = `cm` )
        ( name = `7" Widescreen Portable DVD Player w MP3`            price = `249.99` currencycode = `EUR` weightmeasure = `0.79`  weightunit = `KG` width = `21.4` depth = `19`   height = `27.6` dimunit = `cm` )
        ( name = `10" Portable DVD player`                            price = `449.99` currencycode = `EUR` weightmeasure = `0.84`  weightunit = `KG` width = `24`   depth = `19.5` height = `29`   dimunit = `cm` )
        ( name = `Portable DVD Player with 9" LCD Monitor`            price = `853.99` currencycode = `EUR` weightmeasure = `0.72`  weightunit = `KG` width = `21`   depth = `16.5` height = `14`   dimunit = `cm` )
        ( name = `CD/DVD case: 264 sleeves`                           price = `44.99`  currencycode = `EUR` weightmeasure = `0.65`  weightunit = `KG` width = `13`   depth = `13`   height = `20`   dimunit = `cm` )
        ( name = `Audio/Video Cable Kit - 4m`                         price = `29.99`  currencycode = `EUR` weightmeasure = `0.2`   weightunit = `KG` width = `21`   depth = `10.2` height = `13`   dimunit = `cm` )
        ( name = `Removable CD/DVD Laser Labels`                      price = `8.99`   currencycode = `EUR` weightmeasure = `0.15`  weightunit = `KG` width = `5.5`  depth = `2`    height = `2`    dimunit = `cm` )
        ( name = `Beam Breaker B-1`                                   price = `469`    currencycode = `EUR` weightmeasure = `1.7`   weightunit = `KG` width = `30.4` depth = `23.1` height = `23`   dimunit = `cm` )
        ( name = `Beam Breaker B-2`                                   price = `679`    currencycode = `EUR` weightmeasure = `2`     weightunit = `KG` width = `30.4` depth = `23.1` height = `23`   dimunit = `cm` )
        ( name = `Beam Breaker B-3`                                   price = `889`    currencycode = `EUR` weightmeasure = `2.5`   weightunit = `KG` width = `30.4` depth = `23.1` height = `23`   dimunit = `cm` )
        ( name = `Play Movie`                                         price = `130`    currencycode = `EUR` weightmeasure = `2.4`   weightunit = `KG` width = `37`   depth = `24`   height = `6`    dimunit = `cm` )
        ( name = `Record Movie`                                       price = `288`    currencycode = `EUR` weightmeasure = `3.1`   weightunit = `KG` width = `38`   depth = `26`   height = `6.2`  dimunit = `cm` )
        ( name = `ITelo MusicStick`                                   price = `45`     currencycode = `EUR` weightmeasure = `134`   weightunit = `G`  width = `1.5`  depth = `6`    height = `1`    dimunit = `cm` )
        ( name = `ITelo Jog-Mate`                                     price = `63`     currencycode = `EUR` weightmeasure = `134`   weightunit = `G`  width = `5.1`  depth = `8`    height = `9.2`  dimunit = `cm` )
        ( name = `Power Pro Player 40`                                price = `167`    currencycode = `EUR` weightmeasure = `266`   weightunit = `G`  width = `5.1`  depth = `8`    height = `9.2`  dimunit = `cm` )
        ( name = `Power Pro Player 80`                                price = `299`    currencycode = `EUR` weightmeasure = `267`   weightunit = `G`  width = `4`    depth = `6`    height = `0.8`  dimunit = `cm` )
        ( name = `Flat Watch HD32`                                    price = `1459`   currencycode = `EUR` weightmeasure = `2.6`   weightunit = `KG` width = `78`   depth = `22.1` height = `55`   dimunit = `cm` )
        ( name = `Flat Watch HD37`                                    price = `1199`   currencycode = `EUR` weightmeasure = `2.2`   weightunit = `KG` width = `99.1` depth = `26`   height = `61`   dimunit = `cm` )
        ( name = `Flat Watch HD41`                                    price = `899`    currencycode = `EUR` weightmeasure = `1.8`   weightunit = `KG` width = `128`  depth = `23`   height = `79.1` dimunit = `cm` )
        ( name = `Copperberry`                                        price = `549`    currencycode = `EUR` weightmeasure = `0.5`   weightunit = `KG` width = `8.1`  depth = `13`   height = `12.1` dimunit = `cm` )
        ( name = `Silverberry`                                        price = `549`    currencycode = `EUR` weightmeasure = `0.5`   weightunit = `KG` width = `8.1`  depth = `13`   height = `12.1` dimunit = `cm` )
        ( name = `Goldberry`                                          price = `549`    currencycode = `EUR` weightmeasure = `0.5`   weightunit = `KG` width = `8.1`  depth = `13`   height = `12.1` dimunit = `cm` )
        ( name = `Platinberry`                                        price = `549`    currencycode = `EUR` weightmeasure = `0.5`   weightunit = `KG` width = `8.1`  depth = `13`   height = `12.1` dimunit = `cm` )
        ( name = `ITelO FlexTop I4000`                                price = `799`    currencycode = `EUR` weightmeasure = `4`     weightunit = `KG` width = `31`   depth = `19`   height = `3.1`  dimunit = `cm` )
        ( name = `ITelO FlexTop I6300c`                               price = `799`    currencycode = `EUR` weightmeasure = `4.2`   weightunit = `KG` width = `32`   depth = `20`   height = `3.4`  dimunit = `cm` )
        ( name = `ITelO FlexTop I9100`                                price = `1199`   currencycode = `EUR` weightmeasure = `3.5`   weightunit = `KG` width = `38`   depth = `21`   height = `4.1`  dimunit = `cm` )
        ( name = `ITelO FlexTop I9800`                                price = `1388`   currencycode = `EUR` weightmeasure = `3.8`   weightunit = `KG` width = `48`   depth = `31`   height = `4.5`  dimunit = `cm` )
        ( name = `Smartphone Leather Case`                            price = `25`     currencycode = `EUR` weightmeasure = `0.02`  weightunit = `KG` width = `48`   depth = `31`   height = `4.5`  dimunit = `cm` )
        ( name = `Smartphone Alpha`                                   price = `599`    currencycode = `EUR` weightmeasure = `0.75`  weightunit = `KG` width = `48`   depth = `31`   height = `4.5`  dimunit = `cm` )
        ( name = `Mini Tablet`                                        price = `833`    currencycode = `EUR` weightmeasure = `3.8`   weightunit = `KG` width = `48`   depth = `31`   height = `4.5`  dimunit = `cm` )
        ( name = `Camcorder View`                                     price = `1388`   currencycode = `EUR` weightmeasure = `3.8`   weightunit = `KG` width = `48`   depth = `31`   height = `27`   dimunit = `cm` )
        ( name = `Tablet Pouch`                                       price = `20`     currencycode = `EUR` weightmeasure = `0.03`  weightunit = `KG` width = `25`   depth = `40`   height = `4.5`  dimunit = `cm` )
        ( name = `Tablet Pouch`                                       price = `20`     currencycode = `EUR` weightmeasure = `0.03`  weightunit = `KG` width = `25`   depth = `40`   height = `4.5`  dimunit = `cm` )
        ( name = `e-Book Reader ReadMe`                               price = `33`     currencycode = `EUR` weightmeasure = `3.8`   weightunit = `KG` width = `48`   depth = `31`   height = `4.5`  dimunit = `cm` )
        ( name = `Smartphone Beta`                                    price = `30`     currencycode = `EUR` weightmeasure = `0.75`  weightunit = `KG` width = `48`   depth = `31`   height = `4.5`  dimunit = `cm` )
        ( name = `Maxi Tablet`                                        price = `749`    currencycode = `EUR` weightmeasure = `3.8`   weightunit = `KG` width = `48`   depth = `31`   height = `4.5`  dimunit = `cm` )
        ( name = `Flyer`                                              price = `0`      currencycode = `EUR` weightmeasure = `0.01`  weightunit = `KG` width = `46`   depth = `30`   height = `3`    dimunit = `cm` ) ).

    " the header starts on /ProductCollection/0, like the original's binding
    DATA(first) = t_products[ 1 ].
    sel_name          = first-name.
    sel_price         = first-price.
    sel_currencycode  = first-currencycode.
    sel_weightmeasure = first-weightmeasure.
    sel_weightunit    = first-weightunit.
    sel_width         = first-width.
    sel_depth         = first-depth.
    sel_height        = first-height.
    sel_dimunit       = first-dimunit.

  ENDMETHOD.

ENDCLASS.
