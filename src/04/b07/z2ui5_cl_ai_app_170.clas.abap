CLASS z2ui5_cl_ai_app_170 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_row,
        name         TYPE string,
        productid    TYPE string,
        suppliername TYPE string,
        width        TYPE i,
        depth        TYPE i,
        height       TYPE i,
        dimunit      TYPE string,
        price        TYPE p LENGTH 13 DECIMALS 2,
        currencycode TYPE string,
      END OF ty_row.
    DATA productcollection TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.

    DATA headerexpanded TYPE abap_bool.
    DATA titleclickable TYPE abap_bool.
    DATA showfooter     TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_ai_app_170 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " sap.f.DynamicPage (freestyle) - title/header/content/footer. headerExpanded,
    " toggleHeaderOnTitleClick and showFooter are two-way bound to model flags
    " (the original toggles showFooter imperatively; the faithful abap2UI5 form
    " binds it). The Products table keeps the original sorter + Currency composite
    " type bindings 1:1. The controller's Card popover (onPressOpenPopover) and
    " areaShrinkRatio toggle (Edit) have no bindable path and are dropped (declared).
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:f`      v = `sap.f`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `height`       v = `100%`

        )->open( n = `DynamicPage` ns = `f`
            )->a( n = `id`                       v = `dynamicPageId`
            )->a( n = `headerExpanded`           v = client->_bind( headerexpanded )
            )->a( n = `toggleHeaderOnTitleClick` v = client->_bind( titleclickable )
            )->a( n = `showFooter`               v = client->_bind( showfooter )

            )->open( n = `title` ns = `f`
                )->open( n = `DynamicPageTitle` ns = `f`

                    )->open( n = `heading` ns = `f`
                        )->leaf( `Title`
                            )->a( n = `text` v = `Header Title`

                    )->shut(

                    )->open( n = `breadcrumbs` ns = `f`
                        )->open( `Breadcrumbs`
                            )->leaf( `Link`
                                )->a( n = `text` v = `Home`
                            )->leaf( `Link`
                                )->a( n = `text` v = `Page 1`
                            )->leaf( `Link`
                                )->a( n = `text` v = `Page 2`
                            )->leaf( `Link`
                                )->a( n = `text` v = `Page 3`
                            )->leaf( `Link`
                                )->a( n = `text` v = `Page 4`
                            )->leaf( `Link`
                                )->a( n = `text` v = `Page 5`

                    )->shut(
                    )->shut(

                    )->open( n = `expandedContent` ns = `f`
                        )->leaf( `Label`
                            )->a( n = `text` v = `This is a subheading`

                    )->shut(

                    )->open( n = `snappedContent` ns = `f`
                        )->leaf( `Label`
                            )->a( n = `text` v = `This is a subheading`

                    )->shut(

                    )->open( n = `snappedTitleOnMobile` ns = `f`
                        )->leaf( `Title`
                            )->a( n = `text` v = `This is a subheading`

                    )->shut(

                    )->open( n = `content` ns = `f`
                        )->open( `OverflowToolbar`
                            )->open( `GenericTag`
                                )->a( n = `text`   v = `SR`
                                )->a( n = `status` v = `Error`
                                )->a( n = `design` v = `StatusIconHidden`
                                )->leaf( `ObjectNumber`
                                    )->a( n = `number`     v = `2`
                                    )->a( n = `unit`       v = `M`
                                    )->a( n = `emphasized` v = `false`
                                    )->a( n = `state`      v = `Error`

                    )->shut(
                    )->shut(
                    )->shut(

                    )->open( n = `actions` ns = `f`
                        )->leaf( `Button`
                            )->a( n = `text` v = `Edit`
                            )->a( n = `type` v = `Emphasized`
                        )->leaf( `Button`
                            )->a( n = `text` v = `Delete`
                            )->a( n = `type` v = `Transparent`
                        )->leaf( `Button`
                            )->a( n = `text` v = `Copy`
                            )->a( n = `type` v = `Transparent`
                        )->leaf( `Button`
                            )->a( n = `text`  v = `Toggle Footer`
                            )->a( n = `type`  v = `Transparent`
                            )->a( n = `press` v = client->_event( `TOGGLE_FOOTER` )
                        )->leaf( `Button`
                            )->a( n = `icon` v = `sap-icon://action`
                            )->a( n = `type` v = `Transparent`

                        )->open( `Button`
                            )->a( n = `text` v = `Button with layoutData`
                            )->a( n = `type` v = `Transparent`
                            )->open( `layoutData`
                                )->leaf( `OverflowToolbarLayoutData`
                                    )->a( n = `priority`                  v = `AlwaysOverflow`
                                    )->a( n = `closeOverflowOnInteraction` v = `false`

                    )->shut(
                    )->shut(
                    )->shut(

                    )->open( n = `navigationActions` ns = `f`
                        )->leaf( `Button`
                            )->a( n = `icon` v = `sap-icon://full-screen`
                            )->a( n = `type` v = `Transparent`
                        )->leaf( `Button`
                            )->a( n = `icon` v = `sap-icon://decline`
                            )->a( n = `type` v = `Transparent`

                    )->shut(
                    )->shut(
                )->shut(

            )->open( n = `header` ns = `f`
                )->open( n = `DynamicPageHeader` ns = `f`
                    )->a( n = `pinnable` v = `true`
                    )->open( n = `HorizontalLayout` ns = `layout`
                        )->a( n = `allowWrapping` v = `true`

                        )->open( n = `VerticalLayout` ns = `layout`
                            )->a( n = `class` v = `sapUiMediumMarginEnd`
                            )->leaf( `ObjectAttribute`
                                )->a( n = `title` v = `Location`
                                )->a( n = `text`  v = `Warehouse A`
                            )->leaf( `ObjectAttribute`
                                )->a( n = `title` v = `Halway`
                                )->a( n = `text`  v = `23L`
                            )->leaf( `ObjectAttribute`
                                )->a( n = `title` v = `Rack`
                                )->a( n = `text`  v = `34`

                        )->shut(

                        )->open( n = `VerticalLayout` ns = `layout`
                            )->leaf( `ObjectAttribute`
                                )->a( n = `title` v = `Availability`
                            )->leaf( `ObjectStatus`
                                )->a( n = `text`  v = `In Stock`
                                )->a( n = `state` v = `Success`

                    )->shut(
                    )->shut(
                    )->shut(
                )->shut(

            )->open( n = `content` ns = `f`
                )->open( `Table`
                    )->a( n = `id`     v = `idProductsTable`
                    )->a( n = `sticky` v = `HeaderToolbar,ColumnHeaders`
                    )->a( n = `inset`  v = `false`
                    )->a( n = `items`  v = |\{ path: '{ client->_bind( val = productcollection path = abap_true ) }', sorter: \{ path: 'NAME' \} \}|
                    )->a( n = `class`  v = `sapFDynamicPageAlignContent`
                    )->a( n = `width`  v = `auto`

                    )->open( `headerToolbar`
                        )->open( `Toolbar`
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
                            )->a( n = `hAlign`         v = `End`
                            )->leaf( `Text`
                                )->a( n = `text` v = `Dimensions`

                        )->shut(

                        )->open( `Column`
                            )->a( n = `hAlign` v = `End`
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
                                    )->a( n = `number` v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCYCODE'\}], type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
                                    )->a( n = `unit`   v = `{CURRENCYCODE}`

                    )->shut(
                    )->shut(
                    )->shut(
                )->shut(
            )->shut(

            )->open( n = `footer` ns = `f`
                )->open( `OverflowToolbar`
                    )->leaf( `ToolbarSpacer`
                    )->leaf( `Button`
                        )->a( n = `type` v = `Accept`
                        )->a( n = `text` v = `Accept`
                    )->leaf( `Button`
                        )->a( n = `type` v = `Reject`
                        )->a( n = `text` v = `Reject`

            )->shut(
            )->shut(
        )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.
      WHEN `TOGGLE_FOOTER`.
        showfooter = xsdbool( showfooter = abap_false ).
        view_display( ).
    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " the DynamicPage starts with an expanded, click-toggleable header and a
    " hidden footer (the original's default state; the footer is revealed by the
    " Toggle Footer action)
    headerexpanded = abap_true.
    titleclickable = abap_true.
    showfooter     = abap_false.

    " the shared 123-row demo ProductCollection (sap/ui/demo/mock/products.json),
    " the five columns the table binds (+ Price/CurrencyCode for the Currency type)
    productcollection = VALUE #(
          ( name = `Notebook Basic 15` productid = `HT-1000` suppliername = `Very Best Screens` width = 30 depth = 18 height = 3 dimunit = `cm` price = 956 currencycode = `EUR` )
          ( name = `Notebook Basic 17` productid = `HT-1001` suppliername = `Very Best Screens` width = 29 depth = 17 height = 3 dimunit = `cm` price = 1249 currencycode = `EUR` )
          ( name = `Notebook Basic 18` productid = `HT-1002` suppliername = `Very Best Screens` width = 28 depth = 19 height = 2 dimunit = `cm` price = 1570 currencycode = `EUR` )
          ( name = `Notebook Basic 19` productid = `HT-1003` suppliername = `Smartcards` width = 32 depth = 21 height = 4 dimunit = `cm` price = 1650 currencycode = `EUR` )
          ( name = `ITelO Vault` productid = `HT-1007` suppliername = `Technocom` width = 32 depth = 22 height = 3 dimunit = `cm` price = 299 currencycode = `EUR` )
          ( name = `Notebook Professional 15` productid = `HT-1010` suppliername = `Very Best Screens` width = 33 depth = 20 height = 3 dimunit = `cm` price = 1999 currencycode = `EUR` )
          ( name = `Notebook Professional 17` productid = `HT-1011` suppliername = `Very Best Screens` width = 33 depth = 23 height = 2 dimunit = `cm` price = 2299 currencycode = `EUR` )
          ( name = `ITelO Vault Net` productid = `HT-1020` suppliername = `Technocom` width = 10 depth = 1 height = 17 dimunit = `cm` price = 459 currencycode = `EUR` )
          ( name = `ITelO Vault SAT` productid = `HT-1021` suppliername = `Technocom` width = 11 depth = 1 height = 18 dimunit = `cm` price = 149 currencycode = `EUR` )
          ( name = `Comfort Easy` productid = `HT-1022` suppliername = `Technocom` width = 84 depth = 1 height = 14 dimunit = `cm` price = 1679 currencycode = `EUR` )
          ( name = `Comfort Senior` productid = `HT-1023` suppliername = `Technocom` width = 80 depth = 1 height = 13 dimunit = `cm` price = 512 currencycode = `EUR` )
          ( name = `Ergo Screen E-I` productid = `HT-1030` suppliername = `Very Best Screens` width = 37 depth = 12 height = 36 dimunit = `cm` price = 230 currencycode = `EUR` )
          ( name = `Ergo Screen E-II` productid = `HT-1031` suppliername = `Very Best Screens` width = 40 depth = 19 height = 43 dimunit = `cm` price = 285 currencycode = `EUR` )
          ( name = `Ergo Screen E-III` productid = `HT-1032` suppliername = `Very Best Screens` width = 40 depth = 19 height = 43 dimunit = `cm` price = 345 currencycode = `EUR` )
          ( name = `Flat Basic` productid = `HT-1035` suppliername = `Very Best Screens` width = 39 depth = 20 height = 41 dimunit = `cm` price = 399 currencycode = `EUR` )
          ( name = `Flat Future` productid = `HT-1036` suppliername = `Very Best Screens` width = 45 depth = 26 height = 46 dimunit = `cm` price = 430 currencycode = `EUR` )
          ( name = `Flat XL` productid = `HT-1037` suppliername = `Very Best Screens` width = 54 depth = 22 height = 39 dimunit = `cm` price = 1230 currencycode = `EUR` )
          ( name = `Laser Professional Eco` productid = `HT-1040` suppliername = `Alpha Printers` width = 51 depth = 46 height = 30 dimunit = `cm` price = 830 currencycode = `EUR` )
          ( name = `Laser Basic` productid = `HT-1041` suppliername = `Alpha Printers` width = 48 depth = 42 height = 26 dimunit = `cm` price = 490 currencycode = `EUR` )
          ( name = `Laser Allround` productid = `HT-1042` suppliername = `Alpha Printers` width = 53 depth = 50 height = 65 dimunit = `cm` price = 349 currencycode = `EUR` )
          ( name = `Ultra Jet Super Color` productid = `HT-1050` suppliername = `Alpha Printers` width = 41 depth = 41 height = 28 dimunit = `cm` price = 139 currencycode = `EUR` )
          ( name = `Ultra Jet Mobile` productid = `HT-1051` suppliername = `Printer for All` width = 46 depth = 32 height = 25 dimunit = `cm` price = 99 currencycode = `EUR` )
          ( name = `Ultra Jet Super Highspeed` productid = `HT-1052` suppliername = `Printer for All` width = 41 depth = 41 height = 28 dimunit = `cm` price = 170 currencycode = `EUR` )
          ( name = `Multi Print` productid = `HT-1055` suppliername = `Printer for All` width = 55 depth = 45 height = 29 dimunit = `cm` price = 99 currencycode = `EUR` )
          ( name = `Multi Color` productid = `HT-1056` suppliername = `Printer for All` width = 51 depth = 41 height = 22 dimunit = `cm` price = 119 currencycode = `EUR` )
          ( name = `Cordless Mouse` productid = `HT-1060` suppliername = `Oxynum` width = 6 depth = 14 height = 3 dimunit = `cm` price = 9 currencycode = `EUR` )
          ( name = `Speed Mouse` productid = `HT-1061` suppliername = `Oxynum` width = 7 depth = 15 height = 3 dimunit = `cm` price = 7 currencycode = `EUR` )
          ( name = `Track Mouse` productid = `HT-1062` suppliername = `Oxynum` width = 3 depth = 7 height = 4 dimunit = `cm` price = 11 currencycode = `EUR` )
          ( name = `Ergonomic Keyboard` productid = `HT-1063` suppliername = `Oxynum` width = 50 depth = 21 height = 3 dimunit = `cm` price = 14 currencycode = `EUR` )
          ( name = `Internet Keyboard` productid = `HT-1064` suppliername = `Oxynum` width = 52 depth = 25 height = 3 dimunit = `cm` price = 16 currencycode = `EUR` )
          ( name = `Media Keyboard` productid = `HT-1065` suppliername = `Oxynum` width = 51 depth = 23 height = 4 dimunit = `cm` price = 26 currencycode = `EUR` )
          ( name = `Mousepad` productid = `HT-1066` suppliername = `Oxynum` width = 15 depth = 6 height = 0 dimunit = `cm` price = 6 currencycode = `EUR` )
          ( name = `Ergo Mousepad` productid = `HT-1067` suppliername = `Oxynum` width = 15 depth = 6 height = 0 dimunit = `cm` price = 8 currencycode = `EUR` )
          ( name = `Designer Mousepad` productid = `HT-1068` suppliername = `Fasttech` width = 24 depth = 24 height = 0 dimunit = `cm` price = 12 currencycode = `EUR` )
          ( name = `Universal card reader` productid = `HT-1069` suppliername = `Fasttech` width = 6 depth = 6 height = 3 dimunit = `cm` price = 14 currencycode = `EUR` )
          ( name = `Proctra X` productid = `HT-1070` suppliername = `Ultrasonic United` width = 22 depth = 35 height = 17 dimunit = `cm` price = 70 currencycode = `EUR` )
          ( name = `Gladiator MX` productid = `HT-1071` suppliername = `Ultrasonic United` width = 22 depth = 35 height = 17 dimunit = `cm` price = 81 currencycode = `EUR` )
          ( name = `Hurricane GX` productid = `HT-1072` suppliername = `Ultrasonic United` width = 22 depth = 35 height = 17 dimunit = `cm` price = 101 currencycode = `EUR` )
          ( name = `Hurricane GX/LN` productid = `HT-1073` suppliername = `Smartcards` width = 22 depth = 35 height = 17 dimunit = `cm` price = 139 currencycode = `EUR` )
          ( name = `Photo Scan` productid = `HT-1080` suppliername = `Printer for All` width = 34 depth = 48 height = 5 dimunit = `cm` price = 129 currencycode = `EUR` )
          ( name = `Power Scan` productid = `HT-1081` suppliername = `Printer for All` width = 31 depth = 43 height = 7 dimunit = `cm` price = 89 currencycode = `EUR` )
          ( name = `Jet Scan Professional` productid = `HT-1082` suppliername = `Printer for All` width = 33 depth = 41 height = 12 dimunit = `cm` price = 169 currencycode = `EUR` )
          ( name = `Jet Scan Professional` productid = `HT-1083` suppliername = `Printer for All` width = 35 depth = 40 height = 10 dimunit = `cm` price = 189 currencycode = `EUR` )
          ( name = `Copymaster` productid = `HT-1085` suppliername = `Alpha Printers` width = 45 depth = 42 height = 22 dimunit = `cm` price = 1499 currencycode = `EUR` )
          ( name = `Surround Sound` productid = `HT-1090` suppliername = `Speaker Experts` width = 12 depth = 10 height = 16 dimunit = `cm` price = 39 currencycode = `EUR` )
          ( name = `Blaster Extreme` productid = `HT-1091` suppliername = `Speaker Experts` width = 13 depth = 11 height = 17 dimunit = `cm` price = 26 currencycode = `EUR` )
          ( name = `Sound Booster` productid = `HT-1092` suppliername = `Speaker Experts` width = 12 depth = 10 height = 18 dimunit = `cm` price = 45 currencycode = `EUR` )
          ( name = `Lovely Sound 5.1 Wireless` productid = `HT-1095` suppliername = `Fasttech` width = 24 depth = 19 height = 23 dimunit = `cm` price = 49 currencycode = `EUR` )
          ( name = `Lovely Sound 5.1` productid = `HT-1096` suppliername = `Fasttech` width = 25 depth = 17 height = 19 dimunit = `cm` price = 39 currencycode = `EUR` )
          ( name = `Lovely Sound Stereo` productid = `HT-1097` suppliername = `Fasttech` width = 21 depth = 2 height = 19 dimunit = `cm` price = 29 currencycode = `EUR` )
          ( name = `Smart Office` productid = `HT-1100` suppliername = `Technocom` width = 15 depth = 6 height = 2 dimunit = `cm` price = 89 currencycode = `EUR` )
          ( name = `Smart Design` productid = `HT-1101` suppliername = `Technocom` width = 14 depth = 6 height = 24 dimunit = `cm` price = 79 currencycode = `EUR` )
          ( name = `Smart Network` productid = `HT-1102` suppliername = `Technocom` width = 16 depth = 6 height = 27 dimunit = `cm` price = 69 currencycode = `EUR` )
          ( name = `Smart Multimedia` productid = `HT-1103` suppliername = `Technocom` width = 11 depth = 3 height = 22 dimunit = `cm` price = 77 currencycode = `EUR` )
          ( name = `Smart Games` productid = `HT-1104` suppliername = `Technocom` width = 10 depth = 3 height = 30 dimunit = `cm` price = 55 currencycode = `EUR` )
          ( name = `Smart Internet Antivirus` productid = `HT-1105` suppliername = `Brainsoft` width = 16 depth = 4 height = 21 dimunit = `cm` price = 29 currencycode = `EUR` )
          ( name = `Smart Firewall` productid = `HT-1106` suppliername = `Brainsoft` width = 17 depth = 4 height = 23 dimunit = `cm` price = 34 currencycode = `EUR` )
          ( name = `Smart Money` productid = `HT-1107` suppliername = `Brainsoft` width = 12 depth = 1 height = 19 dimunit = `cm` price = 29 currencycode = `EUR` )
          ( name = `PC Lock` productid = `HT-1110` suppliername = `Red Point Stores` width = 20 depth = 8 height = 4 dimunit = `cm` price = 8 currencycode = `EUR` )
          ( name = `Notebook Lock` productid = `HT-1111` suppliername = `Red Point Stores` width = 31 depth = 9 height = 7 dimunit = `cm` price = 6 currencycode = `EUR` )
          ( name = `Web cam reality` productid = `HT-1112` suppliername = `Red Point Stores` width = 9 depth = 8 height = 1 dimunit = `cm` price = 39 currencycode = `EUR` )
          ( name = `Screen clean` productid = `HT-1113` suppliername = `Red Point Stores` width = 2 depth = 2 height = 0 dimunit = `cm` price = 2 currencycode = `EUR` )
          ( name = `Fabric bag professional` productid = `HT-1114` suppliername = `Red Point Stores` width = 42 depth = 32 height = 7 dimunit = `cm` price = 31 currencycode = `EUR` )
          ( name = `Wireless DSL Router` productid = `HT-1115` suppliername = `Red Point Stores` width = 19 depth = 18 height = 5 dimunit = `cm` price = 49 currencycode = `EUR` )
          ( name = `Wireless DSL Router / Repeater` productid = `HT-1116` suppliername = `Red Point Stores` width = 19 depth = 18 height = 5 dimunit = `cm` price = 59 currencycode = `EUR` )
          ( name = `Wireless DSL Router / Repeater and Print Server` productid = `HT-1117` suppliername = `Technocom` width = 19 depth = 18 height = 5 dimunit = `cm` price = 69 currencycode = `EUR` )
          ( name = `USB Stick` productid = `HT-1118` suppliername = `Technocom` width = 1 depth = 8 height = 1 dimunit = `cm` price = 35 currencycode = `EUR` )
          ( name = `Travel Adapter` productid = `HT-1119` suppliername = `Titanium` width = 2 depth = 3 height = 3 dimunit = `cm` price = 79 currencycode = `EUR` )
          ( name = `Cordless Bluetooth Keyboard, english international` productid = `HT-1120` suppliername = `Technocom` width = 51 depth = 23 height = 4 dimunit = `cm` price = 29 currencycode = `EUR` )
          ( name = `Flat XXL` productid = `HT-1137` suppliername = `Technocom` width = 54 depth = 22 height = 38 dimunit = `cm` price = 1430 currencycode = `EUR` )
          ( name = `Pocket Mouse` productid = `HT-1138` suppliername = `Technocom` width = 0 depth = 0 height = 1 dimunit = `cm` price = 23 currencycode = `EUR` )
          ( name = `PC Power Station` productid = `HT-1210` suppliername = `Technocom` width = 28 depth = 31 height = 43 dimunit = `cm` price = 2399 currencycode = `EUR` )
          ( name = `Astro Laptop 1516` productid = `HT-1251` suppliername = `Ultrasonic United` width = 30 depth = 18 height = 3 dimunit = `cm` price = 989 currencycode = `EUR` )
          ( name = `Astro Phone 6` productid = `HT-1252` suppliername = `Ultrasonic United` width = 8 depth = 6 height = 1 dimunit = `cm` price = 649 currencycode = `EUR` )
          ( name = `Benda Laptop 1408` productid = `HT-1253` suppliername = `Ultrasonic United` width = 30 depth = 18 height = 3 dimunit = `cm` price = 976 currencycode = `EUR` )
          ( name = `Bending Screen 21HD` productid = `HT-1254` suppliername = `Ultrasonic United` width = 37 depth = 12 height = 36 dimunit = `cm` price = 250 currencycode = `EUR` )
          ( name = `Broad Screen 22HD` productid = `HT-1255` suppliername = `Ultrasonic United` width = 39 depth = 12 height = 38 dimunit = `cm` price = 270 currencycode = `EUR` )
          ( name = `Cerdik Phone 7` productid = `HT-1256` suppliername = `Ultrasonic United` width = 9 depth = 15 height = 1 dimunit = `cm` price = 549 currencycode = `EUR` )
          ( name = `Cepat Tablet 10.5` productid = `HT-1257` suppliername = `Ultrasonic United` width = 48 depth = 31 height = 4 dimunit = `cm` price = 549 currencycode = `EUR` )
          ( name = `Cepat Tablet 8` productid = `HT-1258` suppliername = `Ultrasonic United` width = 38 depth = 21 height = 3 dimunit = `cm` price = 529 currencycode = `EUR` )
          ( name = `Server Basic` productid = `HT-1500` suppliername = `Technocom` width = 34 depth = 35 height = 23 dimunit = `cm` price = 5000 currencycode = `EUR` )
          ( name = `Server Professional` productid = `HT-1501` suppliername = `Technocom` width = 29 depth = 30 height = 27 dimunit = `cm` price = 15000 currencycode = `EUR` )
          ( name = `Server Power Pro` productid = `HT-1502` suppliername = `Technocom` width = 22 depth = 27 height = 37 dimunit = `cm` price = 25000 currencycode = `EUR` )
          ( name = `Family PC Basic` productid = `HT-1600` suppliername = `Titanium` width = 21 depth = 29 height = 38 dimunit = `cm` price = 600 currencycode = `EUR` )
          ( name = `Family PC Pro` productid = `HT-1601` suppliername = `Titanium` width = 25 depth = 31 height = 40 dimunit = `cm` price = 900 currencycode = `EUR` )
          ( name = `Gaming Monster` productid = `HT-1602` suppliername = `Titanium` width = 26 depth = 34 height = 47 dimunit = `cm` price = 1200 currencycode = `EUR` )
          ( name = `Gaming Monster Pro` productid = `HT-1603` suppliername = `Titanium` width = 27 depth = 28 height = 42 dimunit = `cm` price = 1700 currencycode = `EUR` )
          ( name = `7" Widescreen Portable DVD Player w MP3` productid = `HT-2000` suppliername = `Titanium` width = 21 depth = 19 height = 27 dimunit = `cm` price = 249 currencycode = `EUR` )
          ( name = `10" Portable DVD player` productid = `HT-2001` suppliername = `Titanium` width = 24 depth = 19 height = 29 dimunit = `cm` price = 449 currencycode = `EUR` )
          ( name = `Portable DVD Player with 9" LCD Monitor` productid = `HT-2002` suppliername = `Technocom` width = 21 depth = 16 height = 14 dimunit = `cm` price = 853 currencycode = `EUR` )
          ( name = `CD/DVD case: 264 sleeves` productid = `HT-2025` suppliername = `Titanium` width = 13 depth = 13 height = 20 dimunit = `cm` price = 44 currencycode = `EUR` )
          ( name = `Audio/Video Cable Kit - 4m` productid = `HT-2026` suppliername = `Titanium` width = 21 depth = 10 height = 13 dimunit = `cm` price = 29 currencycode = `EUR` )
          ( name = `Removable CD/DVD Laser Labels` productid = `HT-2027` suppliername = `Titanium` width = 5 depth = 2 height = 2 dimunit = `cm` price = 8 currencycode = `EUR` )
          ( name = `Beam Breaker B-1` productid = `HT-6100` suppliername = `Titanium` width = 30 depth = 23 height = 23 dimunit = `cm` price = 469 currencycode = `EUR` )
          ( name = `Beam Breaker B-2` productid = `HT-6101` suppliername = `Technocom` width = 30 depth = 23 height = 23 dimunit = `cm` price = 679 currencycode = `EUR` )
          ( name = `Beam Breaker B-3` productid = `HT-6102` suppliername = `Technocom` width = 30 depth = 23 height = 23 dimunit = `cm` price = 889 currencycode = `EUR` )
          ( name = `Play Movie` productid = `HT-6110` suppliername = `Fasttech` width = 37 depth = 24 height = 6 dimunit = `cm` price = 130 currencycode = `EUR` )
          ( name = `Record Movie` productid = `HT-6111` suppliername = `Fasttech` width = 38 depth = 26 height = 6 dimunit = `cm` price = 288 currencycode = `EUR` )
          ( name = `ITelo MusicStick` productid = `HT-6120` suppliername = `Fasttech` width = 1 depth = 6 height = 1 dimunit = `cm` price = 45 currencycode = `EUR` )
          ( name = `ITelo Jog-Mate` productid = `HT-6121` suppliername = `Fasttech` width = 5 depth = 8 height = 9 dimunit = `cm` price = 63 currencycode = `EUR` )
          ( name = `Power Pro Player 40` productid = `HT-6122` suppliername = `Fasttech` width = 5 depth = 8 height = 9 dimunit = `cm` price = 167 currencycode = `EUR` )
          ( name = `Power Pro Player 80` productid = `HT-6123` suppliername = `Fasttech` width = 4 depth = 6 height = 0 dimunit = `cm` price = 299 currencycode = `EUR` )
          ( name = `Flat Watch HD32` productid = `HT-6130` suppliername = `Very Best Screens` width = 78 depth = 22 height = 55 dimunit = `cm` price = 1459 currencycode = `EUR` )
          ( name = `Flat Watch HD37` productid = `HT-6131` suppliername = `Very Best Screens` width = 99 depth = 26 height = 61 dimunit = `cm` price = 1199 currencycode = `EUR` )
          ( name = `Flat Watch HD41` productid = `HT-6132` suppliername = `Very Best Screens` width = 128 depth = 23 height = 79 dimunit = `cm` price = 899 currencycode = `EUR` )
          ( name = `Copperberry` productid = `HT-7000` suppliername = `Fasttech` width = 8 depth = 13 height = 12 dimunit = `cm` price = 549 currencycode = `EUR` )
          ( name = `Silverberry` productid = `HT-7010` suppliername = `Fasttech` width = 8 depth = 13 height = 12 dimunit = `cm` price = 549 currencycode = `EUR` )
          ( name = `Goldberry` productid = `HT-7020` suppliername = `Fasttech` width = 8 depth = 13 height = 12 dimunit = `cm` price = 549 currencycode = `EUR` )
          ( name = `Platinberry` productid = `HT-7030` suppliername = `Fasttech` width = 8 depth = 13 height = 12 dimunit = `cm` price = 549 currencycode = `EUR` )
          ( name = `ITelO FlexTop I4000` productid = `HT-8000` suppliername = `Titanium` width = 31 depth = 19 height = 3 dimunit = `cm` price = 799 currencycode = `EUR` )
          ( name = `ITelO FlexTop I6300c` productid = `HT-8001` suppliername = `Titanium` width = 32 depth = 20 height = 3 dimunit = `cm` price = 799 currencycode = `EUR` )
          ( name = `ITelO FlexTop I9100` productid = `HT-8002` suppliername = `Titanium` width = 38 depth = 21 height = 4 dimunit = `cm` price = 1199 currencycode = `EUR` )
          ( name = `ITelO FlexTop I9800` productid = `HT-8003` suppliername = `Titanium` width = 48 depth = 31 height = 4 dimunit = `cm` price = 1388 currencycode = `EUR` )
          ( name = `Smartphone Leather Case` productid = `HT-9991` suppliername = `Ultrasonic United` width = 48 depth = 31 height = 4 dimunit = `cm` price = 25 currencycode = `EUR` )
          ( name = `Smartphone Alpha` productid = `HT-9992` suppliername = `Ultrasonic United` width = 48 depth = 31 height = 4 dimunit = `cm` price = 599 currencycode = `EUR` )
          ( name = `Mini Tablet` productid = `HT-9993` suppliername = `Ultrasonic United` width = 48 depth = 31 height = 4 dimunit = `cm` price = 833 currencycode = `EUR` )
          ( name = `Camcorder View` productid = `HT-9994` suppliername = `Ultrasonic United` width = 48 depth = 31 height = 27 dimunit = `cm` price = 1388 currencycode = `EUR` )
          ( name = `Tablet Pouch` productid = `HT-9995` suppliername = `Titanium` width = 25 depth = 40 height = 4 dimunit = `cm` price = 20 currencycode = `EUR` )
          ( name = `Tablet Pouch` productid = `HT-9996` suppliername = `Titanium` width = 25 depth = 40 height = 4 dimunit = `cm` price = 20 currencycode = `EUR` )
          ( name = `e-Book Reader ReadMe` productid = `HT-9997` suppliername = `Titanium` width = 48 depth = 31 height = 4 dimunit = `cm` price = 33 currencycode = `EUR` )
          ( name = `Smartphone Beta` productid = `HT-9998` suppliername = `Titanium` width = 48 depth = 31 height = 4 dimunit = `cm` price = 30 currencycode = `EUR` )
          ( name = `Maxi Tablet` productid = `HT-9999` suppliername = `Titanium` width = 48 depth = 31 height = 4 dimunit = `cm` price = 749 currencycode = `EUR` )
          ( name = `Flyer` productid = `PF-1000` suppliername = `Titanium` width = 46 depth = 30 height = 3 dimunit = `cm` price = 0 currencycode = `EUR` )
        ).

  ENDMETHOD.

ENDCLASS.
