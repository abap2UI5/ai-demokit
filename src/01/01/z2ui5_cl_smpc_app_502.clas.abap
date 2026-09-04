" @keywords objectheader object header sap.m objectheadertitlesel objectattribute responsivepopover list standardlistitem
" @summary This is a Object Header with a title selection. This can be used to switch between variants of the business object being shown.
CLASS z2ui5_cl_smpc_app_502 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name          TYPE string,
             price         TYPE p LENGTH 8 DECIMALS 2,
             currencycode  TYPE string,
             weightmeasure TYPE string,
             weightunit    TYPE string,
             width         TYPE string,
             depth         TYPE string,
             height        TYPE string,
             dimunit       TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.

    DATA t_products TYPE ty_t_product.
    " the record the header shows - the original moves the ObjectHeader's binding
    " context to the selected row instead
    DATA sel_name          TYPE string.
    DATA sel_price         TYPE p LENGTH 8 DECIMALS 2.
    DATA sel_currencycode  TYPE string.
    DATA sel_weightmeasure TYPE string.
    DATA sel_weightunit    TYPE string.
    DATA sel_width         TYPE string.
    DATA sel_depth         TYPE string.
    DATA sel_height        TYPE string.
    DATA sel_dimunit       TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_502 IMPLEMENTATION.

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
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `myPopover` INTO TABLE temp1.
    INSERT `openBy` INTO TABLE temp1.
    INSERT `$event.oSource.sId` INTO TABLE temp1.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc` v = `sap.ui.core.mvc`
        )->a( n = `xmlns`     v = `sap.m`

        )->ele( `ObjectHeader`
            )->a( n = `id`                 v = `idObjectHeader`
            )->a( n = `title`              v = client->_bind( sel_name )
            )->a( n = `showTitleSelector`  v = `true`
            " handleTitleSelectorPress loads Popover.fragment.xml and opens it by the
            " selector's domRef - the same popover is declared in dependents and opened
            " anchored to the pressed control
            )->a( n = `titleSelectorPress` v = client->follow_up_action( val   = client->cs_event-control_by_id
                                                                         t_arg = temp1 )
            )->a( n = `number`             v = |\{ parts:[\{path:'{ client->_bind_path( sel_price ) }'\},| &&
                                                |\{path:'{ client->_bind_path( sel_currencycode ) }'\}],| &&
                                                | type: 'sap.ui.model.type.Currency', formatOptions: \{showMeasure: false\} \}|
            )->a( n = `numberUnit`         v = client->_bind( sel_currencycode )
            )->a( n = `class`              v = `sapUiResponsivePadding--header`

            )->tag( `ObjectAttribute`
                )->a( n = `text` v = |{ client->_bind( sel_weightmeasure ) } { client->_bind( sel_weightunit ) }|
            )->tag( `ObjectAttribute`
                )->a( n = `text` v = |{ client->_bind( sel_width ) } x { client->_bind( sel_depth ) } x { client->_bind( sel_height ) } { client->_bind( sel_dimunit ) }|

            )->ele( `dependents`
                )->ele( `ResponsivePopover`
                    )->a( n = `id`        v = `myPopover`
                    )->a( n = `title`     v = `Select Product`
                    )->a( n = `placement` v = `Bottom`

                    )->ele( `List`
                        )->a( n = `mode`                   v = `SingleSelectMaster`
                        )->a( n = `includeItemInSelection` v = `true`
                        " handleItemSelect moves the header to the picked row and closes
                        " the popover - the row name travels, ABAP copies the record
                        )->a( n = `selectionChange`        v = client->_event( val = `ITEM_SELECT` arg = `${$parameters>/listItem}.getTitle()` )
                        )->a( n = `items`                  v = client->_bind( t_products )

                        )->tag( `StandardListItem`
                            )->a( n = `title` v = `{NAME}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
      DATA title TYPE string.
      DATA product TYPE z2ui5_cl_smpc_app_502=>ty_s_product.
      DATA temp3 TYPE string_table.

    IF client->get_event( ) = `ITEM_SELECT`.

      
      title = client->get_event_arg( ).
      
      READ TABLE t_products INTO product WITH KEY name = title.
      IF sy-subrc = 0.
        sel_name          = product-name.
        sel_price         = product-price.
        sel_currencycode  = product-currencycode.
        sel_weightmeasure = product-weightmeasure.
        sel_weightunit    = product-weightunit.
        sel_width         = product-width.
        sel_depth         = product-depth.
        sel_height        = product-height.
        sel_dimunit       = product-dimunit.
      ENDIF.

      " the original closes the popover from the same handler
      
      CLEAR temp3.
      INSERT `myPopover` INTO TABLE temp3.
      INSERT `close` INTO TABLE temp3.
      client->follow_up_action( val   = client->cs_event-control_by_id
                                t_arg = temp3 ).

    ENDIF.

  ENDMETHOD.


  METHOD model_init.

    " full mock /ProductCollection of ui5/mock/products.json (the bound fields)
    DATA temp5 TYPE z2ui5_cl_smpc_app_502=>ty_t_product.
    DATA temp6 LIKE LINE OF temp5.
    DATA first LIKE LINE OF t_products.
    DATA temp1 LIKE LINE OF t_products.
    DATA temp2 LIKE sy-tabix.
    CLEAR temp5.
    
    temp6-name = `Notebook Basic 15`.
    temp6-price = `956`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `4.2`.
    temp6-weightunit = `KG`.
    temp6-width = `30`.
    temp6-depth = `18`.
    temp6-height = `3`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Notebook Basic 17`.
    temp6-price = `1249`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `4.5`.
    temp6-weightunit = `KG`.
    temp6-width = `29`.
    temp6-depth = `17`.
    temp6-height = `3.1`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Notebook Basic 18`.
    temp6-price = `1570`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `4.2`.
    temp6-weightunit = `KG`.
    temp6-width = `28`.
    temp6-depth = `19`.
    temp6-height = `2.5`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Notebook Basic 19`.
    temp6-price = `1650`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `4.2`.
    temp6-weightunit = `KG`.
    temp6-width = `32`.
    temp6-depth = `21`.
    temp6-height = `4`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `ITelO Vault`.
    temp6-price = `299`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.2`.
    temp6-weightunit = `KG`.
    temp6-width = `32`.
    temp6-depth = `22`.
    temp6-height = `3`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Notebook Professional 15`.
    temp6-price = `1999`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `4.3`.
    temp6-weightunit = `KG`.
    temp6-width = `33`.
    temp6-depth = `20`.
    temp6-height = `3`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Notebook Professional 17`.
    temp6-price = `2299`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `4.1`.
    temp6-weightunit = `KG`.
    temp6-width = `33`.
    temp6-depth = `23`.
    temp6-height = `2`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `ITelO Vault Net`.
    temp6-price = `459`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.16`.
    temp6-weightunit = `KG`.
    temp6-width = `10`.
    temp6-depth = `1.8`.
    temp6-height = `17`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `ITelO Vault SAT`.
    temp6-price = `149`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.18`.
    temp6-weightunit = `KG`.
    temp6-width = `11`.
    temp6-depth = `1.7`.
    temp6-height = `18`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Comfort Easy`.
    temp6-price = `1679`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.2`.
    temp6-weightunit = `KG`.
    temp6-width = `84`.
    temp6-depth = `1.5`.
    temp6-height = `14`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Comfort Senior`.
    temp6-price = `512`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.8`.
    temp6-weightunit = `KG`.
    temp6-width = `80`.
    temp6-depth = `1.6`.
    temp6-height = `13`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Ergo Screen E-I`.
    temp6-price = `230`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `21`.
    temp6-weightunit = `KG`.
    temp6-width = `37`.
    temp6-depth = `12`.
    temp6-height = `36`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Ergo Screen E-II`.
    temp6-price = `285`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `21`.
    temp6-weightunit = `KG`.
    temp6-width = `40.8`.
    temp6-depth = `19`.
    temp6-height = `43`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Ergo Screen E-III`.
    temp6-price = `345`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `21`.
    temp6-weightunit = `KG`.
    temp6-width = `40.8`.
    temp6-depth = `19`.
    temp6-height = `43`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Flat Basic`.
    temp6-price = `399`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `14`.
    temp6-weightunit = `KG`.
    temp6-width = `39`.
    temp6-depth = `20`.
    temp6-height = `41`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Flat Future`.
    temp6-price = `430`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `15`.
    temp6-weightunit = `KG`.
    temp6-width = `45`.
    temp6-depth = `26`.
    temp6-height = `46`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Flat XL`.
    temp6-price = `1230`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `17`.
    temp6-weightunit = `KG`.
    temp6-width = `54.5`.
    temp6-depth = `22.1`.
    temp6-height = `39.1`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Laser Professional Eco`.
    temp6-price = `830`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `32`.
    temp6-weightunit = `KG`.
    temp6-width = `51`.
    temp6-depth = `46`.
    temp6-height = `30`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Laser Basic`.
    temp6-price = `490`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `23`.
    temp6-weightunit = `KG`.
    temp6-width = `48`.
    temp6-depth = `42`.
    temp6-height = `26`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Laser Allround`.
    temp6-price = `349`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `17`.
    temp6-weightunit = `KG`.
    temp6-width = `53`.
    temp6-depth = `50`.
    temp6-height = `65`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Ultra Jet Super Color`.
    temp6-price = `139`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `3`.
    temp6-weightunit = `KG`.
    temp6-width = `41`.
    temp6-depth = `41`.
    temp6-height = `28`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Ultra Jet Mobile`.
    temp6-price = `99`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `1.9`.
    temp6-weightunit = `KG`.
    temp6-width = `46`.
    temp6-depth = `32`.
    temp6-height = `25`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Ultra Jet Super Highspeed`.
    temp6-price = `170`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `18`.
    temp6-weightunit = `KG`.
    temp6-width = `41`.
    temp6-depth = `41`.
    temp6-height = `28`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Multi Print`.
    temp6-price = `99`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `6.3`.
    temp6-weightunit = `KG`.
    temp6-width = `55`.
    temp6-depth = `45`.
    temp6-height = `29`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Multi Color`.
    temp6-price = `119`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `4.3`.
    temp6-weightunit = `KG`.
    temp6-width = `51`.
    temp6-depth = `41.3`.
    temp6-height = `22`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Cordless Mouse`.
    temp6-price = `9`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.09`.
    temp6-weightunit = `KG`.
    temp6-width = `6`.
    temp6-depth = `14.5`.
    temp6-height = `3.5`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Speed Mouse`.
    temp6-price = `7`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.09`.
    temp6-weightunit = `KG`.
    temp6-width = `7`.
    temp6-depth = `15`.
    temp6-height = `3.1`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Track Mouse`.
    temp6-price = `11`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.03`.
    temp6-weightunit = `KG`.
    temp6-width = `3`.
    temp6-depth = `7`.
    temp6-height = `4`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Ergonomic Keyboard`.
    temp6-price = `14`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `2.1`.
    temp6-weightunit = `KG`.
    temp6-width = `50`.
    temp6-depth = `21`.
    temp6-height = `3.5`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Internet Keyboard`.
    temp6-price = `16`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `1.8`.
    temp6-weightunit = `KG`.
    temp6-width = `52`.
    temp6-depth = `25`.
    temp6-height = `3`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Media Keyboard`.
    temp6-price = `26`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `2.3`.
    temp6-weightunit = `KG`.
    temp6-width = `51.4`.
    temp6-depth = `23`.
    temp6-height = `4`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Mousepad`.
    temp6-price = `6.99`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `80`.
    temp6-weightunit = `G`.
    temp6-width = `15`.
    temp6-depth = `6`.
    temp6-height = `0.2`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Ergo Mousepad`.
    temp6-price = `8.99`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `80`.
    temp6-weightunit = `G`.
    temp6-width = `15`.
    temp6-depth = `6`.
    temp6-height = `0.2`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Designer Mousepad`.
    temp6-price = `12.99`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `90`.
    temp6-weightunit = `G`.
    temp6-width = `24`.
    temp6-depth = `24`.
    temp6-height = `0.6`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Universal card reader`.
    temp6-price = `14`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `45`.
    temp6-weightunit = `G`.
    temp6-width = `6`.
    temp6-depth = `6`.
    temp6-height = `3`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Proctra X`.
    temp6-price = `70.9`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.255`.
    temp6-weightunit = `KG`.
    temp6-width = `22`.
    temp6-depth = `35`.
    temp6-height = `17`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Gladiator MX`.
    temp6-price = `81.7`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.3`.
    temp6-weightunit = `KG`.
    temp6-width = `22`.
    temp6-depth = `35`.
    temp6-height = `17`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Hurricane GX`.
    temp6-price = `101.2`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.4`.
    temp6-weightunit = `KG`.
    temp6-width = `22`.
    temp6-depth = `35`.
    temp6-height = `17`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Hurricane GX/LN`.
    temp6-price = `139.99`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.4`.
    temp6-weightunit = `KG`.
    temp6-width = `22`.
    temp6-depth = `35`.
    temp6-height = `17`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Photo Scan`.
    temp6-price = `129`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `2.3`.
    temp6-weightunit = `KG`.
    temp6-width = `34`.
    temp6-depth = `48`.
    temp6-height = `5`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Power Scan`.
    temp6-price = `89`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `2.4`.
    temp6-weightunit = `KG`.
    temp6-width = `31`.
    temp6-depth = `43`.
    temp6-height = `7`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Jet Scan Professional`.
    temp6-price = `169`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `3.2`.
    temp6-weightunit = `KG`.
    temp6-width = `33`.
    temp6-depth = `41`.
    temp6-height = `12`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Jet Scan Professional`.
    temp6-price = `189`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `3.2`.
    temp6-weightunit = `KG`.
    temp6-width = `35`.
    temp6-depth = `40`.
    temp6-height = `10`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Copymaster`.
    temp6-price = `1499`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `23.2`.
    temp6-weightunit = `KG`.
    temp6-width = `45`.
    temp6-depth = `42`.
    temp6-height = `22`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Surround Sound`.
    temp6-price = `39`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `3`.
    temp6-weightunit = `KG`.
    temp6-width = `12`.
    temp6-depth = `10`.
    temp6-height = `16`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Blaster Extreme`.
    temp6-price = `26`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `1.4`.
    temp6-weightunit = `KG`.
    temp6-width = `13`.
    temp6-depth = `11`.
    temp6-height = `17.5`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Sound Booster`.
    temp6-price = `45`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `2.1`.
    temp6-weightunit = `KG`.
    temp6-width = `12.4`.
    temp6-depth = `10.4`.
    temp6-height = `18.1`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Lovely Sound 5.1 Wireless`.
    temp6-price = `49`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `80`.
    temp6-weightunit = `G`.
    temp6-width = `24`.
    temp6-depth = `19`.
    temp6-height = `23`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Lovely Sound 5.1`.
    temp6-price = `39`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `130`.
    temp6-weightunit = `G`.
    temp6-width = `25`.
    temp6-depth = `17`.
    temp6-height = `19`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Lovely Sound Stereo`.
    temp6-price = `29`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `60`.
    temp6-weightunit = `G`.
    temp6-width = `21.3`.
    temp6-depth = `2.4`.
    temp6-height = `19.7`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Smart Office`.
    temp6-price = `89.9`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `1.2`.
    temp6-weightunit = `KG`.
    temp6-width = `15`.
    temp6-depth = `6.5`.
    temp6-height = `2.1`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Smart Design`.
    temp6-price = `79.9`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.8`.
    temp6-weightunit = `KG`.
    temp6-width = `14`.
    temp6-depth = `6.7`.
    temp6-height = `24`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Smart Network`.
    temp6-price = `69`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.8`.
    temp6-weightunit = `KG`.
    temp6-width = `16`.
    temp6-depth = `6`.
    temp6-height = `27`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Smart Multimedia`.
    temp6-price = `77`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.8`.
    temp6-weightunit = `KG`.
    temp6-width = `11`.
    temp6-depth = `3.4`.
    temp6-height = `22`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Smart Games`.
    temp6-price = `55`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `1.1`.
    temp6-weightunit = `KG`.
    temp6-width = `10`.
    temp6-depth = `3`.
    temp6-height = `30`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Smart Internet Antivirus`.
    temp6-price = `29`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.7`.
    temp6-weightunit = `KG`.
    temp6-width = `16`.
    temp6-depth = `4`.
    temp6-height = `21`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Smart Firewall`.
    temp6-price = `34`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.9`.
    temp6-weightunit = `KG`.
    temp6-width = `17.9`.
    temp6-depth = `4.2`.
    temp6-height = `23.1`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Smart Money`.
    temp6-price = `29.9`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.5`.
    temp6-weightunit = `KG`.
    temp6-width = `12`.
    temp6-depth = `1.5`.
    temp6-height = `19`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `PC Lock`.
    temp6-price = `8.9`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.03`.
    temp6-weightunit = `KG`.
    temp6-width = `20`.
    temp6-depth = `8`.
    temp6-height = `4.3`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Notebook Lock`.
    temp6-price = `6.9`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.02`.
    temp6-weightunit = `KG`.
    temp6-width = `31`.
    temp6-depth = `9`.
    temp6-height = `7`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Web cam reality`.
    temp6-price = `39`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.075`.
    temp6-weightunit = `KG`.
    temp6-width = `9`.
    temp6-depth = `8.2`.
    temp6-height = `1.3`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Screen clean`.
    temp6-price = `2.3`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.05`.
    temp6-weightunit = `KG`.
    temp6-width = `2`.
    temp6-depth = `2`.
    temp6-height = `0.1`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Fabric bag professional`.
    temp6-price = `31`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `1.8`.
    temp6-weightunit = `KG`.
    temp6-width = `42`.
    temp6-depth = `32`.
    temp6-height = `7`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Wireless DSL Router`.
    temp6-price = `49`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.45`.
    temp6-weightunit = `KG`.
    temp6-width = `19.3`.
    temp6-depth = `18`.
    temp6-height = `5`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Wireless DSL Router / Repeater`.
    temp6-price = `59`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.45`.
    temp6-weightunit = `KG`.
    temp6-width = `19.3`.
    temp6-depth = `18`.
    temp6-height = `5`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Wireless DSL Router / Repeater and Print Server`.
    temp6-price = `69`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.45`.
    temp6-weightunit = `KG`.
    temp6-width = `19.3`.
    temp6-depth = `18`.
    temp6-height = `5`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `USB Stick`.
    temp6-price = `35`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.015`.
    temp6-weightunit = `KG`.
    temp6-width = `1.5`.
    temp6-depth = `8.7`.
    temp6-height = `1.2`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Travel Adapter`.
    temp6-price = `79`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `88`.
    temp6-weightunit = `G`.
    temp6-width = `2`.
    temp6-depth = `3.1`.
    temp6-height = `3.9`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Cordless Bluetooth Keyboard, english international`.
    temp6-price = `29`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `1`.
    temp6-weightunit = `KG`.
    temp6-width = `51.4`.
    temp6-depth = `23`.
    temp6-height = `4`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Flat XXL`.
    temp6-price = `1430`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `18`.
    temp6-weightunit = `KG`.
    temp6-width = `54`.
    temp6-depth = `22`.
    temp6-height = `38`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Pocket Mouse`.
    temp6-price = `23`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.02`.
    temp6-weightunit = `KG`.
    temp6-width = `0.3`.
    temp6-depth = `0.5`.
    temp6-height = `1`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `PC Power Station`.
    temp6-price = `2399`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `2.3`.
    temp6-weightunit = `KG`.
    temp6-width = `28`.
    temp6-depth = `31`.
    temp6-height = `43`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Astro Laptop 1516`.
    temp6-price = `989`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `4.2`.
    temp6-weightunit = `KG`.
    temp6-width = `30`.
    temp6-depth = `18`.
    temp6-height = `3`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Astro Phone 6`.
    temp6-price = `649`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.75`.
    temp6-weightunit = `KG`.
    temp6-width = `8`.
    temp6-depth = `6`.
    temp6-height = `1.5`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Benda Laptop 1408`.
    temp6-price = `976`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `4.2`.
    temp6-weightunit = `KG`.
    temp6-width = `30`.
    temp6-depth = `18`.
    temp6-height = `3`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Bending Screen 21HD`.
    temp6-price = `250`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `15`.
    temp6-weightunit = `KG`.
    temp6-width = `37`.
    temp6-depth = `12`.
    temp6-height = `36`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Broad Screen 22HD`.
    temp6-price = `270`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `16`.
    temp6-weightunit = `KG`.
    temp6-width = `39`.
    temp6-depth = `12`.
    temp6-height = `38`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Cerdik Phone 7`.
    temp6-price = `549`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.75`.
    temp6-weightunit = `KG`.
    temp6-width = `9`.
    temp6-depth = `15`.
    temp6-height = `1.5`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Cepat Tablet 10.5`.
    temp6-price = `549`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `2.8`.
    temp6-weightunit = `KG`.
    temp6-width = `48`.
    temp6-depth = `31`.
    temp6-height = `4.5`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Cepat Tablet 8`.
    temp6-price = `529`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `2.5`.
    temp6-weightunit = `KG`.
    temp6-width = `38`.
    temp6-depth = `21`.
    temp6-height = `3.5`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Server Basic`.
    temp6-price = `5000`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `18`.
    temp6-weightunit = `KG`.
    temp6-width = `34`.
    temp6-depth = `35`.
    temp6-height = `23`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Server Professional`.
    temp6-price = `15000`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `25`.
    temp6-weightunit = `KG`.
    temp6-width = `29`.
    temp6-depth = `30`.
    temp6-height = `27`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Server Power Pro`.
    temp6-price = `25000`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `35`.
    temp6-weightunit = `KG`.
    temp6-width = `22`.
    temp6-depth = `27.3`.
    temp6-height = `37`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Family PC Basic`.
    temp6-price = `600`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `4.8`.
    temp6-weightunit = `KG`.
    temp6-width = `21.4`.
    temp6-depth = `29`.
    temp6-height = `38`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Family PC Pro`.
    temp6-price = `900`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `5.3`.
    temp6-weightunit = `KG`.
    temp6-width = `25`.
    temp6-depth = `31.7`.
    temp6-height = `40.2`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Gaming Monster`.
    temp6-price = `1200`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `5.9`.
    temp6-weightunit = `KG`.
    temp6-width = `26.5`.
    temp6-depth = `34`.
    temp6-height = `47`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Gaming Monster Pro`.
    temp6-price = `1700`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `6.8`.
    temp6-weightunit = `KG`.
    temp6-width = `27`.
    temp6-depth = `28`.
    temp6-height = `42`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `7" Widescreen Portable DVD Player w MP3`.
    temp6-price = `249.99`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.79`.
    temp6-weightunit = `KG`.
    temp6-width = `21.4`.
    temp6-depth = `19`.
    temp6-height = `27.6`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `10" Portable DVD player`.
    temp6-price = `449.99`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.84`.
    temp6-weightunit = `KG`.
    temp6-width = `24`.
    temp6-depth = `19.5`.
    temp6-height = `29`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Portable DVD Player with 9" LCD Monitor`.
    temp6-price = `853.99`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.72`.
    temp6-weightunit = `KG`.
    temp6-width = `21`.
    temp6-depth = `16.5`.
    temp6-height = `14`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `CD/DVD case: 264 sleeves`.
    temp6-price = `44.99`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.65`.
    temp6-weightunit = `KG`.
    temp6-width = `13`.
    temp6-depth = `13`.
    temp6-height = `20`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Audio/Video Cable Kit - 4m`.
    temp6-price = `29.99`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.2`.
    temp6-weightunit = `KG`.
    temp6-width = `21`.
    temp6-depth = `10.2`.
    temp6-height = `13`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Removable CD/DVD Laser Labels`.
    temp6-price = `8.99`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.15`.
    temp6-weightunit = `KG`.
    temp6-width = `5.5`.
    temp6-depth = `2`.
    temp6-height = `2`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Beam Breaker B-1`.
    temp6-price = `469`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `1.7`.
    temp6-weightunit = `KG`.
    temp6-width = `30.4`.
    temp6-depth = `23.1`.
    temp6-height = `23`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Beam Breaker B-2`.
    temp6-price = `679`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `2`.
    temp6-weightunit = `KG`.
    temp6-width = `30.4`.
    temp6-depth = `23.1`.
    temp6-height = `23`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Beam Breaker B-3`.
    temp6-price = `889`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `2.5`.
    temp6-weightunit = `KG`.
    temp6-width = `30.4`.
    temp6-depth = `23.1`.
    temp6-height = `23`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Play Movie`.
    temp6-price = `130`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `2.4`.
    temp6-weightunit = `KG`.
    temp6-width = `37`.
    temp6-depth = `24`.
    temp6-height = `6`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Record Movie`.
    temp6-price = `288`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `3.1`.
    temp6-weightunit = `KG`.
    temp6-width = `38`.
    temp6-depth = `26`.
    temp6-height = `6.2`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `ITelo MusicStick`.
    temp6-price = `45`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `134`.
    temp6-weightunit = `G`.
    temp6-width = `1.5`.
    temp6-depth = `6`.
    temp6-height = `1`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `ITelo Jog-Mate`.
    temp6-price = `63`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `134`.
    temp6-weightunit = `G`.
    temp6-width = `5.1`.
    temp6-depth = `8`.
    temp6-height = `9.2`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Power Pro Player 40`.
    temp6-price = `167`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `266`.
    temp6-weightunit = `G`.
    temp6-width = `5.1`.
    temp6-depth = `8`.
    temp6-height = `9.2`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Power Pro Player 80`.
    temp6-price = `299`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `267`.
    temp6-weightunit = `G`.
    temp6-width = `4`.
    temp6-depth = `6`.
    temp6-height = `0.8`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Flat Watch HD32`.
    temp6-price = `1459`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `2.6`.
    temp6-weightunit = `KG`.
    temp6-width = `78`.
    temp6-depth = `22.1`.
    temp6-height = `55`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Flat Watch HD37`.
    temp6-price = `1199`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `2.2`.
    temp6-weightunit = `KG`.
    temp6-width = `99.1`.
    temp6-depth = `26`.
    temp6-height = `61`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Flat Watch HD41`.
    temp6-price = `899`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `1.8`.
    temp6-weightunit = `KG`.
    temp6-width = `128`.
    temp6-depth = `23`.
    temp6-height = `79.1`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Copperberry`.
    temp6-price = `549`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.5`.
    temp6-weightunit = `KG`.
    temp6-width = `8.1`.
    temp6-depth = `13`.
    temp6-height = `12.1`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Silverberry`.
    temp6-price = `549`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.5`.
    temp6-weightunit = `KG`.
    temp6-width = `8.1`.
    temp6-depth = `13`.
    temp6-height = `12.1`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Goldberry`.
    temp6-price = `549`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.5`.
    temp6-weightunit = `KG`.
    temp6-width = `8.1`.
    temp6-depth = `13`.
    temp6-height = `12.1`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Platinberry`.
    temp6-price = `549`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.5`.
    temp6-weightunit = `KG`.
    temp6-width = `8.1`.
    temp6-depth = `13`.
    temp6-height = `12.1`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `ITelO FlexTop I4000`.
    temp6-price = `799`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `4`.
    temp6-weightunit = `KG`.
    temp6-width = `31`.
    temp6-depth = `19`.
    temp6-height = `3.1`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `ITelO FlexTop I6300c`.
    temp6-price = `799`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `4.2`.
    temp6-weightunit = `KG`.
    temp6-width = `32`.
    temp6-depth = `20`.
    temp6-height = `3.4`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `ITelO FlexTop I9100`.
    temp6-price = `1199`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `3.5`.
    temp6-weightunit = `KG`.
    temp6-width = `38`.
    temp6-depth = `21`.
    temp6-height = `4.1`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `ITelO FlexTop I9800`.
    temp6-price = `1388`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `3.8`.
    temp6-weightunit = `KG`.
    temp6-width = `48`.
    temp6-depth = `31`.
    temp6-height = `4.5`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Smartphone Leather Case`.
    temp6-price = `25`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.02`.
    temp6-weightunit = `KG`.
    temp6-width = `48`.
    temp6-depth = `31`.
    temp6-height = `4.5`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Smartphone Alpha`.
    temp6-price = `599`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.75`.
    temp6-weightunit = `KG`.
    temp6-width = `48`.
    temp6-depth = `31`.
    temp6-height = `4.5`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Mini Tablet`.
    temp6-price = `833`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `3.8`.
    temp6-weightunit = `KG`.
    temp6-width = `48`.
    temp6-depth = `31`.
    temp6-height = `4.5`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Camcorder View`.
    temp6-price = `1388`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `3.8`.
    temp6-weightunit = `KG`.
    temp6-width = `48`.
    temp6-depth = `31`.
    temp6-height = `27`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Tablet Pouch`.
    temp6-price = `20`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.03`.
    temp6-weightunit = `KG`.
    temp6-width = `25`.
    temp6-depth = `40`.
    temp6-height = `4.5`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Tablet Pouch`.
    temp6-price = `20`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.03`.
    temp6-weightunit = `KG`.
    temp6-width = `25`.
    temp6-depth = `40`.
    temp6-height = `4.5`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `e-Book Reader ReadMe`.
    temp6-price = `33`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `3.8`.
    temp6-weightunit = `KG`.
    temp6-width = `48`.
    temp6-depth = `31`.
    temp6-height = `4.5`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Smartphone Beta`.
    temp6-price = `30`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.75`.
    temp6-weightunit = `KG`.
    temp6-width = `48`.
    temp6-depth = `31`.
    temp6-height = `4.5`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Maxi Tablet`.
    temp6-price = `749`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `3.8`.
    temp6-weightunit = `KG`.
    temp6-width = `48`.
    temp6-depth = `31`.
    temp6-height = `4.5`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    temp6-name = `Flyer`.
    temp6-price = `0`.
    temp6-currencycode = `EUR`.
    temp6-weightmeasure = `0.01`.
    temp6-weightunit = `KG`.
    temp6-width = `46`.
    temp6-depth = `30`.
    temp6-height = `3`.
    temp6-dimunit = `cm`.
    INSERT temp6 INTO TABLE temp5.
    t_products = temp5.

    " the header starts on /ProductCollection/0, like the original's binding
    
    
    
    temp2 = sy-tabix.
    READ TABLE t_products INDEX 1 INTO temp1.
    sy-tabix = temp2.
    IF sy-subrc <> 0.
      ASSERT 1 = 0.
    ENDIF.
    first = temp1.
    sel_name          = first-name.
    sel_price         = first-price.
    sel_currencycode  = first-currencycode.
    sel_weightmeasure = first-weightmeasure.
    sel_weightunit    = first-weightunit.
    sel_width         = first-width.
    sel_depth         = first-depth.
    sel_height        = first-height.
    sel_dimunit       = first-dimunit.

  ENDMETHOD.

ENDCLASS.
