" @keywords flexiblecolumnlayout flexible column layout sap.f shellbarwithflexiblecolumnlayout shellbar menu menuitem avatar dynamicpage dynamicpagetitle
" @summary Example of Shell Bar in combination with Flexible Column Layout.
CLASS z2ui5_cl_smpc_app_584 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             productid     TYPE string,
             name          TYPE string,
             maincategory  TYPE string,
             category      TYPE string,
             suppliername  TYPE string,
             productpicurl TYPE string,
             description   TYPE string,
             price         TYPE p LENGTH 9 DECIMALS 2,
             currencycode  TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.
    TYPES: BEGIN OF ty_s_supplier,
             text TYPE string,
           END OF ty_s_supplier.
    TYPES ty_t_supplier TYPE STANDARD TABLE OF ty_s_supplier WITH EMPTY KEY.

    DATA t_products  TYPE ty_t_product.
    DATA t_rows      TYPE ty_t_product.
    DATA t_suppliers TYPE ty_t_supplier.

    " the FlexibleColumnLayout state the router drives in the original
    DATA layout      TYPE string VALUE `OneColumn`.
    DATA total_count TYPE i.
    DATA descending  TYPE abap_bool.

    " the product the mid column shows and the supplier the end column shows
    DATA d_name          TYPE string.
    DATA d_productid     TYPE string.
    DATA d_maincategory  TYPE string.
    DATA d_category      TYPE string.
    DATA d_suppliername  TYPE string.
    DATA d_productpicurl TYPE string.
    DATA d_description   TYPE string.
    DATA d_price         TYPE string.
    DATA dd_text         TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS detail_bind IMPORTING productid TYPE string.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_584 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      t_rows = t_products.
      total_count = lines( t_products ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    DATA(page) = view->ele( n = `View` ns = `mvc`
        )->a( n = `height`      v = `100%`
        )->a( n = `xmlns`       v = `sap.m`
        )->a( n = `xmlns:f`     v = `sap.f`
        )->a( n = `xmlns:form`  v = `sap.ui.layout.form`
        )->a( n = `xmlns:mvc`   v = `sap.ui.core.mvc`
        )->a( n = `xmlns:uxap`  v = `sap.uxap`

        )->ele( `Page` ).

    " the ShellBar is the page's custom header; its back button only shows while
    " the end column is full screen, which is a pure expression over the layout
    page->ele( `customHeader`
        )->ele( n = `ShellBar` ns = `f`
            )->a( n = `title`               v = `Application Title`
            )->a( n = `secondTitle`         v = `Short description`
            )->a( n = `homeIcon`            v = `https://sdk.openui5.org/resources/sap/ui/documentation/sdk/images/logo_sap.png`
            )->a( n = `showCopilot`         v = `true`
            )->a( n = `showSearch`          v = `true`
            )->a( n = `showNotifications`   v = `true`
            )->a( n = `notificationsNumber` v = `2`
            )->a( n = `showNavButton`       v = |\{= ${ client->_bind( layout ) } === 'EndColumnFullScreen' \}|
            )->a( n = `navButtonPressed`    v = client->_event( `SHELL_BACK` )

            )->ele( n = `menu` ns = `f`
                )->ele( `Menu`
                    )->tag( `MenuItem`
                        )->a( n = `text` v = `Flight booking`
                        )->a( n = `icon` v = `sap-icon://flight`
                    )->tag( `MenuItem`
                        )->a( n = `text` v = `Car rental`
                        )->a( n = `icon` v = `sap-icon://car-rental`

                )->end(
            )->end(
            )->ele( n = `profile` ns = `f`
                )->tag( `Avatar`
                    )->a( n = `initials` v = `UI`

            )->end(
        )->end(
    )->end( ).

    DATA(fcl) = page->ele( n = `FlexibleColumnLayout` ns = `f`
        )->a( n = `id`               v = `fcl`
        )->a( n = `backgroundDesign` v = `Solid`
        )->a( n = `layout`           v = client->_bind( layout ) ).

    " List.view.xml
    fcl->ele( n = `beginColumnPages` ns = `f`
        )->ele( n = `DynamicPage` ns = `f`
            )->a( n = `id`                       v = `dynamicPageId`
            )->a( n = `toggleHeaderOnTitleClick` v = `false`

            )->ele( n = `title` ns = `f`
                )->ele( n = `DynamicPageTitle` ns = `f`
                    )->ele( n = `heading` ns = `f`
                        )->tag( `Title`
                            )->a( n = `text` v = |Products (\{{ client->_bind( val = total_count path = abap_true ) }\})|

                    )->end(
                )->end(
            )->end(
            )->ele( n = `content` ns = `f`
                )->ele( `Table`
                    )->a( n = `id`    v = `productsTable`
                    )->a( n = `mode`  v = `SingleSelectMaster`
                    )->a( n = `inset` v = `false`
                    )->a( n = `class` v = `sapFDynamicPageAlignContent`
                    )->a( n = `width` v = `auto`
                    )->a( n = `items` v = client->_bind( t_rows )
                    )->a( n = `itemPress` v = client->_event( val   = `LIST_ITEM`
                                                              t_arg = VALUE #( ( `${$parameters>/listItem}.getBindingContext().getProperty('PRODUCTID')` ) ) )

                    )->ele( `headerToolbar`
                        )->ele( `OverflowToolbar`
                            )->tag( `ToolbarSpacer`
                            )->tag( `SearchField`
                                )->a( n = `width`  v = `17.5rem`
                                )->a( n = `search` v = client->_event( val   = `SEARCH`
                                                                       t_arg = VALUE #( ( `${$parameters>/query}` ) ) )
                            )->tag( `OverflowToolbarButton`
                                )->a( n = `icon`    v = `sap-icon://add`
                                )->a( n = `type`    v = `Transparent`
                                )->a( n = `tooltip` v = `Add`
                                )->a( n = `press`   v = client->_event( `ADD` )
                            )->tag( `OverflowToolbarButton`
                                )->a( n = `icon`    v = `sap-icon://sort`
                                )->a( n = `type`    v = `Transparent`
                                )->a( n = `tooltip` v = `Sort`
                                )->a( n = `press`   v = client->_event( `SORT` )

                        )->end(
                    )->end(
                    )->ele( `columns`
                        )->ele( `Column`
                            )->a( n = `width` v = `12em`

                            )->tag( `Text`
                                )->a( n = `text` v = `Product`

                        )->end(
                        )->ele( `Column`
                            )->a( n = `hAlign` v = `End`

                            )->tag( `Text`
                                )->a( n = `text` v = `Price`

                        )->end(
                    )->end(
                    )->ele( `items`
                        )->ele( `ColumnListItem`
                            )->a( n = `type` v = `Navigation`

                            )->ele( `cells`
                                )->tag( `ObjectIdentifier`
                                    )->a( n = `title` v = `{NAME}`
                                    )->a( n = `text`  v = `{PRODUCTID}`
                                )->tag( `ObjectNumber`
                                    )->a( n = `number` v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCYCODE'\}], type:'sap.ui.model.type.Currency', formatOptions:\{showMeasure:false\} \}|
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

    " Detail.view.xml - the ObjectPage of the mid column
    DATA(detail) = fcl->ele( n = `midColumnPages` ns = `f`
        )->ele( n = `ObjectPageLayout` ns = `uxap`
            )->a( n = `id`                          v = `ObjectPageLayout`
            )->a( n = `showTitleInHeaderContent`    v = `true`
            )->a( n = `alwaysShowContentHeader`     v = `false`
            )->a( n = `preserveHeaderStateOnScroll` v = `false`
            )->a( n = `headerContentPinnable`       v = `true`
            )->a( n = `isChildPage`                 v = `true`
            )->a( n = `upperCaseAnchorBar`          v = `false` ).

    DATA(detail_title) = detail->ele( n = `headerTitle` ns = `uxap`
        )->ele( n = `ObjectPageDynamicHeaderTitle` ns = `uxap` ).

    detail_title->ele( n = `expandedHeading` ns = `uxap`
        )->tag( `Title`
            )->a( n = `text`     v = client->_bind( d_name )
            )->a( n = `wrapping` v = `true`
            )->a( n = `class`    v = `sapUiSmallMarginEnd`

    )->end(
        )->ele( n = `snappedHeading` ns = `uxap`
            )->ele( `HBox`
                )->a( n = `wrap`       v = `NoWrap`
                )->a( n = `alignItems` v = `Center`
                )->a( n = `class`      v = `sapUiTinyMarginEnd`

                )->tag( `Avatar`
                    )->a( n = `src`          v = client->_bind( d_productpicurl )
                    )->a( n = `displaySize`  v = `S`
                    )->a( n = `displayShape` v = `Square`
                    )->a( n = `class`        v = `sapUiTinyMarginEnd`
                )->ele( `VBox`
                    )->a( n = `wrap` v = `Wrap`

                    )->tag( `Title`
                        )->a( n = `text`     v = client->_bind( d_name )
                        )->a( n = `wrapping` v = `true`
                    )->tag( `Label`
                        )->a( n = `text`     v = client->_bind( d_productid )
                        )->a( n = `wrapping` v = `true`

                )->end(
            )->end(
        )->end(
        )->ele( n = `navigationActions` ns = `uxap`
            )->tag( `OverflowToolbarButton`
                )->a( n = `id`      v = `enterFullScreenBtn`
                )->a( n = `type`    v = `Transparent`
                )->a( n = `icon`    v = `sap-icon://full-screen`
                )->a( n = `tooltip` v = `Enter Full Screen Mode`
                )->a( n = `visible` v = |\{= ${ client->_bind( layout ) } !== 'MidColumnFullScreen' \}|
                )->a( n = `press`   v = client->_event( `MID_FULL_SCREEN` )
            )->tag( `OverflowToolbarButton`
                )->a( n = `id`      v = `exitFullScreenBtn`
                )->a( n = `type`    v = `Transparent`
                )->a( n = `icon`    v = `sap-icon://exit-full-screen`
                )->a( n = `tooltip` v = `Exit Full Screen Mode`
                )->a( n = `visible` v = |\{= ${ client->_bind( layout ) } === 'MidColumnFullScreen' \}|
                )->a( n = `press`   v = client->_event( `MID_EXIT_FULL_SCREEN` )
            )->tag( `OverflowToolbarButton`
                )->a( n = `type`    v = `Transparent`
                )->a( n = `icon`    v = `sap-icon://decline`
                )->a( n = `tooltip` v = `Close middle column`
                )->a( n = `visible` v = |\{= ${ client->_bind( layout ) } !== 'OneColumn' \}|
                )->a( n = `press`   v = client->_event( `MID_CLOSE` )

        )->end(
        )->ele( n = `actions` ns = `uxap`
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
                )->a( n = `text` v = `Toggle Footer`
                )->a( n = `type` v = `Transparent`
            )->tag( `Button`
                )->a( n = `icon`    v = `sap-icon://action`
                )->a( n = `tooltip` v = `Share`
                )->a( n = `type`    v = `Transparent`

        )->end(
    )->end( ).

    detail->ele( n = `headerContent` ns = `uxap`
        )->ele( `FlexBox`
            )->a( n = `wrap`         v = `Wrap`
            )->a( n = `fitContainer` v = `true`
            )->a( n = `alignItems`   v = `Stretch`

            )->tag( `Avatar`
                )->a( n = `src`          v = client->_bind( d_productpicurl )
                )->a( n = `displaySize`  v = `L`
                )->a( n = `displayShape` v = `Square`
                )->a( n = `class`        v = `sapUiTinyMarginEnd`
            )->ele( `VBox`
                )->a( n = `justifyContent` v = `Center`
                )->a( n = `class`          v = `sapUiSmallMarginEnd`

                )->tag( `Label`
                    )->a( n = `text` v = `Main Category`
                )->tag( `Text`
                    )->a( n = `text` v = client->_bind( d_maincategory )

            )->end(
            )->ele( `VBox`
                )->a( n = `justifyContent` v = `Center`
                )->a( n = `class`          v = `sapUiSmallMarginEnd`

                )->tag( `Label`
                    )->a( n = `text` v = `Subcategory`
                )->tag( `Text`
                    )->a( n = `text` v = client->_bind( d_category )

            )->end(
            )->ele( `VBox`
                )->a( n = `justifyContent` v = `Center`
                )->a( n = `class`          v = `sapUiSmallMarginEnd`

                )->tag( `Label`
                    )->a( n = `text` v = `Price`
                )->tag( `ObjectNumber`
                    )->a( n = `number`     v = client->_bind( d_price )
                    )->a( n = `emphasized` v = `false`

            )->end(
        )->end(
    )->end( ).

    DATA(sections) = detail->ele( n = `sections` ns = `uxap` ).

    sections->ele( n = `ObjectPageSection` ns = `uxap`
        )->a( n = `title` v = `General Information`

        )->ele( n = `subSections` ns = `uxap`
            )->ele( n = `ObjectPageSubSection` ns = `uxap`

                )->ele( n = `blocks` ns = `uxap`
                    )->ele( n = `SimpleForm` ns = `form`
                        )->a( n = `maxContainerCols` v = `2`
                        )->a( n = `editable`         v = `false`
                        )->a( n = `layout`           v = `ResponsiveGridLayout`
                        )->a( n = `labelSpanL`       v = `12`
                        )->a( n = `labelSpanM`       v = `12`
                        )->a( n = `emptySpanL`       v = `0`
                        )->a( n = `emptySpanM`       v = `0`
                        )->a( n = `columnsL`         v = `1`
                        )->a( n = `columnsM`         v = `1`

                        )->ele( n = `content` ns = `form`
                            )->tag( `Label`
                                )->a( n = `text` v = `Product ID`
                            )->tag( `Text`
                                )->a( n = `text` v = client->_bind( d_productid )
                            )->tag( `Label`
                                )->a( n = `text` v = `Description`
                            )->tag( `Text`
                                )->a( n = `text` v = client->_bind( d_description )
                            )->tag( `Label`
                                )->a( n = `text` v = `Supplier`
                            )->tag( `Text`
                                )->a( n = `text` v = client->_bind( d_suppliername )

                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end(
    )->end( ).

    sections->ele( n = `ObjectPageSection` ns = `uxap`
        )->a( n = `title` v = `Suppliers`

        )->ele( n = `subSections` ns = `uxap`
            )->ele( n = `ObjectPageSubSection` ns = `uxap`

                )->ele( n = `blocks` ns = `uxap`
                    )->ele( `Table`
                        )->a( n = `id`    v = `suppliersTable`
                        )->a( n = `mode`  v = `SingleSelectMaster`
                        )->a( n = `items` v = client->_bind( t_suppliers )
                        )->a( n = `itemPress` v = client->_event( val   = `SUPPLIER_ITEM`
                                                                  t_arg = VALUE #( ( `${$parameters>/listItem}.getBindingContext().getProperty('TEXT')` ) ) )

                        )->ele( `columns`
                            )->tag( `Column`

                        )->end(
                        )->ele( `items`
                            )->ele( `ColumnListItem`
                                )->a( n = `type` v = `Navigation`

                                )->ele( `cells`
                                    )->tag( `ObjectIdentifier`
                                        )->a( n = `text` v = `{TEXT}`

                                )->end(
                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end(
    )->end( ).

    " DetailDetail.view.xml and AboutPage.view.xml - the end column
    DATA(end_column) = fcl->ele( n = `endColumnPages` ns = `f` ).

    end_column->ele( n = `DynamicPage` ns = `f`
        )->a( n = `toggleHeaderOnTitleClick` v = `false`

        )->ele( n = `title` ns = `f`
            )->ele( n = `DynamicPageTitle` ns = `f`

                )->ele( n = `heading` ns = `f`
                    )->ele( `FlexBox`
                        )->a( n = `wrap`         v = `Wrap`
                        )->a( n = `fitContainer` v = `true`
                        )->a( n = `alignItems`   v = `Center`

                        )->tag( `Title`
                            )->a( n = `text`     v = client->_bind( dd_text )
                            )->a( n = `wrapping` v = `true`
                            )->a( n = `class`    v = `sapUiTinyMarginEnd`

                    )->end(
                )->end(
                )->ele( n = `navigationActions` ns = `f`
                    )->tag( `OverflowToolbarButton`
                        )->a( n = `type`    v = `Transparent`
                        )->a( n = `icon`    v = `sap-icon://full-screen`
                        )->a( n = `tooltip` v = `Enter Full Screen Mode`
                        )->a( n = `visible` v = |\{= ${ client->_bind( layout ) } !== 'EndColumnFullScreen' \}|
                        )->a( n = `press`   v = client->_event( `END_FULL_SCREEN` )
                    )->tag( `OverflowToolbarButton`
                        )->a( n = `type`    v = `Transparent`
                        )->a( n = `icon`    v = `sap-icon://exit-full-screen`
                        )->a( n = `tooltip` v = `Exit Full Screen Mode`
                        )->a( n = `visible` v = |\{= ${ client->_bind( layout ) } === 'EndColumnFullScreen' \}|
                        )->a( n = `press`   v = client->_event( `END_EXIT_FULL_SCREEN` )
                    )->tag( `OverflowToolbarButton`
                        )->a( n = `type`    v = `Transparent`
                        )->a( n = `icon`    v = `sap-icon://decline`
                        )->a( n = `tooltip` v = `Close end column`
                        )->a( n = `press`   v = client->_event( `END_CLOSE` )

                )->end(
            )->end(
        )->end(
        )->ele( n = `content` ns = `f`
            )->tag( `Link`
                )->a( n = `text`  v = `Navigate to next page…`
                )->a( n = `press` v = client->_event( `ABOUT` )

        )->end(
    )->end( ).

    end_column->ele( n = `DynamicPage` ns = `f`
        )->a( n = `toggleHeaderOnTitleClick` v = `false`

        )->ele( n = `title` ns = `f`
            )->ele( n = `DynamicPageTitle` ns = `f`
                )->ele( n = `heading` ns = `f`
                    )->tag( `Title`
                        )->a( n = `text` v = `About supplier`

                )->end(
            )->end(
        )->end(
    )->end( ).

    client->view_display( view->stringify( ) ).
    " Component.js: oProductsModel.setSizeLimit(1000) - the collection is 123 rows
    " and the JSONModel caps a bound aggregation at 100, so the table would stop 23
    " rows short of the count its own title reports
    client->follow_up_action( val   = client->cs_event-set_size_limit
                              t_arg = VALUE #( ( `1000` ) ( `MAIN` ) ) ).

  ENDMETHOD.


  METHOD detail_bind.

    " Detail.controller's bindElement( '/ProductCollection/<n>' ) - the relative
    " bindings of the original resolve against the bound element, the port folds
    " them to root-seeded fields (app 229 idiom)
    ASSIGN t_products[ productid = productid ] TO FIELD-SYMBOL(<product>).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    d_name          = <product>-name.
    d_productid     = <product>-productid.
    d_maincategory  = <product>-maincategory.
    d_category      = <product>-category.
    d_suppliername  = <product>-suppliername.
    d_productpicurl = <product>-productpicurl.
    d_description   = <product>-description.
    d_price         = |{ <product>-currencycode } { <product>-price }|.

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `LIST_ITEM`.
        " onListItemPress: the helper's next state for level 1 opens the mid column
        detail_bind( client->get_event_arg( ) ).
        layout = `TwoColumnsMidExpanded`.

      WHEN `SUPPLIER_ITEM`.
        " handleItemPress: level 2 opens the end column
        dd_text = client->get_event_arg( ).
        layout = `ThreeColumnsMidExpanded`.

      WHEN `ABOUT`.
        " handleAboutPress: level 3 is the about page, full screen in the end column
        layout = `EndColumnFullScreen`.

      WHEN `SHELL_BACK`.
        " handleBackButtonPressed: the ShellBar's nav button leaves the
        " full-screen about page
        layout = `ThreeColumnsMidExpanded`.

      WHEN `MID_FULL_SCREEN`.
        layout = `MidColumnFullScreen`.

      WHEN `MID_EXIT_FULL_SCREEN`.
        layout = `TwoColumnsMidExpanded`.

      WHEN `MID_CLOSE`.
        layout = `OneColumn`.

      WHEN `END_FULL_SCREEN`.
        layout = `EndColumnFullScreen`.

      WHEN `END_EXIT_FULL_SCREEN`.
        layout = `ThreeColumnsMidExpanded`.

      WHEN `END_CLOSE`.
        layout = `TwoColumnsMidExpanded`.

      WHEN `SEARCH`.
        " onSearch filters the table's items on Name
        DATA(query) = to_upper( client->get_event_arg( ) ).
        IF query IS INITIAL.
          t_rows = t_products.
        ELSE.
          CLEAR t_rows.
          LOOP AT t_products INTO DATA(product).
            IF to_upper( product-name ) CS query.
              APPEND product TO t_rows.
            ENDIF.
          ENDLOOP.
        ENDIF.
        view_display( ).

      WHEN `SORT`.
        " onSort flips the Name sorter; a thin frontend sorts the data it sends
        descending = xsdbool( descending = abap_false ).
        IF descending = abap_true.
          SORT t_rows BY name DESCENDING.
        ELSE.
          SORT t_rows BY name ASCENDING.
        ENDIF.
        view_display( ).

      WHEN `ADD`.
        " onAdd: MessageBox.show( 'This functionality is not ready yet.' )
        client->message_box_display( text  = `This functionality is not ready yet.`
                                     type  = `information`
                                     title = `Aw, Snap!` ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " the full mock /ProductCollection, in the mock order - the items binding
    " keeps its own sorter on NAME
    t_products = VALUE #(
      ( productid = `HT-1000` name = `Notebook Basic 15`
        maincategory = `Computer Systems` category = `Laptops` suppliername = `Very Best Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`
        description = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro` price = `956` currencycode = `EUR` )
      ( productid = `HT-1001` name = `Notebook Basic 17`
        maincategory = `Computer Systems` category = `Laptops` suppliername = `Very Best Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg`
        description = `Notebook Basic 17 with 2,80 GHz quad core, 17" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro` price = `1249` currencycode = `EUR` )
      ( productid = `HT-1002` name = `Notebook Basic 18`
        maincategory = `Computer Systems` category = `Laptops` suppliername = `Very Best Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg`
        description = `Notebook Basic 18 with 2,80 GHz quad core, 18" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro` price = `1570` currencycode = `EUR` )
      ( productid = `HT-1003` name = `Notebook Basic 19`
        maincategory = `Computer Systems` category = `Laptops` suppliername = `Smartcards` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg`
        description = `Notebook Basic 19 with 2,80 GHz quad core, 19" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro` price = `1650` currencycode = `EUR` )
      ( productid = `HT-1007` name = `ITelO Vault`
        maincategory = `Computer Components` category = `Accessories` suppliername = `Technocom` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg`
        description = `Digital Organizer with State-of-the-Art Storage Encryption` price = `299` currencycode = `EUR` )
      ( productid = `HT-1010` name = `Notebook Professional 15`
        maincategory = `Computer Systems` category = `Accessories` suppliername = `Very Best Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg`
        description = `Notebook Professional 15 with 2,80 GHz quad core, 15" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro` price = `1999` currencycode = `EUR` )
      ( productid = `HT-1011` name = `Notebook Professional 17`
        maincategory = `Computer Systems` category = `Laptops` suppliername = `Very Best Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg`
        description = `Notebook Professional 17 with 2,80 GHz quad core, 17" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro` price = `2299` currencycode = `EUR` )
      ( productid = `HT-1020` name = `ITelO Vault Net`
        maincategory = `Computer Components` category = `Accessories` suppliername = `Technocom` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg`
        description = `Digital Organizer with State-of-the-Art Encryption for Storage and Network Communications` price = `459` currencycode = `EUR` )
      ( productid = `HT-1021` name = `ITelO Vault SAT`
        maincategory = `Computer Components` category = `Accessories` suppliername = `Technocom` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg`
        description = `Digital Organizer with State-of-the-Art Encryption for Storage and Secure Stellite Link` price = `149` currencycode = `EUR` )
      ( productid = `HT-1022` name = `Comfort Easy`
        maincategory = `Computer Components` category = `Accessories` suppliername = `Technocom` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg`
        description = `32 GB Digital Assistant with high-resolution color screen` price = `1679` currencycode = `EUR` )
      ( productid = `HT-1023` name = `Comfort Senior`
        maincategory = `Computer Components` category = `Accessories` suppliername = `Technocom` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg`
        description = `64 GB Digital Assistant with high-resolution color screen and synthesized voice output` price = `512` currencycode = `EUR` )
      ( productid = `HT-1030` name = `Ergo Screen E-I`
        maincategory = `Computer Components` category = `Flat Screen Monitors` suppliername = `Very Best Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg`
        description = `Optimum Hi-Resolution max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm` price = `230` currencycode = `EUR` )
      ( productid = `HT-1031` name = `Ergo Screen E-II`
        maincategory = `Computer Components` category = `Flat Screen Monitors` suppliername = `Very Best Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg`
        description = `Optimum Hi-Resolution max. 1920 x 1200 @ 85Hz, Dot Pitch: 0.26mm` price = `285` currencycode = `EUR` )
      ( productid = `HT-1032` name = `Ergo Screen E-III`
        maincategory = `Computer Components` category = `Flat Screen Monitors` suppliername = `Very Best Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg`
        description = `Optimum Hi-Resolution max. 2560 x 1440 @ 85Hz, Dot Pitch: 0.25mm` price = `345` currencycode = `EUR` )
      ( productid = `HT-1035` name = `Flat Basic`
        maincategory = `Computer Components` category = `Flat Screen Monitors` suppliername = `Very Best Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg`
        description = `Optimum Hi-Resolution max. 1600 x 1200 @ 85Hz, Dot Pitch: 0.24mm` price = `399` currencycode = `EUR` )
      ( productid = `HT-1036` name = `Flat Future`
        maincategory = `Computer Components` category = `Flat Screen Monitors` suppliername = `Very Best Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg`
        description = `Optimum Hi-Resolution max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.26mm` price = `430` currencycode = `EUR` )
      ( productid = `HT-1037` name = `Flat XL`
        maincategory = `Computer Components` category = `Flat Screen Monitors` suppliername = `Very Best Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg`
        description = `Optimum Hi-Resolution max. 2016 x 1512 @ 85Hz, Dot Pitch: 0.24mm` price = `1230` currencycode = `EUR` )
      ( productid = `HT-1040` name = `Laser Professional Eco`
        maincategory = `Printers & Scanners` category = `Printers` suppliername = `Alpha Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg`
        description = `Print 2400 dpi image quality color documents at speeds of up to 32 ppm (color) or 36 ppm (monochrome), letter/A4. Powerful 500 MHz processor, 512MB of memory` price = `830` currencycode = `EUR` )
      ( productid = `HT-1041` name = `Laser Basic`
        maincategory = `Printers & Scanners` category = `Printers` suppliername = `Alpha Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg`
        description = `Up to 22 ppm color or 24 ppm monochrome A4/letter, powerful 500 MHz processor and 128MB of memory` price = `490` currencycode = `EUR` )
      ( productid = `HT-1042` name = `Laser Allround`
        maincategory = `Printers & Scanners` category = `Printers` suppliername = `Alpha Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg`
        description = `Print up to 25 ppm letter and 24 ppm A4 color or monochrome, with Available first-page-out-time of less than 13 seconds for monochrome and less than 15 seconds for color` price = `349` currencycode = `EUR` )
      ( productid = `HT-1050` name = `Ultra Jet Super Color`
        maincategory = `Printers & Scanners` category = `Printers` suppliername = `Alpha Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg`
        description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB, Ethernet` price = `139` currencycode = `EUR` )
      ( productid = `HT-1051` name = `Ultra Jet Mobile`
        maincategory = `Printers & Scanners` category = `Printers` suppliername = `Printer for All` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg`
        description = `1000 dpi x 1000 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB - excellent dimensions for the small office` price = `99` currencycode = `EUR` )
      ( productid = `HT-1052` name = `Ultra Jet Super Highspeed`
        maincategory = `Printers & Scanners` category = `Printers` suppliername = `Printer for All` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg`
        description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB2.0, Ethernet` price = `170` currencycode = `EUR` )
      ( productid = `HT-1055` name = `Multi Print`
        maincategory = `Printers & Scanners` category = `Multifunction Printers` suppliername = `Printer for All` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg`
        description = `1000 dpi x 1000 dpi - up to 16 ppm (mono) / up to 15 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 1200dpi x 2400dpi)` price = `99` currencycode = `EUR` )
      ( productid = `HT-1056` name = `Multi Color`
        maincategory = `Printers & Scanners` category = `Multifunction Printers` suppliername = `Printer for All` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg`
        description = `1200 dpi x 1200 dpi - up to 25 ppm (mono) / up to 24 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 2400dpi x 4800dpi, high resolution)` price = `119` currencycode = `EUR` )
      ( productid = `HT-1060` name = `Cordless Mouse`
        maincategory = `Computer Components` category = `Mice` suppliername = `Oxynum` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg`
        description = `Cordless Optical USB Mice, Laptop, Color: Black, Plug&Play` price = `9` currencycode = `EUR` )
      ( productid = `HT-1061` name = `Speed Mouse`
        maincategory = `Computer Components` category = `Mice` suppliername = `Oxynum` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg`
        description = `Optical USB, PS/2 Mouse, Color: Blue, 3-button-functionality (incl. Scroll wheel)` price = `7` currencycode = `EUR` )
      ( productid = `HT-1062` name = `Track Mouse`
        maincategory = `Computer Components` category = `Mice` suppliername = `Oxynum` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg`
        description = `Optical USB Mouse, Color: Red, 5-button-functionality(incl. Scroll wheel), Plug&Play` price = `11` currencycode = `EUR` )
      ( productid = `HT-1063` name = `Ergonomic Keyboard`
        maincategory = `Computer Components` category = `Keyboards` suppliername = `Oxynum` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg`
        description = `Ergonomic USB Keyboard for Desktop, Plug&Play` price = `14` currencycode = `EUR` )
      ( productid = `HT-1064` name = `Internet Keyboard`
        maincategory = `Computer Components` category = `Keyboards` suppliername = `Oxynum` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg`
        description = `Corded Keyboard with special keys for Internet Usability, USB` price = `16` currencycode = `EUR` )
      ( productid = `HT-1065` name = `Media Keyboard`
        maincategory = `Computer Components` category = `Keyboards` suppliername = `Oxynum` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg`
        description = `Corded Ergonomic Keyboard with special keys for Media Usability, USB` price = `26` currencycode = `EUR` )
      ( productid = `HT-1066` name = `Mousepad`
        maincategory = `Computer Components` category = `Mousepads` suppliername = `Oxynum` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg`
        description = `Nice mouse pad with ITelO Logo` price = `6.99` currencycode = `EUR` )
      ( productid = `HT-1067` name = `Ergo Mousepad`
        maincategory = `Computer Components` category = `Mousepads` suppliername = `Oxynum` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg`
        description = `Ergonomic mouse pad with ITelO Logo` price = `8.99` currencycode = `EUR` )
      ( productid = `HT-1068` name = `Designer Mousepad`
        maincategory = `Computer Components` category = `Mousepads` suppliername = `Fasttech` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg`
        description = `ITelO Mousepad Special Edition` price = `12.99` currencycode = `EUR` )
      ( productid = `HT-1069` name = `Universal card reader`
        maincategory = `Computer Systems` category = `Computer System Accessories` suppliername = `Fasttech` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg`
        description = `Universal card reader` price = `14` currencycode = `EUR` )
      ( productid = `HT-1070` name = `Proctra X`
        maincategory = `Computer Components` category = `Graphic Cards` suppliername = `Ultrasonic United` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg`
        description = `Proctra X: PCI-E GDDR5 3072MB` price = `70.9` currencycode = `EUR` )
      ( productid = `HT-1071` name = `Gladiator MX`
        maincategory = `Computer Components` category = `Graphic Cards` suppliername = `Ultrasonic United` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg`
        description = `Gladiator XLN: PCI-E GDDR5 3072MB DVI Out, TV Out low-noise` price = `81.7` currencycode = `EUR` )
      ( productid = `HT-1072` name = `Hurricane GX`
        maincategory = `Computer Components` category = `Graphic Cards` suppliername = `Ultrasonic United` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg`
        description = `Hurricane GX: PCI-E 691 GFLOPS game-optimized` price = `101.2` currencycode = `EUR` )
      ( productid = `HT-1073` name = `Hurricane GX/LN`
        maincategory = `Computer Components` category = `Graphic Cards` suppliername = `Smartcards` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg`
        description = `Hurricane GX/LN: PCI-E 691 GFLOPS game-optimized, low-noise.` price = `139.99` currencycode = `EUR` )
      ( productid = `HT-1080` name = `Photo Scan`
        maincategory = `Printers & Scanners` category = `Scanners` suppliername = `Printer for All` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg`
        description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - Hi-Speed USB - Bluetooth` price = `129` currencycode = `EUR` )
      ( productid = `HT-1081` name = `Power Scan`
        maincategory = `Printers & Scanners` category = `Scanners` suppliername = `Printer for All` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg`
        description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - SCSI for backward compatibility` price = `89` currencycode = `EUR` )
      ( productid = `HT-1082` name = `Jet Scan Professional`
        maincategory = `Printers & Scanners` category = `Scanners` suppliername = `Printer for All` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg`
        description = `Flatbed scanner - Letter - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module` price = `169` currencycode = `EUR` )
      ( productid = `HT-1083` name = `Jet Scan Professional`
        maincategory = `Printers & Scanners` category = `Scanners` suppliername = `Printer for All` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg`
        description = `Flatbed scanner - A4 - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module` price = `189` currencycode = `EUR` )
      ( productid = `HT-1085` name = `Copymaster`
        maincategory = `Printers & Scanners` category = `Multifunction Printers` suppliername = `Alpha Printers` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg`
        description = `Copymaster` price = `1499` currencycode = `EUR` )
      ( productid = `HT-1090` name = `Surround Sound`
        maincategory = `Computer Components` category = `Speakers` suppliername = `Speaker Experts` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg`
        description = `PC multimedia speakers - 5 Watt (Total)` price = `39` currencycode = `EUR` )
      ( productid = `HT-1091` name = `Blaster Extreme`
        maincategory = `Computer Components` category = `Speakers` suppliername = `Speaker Experts` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg`
        description = `PC multimedia speakers - 10 Watt (Total) - 2-way` price = `26` currencycode = `EUR` )
      ( productid = `HT-1092` name = `Sound Booster`
        maincategory = `Computer Components` category = `Speakers` suppliername = `Speaker Experts` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg`
        description = `PC multimedia speakers - optimized for Blutooth/A2DP` price = `45` currencycode = `EUR` )
      ( productid = `HT-1095` name = `Lovely Sound 5.1 Wireless`
        maincategory = `Computer Components` category = `Accessories` suppliername = `Fasttech` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg`
        description = `5.1 Headset, 40 Hz-20 kHz, Wireless` price = `49` currencycode = `EUR` )
      ( productid = `HT-1096` name = `Lovely Sound 5.1`
        maincategory = `Computer Components` category = `Accessories` suppliername = `Fasttech` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg`
        description = `5.1 Headset, 40 Hz-20 kHz, 3m cable` price = `39` currencycode = `EUR` )
      ( productid = `HT-1097` name = `Lovely Sound Stereo`
        maincategory = `Computer Components` category = `Accessories` suppliername = `Fasttech` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg`
        description = `5.1 Headset, 40 Hz-20 kHz, 1m cable` price = `29` currencycode = `EUR` )
      ( productid = `HT-1100` name = `Smart Office`
        maincategory = `Software` category = `Software` suppliername = `Technocom` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg`
        description = `Complete package, 1 User, Office Applications (word processing, spreadsheet, presentations)` price = `89.9` currencycode = `EUR` )
      ( productid = `HT-1101` name = `Smart Design`
        maincategory = `Software` category = `Software` suppliername = `Technocom` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg`
        description = `Complete package, 1 User, Image editing, processing` price = `79.9` currencycode = `EUR` )
      ( productid = `HT-1102` name = `Smart Network`
        maincategory = `Software` category = `Software` suppliername = `Technocom` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg`
        description = `Complete package, 1 User, Network Software Utilities, Useful Applications and Documentation` price = `69` currencycode = `EUR` )
      ( productid = `HT-1103` name = `Smart Multimedia`
        maincategory = `Software` category = `Software` suppliername = `Technocom` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg`
        description = `Complete package, 1 User, different Multimedia applications, playing music, watching DVDs, only with this Smart package` price = `77` currencycode = `EUR` )
      ( productid = `HT-1104` name = `Smart Games`
        maincategory = `Software` category = `Software` suppliername = `Technocom` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg`
        description = `Complete package, 1 User, various games for amusement, logic, action, jump&run` price = `55` currencycode = `EUR` )
      ( productid = `HT-1105` name = `Smart Internet Antivirus`
        maincategory = `Software` category = `Software` suppliername = `Brainsoft` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg`
        description = `Complete package, 1 User, highly recommended for internet users as anti-virus protection` price = `29` currencycode = `EUR` )
      ( productid = `HT-1106` name = `Smart Firewall`
        maincategory = `Software` category = `Software` suppliername = `Brainsoft` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg`
        description = `Complete package, 1 User, recommended for internet users, protect your PC against cyber-crime` price = `34` currencycode = `EUR` )
      ( productid = `HT-1107` name = `Smart Money`
        maincategory = `Software` category = `Software` suppliername = `Brainsoft` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg`
        description = `Complete package, 1 User, bring your money in your mind, see what you have and what you want` price = `29.9` currencycode = `EUR` )
      ( productid = `HT-1110` name = `PC Lock`
        maincategory = `Computer Systems` category = `Computer System Accessories` suppliername = `Red Point Stores` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg`
        description = `Robust 3m anti-burglary protection for your laptop computer` price = `8.9` currencycode = `EUR` )
      ( productid = `HT-1111` name = `Notebook Lock`
        maincategory = `Computer Systems` category = `Computer System Accessories` suppliername = `Red Point Stores` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg`
        description = `Robust 1m anti-burglary protection for your desktop computer` price = `6.9` currencycode = `EUR` )
      ( productid = `HT-1112` name = `Web cam reality`
        maincategory = `Computer Systems` category = `Computer System Accessories` suppliername = `Red Point Stores` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg`
        description = `Color webcam, color, High-Speed USB` price = `39` currencycode = `EUR` )
      ( productid = `HT-1113` name = `Screen clean`
        maincategory = `Computer Systems` category = `Computer System Accessories` suppliername = `Red Point Stores` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg`
        description = `10 separately packed screen wipes` price = `2.3` currencycode = `EUR` )
      ( productid = `HT-1114` name = `Fabric bag professional`
        maincategory = `Computer Systems` category = `Computer System Accessories` suppliername = `Red Point Stores` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg`
        description = `Notebook bag, plenty of room for stationery and writing materials` price = `31` currencycode = `EUR` )
      ( productid = `HT-1115` name = `Wireless DSL Router`
        maincategory = `Computer Components` category = `Telecommunications` suppliername = `Red Point Stores` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg`
        description = `Wireless DSL Router (available in blue, black and silver)` price = `49` currencycode = `EUR` )
      ( productid = `HT-1116` name = `Wireless DSL Router / Repeater`
        maincategory = `Computer Components` category = `Telecommunications` suppliername = `Red Point Stores` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg`
        description = `Wireless DSL Router / Repeater (available in blue, black and silver)` price = `59` currencycode = `EUR` )
      ( productid = `HT-1117` name = `Wireless DSL Router / Repeater and Print Server`
        maincategory = `Computer Components` category = `Telecommunications` suppliername = `Technocom` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg`
        description = `Wireless DSL Router / Repeater and Print Server (available in blue, black and silver)` price = `69` currencycode = `EUR` )
      ( productid = `HT-1118` name = `USB Stick`
        maincategory = `Computer Systems` category = `Computer System Accessories` suppliername = `Technocom` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg`
        description = `USB 2.0 High-Speed 64 GB` price = `35` currencycode = `EUR` )
      ( productid = `HT-1119` name = `Travel Adapter`
        maincategory = `Computer Systems` category = `Accessories` suppliername = `Titanium` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg`
        description = `Universal Travel Adapter` price = `79` currencycode = `EUR` )
      ( productid = `HT-1120` name = `Cordless Bluetooth Keyboard, english international`
        maincategory = `Computer Components` category = `Keyboards` suppliername = `Technocom` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg`
        description = `Cordless Bluetooth Keyboard with English keys` price = `29` currencycode = `EUR` )
      ( productid = `HT-1137` name = `Flat XXL`
        maincategory = `Computer Components` category = `Flat Screen Monitors` suppliername = `Technocom` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg`
        description = `Optimum Hi-Resolution max. 2048 × 1536 @ 85Hz, Dot Pitch: 0.24mm` price = `1430` currencycode = `EUR` )
      ( productid = `HT-1138` name = `Pocket Mouse`
        maincategory = `Computer Components` category = `Mice` suppliername = `Technocom` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg`
        description = `Portable pocket Mouse with retracting cord` price = `23` currencycode = `EUR` )
      ( productid = `HT-1210` name = `PC Power Station`
        maincategory = `Computer Systems` category = `PCs` suppliername = `Technocom` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg`
        description = `PC Power Station with 3,4 Ghz quad-core, 32 GB DDR3 SDRAM, feels like Available PC, Windows 8 Pro` price = `2399` currencycode = `EUR` )
      ( productid = `HT-1251` name = `Astro Laptop 1516`
        maincategory = `Computer Systems` category = `Laptops` suppliername = `Ultrasonic United` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg`
        description = `Flexible Laptop with 2,5 GHz Quad Core, 15" HD TN, 16 GB DDR SDRAM, 256 GB SSD, Windows 10 Pro` price = `989` currencycode = `EUR` )
      ( productid = `HT-1252` name = `Astro Phone 6`
        maincategory = `Smartphones & Tablets` category = `Smartphones and Tablets` suppliername = `Ultrasonic United` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg`
        description = `6 inch 1280x800 HD display (216 ppi), Quad-core processor, 8 GB internal storage (actual formatted capacity will be less), 3050 mAh battery (Up to 8 hours of active use), grey or black` price = `649` currencycode = `EUR` )
      ( productid = `HT-1253` name = `Benda Laptop 1408`
        maincategory = `Computer Systems` category = `Laptops` suppliername = `Ultrasonic United` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg`
        description = `Flexible Laptop with 2,5 GHz Dual Core, 14" HD+ TN, 8 GB DDR SDRAM, 324 GB SSD, Windows 10 Pro` price = `976` currencycode = `EUR` )
      ( productid = `HT-1254` name = `Bending Screen 21HD`
        maincategory = `Computer Components` category = `Flat Screens` suppliername = `Ultrasonic United` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg`
        description = `Optimum Hi-Resolution Widescreen max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub` price = `250` currencycode = `EUR` )
      ( productid = `HT-1255` name = `Broad Screen 22HD`
        maincategory = `Computer Components` category = `Flat Screens` suppliername = `Ultrasonic United` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg`
        description = `Optimum Hi-Resolution Widescreen max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub` price = `270` currencycode = `EUR` )
      ( productid = `HT-1256` name = `Cerdik Phone 7`
        maincategory = `Smartphones & Tablets` category = `Smartphones and Tablets` suppliername = `Ultrasonic United` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg`
        description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black` price = `549` currencycode = `EUR` )
      ( productid = `HT-1257` name = `Cepat Tablet 10.5`
        maincategory = `Smartphones & Tablets` category = `Smartphones and Tablets` suppliername = `Ultrasonic United` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg`
        description = `10.5-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor` price = `549` currencycode = `EUR` )
      ( productid = `HT-1258` name = `Cepat Tablet 8`
        maincategory = `Smartphones & Tablets` category = `Smartphones and Tablets` suppliername = `Ultrasonic United` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg`
        description = `8-inch Multitouch HD Screen (2000 x 1500) 32GB Internal Memory, Wireless N Wi-Fi, Bluetooth, GPS Enabled, 1.5 GHz Quad-Core Processor` price = `529` currencycode = `EUR` )
      ( productid = `HT-1500` name = `Server Basic`
        maincategory = `Computer Systems` category = `Servers` suppliername = `Technocom` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg`
        description = `Dual socket, quad-core processing server with 1333 MHz Front Side Bus with 10Gb connectivity` price = `5000` currencycode = `EUR` )
      ( productid = `HT-1501` name = `Server Professional`
        maincategory = `Computer Systems` category = `Servers` suppliername = `Technocom` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg`
        description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 10Gb connectivity` price = `15000` currencycode = `EUR` )
      ( productid = `HT-1502` name = `Server Power Pro`
        maincategory = `Computer Systems` category = `Servers` suppliername = `Technocom` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg`
        description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 100Gb connectivity` price = `25000` currencycode = `EUR` )
      ( productid = `HT-1600` name = `Family PC Basic`
        maincategory = `Computer Systems` category = `Desktop Computers` suppliername = `Titanium` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg`
        description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Graphic Card: Proctra X, Windows 8` price = `600` currencycode = `EUR` )
      ( productid = `HT-1601` name = `Family PC Pro`
        maincategory = `Computer Systems` category = `Desktop Computers` suppliername = `Titanium` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg`
        description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8` price = `900` currencycode = `EUR` )
      ( productid = `HT-1602` name = `Gaming Monster`
        maincategory = `Computer Systems` category = `Desktop Computers` suppliername = `Titanium` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg`
        description = `3,4 Ghz quad core, 8 GB DDR3 SDRAM, 2000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8` price = `1200` currencycode = `EUR` )
      ( productid = `HT-1603` name = `Gaming Monster Pro`
        maincategory = `Computer Systems` category = `Desktop Computers` suppliername = `Titanium` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg`
        description = `3,4 Ghz quad core, 16 GB DDR3 SDRAM, 4000 GB Hard Disc, Graphic Card: Hurricane GX, Windows 8` price = `1700` currencycode = `EUR` )
      ( productid = `HT-2000` name = `7" Widescreen Portable DVD Player w MP3`
        maincategory = `TV, Video & HiFi` category = `Accessories` suppliername = `Titanium` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg`
        description = `7" LCD Screen, storage battery holds up to 6 hours!` price = `249.99` currencycode = `EUR` )
      ( productid = `HT-2001` name = `10" Portable DVD player`
        maincategory = `TV, Video & HiFi` category = `Accessories` suppliername = `Titanium` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg`
        description = `10" LCD Screen, storage battery holds up to 8 hours` price = `449.99` currencycode = `EUR` )
      ( productid = `HT-2002` name = `Portable DVD Player with 9" LCD Monitor`
        maincategory = `TV, Video & HiFi` category = `Accessories` suppliername = `Technocom` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg`
        description = `9" LCD Screen, storage holds up to 8 hours, 2 speakers included` price = `853.99` currencycode = `EUR` )
      ( productid = `HT-2025` name = `CD/DVD case: 264 sleeves`
        maincategory = `Computer Systems` category = `Accessories` suppliername = `Titanium` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg`
        description = `Organizer and protective case for 264 CDs and DVDs` price = `44.99` currencycode = `EUR` )
      ( productid = `HT-2026` name = `Audio/Video Cable Kit - 4m`
        maincategory = `Computer Systems` category = `Accessories` suppliername = `Titanium` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg`
        description = `Quality cables for notebooks and projectors` price = `29.99` currencycode = `EUR` )
      ( productid = `HT-2027` name = `Removable CD/DVD Laser Labels`
        maincategory = `Computer Systems` category = `Accessories` suppliername = `Titanium` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg`
        description = `Removable jewel case labels, zero residues (100)` price = `8.99` currencycode = `EUR` )
      ( productid = `HT-6100` name = `Beam Breaker B-1`
        maincategory = `TV, Video & HiFi` category = `Accessories` suppliername = `Titanium` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg`
        description = `720p, DLP Projector max. 8,45 Meter, 2D` price = `469` currencycode = `EUR` )
      ( productid = `HT-6101` name = `Beam Breaker B-2`
        maincategory = `TV, Video & HiFi` category = `Accessories` suppliername = `Technocom` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg`
        description = `1080p, DLP max.9,34 Meter, 2D-ready` price = `679` currencycode = `EUR` )
      ( productid = `HT-6102` name = `Beam Breaker B-3`
        maincategory = `TV, Video & HiFi` category = `Accessories` suppliername = `Technocom` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg`
        description = `1080p, DLP max. 12,3 Meter, 3D-ready` price = `889` currencycode = `EUR` )
      ( productid = `HT-6110` name = `Play Movie`
        maincategory = `TV, Video & HiFi` category = `Accessories` suppliername = `Fasttech` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg`
        description = `CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid` price = `130` currencycode = `EUR` )
      ( productid = `HT-6111` name = `Record Movie`
        maincategory = `TV, Video & HiFi` category = `Accessories` suppliername = `Fasttech` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg`
        description = `160 GB HDD, CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid` price = `288` currencycode = `EUR` )
      ( productid = `HT-6120` name = `ITelo MusicStick`
        maincategory = `TV, Video & HiFi` category = `Accessories` suppliername = `Fasttech` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg`
        description = `64 GB USB Music-on-Available-Stick` price = `45` currencycode = `EUR` )
      ( productid = `HT-6121` name = `ITelo Jog-Mate`
        maincategory = `TV, Video & HiFi` category = `Accessories` suppliername = `Fasttech` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg`
        description = `ITelo Jog-Mate 64 GB HDD and Color Display, can play movies` price = `63` currencycode = `EUR` )
      ( productid = `HT-6122` name = `Power Pro Player 40`
        maincategory = `TV, Video & HiFi` category = `Accessories` suppliername = `Fasttech` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg`
        description = `MP3-Player with 40 GB HDD and Color Display, can play movies` price = `167` currencycode = `EUR` )
      ( productid = `HT-6123` name = `Power Pro Player 80`
        maincategory = `TV, Video & HiFi` category = `Accessories` suppliername = `Fasttech` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg`
        description = `MP3-Player with 80 GB SSD and Color Display, can play movies` price = `299` currencycode = `EUR` )
      ( productid = `HT-6130` name = `Flat Watch HD32`
        maincategory = `TV, Video & HiFi` category = `Flat Screen TVs` suppliername = `Very Best Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg`
        description = `32-inch, 1366x768 Pixel, 16:9, HDTV ready` price = `1459` currencycode = `EUR` )
      ( productid = `HT-6131` name = `Flat Watch HD37`
        maincategory = `TV, Video & HiFi` category = `Flat Screen TVs` suppliername = `Very Best Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg`
        description = `37-inch, 1366x768 Pixel, 16:9, HDTV ready` price = `1199` currencycode = `EUR` )
      ( productid = `HT-6132` name = `Flat Watch HD41`
        maincategory = `TV, Video & HiFi` category = `Flat Screen TVs` suppliername = `Very Best Screens` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg`
        description = `41-inch, 1366x768 Pixel, 16:9, HDTV ready` price = `899` currencycode = `EUR` )
      ( productid = `HT-7000` name = `Copperberry`
        maincategory = `Computer Components` category = `Accessories` suppliername = `Fasttech` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg`
        description = `Our new multifunctional Handheld with phone function in copper` price = `549` currencycode = `EUR` )
      ( productid = `HT-7010` name = `Silverberry`
        maincategory = `Computer Components` category = `Accessories` suppliername = `Fasttech` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg`
        description = `Our new multifunctional Handheld with phone function in silver` price = `549` currencycode = `EUR` )
      ( productid = `HT-7020` name = `Goldberry`
        maincategory = `Computer Components` category = `Accessories` suppliername = `Fasttech` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg`
        description = `Our new multifunctional Handheld with phone function in gold` price = `549` currencycode = `EUR` )
      ( productid = `HT-7030` name = `Platinberry`
        maincategory = `Computer Components` category = `Accessories` suppliername = `Fasttech` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg`
        description = `Our new multifunctional Handheld with phone function in platinum` price = `549` currencycode = `EUR` )
      ( productid = `HT-8000` name = `ITelO FlexTop I4000`
        maincategory = `Computer Systems` category = `Laptops` suppliername = `Titanium` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg`
        description = `Notebook with 2,80 GHz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8` price = `799` currencycode = `EUR` )
      ( productid = `HT-8001` name = `ITelO FlexTop I6300c`
        maincategory = `Computer Systems` category = `Laptops` suppliername = `Titanium` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg`
        description = `Notebook with 2,80 GHz dual core, 8 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8` price = `799` currencycode = `EUR` )
      ( productid = `HT-8002` name = `ITelO FlexTop I9100`
        maincategory = `Computer Systems` category = `Laptops` suppliername = `Titanium` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg`
        description = `Notebook with 2,80 GHz quad core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8` price = `1199` currencycode = `EUR` )
      ( productid = `HT-8003` name = `ITelO FlexTop I9800`
        maincategory = `Computer Systems` category = `Laptops` suppliername = `Titanium` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg`
        description = `Notebook with 2,80 GHz quad core, 8 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8` price = `1388` currencycode = `EUR` )
      ( productid = `HT-9991` name = `Smartphone Leather Case`
        maincategory = `Smartphones & Tablets` category = `Accessories` suppliername = `Ultrasonic United` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg`
        description = `Button Clasp, Quality Material, 100% Leather, compatible with many smartphone models` price = `25` currencycode = `EUR` )
      ( productid = `HT-9992` name = `Smartphone Alpha`
        maincategory = `Smartphones & Tablets` category = `Smartphones and Tablets` suppliername = `Ultrasonic United` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg`
        description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black` price = `599` currencycode = `EUR` )
      ( productid = `HT-9993` name = `Mini Tablet`
        maincategory = `Smartphones & Tablets` category = `Smartphones and Tablets` suppliername = `Ultrasonic United` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg`
        description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage, 4325 mAh battery (Up to 8 hours of active use)` price = `833` currencycode = `EUR` )
      ( productid = `HT-9994` name = `Camcorder View`
        maincategory = `TV, Video & HiFi` category = `Accessories` suppliername = `Ultrasonic United` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg`
        description = `1920x1080 Full HD, image stabilization reduces blur, 27x Optical / 32x Extended Zoom, wide angle Lens, 2.7" wide LCD display` price = `1388` currencycode = `EUR` )
      ( productid = `HT-9995` name = `Tablet Pouch`
        maincategory = `Smartphones & Tablets` category = `Accessories` suppliername = `Titanium` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg`
        description = `Stylish tablet pouch, protects from scratches, color: black` price = `20` currencycode = `EUR` )
      ( productid = `HT-9996` name = `Tablet Pouch`
        maincategory = `Smartphones & Tablets` category = `Accessories` suppliername = `Titanium` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg`
        description = `Stylish tablet pouch, protects from scratches, color: black` price = `20` currencycode = `EUR` )
      ( productid = `HT-9997` name = `e-Book Reader ReadMe`
        maincategory = `Smartphones & Tablets` category = `Smartphones and Tablets` suppliername = `Titanium` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg`
        description = `6-Inch E Ink Screen, Access To e-book Store, Adjustable Font Styles and Sizes, Stores Up To 1,000 Books` price = `33` currencycode = `EUR` )
      ( productid = `HT-9998` name = `Smartphone Beta`
        maincategory = `Smartphones & Tablets` category = `Smartphones and Tablets` suppliername = `Titanium` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg`
        description = `5 Megapixel Camera, Wi-Fi 802.11 b/g/n, Bluetooth, GPS Available-GPS support` price = `30` currencycode = `EUR` )
      ( productid = `HT-9999` name = `Maxi Tablet`
        maincategory = `Smartphones & Tablets` category = `Tablets` suppliername = `Titanium` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg`
        description = `10.1-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor` price = `749` currencycode = `EUR` )
      ( productid = `PF-1000` name = `Flyer`
        maincategory = `Computer Systems` category = `Accessories` suppliername = `Titanium` productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg`
        description = `Flyer for our product palette` price = `0` currencycode = `EUR` ) ).

    " /ProductCollectionStats/Filters/1/values - the twelve suppliers
    t_suppliers = VALUE #(
      ( text = `Titanium` )
      ( text = `Technocom` )
      ( text = `Red Point Stores` )
      ( text = `Very Best Screens` )
      ( text = `Smartcards` )
      ( text = `Alpha Printers` )
      ( text = `Printer for All` )
      ( text = `Oxynum` )
      ( text = `Fasttech` )
      ( text = `Ultrasonic United` )
      ( text = `Speaker Experts` )
      ( text = `Brainsoft` ) ).

  ENDMETHOD.

ENDCLASS.
