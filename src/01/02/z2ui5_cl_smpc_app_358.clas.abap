CLASS z2ui5_cl_smpc_app_358 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        productid           TYPE string,
        typecode            TYPE string,
        category            TYPE string,
        name                TYPE string,
        namelanguage        TYPE string,
        description         TYPE string,
        descriptionlanguage TYPE string,
        supplierid          TYPE string,
        suppliername        TYPE string,
        taxtarifcode        TYPE i,
        measureunit         TYPE string,
        weightmeasure       TYPE string,
        weightunit          TYPE string,
        currencycode        TYPE string,
        price               TYPE string,
        width               TYPE string,
        depth               TYPE string,
        height              TYPE string,
        dimunit             TYPE string,
        createdat           TYPE string,
        changedat           TYPE string,
      END OF ty_s_product.
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_358 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    " the metadata-driven table. The original binds the columns aggregation to
    " the OData METAMODEL and builds each Column in a JS factory; a control
    " factory is not expressible in abap2UI5 - and it does not have to be,
    " because the decision it makes belongs in the backend anyway. The
    " twenty-one columns are therefore written out here exactly as the factory
    " would produce them from the sample's metadata.xml: visible unless
    " sap:visible="false" or a unit-of-measure / currency-code semantic, the
    " width from maxLength (>50 -> 15rem, >9 -> 10rem, else 5rem),
    " sortProperty / filterProperty only where the metadata allows it, End
    " alignment for the Edm.Decimal columns, the sap:label as the header text,
    " and a u:Currency template for the one property whose sap:unit carries the
    " currency-code semantic (Price / CurrencyCode).
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`     v = `sap.ui.table`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns:u`   v = `sap.ui.unified`
        )->a( n = `xmlns:c`   v = `sap.ui.core`
        )->a( n = `xmlns:m`   v = `sap.m`
        )->a( n = `height`    v = `100%`

        )->ele( n = `Page` ns = `m`
            )->a( n = `showHeader`      v = `false`
            )->a( n = `enableScrolling` v = `false`
            )->a( n = `class`           v = `sapUiContentPadding`

            )->ele( n = `content` ns = `m`
                )->ele( `Table`
                    )->a( n = `id`                  v = `table`
                    )->a( n = `selectionMode`       v = `MultiToggle`
                    )->a( n = `enableSelectAll`     v = `false`
                    )->a( n = `rows`                v = client->_bind( t_products )
                    )->a( n = `threshold`           v = `15`
                    )->a( n = `enableBusyIndicator` v = `true`
                    )->a( n = `ariaLabelledBy`      v = `title`

                    )->ele( `extension`
                        )->ele( n = `OverflowToolbar` ns = `m`
                            )->a( n = `style` v = `Clear`

                            )->tag( n = `Title` ns = `m`
                                )->a( n = `id`   v = `title`
                                )->a( n = `text` v = `Products`

                        )->end(
                    )->end(
                    )->ele( `noData`
                        )->tag( n = `BusyIndicator` ns = `m`
                            )->a( n = `class` v = `sapUiMediumMargin`

                    )->end(
                    )->ele( `columns`
                        )->ele( `Column`
                            )->a( n = `visible` v = `true`
                            )->a( n = `width`   v = `10rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Product ID`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{PRODUCTID}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `visible` v = `true`
                            )->a( n = `width`   v = `5rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Prod. Type Code`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{TYPECODE}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `visible`        v = `true`
                            )->a( n = `sortProperty`   v = `CATEGORY`
                            )->a( n = `filterProperty` v = `CATEGORY`
                            )->a( n = `width`          v = `10rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Category`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{CATEGORY}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `visible`        v = `true`
                            )->a( n = `sortProperty`   v = `NAME`
                            )->a( n = `filterProperty` v = `NAME`
                            )->a( n = `width`          v = `15rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Product Name`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{NAME}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `visible` v = `false`
                            )->a( n = `width`   v = `5rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Language`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{NAMELANGUAGE}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `visible` v = `true`
                            )->a( n = `width`   v = `15rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Prod.Descrip.`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{DESCRIPTION}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `visible` v = `false`
                            )->a( n = `width`   v = `5rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Language`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{DESCRIPTIONLANGUAGE}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `visible` v = `true`
                            )->a( n = `width`   v = `10rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Supplier ID`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{SUPPLIERID}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `visible` v = `true`
                            )->a( n = `width`   v = `15rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Supplier Company Name`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{SUPPLIERNAME}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `visible` v = `false`
                            )->a( n = `width`   v = `10rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Prod. Tax Code`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{TAXTARIFCODE}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `visible` v = `false`
                            )->a( n = `width`   v = `5rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Qty. Unit`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{MEASUREUNIT}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `visible` v = `false`
                            )->a( n = `width`   v = `10rem`
                            )->a( n = `hAlign`  v = `End`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Wt. Measure`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{WEIGHTMEASURE}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `visible` v = `false`
                            )->a( n = `width`   v = `5rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Qty. Unit`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{WEIGHTUNIT}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `visible` v = `false`
                            )->a( n = `width`   v = `5rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Currency`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{CURRENCYCODE}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `visible` v = `true`
                            )->a( n = `width`   v = `10rem`
                            )->a( n = `hAlign`  v = `End`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Unit Price`

                            )->ele( `template`
                                )->tag( n = `Currency` ns = `u`
                                    )->a( n = `value`    v = |\{ path: 'PRICE', type: 'sap.ui.model.type.String' \}|
                                    )->a( n = `currency` v = `{CURRENCYCODE}`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `visible` v = `false`
                            )->a( n = `width`   v = `10rem`
                            )->a( n = `hAlign`  v = `End`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Dimensions`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{WIDTH}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `visible` v = `false`
                            )->a( n = `width`   v = `10rem`
                            )->a( n = `hAlign`  v = `End`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Dimensions`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{DEPTH}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `visible` v = `false`
                            )->a( n = `width`   v = `10rem`
                            )->a( n = `hAlign`  v = `End`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Dimensions`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{HEIGHT}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `visible` v = `false`
                            )->a( n = `width`   v = `5rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Dim. Unit`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{DIMUNIT}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `visible` v = `false`
                            )->a( n = `width`   v = `10rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Time Stamp`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{CREATEDAT}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `visible` v = `false`
                            )->a( n = `width`   v = `10rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Time Stamp`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{CHANGEDAT}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                    )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " the OData ProductSet the sample serves from a MockServer, inlined in full
    " (all 115 rows of ProductSet.json, every property the metadata declares -
    " the metadata-driven columns render all of them)
    t_products = VALUE #(
      ( productid = `AD-1000` typecode = `AD` category = `Computer system accessories` name = `Flyer` namelanguage = `E` description = `Flyer for our product palette` descriptionlanguage = `E` supplierid = `0100000015`
        suppliername = `Robert Brown Entertainment` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.01` weightunit = `KG` currencycode = `CAD` price = `0.0` width = `0.46` depth = `0.3` height = `0.03` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1000` typecode = `PR` category = `Notebooks` name = `Notebook Basic 15` namelanguage = `E` description = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`
        descriptionlanguage = `E` supplierid = `0100000000` suppliername = `SAP` taxtarifcode = 1 measureunit = `EA` weightmeasure = `4.2` weightunit = `KG` currencycode = `EUR` price = `956.0` width = `0.3` depth = `0.18` height = `0.03`
        dimunit = `M` createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1001` typecode = `PR` category = `Notebooks` name = `Notebook Basic 17` namelanguage = `E` description = `Notebook Basic 17 with 2,80 GHz quad core, 17" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`
        descriptionlanguage = `E` supplierid = `0100000001` suppliername = `Becker Berlin` taxtarifcode = 1 measureunit = `EA` weightmeasure = `4.5` weightunit = `KG` currencycode = `EUR` price = `1249.0` width = `0.29` depth = `0.17` height = `0.03`
        dimunit = `M` createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1002` typecode = `PR` category = `Notebooks` name = `Notebook Basic 18` namelanguage = `E` description = `Notebook Basic 18 with 2,80 GHz quad core, 18" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`
        descriptionlanguage = `E` supplierid = `0100000002` suppliername = `DelBont Industries` taxtarifcode = 1 measureunit = `EA` weightmeasure = `4.2` weightunit = `KG` currencycode = `USD` price = `1570.0` width = `0.28` depth = `0.19`
        height = `0.03` dimunit = `M` createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1003` typecode = `PR` category = `Notebooks` name = `Notebook Basic 19` namelanguage = `E` description = `Notebook Basic 19 with 2,80 GHz quad core, 19" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`
        descriptionlanguage = `E` supplierid = `0100000003` suppliername = `Talpa` taxtarifcode = 1 measureunit = `EA` weightmeasure = `4.2` weightunit = `KG` currencycode = `EUR` price = `1650.0` width = `0.32` depth = `0.21` height = `0.04`
        dimunit = `M` createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1007` typecode = `PR` category = `PDAs/Organizers` name = `ITelO Vault` namelanguage = `E` description = `Digital Organizer with State-of-the-Art Storage Encryption` descriptionlanguage = `E` supplierid = `0100000004`
        suppliername = `Panorama Studios` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.2` weightunit = `KG` currencycode = `USD` price = `299.0` width = `0.32` depth = `0.22` height = `0.03` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1010` typecode = `PR` category = `Notebooks` name = `Notebook Professional 15` namelanguage = `E`
        description = `Notebook Professional 15 with 2,80 GHz quad core, 15" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro` descriptionlanguage = `E` supplierid = `0100000005` suppliername = `TECUM`
        taxtarifcode = 1 measureunit = `EA` weightmeasure = `4.3` weightunit = `KG` currencycode = `EUR` price = `1999.0` width = `0.33` depth = `0.2` height = `0.03` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1011` typecode = `PR` category = `Notebooks` name = `Notebook Professional 17` namelanguage = `E`
        description = `Notebook Professional 17 with 2,80 GHz quad core, 17" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro` descriptionlanguage = `E` supplierid = `0100000006` suppliername = `Asia High tech`
        taxtarifcode = 1 measureunit = `EA` weightmeasure = `4.1` weightunit = `KG` currencycode = `JPY` price = `2299.0` width = `0.33` depth = `0.23` height = `0.02` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1020` typecode = `PR` category = `PDAs/Organizers` name = `ITelO Vault Net` namelanguage = `E` description = `Digital Organizer with State-of-the-Art Encryption for Storage and Network Communications` descriptionlanguage = `E`
        supplierid = `0100000007` suppliername = `Laurent` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.16` weightunit = `KG` currencycode = `EUR` price = `459.0` width = `0.1` depth = `0.02` height = `0.17` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1021` typecode = `PR` category = `PDAs/Organizers` name = `ITelO Vault SAT` namelanguage = `E` description = `Digital Organizer with State-of-the-Art Encryption for Storage and Secure Stellite Link` descriptionlanguage = `E`
        supplierid = `0100000008` suppliername = `AVANTEL` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.18` weightunit = `KG` currencycode = `MXN` price = `149.0` width = `0.11` depth = `0.02` height = `0.18` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1022` typecode = `PR` category = `PDAs/Organizers` name = `Comfort Easy` namelanguage = `E` description = `32 GB Digital Assitant with high-resolution color screen` descriptionlanguage = `E` supplierid = `0100000009`
        suppliername = `Telecomunicaciones Star` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.2` weightunit = `KG` currencycode = `ARS` price = `1679.0` width = `0.84` depth = `0.02` height = `0.14` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1023` typecode = `PR` category = `PDAs/Organizers` name = `Comfort Senior` namelanguage = `E` description = `64 GB Digital Assitant with high-resolution color screen and synthesized voice output` descriptionlanguage = `E`
        supplierid = `0100000010` suppliername = `Pear Computing Services` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.8` weightunit = `KG` currencycode = `USD` price = `512.0` width = `0.8` depth = `0.02` height = `0.13` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1030` typecode = `PR` category = `Flat screens` name = `Ergo Screen E-I` namelanguage = `E` description = `Optimum Hi-Resolution max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm` descriptionlanguage = `E` supplierid = `0100000011`
        suppliername = `Alpine Systems` taxtarifcode = 1 measureunit = `EA` weightmeasure = `21.0` weightunit = `KG` currencycode = `EUR` price = `230.0` width = `0.37` depth = `0.12` height = `0.36` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1031` typecode = `PR` category = `Flat screens` name = `Ergo Screen E-II` namelanguage = `E` description = `Optimum Hi-Resolution max. 1920 x 1200 @ 85Hz, Dot Pitch: 0.26mm` descriptionlanguage = `E` supplierid = `0100000012`
        suppliername = `New Line Design` taxtarifcode = 1 measureunit = `EA` weightmeasure = `21.0` weightunit = `KG` currencycode = `GBP` price = `285.0` width = `0.41` depth = `0.19` height = `0.43` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1032` typecode = `PR` category = `Flat screens` name = `Ergo Screen E-III` namelanguage = `E` description = `Optimum Hi-Resolution max. 2560 x 1440 @ 85Hz, Dot Pitch: 0.25mm` descriptionlanguage = `E` supplierid = `0100000013`
        suppliername = `HEPA Tec` taxtarifcode = 1 measureunit = `EA` weightmeasure = `21.0` weightunit = `KG` currencycode = `EUR` price = `345.0` width = `0.41` depth = `0.19` height = `0.43` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1035` typecode = `PR` category = `Flat screens` name = `Flat Basic` namelanguage = `E` description = `Optimum Hi-Resolution max. 1600 x 1200 @ 85Hz, Dot Pitch: 0.24mm` descriptionlanguage = `E` supplierid = `0100000014`
        suppliername = `Anav Ideon` taxtarifcode = 1 measureunit = `EA` weightmeasure = `14.0` weightunit = `KG` currencycode = `USD` price = `399.0` width = `0.39` depth = `0.2` height = `0.41` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1036` typecode = `PR` category = `Flat screens` name = `Flat Future` namelanguage = `E` description = `Optimum Hi-Resolution max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.26mm` descriptionlanguage = `E` supplierid = `0100000015`
        suppliername = `Robert Brown Entertainment` taxtarifcode = 1 measureunit = `EA` weightmeasure = `15.0` weightunit = `KG` currencycode = `CAD` price = `430.0` width = `0.45` depth = `0.26` height = `0.46` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1037` typecode = `PR` category = `Flat screens` name = `Flat XL` namelanguage = `E` description = `Optimum Hi-Resolution max. 2016 x 1512 @ 85Hz, Dot Pitch: 0.24mm` descriptionlanguage = `E` supplierid = `0100000016`
        suppliername = `Mexican Oil Trading Company` taxtarifcode = 1 measureunit = `EA` weightmeasure = `17.0` weightunit = `KG` currencycode = `MXN` price = `1230.0` width = `0.55` depth = `0.22` height = `0.39` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1040` typecode = `PR` category = `Laser printers` name = `Laser Professional Eco` namelanguage = `E`
        description = `Print 2400 dpi image quality color documents at speeds of up to 32 ppm (color) or 36 ppm (monochrome), letter/A4. Powerful 500 MHz processor, 512MB of memory` descriptionlanguage = `E` supplierid = `0100000017`
        suppliername = `Meliva` taxtarifcode = 1 measureunit = `EA` weightmeasure = `32.0` weightunit = `KG` currencycode = `EUR` price = `830.0` width = `0.51` depth = `0.46` height = `0.3` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1041` typecode = `PR` category = `Laser printers` name = `Laser Basic` namelanguage = `E` description = `Up to 22 ppm color or 24 ppm monochrome A4/letter, powerful 500 MHz processor and 128MB of memory`
        descriptionlanguage = `E` supplierid = `0100000018` suppliername = `Compostela` taxtarifcode = 1 measureunit = `EA` weightmeasure = `23.0` weightunit = `KG` currencycode = `ARS` price = `490.0` width = `0.48` depth = `0.42` height = `0.26`
        dimunit = `M` createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1042` typecode = `PR` category = `Laser printers` name = `Laser Allround` namelanguage = `E`
        description = `Print up to 25 ppm letter and 24 ppm A4 color or monochrome, with a first-page-out-time of less than 13 seconds for monochrome and less than 15 seconds for color` descriptionlanguage = `E` supplierid = `0100000019`
        suppliername = `Pateu` taxtarifcode = 1 measureunit = `EA` weightmeasure = `17.0` weightunit = `KG` currencycode = `EUR` price = `349.0` width = `0.53` depth = `0.5` height = `0.65` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1050` typecode = `PR` category = `Ink jet printers` name = `Ultra Jet Super Color` namelanguage = `E`
        description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB, Ethernet` descriptionlanguage = `E` supplierid = `0100000020` suppliername = `Russian Electronic Trading Company`
        taxtarifcode = 1 measureunit = `EA` weightmeasure = `3.0` weightunit = `KG` currencycode = `RUB` price = `139.0` width = `0.41` depth = `0.41` height = `0.28` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1051` typecode = `PR` category = `Ink jet printers` name = `Ultra Jet Mobile` namelanguage = `E`
        description = `1000 dpi x 1000 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB - excellent dimensions for the small office` descriptionlanguage = `E` supplierid = `0100000021`
        suppliername = `Florida Holiday Company` taxtarifcode = 1 measureunit = `EA` weightmeasure = `1.9` weightunit = `KG` currencycode = `USD` price = `99.0` width = `0.46` depth = `0.32` height = `0.25` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1052` typecode = `PR` category = `Ink jet printers` name = `Ultra Jet Super Highspeed` namelanguage = `E`
        description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB2.0, Ethernet` descriptionlanguage = `E` supplierid = `0100000022` suppliername = `Quimica Madrilenos` taxtarifcode = 1
        measureunit = `EA` weightmeasure = `18.0` weightunit = `KG` currencycode = `EUR` price = `170.0` width = `0.41` depth = `0.41` height = `0.28` dimunit = `M` createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1055` typecode = `PR` category = `Multifunction printers` name = `Multi Print` namelanguage = `E`
        description = `1000 dpi x 1000 dpi - up to 16 ppm (mono) / up to 15 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 1200dpi x 2400dpi)` descriptionlanguage = `E` supplierid = `0100000023` suppliername = `Getränkegroßhandel Janssen`
        taxtarifcode = 1 measureunit = `EA` weightmeasure = `6.3` weightunit = `KG` currencycode = `EUR` price = `99.0` width = `0.55` depth = `0.45` height = `0.29` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1056` typecode = `PR` category = `Multifunction printers` name = `Multi Color` namelanguage = `E`
        description = `1200 dpi x 1200 dpi - up to 25 ppm (mono) / up to 24 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 2400dpi x 4800dpi, high resolution)` descriptionlanguage = `E` supplierid = `0100000024` suppliername = `JaTeCo`
        taxtarifcode = 1 measureunit = `EA` weightmeasure = `4.3` weightunit = `KG` currencycode = `JPY` price = `119.0` width = `0.51` depth = `0.41` height = `0.22` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1060` typecode = `PR` category = `Mice` name = `Cordless Mouse` namelanguage = `E` description = `Cordless Optical USB Mice, Laptop, Color: Black, Plug&Play` descriptionlanguage = `E` supplierid = `0100000025`
        suppliername = `Tessile Casa Di Roma` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.09` weightunit = `KG` currencycode = `EUR` price = `9.0` width = `0.06` depth = `0.15` height = `0.04` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1061` typecode = `PR` category = `Mice` name = `Speed Mouse` namelanguage = `E` description = `Optical USB, PS/2 Mouse, Color: Blue, 3-button-functionality (incl. Scroll wheel)` descriptionlanguage = `E`
        supplierid = `0100000026` suppliername = `Vente Et Réparation de Ordinateur` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.09` weightunit = `KG` currencycode = `EUR` price = `7.0` width = `0.07` depth = `0.15` height = `0.03`
        dimunit = `M` createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1062` typecode = `PR` category = `Mice` name = `Track Mouse` namelanguage = `E` description = `Optical USB Mouse, Color: Red, 5-button-functionality(incl. Scroll wheel), Plug&Play` descriptionlanguage = `E`
        supplierid = `0100000027` suppliername = `Developement Para O Governo` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.03` weightunit = `KG` currencycode = `ARS` price = `11.0` width = `0.0` depth = `0.01` height = `0.04` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1063` typecode = `PR` category = `Keyboards` name = `Ergonomic Keyboard` namelanguage = `E` description = `Ergonomic USB Keyboard for Desktop, Plug&Play` descriptionlanguage = `E` supplierid = `0100000028`
        suppliername = `Brazil Technologies` taxtarifcode = 1 measureunit = `EA` weightmeasure = `2.1` weightunit = `KG` currencycode = `BRL` price = `14.0` width = `0.5` depth = `0.21` height = `0.04` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1064` typecode = `PR` category = `Keyboards` name = `Internet Keyboard` namelanguage = `E` description = `Corded Keyboard with special keys for Internet Usability, USB` descriptionlanguage = `E` supplierid = `0100000029`
        suppliername = `C.R.T.U.` taxtarifcode = 1 measureunit = `EA` weightmeasure = `1.8` weightunit = `KG` currencycode = `CAD` price = `16.0` width = `0.52` depth = `0.25` height = `0.03` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1065` typecode = `PR` category = `Keyboards` name = `Media Keyboard` namelanguage = `E` description = `Corded Ergonomic Keyboard with special keys for Media Usability, USB` descriptionlanguage = `E` supplierid = `0100000030`
        suppliername = `Jologa` taxtarifcode = 1 measureunit = `EA` weightmeasure = `2.3` weightunit = `KG` currencycode = `CHF` price = `26.0` width = `0.51` depth = `0.23` height = `0.04` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1066` typecode = `PR` category = `Mousepads` name = `Mousepad` namelanguage = `E` description = `Nice mouse pad with ITelO Logo` descriptionlanguage = `E` supplierid = `0100000031` suppliername = `Baleda` taxtarifcode = 1
        measureunit = `EA` weightmeasure = `80.0` weightunit = `G` currencycode = `USD` price = `6.99` width = `0.15` depth = `0.06` height = `0.0` dimunit = `M` createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1067` typecode = `PR` category = `Mousepads` name = `Ergo Mousepad` namelanguage = `E` description = `Ergonomic mouse pad with ITelO Logo` descriptionlanguage = `E` supplierid = `0100000032` suppliername = `Angeré`
        taxtarifcode = 1 measureunit = `EA` weightmeasure = `80.0` weightunit = `G` currencycode = `EUR` price = `8.99` width = `0.15` depth = `0.06` height = `0.0` dimunit = `M` createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1068` typecode = `PR` category = `Mousepads` name = `Designer Mousepad` namelanguage = `E` description = `ITelO Mousepad Special Edition` descriptionlanguage = `E` supplierid = `0100000033` suppliername = `PC Gym Tec`
        taxtarifcode = 1 measureunit = `EA` weightmeasure = `90.0` weightunit = `G` currencycode = `USD` price = `12.99` width = `0.24` depth = `0.24` height = `0.01` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1069` typecode = `PR` category = `Computer system accessories` name = `Universal card reader` namelanguage = `E` description = `Universal card reader` descriptionlanguage = `E` supplierid = `0100000034`
        suppliername = `Japan Insurance Partner` taxtarifcode = 1 measureunit = `EA` weightmeasure = `45.0` weightunit = `G` currencycode = `JPY` price = `14.0` width = `0.01` depth = `0.01` height = `0.0` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1070` typecode = `PR` category = `Graphic cards` name = `Proctra X` namelanguage = `E` description = `Proctra X: PCI-E GDDR5 3072MB` descriptionlanguage = `E` supplierid = `0100000035` suppliername = `Entertainment Argentinia`
        taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.255` weightunit = `KG` currencycode = `ARS` price = `70.9` width = `0.22` depth = `0.35` height = `0.17` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1071` typecode = `PR` category = `Graphic cards` name = `Gladiator MX` namelanguage = `E` description = `Gladiator XLN: PCI-E GDDR5 3072MB DVI Out, TV Out low-noise` descriptionlanguage = `E` supplierid = `0100000036`
        suppliername = `African Gold And Diamond Corporation` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.3` weightunit = `KG` currencycode = `ZAR` price = `81.7` width = `0.22` depth = `0.35` height = `0.17` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1072` typecode = `PR` category = `Graphic cards` name = `Hurricane GX` namelanguage = `E` description = `Hurricane GX: PCI-E 691 GFLOPS game-optimized` descriptionlanguage = `E` supplierid = `0100000037`
        suppliername = `PicoBit` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.4` weightunit = `KG` currencycode = `USD` price = `101.2` width = `0.22` depth = `0.35` height = `0.17` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1073` typecode = `PR` category = `Graphic cards` name = `Hurricane GX/LN` namelanguage = `E` description = `Hurricane GX/LN: PCI-E 691 GFLOPS game-optimized, low-noise.` descriptionlanguage = `E` supplierid = `0100000038`
        suppliername = `Bionic Research Lab` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.4` weightunit = `KG` currencycode = `EUR` price = `139.99` width = `0.22` depth = `0.35` height = `0.17` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1080` typecode = `PR` category = `Scanners` name = `Photo Scan` namelanguage = `E` description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - Hi-Speed USB - Bluetooth` descriptionlanguage = `E`
        supplierid = `0100000039` suppliername = `Indian IT Trading Company` taxtarifcode = 1 measureunit = `EA` weightmeasure = `2.3` weightunit = `KG` currencycode = `INR` price = `129.0` width = `0.34` depth = `0.48` height = `0.05` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1081` typecode = `PR` category = `Scanners` name = `Power Scan` namelanguage = `E` description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - SCSI for backward compatibility` descriptionlanguage = `E`
        supplierid = `0100000040` suppliername = `Chemia A Technicznie Fabryka` taxtarifcode = 1 measureunit = `EA` weightmeasure = `2.4` weightunit = `KG` currencycode = `PLN` price = `89.0` width = `0.31` depth = `0.43` height = `0.07`
        dimunit = `M` createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1082` typecode = `PR` category = `Scanners` name = `Jet Scan Professional` namelanguage = `E` description = `Flatbed scanner - Letter - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module` descriptionlanguage = `E`
        supplierid = `0100000041` suppliername = `South American IT Company` taxtarifcode = 1 measureunit = `EA` weightmeasure = `3.2` weightunit = `KG` currencycode = `ARS` price = `169.0` width = `0.33` depth = `0.41` height = `0.12` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1083` typecode = `PR` category = `Scanners` name = `Jet Scan Professional` namelanguage = `E` description = `Flatbed scanner - A4 - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module` descriptionlanguage = `E`
        supplierid = `0100000042` suppliername = `Siwusha` taxtarifcode = 1 measureunit = `EA` weightmeasure = `3.2` weightunit = `KG` currencycode = `CNY` price = `189.0` width = `0.35` depth = `0.4` height = `0.1` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1085` typecode = `PR` category = `Multifunction printers` name = `Copymaster` namelanguage = `E` description = `Copymaster` descriptionlanguage = `E` supplierid = `0100000043` suppliername = `Danish Fish Trading Company`
        taxtarifcode = 1 measureunit = `EA` weightmeasure = `23.2` weightunit = `KG` currencycode = `DKK` price = `1499.0` width = `0.45` depth = `0.42` height = `0.22` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1090` typecode = `PR` category = `Speakers` name = `Surround Sound` namelanguage = `E` description = `PC multimedia speakers - 5 Watt (Total)` descriptionlanguage = `E` supplierid = `0100000044` suppliername = `Sorali`
        taxtarifcode = 1 measureunit = `EA` weightmeasure = `3.0` weightunit = `KG` currencycode = `EUR` price = `39.0` width = `0.12` depth = `0.1` height = `0.16` dimunit = `M` createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1091` typecode = `PR` category = `Speakers` name = `Blaster Extreme` namelanguage = `E` description = `PC multimedia speakers - 10 Watt (Total) - 2-way` descriptionlanguage = `E` supplierid = `0100000000` suppliername = `SAP`
        taxtarifcode = 1 measureunit = `EA` weightmeasure = `1.4` weightunit = `KG` currencycode = `EUR` price = `26.0` width = `0.13` depth = `0.11` height = `0.18` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1092` typecode = `PR` category = `Speakers` name = `Sound Booster` namelanguage = `E` description = `PC multimedia speakers - optimized for Blutooth/A2DP` descriptionlanguage = `E` supplierid = `0100000001`
        suppliername = `Becker Berlin` taxtarifcode = 1 measureunit = `EA` weightmeasure = `2.1` weightunit = `KG` currencycode = `EUR` price = `45.0` width = `0.12` depth = `0.1` height = `0.18` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1095` typecode = `PR` category = `Headsets` name = `Lovely Sound 5.1 Wireless` namelanguage = `E` description = `5.1 Headset, 40 Hz-20 kHz, Wireless` descriptionlanguage = `E` supplierid = `0100000033`
        suppliername = `PC Gym Tec` taxtarifcode = 1 measureunit = `EA` weightmeasure = `80.0` weightunit = `G` currencycode = `USD` price = `49.0` width = `0.24` depth = `0.02` height = `0.23` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1096` typecode = `PR` category = `Headsets` name = `Lovely Sound 5.1` namelanguage = `E` description = `5.1 Headset, 40 Hz-20 kHz, 3m cable` descriptionlanguage = `E` supplierid = `0100000034`
        suppliername = `Japan Insurance Partner` taxtarifcode = 1 measureunit = `EA` weightmeasure = `130.0` weightunit = `G` currencycode = `JPY` price = `39.0` width = `0.25` depth = `0.02` height = `0.19` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1097` typecode = `PR` category = `Headsets` name = `Lovely Sound Stereo` namelanguage = `E` description = `5.1 Headset, 40 Hz-20 kHz, 1m cable` descriptionlanguage = `E` supplierid = `0100000035`
        suppliername = `Entertainment Argentinia` taxtarifcode = 1 measureunit = `EA` weightmeasure = `60.0` weightunit = `G` currencycode = `ARS` price = `29.0` width = `0.21` depth = `0.02` height = `0.2` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1100` typecode = `PR` category = `Software` name = `Smart Office` namelanguage = `E` description = `Complete package, 1 User, Office Applications (word processing, spreadsheet, presentations)` descriptionlanguage = `E`
        supplierid = `0100000002` suppliername = `DelBont Industries` taxtarifcode = 1 measureunit = `EA` weightmeasure = `1.2` weightunit = `KG` currencycode = `USD` price = `89.9` width = `0.15` depth = `0.07` height = `0.21` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1101` typecode = `PR` category = `Software` name = `Smart Design` namelanguage = `E` description = `Complete package, 1 User, Image editing, processing` descriptionlanguage = `E` supplierid = `0100000003`
        suppliername = `Talpa` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.8` weightunit = `KG` currencycode = `EUR` price = `79.9` width = `0.14` depth = `0.07` height = `0.24` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1102` typecode = `PR` category = `Software` name = `Smart Network` namelanguage = `E` description = `Complete package, 1 User, Network Software Utilities, Useful Applications and Documentation` descriptionlanguage = `E`
        supplierid = `0100000004` suppliername = `Panorama Studios` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.8` weightunit = `KG` currencycode = `USD` price = `69.0` width = `0.16` depth = `0.06` height = `0.27` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1103` typecode = `PR` category = `Software` name = `Smart Multimedia` namelanguage = `E` description = `Complete package, 1 User, different Multimedia applications, playing music, watching DVDs, only with this Smart package`
        descriptionlanguage = `E` supplierid = `0100000005` suppliername = `TECUM` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.8` weightunit = `KG` currencycode = `EUR` price = `77.0` width = `0.11` depth = `0.03` height = `0.22`
        dimunit = `M` createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1104` typecode = `PR` category = `Software` name = `Smart Games` namelanguage = `E` description = `Complete package, 1 User, various games for amusement, logic, action, jump&run` descriptionlanguage = `E`
        supplierid = `0100000006` suppliername = `Asia High tech` taxtarifcode = 1 measureunit = `EA` weightmeasure = `1.1` weightunit = `KG` currencycode = `JPY` price = `55.0` width = `0.1` depth = `0.03` height = `0.3` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1105` typecode = `PR` category = `Software` name = `Smart Internet Antivirus` namelanguage = `E` description = `Complete package, 1 User, highly recommended for internet users as anti-virus protection`
        descriptionlanguage = `E` supplierid = `0100000007` suppliername = `Laurent` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.7` weightunit = `KG` currencycode = `EUR` price = `29.0` width = `0.16` depth = `0.04` height = `0.21`
        dimunit = `M` createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1106` typecode = `PR` category = `Software` name = `Smart Firewall` namelanguage = `E` description = `Complete package, 1 User, recommended for internet users, protect your PC against cyber-crime` descriptionlanguage = `E`
        supplierid = `0100000008` suppliername = `AVANTEL` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.9` weightunit = `KG` currencycode = `MXN` price = `34.0` width = `0.18` depth = `0.04` height = `0.23` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1107` typecode = `PR` category = `Software` name = `Smart Money` namelanguage = `E` description = `Complete package, 1 User, bring your money in your mind, see what you have and what you want` descriptionlanguage = `E`
        supplierid = `0100000009` suppliername = `Telecomunicaciones Star` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.5` weightunit = `KG` currencycode = `ARS` price = `29.9` width = `0.12` depth = `0.02` height = `0.19` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1110` typecode = `PR` category = `Computer system accessories` name = `PC Lock` namelanguage = `E` description = `Robust 3m anti-burglary protection for your laptop computer` descriptionlanguage = `E` supplierid = `0100000010`
        suppliername = `Pear Computing Services` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.03` weightunit = `KG` currencycode = `USD` price = `8.9` width = `0.2` depth = `0.08` height = `0.04` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1111` typecode = `PR` category = `Computer system accessories` name = `Notebook Lock` namelanguage = `E` description = `Robust 1m anti-burglary protection for your desktop computer` descriptionlanguage = `E`
        supplierid = `0100000011` suppliername = `Alpine Systems` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.02` weightunit = `KG` currencycode = `EUR` price = `6.9` width = `0.31` depth = `0.09` height = `0.07` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1112` typecode = `PR` category = `Computer system accessories` name = `Web cam reality` namelanguage = `E` description = `Color webcam, color, High-Speed USB` descriptionlanguage = `E` supplierid = `0100000012`
        suppliername = `New Line Design` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.075` weightunit = `KG` currencycode = `GBP` price = `39.0` width = `0.09` depth = `0.08` height = `0.01` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1113` typecode = `PR` category = `Computer system accessories` name = `Screen clean` namelanguage = `E` description = `10 separately packed screen wipes` descriptionlanguage = `E` supplierid = `0100000013`
        suppliername = `HEPA Tec` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.05` weightunit = `KG` currencycode = `EUR` price = `2.3` width = `0.02` depth = `0.02` height = `0.0` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1114` typecode = `PR` category = `Computer system accessories` name = `Fabric bag professional` namelanguage = `E` description = `Notebook bag, plenty of room for stationery and writing materials` descriptionlanguage = `E`
        supplierid = `0100000014` suppliername = `Anav Ideon` taxtarifcode = 1 measureunit = `EA` weightmeasure = `1.8` weightunit = `KG` currencycode = `USD` price = `31.0` width = `0.42` depth = `0.32` height = `0.07` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1115` typecode = `PR` category = `Telecommunication` name = `Wireless DSL Router` namelanguage = `E` description = `Wireless DSL Router (available in blue, black and silver)` descriptionlanguage = `E` supplierid = `0100000015`
        suppliername = `Robert Brown Entertainment` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.45` weightunit = `KG` currencycode = `CAD` price = `49.0` width = `0.19` depth = `0.18` height = `0.05` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1116` typecode = `PR` category = `Telecommunication` name = `Wireless DSL Router / Repeater` namelanguage = `E` description = `Wireless DSL Router / Repeater (available in blue, black and silver)` descriptionlanguage = `E`
        supplierid = `0100000016` suppliername = `Mexican Oil Trading Company` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.45` weightunit = `KG` currencycode = `MXN` price = `59.0` width = `0.19` depth = `0.18` height = `0.05`
        dimunit = `M` createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1117` typecode = `PR` category = `Telecommunication` name = `Wireless DSL Router / Repeater and Print Server` namelanguage = `E`
        description = `Wireless DSL Router / Repeater and Print Server (available in blue, black and silver)` descriptionlanguage = `E` supplierid = `0100000017` suppliername = `Meliva` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.45`
        weightunit = `KG` currencycode = `EUR` price = `69.0` width = `0.19` depth = `0.18` height = `0.05` dimunit = `M` createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1118` typecode = `PR` category = `Computer system accessories` name = `USB Stick` namelanguage = `E` description = `USB 2.0 High-Speed 64 GB` descriptionlanguage = `E` supplierid = `0100000018` suppliername = `Compostela`
        taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.015` weightunit = `KG` currencycode = `ARS` price = `35.0` width = `0.02` depth = `0.09` height = `0.01` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1119` typecode = `PR` category = `Computer system accessories` name = `Travel Adapter` namelanguage = `E` description = `Universal Travel Adapter` descriptionlanguage = `E` supplierid = `0100000010`
        suppliername = `Pear Computing Services` taxtarifcode = 1 measureunit = `EA` weightmeasure = `88.0` weightunit = `G` currencycode = `USD` price = `79.0` width = `0.02` depth = `0.03` height = `0.04` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1120` typecode = `PR` category = `Keyboards` name = `Cordless Bluetooth Keyboard, english international` namelanguage = `E` description = `Cordless Bluetooth Keyboard with English keys` descriptionlanguage = `E`
        supplierid = `0100000019` suppliername = `Pateu` taxtarifcode = 1 measureunit = `EA` weightmeasure = `1.0` weightunit = `KG` currencycode = `EUR` price = `29.0` width = `0.51` depth = `0.23` height = `0.04` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1137` typecode = `PR` category = `Flat screens` name = `Flat XXL` namelanguage = `E` description = `Optimum Hi-Resolution max. 2048 × 1536 @ 85Hz, Dot Pitch: 0.24mm` descriptionlanguage = `E` supplierid = `0100000020`
        suppliername = `Russian Electronic Trading Company` taxtarifcode = 1 measureunit = `EA` weightmeasure = `18.0` weightunit = `KG` currencycode = `RUB` price = `1430.0` width = `0.54` depth = `0.22` height = `0.38` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1138` typecode = `PR` category = `Mice` name = `Pocket Mouse` namelanguage = `E` description = `Portable pocket Mouse with retracting cord` descriptionlanguage = `E` supplierid = `0100000021`
        suppliername = `Florida Holiday Company` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.02` weightunit = `KG` currencycode = `USD` price = `23.0` width = `0.0` depth = `0.01` height = `0.01` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1210` typecode = `PR` category = `PCs` name = `PC Power Station` namelanguage = `E` description = `PC Power Station with 3,4 Ghz quad-core, 32 GB DDR3 SDRAM, feels like a PC, Windows 8 Pro` descriptionlanguage = `E`
        supplierid = `0100000022` suppliername = `Quimica Madrilenos` taxtarifcode = 1 measureunit = `EA` weightmeasure = `2.3` weightunit = `KG` currencycode = `EUR` price = `2399.0` width = `0.28` depth = `0.31` height = `0.43` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1500` typecode = `PR` category = `Servers` name = `Server Basic` namelanguage = `E` description = `Dual socket, quad-core processing server with 1333 MHz Front Side Bus with 10Gb connectivity` descriptionlanguage = `E`
        supplierid = `0100000023` suppliername = `Getränkegroßhandel Janssen` taxtarifcode = 1 measureunit = `EA` weightmeasure = `18.0` weightunit = `KG` currencycode = `EUR` price = `5000.0` width = `0.34` depth = `0.35` height = `0.23`
        dimunit = `M` createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1501` typecode = `PR` category = `Servers` name = `Server Professional` namelanguage = `E` description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 10Gb connectivity` descriptionlanguage = `E`
        supplierid = `0100000024` suppliername = `JaTeCo` taxtarifcode = 1 measureunit = `EA` weightmeasure = `25.0` weightunit = `KG` currencycode = `JPY` price = `15000.0` width = `0.29` depth = `0.3` height = `0.27` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1502` typecode = `PR` category = `Servers` name = `Server Power Pro` namelanguage = `E` description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 100Gb connectivity` descriptionlanguage = `E`
        supplierid = `0100000025` suppliername = `Tessile Casa Di Roma` taxtarifcode = 1 measureunit = `EA` weightmeasure = `35.0` weightunit = `KG` currencycode = `EUR` price = `25000.0` width = `0.22` depth = `0.27` height = `0.37` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1600` typecode = `PR` category = `PCs` name = `Family PC Basic` namelanguage = `E` description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Graphic Card: Proctra X, Windows 8` descriptionlanguage = `E`
        supplierid = `0100000009` suppliername = `Telecomunicaciones Star` taxtarifcode = 1 measureunit = `EA` weightmeasure = `4.8` weightunit = `KG` currencycode = `ARS` price = `600.0` width = `0.21` depth = `0.29` height = `0.38` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1601` typecode = `PR` category = `PCs` name = `Family PC Pro` namelanguage = `E` description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8` descriptionlanguage = `E`
        supplierid = `0100000008` suppliername = `AVANTEL` taxtarifcode = 1 measureunit = `EA` weightmeasure = `5.3` weightunit = `KG` currencycode = `MXN` price = `900.0` width = `0.25` depth = `0.32` height = `0.4` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1602` typecode = `PR` category = `PCs` name = `Gaming Monster` namelanguage = `E` description = `3,4 Ghz quad core, 8 GB DDR3 SDRAM, 2000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8` descriptionlanguage = `E`
        supplierid = `0100000007` suppliername = `Laurent` taxtarifcode = 1 measureunit = `EA` weightmeasure = `5.9` weightunit = `KG` currencycode = `EUR` price = `1200.0` width = `0.27` depth = `0.34` height = `0.47` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-1603` typecode = `PR` category = `PCs` name = `Gaming Monster Pro` namelanguage = `E` description = `3,4 Ghz quad core, 16 GB DDR3 SDRAM, 4000 GB Hard Disc, Graphic Card: Hurricane GX, Windows 8` descriptionlanguage = `E`
        supplierid = `0100000006` suppliername = `Asia High tech` taxtarifcode = 1 measureunit = `EA` weightmeasure = `6.8` weightunit = `KG` currencycode = `JPY` price = `1700.0` width = `0.27` depth = `0.28` height = `0.42` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-2000` typecode = `PR` category = `Portable Players` name = `7" Widescreen Portable DVD Player w MP3` namelanguage = `E` description = `7" LCD Screen, storage battery holds up to 6 hours!` descriptionlanguage = `E`
        supplierid = `0100000005` suppliername = `TECUM` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.79` weightunit = `KG` currencycode = `EUR` price = `249.99` width = `0.21` depth = `0.19` height = `0.28` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-2001` typecode = `PR` category = `Portable Players` name = `10" Portable DVD player` namelanguage = `E` description = `10" LCD Screen, storage battery holds up to 8 hours` descriptionlanguage = `E` supplierid = `0100000004`
        suppliername = `Panorama Studios` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.84` weightunit = `KG` currencycode = `USD` price = `449.99` width = `0.24` depth = `0.2` height = `0.29` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-2002` typecode = `PR` category = `Portable Players` name = `Portable DVD Player with 9" LCD Monitor` namelanguage = `E` description = `9" LCD Screen, storage holds up to 8 hours, 2 speakers included` descriptionlanguage = `E`
        supplierid = `0100000044` suppliername = `Sorali` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.72` weightunit = `KG` currencycode = `EUR` price = `853.99` width = `0.21` depth = `0.17` height = `0.14` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-2025` typecode = `PR` category = `Computer system accessories` name = `CD/DVD case: 264 sleeves` namelanguage = `E` description = `Organizer and protective case for 264 CDs and DVDs` descriptionlanguage = `E`
        supplierid = `0100000003` suppliername = `Talpa` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.65` weightunit = `KG` currencycode = `EUR` price = `44.99` width = `0.13` depth = `0.13` height = `0.2` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-2026` typecode = `PR` category = `Computer system accessories` name = `Audio/Video Cable Kit - 4m` namelanguage = `E` description = `Quality cables for notebooks and beamers` descriptionlanguage = `E` supplierid = `0100000002`
        suppliername = `DelBont Industries` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.2` weightunit = `KG` currencycode = `USD` price = `29.99` width = `0.21` depth = `0.1` height = `0.13` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-2027` typecode = `PR` category = `Computer system accessories` name = `Removable CD/DVD Laser Labels` namelanguage = `E` description = `Removable jewel case labels, zero residues (100)` descriptionlanguage = `E`
        supplierid = `0100000001` suppliername = `Becker Berlin` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.15` weightunit = `KG` currencycode = `EUR` price = `8.99` width = `0.06` depth = `0.02` height = `0.02` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-6100` typecode = `PR` category = `Beamers` name = `Beam Breaker B-1` namelanguage = `E` description = `720p, DLP beamer max. 8,45 Meter, 2D` descriptionlanguage = `E` supplierid = `0100000000` suppliername = `SAP`
        taxtarifcode = 1 measureunit = `EA` weightmeasure = `1.7` weightunit = `KG` currencycode = `EUR` price = `469.0` width = `0.3` depth = `0.23` height = `0.23` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-6101` typecode = `PR` category = `Beamers` name = `Beam Breaker B-2` namelanguage = `E` description = `1080p, DLP max.9,34 Meter, 2D-ready` descriptionlanguage = `E` supplierid = `0100000043`
        suppliername = `Danish Fish Trading Company` taxtarifcode = 1 measureunit = `EA` weightmeasure = `2.0` weightunit = `KG` currencycode = `DKK` price = `679.0` width = `0.3` depth = `0.23` height = `0.23` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-6102` typecode = `PR` category = `Beamers` name = `Beam Breaker B-3` namelanguage = `E` description = `1080p, DLP max. 12,3 Meter, 3D-ready` descriptionlanguage = `E` supplierid = `0100000042` suppliername = `Siwusha`
        taxtarifcode = 1 measureunit = `EA` weightmeasure = `2.5` weightunit = `KG` currencycode = `CNY` price = `889.0` width = `0.3` depth = `0.23` height = `0.23` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-6110` typecode = `PR` category = `Portable Players` name = `Play Movie` namelanguage = `E` description = `CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid` descriptionlanguage = `E`
        supplierid = `0100000041` suppliername = `South American IT Company` taxtarifcode = 1 measureunit = `EA` weightmeasure = `2.4` weightunit = `KG` currencycode = `ARS` price = `130.0` width = `0.37` depth = `0.24` height = `0.06` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-6111` typecode = `PR` category = `Portable Players` name = `Record Movie` namelanguage = `E` description = `160 GB HDD, CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid` descriptionlanguage = `E`
        supplierid = `0100000040` suppliername = `Chemia A Technicznie Fabryka` taxtarifcode = 1 measureunit = `EA` weightmeasure = `3.1` weightunit = `KG` currencycode = `PLN` price = `288.0` width = `0.38` depth = `0.26` height = `0.06`
        dimunit = `M` createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-6120` typecode = `PR` category = `MP3-Players` name = `ITelo MusickStick` namelanguage = `E` description = `64 GB USB Musick-on-a-Stick` descriptionlanguage = `E` supplierid = `0100000039`
        suppliername = `Indian IT Trading Company` taxtarifcode = 1 measureunit = `EA` weightmeasure = `134.0` weightunit = `G` currencycode = `INR` price = `45.0` width = `0.02` depth = `0.06` height = `0.01` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-6121` typecode = `PR` category = `MP3-Players` name = `ITelo Jog-Mate` namelanguage = `E` description = `ITelo Jog-Mate 64 GB HDD and Color Display, can play movies` descriptionlanguage = `E` supplierid = `0100000038`
        suppliername = `Bionic Research Lab` taxtarifcode = 1 measureunit = `EA` weightmeasure = `134.0` weightunit = `G` currencycode = `EUR` price = `63.0` width = `0.05` depth = `0.08` height = `0.09` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-6122` typecode = `PR` category = `MP3-Players` name = `Power Pro Player 40` namelanguage = `E` description = `MP3-Player with 40 GB HDD and Color Display, can play movies` descriptionlanguage = `E` supplierid = `0100000037`
        suppliername = `PicoBit` taxtarifcode = 1 measureunit = `EA` weightmeasure = `266.0` weightunit = `G` currencycode = `USD` price = `167.0` width = `0.05` depth = `0.08` height = `0.09` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-6123` typecode = `PR` category = `MP3-Players` name = `Power Pro Player 80` namelanguage = `E` description = `MP3-Player with 80 GB SSD and Color Display, can play movies` descriptionlanguage = `E` supplierid = `0100000036`
        suppliername = `African Gold And Diamond Corporation` taxtarifcode = 1 measureunit = `EA` weightmeasure = `267.0` weightunit = `G` currencycode = `ZAR` price = `299.0` width = `0.04` depth = `0.06` height = `0.01` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-6130` typecode = `PR` category = `TV flat screens` name = `Flat Watch HD32` namelanguage = `E` description = `32-inch, 1366x768 Pixel, 16:9, HDTV ready` descriptionlanguage = `E` supplierid = `0100000026`
        suppliername = `Vente Et Réparation de Ordinateur` taxtarifcode = 1 measureunit = `EA` weightmeasure = `2.6` weightunit = `KG` currencycode = `EUR` price = `1459.0` width = `0.78` depth = `0.22` height = `0.55` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-6131` typecode = `PR` category = `TV flat screens` name = `Flat Watch HD37` namelanguage = `E` description = `37-inch, 1366x768 Pixel, 16:9, HDTV ready` descriptionlanguage = `E` supplierid = `0100000027`
        suppliername = `Developement Para O Governo` taxtarifcode = 1 measureunit = `EA` weightmeasure = `2.2` weightunit = `KG` currencycode = `ARS` price = `1199.0` width = `0.99` depth = `0.26` height = `0.61` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-6132` typecode = `PR` category = `TV flat screens` name = `Flat Watch HD41` namelanguage = `E` description = `41-inch, 1366x768 Pixel, 16:9, HDTV ready` descriptionlanguage = `E` supplierid = `0100000028`
        suppliername = `Brazil Technologies` taxtarifcode = 1 measureunit = `EA` weightmeasure = `1.8` weightunit = `KG` currencycode = `BRL` price = `899.0` width = `1.28` depth = `0.23` height = `0.79` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-7000` typecode = `PR` category = `PDAs/Organizers` name = `Copperberry` namelanguage = `E` description = `Our new multifunctional Handheld with phone function in copper` descriptionlanguage = `E` supplierid = `0100000032`
        suppliername = `Angeré` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.5` weightunit = `KG` currencycode = `EUR` price = `549.0` width = `0.08` depth = `0.13` height = `0.12` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-7010` typecode = `PR` category = `PDAs/Organizers` name = `Silverberry` namelanguage = `E` description = `Our new multifunctional Handheld with phone function in silver` descriptionlanguage = `E` supplierid = `0100000031`
        suppliername = `Baleda` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.5` weightunit = `KG` currencycode = `USD` price = `549.0` width = `0.08` depth = `0.13` height = `0.12` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-7020` typecode = `PR` category = `PDAs/Organizers` name = `Goldberry` namelanguage = `E` description = `Our new multifunctional Handheld with phone function in gold` descriptionlanguage = `E` supplierid = `0100000030`
        suppliername = `Jologa` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.5` weightunit = `KG` currencycode = `CHF` price = `549.0` width = `0.08` depth = `0.13` height = `0.12` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-7030` typecode = `PR` category = `PDAs/Organizers` name = `Platinberry` namelanguage = `E` description = `Our new multifunctional Handheld with phone function in platinum` descriptionlanguage = `E` supplierid = `0100000029`
        suppliername = `C.R.T.U.` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.5` weightunit = `KG` currencycode = `CAD` price = `549.0` width = `0.08` depth = `0.13` height = `0.12` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-8000` typecode = `PR` category = `Notebooks` name = `ITelO FlexTop I4000` namelanguage = `E` description = `Notebook with 2,80 GHz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8` descriptionlanguage = `E`
        supplierid = `0100000011` suppliername = `Alpine Systems` taxtarifcode = 1 measureunit = `EA` weightmeasure = `4.0` weightunit = `KG` currencycode = `EUR` price = `799.0` width = `0.31` depth = `0.19` height = `0.03` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-8001` typecode = `PR` category = `Notebooks` name = `ITelO FlexTop I6300c` namelanguage = `E` description = `Notebook with 2,80 GHz dual core, 8 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8` descriptionlanguage = `E`
        supplierid = `0100000012` suppliername = `New Line Design` taxtarifcode = 1 measureunit = `EA` weightmeasure = `4.2` weightunit = `KG` currencycode = `GBP` price = `999.0` width = `0.32` depth = `0.2` height = `0.03` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-8002` typecode = `PR` category = `Notebooks` name = `ITelO FlexTop I9100` namelanguage = `E` description = `Notebook with 2,80 GHz quad core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8` descriptionlanguage = `E`
        supplierid = `0100000013` suppliername = `HEPA Tec` taxtarifcode = 1 measureunit = `EA` weightmeasure = `3.5` weightunit = `KG` currencycode = `EUR` price = `1199.0` width = `0.38` depth = `0.21` height = `0.04` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-8003` typecode = `PR` category = `Notebooks` name = `ITelO FlexTop I9800` namelanguage = `E` description = `Notebook with 2,80 GHz quad core, 8 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8` descriptionlanguage = `E`
        supplierid = `0100000014` suppliername = `Anav Ideon` taxtarifcode = 1 measureunit = `EA` weightmeasure = `3.8` weightunit = `KG` currencycode = `USD` price = `1388.0` width = `0.48` depth = `0.31` height = `0.05` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-9991` typecode = `PR` category = `Accessories` name = `Smartphone Leather Case` namelanguage = `E` description = `Button Clasp, Quality Material, 100% Leather, compatible with many smartphone models` descriptionlanguage = `E`
        supplierid = `0100000024` suppliername = `JaTeCo` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.02` weightunit = `KG` currencycode = `JPY` price = `25.0` width = `0.48` depth = `0.31` height = `0.05` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-9992` typecode = `PR` category = `Smartphones` name = `Smartphone Alpha` namelanguage = `E`
        description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black` descriptionlanguage = `E`
        supplierid = `0100000023` suppliername = `Getränkegroßhandel Janssen` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.75` weightunit = `KG` currencycode = `EUR` price = `599.0` width = `0.48` depth = `0.31` height = `0.05`
        dimunit = `M` createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-9993` typecode = `PR` category = `Tablets` name = `Mini Tablet` namelanguage = `E`
        description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage, 4325 mAh battery (Up to 8 hours of active use)` descriptionlanguage = `E` supplierid = `0100000022` suppliername = `Quimica Madrilenos`
        taxtarifcode = 1 measureunit = `EA` weightmeasure = `3.8` weightunit = `KG` currencycode = `EUR` price = `833.0` width = `0.48` depth = `0.31` height = `0.05` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-9994` typecode = `PR` category = `Camcorders` name = `Camcorder View` namelanguage = `E`
        description = `1920x1080 Full HD, image stabilization reduces blur, 27x Optical / 32x Extended Zoom, wide angle Lens, 2.7" wide LCD display` descriptionlanguage = `E` supplierid = `0100000021` suppliername = `Florida Holiday Company`
        taxtarifcode = 1 measureunit = `EA` weightmeasure = `3.8` weightunit = `KG` currencycode = `USD` price = `1388.0` width = `0.48` depth = `0.31` height = `0.27` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-9995` typecode = `PR` category = `Accessories` name = `Smartphone Cover` namelanguage = `E`
        description = `Durable high quality plastic bump-sleeve, lightweight, protects from scratches, rubber coating, multiple colors available, Accurate design and cut-outs for your device, snap-on design` descriptionlanguage = `E`
        supplierid = `0100000020` suppliername = `Russian Electronic Trading Company` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.02` weightunit = `KG` currencycode = `RUB` price = `15.0` width = `0.48` depth = `0.31` height = `0.05`
        dimunit = `M` createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-9996` typecode = `PR` category = `Accessories` name = `Tablet Pouch` namelanguage = `E` description = `Stylish tablet pouch, protects from scratches, color: black` descriptionlanguage = `E` supplierid = `0100000019`
        suppliername = `Pateu` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.03` weightunit = `KG` currencycode = `EUR` price = `20.0` width = `0.25` depth = `0.4` height = `0.05` dimunit = `M` createdat = `/Date(1414583899000)/`
        changedat = `/Date(1414583899000)/` )
      ( productid = `HT-9997` typecode = `PR` category = `Tablets` name = `e-Book Reader ReadMe` namelanguage = `E` description = `6-Inch E Ink Screen, Access To e-book Store, Adjustable Font Styles and Sizes, Stores Up To 1,000 Books`
        descriptionlanguage = `E` supplierid = `0100000018` suppliername = `Compostela` taxtarifcode = 1 measureunit = `EA` weightmeasure = `3.8` weightunit = `KG` currencycode = `ARS` price = `633.0` width = `0.48` depth = `0.31` height = `0.05`
        dimunit = `M` createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-9998` typecode = `PR` category = `Smartphones` name = `Smartphone Beta` namelanguage = `E` description = `5 Megapixel Camera, Wi-Fi 802.11 b/g/n, Bluetooth, GPS A-GPS support` descriptionlanguage = `E`
        supplierid = `0100000017` suppliername = `Meliva` taxtarifcode = 1 measureunit = `EA` weightmeasure = `0.75` weightunit = `KG` currencycode = `EUR` price = `699.0` width = `0.48` depth = `0.31` height = `0.05` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ( productid = `HT-9999` typecode = `PR` category = `Tablets` name = `Maxi Tablet` namelanguage = `E`
        description = `10.1-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor` descriptionlanguage = `E` supplierid = `0100000016`
        suppliername = `Mexican Oil Trading Company` taxtarifcode = 1 measureunit = `EA` weightmeasure = `3.8` weightunit = `KG` currencycode = `MXN` price = `749.0` width = `0.48` depth = `0.31` height = `0.05` dimunit = `M`
        createdat = `/Date(1414583899000)/` changedat = `/Date(1414583899000)/` )
      ).

  ENDMETHOD.

ENDCLASS.
