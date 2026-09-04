" @keywords table sap.m tablescrolltoindex flexiblecolumnlayout dynamicpage dynamicpagetitle title overflowtoolbar toolbarspacer searchfield column text
" @summary This sample demonstrates the scroll-to-index functionality.
CLASS z2ui5_cl_smpc_app_575 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             productid     TYPE string,
             name          TYPE string,
             quantity      TYPE string,
             maincategory  TYPE string,
             category      TYPE string,
             suppliername  TYPE string,
             productpicurl TYPE string,
             description   TYPE string,
             price         TYPE p LENGTH 9 DECIMALS 2,
             currencycode  TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    DATA t_products   TYPE ty_t_product.
    " the rows the search leaves; the full set stays in T_PRODUCTS
    DATA t_rows       TYPE ty_t_product.

    " the FlexibleColumnLayout state the router drives in the original
    DATA layout       TYPE string VALUE `OneColumn`.
    DATA total_count  TYPE i.
    " the product the mid column shows (bindElement in the detail controller)
    DATA d_name          TYPE string.
    DATA d_productid     TYPE string.
    DATA d_maincategory  TYPE string.
    DATA d_category      TYPE string.
    DATA d_suppliername  TYPE string.
    DATA d_productpicurl TYPE string.
    DATA d_description   TYPE string.
    DATA d_price         TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    " Master.controller stores the index of the row it navigated from
    " (this.iIndex) so onColumnResize can scroll it back into view. Not bound,
    " so it stays out of the round-trip model scan
    DATA press_index TYPE i VALUE -1.

    " the router state the original keeps (currentRouteName + the route's
    " arguments): the original routes by INDEX into the mock collection
    DATA route      TYPE string VALUE `master`.
    DATA product_ix TYPE i.

    METHODS view_display.
    METHODS on_event.
    METHODS detail_bind IMPORTING productid TYPE string.
    METHODS row_index IMPORTING productid     TYPE string
                      RETURNING VALUE(result) TYPE i.
    METHODS hash_apply IMPORTING iv_hash TYPE string.
    METHODS hash_push IMPORTING check_replace TYPE abap_bool OPTIONAL.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_575 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ) IS NOT INITIAL.
      model_init( ).
      t_rows = t_products.
      total_count = lines( t_products ).
      view_display( ).
    ELSEIF client->check_on_navigated( ) IS NOT INITIAL.
      view_display( ).
    ELSEIF client->check_on_event( ) IS NOT INITIAL.
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    " the router also matches a deep link / reload (`#/detail/1/
    " TwoColumnsMidExpanded`): the live hash rides in s_config-hash on every
    " request; applying it is idempotent, so a rebuild whose hash matches the
    " state simply re-derives it
    DATA lv_hash TYPE z2ui5_if_client=>ty_s_get-s_config-hash.
    DATA view TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE string_table.
    DATA fcl TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA detail TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp3 TYPE string_table.
    lv_hash = client->get( )-s_config-hash.
    IF lv_hash IS NOT INITIAL AND lv_hash <> `#`.
      hash_apply( lv_hash ).
    ENDIF.

    
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `${$parameters>/isNavigationArrow}` INTO TABLE temp1.
    INSERT `${$parameters>/layout}` INTO TABLE temp1.
    
    fcl = view->ele( n = `View` ns = `mvc`
        )->a( n = `height`      v = `100%`
        )->a( n = `xmlns`       v = `sap.m`
        )->a( n = `xmlns:f`     v = `sap.f`
        )->a( n = `xmlns:mvc`   v = `sap.ui.core.mvc`
        )->a( n = `xmlns:uxap`  v = `sap.uxap`
        )->a( n = `xmlns:form`  v = `sap.ui.layout.form`

        )->ele( n = `FlexibleColumnLayout` ns = `f`
            )->a( n = `id`                          v = `fcl`
            )->a( n = `autoFocus`                   v = `false`
            )->a( n = `restoreFocusOnBackNavigation` v = `true`
            )->a( n = `backgroundDesign`            v = `Translucent`
            " onColumnResize (@since 1.76) carries the same beginColumn flag the
            " original's handler guards on - it fires once the begin column's
            " resize has completed, which is when the pressed row has to be
            " scrolled back into view
            )->a( n = `columnResize`                v = client->_event( val = `COLUMN_RESIZE` arg = `${$parameters>/beginColumn}` )
            " the original wires stateChange to onStateChanged: only a layout
            " change by a NAVIGATION ARROW replace-navTo's the URL - the flag
            " and the new layout travel with the event, the backend guards on it
            )->a( n = `stateChange`      v = client->_event( val = `STATE_CHANGED` t_arg = temp1 )
            )->a( n = `layout`                      v = client->_bind( layout ) ).

    " Master.view.xml - the DynamicPage with the products table
    fcl->ele( n = `beginColumnPages` ns = `f`
        )->ele( n = `DynamicPage` ns = `f`
            )->a( n = `id`                       v = `dynamicPageId`
            )->a( n = `toggleHeaderOnTitleClick` v = `false`

            )->ele( n = `title` ns = `f`
                )->ele( n = `DynamicPageTitle` ns = `f`
                    )->ele( n = `heading` ns = `f`
                        )->tag( `Title`
                            )->a( n = `text` v = |Products (\{{ client->_bind_path( total_count ) }\})|

                    )->end(
                )->end(
            )->end(

            )->ele( n = `content` ns = `f`
                )->ele( `Table`
                    )->a( n = `id`      v = `productsTable`
                    )->a( n = `sticky`  v = `ColumnHeaders,HeaderToolbar`
                    )->a( n = `inset`   v = `false`
                    )->a( n = `growing` v = `true`
                    )->a( n = `class`   v = `sapFDynamicPageAlignContent`
                    )->a( n = `width`   v = `auto`
                    )->a( n = `items`   v = |\{ path: '{ client->_bind_path( t_rows ) }', sorter: \{ path: 'NAME' \} \}|

                    )->ele( `headerToolbar`
                        )->ele( `OverflowToolbar`
                            )->tag( `ToolbarSpacer`
                            )->tag( `SearchField`
                                )->a( n = `width`  v = `17.5rem`
                                )->a( n = `search` v = client->_event( val = `SEARCH` arg = `${$parameters>/query}` )

                        )->end(
                    )->end(
                    )->ele( `columns`
                        )->ele( `Column`

                            )->tag( `Text`
                                )->a( n = `text` v = `Product`

                        )->end(
                        )->ele( `Column`
                            )->a( n = `minScreenWidth` v = `Desktop`
                            )->a( n = `demandPopin`    v = `true`

                            )->tag( `Text`
                                )->a( n = `text` v = `Quantity`

                        )->end(
                        )->ele( `Column`
                            )->a( n = `minScreenWidth` v = `Desktop`
                            )->a( n = `demandPopin`    v = `true`

                            )->tag( `Text`
                                )->a( n = `text` v = `Description`

                        )->end(
                        )->ele( `Column`
                            )->a( n = `hAlign` v = `End`

                            )->tag( `Text`
                                )->a( n = `text` v = `Price`

                        )->end(
                    )->end(
                    )->ele( `items`
                        )->ele( `ColumnListItem`
                            )->a( n = `type`   v = `Navigation`
                            )->a( n = `vAlign` v = `Middle`
                            )->a( n = `press`  v = client->_event( val = `LIST_ITEM` arg = `${PRODUCTID}` )

                            )->ele( `cells`
                                )->tag( `ObjectIdentifier`
                                    )->a( n = `title` v = `{NAME}`
                                    )->a( n = `text`  v = `{PRODUCTID}`
                                )->tag( `ObjectIdentifier`
                                    )->a( n = `text` v = `{QUANTITY}`
                                )->tag( `ObjectIdentifier`
                                    )->a( n = `text` v = `{DESCRIPTION}`
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
    
    detail = fcl->ele( n = `midColumnPages` ns = `f`
        )->ele( n = `ObjectPageLayout` ns = `uxap`
            )->a( n = `id`                          v = `ObjectPageLayout`
            )->a( n = `showTitleInHeaderContent`    v = `true`
            )->a( n = `alwaysShowContentHeader`     v = `false`
            )->a( n = `preserveHeaderStateOnScroll` v = `false`
            )->a( n = `headerContentPinnable`       v = `true`
            )->a( n = `isChildPage`                 v = `true`
            )->a( n = `upperCaseAnchorBar`          v = `false` ).

    detail->ele( n = `headerTitle` ns = `uxap`
        )->ele( n = `ObjectPageDynamicHeaderTitle` ns = `uxap`

            )->ele( n = `expandedHeading` ns = `uxap`
                )->tag( `Title`
                    )->a( n = `text`     v = client->_bind( d_name )
                    )->a( n = `wrapping` v = `true`
                    )->a( n = `class`    v = `sapUiSmallMarginEnd`

            )->end(
            )->ele( n = `snappedHeading` ns = `uxap`
                )->ele( `FlexBox`
                    )->a( n = `wrap`         v = `Wrap`
                    )->a( n = `fitContainer` v = `true`
                    )->a( n = `alignItems`   v = `Center`

                    )->ele( `FlexBox`
                        )->a( n = `wrap`         v = `NoWrap`
                        )->a( n = `fitContainer` v = `true`
                        )->a( n = `alignItems`   v = `Center`
                        )->a( n = `class`        v = `sapUiTinyMarginEnd`

                        )->tag( `Avatar`
                            )->a( n = `src`          v = client->_bind( d_productpicurl )
                            )->a( n = `displaySize`  v = `S`
                            )->a( n = `displayShape` v = `Square`
                        )->tag( `Title`
                            )->a( n = `text`     v = client->_bind( d_name )
                            )->a( n = `wrapping` v = `true`
                            )->a( n = `class`    v = `sapUiTinyMarginEnd`

                    )->end(
                )->end(
            )->end(
            )->ele( n = `navigationActions` ns = `uxap`
                )->tag( `OverflowToolbarButton`
                    )->a( n = `type`    v = `Transparent`
                    )->a( n = `icon`    v = `sap-icon://full-screen`
                    )->a( n = `tooltip` v = `Enter Full Screen Mode`
                    )->a( n = `visible` v = |\{= ${ client->_bind( layout ) } !== 'MidColumnFullScreen' \}|
                    )->a( n = `press`   v = client->_event( `FULL_SCREEN` )
                )->tag( `OverflowToolbarButton`
                    )->a( n = `type`    v = `Transparent`
                    )->a( n = `icon`    v = `sap-icon://exit-full-screen`
                    )->a( n = `tooltip` v = `Exit Full Screen Mode`
                    )->a( n = `visible` v = |\{= ${ client->_bind( layout ) } === 'MidColumnFullScreen' \}|
                    )->a( n = `press`   v = client->_event( `EXIT_FULL_SCREEN` )
                )->tag( `OverflowToolbarButton`
                    )->a( n = `type`    v = `Transparent`
                    )->a( n = `icon`    v = `sap-icon://decline`
                    )->a( n = `tooltip` v = `Close column`
                    )->a( n = `visible` v = |\{= ${ client->_bind( layout ) } !== 'OneColumn' \}|
                    )->a( n = `press`   v = client->_event( `CLOSE_COLUMN` )

            )->end(
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

    detail->ele( n = `sections` ns = `uxap`
        )->ele( n = `ObjectPageSection` ns = `uxap`
            )->a( n = `title` v = `General Information`

            )->ele( n = `subSections` ns = `uxap`
                )->ele( n = `ObjectPageSubSection` ns = `uxap`

                    )->ele( n = `blocks` ns = `uxap`
                        )->ele( n = `SimpleForm` ns = `form`
                            )->a( n = `editable`    v = `false`
                            )->a( n = `layout`      v = `ResponsiveGridLayout`
                            )->a( n = `labelSpanL`  v = `12`
                            )->a( n = `labelSpanM`  v = `12`
                            )->a( n = `emptySpanL`  v = `0`
                            )->a( n = `emptySpanM`  v = `0`
                            )->a( n = `columnsL`    v = `1`
                            )->a( n = `columnsM`    v = `1`

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
        )->end(
    )->end( ).

    client->view_display( view->stringify( ) ).

    " the original's router, app-owned: the hash carries the route the way
    " the manifest patterns spell it, and a hash change the app did not
    " write (browser Back/Forward, a manual edit) round-trips as
    " HASH_CHANGED. Re-asserted per render - it dies with an app switch
    
    CLEAR temp3.
    INSERT `HASH_CHANGED` INTO TABLE temp3.
    client->follow_up_action( val   = client->cs_event-hash_attach_changed
                              t_arg = temp3 ).

  ENDMETHOD.


  METHOD detail_bind.

    " Detail.controller's bindElement( '/ProductCollection/<n>' ) - the relative
    " bindings of the original resolve against the bound element, the port folds
    " them to root-seeded fields (app 229 idiom)
    FIELD-SYMBOLS <product> TYPE z2ui5_cl_smpc_app_575=>ty_s_product.
    READ TABLE t_products WITH KEY productid = productid ASSIGNING <product>.
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


  METHOD row_index.

    " the items binding renders T_ROWS sorted on NAME, so the row index the
    " original reads off the aggregation is the position in that order
    DATA rows LIKE t_rows.
    DATA row LIKE LINE OF rows.
    rows = t_rows.
    SORT rows BY name AS TEXT ASCENDING.

    result = -1.
    
    LOOP AT rows INTO row.
      IF row-productid = productid.
        result = sy-tabix - 1.
        RETURN.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD on_event.
          DATA temp5 TYPE string_table.
          DATA temp1 LIKE LINE OF temp5.
        DATA query TYPE string.
          DATA product LIKE LINE OF t_products.

    CASE client->get_event( ).

      WHEN `LIST_ITEM`.
        " onListItemPress: navigate to the detail route, which opens the mid
        " column - the route carries the product's INDEX into the collection
        " (the bindingContext path index of the original)
        detail_bind( client->get_event_arg( ) ).
        " oItem.getParent( )->indexOfItem( oItem ) - the index of the pressed row
        " in the RENDERED items, which the items binding sorts on NAME
        press_index = row_index( client->get_event_arg( ) ).
        READ TABLE t_products WITH KEY productid = client->get_event_arg( ) TRANSPORTING NO FIELDS.
        IF sy-subrc = 0.
          product_ix = sy-tabix - 1.
        ENDIF.
        route  = `detail`.
        layout = `TwoColumnsMidExpanded`.
        hash_push( ).

      WHEN `FULL_SCREEN`.
        route  = `detail`.
        layout = `MidColumnFullScreen`.
        hash_push( ).

      WHEN `EXIT_FULL_SCREEN`.
        route  = `detail`.
        layout = `TwoColumnsMidExpanded`.
        hash_push( ).

      WHEN `CLOSE_COLUMN`.
        " handleClose: navTo('master') - the ':layout:' route
        route  = `master`.
        layout = `OneColumn`.
        hash_push( ).

      WHEN `STATE_CHANGED`.
        " onStateChanged: the layout is a two-way binding, so the model
        " already carries the value this event reports - but when a
        " NAVIGATION ARROW changed it, the original replace-navTo's the
        " URL: same route, new layout, no new history entry
        IF client->get_event_arg( ) = abap_true.
          layout = client->get_event_arg( 2 ).
          hash_push( abap_true ).
        ENDIF.

      WHEN `HASH_CHANGED`.
        " browser Back/Forward (or a manual edit) moved the app-owned hash -
        " the router's routeMatched: derive route, index and layout from the
        " hash this request carries. The instance itself is untouched, so the
        " search text survives like in the original
        hash_apply( client->get( )-s_config-hash ).

      WHEN `COLUMN_RESIZE`.
        " onColumnResize: oTable.scrollToIndex( iIndex ) once the begin column
        " has finished resizing, so the row the user pressed stays in view. The
        " original also asks oTable.$( )->is( ':visible' ); the begin column is
        " hidden exactly while the mid column is full screen, which the backend
        " reads off LAYOUT instead of the DOM
        IF client->get_event_arg( ) = abap_true
           AND press_index >= 0
           AND layout <> `MidColumnFullScreen`.
          
          CLEAR temp5.
          INSERT `productsTable` INTO TABLE temp5.
          INSERT `scrollToIndex` INTO TABLE temp5.
          
          temp1 = |{ press_index }|.
          INSERT temp1 INTO TABLE temp5.
          client->follow_up_action( val   = client->cs_event-control_by_id
                                    t_arg = temp5 ).
        ENDIF.

      WHEN `SEARCH`.
        " onSearch filters the table's items on Name
        
        query = to_upper( client->get_event_arg( ) ).
        IF query IS INITIAL.
          t_rows = t_products.
        ELSE.
          CLEAR t_rows.
          
          LOOP AT t_products INTO product.
            IF to_upper( product-name ) CS query.
              APPEND product TO t_rows.
            ENDIF.
          ENDLOOP.
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD hash_apply.

    " the router's routeMatched, read side: parse the app hash back into
    " route, index and layout. The original's patterns: '' (master start),
    " '{layout}' (the ':layout:' master route), 'detail/{product}/{layout}' -
    " product is an INDEX into the mock collection, defaulting to 0 like the
    " original's `arguments.product || this._product || "0"`
    DATA lv_hash LIKE iv_hash.
    DATA lt_seg TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    DATA temp7 TYPE string.
    DATA temp8 TYPE string.
    DATA lv_p LIKE temp7.
    DATA temp9 TYPE string.
    DATA temp10 TYPE string.
    DATA lv_l LIKE temp9.
    DATA temp11 TYPE string.
    DATA temp12 TYPE string.
        DATA temp13 TYPE i.
        DATA temp14 TYPE string.
          DATA temp15 LIKE LINE OF t_products.
          DATA temp16 LIKE sy-tabix.
        DATA temp17 LIKE LINE OF lt_seg.
        DATA temp18 LIKE sy-tabix.
    lv_hash = iv_hash.
    IF lv_hash CS `#`.
      lv_hash = substring_after( val = lv_hash sub = `#` ).
    ENDIF.
    SHIFT lv_hash LEFT DELETING LEADING `/`.
    
    SPLIT lv_hash AT `/` INTO TABLE lt_seg.
    DELETE lt_seg WHERE table_line IS INITIAL.

    
    CLEAR temp7.
    
    READ TABLE lt_seg INTO temp8 INDEX 2.
    IF sy-subrc = 0.
      temp7 = temp8.
    ENDIF.
    
    lv_p = temp7.
    
    CLEAR temp9.
    
    READ TABLE lt_seg INTO temp10 INDEX 3.
    IF sy-subrc = 0.
      temp9 = temp10.
    ENDIF.
    
    lv_l = temp9.

    
    CLEAR temp11.
    
    READ TABLE lt_seg INTO temp12 INDEX 1.
    IF sy-subrc = 0.
      temp11 = temp12.
    ENDIF.
    CASE temp11.
      WHEN ``.
        route  = `master`.
        layout = `OneColumn`.

      WHEN `detail`.
        route      = `detail`.
        
        IF lv_p CO `0123456789` AND lv_p IS NOT INITIAL AND strlen( lv_p ) <= 4.
          temp13 = lv_p.
        ELSE.
          CLEAR temp13.
        ENDIF.
        product_ix = temp13.
        
        IF lv_l IS NOT INITIAL.
          temp14 = lv_l.
        ELSE.
          temp14 = `TwoColumnsMidExpanded`.
        ENDIF.
        layout     = temp14.
        IF product_ix < lines( t_products ).
          
          
          temp16 = sy-tabix.
          READ TABLE t_products INDEX product_ix + 1 INTO temp15.
          sy-tabix = temp16.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          detail_bind( temp15-productid ).
        ENDIF.

      WHEN OTHERS.
        " the single-segment ':layout:' master route, e.g. '#/OneColumn'
        route  = `master`.
        
        
        temp18 = sy-tabix.
        READ TABLE lt_seg INDEX 1 INTO temp17.
        sy-tabix = temp18.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        layout = temp17.
    ENDCASE.

  ENDMETHOD.


  METHOD hash_push.

    DATA lv_hash TYPE string.
    " the router's navTo, write side: compose the current route the way the
    " manifest patterns spell it and push it as the app-owned hash
    CASE route.
      WHEN `detail`.
        lv_hash = |/detail/{ product_ix }/{ layout }|.
      WHEN OTHERS.
        lv_hash = |/{ layout }|.
    ENDCASE.

    " a NAVIGATION ARROW rewrites the URL in place (the original's
    " replace-navTo) - everything else is a real, pushed history entry
    IF check_replace = abap_true.
      client->hash_replace( lv_hash ).
    ELSE.
      client->hash_set( lv_hash ).
    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " the full mock /ProductCollection, in the mock order - the items binding
    " keeps its own sorter on NAME
    DATA temp19 TYPE z2ui5_cl_smpc_app_575=>ty_t_product.
    DATA temp20 LIKE LINE OF temp19.
    CLEAR temp19.
    
    temp20-productid = `HT-1000`.
    temp20-name = `Notebook Basic 15`.
    temp20-quantity = `10`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `Laptops`.
    temp20-suppliername = `Very Best Screens`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`.
    temp20-description = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.
    temp20-price = `956`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1001`.
    temp20-name = `Notebook Basic 17`.
    temp20-quantity = `20`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `Laptops`.
    temp20-suppliername = `Very Best Screens`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg`.
    temp20-description = `Notebook Basic 17 with 2,80 GHz quad core, 17" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.
    temp20-price = `1249`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1002`.
    temp20-name = `Notebook Basic 18`.
    temp20-quantity = `10`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `Laptops`.
    temp20-suppliername = `Very Best Screens`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg`.
    temp20-description = `Notebook Basic 18 with 2,80 GHz quad core, 18" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`.
    temp20-price = `1570`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1003`.
    temp20-name = `Notebook Basic 19`.
    temp20-quantity = `15`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `Laptops`.
    temp20-suppliername = `Smartcards`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg`.
    temp20-description = `Notebook Basic 19 with 2,80 GHz quad core, 19" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`.
    temp20-price = `1650`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1007`.
    temp20-name = `ITelO Vault`.
    temp20-quantity = `15`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Technocom`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg`.
    temp20-description = `Digital Organizer with State-of-the-Art Storage Encryption`.
    temp20-price = `299`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1010`.
    temp20-name = `Notebook Professional 15`.
    temp20-quantity = `16`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Very Best Screens`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg`.
    temp20-description = `Notebook Professional 15 with 2,80 GHz quad core, 15" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro`.
    temp20-price = `1999`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1011`.
    temp20-name = `Notebook Professional 17`.
    temp20-quantity = `17`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `Laptops`.
    temp20-suppliername = `Very Best Screens`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg`.
    temp20-description = `Notebook Professional 17 with 2,80 GHz quad core, 17" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro`.
    temp20-price = `2299`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1020`.
    temp20-name = `ITelO Vault Net`.
    temp20-quantity = `14`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Technocom`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg`.
    temp20-description = `Digital Organizer with State-of-the-Art Encryption for Storage and Network Communications`.
    temp20-price = `459`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1021`.
    temp20-name = `ITelO Vault SAT`.
    temp20-quantity = `50`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Technocom`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg`.
    temp20-description = `Digital Organizer with State-of-the-Art Encryption for Storage and Secure Stellite Link`.
    temp20-price = `149`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1022`.
    temp20-name = `Comfort Easy`.
    temp20-quantity = `30`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Technocom`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg`.
    temp20-description = `32 GB Digital Assistant with high-resolution color screen`.
    temp20-price = `1679`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1023`.
    temp20-name = `Comfort Senior`.
    temp20-quantity = `24`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Technocom`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg`.
    temp20-description = `64 GB Digital Assistant with high-resolution color screen and synthesized voice output`.
    temp20-price = `512`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1030`.
    temp20-name = `Ergo Screen E-I`.
    temp20-quantity = `14`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Flat Screen Monitors`.
    temp20-suppliername = `Very Best Screens`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg`.
    temp20-description = `Optimum Hi-Resolution max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm`.
    temp20-price = `230`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1031`.
    temp20-name = `Ergo Screen E-II`.
    temp20-quantity = `24`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Flat Screen Monitors`.
    temp20-suppliername = `Very Best Screens`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg`.
    temp20-description = `Optimum Hi-Resolution max. 1920 x 1200 @ 85Hz, Dot Pitch: 0.26mm`.
    temp20-price = `285`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1032`.
    temp20-name = `Ergo Screen E-III`.
    temp20-quantity = `50`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Flat Screen Monitors`.
    temp20-suppliername = `Very Best Screens`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg`.
    temp20-description = `Optimum Hi-Resolution max. 2560 x 1440 @ 85Hz, Dot Pitch: 0.25mm`.
    temp20-price = `345`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1035`.
    temp20-name = `Flat Basic`.
    temp20-quantity = `23`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Flat Screen Monitors`.
    temp20-suppliername = `Very Best Screens`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg`.
    temp20-description = `Optimum Hi-Resolution max. 1600 x 1200 @ 85Hz, Dot Pitch: 0.24mm`.
    temp20-price = `399`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1036`.
    temp20-name = `Flat Future`.
    temp20-quantity = `22`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Flat Screen Monitors`.
    temp20-suppliername = `Very Best Screens`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg`.
    temp20-description = `Optimum Hi-Resolution max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.26mm`.
    temp20-price = `430`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1037`.
    temp20-name = `Flat XL`.
    temp20-quantity = `23`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Flat Screen Monitors`.
    temp20-suppliername = `Very Best Screens`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg`.
    temp20-description = `Optimum Hi-Resolution max. 2016 x 1512 @ 85Hz, Dot Pitch: 0.24mm`.
    temp20-price = `1230`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1040`.
    temp20-name = `Laser Professional Eco`.
    temp20-quantity = `21`.
    temp20-maincategory = `Printers & Scanners`.
    temp20-category = `Printers`.
    temp20-suppliername = `Alpha Printers`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg`.
    temp20-description = `Print 2400 dpi image quality color documents at speeds of up to 32 ppm (color) or 36 ppm (monochrome), letter/A4. Powerful 500 MHz processor, 512MB of memory`.
    temp20-price = `830`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1041`.
    temp20-name = `Laser Basic`.
    temp20-quantity = `8`.
    temp20-maincategory = `Printers & Scanners`.
    temp20-category = `Printers`.
    temp20-suppliername = `Alpha Printers`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg`.
    temp20-description = `Up to 22 ppm color or 24 ppm monochrome A4/letter, powerful 500 MHz processor and 128MB of memory`.
    temp20-price = `490`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1042`.
    temp20-name = `Laser Allround`.
    temp20-quantity = `9`.
    temp20-maincategory = `Printers & Scanners`.
    temp20-category = `Printers`.
    temp20-suppliername = `Alpha Printers`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg`.
    temp20-description = `Print up to 25 ppm letter and 24 ppm A4 color or monochrome, with Available first-page-out-time of less than 13 seconds for monochrome and less than 15 seconds for color`.
    temp20-price = `349`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1050`.
    temp20-name = `Ultra Jet Super Color`.
    temp20-quantity = `17`.
    temp20-maincategory = `Printers & Scanners`.
    temp20-category = `Printers`.
    temp20-suppliername = `Alpha Printers`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg`.
    temp20-description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB, Ethernet`.
    temp20-price = `139`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1051`.
    temp20-name = `Ultra Jet Mobile`.
    temp20-quantity = `18`.
    temp20-maincategory = `Printers & Scanners`.
    temp20-category = `Printers`.
    temp20-suppliername = `Printer for All`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg`.
    temp20-description = `1000 dpi x 1000 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB - excellent dimensions for the small office`.
    temp20-price = `99`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1052`.
    temp20-name = `Ultra Jet Super Highspeed`.
    temp20-quantity = `25`.
    temp20-maincategory = `Printers & Scanners`.
    temp20-category = `Printers`.
    temp20-suppliername = `Printer for All`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg`.
    temp20-description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB2.0, Ethernet`.
    temp20-price = `170`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1055`.
    temp20-name = `Multi Print`.
    temp20-quantity = `16`.
    temp20-maincategory = `Printers & Scanners`.
    temp20-category = `Multifunction Printers`.
    temp20-suppliername = `Printer for All`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg`.
    temp20-description = `1000 dpi x 1000 dpi - up to 16 ppm (mono) / up to 15 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 1200dpi x 2400dpi)`.
    temp20-price = `99`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1056`.
    temp20-name = `Multi Color`.
    temp20-quantity = `5`.
    temp20-maincategory = `Printers & Scanners`.
    temp20-category = `Multifunction Printers`.
    temp20-suppliername = `Printer for All`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg`.
    temp20-description = `1200 dpi x 1200 dpi - up to 25 ppm (mono) / up to 24 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 2400dpi x 4800dpi, high resolution)`.
    temp20-price = `119`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1060`.
    temp20-name = `Cordless Mouse`.
    temp20-quantity = `25`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Mice`.
    temp20-suppliername = `Oxynum`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg`.
    temp20-description = `Cordless Optical USB Mice, Laptop, Color: Black, Plug&Play`.
    temp20-price = `9`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1061`.
    temp20-name = `Speed Mouse`.
    temp20-quantity = `12`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Mice`.
    temp20-suppliername = `Oxynum`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg`.
    temp20-description = `Optical USB, PS/2 Mouse, Color: Blue, 3-button-functionality (incl. Scroll wheel)`.
    temp20-price = `7`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1062`.
    temp20-name = `Track Mouse`.
    temp20-quantity = `12`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Mice`.
    temp20-suppliername = `Oxynum`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg`.
    temp20-description = `Optical USB Mouse, Color: Red, 5-button-functionality(incl. Scroll wheel), Plug&Play`.
    temp20-price = `11`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1063`.
    temp20-name = `Ergonomic Keyboard`.
    temp20-quantity = `50`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Keyboards`.
    temp20-suppliername = `Oxynum`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg`.
    temp20-description = `Ergonomic USB Keyboard for Desktop, Plug&Play`.
    temp20-price = `14`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1064`.
    temp20-name = `Internet Keyboard`.
    temp20-quantity = `35`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Keyboards`.
    temp20-suppliername = `Oxynum`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg`.
    temp20-description = `Corded Keyboard with special keys for Internet Usability, USB`.
    temp20-price = `16`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1065`.
    temp20-name = `Media Keyboard`.
    temp20-quantity = `26`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Keyboards`.
    temp20-suppliername = `Oxynum`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg`.
    temp20-description = `Corded Ergonomic Keyboard with special keys for Media Usability, USB`.
    temp20-price = `26`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1066`.
    temp20-name = `Mousepad`.
    temp20-quantity = `12`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Mousepads`.
    temp20-suppliername = `Oxynum`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg`.
    temp20-description = `Nice mouse pad with ITelO Logo`.
    temp20-price = `6.99`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1067`.
    temp20-name = `Ergo Mousepad`.
    temp20-quantity = `16`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Mousepads`.
    temp20-suppliername = `Oxynum`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg`.
    temp20-description = `Ergonomic mouse pad with ITelO Logo`.
    temp20-price = `8.99`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1068`.
    temp20-name = `Designer Mousepad`.
    temp20-quantity = `26`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Mousepads`.
    temp20-suppliername = `Fasttech`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg`.
    temp20-description = `ITelO Mousepad Special Edition`.
    temp20-price = `12.99`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1069`.
    temp20-name = `Universal card reader`.
    temp20-quantity = `22`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `Computer System Accessories`.
    temp20-suppliername = `Fasttech`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg`.
    temp20-description = `Universal card reader`.
    temp20-price = `14`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1070`.
    temp20-name = `Proctra X`.
    temp20-quantity = `15`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Graphic Cards`.
    temp20-suppliername = `Ultrasonic United`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg`.
    temp20-description = `Proctra X: PCI-E GDDR5 3072MB`.
    temp20-price = `70.9`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1071`.
    temp20-name = `Gladiator MX`.
    temp20-quantity = `16`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Graphic Cards`.
    temp20-suppliername = `Ultrasonic United`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg`.
    temp20-description = `Gladiator XLN: PCI-E GDDR5 3072MB DVI Out, TV Out low-noise`.
    temp20-price = `81.7`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1072`.
    temp20-name = `Hurricane GX`.
    temp20-quantity = `13`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Graphic Cards`.
    temp20-suppliername = `Ultrasonic United`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg`.
    temp20-description = `Hurricane GX: PCI-E 691 GFLOPS game-optimized`.
    temp20-price = `101.2`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1073`.
    temp20-name = `Hurricane GX/LN`.
    temp20-quantity = `5`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Graphic Cards`.
    temp20-suppliername = `Smartcards`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg`.
    temp20-description = `Hurricane GX/LN: PCI-E 691 GFLOPS game-optimized, low-noise.`.
    temp20-price = `139.99`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1080`.
    temp20-name = `Photo Scan`.
    temp20-quantity = `8`.
    temp20-maincategory = `Printers & Scanners`.
    temp20-category = `Scanners`.
    temp20-suppliername = `Printer for All`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg`.
    temp20-description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - Hi-Speed USB - Bluetooth`.
    temp20-price = `129`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1081`.
    temp20-name = `Power Scan`.
    temp20-quantity = `11`.
    temp20-maincategory = `Printers & Scanners`.
    temp20-category = `Scanners`.
    temp20-suppliername = `Printer for All`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg`.
    temp20-description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - SCSI for backward compatibility`.
    temp20-price = `89`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1082`.
    temp20-name = `Jet Scan Professional`.
    temp20-quantity = `13`.
    temp20-maincategory = `Printers & Scanners`.
    temp20-category = `Scanners`.
    temp20-suppliername = `Printer for All`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg`.
    temp20-description = `Flatbed scanner - Letter - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module`.
    temp20-price = `169`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1083`.
    temp20-name = `Jet Scan Professional`.
    temp20-quantity = `10`.
    temp20-maincategory = `Printers & Scanners`.
    temp20-category = `Scanners`.
    temp20-suppliername = `Printer for All`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg`.
    temp20-description = `Flatbed scanner - A4 - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module`.
    temp20-price = `189`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1085`.
    temp20-name = `Copymaster`.
    temp20-quantity = `10`.
    temp20-maincategory = `Printers & Scanners`.
    temp20-category = `Multifunction Printers`.
    temp20-suppliername = `Alpha Printers`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg`.
    temp20-description = `Copymaster`.
    temp20-price = `1499`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1090`.
    temp20-name = `Surround Sound`.
    temp20-quantity = `20`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Speakers`.
    temp20-suppliername = `Speaker Experts`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg`.
    temp20-description = `PC multimedia speakers - 5 Watt (Total)`.
    temp20-price = `39`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1091`.
    temp20-name = `Blaster Extreme`.
    temp20-quantity = `15`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Speakers`.
    temp20-suppliername = `Speaker Experts`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg`.
    temp20-description = `PC multimedia speakers - 10 Watt (Total) - 2-way`.
    temp20-price = `26`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1092`.
    temp20-name = `Sound Booster`.
    temp20-quantity = `50`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Speakers`.
    temp20-suppliername = `Speaker Experts`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg`.
    temp20-description = `PC multimedia speakers - optimized for Blutooth/A2DP`.
    temp20-price = `45`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1095`.
    temp20-name = `Lovely Sound 5.1 Wireless`.
    temp20-quantity = `12`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Fasttech`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg`.
    temp20-description = `5.1 Headset, 40 Hz-20 kHz, Wireless`.
    temp20-price = `49`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1096`.
    temp20-name = `Lovely Sound 5.1`.
    temp20-quantity = `18`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Fasttech`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg`.
    temp20-description = `5.1 Headset, 40 Hz-20 kHz, 3m cable`.
    temp20-price = `39`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1097`.
    temp20-name = `Lovely Sound Stereo`.
    temp20-quantity = `21`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Fasttech`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg`.
    temp20-description = `5.1 Headset, 40 Hz-20 kHz, 1m cable`.
    temp20-price = `29`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1100`.
    temp20-name = `Smart Office`.
    temp20-quantity = `25`.
    temp20-maincategory = `Software`.
    temp20-category = `Software`.
    temp20-suppliername = `Technocom`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg`.
    temp20-description = `Complete package, 1 User, Office Applications (word processing, spreadsheet, presentations)`.
    temp20-price = `89.9`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1101`.
    temp20-name = `Smart Design`.
    temp20-quantity = `26`.
    temp20-maincategory = `Software`.
    temp20-category = `Software`.
    temp20-suppliername = `Technocom`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg`.
    temp20-description = `Complete package, 1 User, Image editing, processing`.
    temp20-price = `79.9`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1102`.
    temp20-name = `Smart Network`.
    temp20-quantity = `28`.
    temp20-maincategory = `Software`.
    temp20-category = `Software`.
    temp20-suppliername = `Technocom`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg`.
    temp20-description = `Complete package, 1 User, Network Software Utilities, Useful Applications and Documentation`.
    temp20-price = `69`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1103`.
    temp20-name = `Smart Multimedia`.
    temp20-quantity = `9`.
    temp20-maincategory = `Software`.
    temp20-category = `Software`.
    temp20-suppliername = `Technocom`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg`.
    temp20-description = `Complete package, 1 User, different Multimedia applications, playing music, watching DVDs, only with this Smart package`.
    temp20-price = `77`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1104`.
    temp20-name = `Smart Games`.
    temp20-quantity = `13`.
    temp20-maincategory = `Software`.
    temp20-category = `Software`.
    temp20-suppliername = `Technocom`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg`.
    temp20-description = `Complete package, 1 User, various games for amusement, logic, action, jump&run`.
    temp20-price = `55`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1105`.
    temp20-name = `Smart Internet Antivirus`.
    temp20-quantity = `17`.
    temp20-maincategory = `Software`.
    temp20-category = `Software`.
    temp20-suppliername = `Brainsoft`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg`.
    temp20-description = `Complete package, 1 User, highly recommended for internet users as anti-virus protection`.
    temp20-price = `29`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1106`.
    temp20-name = `Smart Firewall`.
    temp20-quantity = `19`.
    temp20-maincategory = `Software`.
    temp20-category = `Software`.
    temp20-suppliername = `Brainsoft`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg`.
    temp20-description = `Complete package, 1 User, recommended for internet users, protect your PC against cyber-crime`.
    temp20-price = `34`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1107`.
    temp20-name = `Smart Money`.
    temp20-quantity = `18`.
    temp20-maincategory = `Software`.
    temp20-category = `Software`.
    temp20-suppliername = `Brainsoft`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg`.
    temp20-description = `Complete package, 1 User, bring your money in your mind, see what you have and what you want`.
    temp20-price = `29.9`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1110`.
    temp20-name = `PC Lock`.
    temp20-quantity = `14`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `Computer System Accessories`.
    temp20-suppliername = `Red Point Stores`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg`.
    temp20-description = `Robust 3m anti-burglary protection for your laptop computer`.
    temp20-price = `8.9`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1111`.
    temp20-name = `Notebook Lock`.
    temp20-quantity = `20`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `Computer System Accessories`.
    temp20-suppliername = `Red Point Stores`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg`.
    temp20-description = `Robust 1m anti-burglary protection for your desktop computer`.
    temp20-price = `6.9`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1112`.
    temp20-name = `Web cam reality`.
    temp20-quantity = `27`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `Computer System Accessories`.
    temp20-suppliername = `Red Point Stores`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg`.
    temp20-description = `Color webcam, color, High-Speed USB`.
    temp20-price = `39`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1113`.
    temp20-name = `Screen clean`.
    temp20-quantity = `17`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `Computer System Accessories`.
    temp20-suppliername = `Red Point Stores`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg`.
    temp20-description = `10 separately packed screen wipes`.
    temp20-price = `2.3`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1114`.
    temp20-name = `Fabric bag professional`.
    temp20-quantity = `14`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `Computer System Accessories`.
    temp20-suppliername = `Red Point Stores`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg`.
    temp20-description = `Notebook bag, plenty of room for stationery and writing materials`.
    temp20-price = `31`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1115`.
    temp20-name = `Wireless DSL Router`.
    temp20-quantity = `16`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Telecommunications`.
    temp20-suppliername = `Red Point Stores`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg`.
    temp20-description = `Wireless DSL Router (available in blue, black and silver)`.
    temp20-price = `49`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1116`.
    temp20-name = `Wireless DSL Router / Repeater`.
    temp20-quantity = `12`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Telecommunications`.
    temp20-suppliername = `Red Point Stores`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg`.
    temp20-description = `Wireless DSL Router / Repeater (available in blue, black and silver)`.
    temp20-price = `59`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1117`.
    temp20-name = `Wireless DSL Router / Repeater and Print Server`.
    temp20-quantity = `12`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Telecommunications`.
    temp20-suppliername = `Technocom`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg`.
    temp20-description = `Wireless DSL Router / Repeater and Print Server (available in blue, black and silver)`.
    temp20-price = `69`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1118`.
    temp20-name = `USB Stick`.
    temp20-quantity = `14`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `Computer System Accessories`.
    temp20-suppliername = `Technocom`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg`.
    temp20-description = `USB 2.0 High-Speed 64 GB`.
    temp20-price = `35`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1119`.
    temp20-name = `Travel Adapter`.
    temp20-quantity = `10`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Titanium`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg`.
    temp20-description = `Universal Travel Adapter`.
    temp20-price = `79`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1120`.
    temp20-name = `Cordless Bluetooth Keyboard, english international`.
    temp20-quantity = `13`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Keyboards`.
    temp20-suppliername = `Technocom`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg`.
    temp20-description = `Cordless Bluetooth Keyboard with English keys`.
    temp20-price = `29`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1137`.
    temp20-name = `Flat XXL`.
    temp20-quantity = `10`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Flat Screen Monitors`.
    temp20-suppliername = `Technocom`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg`.
    temp20-description = `Optimum Hi-Resolution max. 2048 × 1536 @ 85Hz, Dot Pitch: 0.24mm`.
    temp20-price = `1430`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1138`.
    temp20-name = `Pocket Mouse`.
    temp20-quantity = `20`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Mice`.
    temp20-suppliername = `Technocom`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg`.
    temp20-description = `Portable pocket Mouse with retracting cord`.
    temp20-price = `23`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1210`.
    temp20-name = `PC Power Station`.
    temp20-quantity = `22`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `PCs`.
    temp20-suppliername = `Technocom`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg`.
    temp20-description = `PC Power Station with 3,4 Ghz quad-core, 32 GB DDR3 SDRAM, feels like Available PC, Windows 8 Pro`.
    temp20-price = `2399`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1251`.
    temp20-name = `Astro Laptop 1516`.
    temp20-quantity = `23`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `Laptops`.
    temp20-suppliername = `Ultrasonic United`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg`.
    temp20-description = `Flexible Laptop with 2,5 GHz Quad Core, 15" HD TN, 16 GB DDR SDRAM, 256 GB SSD, Windows 10 Pro`.
    temp20-price = `989`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1252`.
    temp20-name = `Astro Phone 6`.
    temp20-quantity = `28`.
    temp20-maincategory = `Smartphones & Tablets`.
    temp20-category = `Smartphones and Tablets`.
    temp20-suppliername = `Ultrasonic United`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg`.
    temp20-description = `6 inch 1280x800 HD display (216 ppi), Quad-core processor, 8 GB internal storage (actual formatted capacity will be less), 3050 mAh battery (Up to 8 hours of active use), grey or black`.
    temp20-price = `649`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1253`.
    temp20-name = `Benda Laptop 1408`.
    temp20-quantity = `27`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `Laptops`.
    temp20-suppliername = `Ultrasonic United`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg`.
    temp20-description = `Flexible Laptop with 2,5 GHz Dual Core, 14" HD+ TN, 8 GB DDR SDRAM, 324 GB SSD, Windows 10 Pro`.
    temp20-price = `976`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1254`.
    temp20-name = `Bending Screen 21HD`.
    temp20-quantity = `23`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Flat Screens`.
    temp20-suppliername = `Ultrasonic United`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg`.
    temp20-description = `Optimum Hi-Resolution Widescreen max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub`.
    temp20-price = `250`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1255`.
    temp20-name = `Broad Screen 22HD`.
    temp20-quantity = `5`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Flat Screens`.
    temp20-suppliername = `Ultrasonic United`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg`.
    temp20-description = `Optimum Hi-Resolution Widescreen max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub`.
    temp20-price = `270`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1256`.
    temp20-name = `Cerdik Phone 7`.
    temp20-quantity = `19`.
    temp20-maincategory = `Smartphones & Tablets`.
    temp20-category = `Smartphones and Tablets`.
    temp20-suppliername = `Ultrasonic United`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg`.
    temp20-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black`.
    temp20-price = `549`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1257`.
    temp20-name = `Cepat Tablet 10.5`.
    temp20-quantity = `17`.
    temp20-maincategory = `Smartphones & Tablets`.
    temp20-category = `Smartphones and Tablets`.
    temp20-suppliername = `Ultrasonic United`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg`.
    temp20-description = `10.5-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor`.
    temp20-price = `549`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1258`.
    temp20-name = `Cepat Tablet 8`.
    temp20-quantity = `24`.
    temp20-maincategory = `Smartphones & Tablets`.
    temp20-category = `Smartphones and Tablets`.
    temp20-suppliername = `Ultrasonic United`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg`.
    temp20-description = `8-inch Multitouch HD Screen (2000 x 1500) 32GB Internal Memory, Wireless N Wi-Fi, Bluetooth, GPS Enabled, 1.5 GHz Quad-Core Processor`.
    temp20-price = `529`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1500`.
    temp20-name = `Server Basic`.
    temp20-quantity = `24`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `Servers`.
    temp20-suppliername = `Technocom`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg`.
    temp20-description = `Dual socket, quad-core processing server with 1333 MHz Front Side Bus with 10Gb connectivity`.
    temp20-price = `5000`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1501`.
    temp20-name = `Server Professional`.
    temp20-quantity = `26`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `Servers`.
    temp20-suppliername = `Technocom`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg`.
    temp20-description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 10Gb connectivity`.
    temp20-price = `15000`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1502`.
    temp20-name = `Server Power Pro`.
    temp20-quantity = `34`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `Servers`.
    temp20-suppliername = `Technocom`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg`.
    temp20-description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 100Gb connectivity`.
    temp20-price = `25000`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1600`.
    temp20-name = `Family PC Basic`.
    temp20-quantity = `10`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `Desktop Computers`.
    temp20-suppliername = `Titanium`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg`.
    temp20-description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Graphic Card: Proctra X, Windows 8`.
    temp20-price = `600`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1601`.
    temp20-name = `Family PC Pro`.
    temp20-quantity = `20`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `Desktop Computers`.
    temp20-suppliername = `Titanium`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg`.
    temp20-description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8`.
    temp20-price = `900`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1602`.
    temp20-name = `Gaming Monster`.
    temp20-quantity = `24`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `Desktop Computers`.
    temp20-suppliername = `Titanium`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg`.
    temp20-description = `3,4 Ghz quad core, 8 GB DDR3 SDRAM, 2000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8`.
    temp20-price = `1200`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-1603`.
    temp20-name = `Gaming Monster Pro`.
    temp20-quantity = `25`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `Desktop Computers`.
    temp20-suppliername = `Titanium`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg`.
    temp20-description = `3,4 Ghz quad core, 16 GB DDR3 SDRAM, 4000 GB Hard Disc, Graphic Card: Hurricane GX, Windows 8`.
    temp20-price = `1700`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-2000`.
    temp20-name = `7" Widescreen Portable DVD Player w MP3`.
    temp20-quantity = `20`.
    temp20-maincategory = `TV, Video & HiFi`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Titanium`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg`.
    temp20-description = `7" LCD Screen, storage battery holds up to 6 hours!`.
    temp20-price = `249.99`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-2001`.
    temp20-name = `10" Portable DVD player`.
    temp20-quantity = `21`.
    temp20-maincategory = `TV, Video & HiFi`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Titanium`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg`.
    temp20-description = `10" LCD Screen, storage battery holds up to 8 hours`.
    temp20-price = `449.99`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-2002`.
    temp20-name = `Portable DVD Player with 9" LCD Monitor`.
    temp20-quantity = `50`.
    temp20-maincategory = `TV, Video & HiFi`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Technocom`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg`.
    temp20-description = `9" LCD Screen, storage holds up to 8 hours, 2 speakers included`.
    temp20-price = `853.99`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-2025`.
    temp20-name = `CD/DVD case: 264 sleeves`.
    temp20-quantity = `26`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Titanium`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg`.
    temp20-description = `Organizer and protective case for 264 CDs and DVDs`.
    temp20-price = `44.99`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-2026`.
    temp20-name = `Audio/Video Cable Kit - 4m`.
    temp20-quantity = `16`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Titanium`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg`.
    temp20-description = `Quality cables for notebooks and projectors`.
    temp20-price = `29.99`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-2027`.
    temp20-name = `Removable CD/DVD Laser Labels`.
    temp20-quantity = `25`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Titanium`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg`.
    temp20-description = `Removable jewel case labels, zero residues (100)`.
    temp20-price = `8.99`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-6100`.
    temp20-name = `Beam Breaker B-1`.
    temp20-quantity = `32`.
    temp20-maincategory = `TV, Video & HiFi`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Titanium`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg`.
    temp20-description = `720p, DLP Projector max. 8,45 Meter, 2D`.
    temp20-price = `469`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-6101`.
    temp20-name = `Beam Breaker B-2`.
    temp20-quantity = `18`.
    temp20-maincategory = `TV, Video & HiFi`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Technocom`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg`.
    temp20-description = `1080p, DLP max.9,34 Meter, 2D-ready`.
    temp20-price = `679`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-6102`.
    temp20-name = `Beam Breaker B-3`.
    temp20-quantity = `16`.
    temp20-maincategory = `TV, Video & HiFi`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Technocom`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg`.
    temp20-description = `1080p, DLP max. 12,3 Meter, 3D-ready`.
    temp20-price = `889`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-6110`.
    temp20-name = `Play Movie`.
    temp20-quantity = `15`.
    temp20-maincategory = `TV, Video & HiFi`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Fasttech`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg`.
    temp20-description = `CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid`.
    temp20-price = `130`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-6111`.
    temp20-name = `Record Movie`.
    temp20-quantity = `24`.
    temp20-maincategory = `TV, Video & HiFi`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Fasttech`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg`.
    temp20-description = `160 GB HDD, CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid`.
    temp20-price = `288`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-6120`.
    temp20-name = `ITelo MusicStick`.
    temp20-quantity = `15`.
    temp20-maincategory = `TV, Video & HiFi`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Fasttech`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg`.
    temp20-description = `64 GB USB Music-on-Available-Stick`.
    temp20-price = `45`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-6121`.
    temp20-name = `ITelo Jog-Mate`.
    temp20-quantity = `24`.
    temp20-maincategory = `TV, Video & HiFi`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Fasttech`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg`.
    temp20-description = `ITelo Jog-Mate 64 GB HDD and Color Display, can play movies`.
    temp20-price = `63`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-6122`.
    temp20-name = `Power Pro Player 40`.
    temp20-quantity = `23`.
    temp20-maincategory = `TV, Video & HiFi`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Fasttech`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg`.
    temp20-description = `MP3-Player with 40 GB HDD and Color Display, can play movies`.
    temp20-price = `167`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-6123`.
    temp20-name = `Power Pro Player 80`.
    temp20-quantity = `13`.
    temp20-maincategory = `TV, Video & HiFi`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Fasttech`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg`.
    temp20-description = `MP3-Player with 80 GB SSD and Color Display, can play movies`.
    temp20-price = `299`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-6130`.
    temp20-name = `Flat Watch HD32`.
    temp20-quantity = `16`.
    temp20-maincategory = `TV, Video & HiFi`.
    temp20-category = `Flat Screen TVs`.
    temp20-suppliername = `Very Best Screens`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg`.
    temp20-description = `32-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    temp20-price = `1459`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-6131`.
    temp20-name = `Flat Watch HD37`.
    temp20-quantity = `14`.
    temp20-maincategory = `TV, Video & HiFi`.
    temp20-category = `Flat Screen TVs`.
    temp20-suppliername = `Very Best Screens`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg`.
    temp20-description = `37-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    temp20-price = `1199`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-6132`.
    temp20-name = `Flat Watch HD41`.
    temp20-quantity = `13`.
    temp20-maincategory = `TV, Video & HiFi`.
    temp20-category = `Flat Screen TVs`.
    temp20-suppliername = `Very Best Screens`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg`.
    temp20-description = `41-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    temp20-price = `899`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-7000`.
    temp20-name = `Copperberry`.
    temp20-quantity = `5`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Fasttech`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg`.
    temp20-description = `Our new multifunctional Handheld with phone function in copper`.
    temp20-price = `549`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-7010`.
    temp20-name = `Silverberry`.
    temp20-quantity = `9`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Fasttech`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg`.
    temp20-description = `Our new multifunctional Handheld with phone function in silver`.
    temp20-price = `549`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-7020`.
    temp20-name = `Goldberry`.
    temp20-quantity = `11`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Fasttech`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg`.
    temp20-description = `Our new multifunctional Handheld with phone function in gold`.
    temp20-price = `549`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-7030`.
    temp20-name = `Platinberry`.
    temp20-quantity = `12`.
    temp20-maincategory = `Computer Components`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Fasttech`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg`.
    temp20-description = `Our new multifunctional Handheld with phone function in platinum`.
    temp20-price = `549`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-8000`.
    temp20-name = `ITelO FlexTop I4000`.
    temp20-quantity = `11`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `Laptops`.
    temp20-suppliername = `Titanium`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg`.
    temp20-description = `Notebook with 2,80 GHz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8`.
    temp20-price = `799`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-8001`.
    temp20-name = `ITelO FlexTop I6300c`.
    temp20-quantity = `20`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `Laptops`.
    temp20-suppliername = `Titanium`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg`.
    temp20-description = `Notebook with 2,80 GHz dual core, 8 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8`.
    temp20-price = `799`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-8002`.
    temp20-name = `ITelO FlexTop I9100`.
    temp20-quantity = `20`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `Laptops`.
    temp20-suppliername = `Titanium`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg`.
    temp20-description = `Notebook with 2,80 GHz quad core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8`.
    temp20-price = `1199`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-8003`.
    temp20-name = `ITelO FlexTop I9800`.
    temp20-quantity = `22`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `Laptops`.
    temp20-suppliername = `Titanium`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg`.
    temp20-description = `Notebook with 2,80 GHz quad core, 8 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8`.
    temp20-price = `1388`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-9991`.
    temp20-name = `Smartphone Leather Case`.
    temp20-quantity = `12`.
    temp20-maincategory = `Smartphones & Tablets`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Ultrasonic United`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg`.
    temp20-description = `Button Clasp, Quality Material, 100% Leather, compatible with many smartphone models`.
    temp20-price = `25`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-9992`.
    temp20-name = `Smartphone Alpha`.
    temp20-quantity = `13`.
    temp20-maincategory = `Smartphones & Tablets`.
    temp20-category = `Smartphones and Tablets`.
    temp20-suppliername = `Ultrasonic United`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg`.
    temp20-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black`.
    temp20-price = `599`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-9993`.
    temp20-name = `Mini Tablet`.
    temp20-quantity = `10`.
    temp20-maincategory = `Smartphones & Tablets`.
    temp20-category = `Smartphones and Tablets`.
    temp20-suppliername = `Ultrasonic United`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg`.
    temp20-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage, 4325 mAh battery (Up to 8 hours of active use)`.
    temp20-price = `833`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-9994`.
    temp20-name = `Camcorder View`.
    temp20-quantity = `50`.
    temp20-maincategory = `TV, Video & HiFi`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Ultrasonic United`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg`.
    temp20-description = `1920x1080 Full HD, image stabilization reduces blur, 27x Optical / 32x Extended Zoom, wide angle Lens, 2.7" wide LCD display`.
    temp20-price = `1388`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-9995`.
    temp20-name = `Tablet Pouch`.
    temp20-quantity = `34`.
    temp20-maincategory = `Smartphones & Tablets`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Titanium`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg`.
    temp20-description = `Stylish tablet pouch, protects from scratches, color: black`.
    temp20-price = `20`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-9996`.
    temp20-name = `Tablet Pouch`.
    temp20-quantity = `34`.
    temp20-maincategory = `Smartphones & Tablets`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Titanium`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg`.
    temp20-description = `Stylish tablet pouch, protects from scratches, color: black`.
    temp20-price = `20`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-9997`.
    temp20-name = `e-Book Reader ReadMe`.
    temp20-quantity = `23`.
    temp20-maincategory = `Smartphones & Tablets`.
    temp20-category = `Smartphones and Tablets`.
    temp20-suppliername = `Titanium`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg`.
    temp20-description = `6-Inch E Ink Screen, Access To e-book Store, Adjustable Font Styles and Sizes, Stores Up To 1,000 Books`.
    temp20-price = `33`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-9998`.
    temp20-name = `Smartphone Beta`.
    temp20-quantity = `21`.
    temp20-maincategory = `Smartphones & Tablets`.
    temp20-category = `Smartphones and Tablets`.
    temp20-suppliername = `Titanium`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg`.
    temp20-description = `5 Megapixel Camera, Wi-Fi 802.11 b/g/n, Bluetooth, GPS Available-GPS support`.
    temp20-price = `30`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `HT-9999`.
    temp20-name = `Maxi Tablet`.
    temp20-quantity = `20`.
    temp20-maincategory = `Smartphones & Tablets`.
    temp20-category = `Tablets`.
    temp20-suppliername = `Titanium`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg`.
    temp20-description = `10.1-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor`.
    temp20-price = `749`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    temp20-productid = `PF-1000`.
    temp20-name = `Flyer`.
    temp20-quantity = `33`.
    temp20-maincategory = `Computer Systems`.
    temp20-category = `Accessories`.
    temp20-suppliername = `Titanium`.
    temp20-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg`.
    temp20-description = `Flyer for our product palette`.
    temp20-price = `0`.
    temp20-currencycode = `EUR`.
    INSERT temp20 INTO TABLE temp19.
    t_products = temp19.

  ENDMETHOD.

ENDCLASS.
