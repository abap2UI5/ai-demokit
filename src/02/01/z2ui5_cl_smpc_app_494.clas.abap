" @keywords combobox combo box sap.m comboboxmaxpickerheight verticallayout label item
" @summary Limit the picker popup height using maxPickerHeight property
CLASS z2ui5_cl_smpc_app_494 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_item,
             key  TYPE string,
             text TYPE string,
           END OF ty_s_item.
    TYPES ty_t_item TYPE STANDARD TABLE OF ty_s_item WITH EMPTY KEY.

    DATA t_items TYPE ty_t_item.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_494 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( `Page`
            )->a( n = `showHeader` v = `false`
            )->a( n = `class`      v = `sapUiContentPadding`

            )->ele( `content`
                )->ele( n = `VerticalLayout` ns = `l`

                    )->tag( `Label`
                        )->a( n = `text`     v = `ComboBox without maxPickerHeight`
                        )->a( n = `labelFor` v = `idComboBoxDefault`
                    )->ele( `ComboBox`
                        )->a( n = `class` v = `sapUiSmallMarginBottom`
                        )->a( n = `id`    v = `idComboBoxDefault`
                        )->a( n = `items` v = client->_bind( t_items )

                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `{KEY}`
                            )->a( n = `text` v = `{TEXT}`

                    )->end(

                    )->tag( `Label`
                        )->a( n = `text`     v = `ComboBox with maxPickerHeight='300px'`
                        )->a( n = `labelFor` v = `idComboBox300px`
                    )->ele( `ComboBox`
                        )->a( n = `class` v = `sapUiSmallMarginBottom`
                        )->a( n = `id`    v = `idComboBox300px`
                        )->a( n = `maxPickerHeight` v = `300px`
                        )->a( n = `items` v = client->_bind( t_items )

                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `{KEY}`
                            )->a( n = `text` v = `{TEXT}`

                    )->end(

                    )->tag( `Label`
                        )->a( n = `text`     v = `ComboBox with maxPickerHeight='15rem'`
                        )->a( n = `labelFor` v = `idComboBox15rem`
                    )->ele( `ComboBox`
                        )->a( n = `class` v = `sapUiSmallMarginBottom`
                        )->a( n = `id`    v = `idComboBox15rem`
                        )->a( n = `maxPickerHeight` v = `15rem`
                        )->a( n = `items` v = client->_bind( t_items )

                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `{KEY}`
                            )->a( n = `text` v = `{TEXT}`

                    )->end(

                    )->tag( `Label`
                        )->a( n = `text`     v = `ComboBox with maxPickerHeight='150px' and value state`
                        )->a( n = `labelFor` v = `idComboBoxWithValueState`
                    )->ele( `ComboBox`
                        )->a( n = `class` v = `sapUiSmallMarginBottom`
                        )->a( n = `id`    v = `idComboBoxWithValueState`
                        )->a( n = `maxPickerHeight` v = `150px`
                        )->a( n = `valueState`      v = `Information`
                        )->a( n = `valueStateText`  v = `The maxPickerHeight property limits the picker popup height. When items exceed this height, the picker becomes scrollable.`
                        )->a( n = `items` v = client->_bind( t_items )

                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `{KEY}`
                            )->a( n = `text` v = `{TEXT}` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " onInit builds 100 items (key item<n>, text Item <n>) to make the picker scroll
    DO 100 TIMES.
      DATA(index) = sy-index.
      INSERT VALUE #( key = |item{ index }| text = |Item { index }| ) INTO TABLE t_items.
    ENDDO.

  ENDMETHOD.

ENDCLASS.
