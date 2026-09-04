" @keywords table sap.m tableeditable overflowtoolbar toolbarspacer button overflowtoolbarlayoutdata title column text columnlistitem input
" @summary Table with edit/display togglable scenario.
CLASS z2ui5_cl_smpc_app_570 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             productid     TYPE string,
             name          TYPE string,
             quantity      TYPE string,
             uom           TYPE string,
             weightmeasure TYPE string,
             weightunit    TYPE string,
             " Formatter.weightState, computed in the backend (thin frontend)
             weight_state  TYPE string,
             price         TYPE p LENGTH 9 DECIMALS 2,
             " PRICE stays packed for the read-only template's Currency composite
             " binding, so the EDITABLE cell binds this string mirror instead. A
             " packed cell cannot take the write-back: delta_apply_field ends in
             " CATCH cx_root ##NO_HANDLER ("skip just this cell"), so 1,250.00 was
             " dropped with no error and a lone - or a cleared cell became 0.00
             " (both measured). A string cell always arrives, and SAVE parses it
             price_text    TYPE string,
             currencycode  TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    DATA t_products TYPE ty_t_product.
    " onEdit keeps a deepExtend copy so onCancel can put it back
    DATA t_backup   TYPE ty_t_product.
    DATA edit_mode  TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_570 IMPLEMENTATION.

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
    DATA temp1 TYPE string_table.
    DATA temp3 TYPE string_table.
    DATA cells TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    page = view->ele( n = `View` ns = `mvc`
        )->a( n = `height`    v = `100%`
        )->a( n = `xmlns`     v = `sap.m`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`

        )->ele( `Page`
            )->a( n = `showHeader`      v = `false`
            )->a( n = `enableScrolling` v = `true`
            )->a( n = `class`           v = `sapUiContentPadding`
            )->a( n = `showNavButton`   v = `false` ).

    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `Order button pressed` INTO TABLE temp1.
    page->ele( `footer`
        )->ele( `OverflowToolbar`
            )->a( n = `id` v = `otbFooter`

            )->tag( `ToolbarSpacer`
            )->ele( `Button`
                )->a( n = `text`  v = `Order`
                " onOrder shows a static toast - composed on the client
                )->a( n = `press` v = client->follow_up_action(
                          val   = client->cs_event-control_global
                          t_arg = temp1 )

                )->ele( `layoutData`
                    )->tag( `OverflowToolbarLayoutData`
                        )->a( n = `priority` v = `NeverOverflow`

                )->end(
            )->end(
        )->end(
    )->end( ).

    
    CLEAR temp3.
    INSERT `MESSAGE_TOAST` INTO TABLE temp3.
    INSERT `show` INTO TABLE temp3.
    INSERT `Pasted Data: {0}` INTO TABLE temp3.
    INSERT `${$parameters>/data}` INTO TABLE temp3.
    
    cells = page->ele( `content`
        )->ele( `Table`
            )->a( n = `id`               v = `idProductsTable`
            )->a( n = `growing`          v = `true`
            )->a( n = `growingThreshold` v = `10`
            )->a( n = `items`            v = client->_bind( t_products )
            " onPaste toasts the pasted data - composed on the client
            )->a( n = `paste`            v = client->follow_up_action(
                      val   = client->cs_event-control_global
                      t_arg = temp3 )

            )->ele( `headerToolbar`
                )->ele( `OverflowToolbar`
                    )->a( n = `id` v = `otbSubheader`

                    )->tag( `Title`
                        )->a( n = `text`  v = `Products`
                        )->a( n = `level` v = `H2`
                    )->tag( `ToolbarSpacer`
                    )->tag( `Button`
                        )->a( n = `id`      v = `editButton`
                        )->a( n = `text`    v = `Edit`
                        )->a( n = `type`    v = `Transparent`
                        )->a( n = `visible` v = |\{= !$\{{ client->_bind_path( edit_mode ) }\} \}|
                        )->a( n = `press`   v = client->_event( `EDIT` )
                    )->tag( `Button`
                        )->a( n = `id`      v = `saveButton`
                        )->a( n = `text`    v = `Save`
                        )->a( n = `type`    v = `Transparent`
                        )->a( n = `visible` v = client->_bind( edit_mode )
                        )->a( n = `press`   v = client->_event( `SAVE` )
                    )->tag( `Button`
                        )->a( n = `id`      v = `cancelButton`
                        )->a( n = `text`    v = `Cancel`
                        )->a( n = `type`    v = `Transparent`
                        )->a( n = `visible` v = client->_bind( edit_mode )
                        )->a( n = `press`   v = client->_event( `CANCEL` )

                )->end(
            )->end(
            )->ele( `columns`
                )->ele( `Column`
                    )->a( n = `width` v = `12em`

                    )->tag( `Text`
                        )->a( n = `text` v = `Product`

                )->end(
                )->ele( `Column`
                    )->a( n = `minScreenWidth` v = `Tablet`
                    )->a( n = `demandPopin`    v = `true`
                    )->a( n = `hAlign`         v = `End`

                    )->tag( `Text`
                        )->a( n = `text` v = `Quantity`

                )->end(
                )->ele( `Column`
                    )->a( n = `minScreenWidth` v = `Tablet`
                    )->a( n = `demandPopin`    v = `true`
                    )->a( n = `hAlign`         v = `Center`

                    )->tag( `Text`
                        )->a( n = `text` v = `Weight`

                )->end(
                )->ele( `Column`
                    )->a( n = `hAlign` v = `End`

                    )->tag( `Text`
                        )->a( n = `text` v = `Price`

                )->end(
            )->end(
            )->ele( `items`
                )->ele( `ColumnListItem`
                    )->a( n = `vAlign` v = `Middle`

                    )->ele( `cells` ).

    " onEdit / onSave / onCancel rebind the SAME table between a read-only and an
    " editable ColumnListItem template. abap2UI5 rebuilds the view per round trip,
    " so the two templates are the two branches below
    IF edit_mode = abap_true.
      cells->tag( `Input`
          )->a( n = `value` v = `{NAME}`
          )->tag( `Input`
              )->a( n = `value`       v = `{QUANTITY}`
              )->a( n = `description` v = `{UOM}`
          )->tag( `Input`
              )->a( n = `value`       v = `{WEIGHTMEASURE}`
              )->a( n = `description` v = `{WEIGHTUNIT}`
          )->tag( `Input`
              )->a( n = `value`       v = `{PRICE_TEXT}`
              )->a( n = `description` v = `{CURRENCYCODE}` ).
    ELSE.
      cells->tag( `ObjectIdentifier`
          )->a( n = `title` v = `{NAME}`
          )->a( n = `text`  v = `{PRODUCTID}`
          )->tag( `ObjectNumber`
              )->a( n = `number` v = |\{ path:'QUANTITY', type: 'sap.ui.model.type.String', formatOptions: \{showMeasure: false\} \}|
              )->a( n = `unit`   v = `{UOM}`
          )->tag( `ObjectNumber`
              )->a( n = `number` v = `{WEIGHTMEASURE}`
              )->a( n = `unit`   v = `{WEIGHTUNIT}`
              )->a( n = `state`  v = `{WEIGHT_STATE}`
          )->tag( `ObjectNumber`
              )->a( n = `number` v = |\{ parts:[\{path:'PRICE'\},\{path:'CURRENCYCODE'\}], type:'sap.ui.model.type.Currency', formatOptions:\{showMeasure:false\} \}|
              )->a( n = `unit`   v = `{CURRENCYCODE}` ).
    ENDIF.

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    " the first row SAVE could not parse, if any - see the SAVE branch
    DATA lv_bad TYPE string.
        DATA temp5 LIKE LINE OF t_products.
        DATA lr_seed LIKE REF TO temp5.
        DATA temp6 LIKE LINE OF t_products.
        DATA lr_prod LIKE REF TO temp6.
          DATA lv_txt TYPE string.
          DATA lv_ok TYPE abap_bool.
          DATA temp1 TYPE xsdboolean.

    CASE client->get_event( ).

      WHEN `EDIT`.
        " onEdit: seed the string mirror from the packed price, keep a copy for
        " Cancel, then rebind to the editable template
        
        
        LOOP AT t_products REFERENCE INTO lr_seed.
          lr_seed->price_text = |{ lr_seed->price }|.
        ENDLOOP.
        t_backup = t_products.
        edit_mode = abap_true.
        view_display( ).

      WHEN `SAVE`.
        " the typed text always reaches the backend now, so SAVE - not the
        " framework - decides. A cell that does not convert keeps its old price,
        " its text is put back from that price, and the app STAYS in edit mode
        " with a toast: the entry is never discarded behind the user's back
        
        
        LOOP AT t_products REFERENCE INTO lr_prod.
          
          lv_txt = condense( lr_prod->price_text ).
          " three terms, not just the character one: CA demands a real digit so a
          " lone `-` or `.` cannot reach the assignment (it used to land as 0.00),
          " and the length term keeps a long digit run from overflowing the target
          
          
          temp1 = boolc( lv_txt IS NOT INITIAL AND lv_txt CO `0123456789.-` AND lv_txt CA `0123456789` AND strlen( lv_txt ) <= 15 ).
          lv_ok = temp1.
          IF lv_ok = abap_true.
            TRY.
                lr_prod->price = lv_txt.
              CATCH cx_root.
                lv_ok = abap_false.
            ENDTRY.
          ENDIF.
          IF lv_ok = abap_false AND lv_bad IS INITIAL.
            lv_bad = |{ lr_prod->name }: '{ lv_txt }'|.
          ENDIF.
          lr_prod->price_text = |{ lr_prod->price }|.
        ENDLOOP.
        IF lv_bad IS INITIAL.
          edit_mode = abap_false.
        ELSE.
          client->message_toast_display( |Not a number, the old price was kept - { lv_bad }| ).
        ENDIF.
        view_display( ).

      WHEN `CANCEL`.
        " onCancel: put the copy back
        t_products = t_backup.
        edit_mode = abap_false.
        view_display( ).

    ENDCASE.

  ENDMETHOD.


  METHOD model_init.

    " the full mock /ProductCollection
    DATA temp7 TYPE z2ui5_cl_smpc_app_570=>ty_t_product.
    DATA temp8 LIKE LINE OF temp7.
    CLEAR temp7.
    
    temp8-productid = `HT-1000`.
    temp8-name = `Notebook Basic 15`.
    temp8-quantity = `10`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `4.2`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `956`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1001`.
    temp8-name = `Notebook Basic 17`.
    temp8-quantity = `20`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `4.5`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `1249`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1002`.
    temp8-name = `Notebook Basic 18`.
    temp8-quantity = `10`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `4.2`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `1570`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1003`.
    temp8-name = `Notebook Basic 19`.
    temp8-quantity = `15`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `4.2`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `1650`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1007`.
    temp8-name = `ITelO Vault`.
    temp8-quantity = `15`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.2`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `299`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1010`.
    temp8-name = `Notebook Professional 15`.
    temp8-quantity = `16`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `4.3`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `1999`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1011`.
    temp8-name = `Notebook Professional 17`.
    temp8-quantity = `17`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `4.1`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `2299`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1020`.
    temp8-name = `ITelO Vault Net`.
    temp8-quantity = `14`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.16`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `459`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1021`.
    temp8-name = `ITelO Vault SAT`.
    temp8-quantity = `50`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.18`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `149`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1022`.
    temp8-name = `Comfort Easy`.
    temp8-quantity = `30`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.2`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `1679`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1023`.
    temp8-name = `Comfort Senior`.
    temp8-quantity = `24`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.8`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `512`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1030`.
    temp8-name = `Ergo Screen E-I`.
    temp8-quantity = `14`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `21`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `230`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1031`.
    temp8-name = `Ergo Screen E-II`.
    temp8-quantity = `24`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `21`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `285`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1032`.
    temp8-name = `Ergo Screen E-III`.
    temp8-quantity = `50`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `21`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `345`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1035`.
    temp8-name = `Flat Basic`.
    temp8-quantity = `23`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `14`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `399`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1036`.
    temp8-name = `Flat Future`.
    temp8-quantity = `22`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `15`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `430`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1037`.
    temp8-name = `Flat XL`.
    temp8-quantity = `23`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `17`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `1230`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1040`.
    temp8-name = `Laser Professional Eco`.
    temp8-quantity = `21`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `32`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `830`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1041`.
    temp8-name = `Laser Basic`.
    temp8-quantity = `8`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `23`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `490`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1042`.
    temp8-name = `Laser Allround`.
    temp8-quantity = `9`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `17`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `349`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1050`.
    temp8-name = `Ultra Jet Super Color`.
    temp8-quantity = `17`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `3`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `139`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1051`.
    temp8-name = `Ultra Jet Mobile`.
    temp8-quantity = `18`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `1.9`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `99`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1052`.
    temp8-name = `Ultra Jet Super Highspeed`.
    temp8-quantity = `25`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `18`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `170`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1055`.
    temp8-name = `Multi Print`.
    temp8-quantity = `16`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `6.3`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `99`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1056`.
    temp8-name = `Multi Color`.
    temp8-quantity = `5`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `4.3`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `119`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1060`.
    temp8-name = `Cordless Mouse`.
    temp8-quantity = `25`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.09`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `9`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1061`.
    temp8-name = `Speed Mouse`.
    temp8-quantity = `12`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.09`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `7`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1062`.
    temp8-name = `Track Mouse`.
    temp8-quantity = `12`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.03`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `11`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1063`.
    temp8-name = `Ergonomic Keyboard`.
    temp8-quantity = `50`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `2.1`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `14`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1064`.
    temp8-name = `Internet Keyboard`.
    temp8-quantity = `35`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `1.8`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `16`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1065`.
    temp8-name = `Media Keyboard`.
    temp8-quantity = `26`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `2.3`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `26`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1066`.
    temp8-name = `Mousepad`.
    temp8-quantity = `12`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `80`.
    temp8-weightunit = `G`.
    temp8-weight_state = `Success`.
    temp8-price = `6.99`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1067`.
    temp8-name = `Ergo Mousepad`.
    temp8-quantity = `16`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `80`.
    temp8-weightunit = `G`.
    temp8-weight_state = `Success`.
    temp8-price = `8.99`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1068`.
    temp8-name = `Designer Mousepad`.
    temp8-quantity = `26`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `90`.
    temp8-weightunit = `G`.
    temp8-weight_state = `Success`.
    temp8-price = `12.99`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1069`.
    temp8-name = `Universal card reader`.
    temp8-quantity = `22`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `45`.
    temp8-weightunit = `G`.
    temp8-weight_state = `Success`.
    temp8-price = `14`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1070`.
    temp8-name = `Proctra X`.
    temp8-quantity = `15`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.255`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `70.9`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1071`.
    temp8-name = `Gladiator MX`.
    temp8-quantity = `16`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.3`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `81.7`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1072`.
    temp8-name = `Hurricane GX`.
    temp8-quantity = `13`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.4`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `101.2`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1073`.
    temp8-name = `Hurricane GX/LN`.
    temp8-quantity = `5`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.4`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `139.99`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1080`.
    temp8-name = `Photo Scan`.
    temp8-quantity = `8`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `2.3`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `129`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1081`.
    temp8-name = `Power Scan`.
    temp8-quantity = `11`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `2.4`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `89`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1082`.
    temp8-name = `Jet Scan Professional`.
    temp8-quantity = `13`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `3.2`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `169`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1083`.
    temp8-name = `Jet Scan Professional`.
    temp8-quantity = `10`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `3.2`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `189`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1085`.
    temp8-name = `Copymaster`.
    temp8-quantity = `10`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `23.2`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `1499`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1090`.
    temp8-name = `Surround Sound`.
    temp8-quantity = `20`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `3`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `39`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1091`.
    temp8-name = `Blaster Extreme`.
    temp8-quantity = `15`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `1.4`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `26`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1092`.
    temp8-name = `Sound Booster`.
    temp8-quantity = `50`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `2.1`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `45`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1095`.
    temp8-name = `Lovely Sound 5.1 Wireless`.
    temp8-quantity = `12`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `80`.
    temp8-weightunit = `G`.
    temp8-weight_state = `Success`.
    temp8-price = `49`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1096`.
    temp8-name = `Lovely Sound 5.1`.
    temp8-quantity = `18`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `130`.
    temp8-weightunit = `G`.
    temp8-weight_state = `Success`.
    temp8-price = `39`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1097`.
    temp8-name = `Lovely Sound Stereo`.
    temp8-quantity = `21`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `60`.
    temp8-weightunit = `G`.
    temp8-weight_state = `Success`.
    temp8-price = `29`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1100`.
    temp8-name = `Smart Office`.
    temp8-quantity = `25`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `1.2`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `89.9`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1101`.
    temp8-name = `Smart Design`.
    temp8-quantity = `26`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.8`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `79.9`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1102`.
    temp8-name = `Smart Network`.
    temp8-quantity = `28`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.8`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `69`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1103`.
    temp8-name = `Smart Multimedia`.
    temp8-quantity = `9`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.8`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `77`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1104`.
    temp8-name = `Smart Games`.
    temp8-quantity = `13`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `1.1`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `55`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1105`.
    temp8-name = `Smart Internet Antivirus`.
    temp8-quantity = `17`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.7`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `29`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1106`.
    temp8-name = `Smart Firewall`.
    temp8-quantity = `19`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.9`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `34`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1107`.
    temp8-name = `Smart Money`.
    temp8-quantity = `18`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.5`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `29.9`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1110`.
    temp8-name = `PC Lock`.
    temp8-quantity = `14`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.03`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `8.9`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1111`.
    temp8-name = `Notebook Lock`.
    temp8-quantity = `20`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.02`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `6.9`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1112`.
    temp8-name = `Web cam reality`.
    temp8-quantity = `27`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.075`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `39`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1113`.
    temp8-name = `Screen clean`.
    temp8-quantity = `17`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.05`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `2.3`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1114`.
    temp8-name = `Fabric bag professional`.
    temp8-quantity = `14`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `1.8`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `31`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1115`.
    temp8-name = `Wireless DSL Router`.
    temp8-quantity = `16`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.45`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `49`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1116`.
    temp8-name = `Wireless DSL Router / Repeater`.
    temp8-quantity = `12`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.45`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `59`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1117`.
    temp8-name = `Wireless DSL Router / Repeater and Print Server`.
    temp8-quantity = `12`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.45`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `69`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1118`.
    temp8-name = `USB Stick`.
    temp8-quantity = `14`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.015`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `35`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1119`.
    temp8-name = `Travel Adapter`.
    temp8-quantity = `10`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `88`.
    temp8-weightunit = `G`.
    temp8-weight_state = `Success`.
    temp8-price = `79`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1120`.
    temp8-name = `Cordless Bluetooth Keyboard, english international`.
    temp8-quantity = `13`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `1`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `29`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1137`.
    temp8-name = `Flat XXL`.
    temp8-quantity = `10`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `18`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `1430`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1138`.
    temp8-name = `Pocket Mouse`.
    temp8-quantity = `20`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.02`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `23`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1210`.
    temp8-name = `PC Power Station`.
    temp8-quantity = `22`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `2.3`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `2399`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1251`.
    temp8-name = `Astro Laptop 1516`.
    temp8-quantity = `23`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `4.2`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `989`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1252`.
    temp8-name = `Astro Phone 6`.
    temp8-quantity = `28`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.75`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `649`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1253`.
    temp8-name = `Benda Laptop 1408`.
    temp8-quantity = `27`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `4.2`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `976`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1254`.
    temp8-name = `Bending Screen 21HD`.
    temp8-quantity = `23`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `15`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `250`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1255`.
    temp8-name = `Broad Screen 22HD`.
    temp8-quantity = `5`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `16`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `270`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1256`.
    temp8-name = `Cerdik Phone 7`.
    temp8-quantity = `19`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.75`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `549`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1257`.
    temp8-name = `Cepat Tablet 10.5`.
    temp8-quantity = `17`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `2.8`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `549`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1258`.
    temp8-name = `Cepat Tablet 8`.
    temp8-quantity = `24`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `2.5`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `529`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1500`.
    temp8-name = `Server Basic`.
    temp8-quantity = `24`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `18`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `5000`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1501`.
    temp8-name = `Server Professional`.
    temp8-quantity = `26`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `25`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `15000`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1502`.
    temp8-name = `Server Power Pro`.
    temp8-quantity = `34`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `35`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `25000`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1600`.
    temp8-name = `Family PC Basic`.
    temp8-quantity = `10`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `4.8`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `600`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1601`.
    temp8-name = `Family PC Pro`.
    temp8-quantity = `20`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `5.3`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `900`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1602`.
    temp8-name = `Gaming Monster`.
    temp8-quantity = `24`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `5.9`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `1200`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-1603`.
    temp8-name = `Gaming Monster Pro`.
    temp8-quantity = `25`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `6.8`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `1700`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-2000`.
    temp8-name = `7" Widescreen Portable DVD Player w MP3`.
    temp8-quantity = `20`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.79`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `249.99`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-2001`.
    temp8-name = `10" Portable DVD player`.
    temp8-quantity = `21`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.84`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `449.99`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-2002`.
    temp8-name = `Portable DVD Player with 9" LCD Monitor`.
    temp8-quantity = `50`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.72`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `853.99`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-2025`.
    temp8-name = `CD/DVD case: 264 sleeves`.
    temp8-quantity = `26`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.65`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `44.99`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-2026`.
    temp8-name = `Audio/Video Cable Kit - 4m`.
    temp8-quantity = `16`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.2`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `29.99`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-2027`.
    temp8-name = `Removable CD/DVD Laser Labels`.
    temp8-quantity = `25`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.15`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `8.99`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6100`.
    temp8-name = `Beam Breaker B-1`.
    temp8-quantity = `32`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `1.7`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `469`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6101`.
    temp8-name = `Beam Breaker B-2`.
    temp8-quantity = `18`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `2`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `679`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6102`.
    temp8-name = `Beam Breaker B-3`.
    temp8-quantity = `16`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `2.5`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `889`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6110`.
    temp8-name = `Play Movie`.
    temp8-quantity = `15`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `2.4`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `130`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6111`.
    temp8-name = `Record Movie`.
    temp8-quantity = `24`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `3.1`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `288`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6120`.
    temp8-name = `ITelo MusicStick`.
    temp8-quantity = `15`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `134`.
    temp8-weightunit = `G`.
    temp8-weight_state = `Success`.
    temp8-price = `45`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6121`.
    temp8-name = `ITelo Jog-Mate`.
    temp8-quantity = `24`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `134`.
    temp8-weightunit = `G`.
    temp8-weight_state = `Success`.
    temp8-price = `63`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6122`.
    temp8-name = `Power Pro Player 40`.
    temp8-quantity = `23`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `266`.
    temp8-weightunit = `G`.
    temp8-weight_state = `Success`.
    temp8-price = `167`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6123`.
    temp8-name = `Power Pro Player 80`.
    temp8-quantity = `13`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `267`.
    temp8-weightunit = `G`.
    temp8-weight_state = `Success`.
    temp8-price = `299`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6130`.
    temp8-name = `Flat Watch HD32`.
    temp8-quantity = `16`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `2.6`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `1459`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6131`.
    temp8-name = `Flat Watch HD37`.
    temp8-quantity = `14`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `2.2`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `1199`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-6132`.
    temp8-name = `Flat Watch HD41`.
    temp8-quantity = `13`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `1.8`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `899`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-7000`.
    temp8-name = `Copperberry`.
    temp8-quantity = `5`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.5`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `549`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-7010`.
    temp8-name = `Silverberry`.
    temp8-quantity = `9`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.5`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `549`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-7020`.
    temp8-name = `Goldberry`.
    temp8-quantity = `11`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.5`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `549`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-7030`.
    temp8-name = `Platinberry`.
    temp8-quantity = `12`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.5`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `549`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-8000`.
    temp8-name = `ITelO FlexTop I4000`.
    temp8-quantity = `11`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `4`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `799`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-8001`.
    temp8-name = `ITelO FlexTop I6300c`.
    temp8-quantity = `20`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `4.2`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `799`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-8002`.
    temp8-name = `ITelO FlexTop I9100`.
    temp8-quantity = `20`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `3.5`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `1199`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-8003`.
    temp8-name = `ITelO FlexTop I9800`.
    temp8-quantity = `22`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `3.8`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `1388`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-9991`.
    temp8-name = `Smartphone Leather Case`.
    temp8-quantity = `12`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.02`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `25`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-9992`.
    temp8-name = `Smartphone Alpha`.
    temp8-quantity = `13`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.75`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `599`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-9993`.
    temp8-name = `Mini Tablet`.
    temp8-quantity = `10`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `3.8`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `833`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-9994`.
    temp8-name = `Camcorder View`.
    temp8-quantity = `50`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `3.8`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `1388`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-9995`.
    temp8-name = `Tablet Pouch`.
    temp8-quantity = `34`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.03`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `20`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-9996`.
    temp8-name = `Tablet Pouch`.
    temp8-quantity = `34`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.03`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `20`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-9997`.
    temp8-name = `e-Book Reader ReadMe`.
    temp8-quantity = `23`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `3.8`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `33`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-9998`.
    temp8-name = `Smartphone Beta`.
    temp8-quantity = `21`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.75`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `30`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `HT-9999`.
    temp8-name = `Maxi Tablet`.
    temp8-quantity = `20`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `3.8`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `749`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    temp8-productid = `PF-1000`.
    temp8-name = `Flyer`.
    temp8-quantity = `33`.
    temp8-uom = `PC`.
    temp8-weightmeasure = `0.01`.
    temp8-weightunit = `KG`.
    temp8-weight_state = `Success`.
    temp8-price = `0`.
    temp8-currencycode = `EUR`.
    INSERT temp8 INTO TABLE temp7.
    t_products = temp7.

  ENDMETHOD.

ENDCLASS.
