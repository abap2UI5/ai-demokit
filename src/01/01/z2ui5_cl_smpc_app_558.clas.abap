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
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

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
    TYPES ty_t_tab TYPE STANDARD TABLE OF ty_s_tab WITH DEFAULT KEY.

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

    " The page the LIVE navCon was last sent to, so a rebuilt view can be sent
    " there again (see view_display). Empty until something navigated, which is
    " the guard. PROTECTED, not PUBLIC: it is bookkeeping and not model data,
    " and only PUBLIC attributes are serialized into the view model - and not
    " PRIVATE, because the draft serialization walks the attributes with a
    " dynamic ASSIGN obj->(name) that cannot reach a PRIVATE one
    DATA nav_page TYPE string.

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
    DATA pages TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA table_page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA tab_page TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA temp1 TYPE z2ui5_if_client=>ty_s_event_control.
    DATA tab_item TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA tab_content TYPE REF TO z2ui5_cl_ui5_view_builder.
    DATA add_page TYPE REF TO z2ui5_cl_ui5_view_builder.
      DATA temp2 TYPE string_table.
    DATA temp4 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    pages = view->ele( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:f`    v = `sap.ui.layout.form`

        )->ele( `NavContainer`
            )->a( n = `id` v = `navCon` ).

    
    table_page = pages->ele( `Page`
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

    
    tab_page = pages->ele( `Page`
        )->a( n = `id`             v = `tabContainerPage`
        )->a( n = `title`          v = `Tab Container`
        )->a( n = `showNavButton`  v = `true`
        )->a( n = `navButtonPress` v = client->_event( `NAV_BACK` ) ).

    " openSelectedItems builds the TabContainer in the controller and inserts it
    " into the page; here it is declared and its items are bound to the open tabs
    " sap.m.TabContainer has no default aggregation, so the item template sits in
    " an explicit items element next to the items binding
    
    CLEAR temp1.
    temp1-check_prevent_default = abap_true.
    
    tab_item = tab_page->ele( `TabContainer`
        )->a( n = `id`                v = `idTabContainer`
        )->a( n = `showAddNewButton`  v = `true`
        )->a( n = `addNewButtonPress` v = client->_event( `TAB_ADD_NEW` )
        " _handleTabContainerItemClose opens with oEvent.preventDefault( ) and
        " closes the tab itself once the user has confirmed. check_prevent_default
        " IS that call: the control does not close the tab, the event still
        " reaches the backend, and tab_close( ) decides
        )->a( n = `itemClose`         v = client->_event( val    = `TAB_CLOSE`
                                                          arg    = `${$parameters>/item}.getKey()`
                                                          s_ctrl = temp1 )
        )->a( n = `itemSelect`        v = client->_event( val = `TAB_SELECT` arg = `${$parameters>/item}.getKey()` )
        )->a( n = `items`             v = client->_bind( t_tabs )

        )->ele( `items`
            )->ele( `TabContainerItem`
                )->a( n = `key`      v = `{PRODUCT_ID}`
                )->a( n = `name`     v = `{NAME}`
                )->a( n = `modified` v = `{MODIFIED}` ).

    
    tab_content = tab_item->ele( `content` ).

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

    
    add_page = pages->ele( `Page`
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

    " The NavContainer's position is live control state: view_display( )
    " destroys the MAIN slot and XMLView.create builds a fresh tree, so navCon
    " comes back on its FIRST page - the table, this NavContainer declaring no
    " initialPage - while selected_tab, save_visible and cancel_visible survive
    " as class state. Four of the five branches that call view_display( ) are
    " reachable only FROM tabContainerPage (TAB_CANCEL, TAB_CLOSE,
    " CLOSE_TAB_CLOSED, TAB_ADD_NEW), so pressing + on the tab bar created the
    " tab and dropped the user on the product list while the buttons claimed an
    " open tab in edit mode. Re-issued from the LAST-issued target rather than
    " re-derived, so the branches that DO want the table (nav_to_table, the
    " tab_close redirect when the last tab goes) park `table` and are skipped
    " here by the same guard. The app-000 idiom
    IF nav_page IS NOT INITIAL AND nav_page <> `table`.
      
      CLEAR temp2.
      INSERT `navCon` INTO TABLE temp2.
      INSERT `to` INTO TABLE temp2.
      INSERT nav_page INTO TABLE temp2.
      client->follow_up_action( val   = client->cs_event-control_by_id
                                t_arg = temp2 ).
    ENDIF.

    " onInit: oModel.setSizeLimit(200) - the collection is 123 rows and the
    " JSONModel caps a bound aggregation at 100, so without this the table
    " stops 23 rows short (the app-252 / app-444 idiom)
    
    CLEAR temp4.
    INSERT `200` INTO TABLE temp4.
    INSERT client->cs_view-main INTO TABLE temp4.
    client->follow_up_action( val   = client->cs_event-set_size_limit
                              t_arg = temp4 ).

  ENDMETHOD.


  METHOD buttons_state.

    edit_visible   = edit.
    save_visible   = save.
    cancel_visible = cancel.

  ENDMETHOD.


  METHOD nav_to_table.

    " fnGoBackToTablePage: back to the table page, and the footer button follows
    " the selection that is left
    DATA temp6 TYPE string_table.
    DATA temp8 LIKE sy-subrc.
    DATA temp1 TYPE xsdboolean.
    CLEAR temp6.
    INSERT `navCon` INTO TABLE temp6.
    INSERT `back` INTO TABLE temp6.
    client->follow_up_action( val   = client->cs_event-control_by_id
                              t_arg = temp6 ).
    nav_page = `table`.
    
    READ TABLE t_products WITH KEY selected = abap_true TRANSPORTING NO FIELDS.
    temp8 = sy-subrc.
    
    temp1 = boolc( temp8 = 0 ).
    open_visible = temp1.

  ENDMETHOD.


  METHOD nav_back.

    " fnNavBackButton: leaving a page with unsaved edits asks first
    DATA modified_names TYPE string.
    DATA tab LIKE LINE OF t_tabs.
      DATA temp9 TYPE string_table.
    modified_names = ``.
    
    LOOP AT t_tabs INTO tab WHERE modified = abap_true.
      modified_names = modified_names && |\n| && tab-name.
    ENDLOOP.

    IF add_mode = abap_true OR modified_names IS NOT INITIAL.
      
      CLEAR temp9.
      INSERT `Leave Page` INTO TABLE temp9.
      INSERT `CANCEL` INTO TABLE temp9.
      client->message_box_display(
          text         = |Your changes to the following tabs will be lost when you leave the page: \n{ modified_names }|
          type         = `warning`
          title        = `Warning`
          actions      = temp9
          initialfocus = `CANCEL`
          onclose      = `LEAVE_CLOSED` ).
      RETURN.
    ENDIF.

    nav_to_table( ).

  ENDMETHOD.


  METHOD unsaved_reset.
    DATA del_id LIKE product_id.

    " _resetUnsavedItems: drop the rows the add-new button created and nobody saved
    IF product_id IS INITIAL.
      DELETE t_products WHERE unsaved = abap_true.
      RETURN.
    ENDIF.
    
    del_id = product_id.
    DELETE t_products WHERE unsaved = abap_true AND product_id = del_id.

  ENDMETHOD.


  METHOD tab_close.

    DATA del_id LIKE product_id.
    FIELD-SYMBOLS <product> TYPE z2ui5_cl_smpc_app_558=>ty_s_product.
    del_id = product_id.
    DELETE t_tabs WHERE product_id = del_id.

    " un-check the row in the table, exactly as _closeItemInTabContainer does
    
    READ TABLE t_products WITH KEY product_id = del_id ASSIGNING <product>.
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
    FIELD-SYMBOLS <saved_tab> TYPE z2ui5_cl_smpc_app_558=>ty_s_tab.
    FIELD-SYMBOLS <target> TYPE z2ui5_cl_smpc_app_558=>ty_s_product.
    READ TABLE t_tabs WITH KEY product_id = selected_tab ASSIGNING <saved_tab>.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    <saved_tab>-modified = abap_false.

    
    READ TABLE t_products WITH KEY product_id = selected_tab ASSIGNING <target>.
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
        DATA temp11 LIKE sy-subrc.
        DATA temp4 TYPE xsdboolean.
        DATA product LIKE LINE OF t_products.
          DATA temp12 TYPE z2ui5_cl_smpc_app_558=>ty_s_tab.
        DATA temp13 TYPE string.
        DATA temp14 TYPE z2ui5_cl_smpc_app_558=>ty_s_tab.
        DATA temp15 TYPE string_table.
        DATA is_modified TYPE abap_bool.
        DATA temp1 LIKE sy-subrc.
        DATA temp5 TYPE xsdboolean.
        DATA temp6 TYPE xsdboolean.
        FIELD-SYMBOLS <tab> TYPE z2ui5_cl_smpc_app_558=>ty_s_tab.
        DATA temp17 LIKE sy-subrc.
          FIELD-SYMBOLS <reset_tab> TYPE z2ui5_cl_smpc_app_558=>ty_s_tab.
            DATA temp2 LIKE LINE OF t_products.
            DATA temp3 LIKE sy-tabix.
        DATA temp18 LIKE sy-subrc.
          DATA temp19 TYPE string_table.
        DATA new_id TYPE string.
        DATA temp21 TYPE z2ui5_cl_smpc_app_558=>ty_s_product.
        DATA temp22 TYPE z2ui5_cl_smpc_app_558=>ty_s_tab.
        DATA temp23 TYPE string_table.
        DATA temp25 TYPE z2ui5_cl_smpc_app_558=>ty_s_product.
          DATA temp26 LIKE LINE OF t_tabs.
          DATA lr_tab LIKE REF TO temp26.
            DATA temp27 LIKE sy-subrc.

    CASE client->get_event( ).

      WHEN `SELECTION_CHANGE`.
        
        READ TABLE t_products WITH KEY selected = abap_true TRANSPORTING NO FIELDS.
        temp11 = sy-subrc.
        
        temp4 = boolc( temp11 = 0 ).
        open_visible = temp4.

      WHEN `OPEN_SELECTED`.
        " openSelectedItems: one tab per selected row, filtered by ProductId
        CLEAR t_tabs.
        
        LOOP AT t_products INTO product WHERE selected = abap_true.
          
          CLEAR temp12.
          MOVE-CORRESPONDING product TO temp12.
          APPEND temp12 TO t_tabs.
        ENDLOOP.
        
        CLEAR temp13.
        
        READ TABLE t_tabs INTO temp14 INDEX 1.
        IF sy-subrc = 0.
          temp13 = temp14-product_id.
        ENDIF.
        selected_tab = temp13.
        buttons_state( edit = abap_true ).
        nav_page = `tabContainerPage`.
        
        CLEAR temp15.
        INSERT `navCon` INTO TABLE temp15.
        INSERT `to` INTO TABLE temp15.
        INSERT nav_page INTO TABLE temp15.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = temp15 ).

      WHEN `TAB_SELECT`.
        selected_tab = client->get_event_arg( ).
        " _handleTabContainerItemSelect: the buttons follow the tab's modified flag
        
        
        READ TABLE t_tabs WITH KEY product_id = selected_tab modified = abap_true TRANSPORTING NO FIELDS.
        temp1 = sy-subrc.
        
        temp5 = boolc( temp1 = 0 ).
        is_modified = temp5.
        
        temp6 = boolc( is_modified = abap_false ).
        buttons_state( edit = temp6 save = is_modified cancel = is_modified ).

      WHEN `TAB_EDIT`.
        " handleTabContainerEditItem: the tab goes into edit mode over its own copy
        
        READ TABLE t_tabs WITH KEY product_id = selected_tab ASSIGNING <tab>.
        IF sy-subrc <> 0.
          RETURN.
        ENDIF.
        <tab>-modified = abap_true.
        buttons_state( save = abap_true cancel = abap_true ).

      WHEN `TAB_SAVE`.
        tab_save( ).

      WHEN `TAB_CANCEL`.
        " handleTabContainerCancelUpdate: a never-saved row disappears with its tab,
        " an existing one falls back to the stored product
        buttons_state( edit = abap_true ).
        
        READ TABLE t_products WITH KEY product_id = selected_tab unsaved = abap_true TRANSPORTING NO FIELDS.
        temp17 = sy-subrc.
        IF temp17 = 0.
          tab_close( selected_tab ).
        ELSE.
          
          READ TABLE t_tabs WITH KEY product_id = selected_tab ASSIGNING <reset_tab>.
          IF sy-subrc = 0.
            
            
            temp3 = sy-tabix.
            READ TABLE t_products WITH KEY product_id = selected_tab INTO temp2.
            sy-tabix = temp3.
            IF sy-subrc <> 0.
              ASSERT 1 = 0.
            ENDIF.
            MOVE-CORRESPONDING temp2 TO <reset_tab>.
          ENDIF.
        ENDIF.
        view_display( ).

      WHEN `TAB_CLOSE`.
        pending_close = client->get_event_arg( ).
        " _handleTabContainerItemClose: a modified tab asks before it goes
        
        READ TABLE t_tabs WITH KEY product_id = pending_close modified = abap_true TRANSPORTING NO FIELDS.
        temp18 = sy-subrc.
        IF temp18 = 0.
          
          CLEAR temp19.
          INSERT `Close Tab` INTO TABLE temp19.
          INSERT `CANCEL` INTO TABLE temp19.
          client->message_box_display( text         = `Your changes will be lost when you close this tab`
                                       type         = `warning`
                                       title        = `Warning`
                                       actions      = temp19
                                       initialfocus = `CANCEL`
                                       onclose      = `CLOSE_TAB_CLOSED` ).
        ELSE.
          tab_close( pending_close ).
        ENDIF.
        " the close was vetoed on the wire, so the tab is still there either way:
        " a confirmed close removes its row and this display drops it, a
        " cancelled one leaves the row and the tab simply stays
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
        
        new_id = |ProductId-{ new_counter }|.
        
        CLEAR temp21.
        temp21-product_id = new_id.
        temp21-currencycode = `EUR`.
        temp21-selected = abap_true.
        temp21-unsaved = abap_true.
        APPEND temp21 TO t_products.
        
        CLEAR temp22.
        temp22-product_id = new_id.
        temp22-currencycode = `EUR`.
        temp22-modified = abap_true.
        APPEND temp22 TO t_tabs.
        selected_tab = new_id.
        buttons_state( save = abap_true cancel = abap_true ).
        view_display( ).

      WHEN `NEW_ITEM_ADD`.
        " handleNewItemAdd: a fresh edit model on the add page
        new_counter = new_counter + 1.
        add_product_id = |ProductId-{ new_counter }|.
        CLEAR: add_name, add_supplier, add_description.
        add_price = 0.
        add_mode = abap_true.
        nav_page = `addItemPage`.
        
        CLEAR temp23.
        INSERT `navCon` INTO TABLE temp23.
        INSERT `to` INTO TABLE temp23.
        INSERT nav_page INTO TABLE temp23.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = temp23 ).

      WHEN `NEW_ITEM_SAVE`.
        " handleNewItemSave: the form's data joins the collection
        
        CLEAR temp25.
        temp25-product_id = add_product_id.
        temp25-name = add_name.
        temp25-suppliername = add_supplier.
        temp25-description = add_description.
        temp25-price = add_price.
        temp25-currencycode = `EUR`.
        APPEND temp25 TO t_products.
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
          
          
          LOOP AT t_tabs REFERENCE INTO lr_tab.
            
            READ TABLE t_products WITH KEY product_id = lr_tab->product_id TRANSPORTING NO FIELDS.
            temp27 = sy-subrc.
            IF NOT temp27 = 0.
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
    DATA temp28 TYPE z2ui5_cl_smpc_app_558=>ty_t_product.
    DATA temp29 LIKE LINE OF temp28.
    CLEAR temp28.
    
    temp29-product_id = `HT-1000`.
    temp29-name = `Notebook Basic 15`.
    temp29-suppliername = `Very Best Screens`.
    temp29-currencycode = `EUR`.
    temp29-price = `956`.
    temp29-description = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1001`.
    temp29-name = `Notebook Basic 17`.
    temp29-suppliername = `Very Best Screens`.
    temp29-currencycode = `EUR`.
    temp29-price = `1249`.
    temp29-description = `Notebook Basic 17 with 2,80 GHz quad core, 17" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1002`.
    temp29-name = `Notebook Basic 18`.
    temp29-suppliername = `Very Best Screens`.
    temp29-currencycode = `EUR`.
    temp29-price = `1570`.
    temp29-description = `Notebook Basic 18 with 2,80 GHz quad core, 18" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1003`.
    temp29-name = `Notebook Basic 19`.
    temp29-suppliername = `Smartcards`.
    temp29-currencycode = `EUR`.
    temp29-price = `1650`.
    temp29-description = `Notebook Basic 19 with 2,80 GHz quad core, 19" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1007`.
    temp29-name = `ITelO Vault`.
    temp29-suppliername = `Technocom`.
    temp29-currencycode = `EUR`.
    temp29-price = `299`.
    temp29-description = `Digital Organizer with State-of-the-Art Storage Encryption`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1010`.
    temp29-name = `Notebook Professional 15`.
    temp29-suppliername = `Very Best Screens`.
    temp29-currencycode = `EUR`.
    temp29-price = `1999`.
    temp29-description = `Notebook Professional 15 with 2,80 GHz quad core, 15" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1011`.
    temp29-name = `Notebook Professional 17`.
    temp29-suppliername = `Very Best Screens`.
    temp29-currencycode = `EUR`.
    temp29-price = `2299`.
    temp29-description = `Notebook Professional 17 with 2,80 GHz quad core, 17" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1020`.
    temp29-name = `ITelO Vault Net`.
    temp29-suppliername = `Technocom`.
    temp29-currencycode = `EUR`.
    temp29-price = `459`.
    temp29-description = `Digital Organizer with State-of-the-Art Encryption for Storage and Network Communications`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1021`.
    temp29-name = `ITelO Vault SAT`.
    temp29-suppliername = `Technocom`.
    temp29-currencycode = `EUR`.
    temp29-price = `149`.
    temp29-description = `Digital Organizer with State-of-the-Art Encryption for Storage and Secure Stellite Link`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1022`.
    temp29-name = `Comfort Easy`.
    temp29-suppliername = `Technocom`.
    temp29-currencycode = `EUR`.
    temp29-price = `1679`.
    temp29-description = `32 GB Digital Assistant with high-resolution color screen`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1023`.
    temp29-name = `Comfort Senior`.
    temp29-suppliername = `Technocom`.
    temp29-currencycode = `EUR`.
    temp29-price = `512`.
    temp29-description = `64 GB Digital Assistant with high-resolution color screen and synthesized voice output`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1030`.
    temp29-name = `Ergo Screen E-I`.
    temp29-suppliername = `Very Best Screens`.
    temp29-currencycode = `EUR`.
    temp29-price = `230`.
    temp29-description = `Optimum Hi-Resolution max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1031`.
    temp29-name = `Ergo Screen E-II`.
    temp29-suppliername = `Very Best Screens`.
    temp29-currencycode = `EUR`.
    temp29-price = `285`.
    temp29-description = `Optimum Hi-Resolution max. 1920 x 1200 @ 85Hz, Dot Pitch: 0.26mm`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1032`.
    temp29-name = `Ergo Screen E-III`.
    temp29-suppliername = `Very Best Screens`.
    temp29-currencycode = `EUR`.
    temp29-price = `345`.
    temp29-description = `Optimum Hi-Resolution max. 2560 x 1440 @ 85Hz, Dot Pitch: 0.25mm`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1035`.
    temp29-name = `Flat Basic`.
    temp29-suppliername = `Very Best Screens`.
    temp29-currencycode = `EUR`.
    temp29-price = `399`.
    temp29-description = `Optimum Hi-Resolution max. 1600 x 1200 @ 85Hz, Dot Pitch: 0.24mm`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1036`.
    temp29-name = `Flat Future`.
    temp29-suppliername = `Very Best Screens`.
    temp29-currencycode = `EUR`.
    temp29-price = `430`.
    temp29-description = `Optimum Hi-Resolution max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.26mm`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1037`.
    temp29-name = `Flat XL`.
    temp29-suppliername = `Very Best Screens`.
    temp29-currencycode = `EUR`.
    temp29-price = `1230`.
    temp29-description = `Optimum Hi-Resolution max. 2016 x 1512 @ 85Hz, Dot Pitch: 0.24mm`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1040`.
    temp29-name = `Laser Professional Eco`.
    temp29-suppliername = `Alpha Printers`.
    temp29-currencycode = `EUR`.
    temp29-price = `830`.
    temp29-description = `Print 2400 dpi image quality color documents at speeds of up to 32 ppm (color) or 36 ppm (monochrome), letter/A4. Powerful 500 MHz processor, 512MB of memory`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1041`.
    temp29-name = `Laser Basic`.
    temp29-suppliername = `Alpha Printers`.
    temp29-currencycode = `EUR`.
    temp29-price = `490`.
    temp29-description = `Up to 22 ppm color or 24 ppm monochrome A4/letter, powerful 500 MHz processor and 128MB of memory`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1042`.
    temp29-name = `Laser Allround`.
    temp29-suppliername = `Alpha Printers`.
    temp29-currencycode = `EUR`.
    temp29-price = `349`.
    temp29-description = `Print up to 25 ppm letter and 24 ppm A4 color or monochrome, with Available first-page-out-time of less than 13 seconds for monochrome and less than 15 seconds for color`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1050`.
    temp29-name = `Ultra Jet Super Color`.
    temp29-suppliername = `Alpha Printers`.
    temp29-currencycode = `EUR`.
    temp29-price = `139`.
    temp29-description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB, Ethernet`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1051`.
    temp29-name = `Ultra Jet Mobile`.
    temp29-suppliername = `Printer for All`.
    temp29-currencycode = `EUR`.
    temp29-price = `99`.
    temp29-description = `1000 dpi x 1000 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB - excellent dimensions for the small office`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1052`.
    temp29-name = `Ultra Jet Super Highspeed`.
    temp29-suppliername = `Printer for All`.
    temp29-currencycode = `EUR`.
    temp29-price = `170`.
    temp29-description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB2.0, Ethernet`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1055`.
    temp29-name = `Multi Print`.
    temp29-suppliername = `Printer for All`.
    temp29-currencycode = `EUR`.
    temp29-price = `99`.
    temp29-description = `1000 dpi x 1000 dpi - up to 16 ppm (mono) / up to 15 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 1200dpi x 2400dpi)`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1056`.
    temp29-name = `Multi Color`.
    temp29-suppliername = `Printer for All`.
    temp29-currencycode = `EUR`.
    temp29-price = `119`.
    temp29-description = `1200 dpi x 1200 dpi - up to 25 ppm (mono) / up to 24 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 2400dpi x 4800dpi, high resolution)`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1060`.
    temp29-name = `Cordless Mouse`.
    temp29-suppliername = `Oxynum`.
    temp29-currencycode = `EUR`.
    temp29-price = `9`.
    temp29-description = `Cordless Optical USB Mice, Laptop, Color: Black, Plug&Play`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1061`.
    temp29-name = `Speed Mouse`.
    temp29-suppliername = `Oxynum`.
    temp29-currencycode = `EUR`.
    temp29-price = `7`.
    temp29-description = `Optical USB, PS/2 Mouse, Color: Blue, 3-button-functionality (incl. Scroll wheel)`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1062`.
    temp29-name = `Track Mouse`.
    temp29-suppliername = `Oxynum`.
    temp29-currencycode = `EUR`.
    temp29-price = `11`.
    temp29-description = `Optical USB Mouse, Color: Red, 5-button-functionality(incl. Scroll wheel), Plug&Play`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1063`.
    temp29-name = `Ergonomic Keyboard`.
    temp29-suppliername = `Oxynum`.
    temp29-currencycode = `EUR`.
    temp29-price = `14`.
    temp29-description = `Ergonomic USB Keyboard for Desktop, Plug&Play`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1064`.
    temp29-name = `Internet Keyboard`.
    temp29-suppliername = `Oxynum`.
    temp29-currencycode = `EUR`.
    temp29-price = `16`.
    temp29-description = `Corded Keyboard with special keys for Internet Usability, USB`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1065`.
    temp29-name = `Media Keyboard`.
    temp29-suppliername = `Oxynum`.
    temp29-currencycode = `EUR`.
    temp29-price = `26`.
    temp29-description = `Corded Ergonomic Keyboard with special keys for Media Usability, USB`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1066`.
    temp29-name = `Mousepad`.
    temp29-suppliername = `Oxynum`.
    temp29-currencycode = `EUR`.
    temp29-price = `6.99`.
    temp29-description = `Nice mouse pad with ITelO Logo`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1067`.
    temp29-name = `Ergo Mousepad`.
    temp29-suppliername = `Oxynum`.
    temp29-currencycode = `EUR`.
    temp29-price = `8.99`.
    temp29-description = `Ergonomic mouse pad with ITelO Logo`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1068`.
    temp29-name = `Designer Mousepad`.
    temp29-suppliername = `Fasttech`.
    temp29-currencycode = `EUR`.
    temp29-price = `12.99`.
    temp29-description = `ITelO Mousepad Special Edition`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1069`.
    temp29-name = `Universal card reader`.
    temp29-suppliername = `Fasttech`.
    temp29-currencycode = `EUR`.
    temp29-price = `14`.
    temp29-description = `Universal card reader`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1070`.
    temp29-name = `Proctra X`.
    temp29-suppliername = `Ultrasonic United`.
    temp29-currencycode = `EUR`.
    temp29-price = `70.9`.
    temp29-description = `Proctra X: PCI-E GDDR5 3072MB`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1071`.
    temp29-name = `Gladiator MX`.
    temp29-suppliername = `Ultrasonic United`.
    temp29-currencycode = `EUR`.
    temp29-price = `81.7`.
    temp29-description = `Gladiator XLN: PCI-E GDDR5 3072MB DVI Out, TV Out low-noise`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1072`.
    temp29-name = `Hurricane GX`.
    temp29-suppliername = `Ultrasonic United`.
    temp29-currencycode = `EUR`.
    temp29-price = `101.2`.
    temp29-description = `Hurricane GX: PCI-E 691 GFLOPS game-optimized`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1073`.
    temp29-name = `Hurricane GX/LN`.
    temp29-suppliername = `Smartcards`.
    temp29-currencycode = `EUR`.
    temp29-price = `139.99`.
    temp29-description = `Hurricane GX/LN: PCI-E 691 GFLOPS game-optimized, low-noise.`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1080`.
    temp29-name = `Photo Scan`.
    temp29-suppliername = `Printer for All`.
    temp29-currencycode = `EUR`.
    temp29-price = `129`.
    temp29-description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - Hi-Speed USB - Bluetooth`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1081`.
    temp29-name = `Power Scan`.
    temp29-suppliername = `Printer for All`.
    temp29-currencycode = `EUR`.
    temp29-price = `89`.
    temp29-description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - SCSI for backward compatibility`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1082`.
    temp29-name = `Jet Scan Professional`.
    temp29-suppliername = `Printer for All`.
    temp29-currencycode = `EUR`.
    temp29-price = `169`.
    temp29-description = `Flatbed scanner - Letter - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1083`.
    temp29-name = `Jet Scan Professional`.
    temp29-suppliername = `Printer for All`.
    temp29-currencycode = `EUR`.
    temp29-price = `189`.
    temp29-description = `Flatbed scanner - A4 - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1085`.
    temp29-name = `Copymaster`.
    temp29-suppliername = `Alpha Printers`.
    temp29-currencycode = `EUR`.
    temp29-price = `1499`.
    temp29-description = `Copymaster`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1090`.
    temp29-name = `Surround Sound`.
    temp29-suppliername = `Speaker Experts`.
    temp29-currencycode = `EUR`.
    temp29-price = `39`.
    temp29-description = `PC multimedia speakers - 5 Watt (Total)`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1091`.
    temp29-name = `Blaster Extreme`.
    temp29-suppliername = `Speaker Experts`.
    temp29-currencycode = `EUR`.
    temp29-price = `26`.
    temp29-description = `PC multimedia speakers - 10 Watt (Total) - 2-way`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1092`.
    temp29-name = `Sound Booster`.
    temp29-suppliername = `Speaker Experts`.
    temp29-currencycode = `EUR`.
    temp29-price = `45`.
    temp29-description = `PC multimedia speakers - optimized for Blutooth/A2DP`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1095`.
    temp29-name = `Lovely Sound 5.1 Wireless`.
    temp29-suppliername = `Fasttech`.
    temp29-currencycode = `EUR`.
    temp29-price = `49`.
    temp29-description = `5.1 Headset, 40 Hz-20 kHz, Wireless`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1096`.
    temp29-name = `Lovely Sound 5.1`.
    temp29-suppliername = `Fasttech`.
    temp29-currencycode = `EUR`.
    temp29-price = `39`.
    temp29-description = `5.1 Headset, 40 Hz-20 kHz, 3m cable`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1097`.
    temp29-name = `Lovely Sound Stereo`.
    temp29-suppliername = `Fasttech`.
    temp29-currencycode = `EUR`.
    temp29-price = `29`.
    temp29-description = `5.1 Headset, 40 Hz-20 kHz, 1m cable`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1100`.
    temp29-name = `Smart Office`.
    temp29-suppliername = `Technocom`.
    temp29-currencycode = `EUR`.
    temp29-price = `89.9`.
    temp29-description = `Complete package, 1 User, Office Applications (word processing, spreadsheet, presentations)`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1101`.
    temp29-name = `Smart Design`.
    temp29-suppliername = `Technocom`.
    temp29-currencycode = `EUR`.
    temp29-price = `79.9`.
    temp29-description = `Complete package, 1 User, Image editing, processing`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1102`.
    temp29-name = `Smart Network`.
    temp29-suppliername = `Technocom`.
    temp29-currencycode = `EUR`.
    temp29-price = `69`.
    temp29-description = `Complete package, 1 User, Network Software Utilities, Useful Applications and Documentation`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1103`.
    temp29-name = `Smart Multimedia`.
    temp29-suppliername = `Technocom`.
    temp29-currencycode = `EUR`.
    temp29-price = `77`.
    temp29-description = `Complete package, 1 User, different Multimedia applications, playing music, watching DVDs, only with this Smart package`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1104`.
    temp29-name = `Smart Games`.
    temp29-suppliername = `Technocom`.
    temp29-currencycode = `EUR`.
    temp29-price = `55`.
    temp29-description = `Complete package, 1 User, various games for amusement, logic, action, jump&run`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1105`.
    temp29-name = `Smart Internet Antivirus`.
    temp29-suppliername = `Brainsoft`.
    temp29-currencycode = `EUR`.
    temp29-price = `29`.
    temp29-description = `Complete package, 1 User, highly recommended for internet users as anti-virus protection`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1106`.
    temp29-name = `Smart Firewall`.
    temp29-suppliername = `Brainsoft`.
    temp29-currencycode = `EUR`.
    temp29-price = `34`.
    temp29-description = `Complete package, 1 User, recommended for internet users, protect your PC against cyber-crime`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1107`.
    temp29-name = `Smart Money`.
    temp29-suppliername = `Brainsoft`.
    temp29-currencycode = `EUR`.
    temp29-price = `29.9`.
    temp29-description = `Complete package, 1 User, bring your money in your mind, see what you have and what you want`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1110`.
    temp29-name = `PC Lock`.
    temp29-suppliername = `Red Point Stores`.
    temp29-currencycode = `EUR`.
    temp29-price = `8.9`.
    temp29-description = `Robust 3m anti-burglary protection for your laptop computer`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1111`.
    temp29-name = `Notebook Lock`.
    temp29-suppliername = `Red Point Stores`.
    temp29-currencycode = `EUR`.
    temp29-price = `6.9`.
    temp29-description = `Robust 1m anti-burglary protection for your desktop computer`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1112`.
    temp29-name = `Web cam reality`.
    temp29-suppliername = `Red Point Stores`.
    temp29-currencycode = `EUR`.
    temp29-price = `39`.
    temp29-description = `Color webcam, color, High-Speed USB`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1113`.
    temp29-name = `Screen clean`.
    temp29-suppliername = `Red Point Stores`.
    temp29-currencycode = `EUR`.
    temp29-price = `2.3`.
    temp29-description = `10 separately packed screen wipes`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1114`.
    temp29-name = `Fabric bag professional`.
    temp29-suppliername = `Red Point Stores`.
    temp29-currencycode = `EUR`.
    temp29-price = `31`.
    temp29-description = `Notebook bag, plenty of room for stationery and writing materials`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1115`.
    temp29-name = `Wireless DSL Router`.
    temp29-suppliername = `Red Point Stores`.
    temp29-currencycode = `EUR`.
    temp29-price = `49`.
    temp29-description = `Wireless DSL Router (available in blue, black and silver)`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1116`.
    temp29-name = `Wireless DSL Router / Repeater`.
    temp29-suppliername = `Red Point Stores`.
    temp29-currencycode = `EUR`.
    temp29-price = `59`.
    temp29-description = `Wireless DSL Router / Repeater (available in blue, black and silver)`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1117`.
    temp29-name = `Wireless DSL Router / Repeater and Print Server`.
    temp29-suppliername = `Technocom`.
    temp29-currencycode = `EUR`.
    temp29-price = `69`.
    temp29-description = `Wireless DSL Router / Repeater and Print Server (available in blue, black and silver)`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1118`.
    temp29-name = `USB Stick`.
    temp29-suppliername = `Technocom`.
    temp29-currencycode = `EUR`.
    temp29-price = `35`.
    temp29-description = `USB 2.0 High-Speed 64 GB`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1119`.
    temp29-name = `Travel Adapter`.
    temp29-suppliername = `Titanium`.
    temp29-currencycode = `EUR`.
    temp29-price = `79`.
    temp29-description = `Universal Travel Adapter`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1120`.
    temp29-name = `Cordless Bluetooth Keyboard, english international`.
    temp29-suppliername = `Technocom`.
    temp29-currencycode = `EUR`.
    temp29-price = `29`.
    temp29-description = `Cordless Bluetooth Keyboard with English keys`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1137`.
    temp29-name = `Flat XXL`.
    temp29-suppliername = `Technocom`.
    temp29-currencycode = `EUR`.
    temp29-price = `1430`.
    temp29-description = `Optimum Hi-Resolution max. 2048 × 1536 @ 85Hz, Dot Pitch: 0.24mm`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1138`.
    temp29-name = `Pocket Mouse`.
    temp29-suppliername = `Technocom`.
    temp29-currencycode = `EUR`.
    temp29-price = `23`.
    temp29-description = `Portable pocket Mouse with retracting cord`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1210`.
    temp29-name = `PC Power Station`.
    temp29-suppliername = `Technocom`.
    temp29-currencycode = `EUR`.
    temp29-price = `2399`.
    temp29-description = `PC Power Station with 3,4 Ghz quad-core, 32 GB DDR3 SDRAM, feels like Available PC, Windows 8 Pro`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1251`.
    temp29-name = `Astro Laptop 1516`.
    temp29-suppliername = `Ultrasonic United`.
    temp29-currencycode = `EUR`.
    temp29-price = `989`.
    temp29-description = `Flexible Laptop with 2,5 GHz Quad Core, 15" HD TN, 16 GB DDR SDRAM, 256 GB SSD, Windows 10 Pro`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1252`.
    temp29-name = `Astro Phone 6`.
    temp29-suppliername = `Ultrasonic United`.
    temp29-currencycode = `EUR`.
    temp29-price = `649`.
    temp29-description = `6 inch 1280x800 HD display (216 ppi), Quad-core processor, 8 GB internal storage (actual formatted capacity will be less), 3050 mAh battery (Up to 8 hours of active use), grey or black`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1253`.
    temp29-name = `Benda Laptop 1408`.
    temp29-suppliername = `Ultrasonic United`.
    temp29-currencycode = `EUR`.
    temp29-price = `976`.
    temp29-description = `Flexible Laptop with 2,5 GHz Dual Core, 14" HD+ TN, 8 GB DDR SDRAM, 324 GB SSD, Windows 10 Pro`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1254`.
    temp29-name = `Bending Screen 21HD`.
    temp29-suppliername = `Ultrasonic United`.
    temp29-currencycode = `EUR`.
    temp29-price = `250`.
    temp29-description = `Optimum Hi-Resolution Widescreen max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1255`.
    temp29-name = `Broad Screen 22HD`.
    temp29-suppliername = `Ultrasonic United`.
    temp29-currencycode = `EUR`.
    temp29-price = `270`.
    temp29-description = `Optimum Hi-Resolution Widescreen max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1256`.
    temp29-name = `Cerdik Phone 7`.
    temp29-suppliername = `Ultrasonic United`.
    temp29-currencycode = `EUR`.
    temp29-price = `549`.
    temp29-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1257`.
    temp29-name = `Cepat Tablet 10.5`.
    temp29-suppliername = `Ultrasonic United`.
    temp29-currencycode = `EUR`.
    temp29-price = `549`.
    temp29-description = `10.5-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1258`.
    temp29-name = `Cepat Tablet 8`.
    temp29-suppliername = `Ultrasonic United`.
    temp29-currencycode = `EUR`.
    temp29-price = `529`.
    temp29-description = `8-inch Multitouch HD Screen (2000 x 1500) 32GB Internal Memory, Wireless N Wi-Fi, Bluetooth, GPS Enabled, 1.5 GHz Quad-Core Processor`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1500`.
    temp29-name = `Server Basic`.
    temp29-suppliername = `Technocom`.
    temp29-currencycode = `EUR`.
    temp29-price = `5000`.
    temp29-description = `Dual socket, quad-core processing server with 1333 MHz Front Side Bus with 10Gb connectivity`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1501`.
    temp29-name = `Server Professional`.
    temp29-suppliername = `Technocom`.
    temp29-currencycode = `EUR`.
    temp29-price = `15000`.
    temp29-description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 10Gb connectivity`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1502`.
    temp29-name = `Server Power Pro`.
    temp29-suppliername = `Technocom`.
    temp29-currencycode = `EUR`.
    temp29-price = `25000`.
    temp29-description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 100Gb connectivity`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1600`.
    temp29-name = `Family PC Basic`.
    temp29-suppliername = `Titanium`.
    temp29-currencycode = `EUR`.
    temp29-price = `600`.
    temp29-description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Graphic Card: Proctra X, Windows 8`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1601`.
    temp29-name = `Family PC Pro`.
    temp29-suppliername = `Titanium`.
    temp29-currencycode = `EUR`.
    temp29-price = `900`.
    temp29-description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1602`.
    temp29-name = `Gaming Monster`.
    temp29-suppliername = `Titanium`.
    temp29-currencycode = `EUR`.
    temp29-price = `1200`.
    temp29-description = `3,4 Ghz quad core, 8 GB DDR3 SDRAM, 2000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-1603`.
    temp29-name = `Gaming Monster Pro`.
    temp29-suppliername = `Titanium`.
    temp29-currencycode = `EUR`.
    temp29-price = `1700`.
    temp29-description = `3,4 Ghz quad core, 16 GB DDR3 SDRAM, 4000 GB Hard Disc, Graphic Card: Hurricane GX, Windows 8`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-2000`.
    temp29-name = `7" Widescreen Portable DVD Player w MP3`.
    temp29-suppliername = `Titanium`.
    temp29-currencycode = `EUR`.
    temp29-price = `249.99`.
    temp29-description = `7" LCD Screen, storage battery holds up to 6 hours!`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-2001`.
    temp29-name = `10" Portable DVD player`.
    temp29-suppliername = `Titanium`.
    temp29-currencycode = `EUR`.
    temp29-price = `449.99`.
    temp29-description = `10" LCD Screen, storage battery holds up to 8 hours`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-2002`.
    temp29-name = `Portable DVD Player with 9" LCD Monitor`.
    temp29-suppliername = `Technocom`.
    temp29-currencycode = `EUR`.
    temp29-price = `853.99`.
    temp29-description = `9" LCD Screen, storage holds up to 8 hours, 2 speakers included`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-2025`.
    temp29-name = `CD/DVD case: 264 sleeves`.
    temp29-suppliername = `Titanium`.
    temp29-currencycode = `EUR`.
    temp29-price = `44.99`.
    temp29-description = `Organizer and protective case for 264 CDs and DVDs`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-2026`.
    temp29-name = `Audio/Video Cable Kit - 4m`.
    temp29-suppliername = `Titanium`.
    temp29-currencycode = `EUR`.
    temp29-price = `29.99`.
    temp29-description = `Quality cables for notebooks and projectors`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-2027`.
    temp29-name = `Removable CD/DVD Laser Labels`.
    temp29-suppliername = `Titanium`.
    temp29-currencycode = `EUR`.
    temp29-price = `8.99`.
    temp29-description = `Removable jewel case labels, zero residues (100)`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-6100`.
    temp29-name = `Beam Breaker B-1`.
    temp29-suppliername = `Titanium`.
    temp29-currencycode = `EUR`.
    temp29-price = `469`.
    temp29-description = `720p, DLP Projector max. 8,45 Meter, 2D`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-6101`.
    temp29-name = `Beam Breaker B-2`.
    temp29-suppliername = `Technocom`.
    temp29-currencycode = `EUR`.
    temp29-price = `679`.
    temp29-description = `1080p, DLP max.9,34 Meter, 2D-ready`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-6102`.
    temp29-name = `Beam Breaker B-3`.
    temp29-suppliername = `Technocom`.
    temp29-currencycode = `EUR`.
    temp29-price = `889`.
    temp29-description = `1080p, DLP max. 12,3 Meter, 3D-ready`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-6110`.
    temp29-name = `Play Movie`.
    temp29-suppliername = `Fasttech`.
    temp29-currencycode = `EUR`.
    temp29-price = `130`.
    temp29-description = `CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-6111`.
    temp29-name = `Record Movie`.
    temp29-suppliername = `Fasttech`.
    temp29-currencycode = `EUR`.
    temp29-price = `288`.
    temp29-description = `160 GB HDD, CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-6120`.
    temp29-name = `ITelo MusicStick`.
    temp29-suppliername = `Fasttech`.
    temp29-currencycode = `EUR`.
    temp29-price = `45`.
    temp29-description = `64 GB USB Music-on-Available-Stick`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-6121`.
    temp29-name = `ITelo Jog-Mate`.
    temp29-suppliername = `Fasttech`.
    temp29-currencycode = `EUR`.
    temp29-price = `63`.
    temp29-description = `ITelo Jog-Mate 64 GB HDD and Color Display, can play movies`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-6122`.
    temp29-name = `Power Pro Player 40`.
    temp29-suppliername = `Fasttech`.
    temp29-currencycode = `EUR`.
    temp29-price = `167`.
    temp29-description = `MP3-Player with 40 GB HDD and Color Display, can play movies`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-6123`.
    temp29-name = `Power Pro Player 80`.
    temp29-suppliername = `Fasttech`.
    temp29-currencycode = `EUR`.
    temp29-price = `299`.
    temp29-description = `MP3-Player with 80 GB SSD and Color Display, can play movies`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-6130`.
    temp29-name = `Flat Watch HD32`.
    temp29-suppliername = `Very Best Screens`.
    temp29-currencycode = `EUR`.
    temp29-price = `1459`.
    temp29-description = `32-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-6131`.
    temp29-name = `Flat Watch HD37`.
    temp29-suppliername = `Very Best Screens`.
    temp29-currencycode = `EUR`.
    temp29-price = `1199`.
    temp29-description = `37-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-6132`.
    temp29-name = `Flat Watch HD41`.
    temp29-suppliername = `Very Best Screens`.
    temp29-currencycode = `EUR`.
    temp29-price = `899`.
    temp29-description = `41-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-7000`.
    temp29-name = `Copperberry`.
    temp29-suppliername = `Fasttech`.
    temp29-currencycode = `EUR`.
    temp29-price = `549`.
    temp29-description = `Our new multifunctional Handheld with phone function in copper`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-7010`.
    temp29-name = `Silverberry`.
    temp29-suppliername = `Fasttech`.
    temp29-currencycode = `EUR`.
    temp29-price = `549`.
    temp29-description = `Our new multifunctional Handheld with phone function in silver`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-7020`.
    temp29-name = `Goldberry`.
    temp29-suppliername = `Fasttech`.
    temp29-currencycode = `EUR`.
    temp29-price = `549`.
    temp29-description = `Our new multifunctional Handheld with phone function in gold`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-7030`.
    temp29-name = `Platinberry`.
    temp29-suppliername = `Fasttech`.
    temp29-currencycode = `EUR`.
    temp29-price = `549`.
    temp29-description = `Our new multifunctional Handheld with phone function in platinum`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-8000`.
    temp29-name = `ITelO FlexTop I4000`.
    temp29-suppliername = `Titanium`.
    temp29-currencycode = `EUR`.
    temp29-price = `799`.
    temp29-description = `Notebook with 2,80 GHz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-8001`.
    temp29-name = `ITelO FlexTop I6300c`.
    temp29-suppliername = `Titanium`.
    temp29-currencycode = `EUR`.
    temp29-price = `799`.
    temp29-description = `Notebook with 2,80 GHz dual core, 8 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-8002`.
    temp29-name = `ITelO FlexTop I9100`.
    temp29-suppliername = `Titanium`.
    temp29-currencycode = `EUR`.
    temp29-price = `1199`.
    temp29-description = `Notebook with 2,80 GHz quad core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-8003`.
    temp29-name = `ITelO FlexTop I9800`.
    temp29-suppliername = `Titanium`.
    temp29-currencycode = `EUR`.
    temp29-price = `1388`.
    temp29-description = `Notebook with 2,80 GHz quad core, 8 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-9991`.
    temp29-name = `Smartphone Leather Case`.
    temp29-suppliername = `Ultrasonic United`.
    temp29-currencycode = `EUR`.
    temp29-price = `25`.
    temp29-description = `Button Clasp, Quality Material, 100% Leather, compatible with many smartphone models`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-9992`.
    temp29-name = `Smartphone Alpha`.
    temp29-suppliername = `Ultrasonic United`.
    temp29-currencycode = `EUR`.
    temp29-price = `599`.
    temp29-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-9993`.
    temp29-name = `Mini Tablet`.
    temp29-suppliername = `Ultrasonic United`.
    temp29-currencycode = `EUR`.
    temp29-price = `833`.
    temp29-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage, 4325 mAh battery (Up to 8 hours of active use)`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-9994`.
    temp29-name = `Camcorder View`.
    temp29-suppliername = `Ultrasonic United`.
    temp29-currencycode = `EUR`.
    temp29-price = `1388`.
    temp29-description = `1920x1080 Full HD, image stabilization reduces blur, 27x Optical / 32x Extended Zoom, wide angle Lens, 2.7" wide LCD display`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-9995`.
    temp29-name = `Tablet Pouch`.
    temp29-suppliername = `Titanium`.
    temp29-currencycode = `EUR`.
    temp29-price = `20`.
    temp29-description = `Stylish tablet pouch, protects from scratches, color: black`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-9996`.
    temp29-name = `Tablet Pouch`.
    temp29-suppliername = `Titanium`.
    temp29-currencycode = `EUR`.
    temp29-price = `20`.
    temp29-description = `Stylish tablet pouch, protects from scratches, color: black`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-9997`.
    temp29-name = `e-Book Reader ReadMe`.
    temp29-suppliername = `Titanium`.
    temp29-currencycode = `EUR`.
    temp29-price = `33`.
    temp29-description = `6-Inch E Ink Screen, Access To e-book Store, Adjustable Font Styles and Sizes, Stores Up To 1,000 Books`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-9998`.
    temp29-name = `Smartphone Beta`.
    temp29-suppliername = `Titanium`.
    temp29-currencycode = `EUR`.
    temp29-price = `30`.
    temp29-description = `5 Megapixel Camera, Wi-Fi 802.11 b/g/n, Bluetooth, GPS Available-GPS support`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `HT-9999`.
    temp29-name = `Maxi Tablet`.
    temp29-suppliername = `Titanium`.
    temp29-currencycode = `EUR`.
    temp29-price = `749`.
    temp29-description = `10.1-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor`.
    INSERT temp29 INTO TABLE temp28.
    temp29-product_id = `PF-1000`.
    temp29-name = `Flyer`.
    temp29-suppliername = `Titanium`.
    temp29-currencycode = `EUR`.
    temp29-price = `0`.
    temp29-description = `Flyer for our product palette`.
    INSERT temp29 INTO TABLE temp28.
    t_products = temp28.

  ENDMETHOD.

ENDCLASS.
