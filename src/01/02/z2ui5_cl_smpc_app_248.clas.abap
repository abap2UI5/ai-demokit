" @keywords treetable tree table sap.ui.table treetable.jsontreebinding overflowtoolbar title toolbarspacer button column label text
" @summary Basic example showing how a TreeTable can be built using a JSONModel
CLASS z2ui5_cl_smpc_app_248 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " the Clothing.json tree has a fixed depth: 4 root categories, their
    " subcategories, then either leaf articles or one more category level -
    " modeled as nested types. A flat ABAP row serializes EVERY field, so a
    " level-3 category row (Dresses) does carry initial AMOUNT/CURRENCY/SIZE
    " fields its own JSON node omits - which is what the Currency > 0 and the
    " !!SIZE guards in the view exist for. Corrected 2026-08-21: this comment
    " used to claim the opposite of the two deviations that declare it.
    TYPES:
      BEGIN OF ty_s_article,
        name     TYPE string,
        amount   TYPE p LENGTH 5 DECIMALS 2,
        currency TYPE string,
        size     TYPE string,
      END OF ty_s_article.
    TYPES ty_t_article TYPE STANDARD TABLE OF ty_s_article WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_s_group,
        name       TYPE string,
        amount     TYPE p LENGTH 5 DECIMALS 2,
        currency   TYPE string,
        size       TYPE string,
        categories TYPE ty_t_article,
      END OF ty_s_group.
    TYPES ty_t_group TYPE STANDARD TABLE OF ty_s_group WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_s_area,
        name       TYPE string,
        categories TYPE ty_t_group,
      END OF ty_s_area.
    TYPES ty_t_area TYPE STANDARD TABLE OF ty_s_area WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_s_root,
        name       TYPE string,
        categories TYPE ty_t_area,
      END OF ty_s_root.
    TYPES ty_t_root TYPE STANDARD TABLE OF ty_s_root WITH DEFAULT KEY.
    TYPES:
      BEGIN OF ty_s_clothing,
        categories TYPE ty_t_root,
      END OF ty_s_clothing.
    TYPES:
      BEGIN OF ty_s_catalog,
        clothing TYPE ty_s_clothing,
      END OF ty_s_catalog.
    TYPES:
      BEGIN OF ty_s_size,
        key   TYPE string,
        value TYPE string,
      END OF ty_s_size.

    DATA catalog TYPE ty_s_catalog.
    DATA sizes   TYPE STANDARD TABLE OF ty_s_size WITH DEFAULT KEY.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_248 IMPLEMENTATION.

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
    DATA temp4 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `TreeTableBasic` INTO TABLE temp1.
    INSERT `collapseAll` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `TreeTableBasic` INTO TABLE temp2.
    INSERT `collapse` INTO TABLE temp2.
    INSERT `$event.oSource.getParent().getParent().getSelectedIndices()` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `TreeTableBasic` INTO TABLE temp3.
    INSERT `expandToLevel` INTO TABLE temp3.
    INSERT `1` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `TreeTableBasic` INTO TABLE temp4.
    INSERT `expand` INTO TABLE temp4.
    INSERT `$event.oSource.getParent().getParent().getSelectedIndices()` INTO TABLE temp4.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.ui.table`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`    v = `sap.m`
        )->a( n = `xmlns:u`    v = `sap.ui.unified`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `height`     v = `100%`

        )->ele( n = `Page` ns = `m`
            )->a( n = `showHeader`      v = `false`
            )->a( n = `enableScrolling` v = `false`

            )->ele( n = `content` ns = `m`
                )->ele( `TreeTable`
                    )->a( n = `id`              v = `TreeTableBasic`
                    )->a( n = `rows`            v = |\{ path: '{ client->_bind_path( catalog-clothing ) }', parameters: \{ arrayNames: ['CATEGORIES'] \} \}|
                    )->a( n = `selectionMode`   v = `MultiToggle`
                    )->a( n = `enableSelectAll` v = `false`
                    )->a( n = `ariaLabelledBy`  v = `title`

                    )->ele( `extension`
                        )->ele( n = `OverflowToolbar` ns = `m`
                            )->a( n = `style` v = `Clear`
                            )->tag( n = `Title` ns = `m`
                                )->a( n = `id`   v = `title`
                                )->a( n = `text` v = `Clothing`
                            )->tag( n = `ToolbarSpacer` ns = `m`
                            )->tag( n = `Button` ns = `m`
                                )->a( n = `text`  v = `Collapse all`
                                )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                                t_arg = temp1 )
                            )->tag( n = `Button` ns = `m`
                                )->a( n = `text`  v = `Collapse selection`
                                )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                                t_arg = temp2 )
                            )->tag( n = `Button` ns = `m`
                                )->a( n = `text`  v = `Expand first level`
                                )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                                t_arg = temp3 )
                            )->tag( n = `Button` ns = `m`
                                )->a( n = `text`  v = `Expand selection`
                                )->a( n = `press` v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                                t_arg = temp4 )

                        )->end(
                    )->end(

                    )->ele( `columns`
                        )->ele( `Column`
                            )->a( n = `width` v = `13rem`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Categories`
                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{NAME}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `width` v = `9rem`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Price`
                            )->ele( `template`
                                " a category row's own AMOUNT serializes as 0 (initial packed);
                                " the guard keeps the Price cell empty there like the original's
                                " absent JSON property (app-220 idiom, declared)
                                )->tag( n = `Currency` ns = `u`
                                    )->a( n = `value`    v = `{= ${AMOUNT} > 0 ? ${AMOUNT} : null }`
                                    )->a( n = `currency` v = `{CURRENCY}`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `width` v = `11rem`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Size`
                            )->ele( `template`
                                )->ele( n = `Select` ns = `m`
                                    )->a( n = `items`          v = |\{ path: '{ client->_bind_path( sizes ) }', templateShareable: true \}|
                                    )->a( n = `selectedKey`    v = `{SIZE}`
                                    )->a( n = `visible`        v = `{= !!${SIZE}}`
                                    )->a( n = `forceSelection` v = `false`

                                    )->tag( n = `Item` ns = `core`
                                        )->a( n = `key`  v = `{KEY}`
                                        )->a( n = `text` v = `{VALUE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " Clothing.json 1:1 - the full tree (Women/Men/Girls/Boys), every leaf
    " with its amount/currency/size; a leaf without a size in the JSON keeps
    " the field initial so the Select stays hidden via the !!SIZE guard
    DATA temp3 TYPE z2ui5_cl_smpc_app_248=>ty_t_root.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp7 TYPE z2ui5_cl_smpc_app_248=>ty_t_area.
    DATA temp8 LIKE LINE OF temp7.
    DATA temp15 TYPE z2ui5_cl_smpc_app_248=>ty_t_group.
    DATA temp16 LIKE LINE OF temp15.
    DATA temp41 TYPE z2ui5_cl_smpc_app_248=>ty_t_article.
    DATA temp42 LIKE LINE OF temp41.
    DATA temp43 TYPE z2ui5_cl_smpc_app_248=>ty_t_article.
    DATA temp44 LIKE LINE OF temp43.
    DATA temp45 TYPE z2ui5_cl_smpc_app_248=>ty_t_article.
    DATA temp46 LIKE LINE OF temp45.
    DATA temp47 TYPE z2ui5_cl_smpc_app_248=>ty_t_article.
    DATA temp48 LIKE LINE OF temp47.
    DATA temp17 TYPE z2ui5_cl_smpc_app_248=>ty_t_group.
    DATA temp18 LIKE LINE OF temp17.
    DATA temp19 TYPE z2ui5_cl_smpc_app_248=>ty_t_group.
    DATA temp20 LIKE LINE OF temp19.
    DATA temp21 TYPE z2ui5_cl_smpc_app_248=>ty_t_group.
    DATA temp22 LIKE LINE OF temp21.
    DATA temp9 TYPE z2ui5_cl_smpc_app_248=>ty_t_area.
    DATA temp10 LIKE LINE OF temp9.
    DATA temp23 TYPE z2ui5_cl_smpc_app_248=>ty_t_group.
    DATA temp24 LIKE LINE OF temp23.
    DATA temp49 TYPE z2ui5_cl_smpc_app_248=>ty_t_article.
    DATA temp50 LIKE LINE OF temp49.
    DATA temp51 TYPE z2ui5_cl_smpc_app_248=>ty_t_article.
    DATA temp52 LIKE LINE OF temp51.
    DATA temp53 TYPE z2ui5_cl_smpc_app_248=>ty_t_article.
    DATA temp54 LIKE LINE OF temp53.
    DATA temp25 TYPE z2ui5_cl_smpc_app_248=>ty_t_group.
    DATA temp26 LIKE LINE OF temp25.
    DATA temp27 TYPE z2ui5_cl_smpc_app_248=>ty_t_group.
    DATA temp28 LIKE LINE OF temp27.
    DATA temp11 TYPE z2ui5_cl_smpc_app_248=>ty_t_area.
    DATA temp12 LIKE LINE OF temp11.
    DATA temp29 TYPE z2ui5_cl_smpc_app_248=>ty_t_group.
    DATA temp30 LIKE LINE OF temp29.
    DATA temp55 TYPE z2ui5_cl_smpc_app_248=>ty_t_article.
    DATA temp56 LIKE LINE OF temp55.
    DATA temp57 TYPE z2ui5_cl_smpc_app_248=>ty_t_article.
    DATA temp58 LIKE LINE OF temp57.
    DATA temp59 TYPE z2ui5_cl_smpc_app_248=>ty_t_article.
    DATA temp60 LIKE LINE OF temp59.
    DATA temp31 TYPE z2ui5_cl_smpc_app_248=>ty_t_group.
    DATA temp32 LIKE LINE OF temp31.
    DATA temp33 TYPE z2ui5_cl_smpc_app_248=>ty_t_group.
    DATA temp34 LIKE LINE OF temp33.
    DATA temp13 TYPE z2ui5_cl_smpc_app_248=>ty_t_area.
    DATA temp14 LIKE LINE OF temp13.
    DATA temp35 TYPE z2ui5_cl_smpc_app_248=>ty_t_group.
    DATA temp36 LIKE LINE OF temp35.
    DATA temp61 TYPE z2ui5_cl_smpc_app_248=>ty_t_article.
    DATA temp62 LIKE LINE OF temp61.
    DATA temp63 TYPE z2ui5_cl_smpc_app_248=>ty_t_article.
    DATA temp64 LIKE LINE OF temp63.
    DATA temp65 TYPE z2ui5_cl_smpc_app_248=>ty_t_article.
    DATA temp66 LIKE LINE OF temp65.
    DATA temp37 TYPE z2ui5_cl_smpc_app_248=>ty_t_group.
    DATA temp38 LIKE LINE OF temp37.
    DATA temp39 TYPE z2ui5_cl_smpc_app_248=>ty_t_group.
    DATA temp40 LIKE LINE OF temp39.
    DATA temp5 LIKE sizes.
    DATA temp6 LIKE LINE OF temp5.
    CLEAR temp3.
    
    temp4-name = `Women`.
    
    CLEAR temp7.
    
    temp8-name = `Clothing`.
    
    CLEAR temp15.
    
    temp16-name = `Dresses`.
    
    CLEAR temp41.
    
    temp42-name = `Casual Red Dress`.
    temp42-amount = `16.99`.
    temp42-currency = `EUR`.
    temp42-size = `S`.
    INSERT temp42 INTO TABLE temp41.
    temp42-name = `Short Black Dress`.
    temp42-amount = `47.99`.
    temp42-currency = `EUR`.
    temp42-size = `M`.
    INSERT temp42 INTO TABLE temp41.
    temp42-name = `Long Blue Dinner Dress`.
    temp42-amount = `103.99`.
    temp42-currency = `USD`.
    temp42-size = `L`.
    INSERT temp42 INTO TABLE temp41.
    temp16-categories = temp41.
    INSERT temp16 INTO TABLE temp15.
    temp16-name = `Tops`.
    
    CLEAR temp43.
    
    temp44-name = `Printed Shirt`.
    temp44-amount = `24.99`.
    temp44-currency = `USD`.
    temp44-size = `M`.
    INSERT temp44 INTO TABLE temp43.
    temp44-name = `Tank Top`.
    temp44-amount = `14.99`.
    temp44-currency = `USD`.
    temp44-size = `S`.
    INSERT temp44 INTO TABLE temp43.
    temp16-categories = temp43.
    INSERT temp16 INTO TABLE temp15.
    temp16-name = `Pants`.
    
    CLEAR temp45.
    
    temp46-name = `Red Pant`.
    temp46-amount = `32.99`.
    temp46-currency = `USD`.
    temp46-size = `M`.
    INSERT temp46 INTO TABLE temp45.
    temp46-name = `Skinny Jeans`.
    temp46-amount = `44.99`.
    temp46-currency = `USD`.
    temp46-size = `S`.
    INSERT temp46 INTO TABLE temp45.
    temp46-name = `Black Jeans`.
    temp46-amount = `99.99`.
    temp46-currency = `USD`.
    temp46-size = `XS`.
    INSERT temp46 INTO TABLE temp45.
    temp46-name = `Relaxed Fit Jeans`.
    temp46-amount = `56.99`.
    temp46-currency = `USD`.
    temp46-size = `L`.
    INSERT temp46 INTO TABLE temp45.
    temp16-categories = temp45.
    INSERT temp16 INTO TABLE temp15.
    temp16-name = `Skirts`.
    
    CLEAR temp47.
    
    temp48-name = `Striped Skirt`.
    temp48-amount = `24.99`.
    temp48-currency = `USD`.
    temp48-size = `M`.
    INSERT temp48 INTO TABLE temp47.
    temp48-name = `Black Skirt`.
    temp48-amount = `44.99`.
    temp48-currency = `USD`.
    temp48-size = `S`.
    INSERT temp48 INTO TABLE temp47.
    temp16-categories = temp47.
    INSERT temp16 INTO TABLE temp15.
    temp8-categories = temp15.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Jewelry`.
    
    CLEAR temp17.
    
    temp18-name = `Necklace`.
    temp18-amount = `16.99`.
    temp18-currency = `USD`.
    INSERT temp18 INTO TABLE temp17.
    temp18-name = `Bracelet`.
    temp18-amount = `47.99`.
    temp18-currency = `USD`.
    INSERT temp18 INTO TABLE temp17.
    temp18-name = `Gold Ring`.
    temp18-amount = `399.99`.
    temp18-currency = `USD`.
    INSERT temp18 INTO TABLE temp17.
    temp8-categories = temp17.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Handbags`.
    
    CLEAR temp19.
    
    temp20-name = `Little Black Bag`.
    temp20-amount = `16.99`.
    temp20-currency = `USD`.
    temp20-size = `S`.
    INSERT temp20 INTO TABLE temp19.
    temp20-name = `Grey Shopper`.
    temp20-amount = `47.99`.
    temp20-currency = `USD`.
    temp20-size = `M`.
    INSERT temp20 INTO TABLE temp19.
    temp8-categories = temp19.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Shoes`.
    
    CLEAR temp21.
    
    temp22-name = `Pumps`.
    temp22-amount = `89.99`.
    temp22-currency = `USD`.
    INSERT temp22 INTO TABLE temp21.
    temp22-name = `Sport Shoes`.
    temp22-amount = `47.99`.
    temp22-currency = `USD`.
    INSERT temp22 INTO TABLE temp21.
    temp22-name = `Boots`.
    temp22-amount = `103.99`.
    temp22-currency = `USD`.
    INSERT temp22 INTO TABLE temp21.
    temp8-categories = temp21.
    INSERT temp8 INTO TABLE temp7.
    temp4-categories = temp7.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Men`.
    
    CLEAR temp9.
    
    temp10-name = `Clothing`.
    
    CLEAR temp23.
    
    temp24-name = `Shirts`.
    
    CLEAR temp49.
    
    temp50-name = `Black T-shirt`.
    temp50-amount = `9.99`.
    temp50-currency = `USD`.
    temp50-size = `XL`.
    INSERT temp50 INTO TABLE temp49.
    temp50-name = `Polo T-shirt`.
    temp50-amount = `47.99`.
    temp50-currency = `USD`.
    temp50-size = `M`.
    INSERT temp50 INTO TABLE temp49.
    temp50-name = `White Shirt`.
    temp50-amount = `103.99`.
    temp50-currency = `USD`.
    temp50-size = `L`.
    INSERT temp50 INTO TABLE temp49.
    temp24-categories = temp49.
    INSERT temp24 INTO TABLE temp23.
    temp24-name = `Pants`.
    
    CLEAR temp51.
    
    temp52-name = `Blue Jeans`.
    temp52-amount = `78.99`.
    temp52-currency = `USD`.
    temp52-size = `M`.
    INSERT temp52 INTO TABLE temp51.
    temp52-name = `Stretch Pant`.
    temp52-amount = `54.99`.
    temp52-currency = `USD`.
    temp52-size = `S`.
    INSERT temp52 INTO TABLE temp51.
    temp24-categories = temp51.
    INSERT temp24 INTO TABLE temp23.
    temp24-name = `Shorts`.
    
    CLEAR temp53.
    
    temp54-name = `Trouser Short`.
    temp54-amount = `62.99`.
    temp54-currency = `USD`.
    temp54-size = `M`.
    INSERT temp54 INTO TABLE temp53.
    temp54-name = `Slim Short`.
    temp54-amount = `44.99`.
    temp54-currency = `USD`.
    temp54-size = `S`.
    INSERT temp54 INTO TABLE temp53.
    temp24-categories = temp53.
    INSERT temp24 INTO TABLE temp23.
    temp10-categories = temp23.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Accessories`.
    
    CLEAR temp25.
    
    temp26-name = `Tie`.
    temp26-amount = `36.99`.
    temp26-currency = `USD`.
    INSERT temp26 INTO TABLE temp25.
    temp26-name = `Wallet`.
    temp26-amount = `47.99`.
    temp26-currency = `USD`.
    INSERT temp26 INTO TABLE temp25.
    temp26-name = `Sunglasses`.
    temp26-amount = `199.99`.
    temp26-currency = `USD`.
    INSERT temp26 INTO TABLE temp25.
    temp10-categories = temp25.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Shoes`.
    
    CLEAR temp27.
    
    temp28-name = `Fashion Sneaker`.
    temp28-amount = `89.99`.
    temp28-currency = `USD`.
    INSERT temp28 INTO TABLE temp27.
    temp28-name = `Sport Shoe`.
    temp28-amount = `47.99`.
    temp28-currency = `USD`.
    INSERT temp28 INTO TABLE temp27.
    temp28-name = `Boots`.
    temp28-amount = `103.99`.
    temp28-currency = `USD`.
    INSERT temp28 INTO TABLE temp27.
    temp10-categories = temp27.
    INSERT temp10 INTO TABLE temp9.
    temp4-categories = temp9.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Girls`.
    
    CLEAR temp11.
    
    temp12-name = `Clothing`.
    
    CLEAR temp29.
    
    temp30-name = `Shirts`.
    
    CLEAR temp55.
    
    temp56-name = `Red T-shirt`.
    temp56-amount = `16.99`.
    temp56-currency = `USD`.
    temp56-size = `S`.
    INSERT temp56 INTO TABLE temp55.
    temp56-name = `Tunic Top`.
    temp56-amount = `47.99`.
    temp56-currency = `USD`.
    temp56-size = `M`.
    INSERT temp56 INTO TABLE temp55.
    temp56-name = `Fuzzy Sweater`.
    temp56-amount = `103.99`.
    temp56-currency = `USD`.
    temp56-size = `L`.
    INSERT temp56 INTO TABLE temp55.
    temp30-categories = temp55.
    INSERT temp30 INTO TABLE temp29.
    temp30-name = `Pants`.
    
    CLEAR temp57.
    
    temp58-name = `Blue Jeans`.
    temp58-amount = `24.99`.
    temp58-currency = `USD`.
    temp58-size = `M`.
    INSERT temp58 INTO TABLE temp57.
    temp58-name = `Red Pant`.
    temp58-amount = `54.99`.
    temp58-currency = `USD`.
    temp58-size = `S`.
    INSERT temp58 INTO TABLE temp57.
    temp30-categories = temp57.
    INSERT temp30 INTO TABLE temp29.
    temp30-name = `Shorts`.
    
    CLEAR temp59.
    
    temp60-name = `Jeans Short`.
    temp60-amount = `32.99`.
    temp60-currency = `USD`.
    temp60-size = `M`.
    INSERT temp60 INTO TABLE temp59.
    temp60-name = `Sport Short`.
    temp60-amount = `14.99`.
    temp60-currency = `USD`.
    temp60-size = `S`.
    INSERT temp60 INTO TABLE temp59.
    temp30-categories = temp59.
    INSERT temp30 INTO TABLE temp29.
    temp12-categories = temp29.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Accessories`.
    
    CLEAR temp31.
    
    temp32-name = `Necklace`.
    temp32-amount = `26.99`.
    temp32-currency = `USD`.
    INSERT temp32 INTO TABLE temp31.
    temp32-name = `Gloves`.
    temp32-amount = `7.99`.
    temp32-currency = `USD`.
    INSERT temp32 INTO TABLE temp31.
    temp32-name = `Beanie`.
    temp32-amount = `12.99`.
    temp32-currency = `USD`.
    INSERT temp32 INTO TABLE temp31.
    temp12-categories = temp31.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Shoes`.
    
    CLEAR temp33.
    
    temp34-name = `Sport Shoes`.
    temp34-amount = `39.99`.
    temp34-currency = `USD`.
    INSERT temp34 INTO TABLE temp33.
    temp34-name = `Boots`.
    temp34-amount = `87.99`.
    temp34-currency = `USD`.
    INSERT temp34 INTO TABLE temp33.
    temp34-name = `Sandals`.
    temp34-amount = `63.99`.
    temp34-currency = `USD`.
    INSERT temp34 INTO TABLE temp33.
    temp12-categories = temp33.
    INSERT temp12 INTO TABLE temp11.
    temp4-categories = temp11.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Boys`.
    
    CLEAR temp13.
    
    temp14-name = `Clothing`.
    
    CLEAR temp35.
    
    temp36-name = `Shirts`.
    
    CLEAR temp61.
    
    temp62-name = `Black T-shirt with Print`.
    temp62-amount = `16.99`.
    temp62-currency = `USD`.
    temp62-size = `S`.
    INSERT temp62 INTO TABLE temp61.
    temp62-name = `Blue Shirt`.
    temp62-amount = `47.99`.
    temp62-currency = `USD`.
    temp62-size = `M`.
    INSERT temp62 INTO TABLE temp61.
    temp62-name = `Yellow Sweater`.
    temp62-amount = `63.99`.
    temp62-currency = `USD`.
    temp62-size = `L`.
    INSERT temp62 INTO TABLE temp61.
    temp36-categories = temp61.
    INSERT temp36 INTO TABLE temp35.
    temp36-name = `Pants`.
    
    CLEAR temp63.
    
    temp64-name = `Blue Jeans`.
    temp64-amount = `44.99`.
    temp64-currency = `USD`.
    temp64-size = `M`.
    INSERT temp64 INTO TABLE temp63.
    temp64-name = `Brown Pant`.
    temp64-amount = `89.99`.
    temp64-currency = `USD`.
    temp64-size = `S`.
    INSERT temp64 INTO TABLE temp63.
    temp36-categories = temp63.
    INSERT temp36 INTO TABLE temp35.
    temp36-name = `Shorts`.
    
    CLEAR temp65.
    
    temp66-name = `Sport Short`.
    temp66-amount = `32.99`.
    temp66-currency = `USD`.
    temp66-size = `M`.
    INSERT temp66 INTO TABLE temp65.
    temp66-name = `Jeans Short`.
    temp66-amount = `99.99`.
    temp66-currency = `USD`.
    temp66-size = `XS`.
    INSERT temp66 INTO TABLE temp65.
    temp66-name = `Black Short`.
    temp66-amount = `56.99`.
    temp66-currency = `USD`.
    temp66-size = `L`.
    INSERT temp66 INTO TABLE temp65.
    temp36-categories = temp65.
    INSERT temp36 INTO TABLE temp35.
    temp14-categories = temp35.
    INSERT temp14 INTO TABLE temp13.
    temp14-name = `Accessories`.
    
    CLEAR temp37.
    
    temp38-name = `Sunglasses`.
    temp38-amount = `36.99`.
    temp38-currency = `USD`.
    INSERT temp38 INTO TABLE temp37.
    temp38-name = `Beanie`.
    temp38-amount = `17.99`.
    temp38-currency = `USD`.
    INSERT temp38 INTO TABLE temp37.
    temp38-name = `Scarf`.
    temp38-amount = `15.99`.
    temp38-currency = `USD`.
    INSERT temp38 INTO TABLE temp37.
    temp14-categories = temp37.
    INSERT temp14 INTO TABLE temp13.
    temp14-name = `Shoes`.
    
    CLEAR temp39.
    
    temp40-name = `Sneaker`.
    temp40-amount = `89.99`.
    temp40-currency = `USD`.
    INSERT temp40 INTO TABLE temp39.
    temp40-name = `Sport Shoe`.
    temp40-amount = `47.99`.
    temp40-currency = `USD`.
    INSERT temp40 INTO TABLE temp39.
    temp40-name = `Boots`.
    temp40-amount = `103.99`.
    temp40-currency = `USD`.
    INSERT temp40 INTO TABLE temp39.
    temp14-categories = temp39.
    INSERT temp14 INTO TABLE temp13.
    temp4-categories = temp13.
    INSERT temp4 INTO TABLE temp3.
    catalog-clothing-categories = temp3.

    " /sizes - the shared Select item list
    
    CLEAR temp5.
    
    temp6-key = `XS`.
    temp6-value = `Extra Small`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `S`.
    temp6-value = `Small`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `M`.
    temp6-value = `Medium`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `L`.
    temp6-value = `Large`.
    INSERT temp6 INTO TABLE temp5.
    sizes = temp5.

  ENDMETHOD.

ENDCLASS.
