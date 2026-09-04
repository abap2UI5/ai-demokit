" @keywords table sap.ui.table odata2 overflowtoolbar title busyindicator column label text currency
" @summary Shows an example how an OData metadata driven table creation can look like.
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
    DATA t_products TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_358 IMPLEMENTATION.

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
    view = z2ui5_cl_ui5_view_builder=>factory( ).

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
    DATA temp1 LIKE t_products.
    DATA temp2 LIKE LINE OF temp1.
    CLEAR temp1.
    
    temp2-productid = `AD-1000`.
    temp2-typecode = `AD`.
    temp2-category = `Computer system accessories`.
    temp2-name = `Flyer`.
    temp2-namelanguage = `E`.
    temp2-description = `Flyer for our product palette`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000015`.
    temp2-suppliername = `Robert Brown Entertainment`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.01`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `CAD`.
    temp2-price = `0.0`.
    temp2-width = `0.46`.
    temp2-depth = `0.3`.
    temp2-height = `0.03`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1000`.
    temp2-typecode = `PR`.
    temp2-category = `Notebooks`.
    temp2-name = `Notebook Basic 15`.
    temp2-namelanguage = `E`.
    temp2-description = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000000`.
    temp2-suppliername = `SAP`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `4.2`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `956.0`.
    temp2-width = `0.3`.
    temp2-depth = `0.18`.
    temp2-height = `0.03`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1001`.
    temp2-typecode = `PR`.
    temp2-category = `Notebooks`.
    temp2-name = `Notebook Basic 17`.
    temp2-namelanguage = `E`.
    temp2-description = `Notebook Basic 17 with 2,80 GHz quad core, 17" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000001`.
    temp2-suppliername = `Becker Berlin`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `4.5`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `1249.0`.
    temp2-width = `0.29`.
    temp2-depth = `0.17`.
    temp2-height = `0.03`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1002`.
    temp2-typecode = `PR`.
    temp2-category = `Notebooks`.
    temp2-name = `Notebook Basic 18`.
    temp2-namelanguage = `E`.
    temp2-description = `Notebook Basic 18 with 2,80 GHz quad core, 18" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000002`.
    temp2-suppliername = `DelBont Industries`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `4.2`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `USD`.
    temp2-price = `1570.0`.
    temp2-width = `0.28`.
    temp2-depth = `0.19`.
    temp2-height = `0.03`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1003`.
    temp2-typecode = `PR`.
    temp2-category = `Notebooks`.
    temp2-name = `Notebook Basic 19`.
    temp2-namelanguage = `E`.
    temp2-description = `Notebook Basic 19 with 2,80 GHz quad core, 19" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000003`.
    temp2-suppliername = `Talpa`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `4.2`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `1650.0`.
    temp2-width = `0.32`.
    temp2-depth = `0.21`.
    temp2-height = `0.04`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1007`.
    temp2-typecode = `PR`.
    temp2-category = `PDAs/Organizers`.
    temp2-name = `ITelO Vault`.
    temp2-namelanguage = `E`.
    temp2-description = `Digital Organizer with State-of-the-Art Storage Encryption`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000004`.
    temp2-suppliername = `Panorama Studios`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.2`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `USD`.
    temp2-price = `299.0`.
    temp2-width = `0.32`.
    temp2-depth = `0.22`.
    temp2-height = `0.03`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1010`.
    temp2-typecode = `PR`.
    temp2-category = `Notebooks`.
    temp2-name = `Notebook Professional 15`.
    temp2-namelanguage = `E`.
    temp2-description = `Notebook Professional 15 with 2,80 GHz quad core, 15" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000005`.
    temp2-suppliername = `TECUM`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `4.3`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `1999.0`.
    temp2-width = `0.33`.
    temp2-depth = `0.2`.
    temp2-height = `0.03`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1011`.
    temp2-typecode = `PR`.
    temp2-category = `Notebooks`.
    temp2-name = `Notebook Professional 17`.
    temp2-namelanguage = `E`.
    temp2-description = `Notebook Professional 17 with 2,80 GHz quad core, 17" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000006`.
    temp2-suppliername = `Asia High tech`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `4.1`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `JPY`.
    temp2-price = `2299.0`.
    temp2-width = `0.33`.
    temp2-depth = `0.23`.
    temp2-height = `0.02`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1020`.
    temp2-typecode = `PR`.
    temp2-category = `PDAs/Organizers`.
    temp2-name = `ITelO Vault Net`.
    temp2-namelanguage = `E`.
    temp2-description = `Digital Organizer with State-of-the-Art Encryption for Storage and Network Communications`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000007`.
    temp2-suppliername = `Laurent`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.16`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `459.0`.
    temp2-width = `0.1`.
    temp2-depth = `0.02`.
    temp2-height = `0.17`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1021`.
    temp2-typecode = `PR`.
    temp2-category = `PDAs/Organizers`.
    temp2-name = `ITelO Vault SAT`.
    temp2-namelanguage = `E`.
    temp2-description = `Digital Organizer with State-of-the-Art Encryption for Storage and Secure Stellite Link`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000008`.
    temp2-suppliername = `AVANTEL`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.18`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `MXN`.
    temp2-price = `149.0`.
    temp2-width = `0.11`.
    temp2-depth = `0.02`.
    temp2-height = `0.18`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1022`.
    temp2-typecode = `PR`.
    temp2-category = `PDAs/Organizers`.
    temp2-name = `Comfort Easy`.
    temp2-namelanguage = `E`.
    temp2-description = `32 GB Digital Assitant with high-resolution color screen`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000009`.
    temp2-suppliername = `Telecomunicaciones Star`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.2`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `ARS`.
    temp2-price = `1679.0`.
    temp2-width = `0.84`.
    temp2-depth = `0.02`.
    temp2-height = `0.14`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1023`.
    temp2-typecode = `PR`.
    temp2-category = `PDAs/Organizers`.
    temp2-name = `Comfort Senior`.
    temp2-namelanguage = `E`.
    temp2-description = `64 GB Digital Assitant with high-resolution color screen and synthesized voice output`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000010`.
    temp2-suppliername = `Pear Computing Services`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.8`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `USD`.
    temp2-price = `512.0`.
    temp2-width = `0.8`.
    temp2-depth = `0.02`.
    temp2-height = `0.13`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1030`.
    temp2-typecode = `PR`.
    temp2-category = `Flat screens`.
    temp2-name = `Ergo Screen E-I`.
    temp2-namelanguage = `E`.
    temp2-description = `Optimum Hi-Resolution max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000011`.
    temp2-suppliername = `Alpine Systems`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `21.0`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `230.0`.
    temp2-width = `0.37`.
    temp2-depth = `0.12`.
    temp2-height = `0.36`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1031`.
    temp2-typecode = `PR`.
    temp2-category = `Flat screens`.
    temp2-name = `Ergo Screen E-II`.
    temp2-namelanguage = `E`.
    temp2-description = `Optimum Hi-Resolution max. 1920 x 1200 @ 85Hz, Dot Pitch: 0.26mm`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000012`.
    temp2-suppliername = `New Line Design`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `21.0`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `GBP`.
    temp2-price = `285.0`.
    temp2-width = `0.41`.
    temp2-depth = `0.19`.
    temp2-height = `0.43`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1032`.
    temp2-typecode = `PR`.
    temp2-category = `Flat screens`.
    temp2-name = `Ergo Screen E-III`.
    temp2-namelanguage = `E`.
    temp2-description = `Optimum Hi-Resolution max. 2560 x 1440 @ 85Hz, Dot Pitch: 0.25mm`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000013`.
    temp2-suppliername = `HEPA Tec`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `21.0`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `345.0`.
    temp2-width = `0.41`.
    temp2-depth = `0.19`.
    temp2-height = `0.43`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1035`.
    temp2-typecode = `PR`.
    temp2-category = `Flat screens`.
    temp2-name = `Flat Basic`.
    temp2-namelanguage = `E`.
    temp2-description = `Optimum Hi-Resolution max. 1600 x 1200 @ 85Hz, Dot Pitch: 0.24mm`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000014`.
    temp2-suppliername = `Anav Ideon`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `14.0`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `USD`.
    temp2-price = `399.0`.
    temp2-width = `0.39`.
    temp2-depth = `0.2`.
    temp2-height = `0.41`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1036`.
    temp2-typecode = `PR`.
    temp2-category = `Flat screens`.
    temp2-name = `Flat Future`.
    temp2-namelanguage = `E`.
    temp2-description = `Optimum Hi-Resolution max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.26mm`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000015`.
    temp2-suppliername = `Robert Brown Entertainment`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `15.0`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `CAD`.
    temp2-price = `430.0`.
    temp2-width = `0.45`.
    temp2-depth = `0.26`.
    temp2-height = `0.46`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1037`.
    temp2-typecode = `PR`.
    temp2-category = `Flat screens`.
    temp2-name = `Flat XL`.
    temp2-namelanguage = `E`.
    temp2-description = `Optimum Hi-Resolution max. 2016 x 1512 @ 85Hz, Dot Pitch: 0.24mm`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000016`.
    temp2-suppliername = `Mexican Oil Trading Company`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `17.0`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `MXN`.
    temp2-price = `1230.0`.
    temp2-width = `0.55`.
    temp2-depth = `0.22`.
    temp2-height = `0.39`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1040`.
    temp2-typecode = `PR`.
    temp2-category = `Laser printers`.
    temp2-name = `Laser Professional Eco`.
    temp2-namelanguage = `E`.
    temp2-description = `Print 2400 dpi image quality color documents at speeds of up to 32 ppm (color) or 36 ppm (monochrome), letter/A4. Powerful 500 MHz processor, 512MB of memory`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000017`.
    temp2-suppliername = `Meliva`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `32.0`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `830.0`.
    temp2-width = `0.51`.
    temp2-depth = `0.46`.
    temp2-height = `0.3`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1041`.
    temp2-typecode = `PR`.
    temp2-category = `Laser printers`.
    temp2-name = `Laser Basic`.
    temp2-namelanguage = `E`.
    temp2-description = `Up to 22 ppm color or 24 ppm monochrome A4/letter, powerful 500 MHz processor and 128MB of memory`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000018`.
    temp2-suppliername = `Compostela`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `23.0`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `ARS`.
    temp2-price = `490.0`.
    temp2-width = `0.48`.
    temp2-depth = `0.42`.
    temp2-height = `0.26`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1042`.
    temp2-typecode = `PR`.
    temp2-category = `Laser printers`.
    temp2-name = `Laser Allround`.
    temp2-namelanguage = `E`.
    temp2-description = `Print up to 25 ppm letter and 24 ppm A4 color or monochrome, with a first-page-out-time of less than 13 seconds for monochrome and less than 15 seconds for color`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000019`.
    temp2-suppliername = `Pateu`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `17.0`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `349.0`.
    temp2-width = `0.53`.
    temp2-depth = `0.5`.
    temp2-height = `0.65`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1050`.
    temp2-typecode = `PR`.
    temp2-category = `Ink jet printers`.
    temp2-name = `Ultra Jet Super Color`.
    temp2-namelanguage = `E`.
    temp2-description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB, Ethernet`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000020`.
    temp2-suppliername = `Russian Electronic Trading Company`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `3.0`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `RUB`.
    temp2-price = `139.0`.
    temp2-width = `0.41`.
    temp2-depth = `0.41`.
    temp2-height = `0.28`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1051`.
    temp2-typecode = `PR`.
    temp2-category = `Ink jet printers`.
    temp2-name = `Ultra Jet Mobile`.
    temp2-namelanguage = `E`.
    temp2-description = `1000 dpi x 1000 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB - excellent dimensions for the small office`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000021`.
    temp2-suppliername = `Florida Holiday Company`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `1.9`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `USD`.
    temp2-price = `99.0`.
    temp2-width = `0.46`.
    temp2-depth = `0.32`.
    temp2-height = `0.25`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1052`.
    temp2-typecode = `PR`.
    temp2-category = `Ink jet printers`.
    temp2-name = `Ultra Jet Super Highspeed`.
    temp2-namelanguage = `E`.
    temp2-description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB2.0, Ethernet`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000022`.
    temp2-suppliername = `Quimica Madrilenos`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `18.0`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `170.0`.
    temp2-width = `0.41`.
    temp2-depth = `0.41`.
    temp2-height = `0.28`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1055`.
    temp2-typecode = `PR`.
    temp2-category = `Multifunction printers`.
    temp2-name = `Multi Print`.
    temp2-namelanguage = `E`.
    temp2-description = `1000 dpi x 1000 dpi - up to 16 ppm (mono) / up to 15 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 1200dpi x 2400dpi)`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000023`.
    temp2-suppliername = `Getränkegroßhandel Janssen`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `6.3`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `99.0`.
    temp2-width = `0.55`.
    temp2-depth = `0.45`.
    temp2-height = `0.29`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1056`.
    temp2-typecode = `PR`.
    temp2-category = `Multifunction printers`.
    temp2-name = `Multi Color`.
    temp2-namelanguage = `E`.
    temp2-description = `1200 dpi x 1200 dpi - up to 25 ppm (mono) / up to 24 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 2400dpi x 4800dpi, high resolution)`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000024`.
    temp2-suppliername = `JaTeCo`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `4.3`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `JPY`.
    temp2-price = `119.0`.
    temp2-width = `0.51`.
    temp2-depth = `0.41`.
    temp2-height = `0.22`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1060`.
    temp2-typecode = `PR`.
    temp2-category = `Mice`.
    temp2-name = `Cordless Mouse`.
    temp2-namelanguage = `E`.
    temp2-description = `Cordless Optical USB Mice, Laptop, Color: Black, Plug&Play`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000025`.
    temp2-suppliername = `Tessile Casa Di Roma`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.09`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `9.0`.
    temp2-width = `0.06`.
    temp2-depth = `0.15`.
    temp2-height = `0.04`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1061`.
    temp2-typecode = `PR`.
    temp2-category = `Mice`.
    temp2-name = `Speed Mouse`.
    temp2-namelanguage = `E`.
    temp2-description = `Optical USB, PS/2 Mouse, Color: Blue, 3-button-functionality (incl. Scroll wheel)`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000026`.
    temp2-suppliername = `Vente Et Réparation de Ordinateur`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.09`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `7.0`.
    temp2-width = `0.07`.
    temp2-depth = `0.15`.
    temp2-height = `0.03`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1062`.
    temp2-typecode = `PR`.
    temp2-category = `Mice`.
    temp2-name = `Track Mouse`.
    temp2-namelanguage = `E`.
    temp2-description = `Optical USB Mouse, Color: Red, 5-button-functionality(incl. Scroll wheel), Plug&Play`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000027`.
    temp2-suppliername = `Developement Para O Governo`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.03`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `ARS`.
    temp2-price = `11.0`.
    temp2-width = `0.0`.
    temp2-depth = `0.01`.
    temp2-height = `0.04`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1063`.
    temp2-typecode = `PR`.
    temp2-category = `Keyboards`.
    temp2-name = `Ergonomic Keyboard`.
    temp2-namelanguage = `E`.
    temp2-description = `Ergonomic USB Keyboard for Desktop, Plug&Play`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000028`.
    temp2-suppliername = `Brazil Technologies`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `2.1`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `BRL`.
    temp2-price = `14.0`.
    temp2-width = `0.5`.
    temp2-depth = `0.21`.
    temp2-height = `0.04`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1064`.
    temp2-typecode = `PR`.
    temp2-category = `Keyboards`.
    temp2-name = `Internet Keyboard`.
    temp2-namelanguage = `E`.
    temp2-description = `Corded Keyboard with special keys for Internet Usability, USB`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000029`.
    temp2-suppliername = `C.R.T.U.`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `1.8`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `CAD`.
    temp2-price = `16.0`.
    temp2-width = `0.52`.
    temp2-depth = `0.25`.
    temp2-height = `0.03`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1065`.
    temp2-typecode = `PR`.
    temp2-category = `Keyboards`.
    temp2-name = `Media Keyboard`.
    temp2-namelanguage = `E`.
    temp2-description = `Corded Ergonomic Keyboard with special keys for Media Usability, USB`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000030`.
    temp2-suppliername = `Jologa`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `2.3`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `CHF`.
    temp2-price = `26.0`.
    temp2-width = `0.51`.
    temp2-depth = `0.23`.
    temp2-height = `0.04`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1066`.
    temp2-typecode = `PR`.
    temp2-category = `Mousepads`.
    temp2-name = `Mousepad`.
    temp2-namelanguage = `E`.
    temp2-description = `Nice mouse pad with ITelO Logo`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000031`.
    temp2-suppliername = `Baleda`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `80.0`.
    temp2-weightunit = `G`.
    temp2-currencycode = `USD`.
    temp2-price = `6.99`.
    temp2-width = `0.15`.
    temp2-depth = `0.06`.
    temp2-height = `0.0`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1067`.
    temp2-typecode = `PR`.
    temp2-category = `Mousepads`.
    temp2-name = `Ergo Mousepad`.
    temp2-namelanguage = `E`.
    temp2-description = `Ergonomic mouse pad with ITelO Logo`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000032`.
    temp2-suppliername = `Angeré`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `80.0`.
    temp2-weightunit = `G`.
    temp2-currencycode = `EUR`.
    temp2-price = `8.99`.
    temp2-width = `0.15`.
    temp2-depth = `0.06`.
    temp2-height = `0.0`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1068`.
    temp2-typecode = `PR`.
    temp2-category = `Mousepads`.
    temp2-name = `Designer Mousepad`.
    temp2-namelanguage = `E`.
    temp2-description = `ITelO Mousepad Special Edition`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000033`.
    temp2-suppliername = `PC Gym Tec`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `90.0`.
    temp2-weightunit = `G`.
    temp2-currencycode = `USD`.
    temp2-price = `12.99`.
    temp2-width = `0.24`.
    temp2-depth = `0.24`.
    temp2-height = `0.01`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1069`.
    temp2-typecode = `PR`.
    temp2-category = `Computer system accessories`.
    temp2-name = `Universal card reader`.
    temp2-namelanguage = `E`.
    temp2-description = `Universal card reader`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000034`.
    temp2-suppliername = `Japan Insurance Partner`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `45.0`.
    temp2-weightunit = `G`.
    temp2-currencycode = `JPY`.
    temp2-price = `14.0`.
    temp2-width = `0.01`.
    temp2-depth = `0.01`.
    temp2-height = `0.0`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1070`.
    temp2-typecode = `PR`.
    temp2-category = `Graphic cards`.
    temp2-name = `Proctra X`.
    temp2-namelanguage = `E`.
    temp2-description = `Proctra X: PCI-E GDDR5 3072MB`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000035`.
    temp2-suppliername = `Entertainment Argentinia`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.255`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `ARS`.
    temp2-price = `70.9`.
    temp2-width = `0.22`.
    temp2-depth = `0.35`.
    temp2-height = `0.17`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1071`.
    temp2-typecode = `PR`.
    temp2-category = `Graphic cards`.
    temp2-name = `Gladiator MX`.
    temp2-namelanguage = `E`.
    temp2-description = `Gladiator XLN: PCI-E GDDR5 3072MB DVI Out, TV Out low-noise`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000036`.
    temp2-suppliername = `African Gold And Diamond Corporation`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.3`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `ZAR`.
    temp2-price = `81.7`.
    temp2-width = `0.22`.
    temp2-depth = `0.35`.
    temp2-height = `0.17`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1072`.
    temp2-typecode = `PR`.
    temp2-category = `Graphic cards`.
    temp2-name = `Hurricane GX`.
    temp2-namelanguage = `E`.
    temp2-description = `Hurricane GX: PCI-E 691 GFLOPS game-optimized`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000037`.
    temp2-suppliername = `PicoBit`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.4`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `USD`.
    temp2-price = `101.2`.
    temp2-width = `0.22`.
    temp2-depth = `0.35`.
    temp2-height = `0.17`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1073`.
    temp2-typecode = `PR`.
    temp2-category = `Graphic cards`.
    temp2-name = `Hurricane GX/LN`.
    temp2-namelanguage = `E`.
    temp2-description = `Hurricane GX/LN: PCI-E 691 GFLOPS game-optimized, low-noise.`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000038`.
    temp2-suppliername = `Bionic Research Lab`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.4`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `139.99`.
    temp2-width = `0.22`.
    temp2-depth = `0.35`.
    temp2-height = `0.17`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1080`.
    temp2-typecode = `PR`.
    temp2-category = `Scanners`.
    temp2-name = `Photo Scan`.
    temp2-namelanguage = `E`.
    temp2-description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - Hi-Speed USB - Bluetooth`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000039`.
    temp2-suppliername = `Indian IT Trading Company`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `2.3`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `INR`.
    temp2-price = `129.0`.
    temp2-width = `0.34`.
    temp2-depth = `0.48`.
    temp2-height = `0.05`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1081`.
    temp2-typecode = `PR`.
    temp2-category = `Scanners`.
    temp2-name = `Power Scan`.
    temp2-namelanguage = `E`.
    temp2-description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - SCSI for backward compatibility`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000040`.
    temp2-suppliername = `Chemia A Technicznie Fabryka`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `2.4`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `PLN`.
    temp2-price = `89.0`.
    temp2-width = `0.31`.
    temp2-depth = `0.43`.
    temp2-height = `0.07`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1082`.
    temp2-typecode = `PR`.
    temp2-category = `Scanners`.
    temp2-name = `Jet Scan Professional`.
    temp2-namelanguage = `E`.
    temp2-description = `Flatbed scanner - Letter - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000041`.
    temp2-suppliername = `South American IT Company`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `3.2`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `ARS`.
    temp2-price = `169.0`.
    temp2-width = `0.33`.
    temp2-depth = `0.41`.
    temp2-height = `0.12`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1083`.
    temp2-typecode = `PR`.
    temp2-category = `Scanners`.
    temp2-name = `Jet Scan Professional`.
    temp2-namelanguage = `E`.
    temp2-description = `Flatbed scanner - A4 - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000042`.
    temp2-suppliername = `Siwusha`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `3.2`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `CNY`.
    temp2-price = `189.0`.
    temp2-width = `0.35`.
    temp2-depth = `0.4`.
    temp2-height = `0.1`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1085`.
    temp2-typecode = `PR`.
    temp2-category = `Multifunction printers`.
    temp2-name = `Copymaster`.
    temp2-namelanguage = `E`.
    temp2-description = `Copymaster`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000043`.
    temp2-suppliername = `Danish Fish Trading Company`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `23.2`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `DKK`.
    temp2-price = `1499.0`.
    temp2-width = `0.45`.
    temp2-depth = `0.42`.
    temp2-height = `0.22`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1090`.
    temp2-typecode = `PR`.
    temp2-category = `Speakers`.
    temp2-name = `Surround Sound`.
    temp2-namelanguage = `E`.
    temp2-description = `PC multimedia speakers - 5 Watt (Total)`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000044`.
    temp2-suppliername = `Sorali`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `3.0`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `39.0`.
    temp2-width = `0.12`.
    temp2-depth = `0.1`.
    temp2-height = `0.16`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1091`.
    temp2-typecode = `PR`.
    temp2-category = `Speakers`.
    temp2-name = `Blaster Extreme`.
    temp2-namelanguage = `E`.
    temp2-description = `PC multimedia speakers - 10 Watt (Total) - 2-way`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000000`.
    temp2-suppliername = `SAP`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `1.4`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `26.0`.
    temp2-width = `0.13`.
    temp2-depth = `0.11`.
    temp2-height = `0.18`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1092`.
    temp2-typecode = `PR`.
    temp2-category = `Speakers`.
    temp2-name = `Sound Booster`.
    temp2-namelanguage = `E`.
    temp2-description = `PC multimedia speakers - optimized for Blutooth/A2DP`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000001`.
    temp2-suppliername = `Becker Berlin`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `2.1`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `45.0`.
    temp2-width = `0.12`.
    temp2-depth = `0.1`.
    temp2-height = `0.18`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1095`.
    temp2-typecode = `PR`.
    temp2-category = `Headsets`.
    temp2-name = `Lovely Sound 5.1 Wireless`.
    temp2-namelanguage = `E`.
    temp2-description = `5.1 Headset, 40 Hz-20 kHz, Wireless`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000033`.
    temp2-suppliername = `PC Gym Tec`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `80.0`.
    temp2-weightunit = `G`.
    temp2-currencycode = `USD`.
    temp2-price = `49.0`.
    temp2-width = `0.24`.
    temp2-depth = `0.02`.
    temp2-height = `0.23`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1096`.
    temp2-typecode = `PR`.
    temp2-category = `Headsets`.
    temp2-name = `Lovely Sound 5.1`.
    temp2-namelanguage = `E`.
    temp2-description = `5.1 Headset, 40 Hz-20 kHz, 3m cable`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000034`.
    temp2-suppliername = `Japan Insurance Partner`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `130.0`.
    temp2-weightunit = `G`.
    temp2-currencycode = `JPY`.
    temp2-price = `39.0`.
    temp2-width = `0.25`.
    temp2-depth = `0.02`.
    temp2-height = `0.19`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1097`.
    temp2-typecode = `PR`.
    temp2-category = `Headsets`.
    temp2-name = `Lovely Sound Stereo`.
    temp2-namelanguage = `E`.
    temp2-description = `5.1 Headset, 40 Hz-20 kHz, 1m cable`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000035`.
    temp2-suppliername = `Entertainment Argentinia`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `60.0`.
    temp2-weightunit = `G`.
    temp2-currencycode = `ARS`.
    temp2-price = `29.0`.
    temp2-width = `0.21`.
    temp2-depth = `0.02`.
    temp2-height = `0.2`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1100`.
    temp2-typecode = `PR`.
    temp2-category = `Software`.
    temp2-name = `Smart Office`.
    temp2-namelanguage = `E`.
    temp2-description = `Complete package, 1 User, Office Applications (word processing, spreadsheet, presentations)`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000002`.
    temp2-suppliername = `DelBont Industries`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `1.2`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `USD`.
    temp2-price = `89.9`.
    temp2-width = `0.15`.
    temp2-depth = `0.07`.
    temp2-height = `0.21`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1101`.
    temp2-typecode = `PR`.
    temp2-category = `Software`.
    temp2-name = `Smart Design`.
    temp2-namelanguage = `E`.
    temp2-description = `Complete package, 1 User, Image editing, processing`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000003`.
    temp2-suppliername = `Talpa`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.8`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `79.9`.
    temp2-width = `0.14`.
    temp2-depth = `0.07`.
    temp2-height = `0.24`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1102`.
    temp2-typecode = `PR`.
    temp2-category = `Software`.
    temp2-name = `Smart Network`.
    temp2-namelanguage = `E`.
    temp2-description = `Complete package, 1 User, Network Software Utilities, Useful Applications and Documentation`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000004`.
    temp2-suppliername = `Panorama Studios`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.8`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `USD`.
    temp2-price = `69.0`.
    temp2-width = `0.16`.
    temp2-depth = `0.06`.
    temp2-height = `0.27`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1103`.
    temp2-typecode = `PR`.
    temp2-category = `Software`.
    temp2-name = `Smart Multimedia`.
    temp2-namelanguage = `E`.
    temp2-description = `Complete package, 1 User, different Multimedia applications, playing music, watching DVDs, only with this Smart package`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000005`.
    temp2-suppliername = `TECUM`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.8`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `77.0`.
    temp2-width = `0.11`.
    temp2-depth = `0.03`.
    temp2-height = `0.22`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1104`.
    temp2-typecode = `PR`.
    temp2-category = `Software`.
    temp2-name = `Smart Games`.
    temp2-namelanguage = `E`.
    temp2-description = `Complete package, 1 User, various games for amusement, logic, action, jump&run`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000006`.
    temp2-suppliername = `Asia High tech`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `1.1`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `JPY`.
    temp2-price = `55.0`.
    temp2-width = `0.1`.
    temp2-depth = `0.03`.
    temp2-height = `0.3`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1105`.
    temp2-typecode = `PR`.
    temp2-category = `Software`.
    temp2-name = `Smart Internet Antivirus`.
    temp2-namelanguage = `E`.
    temp2-description = `Complete package, 1 User, highly recommended for internet users as anti-virus protection`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000007`.
    temp2-suppliername = `Laurent`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.7`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `29.0`.
    temp2-width = `0.16`.
    temp2-depth = `0.04`.
    temp2-height = `0.21`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1106`.
    temp2-typecode = `PR`.
    temp2-category = `Software`.
    temp2-name = `Smart Firewall`.
    temp2-namelanguage = `E`.
    temp2-description = `Complete package, 1 User, recommended for internet users, protect your PC against cyber-crime`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000008`.
    temp2-suppliername = `AVANTEL`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.9`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `MXN`.
    temp2-price = `34.0`.
    temp2-width = `0.18`.
    temp2-depth = `0.04`.
    temp2-height = `0.23`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1107`.
    temp2-typecode = `PR`.
    temp2-category = `Software`.
    temp2-name = `Smart Money`.
    temp2-namelanguage = `E`.
    temp2-description = `Complete package, 1 User, bring your money in your mind, see what you have and what you want`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000009`.
    temp2-suppliername = `Telecomunicaciones Star`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.5`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `ARS`.
    temp2-price = `29.9`.
    temp2-width = `0.12`.
    temp2-depth = `0.02`.
    temp2-height = `0.19`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1110`.
    temp2-typecode = `PR`.
    temp2-category = `Computer system accessories`.
    temp2-name = `PC Lock`.
    temp2-namelanguage = `E`.
    temp2-description = `Robust 3m anti-burglary protection for your laptop computer`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000010`.
    temp2-suppliername = `Pear Computing Services`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.03`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `USD`.
    temp2-price = `8.9`.
    temp2-width = `0.2`.
    temp2-depth = `0.08`.
    temp2-height = `0.04`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1111`.
    temp2-typecode = `PR`.
    temp2-category = `Computer system accessories`.
    temp2-name = `Notebook Lock`.
    temp2-namelanguage = `E`.
    temp2-description = `Robust 1m anti-burglary protection for your desktop computer`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000011`.
    temp2-suppliername = `Alpine Systems`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.02`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `6.9`.
    temp2-width = `0.31`.
    temp2-depth = `0.09`.
    temp2-height = `0.07`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1112`.
    temp2-typecode = `PR`.
    temp2-category = `Computer system accessories`.
    temp2-name = `Web cam reality`.
    temp2-namelanguage = `E`.
    temp2-description = `Color webcam, color, High-Speed USB`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000012`.
    temp2-suppliername = `New Line Design`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.075`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `GBP`.
    temp2-price = `39.0`.
    temp2-width = `0.09`.
    temp2-depth = `0.08`.
    temp2-height = `0.01`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1113`.
    temp2-typecode = `PR`.
    temp2-category = `Computer system accessories`.
    temp2-name = `Screen clean`.
    temp2-namelanguage = `E`.
    temp2-description = `10 separately packed screen wipes`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000013`.
    temp2-suppliername = `HEPA Tec`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.05`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `2.3`.
    temp2-width = `0.02`.
    temp2-depth = `0.02`.
    temp2-height = `0.0`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1114`.
    temp2-typecode = `PR`.
    temp2-category = `Computer system accessories`.
    temp2-name = `Fabric bag professional`.
    temp2-namelanguage = `E`.
    temp2-description = `Notebook bag, plenty of room for stationery and writing materials`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000014`.
    temp2-suppliername = `Anav Ideon`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `1.8`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `USD`.
    temp2-price = `31.0`.
    temp2-width = `0.42`.
    temp2-depth = `0.32`.
    temp2-height = `0.07`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1115`.
    temp2-typecode = `PR`.
    temp2-category = `Telecommunication`.
    temp2-name = `Wireless DSL Router`.
    temp2-namelanguage = `E`.
    temp2-description = `Wireless DSL Router (available in blue, black and silver)`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000015`.
    temp2-suppliername = `Robert Brown Entertainment`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.45`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `CAD`.
    temp2-price = `49.0`.
    temp2-width = `0.19`.
    temp2-depth = `0.18`.
    temp2-height = `0.05`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1116`.
    temp2-typecode = `PR`.
    temp2-category = `Telecommunication`.
    temp2-name = `Wireless DSL Router / Repeater`.
    temp2-namelanguage = `E`.
    temp2-description = `Wireless DSL Router / Repeater (available in blue, black and silver)`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000016`.
    temp2-suppliername = `Mexican Oil Trading Company`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.45`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `MXN`.
    temp2-price = `59.0`.
    temp2-width = `0.19`.
    temp2-depth = `0.18`.
    temp2-height = `0.05`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1117`.
    temp2-typecode = `PR`.
    temp2-category = `Telecommunication`.
    temp2-name = `Wireless DSL Router / Repeater and Print Server`.
    temp2-namelanguage = `E`.
    temp2-description = `Wireless DSL Router / Repeater and Print Server (available in blue, black and silver)`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000017`.
    temp2-suppliername = `Meliva`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.45`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `69.0`.
    temp2-width = `0.19`.
    temp2-depth = `0.18`.
    temp2-height = `0.05`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1118`.
    temp2-typecode = `PR`.
    temp2-category = `Computer system accessories`.
    temp2-name = `USB Stick`.
    temp2-namelanguage = `E`.
    temp2-description = `USB 2.0 High-Speed 64 GB`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000018`.
    temp2-suppliername = `Compostela`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.015`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `ARS`.
    temp2-price = `35.0`.
    temp2-width = `0.02`.
    temp2-depth = `0.09`.
    temp2-height = `0.01`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1119`.
    temp2-typecode = `PR`.
    temp2-category = `Computer system accessories`.
    temp2-name = `Travel Adapter`.
    temp2-namelanguage = `E`.
    temp2-description = `Universal Travel Adapter`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000010`.
    temp2-suppliername = `Pear Computing Services`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `88.0`.
    temp2-weightunit = `G`.
    temp2-currencycode = `USD`.
    temp2-price = `79.0`.
    temp2-width = `0.02`.
    temp2-depth = `0.03`.
    temp2-height = `0.04`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1120`.
    temp2-typecode = `PR`.
    temp2-category = `Keyboards`.
    temp2-name = `Cordless Bluetooth Keyboard, english international`.
    temp2-namelanguage = `E`.
    temp2-description = `Cordless Bluetooth Keyboard with English keys`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000019`.
    temp2-suppliername = `Pateu`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `1.0`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `29.0`.
    temp2-width = `0.51`.
    temp2-depth = `0.23`.
    temp2-height = `0.04`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1137`.
    temp2-typecode = `PR`.
    temp2-category = `Flat screens`.
    temp2-name = `Flat XXL`.
    temp2-namelanguage = `E`.
    temp2-description = `Optimum Hi-Resolution max. 2048 × 1536 @ 85Hz, Dot Pitch: 0.24mm`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000020`.
    temp2-suppliername = `Russian Electronic Trading Company`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `18.0`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `RUB`.
    temp2-price = `1430.0`.
    temp2-width = `0.54`.
    temp2-depth = `0.22`.
    temp2-height = `0.38`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1138`.
    temp2-typecode = `PR`.
    temp2-category = `Mice`.
    temp2-name = `Pocket Mouse`.
    temp2-namelanguage = `E`.
    temp2-description = `Portable pocket Mouse with retracting cord`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000021`.
    temp2-suppliername = `Florida Holiday Company`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.02`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `USD`.
    temp2-price = `23.0`.
    temp2-width = `0.0`.
    temp2-depth = `0.01`.
    temp2-height = `0.01`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1210`.
    temp2-typecode = `PR`.
    temp2-category = `PCs`.
    temp2-name = `PC Power Station`.
    temp2-namelanguage = `E`.
    temp2-description = `PC Power Station with 3,4 Ghz quad-core, 32 GB DDR3 SDRAM, feels like a PC, Windows 8 Pro`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000022`.
    temp2-suppliername = `Quimica Madrilenos`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `2.3`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `2399.0`.
    temp2-width = `0.28`.
    temp2-depth = `0.31`.
    temp2-height = `0.43`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1500`.
    temp2-typecode = `PR`.
    temp2-category = `Servers`.
    temp2-name = `Server Basic`.
    temp2-namelanguage = `E`.
    temp2-description = `Dual socket, quad-core processing server with 1333 MHz Front Side Bus with 10Gb connectivity`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000023`.
    temp2-suppliername = `Getränkegroßhandel Janssen`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `18.0`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `5000.0`.
    temp2-width = `0.34`.
    temp2-depth = `0.35`.
    temp2-height = `0.23`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1501`.
    temp2-typecode = `PR`.
    temp2-category = `Servers`.
    temp2-name = `Server Professional`.
    temp2-namelanguage = `E`.
    temp2-description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 10Gb connectivity`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000024`.
    temp2-suppliername = `JaTeCo`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `25.0`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `JPY`.
    temp2-price = `15000.0`.
    temp2-width = `0.29`.
    temp2-depth = `0.3`.
    temp2-height = `0.27`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1502`.
    temp2-typecode = `PR`.
    temp2-category = `Servers`.
    temp2-name = `Server Power Pro`.
    temp2-namelanguage = `E`.
    temp2-description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 100Gb connectivity`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000025`.
    temp2-suppliername = `Tessile Casa Di Roma`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `35.0`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `25000.0`.
    temp2-width = `0.22`.
    temp2-depth = `0.27`.
    temp2-height = `0.37`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1600`.
    temp2-typecode = `PR`.
    temp2-category = `PCs`.
    temp2-name = `Family PC Basic`.
    temp2-namelanguage = `E`.
    temp2-description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Graphic Card: Proctra X, Windows 8`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000009`.
    temp2-suppliername = `Telecomunicaciones Star`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `4.8`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `ARS`.
    temp2-price = `600.0`.
    temp2-width = `0.21`.
    temp2-depth = `0.29`.
    temp2-height = `0.38`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1601`.
    temp2-typecode = `PR`.
    temp2-category = `PCs`.
    temp2-name = `Family PC Pro`.
    temp2-namelanguage = `E`.
    temp2-description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000008`.
    temp2-suppliername = `AVANTEL`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `5.3`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `MXN`.
    temp2-price = `900.0`.
    temp2-width = `0.25`.
    temp2-depth = `0.32`.
    temp2-height = `0.4`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1602`.
    temp2-typecode = `PR`.
    temp2-category = `PCs`.
    temp2-name = `Gaming Monster`.
    temp2-namelanguage = `E`.
    temp2-description = `3,4 Ghz quad core, 8 GB DDR3 SDRAM, 2000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000007`.
    temp2-suppliername = `Laurent`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `5.9`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `1200.0`.
    temp2-width = `0.27`.
    temp2-depth = `0.34`.
    temp2-height = `0.47`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-1603`.
    temp2-typecode = `PR`.
    temp2-category = `PCs`.
    temp2-name = `Gaming Monster Pro`.
    temp2-namelanguage = `E`.
    temp2-description = `3,4 Ghz quad core, 16 GB DDR3 SDRAM, 4000 GB Hard Disc, Graphic Card: Hurricane GX, Windows 8`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000006`.
    temp2-suppliername = `Asia High tech`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `6.8`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `JPY`.
    temp2-price = `1700.0`.
    temp2-width = `0.27`.
    temp2-depth = `0.28`.
    temp2-height = `0.42`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-2000`.
    temp2-typecode = `PR`.
    temp2-category = `Portable Players`.
    temp2-name = `7" Widescreen Portable DVD Player w MP3`.
    temp2-namelanguage = `E`.
    temp2-description = `7" LCD Screen, storage battery holds up to 6 hours!`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000005`.
    temp2-suppliername = `TECUM`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.79`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `249.99`.
    temp2-width = `0.21`.
    temp2-depth = `0.19`.
    temp2-height = `0.28`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-2001`.
    temp2-typecode = `PR`.
    temp2-category = `Portable Players`.
    temp2-name = `10" Portable DVD player`.
    temp2-namelanguage = `E`.
    temp2-description = `10" LCD Screen, storage battery holds up to 8 hours`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000004`.
    temp2-suppliername = `Panorama Studios`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.84`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `USD`.
    temp2-price = `449.99`.
    temp2-width = `0.24`.
    temp2-depth = `0.2`.
    temp2-height = `0.29`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-2002`.
    temp2-typecode = `PR`.
    temp2-category = `Portable Players`.
    temp2-name = `Portable DVD Player with 9" LCD Monitor`.
    temp2-namelanguage = `E`.
    temp2-description = `9" LCD Screen, storage holds up to 8 hours, 2 speakers included`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000044`.
    temp2-suppliername = `Sorali`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.72`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `853.99`.
    temp2-width = `0.21`.
    temp2-depth = `0.17`.
    temp2-height = `0.14`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-2025`.
    temp2-typecode = `PR`.
    temp2-category = `Computer system accessories`.
    temp2-name = `CD/DVD case: 264 sleeves`.
    temp2-namelanguage = `E`.
    temp2-description = `Organizer and protective case for 264 CDs and DVDs`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000003`.
    temp2-suppliername = `Talpa`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.65`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `44.99`.
    temp2-width = `0.13`.
    temp2-depth = `0.13`.
    temp2-height = `0.2`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-2026`.
    temp2-typecode = `PR`.
    temp2-category = `Computer system accessories`.
    temp2-name = `Audio/Video Cable Kit - 4m`.
    temp2-namelanguage = `E`.
    temp2-description = `Quality cables for notebooks and beamers`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000002`.
    temp2-suppliername = `DelBont Industries`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.2`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `USD`.
    temp2-price = `29.99`.
    temp2-width = `0.21`.
    temp2-depth = `0.1`.
    temp2-height = `0.13`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-2027`.
    temp2-typecode = `PR`.
    temp2-category = `Computer system accessories`.
    temp2-name = `Removable CD/DVD Laser Labels`.
    temp2-namelanguage = `E`.
    temp2-description = `Removable jewel case labels, zero residues (100)`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000001`.
    temp2-suppliername = `Becker Berlin`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.15`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `8.99`.
    temp2-width = `0.06`.
    temp2-depth = `0.02`.
    temp2-height = `0.02`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6100`.
    temp2-typecode = `PR`.
    temp2-category = `Beamers`.
    temp2-name = `Beam Breaker B-1`.
    temp2-namelanguage = `E`.
    temp2-description = `720p, DLP beamer max. 8,45 Meter, 2D`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000000`.
    temp2-suppliername = `SAP`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `1.7`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `469.0`.
    temp2-width = `0.3`.
    temp2-depth = `0.23`.
    temp2-height = `0.23`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6101`.
    temp2-typecode = `PR`.
    temp2-category = `Beamers`.
    temp2-name = `Beam Breaker B-2`.
    temp2-namelanguage = `E`.
    temp2-description = `1080p, DLP max.9,34 Meter, 2D-ready`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000043`.
    temp2-suppliername = `Danish Fish Trading Company`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `2.0`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `DKK`.
    temp2-price = `679.0`.
    temp2-width = `0.3`.
    temp2-depth = `0.23`.
    temp2-height = `0.23`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6102`.
    temp2-typecode = `PR`.
    temp2-category = `Beamers`.
    temp2-name = `Beam Breaker B-3`.
    temp2-namelanguage = `E`.
    temp2-description = `1080p, DLP max. 12,3 Meter, 3D-ready`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000042`.
    temp2-suppliername = `Siwusha`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `2.5`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `CNY`.
    temp2-price = `889.0`.
    temp2-width = `0.3`.
    temp2-depth = `0.23`.
    temp2-height = `0.23`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6110`.
    temp2-typecode = `PR`.
    temp2-category = `Portable Players`.
    temp2-name = `Play Movie`.
    temp2-namelanguage = `E`.
    temp2-description = `CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000041`.
    temp2-suppliername = `South American IT Company`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `2.4`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `ARS`.
    temp2-price = `130.0`.
    temp2-width = `0.37`.
    temp2-depth = `0.24`.
    temp2-height = `0.06`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6111`.
    temp2-typecode = `PR`.
    temp2-category = `Portable Players`.
    temp2-name = `Record Movie`.
    temp2-namelanguage = `E`.
    temp2-description = `160 GB HDD, CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000040`.
    temp2-suppliername = `Chemia A Technicznie Fabryka`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `3.1`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `PLN`.
    temp2-price = `288.0`.
    temp2-width = `0.38`.
    temp2-depth = `0.26`.
    temp2-height = `0.06`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6120`.
    temp2-typecode = `PR`.
    temp2-category = `MP3-Players`.
    temp2-name = `ITelo MusickStick`.
    temp2-namelanguage = `E`.
    temp2-description = `64 GB USB Musick-on-a-Stick`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000039`.
    temp2-suppliername = `Indian IT Trading Company`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `134.0`.
    temp2-weightunit = `G`.
    temp2-currencycode = `INR`.
    temp2-price = `45.0`.
    temp2-width = `0.02`.
    temp2-depth = `0.06`.
    temp2-height = `0.01`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6121`.
    temp2-typecode = `PR`.
    temp2-category = `MP3-Players`.
    temp2-name = `ITelo Jog-Mate`.
    temp2-namelanguage = `E`.
    temp2-description = `ITelo Jog-Mate 64 GB HDD and Color Display, can play movies`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000038`.
    temp2-suppliername = `Bionic Research Lab`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `134.0`.
    temp2-weightunit = `G`.
    temp2-currencycode = `EUR`.
    temp2-price = `63.0`.
    temp2-width = `0.05`.
    temp2-depth = `0.08`.
    temp2-height = `0.09`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6122`.
    temp2-typecode = `PR`.
    temp2-category = `MP3-Players`.
    temp2-name = `Power Pro Player 40`.
    temp2-namelanguage = `E`.
    temp2-description = `MP3-Player with 40 GB HDD and Color Display, can play movies`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000037`.
    temp2-suppliername = `PicoBit`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `266.0`.
    temp2-weightunit = `G`.
    temp2-currencycode = `USD`.
    temp2-price = `167.0`.
    temp2-width = `0.05`.
    temp2-depth = `0.08`.
    temp2-height = `0.09`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6123`.
    temp2-typecode = `PR`.
    temp2-category = `MP3-Players`.
    temp2-name = `Power Pro Player 80`.
    temp2-namelanguage = `E`.
    temp2-description = `MP3-Player with 80 GB SSD and Color Display, can play movies`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000036`.
    temp2-suppliername = `African Gold And Diamond Corporation`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `267.0`.
    temp2-weightunit = `G`.
    temp2-currencycode = `ZAR`.
    temp2-price = `299.0`.
    temp2-width = `0.04`.
    temp2-depth = `0.06`.
    temp2-height = `0.01`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6130`.
    temp2-typecode = `PR`.
    temp2-category = `TV flat screens`.
    temp2-name = `Flat Watch HD32`.
    temp2-namelanguage = `E`.
    temp2-description = `32-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000026`.
    temp2-suppliername = `Vente Et Réparation de Ordinateur`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `2.6`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `1459.0`.
    temp2-width = `0.78`.
    temp2-depth = `0.22`.
    temp2-height = `0.55`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6131`.
    temp2-typecode = `PR`.
    temp2-category = `TV flat screens`.
    temp2-name = `Flat Watch HD37`.
    temp2-namelanguage = `E`.
    temp2-description = `37-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000027`.
    temp2-suppliername = `Developement Para O Governo`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `2.2`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `ARS`.
    temp2-price = `1199.0`.
    temp2-width = `0.99`.
    temp2-depth = `0.26`.
    temp2-height = `0.61`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-6132`.
    temp2-typecode = `PR`.
    temp2-category = `TV flat screens`.
    temp2-name = `Flat Watch HD41`.
    temp2-namelanguage = `E`.
    temp2-description = `41-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000028`.
    temp2-suppliername = `Brazil Technologies`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `1.8`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `BRL`.
    temp2-price = `899.0`.
    temp2-width = `1.28`.
    temp2-depth = `0.23`.
    temp2-height = `0.79`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-7000`.
    temp2-typecode = `PR`.
    temp2-category = `PDAs/Organizers`.
    temp2-name = `Copperberry`.
    temp2-namelanguage = `E`.
    temp2-description = `Our new multifunctional Handheld with phone function in copper`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000032`.
    temp2-suppliername = `Angeré`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.5`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `549.0`.
    temp2-width = `0.08`.
    temp2-depth = `0.13`.
    temp2-height = `0.12`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-7010`.
    temp2-typecode = `PR`.
    temp2-category = `PDAs/Organizers`.
    temp2-name = `Silverberry`.
    temp2-namelanguage = `E`.
    temp2-description = `Our new multifunctional Handheld with phone function in silver`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000031`.
    temp2-suppliername = `Baleda`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.5`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `USD`.
    temp2-price = `549.0`.
    temp2-width = `0.08`.
    temp2-depth = `0.13`.
    temp2-height = `0.12`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-7020`.
    temp2-typecode = `PR`.
    temp2-category = `PDAs/Organizers`.
    temp2-name = `Goldberry`.
    temp2-namelanguage = `E`.
    temp2-description = `Our new multifunctional Handheld with phone function in gold`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000030`.
    temp2-suppliername = `Jologa`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.5`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `CHF`.
    temp2-price = `549.0`.
    temp2-width = `0.08`.
    temp2-depth = `0.13`.
    temp2-height = `0.12`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-7030`.
    temp2-typecode = `PR`.
    temp2-category = `PDAs/Organizers`.
    temp2-name = `Platinberry`.
    temp2-namelanguage = `E`.
    temp2-description = `Our new multifunctional Handheld with phone function in platinum`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000029`.
    temp2-suppliername = `C.R.T.U.`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.5`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `CAD`.
    temp2-price = `549.0`.
    temp2-width = `0.08`.
    temp2-depth = `0.13`.
    temp2-height = `0.12`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-8000`.
    temp2-typecode = `PR`.
    temp2-category = `Notebooks`.
    temp2-name = `ITelO FlexTop I4000`.
    temp2-namelanguage = `E`.
    temp2-description = `Notebook with 2,80 GHz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000011`.
    temp2-suppliername = `Alpine Systems`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `4.0`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `799.0`.
    temp2-width = `0.31`.
    temp2-depth = `0.19`.
    temp2-height = `0.03`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-8001`.
    temp2-typecode = `PR`.
    temp2-category = `Notebooks`.
    temp2-name = `ITelO FlexTop I6300c`.
    temp2-namelanguage = `E`.
    temp2-description = `Notebook with 2,80 GHz dual core, 8 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000012`.
    temp2-suppliername = `New Line Design`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `4.2`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `GBP`.
    temp2-price = `999.0`.
    temp2-width = `0.32`.
    temp2-depth = `0.2`.
    temp2-height = `0.03`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-8002`.
    temp2-typecode = `PR`.
    temp2-category = `Notebooks`.
    temp2-name = `ITelO FlexTop I9100`.
    temp2-namelanguage = `E`.
    temp2-description = `Notebook with 2,80 GHz quad core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000013`.
    temp2-suppliername = `HEPA Tec`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `3.5`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `1199.0`.
    temp2-width = `0.38`.
    temp2-depth = `0.21`.
    temp2-height = `0.04`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-8003`.
    temp2-typecode = `PR`.
    temp2-category = `Notebooks`.
    temp2-name = `ITelO FlexTop I9800`.
    temp2-namelanguage = `E`.
    temp2-description = `Notebook with 2,80 GHz quad core, 8 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000014`.
    temp2-suppliername = `Anav Ideon`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `3.8`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `USD`.
    temp2-price = `1388.0`.
    temp2-width = `0.48`.
    temp2-depth = `0.31`.
    temp2-height = `0.05`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9991`.
    temp2-typecode = `PR`.
    temp2-category = `Accessories`.
    temp2-name = `Smartphone Leather Case`.
    temp2-namelanguage = `E`.
    temp2-description = `Button Clasp, Quality Material, 100% Leather, compatible with many smartphone models`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000024`.
    temp2-suppliername = `JaTeCo`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.02`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `JPY`.
    temp2-price = `25.0`.
    temp2-width = `0.48`.
    temp2-depth = `0.31`.
    temp2-height = `0.05`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9992`.
    temp2-typecode = `PR`.
    temp2-category = `Smartphones`.
    temp2-name = `Smartphone Alpha`.
    temp2-namelanguage = `E`.
    temp2-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000023`.
    temp2-suppliername = `Getränkegroßhandel Janssen`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.75`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `599.0`.
    temp2-width = `0.48`.
    temp2-depth = `0.31`.
    temp2-height = `0.05`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9993`.
    temp2-typecode = `PR`.
    temp2-category = `Tablets`.
    temp2-name = `Mini Tablet`.
    temp2-namelanguage = `E`.
    temp2-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage, 4325 mAh battery (Up to 8 hours of active use)`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000022`.
    temp2-suppliername = `Quimica Madrilenos`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `3.8`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `833.0`.
    temp2-width = `0.48`.
    temp2-depth = `0.31`.
    temp2-height = `0.05`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9994`.
    temp2-typecode = `PR`.
    temp2-category = `Camcorders`.
    temp2-name = `Camcorder View`.
    temp2-namelanguage = `E`.
    temp2-description = `1920x1080 Full HD, image stabilization reduces blur, 27x Optical / 32x Extended Zoom, wide angle Lens, 2.7" wide LCD display`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000021`.
    temp2-suppliername = `Florida Holiday Company`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `3.8`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `USD`.
    temp2-price = `1388.0`.
    temp2-width = `0.48`.
    temp2-depth = `0.31`.
    temp2-height = `0.27`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9995`.
    temp2-typecode = `PR`.
    temp2-category = `Accessories`.
    temp2-name = `Smartphone Cover`.
    temp2-namelanguage = `E`.
    temp2-description = `Durable high quality plastic bump-sleeve, lightweight, protects from scratches, rubber coating, multiple colors available, Accurate design and cut-outs for your device, snap-on design`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000020`.
    temp2-suppliername = `Russian Electronic Trading Company`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.02`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `RUB`.
    temp2-price = `15.0`.
    temp2-width = `0.48`.
    temp2-depth = `0.31`.
    temp2-height = `0.05`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9996`.
    temp2-typecode = `PR`.
    temp2-category = `Accessories`.
    temp2-name = `Tablet Pouch`.
    temp2-namelanguage = `E`.
    temp2-description = `Stylish tablet pouch, protects from scratches, color: black`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000019`.
    temp2-suppliername = `Pateu`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.03`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `20.0`.
    temp2-width = `0.25`.
    temp2-depth = `0.4`.
    temp2-height = `0.05`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9997`.
    temp2-typecode = `PR`.
    temp2-category = `Tablets`.
    temp2-name = `e-Book Reader ReadMe`.
    temp2-namelanguage = `E`.
    temp2-description = `6-Inch E Ink Screen, Access To e-book Store, Adjustable Font Styles and Sizes, Stores Up To 1,000 Books`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000018`.
    temp2-suppliername = `Compostela`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `3.8`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `ARS`.
    temp2-price = `633.0`.
    temp2-width = `0.48`.
    temp2-depth = `0.31`.
    temp2-height = `0.05`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9998`.
    temp2-typecode = `PR`.
    temp2-category = `Smartphones`.
    temp2-name = `Smartphone Beta`.
    temp2-namelanguage = `E`.
    temp2-description = `5 Megapixel Camera, Wi-Fi 802.11 b/g/n, Bluetooth, GPS A-GPS support`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000017`.
    temp2-suppliername = `Meliva`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `0.75`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `EUR`.
    temp2-price = `699.0`.
    temp2-width = `0.48`.
    temp2-depth = `0.31`.
    temp2-height = `0.05`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    temp2-productid = `HT-9999`.
    temp2-typecode = `PR`.
    temp2-category = `Tablets`.
    temp2-name = `Maxi Tablet`.
    temp2-namelanguage = `E`.
    temp2-description = `10.1-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor`.
    temp2-descriptionlanguage = `E`.
    temp2-supplierid = `0100000016`.
    temp2-suppliername = `Mexican Oil Trading Company`.
    temp2-taxtarifcode = 1.
    temp2-measureunit = `EA`.
    temp2-weightmeasure = `3.8`.
    temp2-weightunit = `KG`.
    temp2-currencycode = `MXN`.
    temp2-price = `749.0`.
    temp2-width = `0.48`.
    temp2-depth = `0.31`.
    temp2-height = `0.05`.
    temp2-dimunit = `M`.
    temp2-createdat = `/Date(1414583899000)/`.
    temp2-changedat = `/Date(1414583899000)/`.
    INSERT temp2 INTO TABLE temp1.
    t_products = temp1.

  ENDMETHOD.

ENDCLASS.
