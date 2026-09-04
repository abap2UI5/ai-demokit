" @keywords dynamicpage dynamic sap.f dynamicpageanalyticaltable dynamicpagetitle title label overflowtoolbar generictag objectnumber toolbarspacer button
" @summary Dynamic Page containing an Analytical Table in the content area aligned with the SAP Fiori List Report floorplan.
CLASS z2ui5_cl_smpc_app_559 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_named,
             name TYPE string,
           END OF ty_s_named.
    TYPES: BEGIN OF ty_s_product,
             productid      TYPE string,
             name           TYPE string,
             quantity       TYPE i,
             status         TYPE string,
             price          TYPE p LENGTH 9 DECIMALS 2,
             currencycode   TYPE string,
             suppliername   TYPE string,
             productpicurl  TYPE string,
             category       TYPE string,
             weightmeasure  TYPE p LENGTH 9 DECIMALS 3,
             " derived in initSampleDataModel, reproduced in model_init
             available      TYPE abap_bool,
             availablestate TYPE string,
             availableicon  TYPE string,
             heavy          TYPE string,
             deliverydate   TYPE string,
           END OF ty_s_product.

    TYPES temp1_82f58d8ed1 TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.
DATA productcollection TYPE temp1_82f58d8ed1.
    TYPES temp2_82f58d8ed1 TYPE STANDARD TABLE OF ty_s_named WITH DEFAULT KEY.
DATA suppliers         TYPE temp2_82f58d8ed1.
    TYPES temp3_82f58d8ed1 TYPE STANDARD TABLE OF ty_s_named WITH DEFAULT KEY.
DATA categories        TYPE temp3_82f58d8ed1.
    " initSampleDataModel puts headerExpanded on the model and the page binds it
    DATA headerexpanded    TYPE abap_bool VALUE abap_true.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS popover_display IMPORTING by_id TYPE string.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_559 IMPLEMENTATION.

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
    DATA page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA title TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA columns TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    page = view->ele( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:c`    v = `sap.ui.core`
        )->a( n = `xmlns:u`    v = `sap.ui.unified`
        )->a( n = `xmlns:t`    v = `sap.ui.table`
        )->a( n = `xmlns:f`    v = `sap.f`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`

        )->ele( n = `DynamicPage` ns = `f`
            )->a( n = `id`                         v = `dynamicPageId`
            )->a( n = `preserveHeaderStateOnScroll` v = `true`
            )->a( n = `headerExpanded`             v = client->_bind( headerexpanded )
            )->a( n = `showFooter`                 v = `true`
            )->a( n = `fitContent`                 v = `true` ).

    " DynamicPage Title
    
    title = page->ele( n = `title` ns = `f`
        )->ele( n = `DynamicPageTitle` ns = `f` ).

    title->ele( n = `heading` ns = `f`
        )->tag( `Title`
            )->a( n = `text` v = `Header Title`

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
                    " onGenericTagPress anchors the card popover on the pressed tag
                    )->a( n = `press`  v = client->_event( val = `GENERIC_TAG` arg = `$event.oSource.sId` )

                    )->tag( `ObjectNumber`
                        )->a( n = `number`     v = `2`
                        )->a( n = `unit`       v = `M`
                        )->a( n = `emphasized` v = `false`
                        )->a( n = `state`      v = `Error`

                )->end(
            )->end(
        )->end(
        )->ele( n = `actions` ns = `f`
            )->tag( `ToolbarSpacer`
            )->tag( `Button`
                )->a( n = `text` v = `Edit`
                )->a( n = `type` v = `Emphasized`
            )->tag( `Button`
                )->a( n = `text` v = `Delete`
                )->a( n = `type` v = `Transparent`
            )->tag( `Button`
                )->a( n = `text` v = `Copy`
                )->a( n = `type` v = `Transparent`
            )->tag( `Button`
                )->a( n = `icon`    v = `sap-icon://action`
                )->a( n = `tooltip` v = `Share`
                )->a( n = `type`    v = `Transparent` ).

    " DynamicPage Header
    page->ele( n = `header` ns = `f`
        )->ele( n = `DynamicPageHeader` ns = `f`
            )->a( n = `pinnable` v = `true`

            )->ele( `FlexBox`
                )->a( n = `alignItems`     v = `Start`
                )->a( n = `justifyContent` v = `SpaceBetween`

                )->ele( `items`
                    )->ele( `Panel`
                        )->a( n = `backgroundDesign` v = `Transparent`
                        )->a( n = `class`            v = `sapUiNoContentPadding`

                        )->ele( `content`
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
                )->end(
            )->end(
        )->end(
    )->end( ).

    
    columns = page->ele( n = `content` ns = `f`
        )->ele( n = `Table` ns = `t`
            )->a( n = `rows`          v = client->_bind( productcollection )
            )->a( n = `selectionMode` v = `MultiToggle`
            )->a( n = `rowMode`       v = `Auto`

            )->ele( n = `extension` ns = `t`
                )->ele( `OverflowToolbar`
                    )->a( n = `style` v = `Clear`

                    )->tag( `Title`
                        )->a( n = `text` v = `Products`

                )->end(
            )->end(
            )->ele( n = `columns` ns = `t` ).

    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `Details for product with id {0}` INTO TABLE temp1.
    INSERT `${PRODUCTID}` INTO TABLE temp1.
    columns->ele( n = `Column` ns = `t`
        )->a( n = `width` v = `11rem`
        )->tag( `Label`
            )->a( n = `text` v = `Product Name`
        )->ele( n = `template` ns = `t`
            )->tag( `Text`
                )->a( n = `text`     v = `{NAME}`
                )->a( n = `wrapping` v = `false`

        )->end(
    )->end(
        )->ele( n = `Column` ns = `t`
            )->a( n = `width` v = `11rem`
            )->tag( `Label`
                )->a( n = `text` v = `Product Id`
            )->ele( n = `template` ns = `t`
                )->tag( `Input`
                    )->a( n = `value` v = `{PRODUCTID}`

            )->end(
        )->end(
        )->ele( n = `Column` ns = `t`
            )->a( n = `width`  v = `6rem`
            )->a( n = `hAlign` v = `End`
            )->tag( `Label`
                )->a( n = `text` v = `Quantity`
            )->ele( n = `template` ns = `t`
                )->tag( `Label`
                    )->a( n = `text` v = `{QUANTITY}`

            )->end(
        )->end(
        )->ele( n = `Column` ns = `t`
            )->a( n = `width` v = `9rem`
            )->tag( `Label`
                )->a( n = `text` v = `Status`
            )->ele( n = `template` ns = `t`
                )->tag( `ObjectStatus`
                    )->a( n = `text`  v = `{STATUS}`
                    " formatAvailableToObjectState is computed in ABAP (thin frontend)
                    )->a( n = `state` v = `{AVAILABLESTATE}`

            )->end(
        )->end(
        )->ele( n = `Column` ns = `t`
            )->a( n = `width` v = `9rem`
            )->tag( `Label`
                )->a( n = `text` v = `Price`
            )->ele( n = `template` ns = `t`
                )->tag( n = `Currency` ns = `u`
                    )->a( n = `value`    v = `{PRICE}`
                    )->a( n = `currency` v = `{CURRENCYCODE}`

            )->end(
        )->end(
        )->ele( n = `Column` ns = `t`
            )->a( n = `width` v = `12rem`
            )->tag( `Label`
                )->a( n = `text` v = `Supplier`
            )->ele( n = `template` ns = `t`
                )->ele( `ComboBox`
                    )->a( n = `value` v = `{SUPPLIERNAME}`
                    )->a( n = `items` v = |\{ path: '{ client->_bind_path( suppliers ) }', templateShareable: false \}|

                    )->tag( n = `Item` ns = `c`
                        )->a( n = `text` v = `{NAME}`

                )->end(
            )->end(
        )->end(
        )->ele( n = `Column` ns = `t`
            )->a( n = `width` v = `9rem`
            )->tag( `Label`
                )->a( n = `text` v = `Image`
            )->ele( n = `template` ns = `t`
                )->tag( `Link`
                    )->a( n = `text`   v = `Show Image`
                    )->a( n = `href`   v = `{PRODUCTPICURL}`
                    )->a( n = `target` v = `_blank`

            )->end(
        )->end(
        )->ele( n = `Column` ns = `t`
            )->a( n = `width` v = `9rem`
            )->tag( `Label`
                )->a( n = `text` v = `Details`
            )->ele( n = `template` ns = `t`
                " handleDetailsPress toasts the row's ProductId - the row field
                " resolves on the client, so no round-trip
                )->tag( `Button`
                    )->a( n = `text`  v = `Show Details`
                    )->a( n = `press` v = client->follow_up_action(
                              val   = client->cs_event-control_global
                              t_arg = temp1 )

            )->end(
        )->end(
        )->ele( n = `Column` ns = `t`
            )->a( n = `width` v = `7rem`
            )->tag( `Label`
                )->a( n = `text` v = `Heavy Weight`
            )->ele( n = `template` ns = `t`
                )->tag( `CheckBox`
                    )->a( n = `selected` v = |\{ path: 'HEAVY', type: 'sap.ui.model.type.String' \}|

            )->end(
        )->end(
        )->ele( n = `Column` ns = `t`
            )->a( n = `width` v = `12rem`
            )->tag( `Label`
                )->a( n = `text` v = `Category`
            )->ele( n = `template` ns = `t`
                )->ele( `Select`
                    )->a( n = `selectedKey` v = `{CATEGORY}`
                    )->a( n = `items`       v = |\{ path: '{ client->_bind_path( categories ) }', templateShareable: false \}|

                    )->tag( n = `Item` ns = `c`
                        )->a( n = `text` v = `{NAME}`
                        )->a( n = `key`  v = `{NAME}`

                )->end(
            )->end(
        )->end(
        )->ele( n = `Column` ns = `t`
            )->a( n = `width`  v = `6rem`
            )->a( n = `hAlign` v = `Center`
            )->tag( `Label`
                )->a( n = `text` v = `Status`
            )->ele( n = `template` ns = `t`
                )->tag( n = `Icon` ns = `c`
                    " formatAvailableToIcon is computed in ABAP (thin frontend)
                    )->a( n = `src` v = `{AVAILABLEICON}`

            )->end(
        )->end(
        )->ele( n = `Column` ns = `t`
            )->a( n = `width`  v = `11rem`
            )->a( n = `hAlign` v = `Center`
            )->tag( `Label`
                )->a( n = `text` v = `Delivery Date`
            )->ele( n = `template` ns = `t`
                )->tag( `DatePicker`
                    )->a( n = `value` v = |\{ path: 'DELIVERYDATE', type: 'sap.ui.model.type.Date', formatOptions: \{ source: \{ pattern: 'yyyy-MM-dd' \} \} \}|

            )->end(
        )->end(
    )->end(
    )->end( ).

    " DynamicPage Footer
    page->ele( n = `footer` ns = `f`
        )->ele( `OverflowToolbar`
            )->tag( `ToolbarSpacer`
            )->tag( `Button`
                )->a( n = `type` v = `Accept`
                )->a( n = `text` v = `Accept`
            )->tag( `Button`
                )->a( n = `type` v = `Reject`
                )->a( n = `text` v = `Reject` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD popover_display.

    " Card.fragment.xml - the numeric card the GenericTag opens
    DATA popup TYPE REF TO z2ui5_cl_ui5_view_builder.
    popup = z2ui5_cl_ui5_view_builder=>factory( ).

    popup->ele( n = `FragmentDefinition` ns = `core`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:f`    v = `sap.f`
        )->a( n = `xmlns:card` v = `sap.f.cards`

        )->ele( `Popover`
            )->a( n = `placement`    v = `Right`
            )->a( n = `showHeader`   v = `false`
            )->a( n = `contentWidth` v = `300px`

            )->ele( n = `Card` ns = `f`
                )->a( n = `width` v = `300px`

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

    client->popover_display( xml = popup->stringify( ) by_id = by_id ).

  ENDMETHOD.


  METHOD on_event.

    " onGenericTagPress is the sample's only handler that reaches the backend
    IF client->get_event( ) = `GENERIC_TAG`.
      popover_display( client->get_event_arg( ) ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " sap/ui/demo/mock/products.json, all 123 rows verbatim (ui5/mock/products.json)
    DATA temp3 LIKE productcollection.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp5 LIKE LINE OF productcollection.
    DATA product LIKE REF TO temp5.
      DATA temp6 TYPE d.
      DATA temp1 TYPE d.
      DATA delivery LIKE temp6.
      DATA temp2 TYPE xsdboolean.
      DATA temp7 TYPE z2ui5_cl_smpc_app_559=>ty_s_product-availablestate.
      DATA temp8 TYPE z2ui5_cl_smpc_app_559=>ty_s_product-availableicon.
      DATA temp9 TYPE z2ui5_cl_smpc_app_559=>ty_s_product-heavy.
      DATA temp10 LIKE sy-subrc.
        DATA temp11 TYPE z2ui5_cl_smpc_app_559=>ty_s_named.
      DATA temp12 LIKE sy-subrc.
        DATA temp13 TYPE z2ui5_cl_smpc_app_559=>ty_s_named.
    CLEAR temp3.
    
    temp4-productid = `HT-1000`.
    temp4-name = `Notebook Basic 15`.
    temp4-quantity = 10.
    temp4-status = `Available`.
    temp4-price = '956'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Very Best Screens`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`.
    temp4-category = `Laptops`.
    temp4-weightmeasure = '4.2'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1001`.
    temp4-name = `Notebook Basic 17`.
    temp4-quantity = 20.
    temp4-status = `Available`.
    temp4-price = '1249'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Very Best Screens`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg`.
    temp4-category = `Laptops`.
    temp4-weightmeasure = '4.5'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1002`.
    temp4-name = `Notebook Basic 18`.
    temp4-quantity = 10.
    temp4-status = `Available`.
    temp4-price = '1570'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Very Best Screens`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg`.
    temp4-category = `Laptops`.
    temp4-weightmeasure = '4.2'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1003`.
    temp4-name = `Notebook Basic 19`.
    temp4-quantity = 15.
    temp4-status = `Out of Stock`.
    temp4-price = '1650'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Smartcards`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg`.
    temp4-category = `Laptops`.
    temp4-weightmeasure = '4.2'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1007`.
    temp4-name = `ITelO Vault`.
    temp4-quantity = 15.
    temp4-status = `Out of Stock`.
    temp4-price = '299'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '0.2'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1010`.
    temp4-name = `Notebook Professional 15`.
    temp4-quantity = 16.
    temp4-status = `Out of Stock`.
    temp4-price = '1999'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Very Best Screens`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '4.3'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1011`.
    temp4-name = `Notebook Professional 17`.
    temp4-quantity = 17.
    temp4-status = `Out of Stock`.
    temp4-price = '2299'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Very Best Screens`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg`.
    temp4-category = `Laptops`.
    temp4-weightmeasure = '4.1'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1020`.
    temp4-name = `ITelO Vault Net`.
    temp4-quantity = 14.
    temp4-status = `Discontinued`.
    temp4-price = '459'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '0.16'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1021`.
    temp4-name = `ITelO Vault SAT`.
    temp4-quantity = 50.
    temp4-status = `Available`.
    temp4-price = '149'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '0.18'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1022`.
    temp4-name = `Comfort Easy`.
    temp4-quantity = 30.
    temp4-status = `Out of Stock`.
    temp4-price = '1679'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '0.2'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1023`.
    temp4-name = `Comfort Senior`.
    temp4-quantity = 24.
    temp4-status = `Available`.
    temp4-price = '512'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '0.8'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1030`.
    temp4-name = `Ergo Screen E-I`.
    temp4-quantity = 14.
    temp4-status = `Available`.
    temp4-price = '230'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Very Best Screens`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg`.
    temp4-category = `Flat Screen Monitors`.
    temp4-weightmeasure = '21'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1031`.
    temp4-name = `Ergo Screen E-II`.
    temp4-quantity = 24.
    temp4-status = `Available`.
    temp4-price = '285'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Very Best Screens`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg`.
    temp4-category = `Flat Screen Monitors`.
    temp4-weightmeasure = '21'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1032`.
    temp4-name = `Ergo Screen E-III`.
    temp4-quantity = 50.
    temp4-status = `Out of Stock`.
    temp4-price = '345'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Very Best Screens`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg`.
    temp4-category = `Flat Screen Monitors`.
    temp4-weightmeasure = '21'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1035`.
    temp4-name = `Flat Basic`.
    temp4-quantity = 23.
    temp4-status = `Available`.
    temp4-price = '399'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Very Best Screens`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg`.
    temp4-category = `Flat Screen Monitors`.
    temp4-weightmeasure = '14'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1036`.
    temp4-name = `Flat Future`.
    temp4-quantity = 22.
    temp4-status = `Available`.
    temp4-price = '430'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Very Best Screens`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg`.
    temp4-category = `Flat Screen Monitors`.
    temp4-weightmeasure = '15'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1037`.
    temp4-name = `Flat XL`.
    temp4-quantity = 23.
    temp4-status = `Available`.
    temp4-price = '1230'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Very Best Screens`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg`.
    temp4-category = `Flat Screen Monitors`.
    temp4-weightmeasure = '17'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1040`.
    temp4-name = `Laser Professional Eco`.
    temp4-quantity = 21.
    temp4-status = `Available`.
    temp4-price = '830'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Alpha Printers`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg`.
    temp4-category = `Printers`.
    temp4-weightmeasure = '32'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1041`.
    temp4-name = `Laser Basic`.
    temp4-quantity = 8.
    temp4-status = `Available`.
    temp4-price = '490'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Alpha Printers`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg`.
    temp4-category = `Printers`.
    temp4-weightmeasure = '23'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1042`.
    temp4-name = `Laser Allround`.
    temp4-quantity = 9.
    temp4-status = `Available`.
    temp4-price = '349'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Alpha Printers`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg`.
    temp4-category = `Printers`.
    temp4-weightmeasure = '17'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1050`.
    temp4-name = `Ultra Jet Super Color`.
    temp4-quantity = 17.
    temp4-status = `Discontinued`.
    temp4-price = '139'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Alpha Printers`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg`.
    temp4-category = `Printers`.
    temp4-weightmeasure = '3'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1051`.
    temp4-name = `Ultra Jet Mobile`.
    temp4-quantity = 18.
    temp4-status = `Discontinued`.
    temp4-price = '99'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Printer for All`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg`.
    temp4-category = `Printers`.
    temp4-weightmeasure = '1.9'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1052`.
    temp4-name = `Ultra Jet Super Highspeed`.
    temp4-quantity = 25.
    temp4-status = `Available`.
    temp4-price = '170'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Printer for All`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg`.
    temp4-category = `Printers`.
    temp4-weightmeasure = '18'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1055`.
    temp4-name = `Multi Print`.
    temp4-quantity = 16.
    temp4-status = `Available`.
    temp4-price = '99'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Printer for All`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg`.
    temp4-category = `Multifunction Printers`.
    temp4-weightmeasure = '6.3'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1056`.
    temp4-name = `Multi Color`.
    temp4-quantity = 5.
    temp4-status = `Available`.
    temp4-price = '119'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Printer for All`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg`.
    temp4-category = `Multifunction Printers`.
    temp4-weightmeasure = '4.3'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1060`.
    temp4-name = `Cordless Mouse`.
    temp4-quantity = 25.
    temp4-status = `Available`.
    temp4-price = '9'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Oxynum`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg`.
    temp4-category = `Mice`.
    temp4-weightmeasure = '0.09'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1061`.
    temp4-name = `Speed Mouse`.
    temp4-quantity = 12.
    temp4-status = `Available`.
    temp4-price = '7'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Oxynum`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg`.
    temp4-category = `Mice`.
    temp4-weightmeasure = '0.09'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1062`.
    temp4-name = `Track Mouse`.
    temp4-quantity = 12.
    temp4-status = `Discontinued`.
    temp4-price = '11'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Oxynum`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg`.
    temp4-category = `Mice`.
    temp4-weightmeasure = '0.03'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1063`.
    temp4-name = `Ergonomic Keyboard`.
    temp4-quantity = 50.
    temp4-status = `Available`.
    temp4-price = '14'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Oxynum`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg`.
    temp4-category = `Keyboards`.
    temp4-weightmeasure = '2.1'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1064`.
    temp4-name = `Internet Keyboard`.
    temp4-quantity = 35.
    temp4-status = `Out of Stock`.
    temp4-price = '16'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Oxynum`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg`.
    temp4-category = `Keyboards`.
    temp4-weightmeasure = '1.8'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1065`.
    temp4-name = `Media Keyboard`.
    temp4-quantity = 26.
    temp4-status = `Available`.
    temp4-price = '26'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Oxynum`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg`.
    temp4-category = `Keyboards`.
    temp4-weightmeasure = '2.3'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1066`.
    temp4-name = `Mousepad`.
    temp4-quantity = 12.
    temp4-status = `Available`.
    temp4-price = '6.99'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Oxynum`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg`.
    temp4-category = `Mousepads`.
    temp4-weightmeasure = '80'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1067`.
    temp4-name = `Ergo Mousepad`.
    temp4-quantity = 16.
    temp4-status = `Out of Stock`.
    temp4-price = '8.99'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Oxynum`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg`.
    temp4-category = `Mousepads`.
    temp4-weightmeasure = '80'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1068`.
    temp4-name = `Designer Mousepad`.
    temp4-quantity = 26.
    temp4-status = `Available`.
    temp4-price = '12.99'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Fasttech`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg`.
    temp4-category = `Mousepads`.
    temp4-weightmeasure = '90'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1069`.
    temp4-name = `Universal card reader`.
    temp4-quantity = 22.
    temp4-status = `Available`.
    temp4-price = '14'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Fasttech`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg`.
    temp4-category = `Computer System Accessories`.
    temp4-weightmeasure = '45'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1070`.
    temp4-name = `Proctra X`.
    temp4-quantity = 15.
    temp4-status = `Out of Stock`.
    temp4-price = '70.9'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg`.
    temp4-category = `Graphic Cards`.
    temp4-weightmeasure = '0.255'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1071`.
    temp4-name = `Gladiator MX`.
    temp4-quantity = 16.
    temp4-status = `Discontinued`.
    temp4-price = '81.7'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg`.
    temp4-category = `Graphic Cards`.
    temp4-weightmeasure = '0.3'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1072`.
    temp4-name = `Hurricane GX`.
    temp4-quantity = 13.
    temp4-status = `Available`.
    temp4-price = '101.2'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg`.
    temp4-category = `Graphic Cards`.
    temp4-weightmeasure = '0.4'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1073`.
    temp4-name = `Hurricane GX/LN`.
    temp4-quantity = 5.
    temp4-status = `Out of Stock`.
    temp4-price = '139.99'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Smartcards`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg`.
    temp4-category = `Graphic Cards`.
    temp4-weightmeasure = '0.4'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1080`.
    temp4-name = `Photo Scan`.
    temp4-quantity = 8.
    temp4-status = `Out of Stock`.
    temp4-price = '129'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Printer for All`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg`.
    temp4-category = `Scanners`.
    temp4-weightmeasure = '2.3'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1081`.
    temp4-name = `Power Scan`.
    temp4-quantity = 11.
    temp4-status = `Out of Stock`.
    temp4-price = '89'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Printer for All`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg`.
    temp4-category = `Scanners`.
    temp4-weightmeasure = '2.4'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1082`.
    temp4-name = `Jet Scan Professional`.
    temp4-quantity = 13.
    temp4-status = `Out of Stock`.
    temp4-price = '169'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Printer for All`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg`.
    temp4-category = `Scanners`.
    temp4-weightmeasure = '3.2'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1083`.
    temp4-name = `Jet Scan Professional`.
    temp4-quantity = 10.
    temp4-status = `Available`.
    temp4-price = '189'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Printer for All`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg`.
    temp4-category = `Scanners`.
    temp4-weightmeasure = '3.2'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1085`.
    temp4-name = `Copymaster`.
    temp4-quantity = 10.
    temp4-status = `Available`.
    temp4-price = '1499'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Alpha Printers`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg`.
    temp4-category = `Multifunction Printers`.
    temp4-weightmeasure = '23.2'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1090`.
    temp4-name = `Surround Sound`.
    temp4-quantity = 20.
    temp4-status = `Available`.
    temp4-price = '39'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Speaker Experts`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg`.
    temp4-category = `Speakers`.
    temp4-weightmeasure = '3'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1091`.
    temp4-name = `Blaster Extreme`.
    temp4-quantity = 15.
    temp4-status = `Available`.
    temp4-price = '26'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Speaker Experts`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg`.
    temp4-category = `Speakers`.
    temp4-weightmeasure = '1.4'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1092`.
    temp4-name = `Sound Booster`.
    temp4-quantity = 50.
    temp4-status = `Discontinued`.
    temp4-price = '45'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Speaker Experts`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg`.
    temp4-category = `Speakers`.
    temp4-weightmeasure = '2.1'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1095`.
    temp4-name = `Lovely Sound 5.1 Wireless`.
    temp4-quantity = 12.
    temp4-status = `Available`.
    temp4-price = '49'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Fasttech`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '80'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1096`.
    temp4-name = `Lovely Sound 5.1`.
    temp4-quantity = 18.
    temp4-status = `Available`.
    temp4-price = '39'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Fasttech`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '130'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1097`.
    temp4-name = `Lovely Sound Stereo`.
    temp4-quantity = 21.
    temp4-status = `Out of Stock`.
    temp4-price = '29'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Fasttech`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '60'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1100`.
    temp4-name = `Smart Office`.
    temp4-quantity = 25.
    temp4-status = `Out of Stock`.
    temp4-price = '89.9'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg`.
    temp4-category = `Software`.
    temp4-weightmeasure = '1.2'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1101`.
    temp4-name = `Smart Design`.
    temp4-quantity = 26.
    temp4-status = `Available`.
    temp4-price = '79.9'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg`.
    temp4-category = `Software`.
    temp4-weightmeasure = '0.8'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1102`.
    temp4-name = `Smart Network`.
    temp4-quantity = 28.
    temp4-status = `Available`.
    temp4-price = '69'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg`.
    temp4-category = `Software`.
    temp4-weightmeasure = '0.8'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1103`.
    temp4-name = `Smart Multimedia`.
    temp4-quantity = 9.
    temp4-status = `Available`.
    temp4-price = '77'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg`.
    temp4-category = `Software`.
    temp4-weightmeasure = '0.8'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1104`.
    temp4-name = `Smart Games`.
    temp4-quantity = 13.
    temp4-status = `Available`.
    temp4-price = '55'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg`.
    temp4-category = `Software`.
    temp4-weightmeasure = '1.1'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1105`.
    temp4-name = `Smart Internet Antivirus`.
    temp4-quantity = 17.
    temp4-status = `Available`.
    temp4-price = '29'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Brainsoft`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg`.
    temp4-category = `Software`.
    temp4-weightmeasure = '0.7'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1106`.
    temp4-name = `Smart Firewall`.
    temp4-quantity = 19.
    temp4-status = `Discontinued`.
    temp4-price = '34'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Brainsoft`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg`.
    temp4-category = `Software`.
    temp4-weightmeasure = '0.9'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1107`.
    temp4-name = `Smart Money`.
    temp4-quantity = 18.
    temp4-status = `Out of Stock`.
    temp4-price = '29.9'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Brainsoft`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg`.
    temp4-category = `Software`.
    temp4-weightmeasure = '0.5'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1110`.
    temp4-name = `PC Lock`.
    temp4-quantity = 14.
    temp4-status = `Available`.
    temp4-price = '8.9'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Red Point Stores`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg`.
    temp4-category = `Computer System Accessories`.
    temp4-weightmeasure = '0.03'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1111`.
    temp4-name = `Notebook Lock`.
    temp4-quantity = 20.
    temp4-status = `Available`.
    temp4-price = '6.9'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Red Point Stores`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg`.
    temp4-category = `Computer System Accessories`.
    temp4-weightmeasure = '0.02'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1112`.
    temp4-name = `Web cam reality`.
    temp4-quantity = 27.
    temp4-status = `Out of Stock`.
    temp4-price = '39'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Red Point Stores`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg`.
    temp4-category = `Computer System Accessories`.
    temp4-weightmeasure = '0.075'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1113`.
    temp4-name = `Screen clean`.
    temp4-quantity = 17.
    temp4-status = `Available`.
    temp4-price = '2.3'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Red Point Stores`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg`.
    temp4-category = `Computer System Accessories`.
    temp4-weightmeasure = '0.05'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1114`.
    temp4-name = `Fabric bag professional`.
    temp4-quantity = 14.
    temp4-status = `Available`.
    temp4-price = '31'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Red Point Stores`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg`.
    temp4-category = `Computer System Accessories`.
    temp4-weightmeasure = '1.8'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1115`.
    temp4-name = `Wireless DSL Router`.
    temp4-quantity = 16.
    temp4-status = `Available`.
    temp4-price = '49'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Red Point Stores`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg`.
    temp4-category = `Telecommunications`.
    temp4-weightmeasure = '0.45'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1116`.
    temp4-name = `Wireless DSL Router / Repeater`.
    temp4-quantity = 12.
    temp4-status = `Out of Stock`.
    temp4-price = '59'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Red Point Stores`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg`.
    temp4-category = `Telecommunications`.
    temp4-weightmeasure = '0.45'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1117`.
    temp4-name = `Wireless DSL Router / Repeater and Print Server`.
    temp4-quantity = 12.
    temp4-status = `Available`.
    temp4-price = '69'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg`.
    temp4-category = `Telecommunications`.
    temp4-weightmeasure = '0.45'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1118`.
    temp4-name = `USB Stick`.
    temp4-quantity = 14.
    temp4-status = `Available`.
    temp4-price = '35'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg`.
    temp4-category = `Computer System Accessories`.
    temp4-weightmeasure = '0.015'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1119`.
    temp4-name = `Travel Adapter`.
    temp4-quantity = 10.
    temp4-status = `Discontinued`.
    temp4-price = '79'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '88'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1120`.
    temp4-name = `Cordless Bluetooth Keyboard, english international`.
    temp4-quantity = 13.
    temp4-status = `Out of Stock`.
    temp4-price = '29'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg`.
    temp4-category = `Keyboards`.
    temp4-weightmeasure = '1'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1137`.
    temp4-name = `Flat XXL`.
    temp4-quantity = 10.
    temp4-status = `Discontinued`.
    temp4-price = '1430'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg`.
    temp4-category = `Flat Screen Monitors`.
    temp4-weightmeasure = '18'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1138`.
    temp4-name = `Pocket Mouse`.
    temp4-quantity = 20.
    temp4-status = `Available`.
    temp4-price = '23'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg`.
    temp4-category = `Mice`.
    temp4-weightmeasure = '0.02'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1210`.
    temp4-name = `PC Power Station`.
    temp4-quantity = 22.
    temp4-status = `Available`.
    temp4-price = '2399'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg`.
    temp4-category = `PCs`.
    temp4-weightmeasure = '2.3'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1251`.
    temp4-name = `Astro Laptop 1516`.
    temp4-quantity = 23.
    temp4-status = `Available`.
    temp4-price = '989'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg`.
    temp4-category = `Laptops`.
    temp4-weightmeasure = '4.2'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1252`.
    temp4-name = `Astro Phone 6`.
    temp4-quantity = 28.
    temp4-status = `Available`.
    temp4-price = '649'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg`.
    temp4-category = `Smartphones and Tablets`.
    temp4-weightmeasure = '0.75'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1253`.
    temp4-name = `Benda Laptop 1408`.
    temp4-quantity = 27.
    temp4-status = `Discontinued`.
    temp4-price = '976'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg`.
    temp4-category = `Laptops`.
    temp4-weightmeasure = '4.2'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1254`.
    temp4-name = `Bending Screen 21HD`.
    temp4-quantity = 23.
    temp4-status = `Available`.
    temp4-price = '250'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg`.
    temp4-category = `Flat Screens`.
    temp4-weightmeasure = '15'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1255`.
    temp4-name = `Broad Screen 22HD`.
    temp4-quantity = 5.
    temp4-status = `Discontinued`.
    temp4-price = '270'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg`.
    temp4-category = `Flat Screens`.
    temp4-weightmeasure = '16'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1256`.
    temp4-name = `Cerdik Phone 7`.
    temp4-quantity = 19.
    temp4-status = `Discontinued`.
    temp4-price = '549'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg`.
    temp4-category = `Smartphones and Tablets`.
    temp4-weightmeasure = '0.75'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1257`.
    temp4-name = `Cepat Tablet 10.5`.
    temp4-quantity = 17.
    temp4-status = `Available`.
    temp4-price = '549'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg`.
    temp4-category = `Smartphones and Tablets`.
    temp4-weightmeasure = '2.8'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1258`.
    temp4-name = `Cepat Tablet 8`.
    temp4-quantity = 24.
    temp4-status = `Available`.
    temp4-price = '529'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg`.
    temp4-category = `Smartphones and Tablets`.
    temp4-weightmeasure = '2.5'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1500`.
    temp4-name = `Server Basic`.
    temp4-quantity = 24.
    temp4-status = `Available`.
    temp4-price = '5000'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg`.
    temp4-category = `Servers`.
    temp4-weightmeasure = '18'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1501`.
    temp4-name = `Server Professional`.
    temp4-quantity = 26.
    temp4-status = `Out of Stock`.
    temp4-price = '15000'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg`.
    temp4-category = `Servers`.
    temp4-weightmeasure = '25'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1502`.
    temp4-name = `Server Power Pro`.
    temp4-quantity = 34.
    temp4-status = `Available`.
    temp4-price = '25000'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg`.
    temp4-category = `Servers`.
    temp4-weightmeasure = '35'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1600`.
    temp4-name = `Family PC Basic`.
    temp4-quantity = 10.
    temp4-status = `Available`.
    temp4-price = '600'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg`.
    temp4-category = `Desktop Computers`.
    temp4-weightmeasure = '4.8'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1601`.
    temp4-name = `Family PC Pro`.
    temp4-quantity = 20.
    temp4-status = `Available`.
    temp4-price = '900'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg`.
    temp4-category = `Desktop Computers`.
    temp4-weightmeasure = '5.3'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1602`.
    temp4-name = `Gaming Monster`.
    temp4-quantity = 24.
    temp4-status = `Available`.
    temp4-price = '1200'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg`.
    temp4-category = `Desktop Computers`.
    temp4-weightmeasure = '5.9'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-1603`.
    temp4-name = `Gaming Monster Pro`.
    temp4-quantity = 25.
    temp4-status = `Discontinued`.
    temp4-price = '1700'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg`.
    temp4-category = `Desktop Computers`.
    temp4-weightmeasure = '6.8'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-2000`.
    temp4-name = `7" Widescreen Portable DVD Player w MP3`.
    temp4-quantity = 20.
    temp4-status = `Available`.
    temp4-price = '249.99'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '0.79'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-2001`.
    temp4-name = `10" Portable DVD player`.
    temp4-quantity = 21.
    temp4-status = `Available`.
    temp4-price = '449.99'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '0.84'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-2002`.
    temp4-name = `Portable DVD Player with 9" LCD Monitor`.
    temp4-quantity = 50.
    temp4-status = `Available`.
    temp4-price = '853.99'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '0.72'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-2025`.
    temp4-name = `CD/DVD case: 264 sleeves`.
    temp4-quantity = 26.
    temp4-status = `Discontinued`.
    temp4-price = '44.99'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '0.65'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-2026`.
    temp4-name = `Audio/Video Cable Kit - 4m`.
    temp4-quantity = 16.
    temp4-status = `Available`.
    temp4-price = '29.99'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '0.2'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-2027`.
    temp4-name = `Removable CD/DVD Laser Labels`.
    temp4-quantity = 25.
    temp4-status = `Discontinued`.
    temp4-price = '8.99'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '0.15'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6100`.
    temp4-name = `Beam Breaker B-1`.
    temp4-quantity = 32.
    temp4-status = `Out of Stock`.
    temp4-price = '469'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '1.7'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6101`.
    temp4-name = `Beam Breaker B-2`.
    temp4-quantity = 18.
    temp4-status = `Available`.
    temp4-price = '679'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '2'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6102`.
    temp4-name = `Beam Breaker B-3`.
    temp4-quantity = 16.
    temp4-status = `Out of Stock`.
    temp4-price = '889'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Technocom`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '2.5'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6110`.
    temp4-name = `Play Movie`.
    temp4-quantity = 15.
    temp4-status = `Available`.
    temp4-price = '130'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Fasttech`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '2.4'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6111`.
    temp4-name = `Record Movie`.
    temp4-quantity = 24.
    temp4-status = `Discontinued`.
    temp4-price = '288'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Fasttech`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '3.1'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6120`.
    temp4-name = `ITelo MusicStick`.
    temp4-quantity = 15.
    temp4-status = `Available`.
    temp4-price = '45'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Fasttech`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '134'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6121`.
    temp4-name = `ITelo Jog-Mate`.
    temp4-quantity = 24.
    temp4-status = `Available`.
    temp4-price = '63'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Fasttech`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '134'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6122`.
    temp4-name = `Power Pro Player 40`.
    temp4-quantity = 23.
    temp4-status = `Available`.
    temp4-price = '167'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Fasttech`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '266'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6123`.
    temp4-name = `Power Pro Player 80`.
    temp4-quantity = 13.
    temp4-status = `Available`.
    temp4-price = '299'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Fasttech`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '267'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6130`.
    temp4-name = `Flat Watch HD32`.
    temp4-quantity = 16.
    temp4-status = `Available`.
    temp4-price = '1459'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Very Best Screens`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg`.
    temp4-category = `Flat Screen TVs`.
    temp4-weightmeasure = '2.6'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6131`.
    temp4-name = `Flat Watch HD37`.
    temp4-quantity = 14.
    temp4-status = `Available`.
    temp4-price = '1199'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Very Best Screens`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg`.
    temp4-category = `Flat Screen TVs`.
    temp4-weightmeasure = '2.2'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-6132`.
    temp4-name = `Flat Watch HD41`.
    temp4-quantity = 13.
    temp4-status = `Discontinued`.
    temp4-price = '899'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Very Best Screens`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg`.
    temp4-category = `Flat Screen TVs`.
    temp4-weightmeasure = '1.8'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-7000`.
    temp4-name = `Copperberry`.
    temp4-quantity = 5.
    temp4-status = `Discontinued`.
    temp4-price = '549'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Fasttech`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '0.5'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-7010`.
    temp4-name = `Silverberry`.
    temp4-quantity = 9.
    temp4-status = `Discontinued`.
    temp4-price = '549'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Fasttech`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '0.5'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-7020`.
    temp4-name = `Goldberry`.
    temp4-quantity = 11.
    temp4-status = `Available`.
    temp4-price = '549'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Fasttech`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '0.5'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-7030`.
    temp4-name = `Platinberry`.
    temp4-quantity = 12.
    temp4-status = `Available`.
    temp4-price = '549'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Fasttech`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '0.5'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-8000`.
    temp4-name = `ITelO FlexTop I4000`.
    temp4-quantity = 11.
    temp4-status = `Available`.
    temp4-price = '799'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg`.
    temp4-category = `Laptops`.
    temp4-weightmeasure = '4'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-8001`.
    temp4-name = `ITelO FlexTop I6300c`.
    temp4-quantity = 20.
    temp4-status = `Discontinued`.
    temp4-price = '799'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg`.
    temp4-category = `Laptops`.
    temp4-weightmeasure = '4.2'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-8002`.
    temp4-name = `ITelO FlexTop I9100`.
    temp4-quantity = 20.
    temp4-status = `Available`.
    temp4-price = '1199'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg`.
    temp4-category = `Laptops`.
    temp4-weightmeasure = '3.5'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-8003`.
    temp4-name = `ITelO FlexTop I9800`.
    temp4-quantity = 22.
    temp4-status = `Available`.
    temp4-price = '1388'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg`.
    temp4-category = `Laptops`.
    temp4-weightmeasure = '3.8'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-9991`.
    temp4-name = `Smartphone Leather Case`.
    temp4-quantity = 12.
    temp4-status = `Available`.
    temp4-price = '25'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '0.02'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-9992`.
    temp4-name = `Smartphone Alpha`.
    temp4-quantity = 13.
    temp4-status = `Out of Stock`.
    temp4-price = '599'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg`.
    temp4-category = `Smartphones and Tablets`.
    temp4-weightmeasure = '0.75'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-9993`.
    temp4-name = `Mini Tablet`.
    temp4-quantity = 10.
    temp4-status = `Available`.
    temp4-price = '833'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg`.
    temp4-category = `Smartphones and Tablets`.
    temp4-weightmeasure = '3.8'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-9994`.
    temp4-name = `Camcorder View`.
    temp4-quantity = 50.
    temp4-status = `Out of Stock`.
    temp4-price = '1388'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Ultrasonic United`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '3.8'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-9995`.
    temp4-name = `Tablet Pouch`.
    temp4-quantity = 34.
    temp4-status = `Available`.
    temp4-price = '20'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '0.03'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-9996`.
    temp4-name = `Tablet Pouch`.
    temp4-quantity = 34.
    temp4-status = `Available`.
    temp4-price = '20'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '0.03'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-9997`.
    temp4-name = `e-Book Reader ReadMe`.
    temp4-quantity = 23.
    temp4-status = `Available`.
    temp4-price = '33'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg`.
    temp4-category = `Smartphones and Tablets`.
    temp4-weightmeasure = '3.8'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-9998`.
    temp4-name = `Smartphone Beta`.
    temp4-quantity = 21.
    temp4-status = `Available`.
    temp4-price = '30'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg`.
    temp4-category = `Smartphones and Tablets`.
    temp4-weightmeasure = '0.75'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `HT-9999`.
    temp4-name = `Maxi Tablet`.
    temp4-quantity = 20.
    temp4-status = `Available`.
    temp4-price = '749'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg`.
    temp4-category = `Tablets`.
    temp4-weightmeasure = '3.8'.
    INSERT temp4 INTO TABLE temp3.
    temp4-productid = `PF-1000`.
    temp4-name = `Flyer`.
    temp4-quantity = 33.
    temp4-status = `Out of Stock`.
    temp4-price = '0'.
    temp4-currencycode = `EUR`.
    temp4-suppliername = `Titanium`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg`.
    temp4-category = `Accessories`.
    temp4-weightmeasure = '0.01'.
    INSERT temp4 INTO TABLE temp3.
    productcollection = temp3.

    " initSampleDataModel derives four things per row and two arrays from them
    
    
    LOOP AT productcollection REFERENCE INTO product.
      " Date.now() - (i % 10 * 4 days): a moving value, so it is anchored on a
      " FIXED base here (the corpus rule for now/random values, apps 164/181/289)
      " the arithmetic has to land in a TYPE d field before it is formatted: a
      " date operand inside an expression is converted to its DAY NUMBER, so
      " CONV string( CONV d( ... ) - n ) yields 739618, not 20260101, and the
      " offsets then cut that into '7.39-61-80'. Measured 2026-08-21 - every
      " row carried a nonsense date the DatePicker's yyyy-MM-dd binding could
      " not parse, and nothing failed loudly enough for a gate to see it.
      
      
      temp1 = `20260101`.
      temp6 = temp1 - ( ( sy-tabix - 1 ) MOD 10 ) * 4.
      
      delivery = temp6.
      product->deliverydate   = |{ delivery(4) }-{ delivery+4(2) }-{ delivery+6(2) }|.
      
      temp2 = boolc( product->status = `Available` ).
      product->available      = temp2.
      
      IF product->available = abap_true.
        temp7 = `Success`.
      ELSE.
        temp7 = `Error`.
      ENDIF.
      product->availablestate = temp7.
      
      IF product->available = abap_true.
        temp8 = `sap-icon://accept`.
      ELSE.
        temp8 = `sap-icon://decline`.
      ENDIF.
      product->availableicon  = temp8.
      
      IF product->weightmeasure > 1000.
        temp9 = `true`.
      ELSE.
        temp9 = `false`.
      ENDIF.
      product->heavy          = temp9.

      
      READ TABLE suppliers WITH KEY name = product->suppliername TRANSPORTING NO FIELDS.
      temp10 = sy-subrc.
      IF product->suppliername IS NOT INITIAL AND NOT temp10 = 0.
        
        CLEAR temp11.
        temp11-name = product->suppliername.
        INSERT temp11 INTO TABLE suppliers.
      ENDIF.
      
      READ TABLE categories WITH KEY name = product->category TRANSPORTING NO FIELDS.
      temp12 = sy-subrc.
      IF product->category IS NOT INITIAL AND NOT temp12 = 0.
        
        CLEAR temp13.
        temp13-name = product->category.
        INSERT temp13 INTO TABLE categories.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
