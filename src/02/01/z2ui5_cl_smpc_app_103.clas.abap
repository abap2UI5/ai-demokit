" @keywords selectdialog select dialog sap.m product list standardlistitem verticallayout button customdata input
" @summary The Select Dialog allows the user to search for and pick an item from a possibly long option list. Basically it is a convenience function to quickly assemble a Dialog, a Search Field and a List with Standard List Items.
CLASS z2ui5_cl_smpc_app_103 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    " the productInput's value, bound two-way: the value help preselects the
    " row matching WHAT IS IN THE FIELD (original _configValueHelpDialog reads
    " byId('productInput').getValue()), and the close handler writes back into it
    DATA product_value TYPE string.

    TYPES: BEGIN OF ty_s_product,
             name            TYPE string,
             product_id      TYPE string,
             description     TYPE string,
             category        TYPE string,
             main_category   TYPE string,
             supplier_name   TYPE string,
             width           TYPE string,
             depth           TYPE string,
             height          TYPE string,
             dim_unit        TYPE string,
             weight_measure  TYPE string,
             weight_unit     TYPE string,
             quantity        TYPE string,
             price           TYPE p LENGTH 8 DECIMALS 2,
             currency_code   TYPE string,
             product_pic_url TYPE string,
             selected        TYPE abap_bool,
           END OF ty_s_product.
    TYPES temp1_a3713cf5ce TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.
DATA t_products TYPE temp1_a3713cf5ce.
    DATA multi_select TYPE abap_bool.
    DATA growing TYPE abap_bool.
    DATA growing_threshold TYPE i.
    DATA remember TYPE abap_bool.
    DATA show_clear TYPE abap_bool.
    DATA confirm_text TYPE string.
    DATA draggable TYPE abap_bool.
    DATA resizable TYPE abap_bool.

  PROTECTED SECTION.
    TYPES: BEGIN OF ty_s_event_item,
             id    TYPE string,
             title TYPE string,
           END OF ty_s_event_item.
    TYPES ty_t_event_item TYPE STANDARD TABLE OF ty_s_event_item WITH DEFAULT KEY.

    DATA client TYPE REF TO z2ui5_if_client.
    CONSTANTS c_img_base TYPE string VALUE `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/`.

    METHODS view_display.
    METHODS on_event.
    METHODS event_items
      IMPORTING
        val           TYPE string
      RETURNING
        VALUE(result) TYPE ty_t_event_item.
    METHODS open_dialog IMPORTING multi       TYPE abap_bool DEFAULT abap_false
                                  rem         TYPE abap_bool DEFAULT abap_false
                                  grow        TYPE abap_bool DEFAULT abap_false
                                  threshold   TYPE i         DEFAULT 0
                                  clear       TYPE abap_bool DEFAULT abap_false
                                  confirmtext TYPE string    DEFAULT ``
                                  drag        TYPE abap_bool DEFAULT abap_false
                                  resize      TYPE abap_bool DEFAULT abap_false
                                  responsive  TYPE abap_bool DEFAULT abap_false.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_103 IMPLEMENTATION.

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
    DATA temp1 TYPE string_table.
    DATA temp2 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `mySelectDialog` INTO TABLE temp1.
    INSERT `items` INTO TABLE temp1.
    INSERT `filter` INTO TABLE temp1.
    INSERT `NAME` INTO TABLE temp1.
    INSERT `Contains` INTO TABLE temp1.
    INSERT `${$parameters>/value}` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `valueHelpDialog` INTO TABLE temp2.
    INSERT `items` INTO TABLE temp2.
    INSERT `filter` INTO TABLE temp2.
    INSERT `NAME` INTO TABLE temp2.
    INSERT `Contains` INTO TABLE temp2.
    INSERT `${$parameters>/value}` INTO TABLE temp2.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( n = `dependents` ns = `mvc`
            )->ele( `SelectDialog`
                )->a( n = `id`         v = `mySelectDialog`
                )->a( n = `noDataText` v = `No Products Found`
                )->a( n = `title`      v = `Select Product`
                )->a( n = `search`     v = client->follow_up_action( val   = client->cs_event-binding_call
                                                                     t_arg = temp1 )
                )->a( n = `confirm`    v = client->_event( val = `CONFIRM` arg = `${$parameters>/selectedItems}` )
                )->a( n = `cancel`     v = client->_event( val = `CONFIRM` arg = `${$parameters>/selectedItems}` )
                )->a( n = `multiSelect`        v = client->_bind( multi_select )
                )->a( n = `growing`            v = client->_bind( growing )
                )->a( n = `growingThreshold`   v = client->_bind( growing_threshold )
                )->a( n = `rememberSelections` v = client->_bind( remember )
                )->a( n = `showClearButton`    v = client->_bind( show_clear )
                )->a( n = `confirmButtonText`  v = client->_bind( confirm_text )
                )->a( n = `draggable`          v = client->_bind( draggable )
                )->a( n = `resizable`          v = client->_bind( resizable )
                )->a( n = `items` v = client->_bind( t_products )

                )->tag( `StandardListItem`
                    )->a( n = `title`            v = `{NAME}`
                    )->a( n = `description`      v = `{PRODUCT_ID}`
                    )->a( n = `icon`             v = `{PRODUCT_PIC_URL}`
                    )->a( n = `iconDensityAware` v = `false`
                    )->a( n = `iconInset`        v = `false`
                    )->a( n = `type`             v = `Active`

            )->end(
            )->ele( `SelectDialog`
                )->a( n = `id`                v = `valueHelpDialog`
                )->a( n = `noDataText`        v = `No Products Found`
                )->a( n = `title`             v = `Select Product`
                )->a( n = `search`            v = client->follow_up_action( val   = client->cs_event-binding_call
                                                                            t_arg = temp2 )
                )->a( n = `searchPlaceholder` v = `Search Products`
                )->a( n = `confirm`           v = client->_event( val = `VH_CLOSE` arg = `${$parameters>/selectedItem} ? ${$parameters>/selectedItem}.getTitle() : ''` )
                )->a( n = `cancel`            v = client->_event( `VH_CLOSE` )
                )->a( n = `showClearButton`   v = `true`
                )->a( n = `items` v = |\{ path: '{ client->_bind_path( t_products ) }', sorter: \{ path: 'NAME', descending: false \} \}|

                )->tag( `StandardListItem`
                    )->a( n = `selected`         v = `{SELECTED}`
                    )->a( n = `title`            v = `{NAME}`
                    )->a( n = `description`      v = `{PRODUCT_ID}`
                    )->a( n = `icon`             v = `{PRODUCT_PIC_URL}`
                    )->a( n = `iconDensityAware` v = `false`
                    )->a( n = `iconInset`        v = `false`
                    )->a( n = `type`             v = `Active`

            )->end(
        )->end(

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->ele( `Button`
                )->a( n = `text`  v = `Show Select Dialog`
                )->a( n = `press` v = client->_event( `OPEN_1` )
                )->a( n = `class` v = `sapUiSmallMarginBottom`

            )->end(
            )->ele( `Button`
                )->a( n = `text`  v = `Show Select Dialog (Remember)`
                )->a( n = `press` v = client->_event( `OPEN_2` )
                )->a( n = `class` v = `sapUiSmallMarginBottom`

                )->ele( `customData`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `remember`
                        )->a( n = `value` v = `true`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `text`  v = `Show Select Dialog (Multi)`
                )->a( n = `press` v = client->_event( `OPEN_3` )
                )->a( n = `class` v = `sapUiSmallMarginBottom`

                )->ele( `customData`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `multi`
                        )->a( n = `value` v = `true`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `text`  v = `Show Select Dialog (Remember)`
                )->a( n = `press` v = client->_event( `OPEN_4` )
                )->a( n = `class` v = `sapUiSmallMarginBottom`

                )->ele( `customData`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `multi`
                        )->a( n = `value` v = `true`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `remember`
                        )->a( n = `value` v = `true`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `showClearButton`
                        )->a( n = `value` v = `true`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `confirmButtonText`
                        )->a( n = `value` v = `Remember Selection`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `text`  v = `Show Select Dialog (growingThreshold=15)`
                )->a( n = `press` v = client->_event( `OPEN_5` )
                )->a( n = `class` v = `sapUiSmallMarginBottom`

                )->ele( `customData`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `multi`
                        )->a( n = `value` v = `true`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `remember`
                        )->a( n = `value` v = `true`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `growing`
                        )->a( n = `value` v = `true`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `threshold`
                        )->a( n = `value` v = `15`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `text`  v = `Show Select Dialog (growing=false)`
                )->a( n = `press` v = client->_event( `OPEN_6` )
                )->a( n = `class` v = `sapUiSmallMarginBottom`

                )->ele( `customData`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `multi`
                        )->a( n = `value` v = `true`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `remember`
                        )->a( n = `value` v = `true`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `growing`
                        )->a( n = `value` v = `false`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `text`  v = `Show Select Dialog (draggable=true)`
                )->a( n = `press` v = client->_event( `OPEN_7` )
                )->a( n = `class` v = `sapUiSmallMarginBottom`

                )->ele( `customData`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `multi`
                        )->a( n = `value` v = `true`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `draggable`
                        )->a( n = `value` v = `true`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `text`  v = `Show Select Dialog (resizable=true)`
                )->a( n = `press` v = client->_event( `OPEN_8` )
                )->a( n = `class` v = `sapUiSmallMarginBottom`

                )->ele( `customData`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `multi`
                        )->a( n = `value` v = `true`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `resizable`
                        )->a( n = `value` v = `true`

                )->end(
            )->end(
            )->ele( `Button`
                )->a( n = `text`  v = `Show Select Dialog with Responsive Padding`
                )->a( n = `press` v = client->_event( `OPEN_9` )
                )->a( n = `class` v = `sapUiSmallMarginBottom`

                )->ele( `customData`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `responsivePadding`
                        )->a( n = `value` v = `true`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `resizable`
                        )->a( n = `value` v = `true`
                    )->tag( n = `CustomData` ns = `core`
                        )->a( n = `key`   v = `draggable`
                        )->a( n = `value` v = `true`

                )->end(
            )->end(
            )->tag( `Input`
                )->a( n = `id`               v = `productInput`
                )->a( n = `type`             v = `Text`
                )->a( n = `value`            v = client->_bind( product_value )
                )->a( n = `placeholder`      v = `Enter Product ...`
                )->a( n = `showValueHelp`    v = `true`
                )->a( n = `valueHelpRequest` v = client->_event( `VALUE_HELP` )
                )->a( n = `class`            v = `sapUiSmallMarginBottom`
                )->a( n = `width`            v = `15rem` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
        DATA temp3 LIKE LINE OF t_products.
        DATA lr LIKE REF TO temp3.
          DATA temp1 TYPE xsdboolean.
        DATA temp4 TYPE string_table.
        DATA sel_items TYPE z2ui5_cl_smpc_app_103=>ty_t_event_item.
          DATA sel_names TYPE string.
          DATA temp6 LIKE LINE OF sel_items.
          DATA lr_sel LIKE REF TO temp6.
            DATA temp7 TYPE string.
        DATA temp8 TYPE string_table.

    CASE client->get_event( ).

      WHEN `OPEN_1`.
        open_dialog( ).

      WHEN `OPEN_2`.
        open_dialog( rem = abap_true ).

      WHEN `OPEN_3`.
        open_dialog( multi = abap_true ).

      WHEN `OPEN_4`.
        open_dialog( multi = abap_true rem = abap_true clear = abap_true confirmtext = `Remember Selection` ).

      WHEN `OPEN_5`.
        open_dialog( multi = abap_true rem = abap_true grow = abap_true threshold = 15 ).

      WHEN `OPEN_6`.
        open_dialog( multi = abap_true rem = abap_true ).

      WHEN `OPEN_7`.
        open_dialog( multi = abap_true drag = abap_true ).

      WHEN `OPEN_8`.
        open_dialog( multi = abap_true resize = abap_true ).

      WHEN `OPEN_9`.
        open_dialog( responsive = abap_true resize = abap_true drag = abap_true ).

      WHEN `VALUE_HELP`.
        " preselect the row matching the current input value (original _configValueHelpDialog)
        
        
        LOOP AT t_products REFERENCE INTO lr.
          
          temp1 = boolc( lr->name = product_value ).
          lr->selected = temp1.
        ENDLOOP.
        
        CLEAR temp4.
        INSERT `valueHelpDialog` INTO TABLE temp4.
        INSERT `open` INTO TABLE temp4.
        client->follow_up_action( val   = client->cs_event-control_by_id
                                  t_arg = temp4 ).

      WHEN `CONFIRM`.
        " onDialogClose: name every chosen product, or say that none was
        " picked. The original reads selectedContexts and maps getObject().Name;
        " a Context is not a control, so the wire carries the selectedItems
        " ARRAY instead - the frontend projects each StandardListItem to its
        " public properties, and title is the bound Name. Cancel fires the same
        " handler with no selection, which is the original's else branch
        
        sel_items = event_items( client->get_event_arg( ) ).
        IF sel_items IS INITIAL.
          client->message_toast_display( `No new item was selected.` ).
        ELSE.
          
          sel_names = ``.
          
          
          LOOP AT sel_items REFERENCE INTO lr_sel.
            
            IF sel_names IS INITIAL.
              temp7 = lr_sel->title.
            ELSE.
              temp7 = |{ sel_names }, { lr_sel->title }|.
            ENDIF.
            sel_names = temp7.
          ENDLOOP.
          client->message_toast_display( |You have chosen { sel_names }| ).
        ENDIF.
        " ... and the last line of onDialogClose:
        " oEvent.getSource( ).getBinding( 'items' ).filter( [] ) - so the
        " search a user typed is gone the next time the dialog opens. A
        " binding_call filter with no values is exactly that clear (the
        " client leaves the filter empty when value1 and value2 both are)
        
        CLEAR temp8.
        INSERT `mySelectDialog` INTO TABLE temp8.
        INSERT `items` INTO TABLE temp8.
        INSERT `filter` INTO TABLE temp8.
        client->follow_up_action( val   = client->cs_event-binding_call
                                  t_arg = temp8 ).

      WHEN `VH_CLOSE`.
        " onValueHelpDialogClose: the picked title lands in the input, and a
        " close with no selection resets it (the original's resetProperty)
        product_value = client->get_event_arg( ).

    ENDCASE.

  ENDMETHOD.


  METHOD event_items.

    DATA lv_json TYPE string.
    lv_json = condense( val ).
    IF lv_json IS INITIAL.
      RETURN.
    ENDIF.

    IF lv_json(1) <> `[`.
      lv_json = |[{ lv_json }]|.
    ENDIF.

    TRY.
        " the frontend marshals a control with ALL its public properties
        " (description, icon, type, ...), so only the fields this port models
        " are mapped - a plain to_abap( ) fails on the first extra one
        "
        " z2ui5_cl_ajson is the framework's VENDORED ajson copy and lives
        " outside the released API (src/02), so it may be renamed or
        " restructured without notice - the linter says so, and it is right.
        " There is no released JSON reader to use instead, the same reasoning
        " as app 298; declared as a deviation in the sidecar
        " abap2ui5lint-disable-next-line non-released-api -- no released JSON reader exists; see the comment above and the sidecar deviation
        z2ui5_cl_ajson=>parse( lv_json
          )->to_abap_corresponding_only(
          )->to_abap( IMPORTING ev_container = result ).
        " abap2ui5lint-disable-next-line non-released-api -- the exception of the call above
      CATCH z2ui5_cx_ajson_error.
        CLEAR result.
    ENDTRY.

  ENDMETHOD.


  METHOD open_dialog.
      DATA temp10 TYPE string_table.
      DATA temp12 TYPE string_table.
    DATA temp14 TYPE string_table.

    multi_select      = multi.
    remember          = rem.
    growing           = grow.
    growing_threshold = threshold.
    show_clear        = clear.
    confirm_text      = confirmtext.
    draggable         = drag.
    resizable         = resize.

    IF responsive = abap_true.
      
      CLEAR temp10.
      INSERT `mySelectDialog` INTO TABLE temp10.
      INSERT `addStyleClass` INTO TABLE temp10.
      INSERT `sapUiResponsivePadding--header sapUiResponsivePadding--subHeader sapUiResponsivePadding--content sapUiResponsivePadding--footer` INTO TABLE temp10.
      client->follow_up_action( val   = client->cs_event-control_by_id
                                t_arg = temp10 ).
    ELSE.
      
      CLEAR temp12.
      INSERT `mySelectDialog` INTO TABLE temp12.
      INSERT `removeStyleClass` INTO TABLE temp12.
      INSERT `sapUiResponsivePadding--header sapUiResponsivePadding--subHeader sapUiResponsivePadding--content sapUiResponsivePadding--footer` INTO TABLE temp12.
      client->follow_up_action( val   = client->cs_event-control_by_id
                                t_arg = temp12 ).
    ENDIF.

    
    CLEAR temp14.
    INSERT `mySelectDialog` INTO TABLE temp14.
    INSERT `open` INTO TABLE temp14.
    client->follow_up_action( val   = client->cs_event-control_by_id
                              t_arg = temp14 ).

  ENDMETHOD.


  METHOD model_init.
    DATA temp16 LIKE t_products.
    DATA temp17 LIKE LINE OF temp16.
    DATA temp18 LIKE LINE OF t_products.
    DATA lr_product LIKE REF TO temp18.

    " the original's view seeds the input with this product
    product_value = `Astro Phone 6`.

    
    CLEAR temp16.
    
    temp17-name = `Notebook Basic 15`.
    temp17-product_id = `HT-1000`.
    temp17-category = `Laptops`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Very Best Screens`.
    temp17-description = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.
    temp17-width = `30`.
    temp17-depth = `18`.
    temp17-height = `3`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `4.2`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `10`.
    temp17-price = '956.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Notebook Basic 17`.
    temp17-product_id = `HT-1001`.
    temp17-category = `Laptops`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Very Best Screens`.
    temp17-description = `Notebook Basic 17 with 2,80 GHz quad core, 17" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.
    temp17-width = `29`.
    temp17-depth = `17`.
    temp17-height = `3.1`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `4.5`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `20`.
    temp17-price = '1249.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Notebook Basic 18`.
    temp17-product_id = `HT-1002`.
    temp17-category = `Laptops`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Very Best Screens`.
    temp17-description = `Notebook Basic 18 with 2,80 GHz quad core, 18" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`.
    temp17-width = `28`.
    temp17-depth = `19`.
    temp17-height = `2.5`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `4.2`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `10`.
    temp17-price = '1570.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Notebook Basic 19`.
    temp17-product_id = `HT-1003`.
    temp17-category = `Laptops`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Smartcards`.
    temp17-description = `Notebook Basic 19 with 2,80 GHz quad core, 19" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`.
    temp17-width = `32`.
    temp17-depth = `21`.
    temp17-height = `4`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `4.2`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `15`.
    temp17-price = '1650.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `ITelO Vault`.
    temp17-product_id = `HT-1007`.
    temp17-category = `Accessories`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Technocom`.
    temp17-description = `Digital Organizer with State-of-the-Art Storage Encryption`.
    temp17-width = `32`.
    temp17-depth = `22`.
    temp17-height = `3`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.2`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `15`.
    temp17-price = '299.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Notebook Professional 15`.
    temp17-product_id = `HT-1010`.
    temp17-category = `Accessories`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Very Best Screens`.
    temp17-description = `Notebook Professional 15 with 2,80 GHz quad core, 15" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro`.
    temp17-width = `33`.
    temp17-depth = `20`.
    temp17-height = `3`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `4.3`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `16`.
    temp17-price = '1999.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Notebook Professional 17`.
    temp17-product_id = `HT-1011`.
    temp17-category = `Laptops`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Very Best Screens`.
    temp17-description = `Notebook Professional 17 with 2,80 GHz quad core, 17" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro`.
    temp17-width = `33`.
    temp17-depth = `23`.
    temp17-height = `2`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `4.1`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `17`.
    temp17-price = '2299.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `ITelO Vault Net`.
    temp17-product_id = `HT-1020`.
    temp17-category = `Accessories`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Technocom`.
    temp17-description = `Digital Organizer with State-of-the-Art Encryption for Storage and Network Communications`.
    temp17-width = `10`.
    temp17-depth = `1.8`.
    temp17-height = `17`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.16`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `14`.
    temp17-price = '459.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `ITelO Vault SAT`.
    temp17-product_id = `HT-1021`.
    temp17-category = `Accessories`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Technocom`.
    temp17-description = `Digital Organizer with State-of-the-Art Encryption for Storage and Secure Stellite Link`.
    temp17-width = `11`.
    temp17-depth = `1.7`.
    temp17-height = `18`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.18`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `50`.
    temp17-price = '149.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Comfort Easy`.
    temp17-product_id = `HT-1022`.
    temp17-category = `Accessories`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Technocom`.
    temp17-description = `32 GB Digital Assistant with high-resolution color screen`.
    temp17-width = `84`.
    temp17-depth = `1.5`.
    temp17-height = `14`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.2`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `30`.
    temp17-price = '1679.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Comfort Senior`.
    temp17-product_id = `HT-1023`.
    temp17-category = `Accessories`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Technocom`.
    temp17-description = `64 GB Digital Assistant with high-resolution color screen and synthesized voice output`.
    temp17-width = `80`.
    temp17-depth = `1.6`.
    temp17-height = `13`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.8`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `24`.
    temp17-price = '512.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Ergo Screen E-I`.
    temp17-product_id = `HT-1030`.
    temp17-category = `Flat Screen Monitors`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Very Best Screens`.
    temp17-description = `Optimum Hi-Resolution max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm`.
    temp17-width = `37`.
    temp17-depth = `12`.
    temp17-height = `36`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `21`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `14`.
    temp17-price = '230.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Ergo Screen E-II`.
    temp17-product_id = `HT-1031`.
    temp17-category = `Flat Screen Monitors`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Very Best Screens`.
    temp17-description = `Optimum Hi-Resolution max. 1920 x 1200 @ 85Hz, Dot Pitch: 0.26mm`.
    temp17-width = `40.8`.
    temp17-depth = `19`.
    temp17-height = `43`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `21`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `24`.
    temp17-price = '285.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Ergo Screen E-III`.
    temp17-product_id = `HT-1032`.
    temp17-category = `Flat Screen Monitors`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Very Best Screens`.
    temp17-description = `Optimum Hi-Resolution max. 2560 x 1440 @ 85Hz, Dot Pitch: 0.25mm`.
    temp17-width = `40.8`.
    temp17-depth = `19`.
    temp17-height = `43`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `21`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `50`.
    temp17-price = '345.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Flat Basic`.
    temp17-product_id = `HT-1035`.
    temp17-category = `Flat Screen Monitors`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Very Best Screens`.
    temp17-description = `Optimum Hi-Resolution max. 1600 x 1200 @ 85Hz, Dot Pitch: 0.24mm`.
    temp17-width = `39`.
    temp17-depth = `20`.
    temp17-height = `41`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `14`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `23`.
    temp17-price = '399.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Flat Future`.
    temp17-product_id = `HT-1036`.
    temp17-category = `Flat Screen Monitors`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Very Best Screens`.
    temp17-description = `Optimum Hi-Resolution max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.26mm`.
    temp17-width = `45`.
    temp17-depth = `26`.
    temp17-height = `46`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `15`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `22`.
    temp17-price = '430.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Flat XL`.
    temp17-product_id = `HT-1037`.
    temp17-category = `Flat Screen Monitors`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Very Best Screens`.
    temp17-description = `Optimum Hi-Resolution max. 2016 x 1512 @ 85Hz, Dot Pitch: 0.24mm`.
    temp17-width = `54.5`.
    temp17-depth = `22.1`.
    temp17-height = `39.1`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `17`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `23`.
    temp17-price = '1230.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Laser Professional Eco`.
    temp17-product_id = `HT-1040`.
    temp17-category = `Printers`.
    temp17-main_category = `Printers & Scanners`.
    temp17-supplier_name = `Alpha Printers`.
    temp17-description = `Print 2400 dpi image quality color documents at speeds of up to 32 ppm (color) or 36 ppm (monochrome), letter/A4. Powerful 500 MHz processor, 512MB of memory`.
    temp17-width = `51`.
    temp17-depth = `46`.
    temp17-height = `30`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `32`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `21`.
    temp17-price = '830.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Laser Basic`.
    temp17-product_id = `HT-1041`.
    temp17-category = `Printers`.
    temp17-main_category = `Printers & Scanners`.
    temp17-supplier_name = `Alpha Printers`.
    temp17-description = `Up to 22 ppm color or 24 ppm monochrome A4/letter, powerful 500 MHz processor and 128MB of memory`.
    temp17-width = `48`.
    temp17-depth = `42`.
    temp17-height = `26`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `23`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `8`.
    temp17-price = '490.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Laser Allround`.
    temp17-product_id = `HT-1042`.
    temp17-category = `Printers`.
    temp17-main_category = `Printers & Scanners`.
    temp17-supplier_name = `Alpha Printers`.
    temp17-description = `Print up to 25 ppm letter and 24 ppm A4 color or monochrome, with Available first-page-out-time of less than 13 seconds for monochrome and less than 15 seconds for color`.
    temp17-width = `53`.
    temp17-depth = `50`.
    temp17-height = `65`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `17`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `9`.
    temp17-price = '349.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Ultra Jet Super Color`.
    temp17-product_id = `HT-1050`.
    temp17-category = `Printers`.
    temp17-main_category = `Printers & Scanners`.
    temp17-supplier_name = `Alpha Printers`.
    temp17-description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB, Ethernet`.
    temp17-width = `41`.
    temp17-depth = `41`.
    temp17-height = `28`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `3`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `17`.
    temp17-price = '139.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Ultra Jet Mobile`.
    temp17-product_id = `HT-1051`.
    temp17-category = `Printers`.
    temp17-main_category = `Printers & Scanners`.
    temp17-supplier_name = `Printer for All`.
    temp17-description = `1000 dpi x 1000 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB - excellent dimensions for the small office`.
    temp17-width = `46`.
    temp17-depth = `32`.
    temp17-height = `25`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `1.9`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `18`.
    temp17-price = '99.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Ultra Jet Super Highspeed`.
    temp17-product_id = `HT-1052`.
    temp17-category = `Printers`.
    temp17-main_category = `Printers & Scanners`.
    temp17-supplier_name = `Printer for All`.
    temp17-description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB2.0, Ethernet`.
    temp17-width = `41`.
    temp17-depth = `41`.
    temp17-height = `28`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `18`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `25`.
    temp17-price = '170.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Multi Print`.
    temp17-product_id = `HT-1055`.
    temp17-category = `Multifunction Printers`.
    temp17-main_category = `Printers & Scanners`.
    temp17-supplier_name = `Printer for All`.
    temp17-description = `1000 dpi x 1000 dpi - up to 16 ppm (mono) / up to 15 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 1200dpi x 2400dpi)`.
    temp17-width = `55`.
    temp17-depth = `45`.
    temp17-height = `29`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `6.3`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `16`.
    temp17-price = '99.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Multi Color`.
    temp17-product_id = `HT-1056`.
    temp17-category = `Multifunction Printers`.
    temp17-main_category = `Printers & Scanners`.
    temp17-supplier_name = `Printer for All`.
    temp17-description = `1200 dpi x 1200 dpi - up to 25 ppm (mono) / up to 24 ppm (color)- capacity 80 sheets - scanner (216 x 297 mm, 2400dpi x 4800dpi, high resolution)`.
    temp17-width = `51`.
    temp17-depth = `41.3`.
    temp17-height = `22`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `4.3`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `5`.
    temp17-price = '119.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Cordless Mouse`.
    temp17-product_id = `HT-1060`.
    temp17-category = `Mice`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Oxynum`.
    temp17-description = `Cordless Optical USB Mice, Laptop, Color: Black, Plug&Play`.
    temp17-width = `6`.
    temp17-depth = `14.5`.
    temp17-height = `3.5`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.09`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `25`.
    temp17-price = '9.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Speed Mouse`.
    temp17-product_id = `HT-1061`.
    temp17-category = `Mice`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Oxynum`.
    temp17-description = `Optical USB, PS/2 Mouse, Color: Blue, 3-button-functionality (incl. Scroll wheel)`.
    temp17-width = `7`.
    temp17-depth = `15`.
    temp17-height = `3.1`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.09`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `12`.
    temp17-price = '7.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Track Mouse`.
    temp17-product_id = `HT-1062`.
    temp17-category = `Mice`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Oxynum`.
    temp17-description = `Optical USB Mouse, Color: Red, 5-button-functionality(incl. Scroll wheel), Plug&Play`.
    temp17-width = `3`.
    temp17-depth = `7`.
    temp17-height = `4`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.03`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `12`.
    temp17-price = '11.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Ergonomic Keyboard`.
    temp17-product_id = `HT-1063`.
    temp17-category = `Keyboards`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Oxynum`.
    temp17-description = `Ergonomic USB Keyboard for Desktop, Plug&Play`.
    temp17-width = `50`.
    temp17-depth = `21`.
    temp17-height = `3.5`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `2.1`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `50`.
    temp17-price = '14.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Internet Keyboard`.
    temp17-product_id = `HT-1064`.
    temp17-category = `Keyboards`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Oxynum`.
    temp17-description = `Corded Keyboard with special keys for Internet Usability, USB`.
    temp17-width = `52`.
    temp17-depth = `25`.
    temp17-height = `3`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `1.8`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `35`.
    temp17-price = '16.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Media Keyboard`.
    temp17-product_id = `HT-1065`.
    temp17-category = `Keyboards`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Oxynum`.
    temp17-description = `Corded Ergonomic Keyboard with special keys for Media Usability, USB`.
    temp17-width = `51.4`.
    temp17-depth = `23`.
    temp17-height = `4`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `2.3`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `26`.
    temp17-price = '26.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Mousepad`.
    temp17-product_id = `HT-1066`.
    temp17-category = `Mousepads`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Oxynum`.
    temp17-description = `Nice mouse pad with ITelO Logo`.
    temp17-width = `15`.
    temp17-depth = `6`.
    temp17-height = `0.2`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `80`.
    temp17-weight_unit = `G`.
    temp17-quantity = `12`.
    temp17-price = '6.99'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Ergo Mousepad`.
    temp17-product_id = `HT-1067`.
    temp17-category = `Mousepads`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Oxynum`.
    temp17-description = `Ergonomic mouse pad with ITelO Logo`.
    temp17-width = `15`.
    temp17-depth = `6`.
    temp17-height = `0.2`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `80`.
    temp17-weight_unit = `G`.
    temp17-quantity = `16`.
    temp17-price = '8.99'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Designer Mousepad`.
    temp17-product_id = `HT-1068`.
    temp17-category = `Mousepads`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Fasttech`.
    temp17-description = `ITelO Mousepad Special Edition`.
    temp17-width = `24`.
    temp17-depth = `24`.
    temp17-height = `0.6`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `90`.
    temp17-weight_unit = `G`.
    temp17-quantity = `26`.
    temp17-price = '12.99'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Universal card reader`.
    temp17-product_id = `HT-1069`.
    temp17-category = `Computer System Accessories`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Fasttech`.
    temp17-description = `Universal card reader`.
    temp17-width = `6`.
    temp17-depth = `6`.
    temp17-height = `3`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `45`.
    temp17-weight_unit = `G`.
    temp17-quantity = `22`.
    temp17-price = '14.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Proctra X`.
    temp17-product_id = `HT-1070`.
    temp17-category = `Graphic Cards`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Ultrasonic United`.
    temp17-description = `Proctra X: PCI-E GDDR5 3072MB`.
    temp17-width = `22`.
    temp17-depth = `35`.
    temp17-height = `17`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.255`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `15`.
    temp17-price = '70.90'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Gladiator MX`.
    temp17-product_id = `HT-1071`.
    temp17-category = `Graphic Cards`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Ultrasonic United`.
    temp17-description = `Gladiator XLN: PCI-E GDDR5 3072MB DVI Out, TV Out low-noise`.
    temp17-width = `22`.
    temp17-depth = `35`.
    temp17-height = `17`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.3`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `16`.
    temp17-price = '81.70'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Hurricane GX`.
    temp17-product_id = `HT-1072`.
    temp17-category = `Graphic Cards`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Ultrasonic United`.
    temp17-description = `Hurricane GX: PCI-E 691 GFLOPS game-optimized`.
    temp17-width = `22`.
    temp17-depth = `35`.
    temp17-height = `17`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.4`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `13`.
    temp17-price = '101.20'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Hurricane GX/LN`.
    temp17-product_id = `HT-1073`.
    temp17-category = `Graphic Cards`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Smartcards`.
    temp17-description = `Hurricane GX/LN: PCI-E 691 GFLOPS game-optimized, low-noise.`.
    temp17-width = `22`.
    temp17-depth = `35`.
    temp17-height = `17`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.4`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `5`.
    temp17-price = '139.99'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Photo Scan`.
    temp17-product_id = `HT-1080`.
    temp17-category = `Scanners`.
    temp17-main_category = `Printers & Scanners`.
    temp17-supplier_name = `Printer for All`.
    temp17-description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - Hi-Speed USB - Bluetooth`.
    temp17-width = `34`.
    temp17-depth = `48`.
    temp17-height = `5`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `2.3`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `8`.
    temp17-price = '129.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Power Scan`.
    temp17-product_id = `HT-1081`.
    temp17-category = `Scanners`.
    temp17-main_category = `Printers & Scanners`.
    temp17-supplier_name = `Printer for All`.
    temp17-description = `Flatbed scanner - 9.600 × 9.600 dpi - 216 x 297 mm - SCSI for backward compatibility`.
    temp17-width = `31`.
    temp17-depth = `43`.
    temp17-height = `7`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `2.4`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `11`.
    temp17-price = '89.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Jet Scan Professional`.
    temp17-product_id = `HT-1082`.
    temp17-category = `Scanners`.
    temp17-main_category = `Printers & Scanners`.
    temp17-supplier_name = `Printer for All`.
    temp17-description = `Flatbed scanner - Letter - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module`.
    temp17-width = `33`.
    temp17-depth = `41`.
    temp17-height = `12`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `3.2`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `13`.
    temp17-price = '169.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Jet Scan Professional`.
    temp17-product_id = `HT-1083`.
    temp17-category = `Scanners`.
    temp17-main_category = `Printers & Scanners`.
    temp17-supplier_name = `Printer for All`.
    temp17-description = `Flatbed scanner - A4 - 2400 dpi x 2400 dpi - 216 x 297 mm - add-on module`.
    temp17-width = `35`.
    temp17-depth = `40`.
    temp17-height = `10`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `3.2`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `10`.
    temp17-price = '189.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Copymaster`.
    temp17-product_id = `HT-1085`.
    temp17-category = `Multifunction Printers`.
    temp17-main_category = `Printers & Scanners`.
    temp17-supplier_name = `Alpha Printers`.
    temp17-description = `Copymaster`.
    temp17-width = `45`.
    temp17-depth = `42`.
    temp17-height = `22`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `23.2`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `10`.
    temp17-price = '1499.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Surround Sound`.
    temp17-product_id = `HT-1090`.
    temp17-category = `Speakers`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Speaker Experts`.
    temp17-description = `PC multimedia speakers - 5 Watt (Total)`.
    temp17-width = `12`.
    temp17-depth = `10`.
    temp17-height = `16`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `3`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `20`.
    temp17-price = '39.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Blaster Extreme`.
    temp17-product_id = `HT-1091`.
    temp17-category = `Speakers`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Speaker Experts`.
    temp17-description = `PC multimedia speakers - 10 Watt (Total) - 2-way`.
    temp17-width = `13`.
    temp17-depth = `11`.
    temp17-height = `17.5`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `1.4`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `15`.
    temp17-price = '26.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Sound Booster`.
    temp17-product_id = `HT-1092`.
    temp17-category = `Speakers`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Speaker Experts`.
    temp17-description = `PC multimedia speakers - optimized for Blutooth/A2DP`.
    temp17-width = `12.4`.
    temp17-depth = `10.4`.
    temp17-height = `18.1`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `2.1`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `50`.
    temp17-price = '45.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Lovely Sound 5.1 Wireless`.
    temp17-product_id = `HT-1095`.
    temp17-category = `Accessories`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Fasttech`.
    temp17-description = `5.1 Headset, 40 Hz-20 kHz, Wireless`.
    temp17-width = `24`.
    temp17-depth = `19`.
    temp17-height = `23`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `80`.
    temp17-weight_unit = `G`.
    temp17-quantity = `12`.
    temp17-price = '49.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Lovely Sound 5.1`.
    temp17-product_id = `HT-1096`.
    temp17-category = `Accessories`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Fasttech`.
    temp17-description = `5.1 Headset, 40 Hz-20 kHz, 3m cable`.
    temp17-width = `25`.
    temp17-depth = `17`.
    temp17-height = `19`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `130`.
    temp17-weight_unit = `G`.
    temp17-quantity = `18`.
    temp17-price = '39.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Lovely Sound Stereo`.
    temp17-product_id = `HT-1097`.
    temp17-category = `Accessories`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Fasttech`.
    temp17-description = `5.1 Headset, 40 Hz-20 kHz, 1m cable`.
    temp17-width = `21.3`.
    temp17-depth = `2.4`.
    temp17-height = `19.7`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `60`.
    temp17-weight_unit = `G`.
    temp17-quantity = `21`.
    temp17-price = '29.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Smart Office`.
    temp17-product_id = `HT-1100`.
    temp17-category = `Software`.
    temp17-main_category = `Software`.
    temp17-supplier_name = `Technocom`.
    temp17-description = `Complete package, 1 User, Office Applications (word processing, spreadsheet, presentations)`.
    temp17-width = `15`.
    temp17-depth = `6.5`.
    temp17-height = `2.1`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `1.2`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `25`.
    temp17-price = '89.90'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Smart Design`.
    temp17-product_id = `HT-1101`.
    temp17-category = `Software`.
    temp17-main_category = `Software`.
    temp17-supplier_name = `Technocom`.
    temp17-description = `Complete package, 1 User, Image editing, processing`.
    temp17-width = `14`.
    temp17-depth = `6.7`.
    temp17-height = `24`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.8`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `26`.
    temp17-price = '79.90'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Smart Network`.
    temp17-product_id = `HT-1102`.
    temp17-category = `Software`.
    temp17-main_category = `Software`.
    temp17-supplier_name = `Technocom`.
    temp17-description = `Complete package, 1 User, Network Software Utilities, Useful Applications and Documentation`.
    temp17-width = `16`.
    temp17-depth = `6`.
    temp17-height = `27`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.8`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `28`.
    temp17-price = '69.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Smart Multimedia`.
    temp17-product_id = `HT-1103`.
    temp17-category = `Software`.
    temp17-main_category = `Software`.
    temp17-supplier_name = `Technocom`.
    temp17-description = `Complete package, 1 User, different Multimedia applications, playing music, watching DVDs, only with this Smart package`.
    temp17-width = `11`.
    temp17-depth = `3.4`.
    temp17-height = `22`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.8`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `9`.
    temp17-price = '77.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Smart Games`.
    temp17-product_id = `HT-1104`.
    temp17-category = `Software`.
    temp17-main_category = `Software`.
    temp17-supplier_name = `Technocom`.
    temp17-description = `Complete package, 1 User, various games for amusement, logic, action, jump&run`.
    temp17-width = `10`.
    temp17-depth = `3`.
    temp17-height = `30`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `1.1`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `13`.
    temp17-price = '55.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Smart Internet Antivirus`.
    temp17-product_id = `HT-1105`.
    temp17-category = `Software`.
    temp17-main_category = `Software`.
    temp17-supplier_name = `Brainsoft`.
    temp17-description = `Complete package, 1 User, highly recommended for internet users as anti-virus protection`.
    temp17-width = `16`.
    temp17-depth = `4`.
    temp17-height = `21`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.7`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `17`.
    temp17-price = '29.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Smart Firewall`.
    temp17-product_id = `HT-1106`.
    temp17-category = `Software`.
    temp17-main_category = `Software`.
    temp17-supplier_name = `Brainsoft`.
    temp17-description = `Complete package, 1 User, recommended for internet users, protect your PC against cyber-crime`.
    temp17-width = `17.9`.
    temp17-depth = `4.2`.
    temp17-height = `23.1`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.9`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `19`.
    temp17-price = '34.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Smart Money`.
    temp17-product_id = `HT-1107`.
    temp17-category = `Software`.
    temp17-main_category = `Software`.
    temp17-supplier_name = `Brainsoft`.
    temp17-description = `Complete package, 1 User, bring your money in your mind, see what you have and what you want`.
    temp17-width = `12`.
    temp17-depth = `1.5`.
    temp17-height = `19`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.5`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `18`.
    temp17-price = '29.90'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `PC Lock`.
    temp17-product_id = `HT-1110`.
    temp17-category = `Computer System Accessories`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Red Point Stores`.
    temp17-description = `Robust 3m anti-burglary protection for your laptop computer`.
    temp17-width = `20`.
    temp17-depth = `8`.
    temp17-height = `4.3`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.03`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `14`.
    temp17-price = '8.90'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Notebook Lock`.
    temp17-product_id = `HT-1111`.
    temp17-category = `Computer System Accessories`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Red Point Stores`.
    temp17-description = `Robust 1m anti-burglary protection for your desktop computer`.
    temp17-width = `31`.
    temp17-depth = `9`.
    temp17-height = `7`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.02`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `20`.
    temp17-price = '6.90'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Web cam reality`.
    temp17-product_id = `HT-1112`.
    temp17-category = `Computer System Accessories`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Red Point Stores`.
    temp17-description = `Color webcam, color, High-Speed USB`.
    temp17-width = `9`.
    temp17-depth = `8.2`.
    temp17-height = `1.3`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.075`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `27`.
    temp17-price = '39.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Screen clean`.
    temp17-product_id = `HT-1113`.
    temp17-category = `Computer System Accessories`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Red Point Stores`.
    temp17-description = `10 separately packed screen wipes`.
    temp17-width = `2`.
    temp17-depth = `2`.
    temp17-height = `0.1`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.05`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `17`.
    temp17-price = '2.30'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Fabric bag professional`.
    temp17-product_id = `HT-1114`.
    temp17-category = `Computer System Accessories`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Red Point Stores`.
    temp17-description = `Notebook bag, plenty of room for stationery and writing materials`.
    temp17-width = `42`.
    temp17-depth = `32`.
    temp17-height = `7`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `1.8`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `14`.
    temp17-price = '31.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Wireless DSL Router`.
    temp17-product_id = `HT-1115`.
    temp17-category = `Telecommunications`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Red Point Stores`.
    temp17-description = `Wireless DSL Router (available in blue, black and silver)`.
    temp17-width = `19.3`.
    temp17-depth = `18`.
    temp17-height = `5`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.45`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `16`.
    temp17-price = '49.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Wireless DSL Router / Repeater`.
    temp17-product_id = `HT-1116`.
    temp17-category = `Telecommunications`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Red Point Stores`.
    temp17-description = `Wireless DSL Router / Repeater (available in blue, black and silver)`.
    temp17-width = `19.3`.
    temp17-depth = `18`.
    temp17-height = `5`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.45`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `12`.
    temp17-price = '59.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Wireless DSL Router / Repeater and Print Server`.
    temp17-product_id = `HT-1117`.
    temp17-category = `Telecommunications`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Technocom`.
    temp17-description = `Wireless DSL Router / Repeater and Print Server (available in blue, black and silver)`.
    temp17-width = `19.3`.
    temp17-depth = `18`.
    temp17-height = `5`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.45`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `12`.
    temp17-price = '69.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `USB Stick`.
    temp17-product_id = `HT-1118`.
    temp17-category = `Computer System Accessories`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Technocom`.
    temp17-description = `USB 2.0 High-Speed 64 GB`.
    temp17-width = `1.5`.
    temp17-depth = `8.7`.
    temp17-height = `1.2`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.015`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `14`.
    temp17-price = '35.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Travel Adapter`.
    temp17-product_id = `HT-1119`.
    temp17-category = `Accessories`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Titanium`.
    temp17-description = `Universal Travel Adapter`.
    temp17-width = `2`.
    temp17-depth = `3.1`.
    temp17-height = `3.9`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `88`.
    temp17-weight_unit = `G`.
    temp17-quantity = `10`.
    temp17-price = '79.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Cordless Bluetooth Keyboard, english international`.
    temp17-product_id = `HT-1120`.
    temp17-category = `Keyboards`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Technocom`.
    temp17-description = `Cordless Bluetooth Keyboard with English keys`.
    temp17-width = `51.4`.
    temp17-depth = `23`.
    temp17-height = `4`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `1`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `13`.
    temp17-price = '29.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Flat XXL`.
    temp17-product_id = `HT-1137`.
    temp17-category = `Flat Screen Monitors`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Technocom`.
    temp17-description = `Optimum Hi-Resolution max. 2048 × 1536 @ 85Hz, Dot Pitch: 0.24mm`.
    temp17-width = `54`.
    temp17-depth = `22`.
    temp17-height = `38`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `18`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `10`.
    temp17-price = '1430.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Pocket Mouse`.
    temp17-product_id = `HT-1138`.
    temp17-category = `Mice`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Technocom`.
    temp17-description = `Portable pocket Mouse with retracting cord`.
    temp17-width = `0.3`.
    temp17-depth = `0.5`.
    temp17-height = `1`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.02`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `20`.
    temp17-price = '23.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `PC Power Station`.
    temp17-product_id = `HT-1210`.
    temp17-category = `PCs`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Technocom`.
    temp17-description = `PC Power Station with 3,4 Ghz quad-core, 32 GB DDR3 SDRAM, feels like Available PC, Windows 8 Pro`.
    temp17-width = `28`.
    temp17-depth = `31`.
    temp17-height = `43`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `2.3`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `22`.
    temp17-price = '2399.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Astro Laptop 1516`.
    temp17-product_id = `HT-1251`.
    temp17-category = `Laptops`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Ultrasonic United`.
    temp17-description = `Flexible Laptop with 2,5 GHz Quad Core, 15" HD TN, 16 GB DDR SDRAM, 256 GB SSD, Windows 10 Pro`.
    temp17-width = `30`.
    temp17-depth = `18`.
    temp17-height = `3`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `4.2`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `23`.
    temp17-price = '989.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Astro Phone 6`.
    temp17-product_id = `HT-1252`.
    temp17-category = `Smartphones and Tablets`.
    temp17-main_category = `Smartphones & Tablets`.
    temp17-supplier_name = `Ultrasonic United`.
    temp17-description = `6 inch 1280x800 HD display (216 ppi), Quad-core processor, 8 GB internal storage (actual formatted capacity will be less), 3050 mAh battery (Up to 8 hours of active use), grey or black`.
    temp17-width = `8`.
    temp17-depth = `6`.
    temp17-height = `1.5`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.75`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `28`.
    temp17-price = '649.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Benda Laptop 1408`.
    temp17-product_id = `HT-1253`.
    temp17-category = `Laptops`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Ultrasonic United`.
    temp17-description = `Flexible Laptop with 2,5 GHz Dual Core, 14" HD+ TN, 8 GB DDR SDRAM, 324 GB SSD, Windows 10 Pro`.
    temp17-width = `30`.
    temp17-depth = `18`.
    temp17-height = `3`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `4.2`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `27`.
    temp17-price = '976.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Bending Screen 21HD`.
    temp17-product_id = `HT-1254`.
    temp17-category = `Flat Screens`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Ultrasonic United`.
    temp17-description = `Optimum Hi-Resolution Widescreen max. 1920 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub`.
    temp17-width = `37`.
    temp17-depth = `12`.
    temp17-height = `36`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `15`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `23`.
    temp17-price = '250.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Broad Screen 22HD`.
    temp17-product_id = `HT-1255`.
    temp17-category = `Flat Screens`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Ultrasonic United`.
    temp17-description = `Optimum Hi-Resolution Widescreen max. 2048 x 1080 @ 85Hz, Dot Pitch: 0.27mm, HDMI, Discontinued-Sub`.
    temp17-width = `39`.
    temp17-depth = `12`.
    temp17-height = `38`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `16`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `5`.
    temp17-price = '270.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Cerdik Phone 7`.
    temp17-product_id = `HT-1256`.
    temp17-category = `Smartphones and Tablets`.
    temp17-main_category = `Smartphones & Tablets`.
    temp17-supplier_name = `Ultrasonic United`.
    temp17-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black`.
    temp17-width = `9`.
    temp17-depth = `15`.
    temp17-height = `1.5`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.75`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `19`.
    temp17-price = '549.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Cepat Tablet 10.5`.
    temp17-product_id = `HT-1257`.
    temp17-category = `Smartphones and Tablets`.
    temp17-main_category = `Smartphones & Tablets`.
    temp17-supplier_name = `Ultrasonic United`.
    temp17-description = `10.5-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor`.
    temp17-width = `48`.
    temp17-depth = `31`.
    temp17-height = `4.5`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `2.8`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `17`.
    temp17-price = '549.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Cepat Tablet 8`.
    temp17-product_id = `HT-1258`.
    temp17-category = `Smartphones and Tablets`.
    temp17-main_category = `Smartphones & Tablets`.
    temp17-supplier_name = `Ultrasonic United`.
    temp17-description = `8-inch Multitouch HD Screen (2000 x 1500) 32GB Internal Memory, Wireless N Wi-Fi, Bluetooth, GPS Enabled, 1.5 GHz Quad-Core Processor`.
    temp17-width = `38`.
    temp17-depth = `21`.
    temp17-height = `3.5`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `2.5`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `24`.
    temp17-price = '529.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Server Basic`.
    temp17-product_id = `HT-1500`.
    temp17-category = `Servers`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Technocom`.
    temp17-description = `Dual socket, quad-core processing server with 1333 MHz Front Side Bus with 10Gb connectivity`.
    temp17-width = `34`.
    temp17-depth = `35`.
    temp17-height = `23`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `18`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `24`.
    temp17-price = '5000.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Server Professional`.
    temp17-product_id = `HT-1501`.
    temp17-category = `Servers`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Technocom`.
    temp17-description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 10Gb connectivity`.
    temp17-width = `29`.
    temp17-depth = `30`.
    temp17-height = `27`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `25`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `26`.
    temp17-price = '15000.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Server Power Pro`.
    temp17-product_id = `HT-1502`.
    temp17-category = `Servers`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Technocom`.
    temp17-description = `Dual socket, quad-core processing server with 1644 MHz Front Side Bus with 100Gb connectivity`.
    temp17-width = `22`.
    temp17-depth = `27.3`.
    temp17-height = `37`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `35`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `34`.
    temp17-price = '25000.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Family PC Basic`.
    temp17-product_id = `HT-1600`.
    temp17-category = `Desktop Computers`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Titanium`.
    temp17-description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Graphic Card: Proctra X, Windows 8`.
    temp17-width = `21.4`.
    temp17-depth = `29`.
    temp17-height = `38`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `4.8`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `10`.
    temp17-price = '600.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Family PC Pro`.
    temp17-product_id = `HT-1601`.
    temp17-category = `Desktop Computers`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Titanium`.
    temp17-description = `2,8 Ghz dual core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8`.
    temp17-width = `25`.
    temp17-depth = `31.7`.
    temp17-height = `40.2`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `5.3`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `20`.
    temp17-price = '900.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Gaming Monster`.
    temp17-product_id = `HT-1602`.
    temp17-category = `Desktop Computers`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Titanium`.
    temp17-description = `3,4 Ghz quad core, 8 GB DDR3 SDRAM, 2000 GB Hard Disc, Graphic Card: Gladiator MX, Windows 8`.
    temp17-width = `26.5`.
    temp17-depth = `34`.
    temp17-height = `47`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `5.9`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `24`.
    temp17-price = '1200.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Gaming Monster Pro`.
    temp17-product_id = `HT-1603`.
    temp17-category = `Desktop Computers`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Titanium`.
    temp17-description = `3,4 Ghz quad core, 16 GB DDR3 SDRAM, 4000 GB Hard Disc, Graphic Card: Hurricane GX, Windows 8`.
    temp17-width = `27`.
    temp17-depth = `28`.
    temp17-height = `42`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `6.8`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `25`.
    temp17-price = '1700.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `7" Widescreen Portable DVD Player w MP3`.
    temp17-product_id = `HT-2000`.
    temp17-category = `Accessories`.
    temp17-main_category = `TV, Video & HiFi`.
    temp17-supplier_name = `Titanium`.
    temp17-description = `7" LCD Screen, storage battery holds up to 6 hours!`.
    temp17-width = `21.4`.
    temp17-depth = `19`.
    temp17-height = `27.6`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.79`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `20`.
    temp17-price = '249.99'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `10" Portable DVD player`.
    temp17-product_id = `HT-2001`.
    temp17-category = `Accessories`.
    temp17-main_category = `TV, Video & HiFi`.
    temp17-supplier_name = `Titanium`.
    temp17-description = `10" LCD Screen, storage battery holds up to 8 hours`.
    temp17-width = `24`.
    temp17-depth = `19.5`.
    temp17-height = `29`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.84`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `21`.
    temp17-price = '449.99'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Portable DVD Player with 9" LCD Monitor`.
    temp17-product_id = `HT-2002`.
    temp17-category = `Accessories`.
    temp17-main_category = `TV, Video & HiFi`.
    temp17-supplier_name = `Technocom`.
    temp17-description = `9" LCD Screen, storage holds up to 8 hours, 2 speakers included`.
    temp17-width = `21`.
    temp17-depth = `16.5`.
    temp17-height = `14`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.72`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `50`.
    temp17-price = '853.99'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `CD/DVD case: 264 sleeves`.
    temp17-product_id = `HT-2025`.
    temp17-category = `Accessories`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Titanium`.
    temp17-description = `Organizer and protective case for 264 CDs and DVDs`.
    temp17-width = `13`.
    temp17-depth = `13`.
    temp17-height = `20`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.65`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `26`.
    temp17-price = '44.99'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Audio/Video Cable Kit - 4m`.
    temp17-product_id = `HT-2026`.
    temp17-category = `Accessories`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Titanium`.
    temp17-description = `Quality cables for notebooks and projectors`.
    temp17-width = `21`.
    temp17-depth = `10.2`.
    temp17-height = `13`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.2`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `16`.
    temp17-price = '29.99'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Removable CD/DVD Laser Labels`.
    temp17-product_id = `HT-2027`.
    temp17-category = `Accessories`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Titanium`.
    temp17-description = `Removable jewel case labels, zero residues (100)`.
    temp17-width = `5.5`.
    temp17-depth = `2`.
    temp17-height = `2`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.15`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `25`.
    temp17-price = '8.99'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Beam Breaker B-1`.
    temp17-product_id = `HT-6100`.
    temp17-category = `Accessories`.
    temp17-main_category = `TV, Video & HiFi`.
    temp17-supplier_name = `Titanium`.
    temp17-description = `720p, DLP Projector max. 8,45 Meter, 2D`.
    temp17-width = `30.4`.
    temp17-depth = `23.1`.
    temp17-height = `23`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `1.7`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `32`.
    temp17-price = '469.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Beam Breaker B-2`.
    temp17-product_id = `HT-6101`.
    temp17-category = `Accessories`.
    temp17-main_category = `TV, Video & HiFi`.
    temp17-supplier_name = `Technocom`.
    temp17-description = `1080p, DLP max.9,34 Meter, 2D-ready`.
    temp17-width = `30.4`.
    temp17-depth = `23.1`.
    temp17-height = `23`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `2`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `18`.
    temp17-price = '679.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Beam Breaker B-3`.
    temp17-product_id = `HT-6102`.
    temp17-category = `Accessories`.
    temp17-main_category = `TV, Video & HiFi`.
    temp17-supplier_name = `Technocom`.
    temp17-description = `1080p, DLP max. 12,3 Meter, 3D-ready`.
    temp17-width = `30.4`.
    temp17-depth = `23.1`.
    temp17-height = `23`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `2.5`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `16`.
    temp17-price = '889.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Play Movie`.
    temp17-product_id = `HT-6110`.
    temp17-category = `Accessories`.
    temp17-main_category = `TV, Video & HiFi`.
    temp17-supplier_name = `Fasttech`.
    temp17-description = `CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid`.
    temp17-width = `37`.
    temp17-depth = `24`.
    temp17-height = `6`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `2.4`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `15`.
    temp17-price = '130.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Record Movie`.
    temp17-product_id = `HT-6111`.
    temp17-category = `Accessories`.
    temp17-main_category = `TV, Video & HiFi`.
    temp17-supplier_name = `Fasttech`.
    temp17-description = `160 GB HDD, CD-RW, DVD+R/RW, DVD-R/RW, MPEG 2 (Video-DVD), MPEG 4, VCD, SVCD, DivX, Xvid`.
    temp17-width = `38`.
    temp17-depth = `26`.
    temp17-height = `6.2`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `3.1`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `24`.
    temp17-price = '288.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `ITelo MusicStick`.
    temp17-product_id = `HT-6120`.
    temp17-category = `Accessories`.
    temp17-main_category = `TV, Video & HiFi`.
    temp17-supplier_name = `Fasttech`.
    temp17-description = `64 GB USB Music-on-Available-Stick`.
    temp17-width = `1.5`.
    temp17-depth = `6`.
    temp17-height = `1`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `134`.
    temp17-weight_unit = `G`.
    temp17-quantity = `15`.
    temp17-price = '45.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `ITelo Jog-Mate`.
    temp17-product_id = `HT-6121`.
    temp17-category = `Accessories`.
    temp17-main_category = `TV, Video & HiFi`.
    temp17-supplier_name = `Fasttech`.
    temp17-description = `ITelo Jog-Mate 64 GB HDD and Color Display, can play movies`.
    temp17-width = `5.1`.
    temp17-depth = `8`.
    temp17-height = `9.2`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `134`.
    temp17-weight_unit = `G`.
    temp17-quantity = `24`.
    temp17-price = '63.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Power Pro Player 40`.
    temp17-product_id = `HT-6122`.
    temp17-category = `Accessories`.
    temp17-main_category = `TV, Video & HiFi`.
    temp17-supplier_name = `Fasttech`.
    temp17-description = `MP3-Player with 40 GB HDD and Color Display, can play movies`.
    temp17-width = `5.1`.
    temp17-depth = `8`.
    temp17-height = `9.2`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `266`.
    temp17-weight_unit = `G`.
    temp17-quantity = `23`.
    temp17-price = '167.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Power Pro Player 80`.
    temp17-product_id = `HT-6123`.
    temp17-category = `Accessories`.
    temp17-main_category = `TV, Video & HiFi`.
    temp17-supplier_name = `Fasttech`.
    temp17-description = `MP3-Player with 80 GB SSD and Color Display, can play movies`.
    temp17-width = `4`.
    temp17-depth = `6`.
    temp17-height = `0.8`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `267`.
    temp17-weight_unit = `G`.
    temp17-quantity = `13`.
    temp17-price = '299.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Flat Watch HD32`.
    temp17-product_id = `HT-6130`.
    temp17-category = `Flat Screen TVs`.
    temp17-main_category = `TV, Video & HiFi`.
    temp17-supplier_name = `Very Best Screens`.
    temp17-description = `32-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    temp17-width = `78`.
    temp17-depth = `22.1`.
    temp17-height = `55`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `2.6`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `16`.
    temp17-price = '1459.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Flat Watch HD37`.
    temp17-product_id = `HT-6131`.
    temp17-category = `Flat Screen TVs`.
    temp17-main_category = `TV, Video & HiFi`.
    temp17-supplier_name = `Very Best Screens`.
    temp17-description = `37-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    temp17-width = `99.1`.
    temp17-depth = `26`.
    temp17-height = `61`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `2.2`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `14`.
    temp17-price = '1199.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Flat Watch HD41`.
    temp17-product_id = `HT-6132`.
    temp17-category = `Flat Screen TVs`.
    temp17-main_category = `TV, Video & HiFi`.
    temp17-supplier_name = `Very Best Screens`.
    temp17-description = `41-inch, 1366x768 Pixel, 16:9, HDTV ready`.
    temp17-width = `128`.
    temp17-depth = `23`.
    temp17-height = `79.1`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `1.8`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `13`.
    temp17-price = '899.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Copperberry`.
    temp17-product_id = `HT-7000`.
    temp17-category = `Accessories`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Fasttech`.
    temp17-description = `Our new multifunctional Handheld with phone function in copper`.
    temp17-width = `8.1`.
    temp17-depth = `13`.
    temp17-height = `12.1`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.5`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `5`.
    temp17-price = '549.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Silverberry`.
    temp17-product_id = `HT-7010`.
    temp17-category = `Accessories`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Fasttech`.
    temp17-description = `Our new multifunctional Handheld with phone function in silver`.
    temp17-width = `8.1`.
    temp17-depth = `13`.
    temp17-height = `12.1`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.5`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `9`.
    temp17-price = '549.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Goldberry`.
    temp17-product_id = `HT-7020`.
    temp17-category = `Accessories`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Fasttech`.
    temp17-description = `Our new multifunctional Handheld with phone function in gold`.
    temp17-width = `8.1`.
    temp17-depth = `13`.
    temp17-height = `12.1`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.5`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `11`.
    temp17-price = '549.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Platinberry`.
    temp17-product_id = `HT-7030`.
    temp17-category = `Accessories`.
    temp17-main_category = `Computer Components`.
    temp17-supplier_name = `Fasttech`.
    temp17-description = `Our new multifunctional Handheld with phone function in platinum`.
    temp17-width = `8.1`.
    temp17-depth = `13`.
    temp17-height = `12.1`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.5`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `12`.
    temp17-price = '549.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `ITelO FlexTop I4000`.
    temp17-product_id = `HT-8000`.
    temp17-category = `Laptops`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Titanium`.
    temp17-description = `Notebook with 2,80 GHz dual core, 4 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8`.
    temp17-width = `31`.
    temp17-depth = `19`.
    temp17-height = `3.1`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `4`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `11`.
    temp17-price = '799.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `ITelO FlexTop I6300c`.
    temp17-product_id = `HT-8001`.
    temp17-category = `Laptops`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Titanium`.
    temp17-description = `Notebook with 2,80 GHz dual core, 8 GB DDR3 SDRAM, 500 GB Hard Disc, Windows 8`.
    temp17-width = `32`.
    temp17-depth = `20`.
    temp17-height = `3.4`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `4.2`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `20`.
    temp17-price = '799.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `ITelO FlexTop I9100`.
    temp17-product_id = `HT-8002`.
    temp17-category = `Laptops`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Titanium`.
    temp17-description = `Notebook with 2,80 GHz quad core, 4 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8`.
    temp17-width = `38`.
    temp17-depth = `21`.
    temp17-height = `4.1`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `3.5`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `20`.
    temp17-price = '1199.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `ITelO FlexTop I9800`.
    temp17-product_id = `HT-8003`.
    temp17-category = `Laptops`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Titanium`.
    temp17-description = `Notebook with 2,80 GHz quad core, 8 GB DDR3 SDRAM, 1000 GB Hard Disc, Windows 8`.
    temp17-width = `48`.
    temp17-depth = `31`.
    temp17-height = `4.5`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `3.8`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `22`.
    temp17-price = '1388.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Smartphone Leather Case`.
    temp17-product_id = `HT-9991`.
    temp17-category = `Accessories`.
    temp17-main_category = `Smartphones & Tablets`.
    temp17-supplier_name = `Ultrasonic United`.
    temp17-description = `Button Clasp, Quality Material, 100% Leather, compatible with many smartphone models`.
    temp17-width = `48`.
    temp17-depth = `31`.
    temp17-height = `4.5`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.02`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `12`.
    temp17-price = '25.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Smartphone Alpha`.
    temp17-product_id = `HT-9992`.
    temp17-category = `Smartphones and Tablets`.
    temp17-main_category = `Smartphones & Tablets`.
    temp17-supplier_name = `Ultrasonic United`.
    temp17-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage (actual formatted capacity will be less), 4325 mAh battery (Up to 8 hours of active use), white or black`.
    temp17-width = `48`.
    temp17-depth = `31`.
    temp17-height = `4.5`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.75`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `13`.
    temp17-price = '599.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Mini Tablet`.
    temp17-product_id = `HT-9993`.
    temp17-category = `Smartphones and Tablets`.
    temp17-main_category = `Smartphones & Tablets`.
    temp17-supplier_name = `Ultrasonic United`.
    temp17-description = `7 inch 1280x800 HD display (216 ppi), Quad-core processor, 16 GB internal storage, 4325 mAh battery (Up to 8 hours of active use)`.
    temp17-width = `48`.
    temp17-depth = `31`.
    temp17-height = `4.5`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `3.8`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `10`.
    temp17-price = '833.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Camcorder View`.
    temp17-product_id = `HT-9994`.
    temp17-category = `Accessories`.
    temp17-main_category = `TV, Video & HiFi`.
    temp17-supplier_name = `Ultrasonic United`.
    temp17-description = `1920x1080 Full HD, image stabilization reduces blur, 27x Optical / 32x Extended Zoom, wide angle Lens, 2.7" wide LCD display`.
    temp17-width = `48`.
    temp17-depth = `31`.
    temp17-height = `27`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `3.8`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `50`.
    temp17-price = '1388.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Tablet Pouch`.
    temp17-product_id = `HT-9995`.
    temp17-category = `Accessories`.
    temp17-main_category = `Smartphones & Tablets`.
    temp17-supplier_name = `Titanium`.
    temp17-description = `Stylish tablet pouch, protects from scratches, color: black`.
    temp17-width = `25`.
    temp17-depth = `40`.
    temp17-height = `4.5`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.03`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `34`.
    temp17-price = '20.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Tablet Pouch`.
    temp17-product_id = `HT-9996`.
    temp17-category = `Accessories`.
    temp17-main_category = `Smartphones & Tablets`.
    temp17-supplier_name = `Titanium`.
    temp17-description = `Stylish tablet pouch, protects from scratches, color: black`.
    temp17-width = `25`.
    temp17-depth = `40`.
    temp17-height = `4.5`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.03`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `34`.
    temp17-price = '20.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `e-Book Reader ReadMe`.
    temp17-product_id = `HT-9997`.
    temp17-category = `Smartphones and Tablets`.
    temp17-main_category = `Smartphones & Tablets`.
    temp17-supplier_name = `Titanium`.
    temp17-description = `6-Inch E Ink Screen, Access To e-book Store, Adjustable Font Styles and Sizes, Stores Up To 1,000 Books`.
    temp17-width = `48`.
    temp17-depth = `31`.
    temp17-height = `4.5`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `3.8`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `23`.
    temp17-price = '33.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Smartphone Beta`.
    temp17-product_id = `HT-9998`.
    temp17-category = `Smartphones and Tablets`.
    temp17-main_category = `Smartphones & Tablets`.
    temp17-supplier_name = `Titanium`.
    temp17-description = `5 Megapixel Camera, Wi-Fi 802.11 b/g/n, Bluetooth, GPS Available-GPS support`.
    temp17-width = `48`.
    temp17-depth = `31`.
    temp17-height = `4.5`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.75`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `21`.
    temp17-price = '30.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Maxi Tablet`.
    temp17-product_id = `HT-9999`.
    temp17-category = `Tablets`.
    temp17-main_category = `Smartphones & Tablets`.
    temp17-supplier_name = `Titanium`.
    temp17-description = `10.1-inch Multitouch HD Screen (1280 x 800), 16GB Internal Memory, Wireless N Wi-Fi; Bluetooth, GPS Enabled, 1GHz Dual-Core Processor`.
    temp17-width = `48`.
    temp17-depth = `31`.
    temp17-height = `4.5`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `3.8`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `20`.
    temp17-price = '749.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    temp17-name = `Flyer`.
    temp17-product_id = `PF-1000`.
    temp17-category = `Accessories`.
    temp17-main_category = `Computer Systems`.
    temp17-supplier_name = `Titanium`.
    temp17-description = `Flyer for our product palette`.
    temp17-width = `46`.
    temp17-depth = `30`.
    temp17-height = `3`.
    temp17-dim_unit = `cm`.
    temp17-weight_measure = `0.01`.
    temp17-weight_unit = `KG`.
    temp17-quantity = `33`.
    temp17-price = '0.00'.
    temp17-currency_code = `EUR`.
    INSERT temp17 INTO TABLE temp16.
    t_products = temp16.

    " ProductPicUrl is derivable from the product id (the mock's
    " test-resources/.../<id>.jpg), built from a shared base pointing at the
    " OpenUI5 host (like app 006's image flattening)
    
    
    LOOP AT t_products REFERENCE INTO lr_product.
      lr_product->product_pic_url = |{ c_img_base }{ lr_product->product_id }.jpg|.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
