CLASS z2ui5_cl_dmo_app_365 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_article,
        name     TYPE string,
        amount   TYPE p LENGTH 5 DECIMALS 2,
        currency TYPE string,
        size     TYPE string,
      END OF ty_s_article.
    TYPES ty_t_article TYPE STANDARD TABLE OF ty_s_article WITH EMPTY KEY.
    TYPES:
      BEGIN OF ty_s_group,
        name       TYPE string,
        amount     TYPE p LENGTH 5 DECIMALS 2,
        currency   TYPE string,
        size       TYPE string,
        categories TYPE ty_t_article,
      END OF ty_s_group.
    TYPES ty_t_group TYPE STANDARD TABLE OF ty_s_group WITH EMPTY KEY.
    TYPES:
      BEGIN OF ty_s_area,
        name       TYPE string,
        categories TYPE ty_t_group,
      END OF ty_s_area.
    TYPES ty_t_area TYPE STANDARD TABLE OF ty_s_area WITH EMPTY KEY.
    TYPES:
      BEGIN OF ty_s_root,
        name       TYPE string,
        categories TYPE ty_t_area,
      END OF ty_s_root.
    TYPES ty_t_root TYPE STANDARD TABLE OF ty_s_root WITH EMPTY KEY.
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
    DATA sizes   TYPE STANDARD TABLE OF ty_s_size WITH EMPTY KEY.
  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_dmo_app_365 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    " the hierarchy-maintenance tree. Collapse all / Expand first level are the
    " TreeTable's own methods and are driven as frontend actions; the cut,
    " paste and drag & drop handlers re-parent nodes, which a typed ABAP
    " nesting cannot express (see the sidecar).
    view->open( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.ui.table`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:m`    v = `sap.m`
        )->a( n = `xmlns:u`    v = `sap.ui.unified`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:dnd`  v = `sap.ui.core.dnd`
        )->a( n = `height`     v = `100%`

        )->open( n = `Page` ns = `m`
            )->a( n = `showHeader`      v = `false`
            )->a( n = `enableScrolling` v = `false`

            )->open( n = `content` ns = `m`
                )->open( `TreeTable`
                    )->a( n = `id`              v = `TreeTable`
                    )->a( n = `rows`            v = |\{ path: '{ client->_bind( val = catalog-clothing path = abap_true ) }', parameters: \{ arrayNames: ['CATEGORIES'] \} \}|
                    )->a( n = `selectionMode`   v = `MultiToggle`
                    )->a( n = `enableSelectAll` v = `false`
                    )->a( n = `ariaLabelledBy`  v = `title`

                    )->open( `extension`
                        )->open( n = `OverflowToolbar` ns = `m`
                            )->a( n = `style` v = `Clear`

                            )->leaf( n = `Title` ns = `m`
                                )->a( n = `id`   v = `title`
                                )->a( n = `text` v = `Clothing`

                            )->leaf( n = `Button` ns = `m`
                                )->a( n = `id`   v = `cut`
                                )->a( n = `text` v = `Cut`
                                )->a( n = `icon` v = `sap-icon://scissors`

                            )->leaf( n = `Button` ns = `m`
                                )->a( n = `id`      v = `paste`
                                )->a( n = `text`    v = `Paste`
                                )->a( n = `icon`    v = `sap-icon://paste`
                                )->a( n = `enabled` v = `false`

                            )->leaf( n = `ToolbarSpacer` ns = `m`

                            )->leaf( n = `Button` ns = `m`
                                )->a( n = `text`  v = `Collapse all`
                                )->a( n = `press` v = client->_event_client(
                                          val   = client->cs_event-control_by_id
                                          t_arg = VALUE #( ( `TreeTable` ) ( `collapseAll` ) ) )

                            )->leaf( n = `Button` ns = `m`
                                )->a( n = `text`  v = `Expand first level`
                                )->a( n = `press` v = client->_event_client(
                                          val   = client->cs_event-control_by_id
                                          t_arg = VALUE #( ( `TreeTable` ) ( `expandToLevel` ) ( `1` ) ) )

                        )->shut(
                    )->shut(
                    )->open( `dragDropConfig`
                        )->leaf( n = `DragDropInfo` ns = `dnd`
                            )->a( n = `sourceAggregation` v = `rows`
                            )->a( n = `targetAggregation` v = `rows`

                    )->shut(
                    )->open( `columns`
                        )->open( `Column`
                            )->a( n = `width` v = `13rem`

                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Categories`

                            )->open( `template`
                                )->leaf( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{NAME}`
                                    )->a( n = `wrapping` v = `false`

                            )->shut(
                        )->shut(
                        )->open( `Column`
                            )->a( n = `width` v = `9rem`

                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Price`

                            )->open( `template`
                                )->leaf( n = `Currency` ns = `u`
                                    )->a( n = `value`    v = `{AMOUNT}`
                                    )->a( n = `currency` v = `{CURRENCY}`

                            )->shut(
                        )->shut(
                        )->open( `Column`
                            )->leaf( n = `Label` ns = `m`
                                )->a( n = `text` v = `Size`

                            )->open( `template`
                                )->open( n = `Select` ns = `m`
                                    )->a( n = `items`          v = |\{ path: '{ client->_bind( val = sizes path = abap_true ) }', templateShareable: true \}|
                                    )->a( n = `selectedKey`    v = `{SIZE}`
                                    )->a( n = `visible`        v = `{= !!${SIZE} }`
                                    )->a( n = `forceSelection` v = `false`

                                    )->leaf( n = `Item` ns = `core`
                                        )->a( n = `key`  v = `{KEY}`
                                        )->a( n = `text` v = `{VALUE}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " Clothing.json 1:1 - the full tree (Women/Men/Girls/Boys), every leaf
    " with its amount/currency/size; a leaf without a size in the JSON keeps
    " the field initial so the Select stays hidden via the !!SIZE guard
    catalog-clothing-categories = VALUE #(
          ( name = `Women` categories = VALUE #(
              ( name = `Clothing` categories = VALUE #(
                  ( name = `Dresses` categories = VALUE #(
                      ( name = `Casual Red Dress` amount = `16.99` currency = `EUR` size = `S` )
                      ( name = `Short Black Dress` amount = `47.99` currency = `EUR` size = `M` )
                      ( name = `Long Blue Dinner Dress` amount = `103.99` currency = `USD` size = `L` ) ) )
                  ( name = `Tops` categories = VALUE #(
                      ( name = `Printed Shirt` amount = `24.99` currency = `USD` size = `M` )
                      ( name = `Tank Top` amount = `14.99` currency = `USD` size = `S` ) ) )
                  ( name = `Pants` categories = VALUE #(
                      ( name = `Red Pant` amount = `32.99` currency = `USD` size = `M` )
                      ( name = `Skinny Jeans` amount = `44.99` currency = `USD` size = `S` )
                      ( name = `Black Jeans` amount = `99.99` currency = `USD` size = `XS` )
                      ( name = `Relaxed Fit Jeans` amount = `56.99` currency = `USD` size = `L` ) ) )
                  ( name = `Skirts` categories = VALUE #(
                      ( name = `Striped Skirt` amount = `24.99` currency = `USD` size = `M` )
                      ( name = `Black Skirt` amount = `44.99` currency = `USD` size = `S` ) ) ) ) )
              ( name = `Jewelry` categories = VALUE #(
                  ( name = `Necklace` amount = `16.99` currency = `USD` )
                  ( name = `Bracelet` amount = `47.99` currency = `USD` )
                  ( name = `Gold Ring` amount = `399.99` currency = `USD` ) ) )
              ( name = `Handbags` categories = VALUE #(
                  ( name = `Little Black Bag` amount = `16.99` currency = `USD` size = `S` )
                  ( name = `Grey Shopper` amount = `47.99` currency = `USD` size = `M` ) ) )
              ( name = `Shoes` categories = VALUE #(
                  ( name = `Pumps` amount = `89.99` currency = `USD` )
                  ( name = `Sport Shoes` amount = `47.99` currency = `USD` )
                  ( name = `Boots` amount = `103.99` currency = `USD` ) ) ) ) )
          ( name = `Men` categories = VALUE #(
              ( name = `Clothing` categories = VALUE #(
                  ( name = `Shirts` categories = VALUE #(
                      ( name = `Black T-shirt` amount = `9.99` currency = `USD` size = `XL` )
                      ( name = `Polo T-shirt` amount = `47.99` currency = `USD` size = `M` )
                      ( name = `White Shirt` amount = `103.99` currency = `USD` size = `L` ) ) )
                  ( name = `Pants` categories = VALUE #(
                      ( name = `Blue Jeans` amount = `78.99` currency = `USD` size = `M` )
                      ( name = `Stretch Pant` amount = `54.99` currency = `USD` size = `S` ) ) )
                  ( name = `Shorts` categories = VALUE #(
                      ( name = `Trouser Short` amount = `62.99` currency = `USD` size = `M` )
                      ( name = `Slim Short` amount = `44.99` currency = `USD` size = `S` ) ) ) ) )
              ( name = `Accessories` categories = VALUE #(
                  ( name = `Tie` amount = `36.99` currency = `USD` )
                  ( name = `Wallet` amount = `47.99` currency = `USD` )
                  ( name = `Sunglasses` amount = `199.99` currency = `USD` ) ) )
              ( name = `Shoes` categories = VALUE #(
                  ( name = `Fashion Sneaker` amount = `89.99` currency = `USD` )
                  ( name = `Sport Shoe` amount = `47.99` currency = `USD` )
                  ( name = `Boots` amount = `103.99` currency = `USD` ) ) ) ) )
          ( name = `Girls` categories = VALUE #(
              ( name = `Clothing` categories = VALUE #(
                  ( name = `Shirts` categories = VALUE #(
                      ( name = `Red T-shirt` amount = `16.99` currency = `USD` size = `S` )
                      ( name = `Tunic Top` amount = `47.99` currency = `USD` size = `M` )
                      ( name = `Fuzzy Sweater` amount = `103.99` currency = `USD` size = `L` ) ) )
                  ( name = `Pants` categories = VALUE #(
                      ( name = `Blue Jeans` amount = `24.99` currency = `USD` size = `M` )
                      ( name = `Red Pant` amount = `54.99` currency = `USD` size = `S` ) ) )
                  ( name = `Shorts` categories = VALUE #(
                      ( name = `Jeans Short` amount = `32.99` currency = `USD` size = `M` )
                      ( name = `Sport Short` amount = `14.99` currency = `USD` size = `S` ) ) ) ) )
              ( name = `Accessories` categories = VALUE #(
                  ( name = `Necklace` amount = `26.99` currency = `USD` )
                  ( name = `Gloves` amount = `7.99` currency = `USD` )
                  ( name = `Beanie` amount = `12.99` currency = `USD` ) ) )
              ( name = `Shoes` categories = VALUE #(
                  ( name = `Sport Shoes` amount = `39.99` currency = `USD` )
                  ( name = `Boots` amount = `87.99` currency = `USD` )
                  ( name = `Sandals` amount = `63.99` currency = `USD` ) ) ) ) )
          ( name = `Boys` categories = VALUE #(
              ( name = `Clothing` categories = VALUE #(
                  ( name = `Shirts` categories = VALUE #(
                      ( name = `Black T-shirt with Print` amount = `16.99` currency = `USD` size = `S` )
                      ( name = `Blue Shirt` amount = `47.99` currency = `USD` size = `M` )
                      ( name = `Yellow Sweater` amount = `63.99` currency = `USD` size = `L` ) ) )
                  ( name = `Pants` categories = VALUE #(
                      ( name = `Blue Jeans` amount = `44.99` currency = `USD` size = `M` )
                      ( name = `Brown Pant` amount = `89.99` currency = `USD` size = `S` ) ) )
                  ( name = `Shorts` categories = VALUE #(
                      ( name = `Sport Short` amount = `32.99` currency = `USD` size = `M` )
                      ( name = `Jeans Short` amount = `99.99` currency = `USD` size = `XS` )
                      ( name = `Black Short` amount = `56.99` currency = `USD` size = `L` ) ) ) ) )
              ( name = `Accessories` categories = VALUE #(
                  ( name = `Sunglasses` amount = `36.99` currency = `USD` )
                  ( name = `Beanie` amount = `17.99` currency = `USD` )
                  ( name = `Scarf` amount = `15.99` currency = `USD` ) ) )
              ( name = `Shoes` categories = VALUE #(
                  ( name = `Sneaker` amount = `89.99` currency = `USD` )
                  ( name = `Sport Shoe` amount = `47.99` currency = `USD` )
                  ( name = `Boots` amount = `103.99` currency = `USD` ) ) ) ) ) ).

    " /sizes - the shared Select item list
    sizes = VALUE #(
      ( key = `XS` value = `Extra Small` )
      ( key = `S` value = `Small` )
      ( key = `M` value = `Medium` )
      ( key = `L` value = `Large` ) ).

  ENDMETHOD.

ENDCLASS.
