" @keywords table sap.ui.table multiselectionplugin overflowtoolbar title toolbarspacer label select item input toolbarseparator togglebutton
" @summary Example showing the behavior of MultiSelectionPlugin
CLASS z2ui5_cl_smpc_app_356 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_product,
        name         TYPE string,
        productid    TYPE string,
        category     TYPE string,
        suppliername TYPE string,
        price        TYPE string,
        currencycode TYPE string,
        width        TYPE string,
        height       TYPE string,
        depth        TYPE string,
        dimunit      TYPE string,
      END OF ty_s_product,
      BEGIN OF ty_s_key,
        key  TYPE string,
        text TYPE string,
      END OF ty_s_key.
    DATA t_products       TYPE STANDARD TABLE OF ty_s_product WITH DEFAULT KEY.
    DATA t_selectionmodes TYPE STANDARD TABLE OF ty_s_key WITH DEFAULT KEY.

    " the original's `config>` model, folded onto the one default model. The
    " Input carries the limit as text because sap.m.Input.value is a string
    " property while the plugin's limit is an integer - the original bridges
    " that with a typed binding, the port parses it in onLimitChange's place
    DATA limit                TYPE i.
    DATA limit_text           TYPE string.
    DATA show_header_selector TYPE abap_bool.
    DATA selection_mode       TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_356 IMPLEMENTATION.

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

    " the MultiSelectionPlugin demo. The selection mode Select, the limit Input
    " and the header-selector toggle are two-way bound and the plugin binds the
    " same fields, so the three config controls drive it directly; only the
    " limit's parse and the two selection messages need the backend.
    
    CLEAR temp1.
    INSERT `${$parameters>/limitReached}` INTO TABLE temp1.
    INSERT `${$source>}.getSelectedIndices().length` INTO TABLE temp1.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`         v = `sap.ui.table`
        )->a( n = `xmlns:plugins` v = `sap.ui.table.plugins`
        )->a( n = `xmlns:mvc`     v = `sap.ui.core.mvc`
        )->a( n = `xmlns:u`       v = `sap.ui.unified`
        )->a( n = `xmlns:c`       v = `sap.ui.core`
        )->a( n = `xmlns:m`       v = `sap.m`
        )->a( n = `height`        v = `100%`

        )->ele( n = `Page` ns = `m`
            )->a( n = `showHeader`      v = `false`
            )->a( n = `enableScrolling` v = `false`
            )->a( n = `class`           v = `sapUiContentPadding`

            )->ele( n = `content` ns = `m`
                )->ele( `Table`
                    )->a( n = `id`                  v = `table`
                    )->a( n = `rows`                v = client->_bind( t_products )
                    )->a( n = `threshold`           v = `15`
                    )->a( n = `enableBusyIndicator` v = `true`
                    )->a( n = `ariaLabelledBy`      v = `title`

                    )->ele( `dependents`
                        )->tag( n = `MultiSelectionPlugin` ns = `plugins`
                            )->a( n = `limit`              v = client->_bind( limit )
                            )->a( n = `enableNotification` v = `true`
                            )->a( n = `showHeaderSelector` v = client->_bind( show_header_selector )
                            )->a( n = `selectionMode`      v = client->_bind( selection_mode )
                            )->a( n = `selectionChange`    v = client->_event( val   = `SELECTION_CHANGE`
                                                                               t_arg = temp1 )

                    )->end(
                    )->ele( `extension`
                        )->ele( n = `OverflowToolbar` ns = `m`
                            )->a( n = `style` v = `Clear`

                            )->tag( n = `Title` ns = `m`
                                )->a( n = `id`   v = `title`
                                )->a( n = `text` v = `Products`

                            )->tag( n = `ToolbarSpacer` ns = `m`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text`     v = `Selection Mode`
                                )->a( n = `labelFor` v = `select1`

                            )->ele( n = `Select` ns = `m`
                                )->a( n = `id`          v = `select1`
                                )->a( n = `width`       v = `20%`
                                )->a( n = `items`       v = client->_bind( t_selectionmodes )
                                )->a( n = `selectedKey` v = client->_bind( selection_mode )

                                )->tag( n = `Item` ns = `c`
                                    )->a( n = `key`  v = `{KEY}`
                                    )->a( n = `text` v = `{TEXT}`

                            )->end(
                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text`     v = `Limit`
                                )->a( n = `labelFor` v = `input1`

                            )->tag( n = `Input` ns = `m`
                                )->a( n = `id`      v = `input1`
                                )->a( n = `value`   v = client->_bind( limit_text )
                                )->a( n = `change`  v = client->_event( `LIMIT_CHANGE` )
                                )->a( n = `width`   v = `10%`
                                )->a( n = `tooltip` v = `limit`

                            )->tag( n = `ToolbarSeparator` ns = `m`

                            )->tag( n = `ToggleButton` ns = `m`
                                )->a( n = `icon`    v = `sap-icon://complete`
                                )->a( n = `tooltip` v = `Show header selector`
                                )->a( n = `pressed` v = client->_bind( show_header_selector )

                        )->end(
                    )->end(
                    )->ele( `columns`
                        )->ele( `Column`
                            )->a( n = `sortProperty`   v = `NAME`
                            )->a( n = `filterProperty` v = `NAME`
                            )->a( n = `autoResizable`  v = `true`
                            )->a( n = `width`          v = `11rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Product Name`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{NAME}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `sortProperty`   v = `PRODUCTID`
                            )->a( n = `filterProperty` v = `PRODUCTID`
                            )->a( n = `autoResizable`  v = `true`
                            )->a( n = `width`          v = `6rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Product ID`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{PRODUCTID}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `sortProperty`   v = `CATEGORY`
                            )->a( n = `filterProperty` v = `CATEGORY`
                            )->a( n = `autoResizable`  v = `true`
                            )->a( n = `width`          v = `11rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Prod. Cat.`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{CATEGORY}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `sortProperty`   v = `SUPPLIERNAME`
                            )->a( n = `filterProperty` v = `SUPPLIERNAME`
                            )->a( n = `autoResizable`  v = `true`
                            )->a( n = `width`          v = `12rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Company Name`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{SUPPLIERNAME}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `filterProperty` v = `PRICE`
                            )->a( n = `width`          v = `9rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Unit Price`

                            )->ele( `template`
                                )->tag( n = `Currency` ns = `u`
                                    )->a( n = `value`    v = |\{ path: 'PRICE', type: 'sap.ui.model.type.String' \}|
                                    )->a( n = `currency` v = `{CURRENCYCODE}`

                            )->end(
                        )->end(
                        )->ele( `Column`
                            )->a( n = `hAlign`        v = `End`
                            )->a( n = `autoResizable` v = `true`
                            )->a( n = `width`         v = `9rem`

                            )->tag( n = `Label` ns = `m`
                                )->a( n = `text` v = `Dimensions`

                            )->ele( `template`
                                )->tag( n = `Text` ns = `m`
                                    )->a( n = `text`     v = `{WIDTH}x{HEIGHT}x{DEPTH} {DIMUNIT}`
                                    )->a( n = `wrapping` v = `false`

                            )->end(
                        )->end(
                    )->end(
                )->end(
            )->end(
        )->end(
    )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.
          DATA temp3 TYPE string.
        DATA lv_limit_reached TYPE string.
        DATA temp4 TYPE i.
        DATA lv_count LIKE temp4.

    CASE client->get_event( ).

      WHEN `LIMIT_CHANGE`.
        " onLimitChange: only a positive integer is accepted, 0 disables the
        " limit, anything else snaps the Input back to the current value
        " the length term guards the implicit conversion below: `99999999999`
        " is all digits and overflows the TYPE i target
        IF limit_text CO ` 0123456789` AND limit_text IS NOT INITIAL
           AND strlen( condense( limit_text ) ) <= 9.
          limit = limit_text.
          
          IF limit = 0.
            temp3 = `Limit disabled`.
          ELSE.
            temp3 = |Limit set to { limit }|.
          ENDIF.
          client->message_toast_display( temp3 ).
        ELSE.
          limit_text = |{ limit }|.
          client->message_toast_display( |The Limit accepts positive integer values. To disable it set its value to 0. \nCurrent limit is { limit }| ).
        ENDIF.

      WHEN `SELECTION_CHANGE`.
        " onSelectionChange: how many rows are selected, and whether the last
        " range had to be cut down to the limit
        
        lv_limit_reached = client->get_event_arg( ).
        
        temp4 = client->get_event_arg( 2 ).
        
        lv_count = temp4.
        IF lv_count = 0.
          client->message_toast_display( `Selection cleared.` ).
        ELSEIF lv_limit_reached = abap_true.
          client->message_toast_display( |{ lv_count } row(s) selected. The recently selected range was limited to { limit } rows!| ).
        ELSE.
          client->message_toast_display( |{ lv_count } row(s) selected.| ).
        ENDIF.

    ENDCASE.


  ENDMETHOD.


  METHOD model_init.
    DATA temp5 LIKE t_selectionmodes.
    DATA temp6 LIKE LINE OF temp5.
    DATA temp7 LIKE t_products.
    DATA temp8 LIKE LINE OF temp7.

    " the `config>` model defaults the controller sets
    limit                = 20.
    limit_text           = `20`.
    show_header_selector = abap_true.
    selection_mode       = `MultiToggle`.

    " the SelectionMode item set the controller builds from the sap.ui.table
    " enum, in Object.keys order, with Multi skipped as there. The enum has
    " exactly MultiToggle / Multi / Single / None - until 2026-08-21 this list
    " carried a fourth entry `All`, which is not a member at all: it is bound
    " straight onto the plugin's selectionMode, typed sap.ui.table.SelectionMode,
    " so picking it reached ManagedObject.validateProperty and threw.
    
    CLEAR temp5.
    
    temp6-key = `MultiToggle`.
    temp6-text = `MultiToggle`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `Single`.
    temp6-text = `Single`.
    INSERT temp6 INTO TABLE temp5.
    temp6-key = `None`.
    temp6-text = `None`.
    INSERT temp6 INTO TABLE temp5.
    t_selectionmodes = temp5.

    " the OData ProductSet the sample serves from a MockServer, inlined with
    " the columns the six table columns bind - all 115 rows of ProductSet.json
    
    CLEAR temp7.
    
    temp8-name = `Flyer`.
    temp8-productid = `AD-1000`.
    temp8-category = `Computer system accessories`.
    temp8-suppliername = `Robert Brown Entertainment`.
    temp8-price = `0.0`.
    temp8-currencycode = `CAD`.
    temp8-width = `0.46`.
    temp8-height = `0.03`.
    temp8-depth = `0.3`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Notebook Basic 15`.
    temp8-productid = `HT-1000`.
    temp8-category = `Notebooks`.
    temp8-suppliername = `SAP`.
    temp8-price = `956.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.3`.
    temp8-height = `0.03`.
    temp8-depth = `0.18`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Notebook Basic 17`.
    temp8-productid = `HT-1001`.
    temp8-category = `Notebooks`.
    temp8-suppliername = `Becker Berlin`.
    temp8-price = `1249.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.29`.
    temp8-height = `0.03`.
    temp8-depth = `0.17`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Notebook Basic 18`.
    temp8-productid = `HT-1002`.
    temp8-category = `Notebooks`.
    temp8-suppliername = `DelBont Industries`.
    temp8-price = `1570.0`.
    temp8-currencycode = `USD`.
    temp8-width = `0.28`.
    temp8-height = `0.03`.
    temp8-depth = `0.19`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Notebook Basic 19`.
    temp8-productid = `HT-1003`.
    temp8-category = `Notebooks`.
    temp8-suppliername = `Talpa`.
    temp8-price = `1650.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.32`.
    temp8-height = `0.04`.
    temp8-depth = `0.21`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `ITelO Vault`.
    temp8-productid = `HT-1007`.
    temp8-category = `PDAs/Organizers`.
    temp8-suppliername = `Panorama Studios`.
    temp8-price = `299.0`.
    temp8-currencycode = `USD`.
    temp8-width = `0.32`.
    temp8-height = `0.03`.
    temp8-depth = `0.22`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Notebook Professional 15`.
    temp8-productid = `HT-1010`.
    temp8-category = `Notebooks`.
    temp8-suppliername = `TECUM`.
    temp8-price = `1999.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.33`.
    temp8-height = `0.03`.
    temp8-depth = `0.2`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Notebook Professional 17`.
    temp8-productid = `HT-1011`.
    temp8-category = `Notebooks`.
    temp8-suppliername = `Asia High tech`.
    temp8-price = `2299.0`.
    temp8-currencycode = `JPY`.
    temp8-width = `0.33`.
    temp8-height = `0.02`.
    temp8-depth = `0.23`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `ITelO Vault Net`.
    temp8-productid = `HT-1020`.
    temp8-category = `PDAs/Organizers`.
    temp8-suppliername = `Laurent`.
    temp8-price = `459.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.1`.
    temp8-height = `0.17`.
    temp8-depth = `0.02`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `ITelO Vault SAT`.
    temp8-productid = `HT-1021`.
    temp8-category = `PDAs/Organizers`.
    temp8-suppliername = `AVANTEL`.
    temp8-price = `149.0`.
    temp8-currencycode = `MXN`.
    temp8-width = `0.11`.
    temp8-height = `0.18`.
    temp8-depth = `0.02`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Comfort Easy`.
    temp8-productid = `HT-1022`.
    temp8-category = `PDAs/Organizers`.
    temp8-suppliername = `Telecomunicaciones Star`.
    temp8-price = `1679.0`.
    temp8-currencycode = `ARS`.
    temp8-width = `0.84`.
    temp8-height = `0.14`.
    temp8-depth = `0.02`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Comfort Senior`.
    temp8-productid = `HT-1023`.
    temp8-category = `PDAs/Organizers`.
    temp8-suppliername = `Pear Computing Services`.
    temp8-price = `512.0`.
    temp8-currencycode = `USD`.
    temp8-width = `0.8`.
    temp8-height = `0.13`.
    temp8-depth = `0.02`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Ergo Screen E-I`.
    temp8-productid = `HT-1030`.
    temp8-category = `Flat screens`.
    temp8-suppliername = `Alpine Systems`.
    temp8-price = `230.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.37`.
    temp8-height = `0.36`.
    temp8-depth = `0.12`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Ergo Screen E-II`.
    temp8-productid = `HT-1031`.
    temp8-category = `Flat screens`.
    temp8-suppliername = `New Line Design`.
    temp8-price = `285.0`.
    temp8-currencycode = `GBP`.
    temp8-width = `0.41`.
    temp8-height = `0.43`.
    temp8-depth = `0.19`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Ergo Screen E-III`.
    temp8-productid = `HT-1032`.
    temp8-category = `Flat screens`.
    temp8-suppliername = `HEPA Tec`.
    temp8-price = `345.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.41`.
    temp8-height = `0.43`.
    temp8-depth = `0.19`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Flat Basic`.
    temp8-productid = `HT-1035`.
    temp8-category = `Flat screens`.
    temp8-suppliername = `Anav Ideon`.
    temp8-price = `399.0`.
    temp8-currencycode = `USD`.
    temp8-width = `0.39`.
    temp8-height = `0.41`.
    temp8-depth = `0.2`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Flat Future`.
    temp8-productid = `HT-1036`.
    temp8-category = `Flat screens`.
    temp8-suppliername = `Robert Brown Entertainment`.
    temp8-price = `430.0`.
    temp8-currencycode = `CAD`.
    temp8-width = `0.45`.
    temp8-height = `0.46`.
    temp8-depth = `0.26`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Flat XL`.
    temp8-productid = `HT-1037`.
    temp8-category = `Flat screens`.
    temp8-suppliername = `Mexican Oil Trading Company`.
    temp8-price = `1230.0`.
    temp8-currencycode = `MXN`.
    temp8-width = `0.55`.
    temp8-height = `0.39`.
    temp8-depth = `0.22`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Laser Professional Eco`.
    temp8-productid = `HT-1040`.
    temp8-category = `Laser printers`.
    temp8-suppliername = `Meliva`.
    temp8-price = `830.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.51`.
    temp8-height = `0.3`.
    temp8-depth = `0.46`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Laser Basic`.
    temp8-productid = `HT-1041`.
    temp8-category = `Laser printers`.
    temp8-suppliername = `Compostela`.
    temp8-price = `490.0`.
    temp8-currencycode = `ARS`.
    temp8-width = `0.48`.
    temp8-height = `0.26`.
    temp8-depth = `0.42`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Laser Allround`.
    temp8-productid = `HT-1042`.
    temp8-category = `Laser printers`.
    temp8-suppliername = `Pateu`.
    temp8-price = `349.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.53`.
    temp8-height = `0.65`.
    temp8-depth = `0.5`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Ultra Jet Super Color`.
    temp8-productid = `HT-1050`.
    temp8-category = `Ink jet printers`.
    temp8-suppliername = `Russian Electronic Trading Company`.
    temp8-price = `139.0`.
    temp8-currencycode = `RUB`.
    temp8-width = `0.41`.
    temp8-height = `0.28`.
    temp8-depth = `0.41`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Ultra Jet Mobile`.
    temp8-productid = `HT-1051`.
    temp8-category = `Ink jet printers`.
    temp8-suppliername = `Florida Holiday Company`.
    temp8-price = `99.0`.
    temp8-currencycode = `USD`.
    temp8-width = `0.46`.
    temp8-height = `0.25`.
    temp8-depth = `0.32`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Ultra Jet Super Highspeed`.
    temp8-productid = `HT-1052`.
    temp8-category = `Ink jet printers`.
    temp8-suppliername = `Quimica Madrilenos`.
    temp8-price = `170.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.41`.
    temp8-height = `0.28`.
    temp8-depth = `0.41`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Multi Print`.
    temp8-productid = `HT-1055`.
    temp8-category = `Multifunction printers`.
    temp8-suppliername = `Getränkegroßhandel Janssen`.
    temp8-price = `99.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.55`.
    temp8-height = `0.29`.
    temp8-depth = `0.45`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Multi Color`.
    temp8-productid = `HT-1056`.
    temp8-category = `Multifunction printers`.
    temp8-suppliername = `JaTeCo`.
    temp8-price = `119.0`.
    temp8-currencycode = `JPY`.
    temp8-width = `0.51`.
    temp8-height = `0.22`.
    temp8-depth = `0.41`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Cordless Mouse`.
    temp8-productid = `HT-1060`.
    temp8-category = `Mice`.
    temp8-suppliername = `Tessile Casa Di Roma`.
    temp8-price = `9.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.06`.
    temp8-height = `0.04`.
    temp8-depth = `0.15`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Speed Mouse`.
    temp8-productid = `HT-1061`.
    temp8-category = `Mice`.
    temp8-suppliername = `Vente Et Réparation de Ordinateur`.
    temp8-price = `7.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.07`.
    temp8-height = `0.03`.
    temp8-depth = `0.15`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Track Mouse`.
    temp8-productid = `HT-1062`.
    temp8-category = `Mice`.
    temp8-suppliername = `Developement Para O Governo`.
    temp8-price = `11.0`.
    temp8-currencycode = `ARS`.
    temp8-width = `0.0`.
    temp8-height = `0.04`.
    temp8-depth = `0.01`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Ergonomic Keyboard`.
    temp8-productid = `HT-1063`.
    temp8-category = `Keyboards`.
    temp8-suppliername = `Brazil Technologies`.
    temp8-price = `14.0`.
    temp8-currencycode = `BRL`.
    temp8-width = `0.5`.
    temp8-height = `0.04`.
    temp8-depth = `0.21`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Internet Keyboard`.
    temp8-productid = `HT-1064`.
    temp8-category = `Keyboards`.
    temp8-suppliername = `C.R.T.U.`.
    temp8-price = `16.0`.
    temp8-currencycode = `CAD`.
    temp8-width = `0.52`.
    temp8-height = `0.03`.
    temp8-depth = `0.25`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Media Keyboard`.
    temp8-productid = `HT-1065`.
    temp8-category = `Keyboards`.
    temp8-suppliername = `Jologa`.
    temp8-price = `26.0`.
    temp8-currencycode = `CHF`.
    temp8-width = `0.51`.
    temp8-height = `0.04`.
    temp8-depth = `0.23`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Mousepad`.
    temp8-productid = `HT-1066`.
    temp8-category = `Mousepads`.
    temp8-suppliername = `Baleda`.
    temp8-price = `6.99`.
    temp8-currencycode = `USD`.
    temp8-width = `0.15`.
    temp8-height = `0.0`.
    temp8-depth = `0.06`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Ergo Mousepad`.
    temp8-productid = `HT-1067`.
    temp8-category = `Mousepads`.
    temp8-suppliername = `Angeré`.
    temp8-price = `8.99`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.15`.
    temp8-height = `0.0`.
    temp8-depth = `0.06`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Designer Mousepad`.
    temp8-productid = `HT-1068`.
    temp8-category = `Mousepads`.
    temp8-suppliername = `PC Gym Tec`.
    temp8-price = `12.99`.
    temp8-currencycode = `USD`.
    temp8-width = `0.24`.
    temp8-height = `0.01`.
    temp8-depth = `0.24`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Universal card reader`.
    temp8-productid = `HT-1069`.
    temp8-category = `Computer system accessories`.
    temp8-suppliername = `Japan Insurance Partner`.
    temp8-price = `14.0`.
    temp8-currencycode = `JPY`.
    temp8-width = `0.01`.
    temp8-height = `0.0`.
    temp8-depth = `0.01`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Proctra X`.
    temp8-productid = `HT-1070`.
    temp8-category = `Graphic cards`.
    temp8-suppliername = `Entertainment Argentinia`.
    temp8-price = `70.9`.
    temp8-currencycode = `ARS`.
    temp8-width = `0.22`.
    temp8-height = `0.17`.
    temp8-depth = `0.35`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Gladiator MX`.
    temp8-productid = `HT-1071`.
    temp8-category = `Graphic cards`.
    temp8-suppliername = `African Gold And Diamond Corporation`.
    temp8-price = `81.7`.
    temp8-currencycode = `ZAR`.
    temp8-width = `0.22`.
    temp8-height = `0.17`.
    temp8-depth = `0.35`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Hurricane GX`.
    temp8-productid = `HT-1072`.
    temp8-category = `Graphic cards`.
    temp8-suppliername = `PicoBit`.
    temp8-price = `101.2`.
    temp8-currencycode = `USD`.
    temp8-width = `0.22`.
    temp8-height = `0.17`.
    temp8-depth = `0.35`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Hurricane GX/LN`.
    temp8-productid = `HT-1073`.
    temp8-category = `Graphic cards`.
    temp8-suppliername = `Bionic Research Lab`.
    temp8-price = `139.99`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.22`.
    temp8-height = `0.17`.
    temp8-depth = `0.35`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Photo Scan`.
    temp8-productid = `HT-1080`.
    temp8-category = `Scanners`.
    temp8-suppliername = `Indian IT Trading Company`.
    temp8-price = `129.0`.
    temp8-currencycode = `INR`.
    temp8-width = `0.34`.
    temp8-height = `0.05`.
    temp8-depth = `0.48`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Power Scan`.
    temp8-productid = `HT-1081`.
    temp8-category = `Scanners`.
    temp8-suppliername = `Chemia A Technicznie Fabryka`.
    temp8-price = `89.0`.
    temp8-currencycode = `PLN`.
    temp8-width = `0.31`.
    temp8-height = `0.07`.
    temp8-depth = `0.43`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Jet Scan Professional`.
    temp8-productid = `HT-1082`.
    temp8-category = `Scanners`.
    temp8-suppliername = `South American IT Company`.
    temp8-price = `169.0`.
    temp8-currencycode = `ARS`.
    temp8-width = `0.33`.
    temp8-height = `0.12`.
    temp8-depth = `0.41`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Jet Scan Professional`.
    temp8-productid = `HT-1083`.
    temp8-category = `Scanners`.
    temp8-suppliername = `Siwusha`.
    temp8-price = `189.0`.
    temp8-currencycode = `CNY`.
    temp8-width = `0.35`.
    temp8-height = `0.1`.
    temp8-depth = `0.4`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Copymaster`.
    temp8-productid = `HT-1085`.
    temp8-category = `Multifunction printers`.
    temp8-suppliername = `Danish Fish Trading Company`.
    temp8-price = `1499.0`.
    temp8-currencycode = `DKK`.
    temp8-width = `0.45`.
    temp8-height = `0.22`.
    temp8-depth = `0.42`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Surround Sound`.
    temp8-productid = `HT-1090`.
    temp8-category = `Speakers`.
    temp8-suppliername = `Sorali`.
    temp8-price = `39.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.12`.
    temp8-height = `0.16`.
    temp8-depth = `0.1`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Blaster Extreme`.
    temp8-productid = `HT-1091`.
    temp8-category = `Speakers`.
    temp8-suppliername = `SAP`.
    temp8-price = `26.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.13`.
    temp8-height = `0.18`.
    temp8-depth = `0.11`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Sound Booster`.
    temp8-productid = `HT-1092`.
    temp8-category = `Speakers`.
    temp8-suppliername = `Becker Berlin`.
    temp8-price = `45.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.12`.
    temp8-height = `0.18`.
    temp8-depth = `0.1`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Lovely Sound 5.1 Wireless`.
    temp8-productid = `HT-1095`.
    temp8-category = `Headsets`.
    temp8-suppliername = `PC Gym Tec`.
    temp8-price = `49.0`.
    temp8-currencycode = `USD`.
    temp8-width = `0.24`.
    temp8-height = `0.23`.
    temp8-depth = `0.02`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Lovely Sound 5.1`.
    temp8-productid = `HT-1096`.
    temp8-category = `Headsets`.
    temp8-suppliername = `Japan Insurance Partner`.
    temp8-price = `39.0`.
    temp8-currencycode = `JPY`.
    temp8-width = `0.25`.
    temp8-height = `0.19`.
    temp8-depth = `0.02`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Lovely Sound Stereo`.
    temp8-productid = `HT-1097`.
    temp8-category = `Headsets`.
    temp8-suppliername = `Entertainment Argentinia`.
    temp8-price = `29.0`.
    temp8-currencycode = `ARS`.
    temp8-width = `0.21`.
    temp8-height = `0.2`.
    temp8-depth = `0.02`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Smart Office`.
    temp8-productid = `HT-1100`.
    temp8-category = `Software`.
    temp8-suppliername = `DelBont Industries`.
    temp8-price = `89.9`.
    temp8-currencycode = `USD`.
    temp8-width = `0.15`.
    temp8-height = `0.21`.
    temp8-depth = `0.07`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Smart Design`.
    temp8-productid = `HT-1101`.
    temp8-category = `Software`.
    temp8-suppliername = `Talpa`.
    temp8-price = `79.9`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.14`.
    temp8-height = `0.24`.
    temp8-depth = `0.07`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Smart Network`.
    temp8-productid = `HT-1102`.
    temp8-category = `Software`.
    temp8-suppliername = `Panorama Studios`.
    temp8-price = `69.0`.
    temp8-currencycode = `USD`.
    temp8-width = `0.16`.
    temp8-height = `0.27`.
    temp8-depth = `0.06`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Smart Multimedia`.
    temp8-productid = `HT-1103`.
    temp8-category = `Software`.
    temp8-suppliername = `TECUM`.
    temp8-price = `77.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.11`.
    temp8-height = `0.22`.
    temp8-depth = `0.03`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Smart Games`.
    temp8-productid = `HT-1104`.
    temp8-category = `Software`.
    temp8-suppliername = `Asia High tech`.
    temp8-price = `55.0`.
    temp8-currencycode = `JPY`.
    temp8-width = `0.1`.
    temp8-height = `0.3`.
    temp8-depth = `0.03`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Smart Internet Antivirus`.
    temp8-productid = `HT-1105`.
    temp8-category = `Software`.
    temp8-suppliername = `Laurent`.
    temp8-price = `29.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.16`.
    temp8-height = `0.21`.
    temp8-depth = `0.04`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Smart Firewall`.
    temp8-productid = `HT-1106`.
    temp8-category = `Software`.
    temp8-suppliername = `AVANTEL`.
    temp8-price = `34.0`.
    temp8-currencycode = `MXN`.
    temp8-width = `0.18`.
    temp8-height = `0.23`.
    temp8-depth = `0.04`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Smart Money`.
    temp8-productid = `HT-1107`.
    temp8-category = `Software`.
    temp8-suppliername = `Telecomunicaciones Star`.
    temp8-price = `29.9`.
    temp8-currencycode = `ARS`.
    temp8-width = `0.12`.
    temp8-height = `0.19`.
    temp8-depth = `0.02`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `PC Lock`.
    temp8-productid = `HT-1110`.
    temp8-category = `Computer system accessories`.
    temp8-suppliername = `Pear Computing Services`.
    temp8-price = `8.9`.
    temp8-currencycode = `USD`.
    temp8-width = `0.2`.
    temp8-height = `0.04`.
    temp8-depth = `0.08`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Notebook Lock`.
    temp8-productid = `HT-1111`.
    temp8-category = `Computer system accessories`.
    temp8-suppliername = `Alpine Systems`.
    temp8-price = `6.9`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.31`.
    temp8-height = `0.07`.
    temp8-depth = `0.09`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Web cam reality`.
    temp8-productid = `HT-1112`.
    temp8-category = `Computer system accessories`.
    temp8-suppliername = `New Line Design`.
    temp8-price = `39.0`.
    temp8-currencycode = `GBP`.
    temp8-width = `0.09`.
    temp8-height = `0.01`.
    temp8-depth = `0.08`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Screen clean`.
    temp8-productid = `HT-1113`.
    temp8-category = `Computer system accessories`.
    temp8-suppliername = `HEPA Tec`.
    temp8-price = `2.3`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.02`.
    temp8-height = `0.0`.
    temp8-depth = `0.02`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Fabric bag professional`.
    temp8-productid = `HT-1114`.
    temp8-category = `Computer system accessories`.
    temp8-suppliername = `Anav Ideon`.
    temp8-price = `31.0`.
    temp8-currencycode = `USD`.
    temp8-width = `0.42`.
    temp8-height = `0.07`.
    temp8-depth = `0.32`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Wireless DSL Router`.
    temp8-productid = `HT-1115`.
    temp8-category = `Telecommunication`.
    temp8-suppliername = `Robert Brown Entertainment`.
    temp8-price = `49.0`.
    temp8-currencycode = `CAD`.
    temp8-width = `0.19`.
    temp8-height = `0.05`.
    temp8-depth = `0.18`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Wireless DSL Router / Repeater`.
    temp8-productid = `HT-1116`.
    temp8-category = `Telecommunication`.
    temp8-suppliername = `Mexican Oil Trading Company`.
    temp8-price = `59.0`.
    temp8-currencycode = `MXN`.
    temp8-width = `0.19`.
    temp8-height = `0.05`.
    temp8-depth = `0.18`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Wireless DSL Router / Repeater and Print Server`.
    temp8-productid = `HT-1117`.
    temp8-category = `Telecommunication`.
    temp8-suppliername = `Meliva`.
    temp8-price = `69.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.19`.
    temp8-height = `0.05`.
    temp8-depth = `0.18`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `USB Stick`.
    temp8-productid = `HT-1118`.
    temp8-category = `Computer system accessories`.
    temp8-suppliername = `Compostela`.
    temp8-price = `35.0`.
    temp8-currencycode = `ARS`.
    temp8-width = `0.02`.
    temp8-height = `0.01`.
    temp8-depth = `0.09`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Travel Adapter`.
    temp8-productid = `HT-1119`.
    temp8-category = `Computer system accessories`.
    temp8-suppliername = `Pear Computing Services`.
    temp8-price = `79.0`.
    temp8-currencycode = `USD`.
    temp8-width = `0.02`.
    temp8-height = `0.04`.
    temp8-depth = `0.03`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Cordless Bluetooth Keyboard, english international`.
    temp8-productid = `HT-1120`.
    temp8-category = `Keyboards`.
    temp8-suppliername = `Pateu`.
    temp8-price = `29.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.51`.
    temp8-height = `0.04`.
    temp8-depth = `0.23`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Flat XXL`.
    temp8-productid = `HT-1137`.
    temp8-category = `Flat screens`.
    temp8-suppliername = `Russian Electronic Trading Company`.
    temp8-price = `1430.0`.
    temp8-currencycode = `RUB`.
    temp8-width = `0.54`.
    temp8-height = `0.38`.
    temp8-depth = `0.22`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Pocket Mouse`.
    temp8-productid = `HT-1138`.
    temp8-category = `Mice`.
    temp8-suppliername = `Florida Holiday Company`.
    temp8-price = `23.0`.
    temp8-currencycode = `USD`.
    temp8-width = `0.0`.
    temp8-height = `0.01`.
    temp8-depth = `0.01`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `PC Power Station`.
    temp8-productid = `HT-1210`.
    temp8-category = `PCs`.
    temp8-suppliername = `Quimica Madrilenos`.
    temp8-price = `2399.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.28`.
    temp8-height = `0.43`.
    temp8-depth = `0.31`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Server Basic`.
    temp8-productid = `HT-1500`.
    temp8-category = `Servers`.
    temp8-suppliername = `Getränkegroßhandel Janssen`.
    temp8-price = `5000.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.34`.
    temp8-height = `0.23`.
    temp8-depth = `0.35`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Server Professional`.
    temp8-productid = `HT-1501`.
    temp8-category = `Servers`.
    temp8-suppliername = `JaTeCo`.
    temp8-price = `15000.0`.
    temp8-currencycode = `JPY`.
    temp8-width = `0.29`.
    temp8-height = `0.27`.
    temp8-depth = `0.3`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Server Power Pro`.
    temp8-productid = `HT-1502`.
    temp8-category = `Servers`.
    temp8-suppliername = `Tessile Casa Di Roma`.
    temp8-price = `25000.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.22`.
    temp8-height = `0.37`.
    temp8-depth = `0.27`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Family PC Basic`.
    temp8-productid = `HT-1600`.
    temp8-category = `PCs`.
    temp8-suppliername = `Telecomunicaciones Star`.
    temp8-price = `600.0`.
    temp8-currencycode = `ARS`.
    temp8-width = `0.21`.
    temp8-height = `0.38`.
    temp8-depth = `0.29`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Family PC Pro`.
    temp8-productid = `HT-1601`.
    temp8-category = `PCs`.
    temp8-suppliername = `AVANTEL`.
    temp8-price = `900.0`.
    temp8-currencycode = `MXN`.
    temp8-width = `0.25`.
    temp8-height = `0.4`.
    temp8-depth = `0.32`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Gaming Monster`.
    temp8-productid = `HT-1602`.
    temp8-category = `PCs`.
    temp8-suppliername = `Laurent`.
    temp8-price = `1200.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.27`.
    temp8-height = `0.47`.
    temp8-depth = `0.34`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Gaming Monster Pro`.
    temp8-productid = `HT-1603`.
    temp8-category = `PCs`.
    temp8-suppliername = `Asia High tech`.
    temp8-price = `1700.0`.
    temp8-currencycode = `JPY`.
    temp8-width = `0.27`.
    temp8-height = `0.42`.
    temp8-depth = `0.28`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `7" Widescreen Portable DVD Player w MP3`.
    temp8-productid = `HT-2000`.
    temp8-category = `Portable Players`.
    temp8-suppliername = `TECUM`.
    temp8-price = `249.99`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.21`.
    temp8-height = `0.28`.
    temp8-depth = `0.19`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `10" Portable DVD player`.
    temp8-productid = `HT-2001`.
    temp8-category = `Portable Players`.
    temp8-suppliername = `Panorama Studios`.
    temp8-price = `449.99`.
    temp8-currencycode = `USD`.
    temp8-width = `0.24`.
    temp8-height = `0.29`.
    temp8-depth = `0.2`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Portable DVD Player with 9" LCD Monitor`.
    temp8-productid = `HT-2002`.
    temp8-category = `Portable Players`.
    temp8-suppliername = `Sorali`.
    temp8-price = `853.99`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.21`.
    temp8-height = `0.14`.
    temp8-depth = `0.17`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `CD/DVD case: 264 sleeves`.
    temp8-productid = `HT-2025`.
    temp8-category = `Computer system accessories`.
    temp8-suppliername = `Talpa`.
    temp8-price = `44.99`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.13`.
    temp8-height = `0.2`.
    temp8-depth = `0.13`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Audio/Video Cable Kit - 4m`.
    temp8-productid = `HT-2026`.
    temp8-category = `Computer system accessories`.
    temp8-suppliername = `DelBont Industries`.
    temp8-price = `29.99`.
    temp8-currencycode = `USD`.
    temp8-width = `0.21`.
    temp8-height = `0.13`.
    temp8-depth = `0.1`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Removable CD/DVD Laser Labels`.
    temp8-productid = `HT-2027`.
    temp8-category = `Computer system accessories`.
    temp8-suppliername = `Becker Berlin`.
    temp8-price = `8.99`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.06`.
    temp8-height = `0.02`.
    temp8-depth = `0.02`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Beam Breaker B-1`.
    temp8-productid = `HT-6100`.
    temp8-category = `Beamers`.
    temp8-suppliername = `SAP`.
    temp8-price = `469.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.3`.
    temp8-height = `0.23`.
    temp8-depth = `0.23`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Beam Breaker B-2`.
    temp8-productid = `HT-6101`.
    temp8-category = `Beamers`.
    temp8-suppliername = `Danish Fish Trading Company`.
    temp8-price = `679.0`.
    temp8-currencycode = `DKK`.
    temp8-width = `0.3`.
    temp8-height = `0.23`.
    temp8-depth = `0.23`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Beam Breaker B-3`.
    temp8-productid = `HT-6102`.
    temp8-category = `Beamers`.
    temp8-suppliername = `Siwusha`.
    temp8-price = `889.0`.
    temp8-currencycode = `CNY`.
    temp8-width = `0.3`.
    temp8-height = `0.23`.
    temp8-depth = `0.23`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Play Movie`.
    temp8-productid = `HT-6110`.
    temp8-category = `Portable Players`.
    temp8-suppliername = `South American IT Company`.
    temp8-price = `130.0`.
    temp8-currencycode = `ARS`.
    temp8-width = `0.37`.
    temp8-height = `0.06`.
    temp8-depth = `0.24`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Record Movie`.
    temp8-productid = `HT-6111`.
    temp8-category = `Portable Players`.
    temp8-suppliername = `Chemia A Technicznie Fabryka`.
    temp8-price = `288.0`.
    temp8-currencycode = `PLN`.
    temp8-width = `0.38`.
    temp8-height = `0.06`.
    temp8-depth = `0.26`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `ITelo MusickStick`.
    temp8-productid = `HT-6120`.
    temp8-category = `MP3-Players`.
    temp8-suppliername = `Indian IT Trading Company`.
    temp8-price = `45.0`.
    temp8-currencycode = `INR`.
    temp8-width = `0.02`.
    temp8-height = `0.01`.
    temp8-depth = `0.06`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `ITelo Jog-Mate`.
    temp8-productid = `HT-6121`.
    temp8-category = `MP3-Players`.
    temp8-suppliername = `Bionic Research Lab`.
    temp8-price = `63.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.05`.
    temp8-height = `0.09`.
    temp8-depth = `0.08`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Power Pro Player 40`.
    temp8-productid = `HT-6122`.
    temp8-category = `MP3-Players`.
    temp8-suppliername = `PicoBit`.
    temp8-price = `167.0`.
    temp8-currencycode = `USD`.
    temp8-width = `0.05`.
    temp8-height = `0.09`.
    temp8-depth = `0.08`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Power Pro Player 80`.
    temp8-productid = `HT-6123`.
    temp8-category = `MP3-Players`.
    temp8-suppliername = `African Gold And Diamond Corporation`.
    temp8-price = `299.0`.
    temp8-currencycode = `ZAR`.
    temp8-width = `0.04`.
    temp8-height = `0.01`.
    temp8-depth = `0.06`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Flat Watch HD32`.
    temp8-productid = `HT-6130`.
    temp8-category = `TV flat screens`.
    temp8-suppliername = `Vente Et Réparation de Ordinateur`.
    temp8-price = `1459.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.78`.
    temp8-height = `0.55`.
    temp8-depth = `0.22`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Flat Watch HD37`.
    temp8-productid = `HT-6131`.
    temp8-category = `TV flat screens`.
    temp8-suppliername = `Developement Para O Governo`.
    temp8-price = `1199.0`.
    temp8-currencycode = `ARS`.
    temp8-width = `0.99`.
    temp8-height = `0.61`.
    temp8-depth = `0.26`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Flat Watch HD41`.
    temp8-productid = `HT-6132`.
    temp8-category = `TV flat screens`.
    temp8-suppliername = `Brazil Technologies`.
    temp8-price = `899.0`.
    temp8-currencycode = `BRL`.
    temp8-width = `1.28`.
    temp8-height = `0.79`.
    temp8-depth = `0.23`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Copperberry`.
    temp8-productid = `HT-7000`.
    temp8-category = `PDAs/Organizers`.
    temp8-suppliername = `Angeré`.
    temp8-price = `549.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.08`.
    temp8-height = `0.12`.
    temp8-depth = `0.13`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Silverberry`.
    temp8-productid = `HT-7010`.
    temp8-category = `PDAs/Organizers`.
    temp8-suppliername = `Baleda`.
    temp8-price = `549.0`.
    temp8-currencycode = `USD`.
    temp8-width = `0.08`.
    temp8-height = `0.12`.
    temp8-depth = `0.13`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Goldberry`.
    temp8-productid = `HT-7020`.
    temp8-category = `PDAs/Organizers`.
    temp8-suppliername = `Jologa`.
    temp8-price = `549.0`.
    temp8-currencycode = `CHF`.
    temp8-width = `0.08`.
    temp8-height = `0.12`.
    temp8-depth = `0.13`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Platinberry`.
    temp8-productid = `HT-7030`.
    temp8-category = `PDAs/Organizers`.
    temp8-suppliername = `C.R.T.U.`.
    temp8-price = `549.0`.
    temp8-currencycode = `CAD`.
    temp8-width = `0.08`.
    temp8-height = `0.12`.
    temp8-depth = `0.13`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `ITelO FlexTop I4000`.
    temp8-productid = `HT-8000`.
    temp8-category = `Notebooks`.
    temp8-suppliername = `Alpine Systems`.
    temp8-price = `799.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.31`.
    temp8-height = `0.03`.
    temp8-depth = `0.19`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `ITelO FlexTop I6300c`.
    temp8-productid = `HT-8001`.
    temp8-category = `Notebooks`.
    temp8-suppliername = `New Line Design`.
    temp8-price = `999.0`.
    temp8-currencycode = `GBP`.
    temp8-width = `0.32`.
    temp8-height = `0.03`.
    temp8-depth = `0.2`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `ITelO FlexTop I9100`.
    temp8-productid = `HT-8002`.
    temp8-category = `Notebooks`.
    temp8-suppliername = `HEPA Tec`.
    temp8-price = `1199.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.38`.
    temp8-height = `0.04`.
    temp8-depth = `0.21`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `ITelO FlexTop I9800`.
    temp8-productid = `HT-8003`.
    temp8-category = `Notebooks`.
    temp8-suppliername = `Anav Ideon`.
    temp8-price = `1388.0`.
    temp8-currencycode = `USD`.
    temp8-width = `0.48`.
    temp8-height = `0.05`.
    temp8-depth = `0.31`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Smartphone Leather Case`.
    temp8-productid = `HT-9991`.
    temp8-category = `Accessories`.
    temp8-suppliername = `JaTeCo`.
    temp8-price = `25.0`.
    temp8-currencycode = `JPY`.
    temp8-width = `0.48`.
    temp8-height = `0.05`.
    temp8-depth = `0.31`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Smartphone Alpha`.
    temp8-productid = `HT-9992`.
    temp8-category = `Smartphones`.
    temp8-suppliername = `Getränkegroßhandel Janssen`.
    temp8-price = `599.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.48`.
    temp8-height = `0.05`.
    temp8-depth = `0.31`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Mini Tablet`.
    temp8-productid = `HT-9993`.
    temp8-category = `Tablets`.
    temp8-suppliername = `Quimica Madrilenos`.
    temp8-price = `833.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.48`.
    temp8-height = `0.05`.
    temp8-depth = `0.31`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Camcorder View`.
    temp8-productid = `HT-9994`.
    temp8-category = `Camcorders`.
    temp8-suppliername = `Florida Holiday Company`.
    temp8-price = `1388.0`.
    temp8-currencycode = `USD`.
    temp8-width = `0.48`.
    temp8-height = `0.27`.
    temp8-depth = `0.31`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Smartphone Cover`.
    temp8-productid = `HT-9995`.
    temp8-category = `Accessories`.
    temp8-suppliername = `Russian Electronic Trading Company`.
    temp8-price = `15.0`.
    temp8-currencycode = `RUB`.
    temp8-width = `0.48`.
    temp8-height = `0.05`.
    temp8-depth = `0.31`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Tablet Pouch`.
    temp8-productid = `HT-9996`.
    temp8-category = `Accessories`.
    temp8-suppliername = `Pateu`.
    temp8-price = `20.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.25`.
    temp8-height = `0.05`.
    temp8-depth = `0.4`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `e-Book Reader ReadMe`.
    temp8-productid = `HT-9997`.
    temp8-category = `Tablets`.
    temp8-suppliername = `Compostela`.
    temp8-price = `633.0`.
    temp8-currencycode = `ARS`.
    temp8-width = `0.48`.
    temp8-height = `0.05`.
    temp8-depth = `0.31`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Smartphone Beta`.
    temp8-productid = `HT-9998`.
    temp8-category = `Smartphones`.
    temp8-suppliername = `Meliva`.
    temp8-price = `699.0`.
    temp8-currencycode = `EUR`.
    temp8-width = `0.48`.
    temp8-height = `0.05`.
    temp8-depth = `0.31`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    temp8-name = `Maxi Tablet`.
    temp8-productid = `HT-9999`.
    temp8-category = `Tablets`.
    temp8-suppliername = `Mexican Oil Trading Company`.
    temp8-price = `749.0`.
    temp8-currencycode = `MXN`.
    temp8-width = `0.48`.
    temp8-height = `0.05`.
    temp8-depth = `0.31`.
    temp8-dimunit = `M`.
    INSERT temp8 INTO TABLE temp7.
    t_products = temp7.

  ENDMETHOD.

ENDCLASS.
