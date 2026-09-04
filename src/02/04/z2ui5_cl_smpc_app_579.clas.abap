" @keywords flexiblecolumnlayout flexible column layout sap.f flexiblecolumnlayoutwithonecolumnstart flexiblecolumnlayoutdata flexiblecolumnlayoutdatafordesktop flexiblecolumnlayoutdatafortablet dynamicpage dynamicpagetitle title
" @summary Flexible Column Layout as an app with routing that starts with a single initial column.
CLASS z2ui5_cl_smpc_app_579 DEFINITION PUBLIC.

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
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.
    TYPES: BEGIN OF ty_s_supplier,
             text TYPE string,
           END OF ty_s_supplier.
    TYPES ty_t_supplier TYPE STANDARD TABLE OF ty_s_supplier WITH DEFAULT KEY.

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

    " the columnsDistribution model: the sample seeds three sizes and leaves the
    " rest to the control's own defaults, which are seeded explicitly here
    DATA desktop_two_begin       TYPE string VALUE `67/33/0`.
    DATA desktop_two_mid         TYPE string VALUE `25/75/0`.
    DATA desktop_three_begin_end TYPE string VALUE `67/33/0`.
    DATA desktop_three_end       TYPE string VALUE `25/25/50`.
    DATA desktop_three_mid       TYPE string VALUE `25/50/25`.
    DATA desktop_three_mid_end   TYPE string VALUE `33/67/0`.
    DATA tablet_two_begin        TYPE string VALUE `67/33/0`.
    DATA tablet_two_mid          TYPE string VALUE `40/60/0`.
    DATA tablet_three_begin_end  TYPE string VALUE `67/33/0`.
    DATA tablet_three_end        TYPE string VALUE `0/33/67`.
    DATA tablet_three_mid        TYPE string VALUE `20/60/20`.
    DATA tablet_three_mid_end    TYPE string VALUE `33/67/0`.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    " the router state the original keeps (currentRouteName + the route's
    " arguments): the original routes by INDEX into the mock collections
    DATA route       TYPE string VALUE `list`.
    DATA product_ix  TYPE i.
    DATA supplier_ix TYPE i.

    METHODS view_display.
    METHODS on_event.
    METHODS detail_bind IMPORTING productid TYPE string.
    METHODS hash_apply IMPORTING iv_hash TYPE string.
    METHODS hash_push IMPORTING check_replace TYPE abap_bool OPTIONAL.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_579 IMPLEMENTATION.

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
    DATA detail_title TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA sections TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA end_column TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp3 TYPE string_table.
    DATA temp5 TYPE string_table.
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
        )->a( n = `xmlns:form`  v = `sap.ui.layout.form`
        )->a( n = `xmlns:mvc`   v = `sap.ui.core.mvc`
        )->a( n = `xmlns:uxap`  v = `sap.uxap`

        )->ele( n = `FlexibleColumnLayout` ns = `f`
            )->a( n = `id`                           v = `fcl`
            )->a( n = `autoFocus`                    v = `false`
            )->a( n = `restoreFocusOnBackNavigation` v = `true`
            )->a( n = `backgroundDesign`             v = `Translucent`
            " the original wires stateChange to onStateChanged: only a layout
            " change by a NAVIGATION ARROW replace-navTo's the URL - the flag
            " and the new layout travel with the event, the backend guards on it
            )->a( n = `stateChange`      v = client->_event( val = `STATE_CHANGED` t_arg = temp1 )
            )->a( n = `layout`                       v = client->_bind( layout ) ).

    " the per-device column sizes the sample keeps in its own model
    fcl->ele( n = `layoutData` ns = `f`
        )->ele( n = `FlexibleColumnLayoutData` ns = `f`

            )->ele( n = `desktopLayoutData` ns = `f`
                )->tag( n = `FlexibleColumnLayoutDataForDesktop` ns = `f`
                    )->a( n = `twoColumnsBeginExpanded`            v = client->_bind( desktop_two_begin )
                    )->a( n = `twoColumnsMidExpanded`              v = client->_bind( desktop_two_mid )
                    )->a( n = `threeColumnsBeginExpandedEndHidden` v = client->_bind( desktop_three_begin_end )
                    )->a( n = `threeColumnsEndExpanded`            v = client->_bind( desktop_three_end )
                    )->a( n = `threeColumnsMidExpanded`            v = client->_bind( desktop_three_mid )
                    )->a( n = `threeColumnsMidExpandedEndHidden`   v = client->_bind( desktop_three_mid_end )

            )->end(
            )->ele( n = `tabletLayoutData` ns = `f`
                )->tag( n = `FlexibleColumnLayoutDataForTablet` ns = `f`
                    )->a( n = `twoColumnsBeginExpanded`            v = client->_bind( tablet_two_begin )
                    )->a( n = `twoColumnsMidExpanded`              v = client->_bind( tablet_two_mid )
                    )->a( n = `threeColumnsBeginExpandedEndHidden` v = client->_bind( tablet_three_begin_end )
                    )->a( n = `threeColumnsEndExpanded`            v = client->_bind( tablet_three_end )
                    )->a( n = `threeColumnsMidExpanded`            v = client->_bind( tablet_three_mid )
                    )->a( n = `threeColumnsMidExpandedEndHidden`   v = client->_bind( tablet_three_mid_end )

            )->end(
        )->end(
    )->end( ).

    " List.view.xml
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
                    )->a( n = `id`    v = `productsTable`
                    )->a( n = `mode`  v = `SingleSelectMaster`
                    )->a( n = `inset` v = `false`
                    )->a( n = `class` v = `sapFDynamicPageAlignContent`
                    )->a( n = `width` v = `auto`
                    )->a( n = `items` v = client->_bind( t_rows )
                    )->a( n = `itemPress` v = client->_event( val = `LIST_ITEM` arg = `${$parameters>/listItem}.getBindingContext().getProperty('PRODUCTID')` )

                    )->ele( `headerToolbar`
                        )->ele( `OverflowToolbar`
                            )->tag( `ToolbarSpacer`
                            )->tag( `SearchField`
                                )->a( n = `width`  v = `17.5rem`
                                )->a( n = `search` v = client->_event( val = `SEARCH` arg = `${$parameters>/query}` )
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
    
    detail = fcl->ele( n = `midColumnPages` ns = `f`
        )->ele( n = `ObjectPageLayout` ns = `uxap`
            )->a( n = `id`                          v = `ObjectPageLayout`
            )->a( n = `showTitleInHeaderContent`    v = `true`
            )->a( n = `alwaysShowContentHeader`     v = `false`
            )->a( n = `preserveHeaderStateOnScroll` v = `false`
            )->a( n = `headerContentPinnable`       v = `true`
            )->a( n = `isChildPage`                 v = `true`
            )->a( n = `upperCaseAnchorBar`          v = `false` ).

    
    detail_title = detail->ele( n = `headerTitle` ns = `uxap`
        )->ele( n = `ObjectPageDynamicHeaderTitle` ns = `uxap` ).

    detail_title->ele( n = `expandedHeading` ns = `uxap`
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

    
    sections = detail->ele( n = `sections` ns = `uxap` ).

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
                        )->a( n = `itemPress` v = client->_event( val = `SUPPLIER_ITEM` arg = `${$parameters>/listItem}.getBindingContext().getProperty('TEXT')` )

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
    
    end_column = fcl->ele( n = `endColumnPages` ns = `f` ).

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
                )->ele( n = `navigationActions` ns = `f`
                    )->tag( `OverflowToolbarButton`
                        )->a( n = `type`    v = `Transparent`
                        )->a( n = `icon`    v = `sap-icon://decline`
                        )->a( n = `tooltip` v = `Close about page`
                        " AboutPage.controller's handleClose is
                        " window.history.go(-1): one real step back - the
                        " hash change then round-trips as HASH_CHANGED
                        )->a( n = `press`   v = client->follow_up_action( client->cs_event-hash_back )

                )->end(
            )->end(
        )->end(
    )->end( ).

    client->view_display( view->stringify( ) ).
    " Component.js: oProductsModel.setSizeLimit(1000) - the collection is 123 rows
    " and the JSONModel caps a bound aggregation at 100, so the table would stop 23
    " rows short of the count its own title reports
    
    CLEAR temp3.
    INSERT `1000` INTO TABLE temp3.
    INSERT client->cs_view-main INTO TABLE temp3.
    client->follow_up_action( val   = client->cs_event-set_size_limit
                              t_arg = temp3 ).

    " the original's router, app-owned: the hash carries the route the way
    " the manifest patterns spell it, and a hash change the app did not
    " write (browser Back/Forward, a manual edit) round-trips as
    " HASH_CHANGED. Re-asserted per render - it dies with an app switch
    
    CLEAR temp5.
    INSERT `HASH_CHANGED` INTO TABLE temp5.
    client->follow_up_action( val   = client->cs_event-hash_attach_changed
                              t_arg = temp5 ).

  ENDMETHOD.


  METHOD detail_bind.

    " Detail.controller's bindElement( '/ProductCollection/<n>' ) - the relative
    " bindings of the original resolve against the bound element, the port folds
    " them to root-seeded fields (app 229 idiom)
    FIELD-SYMBOLS <product> TYPE z2ui5_cl_smpc_app_579=>ty_s_product.
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


  METHOD on_event.
        DATA query TYPE string.
          DATA product LIKE LINE OF t_products.
        DATA temp1 TYPE xsdboolean.

    CASE client->get_event( ).

      WHEN `LIST_ITEM`.
        " onListItemPress: navTo('detail') - the helper's next state for
        " level 1 opens the mid column, the route carries the product INDEX
        detail_bind( client->get_event_arg( ) ).
        READ TABLE t_products WITH KEY productid = client->get_event_arg( ) TRANSPORTING NO FIELDS.
        IF sy-subrc = 0.
          product_ix = sy-tabix - 1.
        ENDIF.
        route  = `detail`.
        layout = `TwoColumnsMidExpanded`.
        hash_push( ).

      WHEN `SUPPLIER_ITEM`.
        " handleItemPress: navTo('detailDetail') - level 2 opens the end column
        dd_text = client->get_event_arg( ).
        READ TABLE t_suppliers WITH KEY text = dd_text TRANSPORTING NO FIELDS.
        IF sy-subrc = 0.
          supplier_ix = sy-tabix - 1.
        ENDIF.
        route  = `detailDetail`.
        layout = `ThreeColumnsMidExpanded`.
        hash_push( ).

      WHEN `ABOUT`.
        " handleAboutPress: navTo('page2') - the about page, full screen in
        " the end column
        route  = `page2`.
        layout = `EndColumnFullScreen`.
        hash_push( ).

      WHEN `MID_FULL_SCREEN`.
        route  = `detail`.
        layout = `MidColumnFullScreen`.
        hash_push( ).

      WHEN `MID_EXIT_FULL_SCREEN`.
        route  = `detail`.
        layout = `TwoColumnsMidExpanded`.
        hash_push( ).

      WHEN `MID_CLOSE`.
        " handleClose: navTo('list') - the ':layout:' route
        route  = `list`.
        layout = `OneColumn`.
        hash_push( ).

      WHEN `END_FULL_SCREEN`.
        route  = `detailDetail`.
        layout = `EndColumnFullScreen`.
        hash_push( ).

      WHEN `END_EXIT_FULL_SCREEN`.
        route  = `detailDetail`.
        layout = `ThreeColumnsMidExpanded`.
        hash_push( ).

      WHEN `END_CLOSE`.
        route  = `detail`.
        layout = `TwoColumnsMidExpanded`.
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
        " the router's routeMatched: derive route, indices and layout from
        " the hash this request carries. The instance itself is untouched,
        " so search text and sort order survive like in the original
        hash_apply( client->get( )-s_config-hash ).

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

      WHEN `SORT`.
        " onSort flips the Name sorter; a thin frontend sorts the data it sends
        
        temp1 = boolc( descending = abap_false ).
        descending = temp1.
        IF descending = abap_true.
          SORT t_rows BY name DESCENDING.
        ELSE.
          SORT t_rows BY name ASCENDING.
        ENDIF.

      WHEN `ADD`.
        " onAdd: MessageBox.show( 'This functionality is not ready yet.' )
        client->message_box_display( text  = `This functionality is not ready yet.`
                                     type  = `information`
                                     title = `Aw, Snap!` ).

    ENDCASE.

  ENDMETHOD.


  METHOD hash_apply.

    " the router's routeMatched, read side: parse the app hash back into
    " route, indices and layout. The original's patterns: '' (list start),
    " '{layout}' (the ':layout:' list route), 'page2',
    " 'detail/{product}/{layout}',
    " 'detailDetail/{product}/{supplier}/{layout}' - product/supplier are
    " INDICES into the mock collections, defaulting to 0 like the original's
    " `arguments.product || this._product || "0"`
    DATA lv_hash LIKE iv_hash.
    DATA lt_seg TYPE STANDARD TABLE OF string WITH DEFAULT KEY.
    DATA temp7 TYPE string.
    DATA temp8 TYPE string.
    DATA lv_p LIKE temp7.
    DATA temp9 TYPE string.
    DATA temp10 TYPE string.
    DATA lv_s LIKE temp9.
    DATA temp11 TYPE string.
    DATA temp12 TYPE string.
        DATA temp13 TYPE i.
        DATA temp14 TYPE string.
          DATA temp15 LIKE LINE OF t_products.
          DATA temp16 LIKE sy-tabix.
        DATA temp17 TYPE i.
        DATA temp18 TYPE i.
        DATA temp19 TYPE string.
        DATA temp20 TYPE string.
        DATA temp1 TYPE string.
          DATA temp2 LIKE LINE OF lt_seg.
          DATA temp3 LIKE sy-tabix.
          DATA temp21 LIKE LINE OF t_products.
          DATA temp22 LIKE sy-tabix.
          DATA temp23 LIKE LINE OF t_suppliers.
          DATA temp24 LIKE sy-tabix.
        DATA temp25 LIKE LINE OF lt_seg.
        DATA temp26 LIKE sy-tabix.
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
    
    lv_s = temp9.

    
    CLEAR temp11.
    
    READ TABLE lt_seg INTO temp12 INDEX 1.
    IF sy-subrc = 0.
      temp11 = temp12.
    ENDIF.
    CASE temp11.
      WHEN ``.
        route  = `list`.
        layout = `OneColumn`.

      WHEN `page2`.
        route  = `page2`.
        layout = `EndColumnFullScreen`.

      WHEN `detail`.
        route      = `detail`.
        
        IF lv_p CO `0123456789` AND lv_p IS NOT INITIAL AND strlen( lv_p ) <= 4.
          temp13 = lv_p.
        ELSE.
          CLEAR temp13.
        ENDIF.
        product_ix = temp13.
        
        IF lv_s IS NOT INITIAL.
          temp14 = lv_s.
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

      WHEN `detailDetail`.
        route       = `detailDetail`.
        
        IF lv_p CO `0123456789` AND lv_p IS NOT INITIAL AND strlen( lv_p ) <= 4.
          temp17 = lv_p.
        ELSE.
          CLEAR temp17.
        ENDIF.
        product_ix  = temp17.
        
        IF lv_s CO `0123456789` AND lv_s IS NOT INITIAL AND strlen( lv_s ) <= 4.
          temp18 = lv_s.
        ELSE.
          CLEAR temp18.
        ENDIF.
        supplier_ix = temp18.
        
        CLEAR temp19.
        
        READ TABLE lt_seg INTO temp20 INDEX 4.
        IF sy-subrc = 0.
          temp19 = temp20.
        ENDIF.
        
        IF temp19 IS NOT INITIAL.
          
          
          temp3 = sy-tabix.
          READ TABLE lt_seg INDEX 4 INTO temp2.
          sy-tabix = temp3.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          temp1 = temp2.
        ELSE.
          temp1 = `ThreeColumnsMidExpanded`.
        ENDIF.
        layout      = temp1.
        IF product_ix < lines( t_products ).
          
          
          temp22 = sy-tabix.
          READ TABLE t_products INDEX product_ix + 1 INTO temp21.
          sy-tabix = temp22.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          detail_bind( temp21-productid ).
        ENDIF.
        IF supplier_ix < lines( t_suppliers ).
          
          
          temp24 = sy-tabix.
          READ TABLE t_suppliers INDEX supplier_ix + 1 INTO temp23.
          sy-tabix = temp24.
          IF sy-subrc <> 0.
            ASSERT 1 = 0.
          ENDIF.
          dd_text = temp23-text.
        ENDIF.

      WHEN OTHERS.
        " the single-segment ':layout:' list route, e.g. '#/OneColumn'
        route  = `list`.
        
        
        temp26 = sy-tabix.
        READ TABLE lt_seg INDEX 1 INTO temp25.
        sy-tabix = temp26.
        IF sy-subrc <> 0.
          ASSERT 1 = 0.
        ENDIF.
        layout = temp25.
    ENDCASE.

  ENDMETHOD.


  METHOD hash_push.

    DATA lv_hash TYPE string.
    " the router's navTo, write side: compose the current route the way the
    " manifest patterns spell it and push it as the app-owned hash
    CASE route.
      WHEN `detail`.
        lv_hash = |/detail/{ product_ix }/{ layout }|.
      WHEN `detailDetail`.
        lv_hash = |/detailDetail/{ product_ix }/{ supplier_ix }/{ layout }|.
      WHEN `page2`.
        lv_hash = `/page2`.
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
    " carries NO sorter, so the backend owns the order. Do not add one: a
    " declared sorter is re-applied by JSONListBinding.update on every model
    " change (ClientListBinding.applySort), so it becomes the primary key and
    " the ABAP order survives only as a tiebreak - which is exactly what made
    " the Sort button unable to sort here
    DATA temp27 TYPE z2ui5_cl_smpc_app_579=>ty_t_product.
    DATA temp28 LIKE LINE OF temp27.
    DATA temp29 TYPE z2ui5_cl_smpc_app_579=>ty_t_supplier.
    DATA temp30 LIKE LINE OF temp29.
    CLEAR temp27.
    
    temp28-productid = `HT-1000`.
    temp28-name = `Notebook Basic 15`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `Laptops`.
    temp28-suppliername = `Very Best Screens`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`.
    temp28-description = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.
    temp28-price = `956`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1001`.
    temp28-name = `Notebook Basic 17`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `Laptops`.
    temp28-suppliername = `Very Best Screens`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg`.
    temp28-description = `Notebook Basic 17 with 2,80 GHz quad core, 17" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.
    temp28-price = `1249`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1002`.
    temp28-name = `Notebook Basic 18`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `Laptops`.
    temp28-suppliername = `Very Best Screens`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg`.
    temp28-description = `Notebook Basic 18 with 2,80 GHz quad core, 18" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`.
    temp28-price = `1570`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1003`.
    temp28-name = `Notebook Basic 19`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `Laptops`.
    temp28-suppliername = `Smartcards`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg`.
    temp28-description = `Notebook Basic 19 with 2,80 GHz quad core, 19" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`.
    temp28-price = `1650`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1007`.
    temp28-name = `ITelO Vault`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Technocom`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg`.
    temp28-description = `Digital Organizer with State-of-the-Art Storage Encryption`.
    temp28-price = `299`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1010`.
    temp28-name = `Notebook Professional 15`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Very Best Screens`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg`.
    temp28-description = `Notebook Professional 15 with 2,80 GHz quad core, 15" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro`.
    temp28-price = `1999`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1011`.
    temp28-name = `Notebook Professional 17`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `Laptops`.
    temp28-suppliername = `Very Best Screens`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg`.
    temp28-description = `Notebook Professional 17 with 2,80 GHz quad core, 17" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro`.
    temp28-price = `2299`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1020`.
    temp28-name = `ITelO Vault Net`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Technocom`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg`.
    temp28-description = `Digital Organizer with State-of-the-Art Encryption for Storage and Network Communications`.
    temp28-price = `459`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1021`.
    temp28-name = `ITelO Vault SAT`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Technocom`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg`.
    temp28-description = `Digital Organizer with State-of-the-Art Encryption for Storage and Secure Stellite Link`.
    temp28-price = `149`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1022`.
    temp28-name = `Comfort Easy`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Technocom`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg`.
    temp28-description = `32 GB Digital Assistant with high-resolution color screen`.
    temp28-price = `1679`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1023`.
    temp28-name = `Comfort Senior`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Technocom`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1023.jpg`.
    temp28-description = `64 GB Digital Assistant with high-resolution color screen and synthesized voice output`.
    temp28-price = `512`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1030`.
    temp28-name = `Ergo Screen E-I`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Flat Screen Monitors`.
    temp28-suppliername = `Very Best Screens`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1030.jpg`.
    temp28-description = `Optimum Hi-Resolution max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm`.
    temp28-price = `230`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1031`.
    temp28-name = `Ergo Screen E-II`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Flat Screen Monitors`.
    temp28-suppliername = `Very Best Screens`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1031.jpg`.
    temp28-description = `Optimum Hi-Resolution max. 1920 x 1200 @ 85Hz, Dot Pitch: 0.26mm`.
    temp28-price = `285`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1032`.
    temp28-name = `Ergo Screen E-III`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Flat Screen Monitors`.
    temp28-suppliername = `Very Best Screens`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1032.jpg`.
    temp28-description = `Optimum Hi-Resolution max. 2560 x 1440 @ 85Hz, Dot Pitch: 0.25mm`.
    temp28-price = `345`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1035`.
    temp28-name = `Flat Basic`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Flat Screen Monitors`.
    temp28-suppliername = `Very Best Screens`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1035.jpg`.
    temp28-description = `Optimum Hi-Resolution max. 1600 x 1200 @ 85Hz, Dot Pitch: 0.24mm`.
    temp28-price = `399`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1036`.
    temp28-name = `Flat Future`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Flat Screen Monitors`.
    temp28-suppliername = `Very Best Screens`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1036.jpg`.
    temp28-description = `Optimum Hi-Resolution max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.26mm`.
    temp28-price = `430`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1037`.
    temp28-name = `Flat XL`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Flat Screen Monitors`.
    temp28-suppliername = `Very Best Screens`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1037.jpg`.
    temp28-description = `Optimum Hi-Resolution max. 2016 x 1512 @ 85Hz, Dot Pitch: 0.24mm`.
    temp28-price = `1230`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1040`.
    temp28-name = `Laser Professional Eco`.
    temp28-maincategory = `Printers & Scanners`.
    temp28-category = `Printers`.
    temp28-suppliername = `Alpha Printers`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1040.jpg`.
    temp28-description = `Print 2400 dpi image quality color documents at speeds of up to 32 ppm (color) or 36 ppm (monochrome), letter/A4. Powerful 500 MHz processor, 512MB of memory`.
    temp28-price = `830`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1041`.
    temp28-name = `Laser Basic`.
    temp28-maincategory = `Printers & Scanners`.
    temp28-category = `Printers`.
    temp28-suppliername = `Alpha Printers`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1041.jpg`.
    temp28-description = `Up to 22 ppm color or 24 ppm monochrome A4/letter, powerful 500 MHz processor and 128MB of memory`.
    temp28-price = `490`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1042`.
    temp28-name = `Laser Allround`.
    temp28-maincategory = `Printers & Scanners`.
    temp28-category = `Printers`.
    temp28-suppliername = `Alpha Printers`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1042.jpg`.
    temp28-description = `Print up to 25 ppm letter and 24 ppm A4 color or monochrome, with Available first-page-out-time of less than 13 seconds for monochrome and less than 15 seconds for color`.
    temp28-price = `349`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1050`.
    temp28-name = `Ultra Jet Super Color`.
    temp28-maincategory = `Printers & Scanners`.
    temp28-category = `Printers`.
    temp28-suppliername = `Alpha Printers`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1050.jpg`.
    temp28-description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB, Ethernet`.
    temp28-price = `139`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1051`.
    temp28-name = `Ultra Jet Mobile`.
    temp28-maincategory = `Printers & Scanners`.
    temp28-category = `Printers`.
    temp28-suppliername = `Printer for All`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1051.jpg`.
    temp28-description = `1000 dpi x 1000 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB - excellent dimensions for the small office`.
    temp28-price = `99`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1052`.
    temp28-name = `Ultra Jet Super Highspeed`.
    temp28-maincategory = `Printers & Scanners`.
    temp28-category = `Printers`.
    temp28-suppliername = `Printer for All`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1052.jpg`.
    temp28-description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB2.0, Ethernet`.
    temp28-price = `170`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1055`.
    temp28-name = `Multi Print`.
    temp28-maincategory = `Printers & Scanners`.
    temp28-category = `Multifunction Printers`.
    temp28-suppliername = `Printer for All`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1055.jpg`.
    temp28-description = `1000 dpi x 1000 dpi - up to 16 ppm (mono) / up to 15 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 1200dpi x 2400dpi)`.
    temp28-price = `99`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1056`.
    temp28-name = `Multi Color`.
    temp28-maincategory = `Printers & Scanners`.
    temp28-category = `Multifunction Printers`.
    temp28-suppliername = `Printer for All`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1056.jpg`.
    temp28-description = `1200 dpi x 1200 dpi - up to 25 ppm (mono) / up to 24 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 2400dpi x 4800dpi, high resolution)`.
    temp28-price = `119`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1060`.
    temp28-name = `Cordless Mouse`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Mice`.
    temp28-suppliername = `Oxynum`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1060.jpg`.
    temp28-description = `Cordless Optical USB Mice, Laptop, Color: Black, Plug&Play`.
    temp28-price = `9`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1061`.
    temp28-name = `Speed Mouse`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Mice`.
    temp28-suppliername = `Oxynum`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1061.jpg`.
    temp28-description = `Optical USB, PS/2 Mouse, Color: Blue, 3-button-functionality (incl. Scroll wheel)`.
    temp28-price = `7`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1062`.
    temp28-name = `Track Mouse`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Mice`.
    temp28-suppliername = `Oxynum`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1062.jpg`.
    temp28-description = `Optical USB Mouse, Color: Red, 5-button-functionality(incl. Scroll wheel), Plug&Play`.
    temp28-price = `11`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1063`.
    temp28-name = `Ergonomic Keyboard`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Keyboards`.
    temp28-suppliername = `Oxynum`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1063.jpg`.
    temp28-description = `Ergonomic USB Keyboard for Desktop, Plug&Play`.
    temp28-price = `14`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1064`.
    temp28-name = `Internet Keyboard`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Keyboards`.
    temp28-suppliername = `Oxynum`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1064.jpg`.
    temp28-description = `Corded Keyboard with special keys for Internet Usability, USB`.
    temp28-price = `16`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1065`.
    temp28-name = `Media Keyboard`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Keyboards`.
    temp28-suppliername = `Oxynum`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg`.
    temp28-description = `Corded Ergonomic Keyboard with special keys for Media Usability, USB`.
    temp28-price = `26`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1066`.
    temp28-name = `Mousepad`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Mousepads`.
    temp28-suppliername = `Oxynum`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1066.jpg`.
    temp28-description = `Nice mouse pad with ITelO Logo`.
    temp28-price = `6.99`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1067`.
    temp28-name = `Ergo Mousepad`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Mousepads`.
    temp28-suppliername = `Oxynum`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1067.jpg`.
    temp28-description = `Ergonomic mouse pad with ITelO Logo`.
    temp28-price = `8.99`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1068`.
    temp28-name = `Designer Mousepad`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Mousepads`.
    temp28-suppliername = `Fasttech`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1068.jpg`.
    temp28-description = `ITelO Mousepad Special Edition`.
    temp28-price = `12.99`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1069`.
    temp28-name = `Universal card reader`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `Computer System Accessories`.
    temp28-suppliername = `Fasttech`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1069.jpg`.
    temp28-description = `Universal card reader`.
    temp28-price = `14`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1070`.
    temp28-name = `Proctra X`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Graphic Cards`.
    temp28-suppliername = `Ultrasonic United`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1070.jpg`.
    temp28-description = `Proctra X: PCI-E GDDR5 3072MB`.
    temp28-price = `70.9`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1071`.
    temp28-name = `Gladiator MX`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Graphic Cards`.
    temp28-suppliername = `Ultrasonic United`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1071.jpg`.
    temp28-description = `Gladiator XLN: PCI-E GDDR5 3072MB DVI Out, TV Out low-noise`.
    temp28-price = `81.7`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1072`.
    temp28-name = `Hurricane GX`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Graphic Cards`.
    temp28-suppliername = `Ultrasonic United`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1072.jpg`.
    temp28-description = `Hurricane GX: PCI-E 691 GFLOPS game-optimized`.
    temp28-price = `101.2`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1073`.
    temp28-name = `Hurricane GX/LN`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Graphic Cards`.
    temp28-suppliername = `Smartcards`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1073.jpg`.
    temp28-description = `Hurricane GX/LN: PCI-E 691 GFLOPS game-optimized, low-noise.`.
    temp28-price = `139.99`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1080`.
    temp28-name = `Photo Scan`.
    temp28-maincategory = `Printers & Scanners`.
    temp28-category = `Scanners`.
    temp28-suppliername = `Printer for All`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1080.jpg`.
    temp28-description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - Hi-Speed USB - Bluetooth`.
    temp28-price = `129`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1081`.
    temp28-name = `Power Scan`.
    temp28-maincategory = `Printers & Scanners`.
    temp28-category = `Scanners`.
    temp28-suppliername = `Printer for All`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1081.jpg`.
    temp28-description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - SCSI for backward compatibility`.
    temp28-price = `89`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1082`.
    temp28-name = `Jet Scan Professional`.
    temp28-maincategory = `Printers & Scanners`.
    temp28-category = `Scanners`.
    temp28-suppliername = `Printer for All`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1082.jpg`.
    temp28-description = `Flatbed scanner - Letter - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module`.
    temp28-price = `169`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1083`.
    temp28-name = `Jet Scan Professional`.
    temp28-maincategory = `Printers & Scanners`.
    temp28-category = `Scanners`.
    temp28-suppliername = `Printer for All`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1083.jpg`.
    temp28-description = `Flatbed scanner - A4 - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module`.
    temp28-price = `189`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1085`.
    temp28-name = `Copymaster`.
    temp28-maincategory = `Printers & Scanners`.
    temp28-category = `Multifunction Printers`.
    temp28-suppliername = `Alpha Printers`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1085.jpg`.
    temp28-description = `Copymaster`.
    temp28-price = `1499`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1090`.
    temp28-name = `Surround Sound`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Speakers`.
    temp28-suppliername = `Speaker Experts`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1090.jpg`.
    temp28-description = `PC multimedia speakers - 5 Watt (Total)`.
    temp28-price = `39`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1091`.
    temp28-name = `Blaster Extreme`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Speakers`.
    temp28-suppliername = `Speaker Experts`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1091.jpg`.
    temp28-description = `PC multimedia speakers - 10 Watt (Total) - 2-way`.
    temp28-price = `26`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1092`.
    temp28-name = `Sound Booster`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Speakers`.
    temp28-suppliername = `Speaker Experts`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1092.jpg`.
    temp28-description = `PC multimedia speakers - optimized for Blutooth/A2DP`.
    temp28-price = `45`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1095`.
    temp28-name = `Lovely Sound 5.1 Wireless`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Fasttech`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1095.jpg`.
    temp28-description = `5.1 Headset, 40 Hz-20 kHz, Wireless`.
    temp28-price = `49`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1096`.
    temp28-name = `Lovely Sound 5.1`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Fasttech`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1096.jpg`.
    temp28-description = `5.1 Headset, 40 Hz-20 kHz, 3m cable`.
    temp28-price = `39`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1097`.
    temp28-name = `Lovely Sound Stereo`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Fasttech`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1097.jpg`.
    temp28-description = `5.1 Headset, 40 Hz-20 kHz, 1m cable`.
    temp28-price = `29`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1100`.
    temp28-name = `Smart Office`.
    temp28-maincategory = `Software`.
    temp28-category = `Software`.
    temp28-suppliername = `Technocom`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1100.jpg`.
    temp28-description = `Complete package, 1 User, Office Applications (word processing, spreadsheet, presentations)`.
    temp28-price = `89.9`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1101`.
    temp28-name = `Smart Design`.
    temp28-maincategory = `Software`.
    temp28-category = `Software`.
    temp28-suppliername = `Technocom`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1101.jpg`.
    temp28-description = `Complete package, 1 User, Image editing, processing`.
    temp28-price = `79.9`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1102`.
    temp28-name = `Smart Network`.
    temp28-maincategory = `Software`.
    temp28-category = `Software`.
    temp28-suppliername = `Technocom`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1102.jpg`.
    temp28-description = `Complete package, 1 User, Network Software Utilities, Useful Applications and Documentation`.
    temp28-price = `69`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1103`.
    temp28-name = `Smart Multimedia`.
    temp28-maincategory = `Software`.
    temp28-category = `Software`.
    temp28-suppliername = `Technocom`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1103.jpg`.
    temp28-description = `Complete package, 1 User, different Multimedia applications, playing music, watching DVDs, only with this Smart package`.
    temp28-price = `77`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1104`.
    temp28-name = `Smart Games`.
    temp28-maincategory = `Software`.
    temp28-category = `Software`.
    temp28-suppliername = `Technocom`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1104.jpg`.
    temp28-description = `Complete package, 1 User, various games for amusement, logic, action, jump&run`.
    temp28-price = `55`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1105`.
    temp28-name = `Smart Internet Antivirus`.
    temp28-maincategory = `Software`.
    temp28-category = `Software`.
    temp28-suppliername = `Brainsoft`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1105.jpg`.
    temp28-description = `Complete package, 1 User, highly recommended for internet users as anti-virus protection`.
    temp28-price = `29`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1106`.
    temp28-name = `Smart Firewall`.
    temp28-maincategory = `Software`.
    temp28-category = `Software`.
    temp28-suppliername = `Brainsoft`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1106.jpg`.
    temp28-description = `Complete package, 1 User, recommended for internet users, protect your PC against cyber-crime`.
    temp28-price = `34`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1107`.
    temp28-name = `Smart Money`.
    temp28-maincategory = `Software`.
    temp28-category = `Software`.
    temp28-suppliername = `Brainsoft`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1107.jpg`.
    temp28-description = `Complete package, 1 User, bring your money in your mind, see what you have and what you want`.
    temp28-price = `29.9`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1110`.
    temp28-name = `PC Lock`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `Computer System Accessories`.
    temp28-suppliername = `Red Point Stores`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1110.jpg`.
    temp28-description = `Robust 3m anti-burglary protection for your laptop computer`.
    temp28-price = `8.9`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1111`.
    temp28-name = `Notebook Lock`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `Computer System Accessories`.
    temp28-suppliername = `Red Point Stores`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1111.jpg`.
    temp28-description = `Robust 1m anti-burglary protection for your desktop computer`.
    temp28-price = `6.9`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1112`.
    temp28-name = `Web cam reality`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `Computer System Accessories`.
    temp28-suppliername = `Red Point Stores`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1112.jpg`.
    temp28-description = `Color webcam, color, High-Speed USB`.
    temp28-price = `39`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1113`.
    temp28-name = `Screen clean`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `Computer System Accessories`.
    temp28-suppliername = `Red Point Stores`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1113.jpg`.
    temp28-description = `10 separately packed screen wipes`.
    temp28-price = `2.3`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1114`.
    temp28-name = `Fabric bag professional`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `Computer System Accessories`.
    temp28-suppliername = `Red Point Stores`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1114.jpg`.
    temp28-description = `Notebook bag, plenty of room for stationery and writing materials`.
    temp28-price = `31`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1115`.
    temp28-name = `Wireless DSL Router`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Telecommunications`.
    temp28-suppliername = `Red Point Stores`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1115.jpg`.
    temp28-description = `Wireless DSL Router (available in blue, black and silver)`.
    temp28-price = `49`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1116`.
    temp28-name = `Wireless DSL Router / Repeater`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Telecommunications`.
    temp28-suppliername = `Red Point Stores`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1116.jpg`.
    temp28-description = `Wireless DSL Router / Repeater (available in blue, black and silver)`.
    temp28-price = `59`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1117`.
    temp28-name = `Wireless DSL Router / Repeater and Print Server`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Telecommunications`.
    temp28-suppliername = `Technocom`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1117.jpg`.
    temp28-description = `Wireless DSL Router / Repeater and Print Server (available in blue, black and silver)`.
    temp28-price = `69`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1118`.
    temp28-name = `USB Stick`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `Computer System Accessories`.
    temp28-suppliername = `Technocom`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1118.jpg`.
    temp28-description = `USB 2.0 High-Speed 64 GB`.
    temp28-price = `35`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1119`.
    temp28-name = `Travel Adapter`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Titanium`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1119.jpg`.
    temp28-description = `Universal Travel Adapter`.
    temp28-price = `79`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1120`.
    temp28-name = `Cordless Bluetooth Keyboard, english international`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Keyboards`.
    temp28-suppliername = `Technocom`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1120.jpg`.
    temp28-description = `Cordless Bluetooth Keyboard with English keys`.
    temp28-price = `29`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1137`.
    temp28-name = `Flat XXL`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Flat Screen Monitors`.
    temp28-suppliername = `Technocom`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1137.jpg`.
    temp28-description = `Optimum Hi-Resolution max. 2048 × 1536 @ 85Hz, Dot Pitch: 0.24mm`.
    temp28-price = `1430`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1138`.
    temp28-name = `Pocket Mouse`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Mice`.
    temp28-suppliername = `Technocom`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1138.jpg`.
    temp28-description = `Portable pocket Mouse with retracting cord`.
    temp28-price = `23`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1210`.
    temp28-name = `PC Power Station`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `PCs`.
    temp28-suppliername = `Technocom`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1210.jpg`.
    temp28-description = `PC Power Station with 3,4 Ghz quad-core, 32 GB DDR3 SDRAM, feels like Available PC, Windows 8 Pro`.
    temp28-price = `2399`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1251`.
    temp28-name = `Astro Laptop 1516`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `Laptops`.
    temp28-suppliername = `Ultrasonic United`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1251.jpg`.
    temp28-description = `Flexible Laptop with 2,5 GHz Quad Core, 15" HD TN, 16 GB DDR SDRAM, 256 GB SSD, Windows 10 Pro`.
    temp28-price = `989`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1252`.
    temp28-name = `Astro Phone 6`.
    temp28-maincategory = `Smartphones & Tablets`.
    temp28-category = `Smartphones and Tablets`.
    temp28-suppliername = `Ultrasonic United`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1252.jpg`.
    temp28-description = `6 inch 1280x800 HD display (216 ppi), Quad-core processor, 8 GB internal storage (actual formatted capacity will be less), 3050 mAh battery (Up to 8 hours of active use), grey or black`.
    temp28-price = `649`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1253`.
    temp28-name = `Benda Laptop 1408`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `Laptops`.
    temp28-suppliername = `Ultrasonic United`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1253.jpg`.
    temp28-description = `Flexible Laptop with 2,5 GHz Dual Core, 14" HD+ TN, 8 GB DDR SDRAM, 324 GB SSD, Windows 10 Pro`.
    temp28-price = `976`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1254`.
    temp28-name = `Bending Screen 21HD`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Flat Screens`.
    temp28-suppliername = `Ultrasonic United`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1254.jpg`.
    temp28-description = `Optimum Hi-Resolution Widescreen max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub`.
    temp28-price = `250`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1255`.
    temp28-name = `Broad Screen 22HD`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Flat Screens`.
    temp28-suppliername = `Ultrasonic United`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1255.jpg`.
    temp28-description = `Optimum Hi-Resolution Widescreen max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub`.
    temp28-price = `270`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1256`.
    temp28-name = `Cerdik Phone 7`.
    temp28-maincategory = `Smartphones & Tablets`.
    temp28-category = `Smartphones and Tablets`.
    temp28-suppliername = `Ultrasonic United`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1256.jpg`.
    temp28-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black`.
    temp28-price = `549`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1257`.
    temp28-name = `Cepat Tablet 10.5`.
    temp28-maincategory = `Smartphones & Tablets`.
    temp28-category = `Smartphones and Tablets`.
    temp28-suppliername = `Ultrasonic United`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1257.jpg`.
    temp28-description = `10.5-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor`.
    temp28-price = `549`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1258`.
    temp28-name = `Cepat Tablet 8`.
    temp28-maincategory = `Smartphones & Tablets`.
    temp28-category = `Smartphones and Tablets`.
    temp28-suppliername = `Ultrasonic United`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1258.jpg`.
    temp28-description = `8-inch Multitouch HD Screen (2000 x 1500) 32GB Internal Memory, Wireless N Wi-Fi, Bluetooth, GPS Enabled, 1.5 GHz Quad-Core Processor`.
    temp28-price = `529`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1500`.
    temp28-name = `Server Basic`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `Servers`.
    temp28-suppliername = `Technocom`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1500.jpg`.
    temp28-description = `Dual socket, quad-core processing server with 1333 MHz Front Side Bus with 10Gb connectivity`.
    temp28-price = `5000`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1501`.
    temp28-name = `Server Professional`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `Servers`.
    temp28-suppliername = `Technocom`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1501.jpg`.
    temp28-description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 10Gb connectivity`.
    temp28-price = `15000`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1502`.
    temp28-name = `Server Power Pro`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `Servers`.
    temp28-suppliername = `Technocom`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1502.jpg`.
    temp28-description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 100Gb connectivity`.
    temp28-price = `25000`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1600`.
    temp28-name = `Family PC Basic`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `Desktop Computers`.
    temp28-suppliername = `Titanium`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1600.jpg`.
    temp28-description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Graphic Card: Proctra X, Windows 8`.
    temp28-price = `600`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1601`.
    temp28-name = `Family PC Pro`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `Desktop Computers`.
    temp28-suppliername = `Titanium`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1601.jpg`.
    temp28-description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8`.
    temp28-price = `900`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1602`.
    temp28-name = `Gaming Monster`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `Desktop Computers`.
    temp28-suppliername = `Titanium`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1602.jpg`.
    temp28-description = `3,4 Ghz quad core, 8 GB DDR3 SDRAM, 2000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8`.
    temp28-price = `1200`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-1603`.
    temp28-name = `Gaming Monster Pro`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `Desktop Computers`.
    temp28-suppliername = `Titanium`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1603.jpg`.
    temp28-description = `3,4 Ghz quad core, 16 GB DDR3 SDRAM, 4000 GB Hard Disc, Graphic Card: Hurricane GX, Windows 8`.
    temp28-price = `1700`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-2000`.
    temp28-name = `7" Widescreen Portable DVD Player w MP3`.
    temp28-maincategory = `TV, Video & HiFi`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Titanium`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2000.jpg`.
    temp28-description = `7" LCD Screen, storage battery holds up to 6 hours!`.
    temp28-price = `249.99`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-2001`.
    temp28-name = `10" Portable DVD player`.
    temp28-maincategory = `TV, Video & HiFi`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Titanium`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2001.jpg`.
    temp28-description = `10" LCD Screen, storage battery holds up to 8 hours`.
    temp28-price = `449.99`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-2002`.
    temp28-name = `Portable DVD Player with 9" LCD Monitor`.
    temp28-maincategory = `TV, Video & HiFi`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Technocom`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2002.jpg`.
    temp28-description = `9" LCD Screen, storage holds up to 8 hours, 2 speakers included`.
    temp28-price = `853.99`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-2025`.
    temp28-name = `CD/DVD case: 264 sleeves`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Titanium`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2025.jpg`.
    temp28-description = `Organizer and protective case for 264 CDs and DVDs`.
    temp28-price = `44.99`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-2026`.
    temp28-name = `Audio/Video Cable Kit - 4m`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Titanium`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2026.jpg`.
    temp28-description = `Quality cables for notebooks and projectors`.
    temp28-price = `29.99`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-2027`.
    temp28-name = `Removable CD/DVD Laser Labels`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Titanium`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-2027.jpg`.
    temp28-description = `Removable jewel case labels, zero residues (100)`.
    temp28-price = `8.99`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-6100`.
    temp28-name = `Beam Breaker B-1`.
    temp28-maincategory = `TV, Video & HiFi`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Titanium`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6100.jpg`.
    temp28-description = `720p, DLP Projector max. 8,45 Meter, 2D`.
    temp28-price = `469`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-6101`.
    temp28-name = `Beam Breaker B-2`.
    temp28-maincategory = `TV, Video & HiFi`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Technocom`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6101.jpg`.
    temp28-description = `1080p, DLP max.9,34 Meter, 2D-ready`.
    temp28-price = `679`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-6102`.
    temp28-name = `Beam Breaker B-3`.
    temp28-maincategory = `TV, Video & HiFi`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Technocom`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6102.jpg`.
    temp28-description = `1080p, DLP max. 12,3 Meter, 3D-ready`.
    temp28-price = `889`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-6110`.
    temp28-name = `Play Movie`.
    temp28-maincategory = `TV, Video & HiFi`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Fasttech`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6110.jpg`.
    temp28-description = `CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid`.
    temp28-price = `130`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-6111`.
    temp28-name = `Record Movie`.
    temp28-maincategory = `TV, Video & HiFi`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Fasttech`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6111.jpg`.
    temp28-description = `160 GB HDD, CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid`.
    temp28-price = `288`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-6120`.
    temp28-name = `ITelo MusicStick`.
    temp28-maincategory = `TV, Video & HiFi`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Fasttech`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6120.jpg`.
    temp28-description = `64 GB USB Music-on-Available-Stick`.
    temp28-price = `45`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-6121`.
    temp28-name = `ITelo Jog-Mate`.
    temp28-maincategory = `TV, Video & HiFi`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Fasttech`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6121.jpg`.
    temp28-description = `ITelo Jog-Mate 64 GB HDD and Color Display, can play movies`.
    temp28-price = `63`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-6122`.
    temp28-name = `Power Pro Player 40`.
    temp28-maincategory = `TV, Video & HiFi`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Fasttech`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6122.jpg`.
    temp28-description = `MP3-Player with 40 GB HDD and Color Display, can play movies`.
    temp28-price = `167`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-6123`.
    temp28-name = `Power Pro Player 80`.
    temp28-maincategory = `TV, Video & HiFi`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Fasttech`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6123.jpg`.
    temp28-description = `MP3-Player with 80 GB SSD and Color Display, can play movies`.
    temp28-price = `299`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-6130`.
    temp28-name = `Flat Watch HD32`.
    temp28-maincategory = `TV, Video & HiFi`.
    temp28-category = `Flat Screen TVs`.
    temp28-suppliername = `Very Best Screens`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6130.jpg`.
    temp28-description = `32-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    temp28-price = `1459`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-6131`.
    temp28-name = `Flat Watch HD37`.
    temp28-maincategory = `TV, Video & HiFi`.
    temp28-category = `Flat Screen TVs`.
    temp28-suppliername = `Very Best Screens`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6131.jpg`.
    temp28-description = `37-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    temp28-price = `1199`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-6132`.
    temp28-name = `Flat Watch HD41`.
    temp28-maincategory = `TV, Video & HiFi`.
    temp28-category = `Flat Screen TVs`.
    temp28-suppliername = `Very Best Screens`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-6132.jpg`.
    temp28-description = `41-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    temp28-price = `899`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-7000`.
    temp28-name = `Copperberry`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Fasttech`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7000.jpg`.
    temp28-description = `Our new multifunctional Handheld with phone function in copper`.
    temp28-price = `549`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-7010`.
    temp28-name = `Silverberry`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Fasttech`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7010.jpg`.
    temp28-description = `Our new multifunctional Handheld with phone function in silver`.
    temp28-price = `549`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-7020`.
    temp28-name = `Goldberry`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Fasttech`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7020.jpg`.
    temp28-description = `Our new multifunctional Handheld with phone function in gold`.
    temp28-price = `549`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-7030`.
    temp28-name = `Platinberry`.
    temp28-maincategory = `Computer Components`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Fasttech`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-7030.jpg`.
    temp28-description = `Our new multifunctional Handheld with phone function in platinum`.
    temp28-price = `549`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-8000`.
    temp28-name = `ITelO FlexTop I4000`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `Laptops`.
    temp28-suppliername = `Titanium`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8000.jpg`.
    temp28-description = `Notebook with 2,80 GHz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8`.
    temp28-price = `799`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-8001`.
    temp28-name = `ITelO FlexTop I6300c`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `Laptops`.
    temp28-suppliername = `Titanium`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8001.jpg`.
    temp28-description = `Notebook with 2,80 GHz dual core, 8 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8`.
    temp28-price = `799`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-8002`.
    temp28-name = `ITelO FlexTop I9100`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `Laptops`.
    temp28-suppliername = `Titanium`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8002.jpg`.
    temp28-description = `Notebook with 2,80 GHz quad core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8`.
    temp28-price = `1199`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-8003`.
    temp28-name = `ITelO FlexTop I9800`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `Laptops`.
    temp28-suppliername = `Titanium`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-8003.jpg`.
    temp28-description = `Notebook with 2,80 GHz quad core, 8 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8`.
    temp28-price = `1388`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-9991`.
    temp28-name = `Smartphone Leather Case`.
    temp28-maincategory = `Smartphones & Tablets`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Ultrasonic United`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9991.jpg`.
    temp28-description = `Button Clasp, Quality Material, 100% Leather, compatible with many smartphone models`.
    temp28-price = `25`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-9992`.
    temp28-name = `Smartphone Alpha`.
    temp28-maincategory = `Smartphones & Tablets`.
    temp28-category = `Smartphones and Tablets`.
    temp28-suppliername = `Ultrasonic United`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9992.jpg`.
    temp28-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black`.
    temp28-price = `599`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-9993`.
    temp28-name = `Mini Tablet`.
    temp28-maincategory = `Smartphones & Tablets`.
    temp28-category = `Smartphones and Tablets`.
    temp28-suppliername = `Ultrasonic United`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9993.jpg`.
    temp28-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage, 4325 mAh battery (Up to 8 hours of active use)`.
    temp28-price = `833`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-9994`.
    temp28-name = `Camcorder View`.
    temp28-maincategory = `TV, Video & HiFi`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Ultrasonic United`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9994.jpg`.
    temp28-description = `1920x1080 Full HD, image stabilization reduces blur, 27x Optical / 32x Extended Zoom, wide angle Lens, 2.7" wide LCD display`.
    temp28-price = `1388`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-9995`.
    temp28-name = `Tablet Pouch`.
    temp28-maincategory = `Smartphones & Tablets`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Titanium`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9995.jpg`.
    temp28-description = `Stylish tablet pouch, protects from scratches, color: black`.
    temp28-price = `20`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-9996`.
    temp28-name = `Tablet Pouch`.
    temp28-maincategory = `Smartphones & Tablets`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Titanium`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9996.jpg`.
    temp28-description = `Stylish tablet pouch, protects from scratches, color: black`.
    temp28-price = `20`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-9997`.
    temp28-name = `e-Book Reader ReadMe`.
    temp28-maincategory = `Smartphones & Tablets`.
    temp28-category = `Smartphones and Tablets`.
    temp28-suppliername = `Titanium`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9997.jpg`.
    temp28-description = `6-Inch E Ink Screen, Access To e-book Store, Adjustable Font Styles and Sizes, Stores Up To 1,000 Books`.
    temp28-price = `33`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-9998`.
    temp28-name = `Smartphone Beta`.
    temp28-maincategory = `Smartphones & Tablets`.
    temp28-category = `Smartphones and Tablets`.
    temp28-suppliername = `Titanium`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9998.jpg`.
    temp28-description = `5 Megapixel Camera, Wi-Fi 802.11 b/g/n, Bluetooth, GPS Available-GPS support`.
    temp28-price = `30`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `HT-9999`.
    temp28-name = `Maxi Tablet`.
    temp28-maincategory = `Smartphones & Tablets`.
    temp28-category = `Tablets`.
    temp28-suppliername = `Titanium`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-9999.jpg`.
    temp28-description = `10.1-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor`.
    temp28-price = `749`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    temp28-productid = `PF-1000`.
    temp28-name = `Flyer`.
    temp28-maincategory = `Computer Systems`.
    temp28-category = `Accessories`.
    temp28-suppliername = `Titanium`.
    temp28-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/PF-1000.jpg`.
    temp28-description = `Flyer for our product palette`.
    temp28-price = `0`.
    temp28-currencycode = `EUR`.
    INSERT temp28 INTO TABLE temp27.
    t_products = temp27.

    " /ProductCollectionStats/Filters/1/values - the twelve suppliers
    
    CLEAR temp29.
    
    temp30-text = `Titanium`.
    INSERT temp30 INTO TABLE temp29.
    temp30-text = `Technocom`.
    INSERT temp30 INTO TABLE temp29.
    temp30-text = `Red Point Stores`.
    INSERT temp30 INTO TABLE temp29.
    temp30-text = `Very Best Screens`.
    INSERT temp30 INTO TABLE temp29.
    temp30-text = `Smartcards`.
    INSERT temp30 INTO TABLE temp29.
    temp30-text = `Alpha Printers`.
    INSERT temp30 INTO TABLE temp29.
    temp30-text = `Printer for All`.
    INSERT temp30 INTO TABLE temp29.
    temp30-text = `Oxynum`.
    INSERT temp30 INTO TABLE temp29.
    temp30-text = `Fasttech`.
    INSERT temp30 INTO TABLE temp29.
    temp30-text = `Ultrasonic United`.
    INSERT temp30 INTO TABLE temp29.
    temp30-text = `Speaker Experts`.
    INSERT temp30 INTO TABLE temp29.
    temp30-text = `Brainsoft`.
    INSERT temp30 INTO TABLE temp29.
    t_suppliers = temp29.

  ENDMETHOD.

ENDCLASS.
