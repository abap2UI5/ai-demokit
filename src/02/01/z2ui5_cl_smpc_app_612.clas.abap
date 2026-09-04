" @keywords multiinput multi input sap.m multiinputfilteringsuggestions vbox item column label columnlistitem multiinputext formattedtext
" @summary The default filtering is 'starts with per term', which filters by the beginning of every word in every column.
CLASS z2ui5_cl_smpc_app_612 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name         TYPE string,
             productid    TYPE string,
             suppliername TYPE string,
             price        TYPE string,
             currencycode TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    DATA t_products TYPE ty_t_product.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.
    METHODS on_event.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_612 IMPLEMENTATION.

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
    DATA box TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE z2ui5_if_client=>ty_s_event_control.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    box = view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:z2ui5` v = `z2ui5.cc`
        )->a( n = `height`     v = `100%`

        )->ele( `VBox`
            )->a( n = `class` v = `sapUiSmallMargin` ).

    " the first MultiInput takes plain core:Item suggestions, sorted by Name -
    " the sorter rides along in the binding-info string, the rows themselves
    " come from the backend table
    box->tag( `Label`
        )->a( n = `text`     v = `MultiInput with suggestion list items`
        )->a( n = `labelFor` v = `multiInput4`
        )->a( n = `class`    v = `sapUiSmallMarginTop`

        )->ele( `MultiInput`
            )->a( n = `id`              v = `multiInput4`
            )->a( n = `class`           v = `sapUiSmallMarginBottom`
            )->a( n = `width`           v = `100%`
            )->a( n = `showValueHelp`   v = `false`
            )->a( n = `suggestionItems` v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME' \} \}|

            )->ele( `suggestionItems`
                )->tag( n = `Item` ns = `core`
                    )->a( n = `key`  v = `{PRODUCTID}`
                    )->a( n = `text` v = `{NAME}`

            )->end(
        )->end( ).

    " the second: tabular suggestions with an Information value state. The
    " controller's addValidator( ) turns the picked row into a Token
    " (key = the Name cell, text = 'Name(Price)') - the z2ui5.cc.MultiInputExt
    " companion below installs exactly that validator, so the token is built
    " on the client and no round trip is needed
    box->tag( `Label`
        )->a( n = `text`     v = `MultiInput with suggestion table`
        )->a( n = `labelFor` v = `multiInput2`
        )->a( n = `class`    v = `sapUiSmallMarginTop`

        )->ele( `MultiInput`
            )->a( n = `id`                     v = `multiInput2`
            )->a( n = `class`                  v = `sapUiSmallMarginBottom`
            )->a( n = `width`                  v = `100%`
            )->a( n = `placeholder`            v = `Enter Product ...`
            )->a( n = `showSuggestion`         v = `true`
            )->a( n = `showValueHelp`          v = `false`
            )->a( n = `valueState`             v = `Information`
            )->a( n = `valueStateText`         v = `Information message. Extra long text used as a information message. Extra long text used as a information message - 2. Extra long text used as a information message - 3.`
            )->a( n = `suggestionRows`         v = client->_bind( t_products )

            )->ele( `suggestionColumns`
                )->ele( `Column`
                    )->a( n = `hAlign`       v = `Begin`
                    )->a( n = `popinDisplay` v = `Inline`
                    )->a( n = `demandPopin`  v = `true`
                    )->tag( `Label`
                        )->a( n = `text` v = `Name`

                )->end(
                )->ele( `Column`
                    )->a( n = `hAlign`         v = `Center`
                    )->a( n = `popinDisplay`   v = `Inline`
                    )->a( n = `demandPopin`    v = `true`
                    )->a( n = `minScreenWidth` v = `Tablet`
                    )->tag( `Label`
                        )->a( n = `text` v = `Product ID`

                )->end(
                )->ele( `Column`
                    )->a( n = `hAlign`         v = `Center`
                    )->a( n = `popinDisplay`   v = `Inline`
                    )->a( n = `demandPopin`    v = `false`
                    )->a( n = `minScreenWidth` v = `Tablet`
                    )->tag( `Label`
                        )->a( n = `text` v = `Supplier Name`

                )->end(
                )->ele( `Column`
                    )->a( n = `hAlign`       v = `End`
                    )->a( n = `popinDisplay` v = `Inline`
                    )->a( n = `demandPopin`  v = `true`
                    )->tag( `Label`
                        )->a( n = `text` v = `Price`

                )->end(
            )->end(

            )->ele( `suggestionRows`
                )->ele( `ColumnListItem`
                    )->tag( `Label`
                        )->a( n = `text` v = `{NAME}`
                    )->tag( `Label`
                        )->a( n = `text` v = `{PRODUCTID}`
                    )->tag( `Label`
                        )->a( n = `text` v = `{SUPPLIERNAME}`
                    )->tag( `Label`
                        )->a( n = `text` v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCYCODE'\}],| &&
                                                 | type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: true\} \}|

                )->end(
            )->end(
        )->end(

        " the controller's addValidator( ), installed by the invisible
        " z2ui5.cc.MultiInputExt companion: a picked row becomes a Token whose
        " key is cell 0 (Name) and whose text is rendered key(cell 3) - the
        " Name(Price CurrencyCode) shape the original builds in JavaScript
        )->tag( n = `MultiInputExt` ns = `z2ui5`
            )->a( n = `MultiInputId`   v = `multiInput2`
            )->a( n = `TokenKeyCell`   v = `0`
            )->a( n = `TokenTextCells` v = `3` ).

    " the third adds formattedValueStateText on top of the same companion:
    " the value state message is a
    " FormattedText whose %%0 placeholder is a Link. The link handler calls
    " oEvent.preventDefault( ) and shows a MessageToast - the wire carries the
    " veto flag (baked per wire at render time) and the toast is composed on
    " the way back
    
    CLEAR temp1.
    temp1-check_prevent_default = abap_true.
    box->tag( `Label`
        )->a( n = `text`     v = `MultiInput with suggestion table and value state message containing formatted text with link`
        )->a( n = `labelFor` v = `multiInput3`
        )->a( n = `class`    v = `sapUiSmallMarginTop`

        )->ele( `MultiInput`
            )->a( n = `id`                     v = `multiInput3`
            )->a( n = `width`                  v = `100%`
            )->a( n = `placeholder`            v = `Enter Product ...`
            )->a( n = `showSuggestion`         v = `true`
            )->a( n = `showValueHelp`          v = `false`
            )->a( n = `valueState`             v = `Information`
            )->a( n = `valueStateText`         v = `Information message. Extra long text used as a information message. Extra long text used as a information message - 2. Extra long text used as a information message - 3.`
            )->a( n = `suggestionRows`         v = client->_bind( t_products )

            )->ele( `suggestionColumns`
                )->ele( `Column`
                    )->a( n = `hAlign`       v = `Begin`
                    )->a( n = `popinDisplay` v = `Inline`
                    )->a( n = `demandPopin`  v = `true`
                    )->tag( `Label`
                        )->a( n = `text` v = `Name`

                )->end(
                )->ele( `Column`
                    )->a( n = `hAlign`         v = `Center`
                    )->a( n = `popinDisplay`   v = `Inline`
                    )->a( n = `demandPopin`    v = `true`
                    )->a( n = `minScreenWidth` v = `Tablet`
                    )->tag( `Label`
                        )->a( n = `text` v = `Product ID`

                )->end(
                )->ele( `Column`
                    )->a( n = `hAlign`         v = `Center`
                    )->a( n = `popinDisplay`   v = `Inline`
                    )->a( n = `demandPopin`    v = `false`
                    )->a( n = `minScreenWidth` v = `Tablet`
                    )->tag( `Label`
                        )->a( n = `text` v = `Supplier Name`

                )->end(
                )->ele( `Column`
                    )->a( n = `hAlign`       v = `End`
                    )->a( n = `popinDisplay` v = `Inline`
                    )->a( n = `demandPopin`  v = `true`
                    )->tag( `Label`
                        )->a( n = `text` v = `Price`

                )->end(
            )->end(

            )->ele( `suggestionRows`
                )->ele( `ColumnListItem`
                    )->tag( `Label`
                        )->a( n = `text` v = `{NAME}`
                    )->tag( `Label`
                        )->a( n = `text` v = `{PRODUCTID}`
                    )->tag( `Label`
                        )->a( n = `text` v = `{SUPPLIERNAME}`
                    )->tag( `Label`
                        )->a( n = `text` v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCYCODE'\}],| &&
                                                 | type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: true\} \}|

                )->end(
            )->end(

            )->ele( `formattedValueStateText`
                )->ele( `FormattedText`
                    )->a( n = `htmlText` v = `Recommendantion based on: %%0.`

                    )->ele( `controls`
                        )->tag( `Link`
                            )->a( n = `text`  v = `link`
                            )->a( n = `href`  v = ``
                            )->a( n = `press` v = client->_event( val    = `LINK`
                                                                  s_ctrl = temp1 )

                    )->end(
                )->end(
            )->end(
        )->end(

        " the controller's addValidator( ), installed by the invisible
        " z2ui5.cc.MultiInputExt companion: a picked row becomes a Token whose
        " key is cell 0 (Name) and whose text is rendered key(cell 3) - the
        " Name(Price CurrencyCode) shape the original builds in JavaScript
        )->tag( n = `MultiInputExt` ns = `z2ui5`
            )->a( n = `MultiInputId`   v = `multiInput3`
            )->a( n = `TokenKeyCell`   v = `0`
            )->a( n = `TokenTextCells` v = `3` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
      DATA temp2 TYPE string_table.

    " the token wires are gone with the MultiInputExt companion, so LINK is the
    " only event this app still handles - an IF rather than a one-branch CASE
    IF client->get_event( ) = `LINK`.
      " MessageToast.show( 'You have pressed a link in value state message' )
      " - the my/at Popup.Dock.CenterCenter placement of the original is not
      " reachable through the global target, the default placement is used
      
      CLEAR temp2.
      INSERT `MESSAGE_TOAST` INTO TABLE temp2.
      INSERT `show` INTO TABLE temp2.
      INSERT `You have pressed a link in value state message` INTO TABLE temp2.
      client->follow_up_action( val   = client->cs_event-control_global
                                t_arg = temp2 ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " sap/ui/documentation/sdk/products.json /ProductCollection - the
    " suggestion items and the suggestion rows of all three MultiInputs
    DATA temp4 TYPE z2ui5_cl_smpc_app_612=>ty_t_product.
    DATA temp5 LIKE LINE OF temp4.
    CLEAR temp4.
    
    temp5-name = `Notebook Basic 15`.
    temp5-productid = `HT-1000`.
    temp5-suppliername = `Very Best Screens`.
    temp5-price = `956`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Notebook Basic 17`.
    temp5-productid = `HT-1001`.
    temp5-suppliername = `Very Best Screens`.
    temp5-price = `1249`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Notebook Basic 18`.
    temp5-productid = `HT-1002`.
    temp5-suppliername = `Very Best Screens`.
    temp5-price = `1570`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Notebook Basic 19`.
    temp5-productid = `HT-1003`.
    temp5-suppliername = `Smartcards`.
    temp5-price = `1650`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelO Vault`.
    temp5-productid = `HT-1007`.
    temp5-suppliername = `Technocom`.
    temp5-price = `299`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Notebook Professional 15`.
    temp5-productid = `HT-1010`.
    temp5-suppliername = `Very Best Screens`.
    temp5-price = `1999`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Notebook Professional 17`.
    temp5-productid = `HT-1011`.
    temp5-suppliername = `Very Best Screens`.
    temp5-price = `2299`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelO Vault Net`.
    temp5-productid = `HT-1020`.
    temp5-suppliername = `Technocom`.
    temp5-price = `459`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelO Vault SAT`.
    temp5-productid = `HT-1021`.
    temp5-suppliername = `Technocom`.
    temp5-price = `149`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Comfort Easy`.
    temp5-productid = `HT-1022`.
    temp5-suppliername = `Technocom`.
    temp5-price = `1679`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Comfort Senior`.
    temp5-productid = `HT-1023`.
    temp5-suppliername = `Technocom`.
    temp5-price = `512`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ergo Screen E-I`.
    temp5-productid = `HT-1030`.
    temp5-suppliername = `Very Best Screens`.
    temp5-price = `230`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ergo Screen E-II`.
    temp5-productid = `HT-1031`.
    temp5-suppliername = `Very Best Screens`.
    temp5-price = `285`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ergo Screen E-III`.
    temp5-productid = `HT-1032`.
    temp5-suppliername = `Very Best Screens`.
    temp5-price = `345`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flat Basic`.
    temp5-productid = `HT-1035`.
    temp5-suppliername = `Very Best Screens`.
    temp5-price = `399`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flat Future`.
    temp5-productid = `HT-1036`.
    temp5-suppliername = `Very Best Screens`.
    temp5-price = `430`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flat XL`.
    temp5-productid = `HT-1037`.
    temp5-suppliername = `Very Best Screens`.
    temp5-price = `1230`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Laser Professional Eco`.
    temp5-productid = `HT-1040`.
    temp5-suppliername = `Alpha Printers`.
    temp5-price = `830`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Laser Basic`.
    temp5-productid = `HT-1041`.
    temp5-suppliername = `Alpha Printers`.
    temp5-price = `490`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Laser Allround`.
    temp5-productid = `HT-1042`.
    temp5-suppliername = `Alpha Printers`.
    temp5-price = `349`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ultra Jet Super Color`.
    temp5-productid = `HT-1050`.
    temp5-suppliername = `Alpha Printers`.
    temp5-price = `139`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ultra Jet Mobile`.
    temp5-productid = `HT-1051`.
    temp5-suppliername = `Printer for All`.
    temp5-price = `99`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ultra Jet Super Highspeed`.
    temp5-productid = `HT-1052`.
    temp5-suppliername = `Printer for All`.
    temp5-price = `170`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Multi Print`.
    temp5-productid = `HT-1055`.
    temp5-suppliername = `Printer for All`.
    temp5-price = `99`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Multi Color`.
    temp5-productid = `HT-1056`.
    temp5-suppliername = `Printer for All`.
    temp5-price = `119`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Cordless Mouse`.
    temp5-productid = `HT-1060`.
    temp5-suppliername = `Oxynum`.
    temp5-price = `9`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Speed Mouse`.
    temp5-productid = `HT-1061`.
    temp5-suppliername = `Oxynum`.
    temp5-price = `7`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Track Mouse`.
    temp5-productid = `HT-1062`.
    temp5-suppliername = `Oxynum`.
    temp5-price = `11`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ergonomic Keyboard`.
    temp5-productid = `HT-1063`.
    temp5-suppliername = `Oxynum`.
    temp5-price = `14`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Internet Keyboard`.
    temp5-productid = `HT-1064`.
    temp5-suppliername = `Oxynum`.
    temp5-price = `16`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Media Keyboard`.
    temp5-productid = `HT-1065`.
    temp5-suppliername = `Oxynum`.
    temp5-price = `26`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Mousepad`.
    temp5-productid = `HT-1066`.
    temp5-suppliername = `Oxynum`.
    temp5-price = `6.99`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Ergo Mousepad`.
    temp5-productid = `HT-1067`.
    temp5-suppliername = `Oxynum`.
    temp5-price = `8.99`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Designer Mousepad`.
    temp5-productid = `HT-1068`.
    temp5-suppliername = `Fasttech`.
    temp5-price = `12.99`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Universal card reader`.
    temp5-productid = `HT-1069`.
    temp5-suppliername = `Fasttech`.
    temp5-price = `14`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Proctra X`.
    temp5-productid = `HT-1070`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-price = `70.9`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Gladiator MX`.
    temp5-productid = `HT-1071`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-price = `81.7`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Hurricane GX`.
    temp5-productid = `HT-1072`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-price = `101.2`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Hurricane GX/LN`.
    temp5-productid = `HT-1073`.
    temp5-suppliername = `Smartcards`.
    temp5-price = `139.99`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Photo Scan`.
    temp5-productid = `HT-1080`.
    temp5-suppliername = `Printer for All`.
    temp5-price = `129`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Power Scan`.
    temp5-productid = `HT-1081`.
    temp5-suppliername = `Printer for All`.
    temp5-price = `89`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Jet Scan Professional`.
    temp5-productid = `HT-1082`.
    temp5-suppliername = `Printer for All`.
    temp5-price = `169`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Jet Scan Professional`.
    temp5-productid = `HT-1083`.
    temp5-suppliername = `Printer for All`.
    temp5-price = `189`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Copymaster`.
    temp5-productid = `HT-1085`.
    temp5-suppliername = `Alpha Printers`.
    temp5-price = `1499`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Surround Sound`.
    temp5-productid = `HT-1090`.
    temp5-suppliername = `Speaker Experts`.
    temp5-price = `39`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Blaster Extreme`.
    temp5-productid = `HT-1091`.
    temp5-suppliername = `Speaker Experts`.
    temp5-price = `26`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Sound Booster`.
    temp5-productid = `HT-1092`.
    temp5-suppliername = `Speaker Experts`.
    temp5-price = `45`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Lovely Sound 5.1 Wireless`.
    temp5-productid = `HT-1095`.
    temp5-suppliername = `Fasttech`.
    temp5-price = `49`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Lovely Sound 5.1`.
    temp5-productid = `HT-1096`.
    temp5-suppliername = `Fasttech`.
    temp5-price = `39`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Lovely Sound Stereo`.
    temp5-productid = `HT-1097`.
    temp5-suppliername = `Fasttech`.
    temp5-price = `29`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Office`.
    temp5-productid = `HT-1100`.
    temp5-suppliername = `Technocom`.
    temp5-price = `89.9`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Design`.
    temp5-productid = `HT-1101`.
    temp5-suppliername = `Technocom`.
    temp5-price = `79.9`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Network`.
    temp5-productid = `HT-1102`.
    temp5-suppliername = `Technocom`.
    temp5-price = `69`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Multimedia`.
    temp5-productid = `HT-1103`.
    temp5-suppliername = `Technocom`.
    temp5-price = `77`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Games`.
    temp5-productid = `HT-1104`.
    temp5-suppliername = `Technocom`.
    temp5-price = `55`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Internet Antivirus`.
    temp5-productid = `HT-1105`.
    temp5-suppliername = `Brainsoft`.
    temp5-price = `29`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Firewall`.
    temp5-productid = `HT-1106`.
    temp5-suppliername = `Brainsoft`.
    temp5-price = `34`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smart Money`.
    temp5-productid = `HT-1107`.
    temp5-suppliername = `Brainsoft`.
    temp5-price = `29.9`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `PC Lock`.
    temp5-productid = `HT-1110`.
    temp5-suppliername = `Red Point Stores`.
    temp5-price = `8.9`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Notebook Lock`.
    temp5-productid = `HT-1111`.
    temp5-suppliername = `Red Point Stores`.
    temp5-price = `6.9`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Web cam reality`.
    temp5-productid = `HT-1112`.
    temp5-suppliername = `Red Point Stores`.
    temp5-price = `39`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Screen clean`.
    temp5-productid = `HT-1113`.
    temp5-suppliername = `Red Point Stores`.
    temp5-price = `2.3`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Fabric bag professional`.
    temp5-productid = `HT-1114`.
    temp5-suppliername = `Red Point Stores`.
    temp5-price = `31`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Wireless DSL Router`.
    temp5-productid = `HT-1115`.
    temp5-suppliername = `Red Point Stores`.
    temp5-price = `49`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Wireless DSL Router / Repeater`.
    temp5-productid = `HT-1116`.
    temp5-suppliername = `Red Point Stores`.
    temp5-price = `59`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Wireless DSL Router / Repeater and Print Server`.
    temp5-productid = `HT-1117`.
    temp5-suppliername = `Technocom`.
    temp5-price = `69`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `USB Stick`.
    temp5-productid = `HT-1118`.
    temp5-suppliername = `Technocom`.
    temp5-price = `35`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Travel Adapter`.
    temp5-productid = `HT-1119`.
    temp5-suppliername = `Titanium`.
    temp5-price = `79`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Cordless Bluetooth Keyboard, english international`.
    temp5-productid = `HT-1120`.
    temp5-suppliername = `Technocom`.
    temp5-price = `29`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flat XXL`.
    temp5-productid = `HT-1137`.
    temp5-suppliername = `Technocom`.
    temp5-price = `1430`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Pocket Mouse`.
    temp5-productid = `HT-1138`.
    temp5-suppliername = `Technocom`.
    temp5-price = `23`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `PC Power Station`.
    temp5-productid = `HT-1210`.
    temp5-suppliername = `Technocom`.
    temp5-price = `2399`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Astro Laptop 1516`.
    temp5-productid = `HT-1251`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-price = `989`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Astro Phone 6`.
    temp5-productid = `HT-1252`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-price = `649`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Benda Laptop 1408`.
    temp5-productid = `HT-1253`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-price = `976`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Bending Screen 21HD`.
    temp5-productid = `HT-1254`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-price = `250`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Broad Screen 22HD`.
    temp5-productid = `HT-1255`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-price = `270`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Cerdik Phone 7`.
    temp5-productid = `HT-1256`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-price = `549`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Cepat Tablet 10.5`.
    temp5-productid = `HT-1257`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-price = `549`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Cepat Tablet 8`.
    temp5-productid = `HT-1258`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-price = `529`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Server Basic`.
    temp5-productid = `HT-1500`.
    temp5-suppliername = `Technocom`.
    temp5-price = `5000`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Server Professional`.
    temp5-productid = `HT-1501`.
    temp5-suppliername = `Technocom`.
    temp5-price = `15000`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Server Power Pro`.
    temp5-productid = `HT-1502`.
    temp5-suppliername = `Technocom`.
    temp5-price = `25000`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Family PC Basic`.
    temp5-productid = `HT-1600`.
    temp5-suppliername = `Titanium`.
    temp5-price = `600`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Family PC Pro`.
    temp5-productid = `HT-1601`.
    temp5-suppliername = `Titanium`.
    temp5-price = `900`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Gaming Monster`.
    temp5-productid = `HT-1602`.
    temp5-suppliername = `Titanium`.
    temp5-price = `1200`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Gaming Monster Pro`.
    temp5-productid = `HT-1603`.
    temp5-suppliername = `Titanium`.
    temp5-price = `1700`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `7" Widescreen Portable DVD Player w MP3`.
    temp5-productid = `HT-2000`.
    temp5-suppliername = `Titanium`.
    temp5-price = `249.99`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `10" Portable DVD player`.
    temp5-productid = `HT-2001`.
    temp5-suppliername = `Titanium`.
    temp5-price = `449.99`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Portable DVD Player with 9" LCD Monitor`.
    temp5-productid = `HT-2002`.
    temp5-suppliername = `Technocom`.
    temp5-price = `853.99`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `CD/DVD case: 264 sleeves`.
    temp5-productid = `HT-2025`.
    temp5-suppliername = `Titanium`.
    temp5-price = `44.99`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Audio/Video Cable Kit - 4m`.
    temp5-productid = `HT-2026`.
    temp5-suppliername = `Titanium`.
    temp5-price = `29.99`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Removable CD/DVD Laser Labels`.
    temp5-productid = `HT-2027`.
    temp5-suppliername = `Titanium`.
    temp5-price = `8.99`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Beam Breaker B-1`.
    temp5-productid = `HT-6100`.
    temp5-suppliername = `Titanium`.
    temp5-price = `469`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Beam Breaker B-2`.
    temp5-productid = `HT-6101`.
    temp5-suppliername = `Technocom`.
    temp5-price = `679`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Beam Breaker B-3`.
    temp5-productid = `HT-6102`.
    temp5-suppliername = `Technocom`.
    temp5-price = `889`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Play Movie`.
    temp5-productid = `HT-6110`.
    temp5-suppliername = `Fasttech`.
    temp5-price = `130`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Record Movie`.
    temp5-productid = `HT-6111`.
    temp5-suppliername = `Fasttech`.
    temp5-price = `288`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelo MusicStick`.
    temp5-productid = `HT-6120`.
    temp5-suppliername = `Fasttech`.
    temp5-price = `45`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelo Jog-Mate`.
    temp5-productid = `HT-6121`.
    temp5-suppliername = `Fasttech`.
    temp5-price = `63`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Power Pro Player 40`.
    temp5-productid = `HT-6122`.
    temp5-suppliername = `Fasttech`.
    temp5-price = `167`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Power Pro Player 80`.
    temp5-productid = `HT-6123`.
    temp5-suppliername = `Fasttech`.
    temp5-price = `299`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flat Watch HD32`.
    temp5-productid = `HT-6130`.
    temp5-suppliername = `Very Best Screens`.
    temp5-price = `1459`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flat Watch HD37`.
    temp5-productid = `HT-6131`.
    temp5-suppliername = `Very Best Screens`.
    temp5-price = `1199`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flat Watch HD41`.
    temp5-productid = `HT-6132`.
    temp5-suppliername = `Very Best Screens`.
    temp5-price = `899`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Copperberry`.
    temp5-productid = `HT-7000`.
    temp5-suppliername = `Fasttech`.
    temp5-price = `549`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Silverberry`.
    temp5-productid = `HT-7010`.
    temp5-suppliername = `Fasttech`.
    temp5-price = `549`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Goldberry`.
    temp5-productid = `HT-7020`.
    temp5-suppliername = `Fasttech`.
    temp5-price = `549`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Platinberry`.
    temp5-productid = `HT-7030`.
    temp5-suppliername = `Fasttech`.
    temp5-price = `549`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelO FlexTop I4000`.
    temp5-productid = `HT-8000`.
    temp5-suppliername = `Titanium`.
    temp5-price = `799`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelO FlexTop I6300c`.
    temp5-productid = `HT-8001`.
    temp5-suppliername = `Titanium`.
    temp5-price = `799`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelO FlexTop I9100`.
    temp5-productid = `HT-8002`.
    temp5-suppliername = `Titanium`.
    temp5-price = `1199`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `ITelO FlexTop I9800`.
    temp5-productid = `HT-8003`.
    temp5-suppliername = `Titanium`.
    temp5-price = `1388`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smartphone Leather Case`.
    temp5-productid = `HT-9991`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-price = `25`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smartphone Alpha`.
    temp5-productid = `HT-9992`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-price = `599`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Mini Tablet`.
    temp5-productid = `HT-9993`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-price = `833`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Camcorder View`.
    temp5-productid = `HT-9994`.
    temp5-suppliername = `Ultrasonic United`.
    temp5-price = `1388`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Tablet Pouch`.
    temp5-productid = `HT-9995`.
    temp5-suppliername = `Titanium`.
    temp5-price = `20`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Tablet Pouch`.
    temp5-productid = `HT-9996`.
    temp5-suppliername = `Titanium`.
    temp5-price = `20`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `e-Book Reader ReadMe`.
    temp5-productid = `HT-9997`.
    temp5-suppliername = `Titanium`.
    temp5-price = `33`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Smartphone Beta`.
    temp5-productid = `HT-9998`.
    temp5-suppliername = `Titanium`.
    temp5-price = `30`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Maxi Tablet`.
    temp5-productid = `HT-9999`.
    temp5-suppliername = `Titanium`.
    temp5-price = `749`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    temp5-name = `Flyer`.
    temp5-productid = `PF-1000`.
    temp5-suppliername = `Titanium`.
    temp5-price = `0`.
    temp5-currencycode = `EUR`.
    INSERT temp5 INTO TABLE temp4.
    t_products = temp4.

  ENDMETHOD.

ENDCLASS.
