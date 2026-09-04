" @keywords dynamicpage dynamic sap.f dynamicpagefreestyle dynamicpagetitle title breadcrumbs link label overflowtoolbar generictag objectnumber
" @summary Dynamic Page freestyle example with a responsive sap.m.Table in the content area, showing that each control can be placed in the title and the header content areas.
CLASS z2ui5_cl_smpc_app_170 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_row,
        name         TYPE string,
        productid    TYPE string,
        suppliername TYPE string,
        width        TYPE string,
        depth        TYPE string,
        height       TYPE string,
        dimunit      TYPE string,
        price        TYPE p LENGTH 13 DECIMALS 2,
        currencycode TYPE string,
      END OF ty_row.
    DATA productcollection TYPE STANDARD TABLE OF ty_row WITH DEFAULT KEY.

    DATA headerexpanded  TYPE abap_bool.
    DATA titleclickable  TYPE abap_bool.
    DATA showfooter      TYPE abap_bool.
    DATA areashrinkratio TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_170 IMPLEMENTATION.

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
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " sap.f.DynamicPage (freestyle) - title/header/content/footer. headerExpanded,
    " toggleHeaderOnTitleClick, showFooter and the title's areaShrinkRatio are
    " two-way bound to model fields (the original toggles them imperatively; the
    " faithful abap2UI5 form binds them). The Products table keeps the original
    " sorter + Currency composite type bindings 1:1. The controller's Card popover
    " (onPressOpenPopover) is shown via popover_display on both wired presses.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`        v = `sap.m`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:f`      v = `sap.f`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `height`       v = `100%`

        )->ele( n = `DynamicPage` ns = `f`
            )->a( n = `id`                       v = `dynamicPageId`
            )->a( n = `headerExpanded`           v = client->_bind( headerexpanded )
            )->a( n = `toggleHeaderOnTitleClick` v = client->_bind( titleclickable )
            )->a( n = `showFooter`               v = client->_bind( showfooter )

            )->ele( n = `title` ns = `f`
                )->ele( n = `DynamicPageTitle` ns = `f`
                    " added attr (declared): carries the Edit button's toggle
                    )->a( n = `areaShrinkRatio` v = client->_bind( areashrinkratio )

                    )->ele( n = `heading` ns = `f`
                        )->tag( `Title`
                            )->a( n = `text` v = `Header Title`

                    )->end(

                    )->ele( n = `breadcrumbs` ns = `f`
                        )->ele( `Breadcrumbs`
                            )->tag( `Link`
                                )->a( n = `text` v = `Home`
                            )->tag( `Link`
                                )->a( n = `text` v = `Page 1`
                            )->tag( `Link`
                                )->a( n = `text` v = `Page 2`
                            )->tag( `Link`
                                )->a( n = `text` v = `Page 3`
                            )->tag( `Link`
                                )->a( n = `text` v = `Page 4`
                            )->tag( `Link`
                                )->a( n = `text` v = `Page 5`

                        )->end(
                    )->end(

                    )->ele( n = `expandedContent` ns = `f`
                        )->tag( `Label`
                            )->a( n = `text` v = `This is a subheading`

                    )->end(

                    )->ele( n = `snappedContent` ns = `f`
                        )->tag( `Label`
                            )->a( n = `text` v = `This is a subheading`

                    )->end(

                    )->ele( n = `snappedTitleOnMobile` ns = `f`
                        )->tag( `Title`
                            )->a( n = `text` v = `This is a subheading`

                    )->end(

                    )->ele( n = `content` ns = `f`
                        )->ele( `OverflowToolbar`
                            )->ele( `GenericTag`
                                )->a( n = `text`   v = `SR`
                                )->a( n = `status` v = `Error`
                                )->a( n = `design` v = `StatusIconHidden`
                                )->a( n = `press`  v = client->_event( val = `OPEN_POPOVER` arg = `$event.oSource.sId` )
                                )->tag( `ObjectNumber`
                                    )->a( n = `number`     v = `2`
                                    )->a( n = `unit`       v = `M`
                                    )->a( n = `emphasized` v = `false`
                                    )->a( n = `state`      v = `Error`

                            )->end(
                        )->end(
                    )->end(

                    )->ele( n = `actions` ns = `f`
                        )->tag( `Button`
                            )->a( n = `text`  v = `Edit`
                            )->a( n = `type`  v = `Emphasized`
                            )->a( n = `press` v = client->_event( `TOGGLE_AREA_PRIORITY` )
                        )->tag( `Button`
                            )->a( n = `text` v = `Delete`
                            )->a( n = `type` v = `Transparent`
                        )->tag( `Button`
                            )->a( n = `text` v = `Copy`
                            )->a( n = `type` v = `Transparent`
                        )->tag( `Button`
                            )->a( n = `text`  v = `Toggle Footer`
                            )->a( n = `type`  v = `Transparent`
                            )->a( n = `press` v = client->_event( `TOGGLE_FOOTER` )
                        )->tag( `Button`
                            )->a( n = `icon` v = `sap-icon://action`
                            )->a( n = `type` v = `Transparent`

                        )->ele( `Button`
                            )->a( n = `text`  v = `Button with layoutData`
                            )->a( n = `type`  v = `Transparent`
                            )->a( n = `press` v = client->_event( val = `OPEN_POPOVER` arg = `$event.oSource.sId` )
                            )->ele( `layoutData`
                                )->tag( `OverflowToolbarLayoutData`
                                    )->a( n = `priority`                  v = `AlwaysOverflow`
                                    )->a( n = `closeOverflowOnInteraction` v = `false`

                            )->end(
                        )->end(
                    )->end(

                    )->ele( n = `navigationActions` ns = `f`
                        )->tag( `Button`
                            )->a( n = `icon` v = `sap-icon://full-screen`
                            )->a( n = `type` v = `Transparent`
                        )->tag( `Button`
                            )->a( n = `icon` v = `sap-icon://decline`
                            )->a( n = `type` v = `Transparent`

                    )->end(
                )->end(
            )->end(

            )->ele( n = `header` ns = `f`
                )->ele( n = `DynamicPageHeader` ns = `f`
                    )->a( n = `pinnable` v = `true`
                    )->ele( n = `HorizontalLayout` ns = `layout`
                        )->a( n = `allowWrapping` v = `true`

                        )->ele( n = `VerticalLayout` ns = `layout`
                            )->a( n = `class` v = `sapUiMediumMarginEnd`
                            )->tag( `ObjectAttribute`
                                )->a( n = `title` v = `Location`
                                )->a( n = `text`  v = `Warehouse A`
                            )->tag( `ObjectAttribute`
                                )->a( n = `title` v = `Halway`
                                )->a( n = `text`  v = `23L`
                            )->tag( `ObjectAttribute`
                                )->a( n = `title` v = `Rack`
                                )->a( n = `text`  v = `34`

                        )->end(

                        )->ele( n = `VerticalLayout` ns = `layout`
                            )->tag( `ObjectAttribute`
                                )->a( n = `title` v = `Availability`
                            )->tag( `ObjectStatus`
                                )->a( n = `text`  v = `In Stock`
                                )->a( n = `state` v = `Success`

                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( n = `content` ns = `f`
                )->ele( `Table`
                    )->a( n = `id`     v = `idProductsTable`
                    )->a( n = `sticky` v = `HeaderToolbar,ColumnHeaders`
                    )->a( n = `inset`  v = `false`
                    )->a( n = `items`  v = |\{ path: '{ client->_bind_path( productcollection ) }', sorter: \{ path: 'NAME' \} \}|
                    )->a( n = `class`  v = `sapFDynamicPageAlignContent`
                    )->a( n = `width`  v = `auto`

                    )->ele( `headerToolbar`
                        )->ele( `Toolbar`
                            )->tag( `Title`
                                )->a( n = `text`  v = `Products`
                                )->a( n = `level` v = `H2`

                        )->end(
                    )->end(

                    )->ele( `columns`
                        )->ele( `Column`
                            )->a( n = `width` v = `12em`
                            )->tag( `Text`
                                )->a( n = `text` v = `Product`

                        )->end(

                        )->ele( `Column`
                            )->a( n = `minScreenWidth` v = `Tablet`
                            )->a( n = `demandPopin`    v = `true`
                            )->tag( `Text`
                                )->a( n = `text` v = `Supplier`

                        )->end(

                        )->ele( `Column`
                            )->a( n = `minScreenWidth` v = `Tablet`
                            )->a( n = `demandPopin`    v = `true`
                            )->a( n = `hAlign`         v = `End`
                            )->tag( `Text`
                                )->a( n = `text` v = `Dimensions`

                        )->end(

                        )->ele( `Column`
                            )->a( n = `hAlign` v = `End`
                            )->tag( `Text`
                                )->a( n = `text` v = `Price`

                        )->end(
                    )->end(

                    )->ele( `items`
                        )->ele( `ColumnListItem`
                            )->ele( `cells`
                                )->tag( `ObjectIdentifier`
                                    )->a( n = `title` v = `{NAME}`
                                    )->a( n = `text`  v = `{PRODUCTID}`
                                )->tag( `Text`
                                    )->a( n = `text` v = `{SUPPLIERNAME}`
                                )->tag( `Text`
                                    )->a( n = `text` v = `{WIDTH} x {DEPTH} x {HEIGHT} {DIMUNIT}`
                                )->tag( `ObjectNumber`
                                    )->a( n = `number` v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCYCODE'\}], type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
                                    )->a( n = `unit`   v = `{CURRENCYCODE}`

                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(

            )->ele( n = `footer` ns = `f`
                )->ele( `OverflowToolbar`
                    )->tag( `ToolbarSpacer`
                    )->tag( `Button`
                        )->a( n = `type` v = `Accept`
                        )->a( n = `text` v = `Accept`
                    )->tag( `Button`
                        )->a( n = `type` v = `Reject`
                        )->a( n = `text` v = `Reject`

                )->end(
            )->end(
        )->end(
    )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp2 TYPE xsdboolean.
        DATA temp1 TYPE string.
        DATA popover TYPE REF TO z2ui5_cl_ui5_view_builder.

    CASE client->get_event( ).

      WHEN `TOGGLE_FOOTER`.
        
        temp2 = boolc( showfooter = abap_false ).
        showfooter = temp2.

      WHEN `TOGGLE_AREA_PRIORITY`.
        " original toggleAreaPriority: flip areaShrinkRatio between the
        " metadata default (1:1.6:1.6) and 1.6:1:1.6 via the two-way binding
        
        IF areashrinkratio = `1:1.6:1.6`.
          temp1 = `1.6:1:1.6`.
        ELSE.
          temp1 = `1:1.6:1.6`.
        ENDIF.
        areashrinkratio = temp1.

      WHEN `OPEN_POPOVER`.
        " original onPressOpenPopover: Fragment.load(view/Card.fragment.xml)
        " + openBy(pressed control) - the Card popover rebuilt 1:1, anchored
        " via popover_display by_id
        
        popover = z2ui5_cl_ui5_view_builder=>factory( ).

        popover->ele( n = `FragmentDefinition` ns = `core`
            )->a( n = `xmlns`      v = `sap.m`
            )->a( n = `xmlns:core` v = `sap.ui.core`
            )->a( n = `xmlns:f`    v = `sap.f`
            )->a( n = `xmlns:card` v = `sap.f.cards`

            )->ele( `Popover`
                )->a( n = `placement`    v = `Bottom`
                )->a( n = `showHeader`   v = `false`
                )->a( n = `contentWidth` v = `300px`

                )->ele( n = `Card` ns = `f`
                    )->a( n = `width` v = `100%`

                    )->ele( n = `header` ns = `f`
                        )->ele( n = `NumericHeader` ns = `card`
                            )->a( n = `title`             v = `Sales Revenue`
                            )->a( n = `subtitle`          v = `Sales revenue in the current quarter`
                            )->a( n = `unitOfMeasurement` v = `EUR`
                            )->a( n = `number`            v = `2.16`
                            )->a( n = `scale`             v = `M`
                            )->a( n = `trend`             v = `Down`
                            )->a( n = `state`             v = `Error`

                            )->ele( n = `sideIndicators` ns = `card`
                                )->tag( n = `NumericSideIndicator` ns = `card`
                                    )->a( n = `number` v = `4.74`
                                    )->a( n = `unit`   v = `M`
                                    )->a( n = `title`  v = `Target`
                                )->tag( n = `NumericSideIndicator` ns = `card`
                                    )->a( n = `number` v = `-54.49`
                                    )->a( n = `unit`   v = `%`
                                    )->a( n = `title`  v = `Deviation` ).

        client->popover_display( xml   = popover->stringify( )
                                 by_id = client->get_event_arg( ) ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.
    DATA temp2 LIKE productcollection.
    DATA temp3 LIKE LINE OF temp2.

    " the DynamicPage starts with an expanded, click-toggleable header and a
    " hidden footer (the original's default state; the footer is revealed by the
    " Toggle Footer action)
    headerexpanded  = abap_true.
    titleclickable  = abap_true.
    showfooter      = abap_false.
    " DynamicPageTitle.areaShrinkRatio metadata default (the Edit toggle's base)
    areashrinkratio = `1:1.6:1.6`.

    " the shared 123-row demo ProductCollection (sap/ui/demo/mock/products.json),
    " the five columns the table binds (+ Price/CurrencyCode for the Currency type)
    
    CLEAR temp2.
    
    temp3-name = `Notebook Basic 15`.
    temp3-productid = `HT-1000`.
    temp3-suppliername = `Very Best Screens`.
    temp3-width = `30`.
    temp3-depth = `18`.
    temp3-height = `3`.
    temp3-dimunit = `cm`.
    temp3-price = `956`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Notebook Basic 17`.
    temp3-productid = `HT-1001`.
    temp3-suppliername = `Very Best Screens`.
    temp3-width = `29`.
    temp3-depth = `17`.
    temp3-height = `3.1`.
    temp3-dimunit = `cm`.
    temp3-price = `1249`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Notebook Basic 18`.
    temp3-productid = `HT-1002`.
    temp3-suppliername = `Very Best Screens`.
    temp3-width = `28`.
    temp3-depth = `19`.
    temp3-height = `2.5`.
    temp3-dimunit = `cm`.
    temp3-price = `1570`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Notebook Basic 19`.
    temp3-productid = `HT-1003`.
    temp3-suppliername = `Smartcards`.
    temp3-width = `32`.
    temp3-depth = `21`.
    temp3-height = `4`.
    temp3-dimunit = `cm`.
    temp3-price = `1650`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `ITelO Vault`.
    temp3-productid = `HT-1007`.
    temp3-suppliername = `Technocom`.
    temp3-width = `32`.
    temp3-depth = `22`.
    temp3-height = `3`.
    temp3-dimunit = `cm`.
    temp3-price = `299`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Notebook Professional 15`.
    temp3-productid = `HT-1010`.
    temp3-suppliername = `Very Best Screens`.
    temp3-width = `33`.
    temp3-depth = `20`.
    temp3-height = `3`.
    temp3-dimunit = `cm`.
    temp3-price = `1999`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Notebook Professional 17`.
    temp3-productid = `HT-1011`.
    temp3-suppliername = `Very Best Screens`.
    temp3-width = `33`.
    temp3-depth = `23`.
    temp3-height = `2`.
    temp3-dimunit = `cm`.
    temp3-price = `2299`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `ITelO Vault Net`.
    temp3-productid = `HT-1020`.
    temp3-suppliername = `Technocom`.
    temp3-width = `10`.
    temp3-depth = `1.8`.
    temp3-height = `17`.
    temp3-dimunit = `cm`.
    temp3-price = `459`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `ITelO Vault SAT`.
    temp3-productid = `HT-1021`.
    temp3-suppliername = `Technocom`.
    temp3-width = `11`.
    temp3-depth = `1.7`.
    temp3-height = `18`.
    temp3-dimunit = `cm`.
    temp3-price = `149`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Comfort Easy`.
    temp3-productid = `HT-1022`.
    temp3-suppliername = `Technocom`.
    temp3-width = `84`.
    temp3-depth = `1.5`.
    temp3-height = `14`.
    temp3-dimunit = `cm`.
    temp3-price = `1679`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Comfort Senior`.
    temp3-productid = `HT-1023`.
    temp3-suppliername = `Technocom`.
    temp3-width = `80`.
    temp3-depth = `1.6`.
    temp3-height = `13`.
    temp3-dimunit = `cm`.
    temp3-price = `512`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Ergo Screen E-I`.
    temp3-productid = `HT-1030`.
    temp3-suppliername = `Very Best Screens`.
    temp3-width = `37`.
    temp3-depth = `12`.
    temp3-height = `36`.
    temp3-dimunit = `cm`.
    temp3-price = `230`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Ergo Screen E-II`.
    temp3-productid = `HT-1031`.
    temp3-suppliername = `Very Best Screens`.
    temp3-width = `40.8`.
    temp3-depth = `19`.
    temp3-height = `43`.
    temp3-dimunit = `cm`.
    temp3-price = `285`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Ergo Screen E-III`.
    temp3-productid = `HT-1032`.
    temp3-suppliername = `Very Best Screens`.
    temp3-width = `40.8`.
    temp3-depth = `19`.
    temp3-height = `43`.
    temp3-dimunit = `cm`.
    temp3-price = `345`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Flat Basic`.
    temp3-productid = `HT-1035`.
    temp3-suppliername = `Very Best Screens`.
    temp3-width = `39`.
    temp3-depth = `20`.
    temp3-height = `41`.
    temp3-dimunit = `cm`.
    temp3-price = `399`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Flat Future`.
    temp3-productid = `HT-1036`.
    temp3-suppliername = `Very Best Screens`.
    temp3-width = `45`.
    temp3-depth = `26`.
    temp3-height = `46`.
    temp3-dimunit = `cm`.
    temp3-price = `430`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Flat XL`.
    temp3-productid = `HT-1037`.
    temp3-suppliername = `Very Best Screens`.
    temp3-width = `54.5`.
    temp3-depth = `22.1`.
    temp3-height = `39.1`.
    temp3-dimunit = `cm`.
    temp3-price = `1230`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Laser Professional Eco`.
    temp3-productid = `HT-1040`.
    temp3-suppliername = `Alpha Printers`.
    temp3-width = `51`.
    temp3-depth = `46`.
    temp3-height = `30`.
    temp3-dimunit = `cm`.
    temp3-price = `830`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Laser Basic`.
    temp3-productid = `HT-1041`.
    temp3-suppliername = `Alpha Printers`.
    temp3-width = `48`.
    temp3-depth = `42`.
    temp3-height = `26`.
    temp3-dimunit = `cm`.
    temp3-price = `490`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Laser Allround`.
    temp3-productid = `HT-1042`.
    temp3-suppliername = `Alpha Printers`.
    temp3-width = `53`.
    temp3-depth = `50`.
    temp3-height = `65`.
    temp3-dimunit = `cm`.
    temp3-price = `349`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Ultra Jet Super Color`.
    temp3-productid = `HT-1050`.
    temp3-suppliername = `Alpha Printers`.
    temp3-width = `41`.
    temp3-depth = `41`.
    temp3-height = `28`.
    temp3-dimunit = `cm`.
    temp3-price = `139`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Ultra Jet Mobile`.
    temp3-productid = `HT-1051`.
    temp3-suppliername = `Printer for All`.
    temp3-width = `46`.
    temp3-depth = `32`.
    temp3-height = `25`.
    temp3-dimunit = `cm`.
    temp3-price = `99`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Ultra Jet Super Highspeed`.
    temp3-productid = `HT-1052`.
    temp3-suppliername = `Printer for All`.
    temp3-width = `41`.
    temp3-depth = `41`.
    temp3-height = `28`.
    temp3-dimunit = `cm`.
    temp3-price = `170`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Multi Print`.
    temp3-productid = `HT-1055`.
    temp3-suppliername = `Printer for All`.
    temp3-width = `55`.
    temp3-depth = `45`.
    temp3-height = `29`.
    temp3-dimunit = `cm`.
    temp3-price = `99`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Multi Color`.
    temp3-productid = `HT-1056`.
    temp3-suppliername = `Printer for All`.
    temp3-width = `51`.
    temp3-depth = `41.3`.
    temp3-height = `22`.
    temp3-dimunit = `cm`.
    temp3-price = `119`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Cordless Mouse`.
    temp3-productid = `HT-1060`.
    temp3-suppliername = `Oxynum`.
    temp3-width = `6`.
    temp3-depth = `14.5`.
    temp3-height = `3.5`.
    temp3-dimunit = `cm`.
    temp3-price = `9`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Speed Mouse`.
    temp3-productid = `HT-1061`.
    temp3-suppliername = `Oxynum`.
    temp3-width = `7`.
    temp3-depth = `15`.
    temp3-height = `3.1`.
    temp3-dimunit = `cm`.
    temp3-price = `7`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Track Mouse`.
    temp3-productid = `HT-1062`.
    temp3-suppliername = `Oxynum`.
    temp3-width = `3`.
    temp3-depth = `7`.
    temp3-height = `4`.
    temp3-dimunit = `cm`.
    temp3-price = `11`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Ergonomic Keyboard`.
    temp3-productid = `HT-1063`.
    temp3-suppliername = `Oxynum`.
    temp3-width = `50`.
    temp3-depth = `21`.
    temp3-height = `3.5`.
    temp3-dimunit = `cm`.
    temp3-price = `14`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Internet Keyboard`.
    temp3-productid = `HT-1064`.
    temp3-suppliername = `Oxynum`.
    temp3-width = `52`.
    temp3-depth = `25`.
    temp3-height = `3`.
    temp3-dimunit = `cm`.
    temp3-price = `16`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Media Keyboard`.
    temp3-productid = `HT-1065`.
    temp3-suppliername = `Oxynum`.
    temp3-width = `51.4`.
    temp3-depth = `23`.
    temp3-height = `4`.
    temp3-dimunit = `cm`.
    temp3-price = `26`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Mousepad`.
    temp3-productid = `HT-1066`.
    temp3-suppliername = `Oxynum`.
    temp3-width = `15`.
    temp3-depth = `6`.
    temp3-height = `0.2`.
    temp3-dimunit = `cm`.
    temp3-price = `6.99`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Ergo Mousepad`.
    temp3-productid = `HT-1067`.
    temp3-suppliername = `Oxynum`.
    temp3-width = `15`.
    temp3-depth = `6`.
    temp3-height = `0.2`.
    temp3-dimunit = `cm`.
    temp3-price = `8.99`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Designer Mousepad`.
    temp3-productid = `HT-1068`.
    temp3-suppliername = `Fasttech`.
    temp3-width = `24`.
    temp3-depth = `24`.
    temp3-height = `0.6`.
    temp3-dimunit = `cm`.
    temp3-price = `12.99`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Universal card reader`.
    temp3-productid = `HT-1069`.
    temp3-suppliername = `Fasttech`.
    temp3-width = `6`.
    temp3-depth = `6`.
    temp3-height = `3`.
    temp3-dimunit = `cm`.
    temp3-price = `14`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Proctra X`.
    temp3-productid = `HT-1070`.
    temp3-suppliername = `Ultrasonic United`.
    temp3-width = `22`.
    temp3-depth = `35`.
    temp3-height = `17`.
    temp3-dimunit = `cm`.
    temp3-price = `70.9`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Gladiator MX`.
    temp3-productid = `HT-1071`.
    temp3-suppliername = `Ultrasonic United`.
    temp3-width = `22`.
    temp3-depth = `35`.
    temp3-height = `17`.
    temp3-dimunit = `cm`.
    temp3-price = `81.7`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Hurricane GX`.
    temp3-productid = `HT-1072`.
    temp3-suppliername = `Ultrasonic United`.
    temp3-width = `22`.
    temp3-depth = `35`.
    temp3-height = `17`.
    temp3-dimunit = `cm`.
    temp3-price = `101.2`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Hurricane GX/LN`.
    temp3-productid = `HT-1073`.
    temp3-suppliername = `Smartcards`.
    temp3-width = `22`.
    temp3-depth = `35`.
    temp3-height = `17`.
    temp3-dimunit = `cm`.
    temp3-price = `139.99`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Photo Scan`.
    temp3-productid = `HT-1080`.
    temp3-suppliername = `Printer for All`.
    temp3-width = `34`.
    temp3-depth = `48`.
    temp3-height = `5`.
    temp3-dimunit = `cm`.
    temp3-price = `129`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Power Scan`.
    temp3-productid = `HT-1081`.
    temp3-suppliername = `Printer for All`.
    temp3-width = `31`.
    temp3-depth = `43`.
    temp3-height = `7`.
    temp3-dimunit = `cm`.
    temp3-price = `89`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Jet Scan Professional`.
    temp3-productid = `HT-1082`.
    temp3-suppliername = `Printer for All`.
    temp3-width = `33`.
    temp3-depth = `41`.
    temp3-height = `12`.
    temp3-dimunit = `cm`.
    temp3-price = `169`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Jet Scan Professional`.
    temp3-productid = `HT-1083`.
    temp3-suppliername = `Printer for All`.
    temp3-width = `35`.
    temp3-depth = `40`.
    temp3-height = `10`.
    temp3-dimunit = `cm`.
    temp3-price = `189`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Copymaster`.
    temp3-productid = `HT-1085`.
    temp3-suppliername = `Alpha Printers`.
    temp3-width = `45`.
    temp3-depth = `42`.
    temp3-height = `22`.
    temp3-dimunit = `cm`.
    temp3-price = `1499`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Surround Sound`.
    temp3-productid = `HT-1090`.
    temp3-suppliername = `Speaker Experts`.
    temp3-width = `12`.
    temp3-depth = `10`.
    temp3-height = `16`.
    temp3-dimunit = `cm`.
    temp3-price = `39`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Blaster Extreme`.
    temp3-productid = `HT-1091`.
    temp3-suppliername = `Speaker Experts`.
    temp3-width = `13`.
    temp3-depth = `11`.
    temp3-height = `17.5`.
    temp3-dimunit = `cm`.
    temp3-price = `26`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Sound Booster`.
    temp3-productid = `HT-1092`.
    temp3-suppliername = `Speaker Experts`.
    temp3-width = `12.4`.
    temp3-depth = `10.4`.
    temp3-height = `18.1`.
    temp3-dimunit = `cm`.
    temp3-price = `45`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Lovely Sound 5.1 Wireless`.
    temp3-productid = `HT-1095`.
    temp3-suppliername = `Fasttech`.
    temp3-width = `24`.
    temp3-depth = `19`.
    temp3-height = `23`.
    temp3-dimunit = `cm`.
    temp3-price = `49`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Lovely Sound 5.1`.
    temp3-productid = `HT-1096`.
    temp3-suppliername = `Fasttech`.
    temp3-width = `25`.
    temp3-depth = `17`.
    temp3-height = `19`.
    temp3-dimunit = `cm`.
    temp3-price = `39`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Lovely Sound Stereo`.
    temp3-productid = `HT-1097`.
    temp3-suppliername = `Fasttech`.
    temp3-width = `21.3`.
    temp3-depth = `2.4`.
    temp3-height = `19.7`.
    temp3-dimunit = `cm`.
    temp3-price = `29`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Smart Office`.
    temp3-productid = `HT-1100`.
    temp3-suppliername = `Technocom`.
    temp3-width = `15`.
    temp3-depth = `6.5`.
    temp3-height = `2.1`.
    temp3-dimunit = `cm`.
    temp3-price = `89.9`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Smart Design`.
    temp3-productid = `HT-1101`.
    temp3-suppliername = `Technocom`.
    temp3-width = `14`.
    temp3-depth = `6.7`.
    temp3-height = `24`.
    temp3-dimunit = `cm`.
    temp3-price = `79.9`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Smart Network`.
    temp3-productid = `HT-1102`.
    temp3-suppliername = `Technocom`.
    temp3-width = `16`.
    temp3-depth = `6`.
    temp3-height = `27`.
    temp3-dimunit = `cm`.
    temp3-price = `69`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Smart Multimedia`.
    temp3-productid = `HT-1103`.
    temp3-suppliername = `Technocom`.
    temp3-width = `11`.
    temp3-depth = `3.4`.
    temp3-height = `22`.
    temp3-dimunit = `cm`.
    temp3-price = `77`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Smart Games`.
    temp3-productid = `HT-1104`.
    temp3-suppliername = `Technocom`.
    temp3-width = `10`.
    temp3-depth = `3`.
    temp3-height = `30`.
    temp3-dimunit = `cm`.
    temp3-price = `55`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Smart Internet Antivirus`.
    temp3-productid = `HT-1105`.
    temp3-suppliername = `Brainsoft`.
    temp3-width = `16`.
    temp3-depth = `4`.
    temp3-height = `21`.
    temp3-dimunit = `cm`.
    temp3-price = `29`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Smart Firewall`.
    temp3-productid = `HT-1106`.
    temp3-suppliername = `Brainsoft`.
    temp3-width = `17.9`.
    temp3-depth = `4.2`.
    temp3-height = `23.1`.
    temp3-dimunit = `cm`.
    temp3-price = `34`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Smart Money`.
    temp3-productid = `HT-1107`.
    temp3-suppliername = `Brainsoft`.
    temp3-width = `12`.
    temp3-depth = `1.5`.
    temp3-height = `19`.
    temp3-dimunit = `cm`.
    temp3-price = `29.9`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `PC Lock`.
    temp3-productid = `HT-1110`.
    temp3-suppliername = `Red Point Stores`.
    temp3-width = `20`.
    temp3-depth = `8`.
    temp3-height = `4.3`.
    temp3-dimunit = `cm`.
    temp3-price = `8.9`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Notebook Lock`.
    temp3-productid = `HT-1111`.
    temp3-suppliername = `Red Point Stores`.
    temp3-width = `31`.
    temp3-depth = `9`.
    temp3-height = `7`.
    temp3-dimunit = `cm`.
    temp3-price = `6.9`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Web cam reality`.
    temp3-productid = `HT-1112`.
    temp3-suppliername = `Red Point Stores`.
    temp3-width = `9`.
    temp3-depth = `8.2`.
    temp3-height = `1.3`.
    temp3-dimunit = `cm`.
    temp3-price = `39`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Screen clean`.
    temp3-productid = `HT-1113`.
    temp3-suppliername = `Red Point Stores`.
    temp3-width = `2`.
    temp3-depth = `2`.
    temp3-height = `0.1`.
    temp3-dimunit = `cm`.
    temp3-price = `2.3`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Fabric bag professional`.
    temp3-productid = `HT-1114`.
    temp3-suppliername = `Red Point Stores`.
    temp3-width = `42`.
    temp3-depth = `32`.
    temp3-height = `7`.
    temp3-dimunit = `cm`.
    temp3-price = `31`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Wireless DSL Router`.
    temp3-productid = `HT-1115`.
    temp3-suppliername = `Red Point Stores`.
    temp3-width = `19.3`.
    temp3-depth = `18`.
    temp3-height = `5`.
    temp3-dimunit = `cm`.
    temp3-price = `49`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Wireless DSL Router / Repeater`.
    temp3-productid = `HT-1116`.
    temp3-suppliername = `Red Point Stores`.
    temp3-width = `19.3`.
    temp3-depth = `18`.
    temp3-height = `5`.
    temp3-dimunit = `cm`.
    temp3-price = `59`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Wireless DSL Router / Repeater and Print Server`.
    temp3-productid = `HT-1117`.
    temp3-suppliername = `Technocom`.
    temp3-width = `19.3`.
    temp3-depth = `18`.
    temp3-height = `5`.
    temp3-dimunit = `cm`.
    temp3-price = `69`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `USB Stick`.
    temp3-productid = `HT-1118`.
    temp3-suppliername = `Technocom`.
    temp3-width = `1.5`.
    temp3-depth = `8.7`.
    temp3-height = `1.2`.
    temp3-dimunit = `cm`.
    temp3-price = `35`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Travel Adapter`.
    temp3-productid = `HT-1119`.
    temp3-suppliername = `Titanium`.
    temp3-width = `2`.
    temp3-depth = `3.1`.
    temp3-height = `3.9`.
    temp3-dimunit = `cm`.
    temp3-price = `79`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Cordless Bluetooth Keyboard, english international`.
    temp3-productid = `HT-1120`.
    temp3-suppliername = `Technocom`.
    temp3-width = `51.4`.
    temp3-depth = `23`.
    temp3-height = `4`.
    temp3-dimunit = `cm`.
    temp3-price = `29`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Flat XXL`.
    temp3-productid = `HT-1137`.
    temp3-suppliername = `Technocom`.
    temp3-width = `54`.
    temp3-depth = `22`.
    temp3-height = `38`.
    temp3-dimunit = `cm`.
    temp3-price = `1430`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Pocket Mouse`.
    temp3-productid = `HT-1138`.
    temp3-suppliername = `Technocom`.
    temp3-width = `0.3`.
    temp3-depth = `0.5`.
    temp3-height = `1`.
    temp3-dimunit = `cm`.
    temp3-price = `23`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `PC Power Station`.
    temp3-productid = `HT-1210`.
    temp3-suppliername = `Technocom`.
    temp3-width = `28`.
    temp3-depth = `31`.
    temp3-height = `43`.
    temp3-dimunit = `cm`.
    temp3-price = `2399`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Astro Laptop 1516`.
    temp3-productid = `HT-1251`.
    temp3-suppliername = `Ultrasonic United`.
    temp3-width = `30`.
    temp3-depth = `18`.
    temp3-height = `3`.
    temp3-dimunit = `cm`.
    temp3-price = `989`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Astro Phone 6`.
    temp3-productid = `HT-1252`.
    temp3-suppliername = `Ultrasonic United`.
    temp3-width = `8`.
    temp3-depth = `6`.
    temp3-height = `1.5`.
    temp3-dimunit = `cm`.
    temp3-price = `649`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Benda Laptop 1408`.
    temp3-productid = `HT-1253`.
    temp3-suppliername = `Ultrasonic United`.
    temp3-width = `30`.
    temp3-depth = `18`.
    temp3-height = `3`.
    temp3-dimunit = `cm`.
    temp3-price = `976`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Bending Screen 21HD`.
    temp3-productid = `HT-1254`.
    temp3-suppliername = `Ultrasonic United`.
    temp3-width = `37`.
    temp3-depth = `12`.
    temp3-height = `36`.
    temp3-dimunit = `cm`.
    temp3-price = `250`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Broad Screen 22HD`.
    temp3-productid = `HT-1255`.
    temp3-suppliername = `Ultrasonic United`.
    temp3-width = `39`.
    temp3-depth = `12`.
    temp3-height = `38`.
    temp3-dimunit = `cm`.
    temp3-price = `270`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Cerdik Phone 7`.
    temp3-productid = `HT-1256`.
    temp3-suppliername = `Ultrasonic United`.
    temp3-width = `9`.
    temp3-depth = `15`.
    temp3-height = `1.5`.
    temp3-dimunit = `cm`.
    temp3-price = `549`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Cepat Tablet 10.5`.
    temp3-productid = `HT-1257`.
    temp3-suppliername = `Ultrasonic United`.
    temp3-width = `48`.
    temp3-depth = `31`.
    temp3-height = `4.5`.
    temp3-dimunit = `cm`.
    temp3-price = `549`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Cepat Tablet 8`.
    temp3-productid = `HT-1258`.
    temp3-suppliername = `Ultrasonic United`.
    temp3-width = `38`.
    temp3-depth = `21`.
    temp3-height = `3.5`.
    temp3-dimunit = `cm`.
    temp3-price = `529`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Server Basic`.
    temp3-productid = `HT-1500`.
    temp3-suppliername = `Technocom`.
    temp3-width = `34`.
    temp3-depth = `35`.
    temp3-height = `23`.
    temp3-dimunit = `cm`.
    temp3-price = `5000`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Server Professional`.
    temp3-productid = `HT-1501`.
    temp3-suppliername = `Technocom`.
    temp3-width = `29`.
    temp3-depth = `30`.
    temp3-height = `27`.
    temp3-dimunit = `cm`.
    temp3-price = `15000`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Server Power Pro`.
    temp3-productid = `HT-1502`.
    temp3-suppliername = `Technocom`.
    temp3-width = `22`.
    temp3-depth = `27.3`.
    temp3-height = `37`.
    temp3-dimunit = `cm`.
    temp3-price = `25000`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Family PC Basic`.
    temp3-productid = `HT-1600`.
    temp3-suppliername = `Titanium`.
    temp3-width = `21.4`.
    temp3-depth = `29`.
    temp3-height = `38`.
    temp3-dimunit = `cm`.
    temp3-price = `600`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Family PC Pro`.
    temp3-productid = `HT-1601`.
    temp3-suppliername = `Titanium`.
    temp3-width = `25`.
    temp3-depth = `31.7`.
    temp3-height = `40.2`.
    temp3-dimunit = `cm`.
    temp3-price = `900`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Gaming Monster`.
    temp3-productid = `HT-1602`.
    temp3-suppliername = `Titanium`.
    temp3-width = `26.5`.
    temp3-depth = `34`.
    temp3-height = `47`.
    temp3-dimunit = `cm`.
    temp3-price = `1200`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Gaming Monster Pro`.
    temp3-productid = `HT-1603`.
    temp3-suppliername = `Titanium`.
    temp3-width = `27`.
    temp3-depth = `28`.
    temp3-height = `42`.
    temp3-dimunit = `cm`.
    temp3-price = `1700`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `7" Widescreen Portable DVD Player w MP3`.
    temp3-productid = `HT-2000`.
    temp3-suppliername = `Titanium`.
    temp3-width = `21.4`.
    temp3-depth = `19`.
    temp3-height = `27.6`.
    temp3-dimunit = `cm`.
    temp3-price = `249.99`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `10" Portable DVD player`.
    temp3-productid = `HT-2001`.
    temp3-suppliername = `Titanium`.
    temp3-width = `24`.
    temp3-depth = `19.5`.
    temp3-height = `29`.
    temp3-dimunit = `cm`.
    temp3-price = `449.99`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Portable DVD Player with 9" LCD Monitor`.
    temp3-productid = `HT-2002`.
    temp3-suppliername = `Technocom`.
    temp3-width = `21`.
    temp3-depth = `16.5`.
    temp3-height = `14`.
    temp3-dimunit = `cm`.
    temp3-price = `853.99`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `CD/DVD case: 264 sleeves`.
    temp3-productid = `HT-2025`.
    temp3-suppliername = `Titanium`.
    temp3-width = `13`.
    temp3-depth = `13`.
    temp3-height = `20`.
    temp3-dimunit = `cm`.
    temp3-price = `44.99`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Audio/Video Cable Kit - 4m`.
    temp3-productid = `HT-2026`.
    temp3-suppliername = `Titanium`.
    temp3-width = `21`.
    temp3-depth = `10.2`.
    temp3-height = `13`.
    temp3-dimunit = `cm`.
    temp3-price = `29.99`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Removable CD/DVD Laser Labels`.
    temp3-productid = `HT-2027`.
    temp3-suppliername = `Titanium`.
    temp3-width = `5.5`.
    temp3-depth = `2`.
    temp3-height = `2`.
    temp3-dimunit = `cm`.
    temp3-price = `8.99`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Beam Breaker B-1`.
    temp3-productid = `HT-6100`.
    temp3-suppliername = `Titanium`.
    temp3-width = `30.4`.
    temp3-depth = `23.1`.
    temp3-height = `23`.
    temp3-dimunit = `cm`.
    temp3-price = `469`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Beam Breaker B-2`.
    temp3-productid = `HT-6101`.
    temp3-suppliername = `Technocom`.
    temp3-width = `30.4`.
    temp3-depth = `23.1`.
    temp3-height = `23`.
    temp3-dimunit = `cm`.
    temp3-price = `679`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Beam Breaker B-3`.
    temp3-productid = `HT-6102`.
    temp3-suppliername = `Technocom`.
    temp3-width = `30.4`.
    temp3-depth = `23.1`.
    temp3-height = `23`.
    temp3-dimunit = `cm`.
    temp3-price = `889`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Play Movie`.
    temp3-productid = `HT-6110`.
    temp3-suppliername = `Fasttech`.
    temp3-width = `37`.
    temp3-depth = `24`.
    temp3-height = `6`.
    temp3-dimunit = `cm`.
    temp3-price = `130`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Record Movie`.
    temp3-productid = `HT-6111`.
    temp3-suppliername = `Fasttech`.
    temp3-width = `38`.
    temp3-depth = `26`.
    temp3-height = `6.2`.
    temp3-dimunit = `cm`.
    temp3-price = `288`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `ITelo MusicStick`.
    temp3-productid = `HT-6120`.
    temp3-suppliername = `Fasttech`.
    temp3-width = `1.5`.
    temp3-depth = `6`.
    temp3-height = `1`.
    temp3-dimunit = `cm`.
    temp3-price = `45`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `ITelo Jog-Mate`.
    temp3-productid = `HT-6121`.
    temp3-suppliername = `Fasttech`.
    temp3-width = `5.1`.
    temp3-depth = `8`.
    temp3-height = `9.2`.
    temp3-dimunit = `cm`.
    temp3-price = `63`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Power Pro Player 40`.
    temp3-productid = `HT-6122`.
    temp3-suppliername = `Fasttech`.
    temp3-width = `5.1`.
    temp3-depth = `8`.
    temp3-height = `9.2`.
    temp3-dimunit = `cm`.
    temp3-price = `167`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Power Pro Player 80`.
    temp3-productid = `HT-6123`.
    temp3-suppliername = `Fasttech`.
    temp3-width = `4`.
    temp3-depth = `6`.
    temp3-height = `0.8`.
    temp3-dimunit = `cm`.
    temp3-price = `299`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Flat Watch HD32`.
    temp3-productid = `HT-6130`.
    temp3-suppliername = `Very Best Screens`.
    temp3-width = `78`.
    temp3-depth = `22.1`.
    temp3-height = `55`.
    temp3-dimunit = `cm`.
    temp3-price = `1459`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Flat Watch HD37`.
    temp3-productid = `HT-6131`.
    temp3-suppliername = `Very Best Screens`.
    temp3-width = `99.1`.
    temp3-depth = `26`.
    temp3-height = `61`.
    temp3-dimunit = `cm`.
    temp3-price = `1199`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Flat Watch HD41`.
    temp3-productid = `HT-6132`.
    temp3-suppliername = `Very Best Screens`.
    temp3-width = `128`.
    temp3-depth = `23`.
    temp3-height = `79.1`.
    temp3-dimunit = `cm`.
    temp3-price = `899`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Copperberry`.
    temp3-productid = `HT-7000`.
    temp3-suppliername = `Fasttech`.
    temp3-width = `8.1`.
    temp3-depth = `13`.
    temp3-height = `12.1`.
    temp3-dimunit = `cm`.
    temp3-price = `549`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Silverberry`.
    temp3-productid = `HT-7010`.
    temp3-suppliername = `Fasttech`.
    temp3-width = `8.1`.
    temp3-depth = `13`.
    temp3-height = `12.1`.
    temp3-dimunit = `cm`.
    temp3-price = `549`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Goldberry`.
    temp3-productid = `HT-7020`.
    temp3-suppliername = `Fasttech`.
    temp3-width = `8.1`.
    temp3-depth = `13`.
    temp3-height = `12.1`.
    temp3-dimunit = `cm`.
    temp3-price = `549`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Platinberry`.
    temp3-productid = `HT-7030`.
    temp3-suppliername = `Fasttech`.
    temp3-width = `8.1`.
    temp3-depth = `13`.
    temp3-height = `12.1`.
    temp3-dimunit = `cm`.
    temp3-price = `549`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `ITelO FlexTop I4000`.
    temp3-productid = `HT-8000`.
    temp3-suppliername = `Titanium`.
    temp3-width = `31`.
    temp3-depth = `19`.
    temp3-height = `3.1`.
    temp3-dimunit = `cm`.
    temp3-price = `799`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `ITelO FlexTop I6300c`.
    temp3-productid = `HT-8001`.
    temp3-suppliername = `Titanium`.
    temp3-width = `32`.
    temp3-depth = `20`.
    temp3-height = `3.4`.
    temp3-dimunit = `cm`.
    temp3-price = `799`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `ITelO FlexTop I9100`.
    temp3-productid = `HT-8002`.
    temp3-suppliername = `Titanium`.
    temp3-width = `38`.
    temp3-depth = `21`.
    temp3-height = `4.1`.
    temp3-dimunit = `cm`.
    temp3-price = `1199`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `ITelO FlexTop I9800`.
    temp3-productid = `HT-8003`.
    temp3-suppliername = `Titanium`.
    temp3-width = `48`.
    temp3-depth = `31`.
    temp3-height = `4.5`.
    temp3-dimunit = `cm`.
    temp3-price = `1388`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Smartphone Leather Case`.
    temp3-productid = `HT-9991`.
    temp3-suppliername = `Ultrasonic United`.
    temp3-width = `48`.
    temp3-depth = `31`.
    temp3-height = `4.5`.
    temp3-dimunit = `cm`.
    temp3-price = `25`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Smartphone Alpha`.
    temp3-productid = `HT-9992`.
    temp3-suppliername = `Ultrasonic United`.
    temp3-width = `48`.
    temp3-depth = `31`.
    temp3-height = `4.5`.
    temp3-dimunit = `cm`.
    temp3-price = `599`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Mini Tablet`.
    temp3-productid = `HT-9993`.
    temp3-suppliername = `Ultrasonic United`.
    temp3-width = `48`.
    temp3-depth = `31`.
    temp3-height = `4.5`.
    temp3-dimunit = `cm`.
    temp3-price = `833`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Camcorder View`.
    temp3-productid = `HT-9994`.
    temp3-suppliername = `Ultrasonic United`.
    temp3-width = `48`.
    temp3-depth = `31`.
    temp3-height = `27`.
    temp3-dimunit = `cm`.
    temp3-price = `1388`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Tablet Pouch`.
    temp3-productid = `HT-9995`.
    temp3-suppliername = `Titanium`.
    temp3-width = `25`.
    temp3-depth = `40`.
    temp3-height = `4.5`.
    temp3-dimunit = `cm`.
    temp3-price = `20`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Tablet Pouch`.
    temp3-productid = `HT-9996`.
    temp3-suppliername = `Titanium`.
    temp3-width = `25`.
    temp3-depth = `40`.
    temp3-height = `4.5`.
    temp3-dimunit = `cm`.
    temp3-price = `20`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `e-Book Reader ReadMe`.
    temp3-productid = `HT-9997`.
    temp3-suppliername = `Titanium`.
    temp3-width = `48`.
    temp3-depth = `31`.
    temp3-height = `4.5`.
    temp3-dimunit = `cm`.
    temp3-price = `33`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Smartphone Beta`.
    temp3-productid = `HT-9998`.
    temp3-suppliername = `Titanium`.
    temp3-width = `48`.
    temp3-depth = `31`.
    temp3-height = `4.5`.
    temp3-dimunit = `cm`.
    temp3-price = `30`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Maxi Tablet`.
    temp3-productid = `HT-9999`.
    temp3-suppliername = `Titanium`.
    temp3-width = `48`.
    temp3-depth = `31`.
    temp3-height = `4.5`.
    temp3-dimunit = `cm`.
    temp3-price = `749`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    temp3-name = `Flyer`.
    temp3-productid = `PF-1000`.
    temp3-suppliername = `Titanium`.
    temp3-width = `46`.
    temp3-depth = `30`.
    temp3-height = `3`.
    temp3-dimunit = `cm`.
    temp3-price = `0`.
    temp3-currencycode = `EUR`.
    INSERT temp3 INTO TABLE temp2.
    productcollection = temp2.

  ENDMETHOD.

ENDCLASS.
