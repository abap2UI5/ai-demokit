" @keywords treetable tree table sap.ui.table treetable.hierarchymaintenancejsontreebinding overflowtoolbar title button toolbarspacer dragdropinfo column label
" @summary Shows how hierarchy maintenance can be done using drag and drop.
CLASS z2ui5_cl_smpc_app_365 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

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


CLASS z2ui5_cl_smpc_app_365 IMPLEMENTATION.

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
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    " the hierarchy-maintenance tree. Collapse all / Expand first level are the
    " TreeTable's own methods and are driven as frontend actions; the cut,
    " paste and drag & drop handlers re-parent nodes, which a typed ABAP
    " nesting cannot express (see the sidecar).
    
    CLEAR temp1.
    INSERT `TreeTable` INTO TABLE temp1.
    INSERT `collapseAll` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `TreeTable` INTO TABLE temp2.
    INSERT `expandToLevel` INTO TABLE temp2.
    INSERT `1` INTO TABLE temp2.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.ui.table`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`    v = `sap.m`
        )->a( n = `xmlns:u`    v = `sap.ui.unified`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:dnd`  v = `sap.ui.core.dnd`
        )->a( n = `height`     v = `100%`

        )->ele( n = `Page` ns = `m`
            )->a( n = `showHeader`      v = `false`
            )->a( n = `enableScrolling` v = `false`

            )->ele( n = `content` ns = `m`
                )->ele( `TreeTable`
                    )->a( n = `id`              v = `TreeTable`
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

                            )->tag( n = `Button` ns = `m`
                                )->a( n = `id`   v = `cut`
                                )->a( n = `text` v = `Cut`
                                )->a( n = `icon` v = `sap-icon://scissors`

                            )->tag( n = `Button` ns = `m`
                                )->a( n = `id`      v = `paste`
                                )->a( n = `text`    v = `Paste`
                                )->a( n = `icon`    v = `sap-icon://paste`
                                )->a( n = `enabled` v = `false`

                            )->tag( n = `ToolbarSpacer` ns = `m`

                            )->tag( n = `Button` ns = `m`
                                )->a( n = `text`  v = `Collapse all`
                                )->a( n = `press` v = client->follow_up_action(
                                          val   = client->cs_event-control_by_id
                                          t_arg = temp1 )

                            )->tag( n = `Button` ns = `m`
                                )->a( n = `text`  v = `Expand first level`
                                )->a( n = `press` v = client->follow_up_action(
                                          val   = client->cs_event-control_by_id
                                          t_arg = temp2 )

                        )->end(
                    )->end(
                    )->ele( `dragDropConfig`
                        )->tag( n = `DragDropInfo` ns = `dnd`
                            )->a( n = `sourceAggregation` v = `rows`
                            )->a( n = `targetAggregation` v = `rows`
                            " enabled="false" is NOT in the original, and it is
                            " here because the re-parenting behind dragStart /
                            " drop is dropped (see the deviation). DropInfo
                            " .isDroppable never asks whether anyone listens, so
                            " leaving the configuration active shipped draggable
                            " rows and a live drop indicator that discarded
                            " every drop - an affordance promising something the
                            " port cannot do. Off is honest; removing the
                            " control entirely would lose the structural trace
                            " of what the sample declares here.
                            )->a( n = `enabled`           v = `false`

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
                                )->tag( n = `Currency` ns = `u`
                                    )->a( n = `value`    v = `{AMOUNT}`
                                    )->a( n = `currency` v = `{CURRENCY}`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Size`

                            )->ele( `template`
                                )->ele( n = `Select` ns = `m`
                                    )->a( n = `items`          v = |\{ path: '{ client->_bind_path( sizes ) }', templateShareable: true \}|
                                    )->a( n = `selectedKey`    v = `{SIZE}`
                                    )->a( n = `visible`        v = `{= !!${SIZE} }`
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
    DATA temp3 TYPE z2ui5_cl_smpc_app_365=>ty_t_root.
    DATA temp4 LIKE LINE OF temp3.
    DATA temp7 TYPE z2ui5_cl_smpc_app_365=>ty_t_area.
    DATA temp8 LIKE LINE OF temp7.
    DATA temp1 TYPE z2ui5_cl_smpc_app_365=>ty_t_group.
    DATA temp2 LIKE LINE OF temp1.
    DATA temp39 TYPE z2ui5_cl_smpc_app_365=>ty_t_article.
    DATA temp40 LIKE LINE OF temp39.
    DATA temp41 TYPE z2ui5_cl_smpc_app_365=>ty_t_article.
    DATA temp42 LIKE LINE OF temp41.
    DATA temp43 TYPE z2ui5_cl_smpc_app_365=>ty_t_article.
    DATA temp44 LIKE LINE OF temp43.
    DATA temp45 TYPE z2ui5_cl_smpc_app_365=>ty_t_article.
    DATA temp46 LIKE LINE OF temp45.
    DATA temp15 TYPE z2ui5_cl_smpc_app_365=>ty_t_group.
    DATA temp16 LIKE LINE OF temp15.
    DATA temp17 TYPE z2ui5_cl_smpc_app_365=>ty_t_group.
    DATA temp18 LIKE LINE OF temp17.
    DATA temp19 TYPE z2ui5_cl_smpc_app_365=>ty_t_group.
    DATA temp20 LIKE LINE OF temp19.
    DATA temp9 TYPE z2ui5_cl_smpc_app_365=>ty_t_area.
    DATA temp10 LIKE LINE OF temp9.
    DATA temp21 TYPE z2ui5_cl_smpc_app_365=>ty_t_group.
    DATA temp22 LIKE LINE OF temp21.
    DATA temp47 TYPE z2ui5_cl_smpc_app_365=>ty_t_article.
    DATA temp48 LIKE LINE OF temp47.
    DATA temp49 TYPE z2ui5_cl_smpc_app_365=>ty_t_article.
    DATA temp50 LIKE LINE OF temp49.
    DATA temp51 TYPE z2ui5_cl_smpc_app_365=>ty_t_article.
    DATA temp52 LIKE LINE OF temp51.
    DATA temp23 TYPE z2ui5_cl_smpc_app_365=>ty_t_group.
    DATA temp24 LIKE LINE OF temp23.
    DATA temp25 TYPE z2ui5_cl_smpc_app_365=>ty_t_group.
    DATA temp26 LIKE LINE OF temp25.
    DATA temp11 TYPE z2ui5_cl_smpc_app_365=>ty_t_area.
    DATA temp12 LIKE LINE OF temp11.
    DATA temp27 TYPE z2ui5_cl_smpc_app_365=>ty_t_group.
    DATA temp28 LIKE LINE OF temp27.
    DATA temp53 TYPE z2ui5_cl_smpc_app_365=>ty_t_article.
    DATA temp54 LIKE LINE OF temp53.
    DATA temp55 TYPE z2ui5_cl_smpc_app_365=>ty_t_article.
    DATA temp56 LIKE LINE OF temp55.
    DATA temp57 TYPE z2ui5_cl_smpc_app_365=>ty_t_article.
    DATA temp58 LIKE LINE OF temp57.
    DATA temp29 TYPE z2ui5_cl_smpc_app_365=>ty_t_group.
    DATA temp30 LIKE LINE OF temp29.
    DATA temp31 TYPE z2ui5_cl_smpc_app_365=>ty_t_group.
    DATA temp32 LIKE LINE OF temp31.
    DATA temp13 TYPE z2ui5_cl_smpc_app_365=>ty_t_area.
    DATA temp14 LIKE LINE OF temp13.
    DATA temp33 TYPE z2ui5_cl_smpc_app_365=>ty_t_group.
    DATA temp34 LIKE LINE OF temp33.
    DATA temp59 TYPE z2ui5_cl_smpc_app_365=>ty_t_article.
    DATA temp60 LIKE LINE OF temp59.
    DATA temp61 TYPE z2ui5_cl_smpc_app_365=>ty_t_article.
    DATA temp62 LIKE LINE OF temp61.
    DATA temp63 TYPE z2ui5_cl_smpc_app_365=>ty_t_article.
    DATA temp64 LIKE LINE OF temp63.
    DATA temp35 TYPE z2ui5_cl_smpc_app_365=>ty_t_group.
    DATA temp36 LIKE LINE OF temp35.
    DATA temp37 TYPE z2ui5_cl_smpc_app_365=>ty_t_group.
    DATA temp38 LIKE LINE OF temp37.
    DATA temp5 LIKE sizes.
    DATA temp6 LIKE LINE OF temp5.
    CLEAR temp3.
    
    temp4-name = `Women`.
    
    CLEAR temp7.
    
    temp8-name = `Clothing`.
    
    CLEAR temp1.
    
    temp2-name = `Dresses`.
    
    CLEAR temp39.
    
    temp40-name = `Casual Red Dress`.
    temp40-amount = `16.99`.
    temp40-currency = `EUR`.
    temp40-size = `S`.
    INSERT temp40 INTO TABLE temp39.
    temp40-name = `Short Black Dress`.
    temp40-amount = `47.99`.
    temp40-currency = `EUR`.
    temp40-size = `M`.
    INSERT temp40 INTO TABLE temp39.
    temp40-name = `Long Blue Dinner Dress`.
    temp40-amount = `103.99`.
    temp40-currency = `USD`.
    temp40-size = `L`.
    INSERT temp40 INTO TABLE temp39.
    temp2-categories = temp39.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Tops`.
    
    CLEAR temp41.
    
    temp42-name = `Printed Shirt`.
    temp42-amount = `24.99`.
    temp42-currency = `USD`.
    temp42-size = `M`.
    INSERT temp42 INTO TABLE temp41.
    temp42-name = `Tank Top`.
    temp42-amount = `14.99`.
    temp42-currency = `USD`.
    temp42-size = `S`.
    INSERT temp42 INTO TABLE temp41.
    temp2-categories = temp41.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Pants`.
    
    CLEAR temp43.
    
    temp44-name = `Red Pant`.
    temp44-amount = `32.99`.
    temp44-currency = `USD`.
    temp44-size = `M`.
    INSERT temp44 INTO TABLE temp43.
    temp44-name = `Skinny Jeans`.
    temp44-amount = `44.99`.
    temp44-currency = `USD`.
    temp44-size = `S`.
    INSERT temp44 INTO TABLE temp43.
    temp44-name = `Black Jeans`.
    temp44-amount = `99.99`.
    temp44-currency = `USD`.
    temp44-size = `XS`.
    INSERT temp44 INTO TABLE temp43.
    temp44-name = `Relaxed Fit Jeans`.
    temp44-amount = `56.99`.
    temp44-currency = `USD`.
    temp44-size = `L`.
    INSERT temp44 INTO TABLE temp43.
    temp2-categories = temp43.
    INSERT temp2 INTO TABLE temp1.
    temp2-name = `Skirts`.
    
    CLEAR temp45.
    
    temp46-name = `Striped Skirt`.
    temp46-amount = `24.99`.
    temp46-currency = `USD`.
    temp46-size = `M`.
    INSERT temp46 INTO TABLE temp45.
    temp46-name = `Black Skirt`.
    temp46-amount = `44.99`.
    temp46-currency = `USD`.
    temp46-size = `S`.
    INSERT temp46 INTO TABLE temp45.
    temp2-categories = temp45.
    INSERT temp2 INTO TABLE temp1.
    temp8-categories = temp1.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Jewelry`.
    
    CLEAR temp15.
    
    temp16-name = `Necklace`.
    temp16-amount = `16.99`.
    temp16-currency = `USD`.
    INSERT temp16 INTO TABLE temp15.
    temp16-name = `Bracelet`.
    temp16-amount = `47.99`.
    temp16-currency = `USD`.
    INSERT temp16 INTO TABLE temp15.
    temp16-name = `Gold Ring`.
    temp16-amount = `399.99`.
    temp16-currency = `USD`.
    INSERT temp16 INTO TABLE temp15.
    temp8-categories = temp15.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Handbags`.
    
    CLEAR temp17.
    
    temp18-name = `Little Black Bag`.
    temp18-amount = `16.99`.
    temp18-currency = `USD`.
    temp18-size = `S`.
    INSERT temp18 INTO TABLE temp17.
    temp18-name = `Grey Shopper`.
    temp18-amount = `47.99`.
    temp18-currency = `USD`.
    temp18-size = `M`.
    INSERT temp18 INTO TABLE temp17.
    temp8-categories = temp17.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Shoes`.
    
    CLEAR temp19.
    
    temp20-name = `Pumps`.
    temp20-amount = `89.99`.
    temp20-currency = `USD`.
    INSERT temp20 INTO TABLE temp19.
    temp20-name = `Sport Shoes`.
    temp20-amount = `47.99`.
    temp20-currency = `USD`.
    INSERT temp20 INTO TABLE temp19.
    temp20-name = `Boots`.
    temp20-amount = `103.99`.
    temp20-currency = `USD`.
    INSERT temp20 INTO TABLE temp19.
    temp8-categories = temp19.
    INSERT temp8 INTO TABLE temp7.
    temp4-categories = temp7.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Men`.
    
    CLEAR temp9.
    
    temp10-name = `Clothing`.
    
    CLEAR temp21.
    
    temp22-name = `Shirts`.
    
    CLEAR temp47.
    
    temp48-name = `Black T-shirt`.
    temp48-amount = `9.99`.
    temp48-currency = `USD`.
    temp48-size = `XL`.
    INSERT temp48 INTO TABLE temp47.
    temp48-name = `Polo T-shirt`.
    temp48-amount = `47.99`.
    temp48-currency = `USD`.
    temp48-size = `M`.
    INSERT temp48 INTO TABLE temp47.
    temp48-name = `White Shirt`.
    temp48-amount = `103.99`.
    temp48-currency = `USD`.
    temp48-size = `L`.
    INSERT temp48 INTO TABLE temp47.
    temp22-categories = temp47.
    INSERT temp22 INTO TABLE temp21.
    temp22-name = `Pants`.
    
    CLEAR temp49.
    
    temp50-name = `Blue Jeans`.
    temp50-amount = `78.99`.
    temp50-currency = `USD`.
    temp50-size = `M`.
    INSERT temp50 INTO TABLE temp49.
    temp50-name = `Stretch Pant`.
    temp50-amount = `54.99`.
    temp50-currency = `USD`.
    temp50-size = `S`.
    INSERT temp50 INTO TABLE temp49.
    temp22-categories = temp49.
    INSERT temp22 INTO TABLE temp21.
    temp22-name = `Shorts`.
    
    CLEAR temp51.
    
    temp52-name = `Trouser Short`.
    temp52-amount = `62.99`.
    temp52-currency = `USD`.
    temp52-size = `M`.
    INSERT temp52 INTO TABLE temp51.
    temp52-name = `Slim Short`.
    temp52-amount = `44.99`.
    temp52-currency = `USD`.
    temp52-size = `S`.
    INSERT temp52 INTO TABLE temp51.
    temp22-categories = temp51.
    INSERT temp22 INTO TABLE temp21.
    temp10-categories = temp21.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Accessories`.
    
    CLEAR temp23.
    
    temp24-name = `Tie`.
    temp24-amount = `36.99`.
    temp24-currency = `USD`.
    INSERT temp24 INTO TABLE temp23.
    temp24-name = `Wallet`.
    temp24-amount = `47.99`.
    temp24-currency = `USD`.
    INSERT temp24 INTO TABLE temp23.
    temp24-name = `Sunglasses`.
    temp24-amount = `199.99`.
    temp24-currency = `USD`.
    INSERT temp24 INTO TABLE temp23.
    temp10-categories = temp23.
    INSERT temp10 INTO TABLE temp9.
    temp10-name = `Shoes`.
    
    CLEAR temp25.
    
    temp26-name = `Fashion Sneaker`.
    temp26-amount = `89.99`.
    temp26-currency = `USD`.
    INSERT temp26 INTO TABLE temp25.
    temp26-name = `Sport Shoe`.
    temp26-amount = `47.99`.
    temp26-currency = `USD`.
    INSERT temp26 INTO TABLE temp25.
    temp26-name = `Boots`.
    temp26-amount = `103.99`.
    temp26-currency = `USD`.
    INSERT temp26 INTO TABLE temp25.
    temp10-categories = temp25.
    INSERT temp10 INTO TABLE temp9.
    temp4-categories = temp9.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Girls`.
    
    CLEAR temp11.
    
    temp12-name = `Clothing`.
    
    CLEAR temp27.
    
    temp28-name = `Shirts`.
    
    CLEAR temp53.
    
    temp54-name = `Red T-shirt`.
    temp54-amount = `16.99`.
    temp54-currency = `USD`.
    temp54-size = `S`.
    INSERT temp54 INTO TABLE temp53.
    temp54-name = `Tunic Top`.
    temp54-amount = `47.99`.
    temp54-currency = `USD`.
    temp54-size = `M`.
    INSERT temp54 INTO TABLE temp53.
    temp54-name = `Fuzzy Sweater`.
    temp54-amount = `103.99`.
    temp54-currency = `USD`.
    temp54-size = `L`.
    INSERT temp54 INTO TABLE temp53.
    temp28-categories = temp53.
    INSERT temp28 INTO TABLE temp27.
    temp28-name = `Pants`.
    
    CLEAR temp55.
    
    temp56-name = `Blue Jeans`.
    temp56-amount = `24.99`.
    temp56-currency = `USD`.
    temp56-size = `M`.
    INSERT temp56 INTO TABLE temp55.
    temp56-name = `Red Pant`.
    temp56-amount = `54.99`.
    temp56-currency = `USD`.
    temp56-size = `S`.
    INSERT temp56 INTO TABLE temp55.
    temp28-categories = temp55.
    INSERT temp28 INTO TABLE temp27.
    temp28-name = `Shorts`.
    
    CLEAR temp57.
    
    temp58-name = `Jeans Short`.
    temp58-amount = `32.99`.
    temp58-currency = `USD`.
    temp58-size = `M`.
    INSERT temp58 INTO TABLE temp57.
    temp58-name = `Sport Short`.
    temp58-amount = `14.99`.
    temp58-currency = `USD`.
    temp58-size = `S`.
    INSERT temp58 INTO TABLE temp57.
    temp28-categories = temp57.
    INSERT temp28 INTO TABLE temp27.
    temp12-categories = temp27.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Accessories`.
    
    CLEAR temp29.
    
    temp30-name = `Necklace`.
    temp30-amount = `26.99`.
    temp30-currency = `USD`.
    INSERT temp30 INTO TABLE temp29.
    temp30-name = `Gloves`.
    temp30-amount = `7.99`.
    temp30-currency = `USD`.
    INSERT temp30 INTO TABLE temp29.
    temp30-name = `Beanie`.
    temp30-amount = `12.99`.
    temp30-currency = `USD`.
    INSERT temp30 INTO TABLE temp29.
    temp12-categories = temp29.
    INSERT temp12 INTO TABLE temp11.
    temp12-name = `Shoes`.
    
    CLEAR temp31.
    
    temp32-name = `Sport Shoes`.
    temp32-amount = `39.99`.
    temp32-currency = `USD`.
    INSERT temp32 INTO TABLE temp31.
    temp32-name = `Boots`.
    temp32-amount = `87.99`.
    temp32-currency = `USD`.
    INSERT temp32 INTO TABLE temp31.
    temp32-name = `Sandals`.
    temp32-amount = `63.99`.
    temp32-currency = `USD`.
    INSERT temp32 INTO TABLE temp31.
    temp12-categories = temp31.
    INSERT temp12 INTO TABLE temp11.
    temp4-categories = temp11.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Boys`.
    
    CLEAR temp13.
    
    temp14-name = `Clothing`.
    
    CLEAR temp33.
    
    temp34-name = `Shirts`.
    
    CLEAR temp59.
    
    temp60-name = `Black T-shirt with Print`.
    temp60-amount = `16.99`.
    temp60-currency = `USD`.
    temp60-size = `S`.
    INSERT temp60 INTO TABLE temp59.
    temp60-name = `Blue Shirt`.
    temp60-amount = `47.99`.
    temp60-currency = `USD`.
    temp60-size = `M`.
    INSERT temp60 INTO TABLE temp59.
    temp60-name = `Yellow Sweater`.
    temp60-amount = `63.99`.
    temp60-currency = `USD`.
    temp60-size = `L`.
    INSERT temp60 INTO TABLE temp59.
    temp34-categories = temp59.
    INSERT temp34 INTO TABLE temp33.
    temp34-name = `Pants`.
    
    CLEAR temp61.
    
    temp62-name = `Blue Jeans`.
    temp62-amount = `44.99`.
    temp62-currency = `USD`.
    temp62-size = `M`.
    INSERT temp62 INTO TABLE temp61.
    temp62-name = `Brown Pant`.
    temp62-amount = `89.99`.
    temp62-currency = `USD`.
    temp62-size = `S`.
    INSERT temp62 INTO TABLE temp61.
    temp34-categories = temp61.
    INSERT temp34 INTO TABLE temp33.
    temp34-name = `Shorts`.
    
    CLEAR temp63.
    
    temp64-name = `Sport Short`.
    temp64-amount = `32.99`.
    temp64-currency = `USD`.
    temp64-size = `M`.
    INSERT temp64 INTO TABLE temp63.
    temp64-name = `Jeans Short`.
    temp64-amount = `99.99`.
    temp64-currency = `USD`.
    temp64-size = `XS`.
    INSERT temp64 INTO TABLE temp63.
    temp64-name = `Black Short`.
    temp64-amount = `56.99`.
    temp64-currency = `USD`.
    temp64-size = `L`.
    INSERT temp64 INTO TABLE temp63.
    temp34-categories = temp63.
    INSERT temp34 INTO TABLE temp33.
    temp14-categories = temp33.
    INSERT temp14 INTO TABLE temp13.
    temp14-name = `Accessories`.
    
    CLEAR temp35.
    
    temp36-name = `Sunglasses`.
    temp36-amount = `36.99`.
    temp36-currency = `USD`.
    INSERT temp36 INTO TABLE temp35.
    temp36-name = `Beanie`.
    temp36-amount = `17.99`.
    temp36-currency = `USD`.
    INSERT temp36 INTO TABLE temp35.
    temp36-name = `Scarf`.
    temp36-amount = `15.99`.
    temp36-currency = `USD`.
    INSERT temp36 INTO TABLE temp35.
    temp14-categories = temp35.
    INSERT temp14 INTO TABLE temp13.
    temp14-name = `Shoes`.
    
    CLEAR temp37.
    
    temp38-name = `Sneaker`.
    temp38-amount = `89.99`.
    temp38-currency = `USD`.
    INSERT temp38 INTO TABLE temp37.
    temp38-name = `Sport Shoe`.
    temp38-amount = `47.99`.
    temp38-currency = `USD`.
    INSERT temp38 INTO TABLE temp37.
    temp38-name = `Boots`.
    temp38-amount = `103.99`.
    temp38-currency = `USD`.
    INSERT temp38 INTO TABLE temp37.
    temp14-categories = temp37.
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
