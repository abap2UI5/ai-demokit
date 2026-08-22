" @keywords tabcontainer tab container sap.m tabcontainermhc navcontainer overflowtoolbar toolbarspacer overflowtoolbarbutton column text columnlistitem
" @summary Allows detail view / edit in sap.m.TabContainer after selecting items from table.
CLASS z2ui5_cl_smpc_app_558 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        product_id   TYPE string,
        name         TYPE string,
        suppliername TYPE string,
        description  TYPE string,
        price        TYPE p LENGTH 14 DECIMALS 2,
        currencycode TYPE string,
        selected     TYPE abap_bool,
        " _oNewUnsavedItems: rows the add-new button created and nobody saved yet
        unsaved      TYPE abap_bool,
      END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    " one row per open tab - a COPY of the product, which is what makes Cancel a
    " pure discard (the original edits a deepExtend copy in its own JSONModel)
    TYPES:
      BEGIN OF ty_s_tab,
        product_id   TYPE string,
        name         TYPE string,
        suppliername TYPE string,
        description  TYPE string,
        price        TYPE p LENGTH 14 DECIMALS 2,
        currencycode TYPE string,
        modified     TYPE abap_bool,
      END OF ty_s_tab.
    TYPES ty_t_tab TYPE STANDARD TABLE OF ty_s_tab WITH EMPTY KEY.

    DATA t_products       TYPE ty_t_product.
    DATA t_tabs           TYPE ty_t_tab.
    DATA selected_tab     TYPE string.
    DATA pending_close    TYPE string.
    DATA open_visible     TYPE abap_bool.
    DATA edit_visible     TYPE abap_bool VALUE abap_true.
    DATA save_visible     TYPE abap_bool.
    DATA cancel_visible   TYPE abap_bool.
    " _bEditMode of the add-item page
    DATA add_mode         TYPE abap_bool.
    DATA add_product_id   TYPE string.
    DATA add_name         TYPE string.
    DATA add_supplier     TYPE string.
    DATA add_price        TYPE p LENGTH 14 DECIMALS 2.
    DATA add_description  TYPE string.
    DATA new_counter      TYPE i.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.
    METHODS tab_close IMPORTING product_id TYPE string.
    METHODS tab_save.
    METHODS nav_back.
    METHODS nav_to_table.
    METHODS unsaved_reset IMPORTING product_id TYPE string OPTIONAL.
    METHODS buttons_state
      IMPORTING edit   TYPE abap_bool DEFAULT abap_false
                save   TYPE abap_bool DEFAULT abap_false
                cancel TYPE abap_bool DEFAULT abap_false.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_558 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ELSEIF client->check_on_event( ).
      on_event( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    DATA(pages) = view->ele( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:f`    v = `sap.ui.layout.form`

        )->ele( `NavContainer`
            )->a( n = `id` v = `navCon` ).

    DATA(table_page) = pages->ele( `Page`
        )->a( n = `id`    v = `table`
        )->a( n = `title` v = `Product List` ).

    table_page->ele( `Table`
        )->a( n = `id`              v = `idProductsTable`
        )->a( n = `mode`            v = `MultiSelect`
        )->a( n = `items`           v = client->_bind( t_products )
        " onInit attaches selectionChange to keep the footer button in sync
        )->a( n = `selectionChange` v = client->_event( `SELECTION_CHANGE` )

        )->ele( `headerToolbar`
            )->ele( `OverflowToolbar`
                )->tag( `ToolbarSpacer`
                )->tag( `OverflowToolbarButton`
                    )->a( n = `type`    v = `Transparent`
                    )->a( n = `icon`    v = `sap-icon://add`
                    )->a( n = `tooltip` v = `Add`
                    )->a( n = `press`   v = client->_event( `NEW_ITEM_ADD` )

            )->end(
        )->end(
        )->ele( `columns`
            )->ele( `Column`
                )->a( n = `width` v = `12em`

                )->tag( `Text`
                    )->a( n = `text` v = `Product`

            )->end(
            )->ele( `Column`
                )->a( n = `width` v = `12em`

                )->tag( `Text`
                    )->a( n = `text` v = `Supplier`

            )->end(
        )->end(
        )->ele( `items`
            )->ele( `ColumnListItem`
                " the original reads the selection with getSelectedContexts; the flag
                " is bound two-way here so the backend has it on every round trip
                )->a( n = `selected` v = `{SELECTED}`

                )->ele( `cells`
                    )->tag( `Text`
                        )->a( n = `text` v = `{NAME}`
                    )->tag( `Text`
                        )->a( n = `text` v = `{SUPPLIERNAME}`

                )->end(
            )->end(
        )->end(
    )->end( ).

    table_page->ele( `footer`
        )->ele( `Toolbar`
            )->tag( `ToolbarSpacer`
            )->tag( `Button`
                )->a( n = `id`      v = `idOpenSelected`
                )->a( n = `text`    v = `Open selected item(s)`
                )->a( n = `type`    v = `Emphasized`
                )->a( n = `visible` v = client->_bind( open_visible )
                )->a( n = `press`   v = client->_event( `OPEN_SELECTED` ) ).

    DATA(tab_page) = pages->ele( `Page`
        )->a( n = `id`             v = `tabContainerPage`
        )->a( n = `title`          v = `Tab Container`
        )->a( n = `showNavButton`  v = `true`
        )->a( n = `navButtonPress` v = client->_event( `NAV_BACK` ) ).

    " openSelectedItems builds the TabContainer in the controller and inserts it
    " into the page; here it is declared and its items are bound to the open tabs
    " sap.m.TabContainer has no default aggregation, so the item template sits in
    " an explicit items element next to the items binding
    DATA(tab_item) = tab_page->ele( `TabContainer`
        )->a( n = `id`                v = `idTabContainer`
        )->a( n = `showAddNewButton`  v = `true`
        )->a( n = `addNewButtonPress` v = client->_event( `TAB_ADD_NEW` )
        )->a( n = `itemClose`         v = client->_event( val   = `TAB_CLOSE`
                                                          t_arg = VALUE #( ( `${$parameters>/item}.getKey()` ) ) )
        )->a( n = `itemSelect`        v = client->_event( val   = `TAB_SELECT`
                                                          t_arg = VALUE #( ( `${$parameters>/item}.getKey()` ) ) )
        )->a( n = `items`             v = client->_bind( t_tabs )

        )->ele( `items`
            )->ele( `TabContainerItem`
                )->a( n = `key`      v = `{PRODUCT_ID}`
                )->a( n = `name`     v = `{NAME}`
                )->a( n = `modified` v = `{MODIFIED}` ).

    DATA(tab_content) = tab_item->ele( `content` ).

    " the Display fragment - what a tab shows while it is not being edited
    tab_content->ele( `ObjectHeader`
        )->a( n = `visible`    v = |\{= !$\{MODIFIED\} \}|
        )->a( n = `title`      v = `{NAME}`
        )->a( n = `number`     v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCYCODE'\}], type:'sap.ui.model.type.Currency', formatOptions:\{showMeasure:false\} \}|
        )->a( n = `numberUnit` v = `{CURRENCYCODE}`

        )->ele( `attributes`
            )->tag( `ObjectAttribute`
                )->a( n = `text` v = `{SUPPLIERNAME}`
            )->tag( `ObjectAttribute`
                )->a( n = `text` v = `{DESCRIPTION}`

        )->end(
    )->end( ).

    " the Edit fragment - the tab edits its OWN copy of the row, which is what
    " makes Cancel a pure discard
    tab_content->ele( n = `SimpleForm` ns = `f`
        )->a( n = `visible`  v = |\{= $\{MODIFIED\} \}|
        )->a( n = `editable` v = `true`
        )->a( n = `layout`   v = `ResponsiveGridLayout`

        )->tag( `Label`
            )->a( n = `text` v = `Name`
        )->tag( `Input`
            )->a( n = `value` v = `{NAME}`
            )->a( n = `type`  v = `Text`
        )->tag( `Label`
            )->a( n = `text` v = `Supplier`
        )->tag( `Input`
            )->a( n = `value` v = `{SUPPLIERNAME}`
            )->a( n = `type`  v = `Text`
        )->tag( `Label`
            )->a( n = `text` v = `Price`
        )->tag( `Input`
            )->a( n = `value` v = `{PRICE}`
            )->a( n = `type`  v = `Number`
        )->tag( `Label`
            )->a( n = `text` v = `Description`
        )->tag( `TextArea`
            )->a( n = `value` v = `{DESCRIPTION}` ).

    DATA(add_page) = pages->ele( `Page`
        )->a( n = `id`             v = `addItemPage`
        )->a( n = `showNavButton`  v = `true`
        )->a( n = `navButtonPress` v = client->_event( `NAV_BACK` ) ).

    " handleNewItemAdd loads the same Edit fragment into the add page, over a fresh
    " JSONModel; here the add page's form binds the four add_* fields
    add_page->ele( n = `SimpleForm` ns = `f`
        )->a( n = `id`       v = `myForm`
        )->a( n = `editable` v = `true`
        )->a( n = `layout`   v = `ResponsiveGridLayout`

        )->tag( `Label`
            )->a( n = `text` v = `Name`
        )->tag( `Input`
            )->a( n = `value` v = client->_bind( add_name )
            )->a( n = `type`  v = `Text`
        )->tag( `Label`
            )->a( n = `text` v = `Supplier`
        )->tag( `Input`
            )->a( n = `value` v = client->_bind( add_supplier )
            )->a( n = `type`  v = `Text`
        )->tag( `Label`
            )->a( n = `text` v = `Price`
        )->tag( `Input`
            )->a( n = `value` v = client->_bind( add_price )
            )->a( n = `type`  v = `Number`
        )->tag( `Label`
            )->a( n = `text` v = `Description`
        )->tag( `TextArea`
            )->a( n = `value` v = client->_bind( add_description ) ).

    add_page->ele( `footer`
        )->ele( `Toolbar`
            )->tag( `ToolbarSpacer`
            )->tag( `Button`
                )->a( n = `text`  v = `Save`
                )->a( n = `type`  v = `Emphasized`
                )->a( n = `press` v = client->_event( `NEW_ITEM_SAVE` )
            )->tag( `Button`
                )->a( n = `text`  v = `Cancel`
                )->a( n = `type`  v = `Default`
                )->a( n = `press` v = client->_event( `NEW_ITEM_CANCEL` ) ).

    tab_page->ele( `footer`
        )->ele( `Toolbar`
            )->tag( `ToolbarSpacer`
            )->tag( `Button`
                )->a( n = `id`      v = `idEditItem`
                )->a( n = `text`    v = `Edit`
                )->a( n = `type`    v = `Default`
                )->a( n = `visible` v = client->_bind( edit_visible )
                )->a( n = `press`   v = client->_event( `TAB_EDIT` )
            )->tag( `Button`
                )->a( n = `id`      v = `idSaveItem`
                )->a( n = `text`    v = `Save`
                )->a( n = `type`    v = `Emphasized`
                )->a( n = `visible` v = client->_bind( save_visible )
                )->a( n = `press`   v = client->_event( `TAB_SAVE` )
            )->tag( `Button`
                )->a( n = `id`      v = `idCancel`
                )->a( n = `text`    v = `Cancel`
                )->a( n = `type`    v = `Default`
                )->a( n = `visible` v = client->_bind( cancel_visible )
                )->a( n = `press`   v = client->_event( `TAB_CANCEL` ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD buttons_state.

    edit_visible   = edit.
    save_visible   = save.
    cancel_visible = cancel.

  ENDMETHOD.


  METHOD nav_to_table.

    " fnGoBackToTablePage: back to the table page, and the footer button follows
    " the selection that is left
    client->follow_up_action( val   = client->cs_event-control_by_id
                              t_arg = VALUE #( ( `navCon` ) ( `back` ) ) ).
    open_visible = xsdbool( line_exists( t_products[ selected = abap_true ] ) ).

  ENDMETHOD.


  METHOD nav_back.

    " fnNavBackButton: leaving a page with unsaved edits asks first
    DATA(modified_names) = ``.
    LOOP AT t_tabs INTO DATA(tab) WHERE modified = abap_true.
      modified_names = modified_names && |\n| && tab-name.
    ENDLOOP.

    IF add_mode = abap_true OR modified_names IS NOT INITIAL.
      client->message_box_display(
          text         = |Your changes to the following tabs will be lost when you leave the page: \n{ modified_names }|
          type         = `warning`
          title        = `Warning`
          actions      = VALUE #( ( `Leave Page` ) ( `CANCEL` ) )
          initialfocus = `CANCEL`
          onclose      = `LEAVE_CLOSED` ).
      RETURN.
    ENDIF.

    nav_to_table( ).

  ENDMETHOD.


  METHOD unsaved_reset.

    " _resetUnsavedItems: drop the rows the add-new button created and nobody saved
    IF product_id IS INITIAL.
      DELETE t_products WHERE unsaved = abap_true.
      RETURN.
    ENDIF.
    DATA(del_id) = product_id.
    DELETE t_products WHERE unsaved = abap_true AND product_id = del_id.

  ENDMETHOD.


  METHOD tab_close.

    DATA(del_id) = product_id.
    DELETE t_tabs WHERE product_id = del_id.

    " un-check the row in the table, exactly as _closeItemInTabContainer does
    ASSIGN t_products[ product_id = del_id ] TO FIELD-SYMBOL(<product>).
    IF sy-subrc = 0.
      <product>-selected = abap_false.
    ENDIF.

    unsaved_reset( del_id ).

    " redirect to the table if no tab is left
    IF t_tabs IS INITIAL.
      nav_to_table( ).
    ENDIF.

  ENDMETHOD.


  METHOD tab_save.

    " handleTabContainerSaveItem: the tab's copy is written back to the product
    ASSIGN t_tabs[ product_id = selected_tab ] TO FIELD-SYMBOL(<saved_tab>).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    <saved_tab>-modified = abap_false.

    ASSIGN t_products[ product_id = selected_tab ] TO FIELD-SYMBOL(<target>).
    IF sy-subrc = 0.
      <target>-name         = <saved_tab>-name.
      <target>-suppliername = <saved_tab>-suppliername.
      <target>-description  = <saved_tab>-description.
      <target>-price        = <saved_tab>-price.
      <target>-currencycode = <saved_tab>-currencycode.
      " the row is a real product now, not an unsaved one
      <target>-unsaved      = abap_false.
    ENDIF.

    buttons_state( edit = abap_true ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get_event( ).

      WHEN `SELECTION_CHANGE`.
        open_visible = xsdbool( line_exists( t_products[ selected = abap_true ] ) ).

      WHEN `OPEN_SELECTED`.
        " openSelectedItems: one tab per selected row, filtered by ProductId
        CLEAR t_tabs.
        LOOP AT t_products INTO DATA(product) WHERE selected = abap_true.
          APPEND CORRESPONDING #( product ) TO t_tabs.
        ENDLOOP.
        selected_tab = VALUE #( t_tabs[ 1 ]-product_id OPTIONAL ).
        buttons_state( edit = abap_true ).
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `navCon` ) ( `to` ) ( `tabContainerPage` ) ) ).

      WHEN `TAB_SELECT`.
        selected_tab = client->get_event_arg( ).
        " _handleTabContainerItemSelect: the buttons follow the tab's modified flag
        DATA(is_modified) = xsdbool( line_exists( t_tabs[ product_id = selected_tab modified = abap_true ] ) ).
        buttons_state( edit   = xsdbool( is_modified = abap_false )
                       save   = is_modified
                       cancel = is_modified ).

      WHEN `TAB_EDIT`.
        " handleTabContainerEditItem: the tab goes into edit mode over its own copy
        ASSIGN t_tabs[ product_id = selected_tab ] TO FIELD-SYMBOL(<tab>).
        IF sy-subrc <> 0.
          RETURN.
        ENDIF.
        <tab>-modified = abap_true.
        buttons_state( save   = abap_true
                       cancel = abap_true ).

      WHEN `TAB_SAVE`.
        tab_save( ).

      WHEN `TAB_CANCEL`.
        " handleTabContainerCancelUpdate: a never-saved row disappears with its tab,
        " an existing one falls back to the stored product
        buttons_state( edit = abap_true ).
        IF line_exists( t_products[ product_id = selected_tab unsaved = abap_true ] ).
          tab_close( selected_tab ).
        ELSE.
          ASSIGN t_tabs[ product_id = selected_tab ] TO FIELD-SYMBOL(<reset_tab>).
          IF sy-subrc = 0.
            <reset_tab> = CORRESPONDING #( t_products[ product_id = selected_tab ] ).
          ENDIF.
        ENDIF.
        view_display( ).

      WHEN `TAB_CLOSE`.
        pending_close = client->get_event_arg( ).
        " _handleTabContainerItemClose: a modified tab asks before it goes
        IF line_exists( t_tabs[ product_id = pending_close modified = abap_true ] ).
          client->message_box_display( text         = `Your changes will be lost when you close this tab`
                                       type         = `warning`
                                       title        = `Warning`
                                       actions      = VALUE #( ( `Close Tab` ) ( `CANCEL` ) )
                                       initialfocus = `CANCEL`
                                       onclose      = `CLOSE_TAB_CLOSED` ).
        ELSE.
          tab_close( pending_close ).
        ENDIF.
        " the original cancels the close event and removes the item itself; a thin
        " frontend cannot, so the view is sent again and the tabs come back from
        " the model - the confirmed close then removes the row for good
        view_display( ).

      WHEN `CLOSE_TAB_CLOSED`.
        IF client->get_event_arg( ) <> `CANCEL`.
          tab_close( pending_close ).
        ENDIF.
        view_display( ).

      WHEN `TAB_ADD_NEW`.
        " _handleTabContainerAddNewButtonPress: a blank product joins the collection,
        " gets selected in the table, opens as a tab and starts in edit mode
        new_counter = new_counter + 1.
        DATA(new_id) = |ProductId-{ new_counter }|.
        APPEND VALUE #( product_id   = new_id
                        currencycode = `EUR`
                        selected     = abap_true
                        unsaved      = abap_true ) TO t_products.
        APPEND VALUE #( product_id   = new_id
                        currencycode = `EUR`
                        modified     = abap_true ) TO t_tabs.
        selected_tab = new_id.
        buttons_state( save   = abap_true
                       cancel = abap_true ).
        view_display( ).

      WHEN `NEW_ITEM_ADD`.
        " handleNewItemAdd: a fresh edit model on the add page
        new_counter = new_counter + 1.
        add_product_id = |ProductId-{ new_counter }|.
        CLEAR: add_name, add_supplier, add_description.
        add_price = 0.
        add_mode = abap_true.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = VALUE #( ( `navCon` ) ( `to` ) ( `addItemPage` ) ) ).

      WHEN `NEW_ITEM_SAVE`.
        " handleNewItemSave: the form's data joins the collection
        APPEND VALUE #( product_id   = add_product_id
                        name         = add_name
                        suppliername = add_supplier
                        description  = add_description
                        price        = add_price
                        currencycode = `EUR` ) TO t_products.
        add_mode = abap_false.
        nav_to_table( ).

      WHEN `NEW_ITEM_CANCEL`.
        add_mode = abap_false.
        nav_to_table( ).

      WHEN `NAV_BACK`.
        nav_back( ).

      WHEN `LEAVE_CLOSED`.
        " the confirmation's non-cancel action: leave the page and drop every row
        " the add-new button created and nobody saved
        IF client->get_event_arg( ) <> `CANCEL`.
          add_mode = abap_false.
          nav_to_table( ).
          unsaved_reset( ).
          " a tab whose product is gone goes with it
          LOOP AT t_tabs REFERENCE INTO DATA(lr_tab).
            IF NOT line_exists( t_products[ product_id = lr_tab->product_id ] ).
              DELETE t_tabs INDEX sy-tabix.
            ENDIF.
          ENDLOOP.
          view_display( ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " the full mock /ProductCollection (sap/ui/demo/mock/products.json), all 123
    " rows - onInit raises the model size limit to 200 so the table shows them all
    t_products = VALUE #(
      ( product_id = `HT-1000` name = `Notebook Basic 15`
        suppliername = `Very Best Screens` currencycode = `EUR` price = `956`
        description = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro` )
      ( product_id = `HT-1001` name = `Notebook Basic 17`
        suppliername = `Very Best Screens` currencycode = `EUR` price = `1249`
        description = `Notebook Basic 17 with 2,80 GHz quad core, 17" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro` )
      ( product_id = `HT-1002` name = `Notebook Basic 18`
        suppliername = `Very Best Screens` currencycode = `EUR` price = `1570`
        description = `Notebook Basic 18 with 2,80 GHz quad core, 18" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro` )
      ( product_id = `HT-1003` name = `Notebook Basic 19`
        suppliername = `Smartcards` currencycode = `EUR` price = `1650`
        description = `Notebook Basic 19 with 2,80 GHz quad core, 19" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro` )
      ( product_id = `HT-1007` name = `ITelO Vault`
        suppliername = `Technocom` currencycode = `EUR` price = `299`
        description = `Digital Organizer with State-of-the-Art Storage Encryption` )
      ( product_id = `HT-1010` name = `Notebook Professional 15`
        suppliername = `Very Best Screens` currencycode = `EUR` price = `1999`
        description = `Notebook Professional 15 with 2,80 GHz quad core, 15" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro` )
      ( product_id = `HT-1011` name = `Notebook Professional 17`
        suppliername = `Very Best Screens` currencycode = `EUR` price = `2299`
        description = `Notebook Professional 17 with 2,80 GHz quad core, 17" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro` )
      ( product_id = `HT-1020` name = `ITelO Vault Net`
        suppliername = `Technocom` currencycode = `EUR` price = `459`
        description = `Digital Organizer with State-of-the-Art Encryption for Storage and Network Communications` )
      ( product_id = `HT-1021` name = `ITelO Vault SAT`
        suppliername = `Technocom` currencycode = `EUR` price = `149`
        description = `Digital Organizer with State-of-the-Art Encryption for Storage and Secure Stellite Link` )
      ( product_id = `HT-1022` name = `Comfort Easy`
        suppliername = `Technocom` currencycode = `EUR` price = `1679`
        description = `32 GB Digital Assistant with high-resolution color screen` )
      ( product_id = `HT-1023` name = `Comfort Senior`
        suppliername = `Technocom` currencycode = `EUR` price = `512`
        description = `64 GB Digital Assistant with high-resolution color screen and synthesized voice output` )
      ( product_id = `HT-1030` name = `Ergo Screen E-I`
        suppliername = `Very Best Screens` currencycode = `EUR` price = `230`
        description = `Optimum Hi-Resolution max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm` )
      ( product_id = `HT-1031` name = `Ergo Screen E-II`
        suppliername = `Very Best Screens` currencycode = `EUR` price = `285`
        description = `Optimum Hi-Resolution max. 1920 x 1200 @ 85Hz, Dot Pitch: 0.26mm` )
      ( product_id = `HT-1032` name = `Ergo Screen E-III`
        suppliername = `Very Best Screens` currencycode = `EUR` price = `345`
        description = `Optimum Hi-Resolution max. 2560 x 1440 @ 85Hz, Dot Pitch: 0.25mm` )
      ( product_id = `HT-1035` name = `Flat Basic`
        suppliername = `Very Best Screens` currencycode = `EUR` price = `399`
        description = `Optimum Hi-Resolution max. 1600 x 1200 @ 85Hz, Dot Pitch: 0.24mm` )
      ( product_id = `HT-1036` name = `Flat Future`
        suppliername = `Very Best Screens` currencycode = `EUR` price = `430`
        description = `Optimum Hi-Resolution max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.26mm` )
      ( product_id = `HT-1037` name = `Flat XL`
        suppliername = `Very Best Screens` currencycode = `EUR` price = `1230`
        description = `Optimum Hi-Resolution max. 2016 x 1512 @ 85Hz, Dot Pitch: 0.24mm` )
      ( product_id = `HT-1040` name = `Laser Professional Eco`
        suppliername = `Alpha Printers` currencycode = `EUR` price = `830`
        description = `Print 2400 dpi image quality color documents at speeds of up to 32 ppm (color) or 36 ppm (monochrome), letter/A4. Powerful 500 MHz processor, 512MB of memory` )
      ( product_id = `HT-1041` name = `Laser Basic`
        suppliername = `Alpha Printers` currencycode = `EUR` price = `490`
        description = `Up to 22 ppm color or 24 ppm monochrome A4/letter, powerful 500 MHz processor and 128MB of memory` )
      ( product_id = `HT-1042` name = `Laser Allround`
        suppliername = `Alpha Printers` currencycode = `EUR` price = `349`
        description = `Print up to 25 ppm letter and 24 ppm A4 color or monochrome, with Available first-page-out-time of less than 13 seconds for monochrome and less than 15 seconds for color` )
      ( product_id = `HT-1050` name = `Ultra Jet Super Color`
        suppliername = `Alpha Printers` currencycode = `EUR` price = `139`
        description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB, Ethernet` )
      ( product_id = `HT-1051` name = `Ultra Jet Mobile`
        suppliername = `Printer for All` currencycode = `EUR` price = `99`
        description = `1000 dpi x 1000 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB - excellent dimensions for the small office` )
      ( product_id = `HT-1052` name = `Ultra Jet Super Highspeed`
        suppliername = `Printer for All` currencycode = `EUR` price = `170`
        description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB2.0, Ethernet` )
      ( product_id = `HT-1055` name = `Multi Print`
        suppliername = `Printer for All` currencycode = `EUR` price = `99`
        description = `1000 dpi x 1000 dpi - up to 16 ppm (mono) / up to 15 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 1200dpi x 2400dpi)` )
      ( product_id = `HT-1056` name = `Multi Color`
        suppliername = `Printer for All` currencycode = `EUR` price = `119`
        description = `1200 dpi x 1200 dpi - up to 25 ppm (mono) / up to 24 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 2400dpi x 4800dpi, high resolution)` )
      ( product_id = `HT-1060` name = `Cordless Mouse`
        suppliername = `Oxynum` currencycode = `EUR` price = `9`
        description = `Cordless Optical USB Mice, Laptop, Color: Black, Plug&Play` )
      ( product_id = `HT-1061` name = `Speed Mouse`
        suppliername = `Oxynum` currencycode = `EUR` price = `7`
        description = `Optical USB, PS/2 Mouse, Color: Blue, 3-button-functionality (incl. Scroll wheel)` )
      ( product_id = `HT-1062` name = `Track Mouse`
        suppliername = `Oxynum` currencycode = `EUR` price = `11`
        description = `Optical USB Mouse, Color: Red, 5-button-functionality(incl. Scroll wheel), Plug&Play` )
      ( product_id = `HT-1063` name = `Ergonomic Keyboard`
        suppliername = `Oxynum` currencycode = `EUR` price = `14`
        description = `Ergonomic USB Keyboard for Desktop, Plug&Play` )
      ( product_id = `HT-1064` name = `Internet Keyboard`
        suppliername = `Oxynum` currencycode = `EUR` price = `16`
        description = `Corded Keyboard with special keys for Internet Usability, USB` )
      ( product_id = `HT-1065` name = `Media Keyboard`
        suppliername = `Oxynum` currencycode = `EUR` price = `26`
        description = `Corded Ergonomic Keyboard with special keys for Media Usability, USB` )
      ( product_id = `HT-1066` name = `Mousepad`
        suppliername = `Oxynum` currencycode = `EUR` price = `6.99`
        description = `Nice mouse pad with ITelO Logo` )
      ( product_id = `HT-1067` name = `Ergo Mousepad`
        suppliername = `Oxynum` currencycode = `EUR` price = `8.99`
        description = `Ergonomic mouse pad with ITelO Logo` )
      ( product_id = `HT-1068` name = `Designer Mousepad`
        suppliername = `Fasttech` currencycode = `EUR` price = `12.99`
        description = `ITelO Mousepad Special Edition` )
      ( product_id = `HT-1069` name = `Universal card reader`
        suppliername = `Fasttech` currencycode = `EUR` price = `14`
        description = `Universal card reader` )
      ( product_id = `HT-1070` name = `Proctra X`
        suppliername = `Ultrasonic United` currencycode = `EUR` price = `70.9`
        description = `Proctra X: PCI-E GDDR5 3072MB` )
      ( product_id = `HT-1071` name = `Gladiator MX`
        suppliername = `Ultrasonic United` currencycode = `EUR` price = `81.7`
        description = `Gladiator XLN: PCI-E GDDR5 3072MB DVI Out, TV Out low-noise` )
      ( product_id = `HT-1072` name = `Hurricane GX`
        suppliername = `Ultrasonic United` currencycode = `EUR` price = `101.2`
        description = `Hurricane GX: PCI-E 691 GFLOPS game-optimized` )
      ( product_id = `HT-1073` name = `Hurricane GX/LN`
        suppliername = `Smartcards` currencycode = `EUR` price = `139.99`
        description = `Hurricane GX/LN: PCI-E 691 GFLOPS game-optimized, low-noise.` )
      ( product_id = `HT-1080` name = `Photo Scan`
        suppliername = `Printer for All` currencycode = `EUR` price = `129`
        description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - Hi-Speed USB - Bluetooth` )
      ( product_id = `HT-1081` name = `Power Scan`
        suppliername = `Printer for All` currencycode = `EUR` price = `89`
        description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - SCSI for backward compatibility` )
      ( product_id = `HT-1082` name = `Jet Scan Professional`
        suppliername = `Printer for All` currencycode = `EUR` price = `169`
        description = `Flatbed scanner - Letter - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module` )
      ( product_id = `HT-1083` name = `Jet Scan Professional`
        suppliername = `Printer for All` currencycode = `EUR` price = `189`
        description = `Flatbed scanner - A4 - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module` )
      ( product_id = `HT-1085` name = `Copymaster`
        suppliername = `Alpha Printers` currencycode = `EUR` price = `1499`
        description = `Copymaster` )
      ( product_id = `HT-1090` name = `Surround Sound`
        suppliername = `Speaker Experts` currencycode = `EUR` price = `39`
        description = `PC multimedia speakers - 5 Watt (Total)` )
      ( product_id = `HT-1091` name = `Blaster Extreme`
        suppliername = `Speaker Experts` currencycode = `EUR` price = `26`
        description = `PC multimedia speakers - 10 Watt (Total) - 2-way` )
      ( product_id = `HT-1092` name = `Sound Booster`
        suppliername = `Speaker Experts` currencycode = `EUR` price = `45`
        description = `PC multimedia speakers - optimized for Blutooth/A2DP` )
      ( product_id = `HT-1095` name = `Lovely Sound 5.1 Wireless`
        suppliername = `Fasttech` currencycode = `EUR` price = `49`
        description = `5.1 Headset, 40 Hz-20 kHz, Wireless` )
      ( product_id = `HT-1096` name = `Lovely Sound 5.1`
        suppliername = `Fasttech` currencycode = `EUR` price = `39`
        description = `5.1 Headset, 40 Hz-20 kHz, 3m cable` )
      ( product_id = `HT-1097` name = `Lovely Sound Stereo`
        suppliername = `Fasttech` currencycode = `EUR` price = `29`
        description = `5.1 Headset, 40 Hz-20 kHz, 1m cable` )
      ( product_id = `HT-1100` name = `Smart Office`
        suppliername = `Technocom` currencycode = `EUR` price = `89.9`
        description = `Complete package, 1 User, Office Applications (word processing, spreadsheet, presentations)` )
      ( product_id = `HT-1101` name = `Smart Design`
        suppliername = `Technocom` currencycode = `EUR` price = `79.9`
        description = `Complete package, 1 User, Image editing, processing` )
      ( product_id = `HT-1102` name = `Smart Network`
        suppliername = `Technocom` currencycode = `EUR` price = `69`
        description = `Complete package, 1 User, Network Software Utilities, Useful Applications and Documentation` )
      ( product_id = `HT-1103` name = `Smart Multimedia`
        suppliername = `Technocom` currencycode = `EUR` price = `77`
        description = `Complete package, 1 User, different Multimedia applications, playing music, watching DVDs, only with this Smart package` )
      ( product_id = `HT-1104` name = `Smart Games`
        suppliername = `Technocom` currencycode = `EUR` price = `55`
        description = `Complete package, 1 User, various games for amusement, logic, action, jump&run` )
      ( product_id = `HT-1105` name = `Smart Internet Antivirus`
        suppliername = `Brainsoft` currencycode = `EUR` price = `29`
        description = `Complete package, 1 User, highly recommended for internet users as anti-virus protection` )
      ( product_id = `HT-1106` name = `Smart Firewall`
        suppliername = `Brainsoft` currencycode = `EUR` price = `34`
        description = `Complete package, 1 User, recommended for internet users, protect your PC against cyber-crime` )
      ( product_id = `HT-1107` name = `Smart Money`
        suppliername = `Brainsoft` currencycode = `EUR` price = `29.9`
        description = `Complete package, 1 User, bring your money in your mind, see what you have and what you want` )
      ( product_id = `HT-1110` name = `PC Lock`
        suppliername = `Red Point Stores` currencycode = `EUR` price = `8.9`
        description = `Robust 3m anti-burglary protection for your laptop computer` )
      ( product_id = `HT-1111` name = `Notebook Lock`
        suppliername = `Red Point Stores` currencycode = `EUR` price = `6.9`
        description = `Robust 1m anti-burglary protection for your desktop computer` )
      ( product_id = `HT-1112` name = `Web cam reality`
        suppliername = `Red Point Stores` currencycode = `EUR` price = `39`
        description = `Color webcam, color, High-Speed USB` )
      ( product_id = `HT-1113` name = `Screen clean`
        suppliername = `Red Point Stores` currencycode = `EUR` price = `2.3`
        description = `10 separately packed screen wipes` )
      ( product_id = `HT-1114` name = `Fabric bag professional`
        suppliername = `Red Point Stores` currencycode = `EUR` price = `31`
        description = `Notebook bag, plenty of room for stationery and writing materials` )
      ( product_id = `HT-1115` name = `Wireless DSL Router`
        suppliername = `Red Point Stores` currencycode = `EUR` price = `49`
        description = `Wireless DSL Router (available in blue, black and silver)` )
      ( product_id = `HT-1116` name = `Wireless DSL Router / Repeater`
        suppliername = `Red Point Stores` currencycode = `EUR` price = `59`
        description = `Wireless DSL Router / Repeater (available in blue, black and silver)` )
      ( product_id = `HT-1117` name = `Wireless DSL Router / Repeater and Print Server`
        suppliername = `Technocom` currencycode = `EUR` price = `69`
        description = `Wireless DSL Router / Repeater and Print Server (available in blue, black and silver)` )
      ( product_id = `HT-1118` name = `USB Stick`
        suppliername = `Technocom` currencycode = `EUR` price = `35`
        description = `USB 2.0 High-Speed 64 GB` )
      ( product_id = `HT-1119` name = `Travel Adapter`
        suppliername = `Titanium` currencycode = `EUR` price = `79`
        description = `Universal Travel Adapter` )
      ( product_id = `HT-1120` name = `Cordless Bluetooth Keyboard, english international`
        suppliername = `Technocom` currencycode = `EUR` price = `29`
        description = `Cordless Bluetooth Keyboard with English keys` )
      ( product_id = `HT-1137` name = `Flat XXL`
        suppliername = `Technocom` currencycode = `EUR` price = `1430`
        description = `Optimum Hi-Resolution max. 2048 × 1536 @ 85Hz, Dot Pitch: 0.24mm` )
      ( product_id = `HT-1138` name = `Pocket Mouse`
        suppliername = `Technocom` currencycode = `EUR` price = `23`
        description = `Portable pocket Mouse with retracting cord` )
      ( product_id = `HT-1210` name = `PC Power Station`
        suppliername = `Technocom` currencycode = `EUR` price = `2399`
        description = `PC Power Station with 3,4 Ghz quad-core, 32 GB DDR3 SDRAM, feels like Available PC, Windows 8 Pro` )
      ( product_id = `HT-1251` name = `Astro Laptop 1516`
        suppliername = `Ultrasonic United` currencycode = `EUR` price = `989`
        description = `Flexible Laptop with 2,5 GHz Quad Core, 15" HD TN, 16 GB DDR SDRAM, 256 GB SSD, Windows 10 Pro` )
      ( product_id = `HT-1252` name = `Astro Phone 6`
        suppliername = `Ultrasonic United` currencycode = `EUR` price = `649`
        description = `6 inch 1280x800 HD display (216 ppi), Quad-core processor, 8 GB internal storage (actual formatted capacity will be less), 3050 mAh battery (Up to 8 hours of active use), grey or black` )
      ( product_id = `HT-1253` name = `Benda Laptop 1408`
        suppliername = `Ultrasonic United` currencycode = `EUR` price = `976`
        description = `Flexible Laptop with 2,5 GHz Dual Core, 14" HD+ TN, 8 GB DDR SDRAM, 324 GB SSD, Windows 10 Pro` )
      ( product_id = `HT-1254` name = `Bending Screen 21HD`
        suppliername = `Ultrasonic United` currencycode = `EUR` price = `250`
        description = `Optimum Hi-Resolution Widescreen max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub` )
      ( product_id = `HT-1255` name = `Broad Screen 22HD`
        suppliername = `Ultrasonic United` currencycode = `EUR` price = `270`
        description = `Optimum Hi-Resolution Widescreen max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub` )
      ( product_id = `HT-1256` name = `Cerdik Phone 7`
        suppliername = `Ultrasonic United` currencycode = `EUR` price = `549`
        description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black` )
      ( product_id = `HT-1257` name = `Cepat Tablet 10.5`
        suppliername = `Ultrasonic United` currencycode = `EUR` price = `549`
        description = `10.5-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor` )
      ( product_id = `HT-1258` name = `Cepat Tablet 8`
        suppliername = `Ultrasonic United` currencycode = `EUR` price = `529`
        description = `8-inch Multitouch HD Screen (2000 x 1500) 32GB Internal Memory, Wireless N Wi-Fi, Bluetooth, GPS Enabled, 1.5 GHz Quad-Core Processor` )
      ( product_id = `HT-1500` name = `Server Basic`
        suppliername = `Technocom` currencycode = `EUR` price = `5000`
        description = `Dual socket, quad-core processing server with 1333 MHz Front Side Bus with 10Gb connectivity` )
      ( product_id = `HT-1501` name = `Server Professional`
        suppliername = `Technocom` currencycode = `EUR` price = `15000`
        description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 10Gb connectivity` )
      ( product_id = `HT-1502` name = `Server Power Pro`
        suppliername = `Technocom` currencycode = `EUR` price = `25000`
        description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 100Gb connectivity` )
      ( product_id = `HT-1600` name = `Family PC Basic`
        suppliername = `Titanium` currencycode = `EUR` price = `600`
        description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Graphic Card: Proctra X, Windows 8` )
      ( product_id = `HT-1601` name = `Family PC Pro`
        suppliername = `Titanium` currencycode = `EUR` price = `900`
        description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8` )
      ( product_id = `HT-1602` name = `Gaming Monster`
        suppliername = `Titanium` currencycode = `EUR` price = `1200`
        description = `3,4 Ghz quad core, 8 GB DDR3 SDRAM, 2000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8` )
      ( product_id = `HT-1603` name = `Gaming Monster Pro`
        suppliername = `Titanium` currencycode = `EUR` price = `1700`
        description = `3,4 Ghz quad core, 16 GB DDR3 SDRAM, 4000 GB Hard Disc, Graphic Card: Hurricane GX, Windows 8` )
      ( product_id = `HT-2000` name = `7" Widescreen Portable DVD Player w MP3`
        suppliername = `Titanium` currencycode = `EUR` price = `249.99`
        description = `7" LCD Screen, storage battery holds up to 6 hours!` )
      ( product_id = `HT-2001` name = `10" Portable DVD player`
        suppliername = `Titanium` currencycode = `EUR` price = `449.99`
        description = `10" LCD Screen, storage battery holds up to 8 hours` )
      ( product_id = `HT-2002` name = `Portable DVD Player with 9" LCD Monitor`
        suppliername = `Technocom` currencycode = `EUR` price = `853.99`
        description = `9" LCD Screen, storage holds up to 8 hours, 2 speakers included` )
      ( product_id = `HT-2025` name = `CD/DVD case: 264 sleeves`
        suppliername = `Titanium` currencycode = `EUR` price = `44.99`
        description = `Organizer and protective case for 264 CDs and DVDs` )
      ( product_id = `HT-2026` name = `Audio/Video Cable Kit - 4m`
        suppliername = `Titanium` currencycode = `EUR` price = `29.99`
        description = `Quality cables for notebooks and projectors` )
      ( product_id = `HT-2027` name = `Removable CD/DVD Laser Labels`
        suppliername = `Titanium` currencycode = `EUR` price = `8.99`
        description = `Removable jewel case labels, zero residues (100)` )
      ( product_id = `HT-6100` name = `Beam Breaker B-1`
        suppliername = `Titanium` currencycode = `EUR` price = `469`
        description = `720p, DLP Projector max. 8,45 Meter, 2D` )
      ( product_id = `HT-6101` name = `Beam Breaker B-2`
        suppliername = `Technocom` currencycode = `EUR` price = `679`
        description = `1080p, DLP max.9,34 Meter, 2D-ready` )
      ( product_id = `HT-6102` name = `Beam Breaker B-3`
        suppliername = `Technocom` currencycode = `EUR` price = `889`
        description = `1080p, DLP max. 12,3 Meter, 3D-ready` )
      ( product_id = `HT-6110` name = `Play Movie`
        suppliername = `Fasttech` currencycode = `EUR` price = `130`
        description = `CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid` )
      ( product_id = `HT-6111` name = `Record Movie`
        suppliername = `Fasttech` currencycode = `EUR` price = `288`
        description = `160 GB HDD, CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid` )
      ( product_id = `HT-6120` name = `ITelo MusicStick`
        suppliername = `Fasttech` currencycode = `EUR` price = `45`
        description = `64 GB USB Music-on-Available-Stick` )
      ( product_id = `HT-6121` name = `ITelo Jog-Mate`
        suppliername = `Fasttech` currencycode = `EUR` price = `63`
        description = `ITelo Jog-Mate 64 GB HDD and Color Display, can play movies` )
      ( product_id = `HT-6122` name = `Power Pro Player 40`
        suppliername = `Fasttech` currencycode = `EUR` price = `167`
        description = `MP3-Player with 40 GB HDD and Color Display, can play movies` )
      ( product_id = `HT-6123` name = `Power Pro Player 80`
        suppliername = `Fasttech` currencycode = `EUR` price = `299`
        description = `MP3-Player with 80 GB SSD and Color Display, can play movies` )
      ( product_id = `HT-6130` name = `Flat Watch HD32`
        suppliername = `Very Best Screens` currencycode = `EUR` price = `1459`
        description = `32-inch, 1366x768 Pixel, 16:9, HDTV ready` )
      ( product_id = `HT-6131` name = `Flat Watch HD37`
        suppliername = `Very Best Screens` currencycode = `EUR` price = `1199`
        description = `37-inch, 1366x768 Pixel, 16:9, HDTV ready` )
      ( product_id = `HT-6132` name = `Flat Watch HD41`
        suppliername = `Very Best Screens` currencycode = `EUR` price = `899`
        description = `41-inch, 1366x768 Pixel, 16:9, HDTV ready` )
      ( product_id = `HT-7000` name = `Copperberry`
        suppliername = `Fasttech` currencycode = `EUR` price = `549`
        description = `Our new multifunctional Handheld with phone function in copper` )
      ( product_id = `HT-7010` name = `Silverberry`
        suppliername = `Fasttech` currencycode = `EUR` price = `549`
        description = `Our new multifunctional Handheld with phone function in silver` )
      ( product_id = `HT-7020` name = `Goldberry`
        suppliername = `Fasttech` currencycode = `EUR` price = `549`
        description = `Our new multifunctional Handheld with phone function in gold` )
      ( product_id = `HT-7030` name = `Platinberry`
        suppliername = `Fasttech` currencycode = `EUR` price = `549`
        description = `Our new multifunctional Handheld with phone function in platinum` )
      ( product_id = `HT-8000` name = `ITelO FlexTop I4000`
        suppliername = `Titanium` currencycode = `EUR` price = `799`
        description = `Notebook with 2,80 GHz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8` )
      ( product_id = `HT-8001` name = `ITelO FlexTop I6300c`
        suppliername = `Titanium` currencycode = `EUR` price = `799`
        description = `Notebook with 2,80 GHz dual core, 8 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8` )
      ( product_id = `HT-8002` name = `ITelO FlexTop I9100`
        suppliername = `Titanium` currencycode = `EUR` price = `1199`
        description = `Notebook with 2,80 GHz quad core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8` )
      ( product_id = `HT-8003` name = `ITelO FlexTop I9800`
        suppliername = `Titanium` currencycode = `EUR` price = `1388`
        description = `Notebook with 2,80 GHz quad core, 8 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8` )
      ( product_id = `HT-9991` name = `Smartphone Leather Case`
        suppliername = `Ultrasonic United` currencycode = `EUR` price = `25`
        description = `Button Clasp, Quality Material, 100% Leather, compatible with many smartphone models` )
      ( product_id = `HT-9992` name = `Smartphone Alpha`
        suppliername = `Ultrasonic United` currencycode = `EUR` price = `599`
        description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black` )
      ( product_id = `HT-9993` name = `Mini Tablet`
        suppliername = `Ultrasonic United` currencycode = `EUR` price = `833`
        description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage, 4325 mAh battery (Up to 8 hours of active use)` )
      ( product_id = `HT-9994` name = `Camcorder View`
        suppliername = `Ultrasonic United` currencycode = `EUR` price = `1388`
        description = `1920x1080 Full HD, image stabilization reduces blur, 27x Optical / 32x Extended Zoom, wide angle Lens, 2.7" wide LCD display` )
      ( product_id = `HT-9995` name = `Tablet Pouch`
        suppliername = `Titanium` currencycode = `EUR` price = `20`
        description = `Stylish tablet pouch, protects from scratches, color: black` )
      ( product_id = `HT-9996` name = `Tablet Pouch`
        suppliername = `Titanium` currencycode = `EUR` price = `20`
        description = `Stylish tablet pouch, protects from scratches, color: black` )
      ( product_id = `HT-9997` name = `e-Book Reader ReadMe`
        suppliername = `Titanium` currencycode = `EUR` price = `33`
        description = `6-Inch E Ink Screen, Access To e-book Store, Adjustable Font Styles and Sizes, Stores Up To 1,000 Books` )
      ( product_id = `HT-9998` name = `Smartphone Beta`
        suppliername = `Titanium` currencycode = `EUR` price = `30`
        description = `5 Megapixel Camera, Wi-Fi 802.11 b/g/n, Bluetooth, GPS Available-GPS support` )
      ( product_id = `HT-9999` name = `Maxi Tablet`
        suppliername = `Titanium` currencycode = `EUR` price = `749`
        description = `10.1-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor` )
      ( product_id = `PF-1000` name = `Flyer`
        suppliername = `Titanium` currencycode = `EUR` price = `0`
        description = `Flyer for our product palette` ) ).

  ENDMETHOD.

ENDCLASS.
