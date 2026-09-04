" @keywords multicombobox multi combo box sap.m multicomboboxsuggestionsandvaluestate verticallayout label item formattedtext link
" @summary MultiComboBox with suggestions and Value State Message containing a link.
CLASS z2ui5_cl_smpc_app_519 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             productid TYPE string,
             name      TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    DATA t_products TYPE ty_t_product.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_519 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    DATA temp3 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `Link pressed` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `MESSAGE_TOAST` INTO TABLE temp2.
    INSERT `show` INTO TABLE temp2.
    INSERT `Link pressed` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `MESSAGE_TOAST` INTO TABLE temp3.
    INSERT `show` INTO TABLE temp3.
    INSERT `Link pressed` INTO TABLE temp3.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( `Page`
            )->a( n = `showHeader` v = `false`

            )->ele( n = `VerticalLayout` ns = `l`
                )->a( n = `class` v = `sapUiContentPadding`
                )->a( n = `width` v = `100%`

                )->tag( `Label`
                    )->a( n = `text`     v = `MultiComboBox with suggestions and success value state with a a long message:`
                    )->a( n = `labelFor` v = `MCBSuccess`
                )->ele( `MultiComboBox`
                    )->a( n = `id`         v = `MCBSuccess`
                    )->a( n = `class`      v = `sapUiSmallMarginBottom`
                    )->a( n = `maxWidth`   v = `500px`
                    )->a( n = `valueState` v = `Success`
                    )->a( n = `valueStateText` v = `Success message. Extra long text used as a success message. Extra long text used as a success message - 2. Extra long text used as a success message.`
                    )->a( n = `items`      v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME' \} \}|

                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `{PRODUCTID}`
                        )->a( n = `text` v = `{NAME}`

                )->end(

                )->tag( `Label`
                    )->a( n = `text`     v = `MultiComboBox with suggestions and information value state with a a long message:`
                    )->a( n = `labelFor` v = `MCBInformation`
                )->ele( `MultiComboBox`
                    )->a( n = `id`         v = `MCBInformation`
                    )->a( n = `class`      v = `sapUiSmallMarginBottom`
                    )->a( n = `maxWidth`   v = `500px`
                    )->a( n = `valueState` v = `Information`
                    )->a( n = `valueStateText` v = `Information message. Extra long text used as a information message. Extra long text used as a information message - 2. Extra long text used as a information message.`
                    )->a( n = `items`      v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME' \} \}|

                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `{PRODUCTID}`
                        )->a( n = `text` v = `{NAME}`

                )->end(

                )->tag( `Label`
                    )->a( n = `text`     v = `MultiComboBox with suggestions and an information value state with multiple links:`
                    )->a( n = `labelFor` v = `MCBInformationLinks`
                )->ele( `MultiComboBox`
                    )->a( n = `id`         v = `MCBInformationLinks`
                    )->a( n = `class`      v = `sapUiSmallMarginBottom`
                    )->a( n = `maxWidth`   v = `500px`
                    )->a( n = `valueState` v = `Information`
                    )->a( n = `items`      v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME' \} \}|

                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `{PRODUCTID}`
                        )->a( n = `text` v = `{NAME}`

                    )->ele( `formattedValueStateText`
                        )->ele( `FormattedText`
                            )->a( n = `htmlText` v = `Value state with FormattedText used as an information message containing %%0 %%1.`

                            )->ele( `controls`
                                )->tag( `Link`
                                    )->a( n = `text`  v = `multiple`
                                    )->a( n = `href`  v = ``
                                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                    t_arg = temp1 )
                                )->tag( `Link`
                                    )->a( n = `text`  v = `links`
                                    )->a( n = `href`  v = ``
                                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                    t_arg = temp2 )

                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->tag( `Label`
                    )->a( n = `text`     v = `MultiComboBox with suggestions and warning value state with a a long message:`
                    )->a( n = `labelFor` v = `MCBWarning`
                )->ele( `MultiComboBox`
                    )->a( n = `id`         v = `MCBWarning`
                    )->a( n = `class`      v = `sapUiSmallMarginBottom`
                    )->a( n = `maxWidth`   v = `500px`
                    )->a( n = `valueState` v = `Warning`
                    )->a( n = `valueStateText` v = `Warning message. Extra long text used as a warning message. Extra long text used as a information message - 2. Extra long text used as a warning message.`
                    )->a( n = `items`      v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME' \} \}|

                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `{PRODUCTID}`
                        )->a( n = `text` v = `{NAME}`

                )->end(

                )->tag( `Label`
                    )->a( n = `text`     v = `MultiComboBox with suggestions and a warning value state with a link:`
                    )->a( n = `labelFor` v = `MCBWarningLink`
                )->ele( `MultiComboBox`
                    )->a( n = `id`         v = `MCBWarningLink`
                    )->a( n = `class`      v = `sapUiSmallMarginBottom`
                    )->a( n = `maxWidth`   v = `500px`
                    )->a( n = `valueState` v = `Warning`
                    )->a( n = `valueStateText` v = `Warning message. Extra long text used as a warning message.`
                    )->a( n = `items`      v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME' \} \}|

                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `{PRODUCTID}`
                        )->a( n = `text` v = `{NAME}`

                    )->ele( `formattedValueStateText`
                        )->ele( `FormattedText`
                            )->a( n = `htmlText` v = `Value state with FormattedText used as a warning message containing a %%0.`

                            )->ele( `controls`
                                )->tag( `Link`
                                    )->a( n = `text`  v = `link`
                                    )->a( n = `href`  v = ``
                                    )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                                    t_arg = temp3 )

                            )->end(
                        )->end(
                    )->end(
                )->end(

                )->tag( `Label`
                    )->a( n = `text`     v = `MultiComboBox with suggestions and an error value state with a a long message:`
                    )->a( n = `labelFor` v = `MCBError`
                )->ele( `MultiComboBox`
                    )->a( n = `id`         v = `MCBError`
                    )->a( n = `class`      v = `sapUiSmallMarginBottom`
                    )->a( n = `maxWidth`   v = `500px`
                    )->a( n = `valueState` v = `Error`
                    )->a( n = `valueStateText` v = `Error message. Extra long text used as a warning message. Extra long text used as an error message - 2. Extra long text used as an error message.`
                    )->a( n = `items`      v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME' \} \}|

                    )->tag( n = `Item` ns = `core`
                        )->a( n = `key`  v = `{PRODUCTID}`
                        )->a( n = `text` v = `{NAME}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection of ui5/mock/products.json (the bound fields)
    DATA temp3 TYPE z2ui5_cl_smpc_app_519=>ty_t_product.
    DATA temp4 LIKE LINE OF temp3.
    CLEAR temp3.
    
    temp4-productid = `HT-1000`.
    temp4-name = `Notebook Basic 15`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1001`.
    temp4-name = `Notebook Basic 17`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1002`.
    temp4-name = `Notebook Basic 18`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1003`.
    temp4-name = `Notebook Basic 19`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1007`.
    temp4-name = `ITelO Vault`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1010`.
    temp4-name = `Notebook Professional 15`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1011`.
    temp4-name = `Notebook Professional 17`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1020`.
    temp4-name = `ITelO Vault Net`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1021`.
    temp4-name = `ITelO Vault SAT`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1022`.
    temp4-name = `Comfort Easy`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1023`.
    temp4-name = `Comfort Senior`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1030`.
    temp4-name = `Ergo Screen E-I`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1031`.
    temp4-name = `Ergo Screen E-II`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1032`.
    temp4-name = `Ergo Screen E-III`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1035`.
    temp4-name = `Flat Basic`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1036`.
    temp4-name = `Flat Future`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1037`.
    temp4-name = `Flat XL`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1040`.
    temp4-name = `Laser Professional Eco`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1041`.
    temp4-name = `Laser Basic`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1042`.
    temp4-name = `Laser Allround`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1050`.
    temp4-name = `Ultra Jet Super Color`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1051`.
    temp4-name = `Ultra Jet Mobile`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1052`.
    temp4-name = `Ultra Jet Super Highspeed`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1055`.
    temp4-name = `Multi Print`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1056`.
    temp4-name = `Multi Color`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1060`.
    temp4-name = `Cordless Mouse`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1061`.
    temp4-name = `Speed Mouse`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1062`.
    temp4-name = `Track Mouse`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1063`.
    temp4-name = `Ergonomic Keyboard`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1064`.
    temp4-name = `Internet Keyboard`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1065`.
    temp4-name = `Media Keyboard`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1066`.
    temp4-name = `Mousepad`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1067`.
    temp4-name = `Ergo Mousepad`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1068`.
    temp4-name = `Designer Mousepad`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1069`.
    temp4-name = `Universal card reader`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1070`.
    temp4-name = `Proctra X`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1071`.
    temp4-name = `Gladiator MX`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1072`.
    temp4-name = `Hurricane GX`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1073`.
    temp4-name = `Hurricane GX/LN`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1080`.
    temp4-name = `Photo Scan`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1081`.
    temp4-name = `Power Scan`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1082`.
    temp4-name = `Jet Scan Professional`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1083`.
    temp4-name = `Jet Scan Professional`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1085`.
    temp4-name = `Copymaster`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1090`.
    temp4-name = `Surround Sound`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1091`.
    temp4-name = `Blaster Extreme`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1092`.
    temp4-name = `Sound Booster`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1095`.
    temp4-name = `Lovely Sound 5.1 Wireless`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1096`.
    temp4-name = `Lovely Sound 5.1`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1097`.
    temp4-name = `Lovely Sound Stereo`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1100`.
    temp4-name = `Smart Office`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1101`.
    temp4-name = `Smart Design`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1102`.
    temp4-name = `Smart Network`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1103`.
    temp4-name = `Smart Multimedia`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1104`.
    temp4-name = `Smart Games`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1105`.
    temp4-name = `Smart Internet Antivirus`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1106`.
    temp4-name = `Smart Firewall`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1107`.
    temp4-name = `Smart Money`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1110`.
    temp4-name = `PC Lock`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1111`.
    temp4-name = `Notebook Lock`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1112`.
    temp4-name = `Web cam reality`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1113`.
    temp4-name = `Screen clean`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1114`.
    temp4-name = `Fabric bag professional`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1115`.
    temp4-name = `Wireless DSL Router`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1116`.
    temp4-name = `Wireless DSL Router / Repeater`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1117`.
    temp4-name = `Wireless DSL Router / Repeater and Print Server`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1118`.
    temp4-name = `USB Stick`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1119`.
    temp4-name = `Travel Adapter`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1120`.
    temp4-name = `Cordless Bluetooth Keyboard, english international`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1137`.
    temp4-name = `Flat XXL`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1138`.
    temp4-name = `Pocket Mouse`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1210`.
    temp4-name = `PC Power Station`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1251`.
    temp4-name = `Astro Laptop 1516`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1252`.
    temp4-name = `Astro Phone 6`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1253`.
    temp4-name = `Benda Laptop 1408`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1254`.
    temp4-name = `Bending Screen 21HD`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1255`.
    temp4-name = `Broad Screen 22HD`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1256`.
    temp4-name = `Cerdik Phone 7`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1257`.
    temp4-name = `Cepat Tablet 10.5`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1258`.
    temp4-name = `Cepat Tablet 8`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1500`.
    temp4-name = `Server Basic`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1501`.
    temp4-name = `Server Professional`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1502`.
    temp4-name = `Server Power Pro`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1600`.
    temp4-name = `Family PC Basic`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1601`.
    temp4-name = `Family PC Pro`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1602`.
    temp4-name = `Gaming Monster`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1603`.
    temp4-name = `Gaming Monster Pro`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-2000`.
    temp4-name = `7" Widescreen Portable DVD Player w MP3`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-2001`.
    temp4-name = `10" Portable DVD player`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-2002`.
    temp4-name = `Portable DVD Player with 9" LCD Monitor`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-2025`.
    temp4-name = `CD/DVD case: 264 sleeves`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-2026`.
    temp4-name = `Audio/Video Cable Kit - 4m`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-2027`.
    temp4-name = `Removable CD/DVD Laser Labels`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6100`.
    temp4-name = `Beam Breaker B-1`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6101`.
    temp4-name = `Beam Breaker B-2`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6102`.
    temp4-name = `Beam Breaker B-3`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6110`.
    temp4-name = `Play Movie`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6111`.
    temp4-name = `Record Movie`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6120`.
    temp4-name = `ITelo MusicStick`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6121`.
    temp4-name = `ITelo Jog-Mate`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6122`.
    temp4-name = `Power Pro Player 40`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6123`.
    temp4-name = `Power Pro Player 80`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6130`.
    temp4-name = `Flat Watch HD32`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6131`.
    temp4-name = `Flat Watch HD37`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6132`.
    temp4-name = `Flat Watch HD41`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-7000`.
    temp4-name = `Copperberry`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-7010`.
    temp4-name = `Silverberry`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-7020`.
    temp4-name = `Goldberry`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-7030`.
    temp4-name = `Platinberry`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-8000`.
    temp4-name = `ITelO FlexTop I4000`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-8001`.
    temp4-name = `ITelO FlexTop I6300c`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-8002`.
    temp4-name = `ITelO FlexTop I9100`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-8003`.
    temp4-name = `ITelO FlexTop I9800`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-9991`.
    temp4-name = `Smartphone Leather Case`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-9992`.
    temp4-name = `Smartphone Alpha`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-9993`.
    temp4-name = `Mini Tablet`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-9994`.
    temp4-name = `Camcorder View`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-9995`.
    temp4-name = `Tablet Pouch`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-9996`.
    temp4-name = `Tablet Pouch`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-9997`.
    temp4-name = `e-Book Reader ReadMe`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-9998`.
    temp4-name = `Smartphone Beta`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-9999`.
    temp4-name = `Maxi Tablet`.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `PF-1000`.
    temp4-name = `Flyer`.
    INSERT temp4 INTO TABLE temp3.
    t_products = temp3.

  ENDMETHOD.

ENDCLASS.
