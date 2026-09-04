" @keywords gridlist grid list sap.f selection modes html hbox segmentedbutton segmentedbuttonitem gridbasiclayout gridlistitem
" @summary This is a sample for GridList with different modes of selection.
CLASS z2ui5_cl_smpc_app_133 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_product,
        description   TYPE string,
        name          TYPE string,
        productpicurl TYPE string,
        status        TYPE string,
        type          TYPE string,
        quantity      TYPE i,
        onlyimage     TYPE abap_bool,
      END OF ty_product.
    DATA t_products  TYPE STANDARD TABLE OF ty_product WITH DEFAULT KEY.
    DATA mode        TYPE string.
    DATA header_text TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_133 IMPLEMENTATION.

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
    DATA temp3 TYPE string_table.
    DATA temp4 TYPE string_table.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    CLEAR temp1.
    INSERT `MESSAGE_TOAST` INTO TABLE temp1.
    INSERT `show` INTO TABLE temp1.
    INSERT `{0?Selected:Unselected} item with ID {1}` INTO TABLE temp1.
    INSERT `${$parameters>/selected}` INTO TABLE temp1.
    INSERT `${$parameters>/listItem}.getId()` INTO TABLE temp1.
    
    CLEAR temp2.
    INSERT `MESSAGE_TOAST` INTO TABLE temp2.
    INSERT `show` INTO TABLE temp2.
    INSERT `Delete item with ID {0}` INTO TABLE temp2.
    INSERT `${$parameters>/listItem}.getId()` INTO TABLE temp2.
    
    CLEAR temp3.
    INSERT `MESSAGE_TOAST` INTO TABLE temp3.
    INSERT `show` INTO TABLE temp3.
    INSERT `Request details for item with ID {0}` INTO TABLE temp3.
    INSERT `$event.oSource.sId` INTO TABLE temp3.
    
    CLEAR temp4.
    INSERT `MESSAGE_TOAST` INTO TABLE temp4.
    INSERT `show` INTO TABLE temp4.
    INSERT `Pressed item with ID {0}` INTO TABLE temp4.
    INSERT `$event.oSource.sId` INTO TABLE temp4.
    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:grid` v = `sap.ui.layout.cssgrid`
        )->a( n = `xmlns:f`    v = `sap.f`
        )->a( n = `xmlns:core`  v = `sap.ui.core`

        " the sample's own main.css, injected as a style leaf (apps 122/124):
        " the view carries the imageDisplayBlock class and the rule behind it
        " has to come with it. \{ \} in a backtick literal: the XMLView parser
        " reads an unescaped brace as a binding
        )->tag( n = `HTML` ns = `core`
            )->a( n = `content` v = `<style>.imageDisplayBlock\{display:block\}</style>`

        )->ele( `HBox`
            )->a( n = `justifyContent` v = `End`

            )->ele( `SegmentedButton`
                )->a( n = `selectedKey`      v = client->_bind( mode )
                )->a( n = `class`            v = `sapUiSmallMarginTop sapUiSmallMarginEnd`
                )->a( n = `selectionChange`  v = client->_event( `MODE_CHANGE` )

                )->ele( `items`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `width` v = `auto`
                        )->a( n = `text`  v = `MultiSelect`
                        )->a( n = `key`   v = `MultiSelect`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `width` v = `auto`
                        )->a( n = `text`  v = `SingleSelect`
                        )->a( n = `key`   v = `SingleSelect`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `width` v = `auto`
                        )->a( n = `text`  v = `SingleSelectLeft`
                        )->a( n = `key`   v = `SingleSelectLeft`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `width` v = `auto`
                        )->a( n = `text`  v = `SingleSelectMaster`
                        )->a( n = `key`   v = `SingleSelectMaster`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `width` v = `auto`
                        )->a( n = `text`  v = `Delete`
                        )->a( n = `key`   v = `Delete`
                    )->tag( `SegmentedButtonItem`
                        )->a( n = `width` v = `auto`
                        )->a( n = `text`  v = `None`
                        )->a( n = `key`   v = `None`

                )->end(
            )->end(
        )->end(

        )->ele( n = `GridList` ns = `f`
            )->a( n = `id`              v = `gridList`
            )->a( n = `headerText`      v = client->_bind( header_text )
            )->a( n = `mode`            v = client->_bind( mode )
            )->a( n = `items`           v = client->_bind( t_products )
            )->a( n = `selectionChange` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                      t_arg = temp1 )
            )->a( n = `delete`          v = client->follow_up_action( val   = client->cs_event-control_global
                                                                      t_arg = temp2 )
            )->a( n = `class`           v = `sapUiResponsiveContentPadding`

            )->ele( n = `customLayout` ns = `f`
                )->tag( n = `GridBasicLayout` ns = `grid`
                    )->a( n = `gridTemplateColumns` v = `repeat(auto-fit, minmax(16rem, 1fr))`
                    )->a( n = `gridGap`             v = `0.5rem`

            )->end(

            )->ele( n = `GridListItem` ns = `f`
                )->a( n = `detailPress` v = client->follow_up_action( val   = client->cs_event-control_global
                                                                      t_arg = temp3 )
                )->a( n = `press`       v = client->follow_up_action( val   = client->cs_event-control_global
                                                                      t_arg = temp4 )
                )->a( n = `counter`     v = `{QUANTITY}`
                )->a( n = `highlight`   v = `{STATUS}`
                )->a( n = `type`        v = `{TYPE}`

                )->ele( `VBox`
                    )->a( n = `height` v = `100%`

                    )->tag( `Image`
                        )->a( n = `src`     v = `{PRODUCTPICURL}`
                        )->a( n = `width`   v = `100%`
                        )->a( n = `visible` v = `{= ${ONLYIMAGE} ? true : false }`
                        )->a( n = `class`   v = `imageDisplayBlock`
                    )->ele( `HBox`
                        )->a( n = `height`     v = `100%`
                        )->a( n = `class`      v = `sapUiSmallMargin`
                        )->a( n = `alignItems` v = `Center`
                        )->a( n = `visible`    v = `{= ${ONLYIMAGE} ? false : true }`

                        )->tag( `Image`
                            )->a( n = `src`   v = `{PRODUCTPICURL}`
                            )->a( n = `width` v = `3rem`
                            )->a( n = `class` v = `sapUiSmallMarginEnd`
                        )->ele( `VBox`
                            )->tag( `Title`
                                )->a( n = `text`     v = `{NAME}`
                                )->a( n = `wrapping` v = `true`
                            )->tag( `Label`
                                )->a( n = `text`     v = `{DESCRIPTION}`
                                )->a( n = `wrapping` v = `true` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `MODE_CHANGE`.
      " original onModeChange: setMode(key) + setHeaderText('GridList with mode ' + key)
      header_text = |GridList with mode { mode }|.
    ENDIF.

  ENDMETHOD.


  METHOD model_init.
    DATA temp3 LIKE t_products.
    DATA temp4 LIKE LINE OF temp3.

    mode        = `MultiSelect`.
    header_text = `GridList with mode MultiSelect`.

    " Product rows from the sample's model/data.json (11 items). Absent enum
    " values are substituted with their UI5 defaults so the bound enum
    " properties stay valid: type -> 'Inactive', Status/highlight -> 'None'
    " (both render identically to the original's undefined fields).
    
    CLEAR temp3.
    
    temp4-name = `Notebook Basic 15`.
    temp4-description = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1000.jpg`.
    temp4-status = `Information`.
    temp4-type = `DetailAndActive`.
    temp4-quantity = 24.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 17`.
    temp4-description = `Notebook Basic 17 with 2,80 GHz quad core, 17" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1001.jpg`.
    temp4-status = `Success`.
    temp4-type = `DetailAndActive`.
    temp4-quantity = 14.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 18`.
    temp4-description = `Notebook Basic 18 with 2,80 GHz quad core, 18" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1002.jpg`.
    temp4-status = `Success`.
    temp4-type = `Inactive`.
    temp4-quantity = 37.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Basic 19`.
    temp4-description = `Notebook Basic 19 with 2,80 GHz quad core, 19" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1003.jpg`.
    temp4-status = `Warning`.
    temp4-type = `Inactive`.
    temp4-quantity = 2.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault`.
    temp4-description = `Digital Organizer with State-of-the-Art Storage Encryption`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1007.jpg`.
    temp4-status = `Error`.
    temp4-type = `Inactive`.
    temp4-quantity = 0.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Professional 15`.
    temp4-description = `Notebook Professional 15 with 2,80 GHz quad core, 15" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1010.jpg`.
    temp4-status = `None`.
    temp4-type = `Inactive`.
    temp4-quantity = 22.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Notebook Professional 17`.
    temp4-description = `Notebook Professional 17 with 2,80 GHz quad core, 17" Multitouch LCD, 8 GB DDR3 RAM, 500 GB SSD - DVD-Writer (DVD-R/+R/-RW/-RAM),Windows 8 Pro`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1011.jpg`.
    temp4-status = `None`.
    temp4-type = `Inactive`.
    temp4-quantity = 31.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault Net`.
    temp4-description = `Digital Organizer with State-of-the-Art Encryption for Storage and Network Communications`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1020.jpg`.
    temp4-status = `None`.
    temp4-type = `Inactive`.
    temp4-quantity = 14.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `ITelO Vault SAT`.
    temp4-description = `Digital Organizer with State-of-the-Art Encryption for Storage and Secure Stellite Link`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1021.jpg`.
    temp4-status = `None`.
    temp4-type = `Inactive`.
    temp4-quantity = 50.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Comfort Easy`.
    temp4-description = `32 GB Digital Assistant with high-resolution color screen`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1022.jpg`.
    temp4-status = `None`.
    temp4-type = `Inactive`.
    temp4-quantity = 30.
    INSERT temp4 INTO TABLE temp3.
    temp4-name = `Ultra Jet Super Highspeed`.
    temp4-description = `4800 dpi x 1200 dpi - up to 35 ppm (mono) / up to 34 ppm (color) - capacity: 250 sheets - Hi-Speed USB2.0, Ethernet`.
    temp4-productpicurl = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/HT-1065.jpg`.
    temp4-status = `None`.
    temp4-type = `Navigation`.
    temp4-quantity = 25.
    temp4-onlyimage = abap_true.
    INSERT temp4 INTO TABLE temp3.
    t_products = temp3.

  ENDMETHOD.

ENDCLASS.
