" @keywords table sap.m tablecolumnwidth messagestrip toolbar title checkbox column input columnlistitem fixedlayout
CLASS z2ui5_cl_smpc_app_567 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_product,
             name         TYPE string,
             suppliername TYPE string,
             description  TYPE string,
           END OF ty_s_product.
    TYPES ty_t_product TYPE STANDARD TABLE OF ty_s_product WITH EMPTY KEY.

    TYPES: BEGIN OF ty_s_column,
             width          TYPE string,
             header         TYPE string,
             demandpopin    TYPE abap_bool,
             minscreenwidth TYPE string,
             styleclass     TYPE string,
           END OF ty_s_column.
    TYPES ty_t_column TYPE STANDARD TABLE OF ty_s_column WITH EMPTY KEY.

    DATA t_products     TYPE ty_t_product.
    " the two column models: the clone gives its first column width auto, which
    " is what makes the first table the correct usage
    DATA t_clone        TYPE ty_t_column.
    DATA t_columns      TYPE ty_t_column.
    " onCheckBoxSelect: setFixedLayout( selected ? 'Strict' : true )
    DATA strict_layout  TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_567 IMPLEMENTATION.

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
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`

        )->tag( `MessageStrip`
            )->a( n = `text`     v = `Set the width of at least one column to auto or the fixedLayout property of the table to Strict.`
            )->a( n = `type`     v = `Success`
            )->a( n = `class`    v = `sapUiSmallMargin`
            )->a( n = `showIcon` v = `true`

        )->ele( `Table`
            )->a( n = `id`   v = `table`
            )->a( n = `mode` v = `MultiSelect`
            " setFixedLayout( selected ? 'Strict' : true ) - the property takes a
            " boolean OR the string Strict, so the expression yields both
            )->a( n = `fixedLayout` v = |\{= ${ client->_bind( strict_layout ) } ? 'Strict' : true \}|
            )->a( n = `items`       v = client->_bind( t_products )
            )->a( n = `columns`     v = client->_bind( t_clone )

            )->ele( `headerToolbar`
                )->ele( `Toolbar`
                    )->tag( `Title`
                        )->a( n = `text`  v = `Products (Correct Usage)`
                        )->a( n = `level` v = `H2`
                    )->tag( `ToolbarSpacer`
                    )->tag( `CheckBox`
                        )->a( n = `text`     v = `Strict Layout`
                        )->a( n = `selected` v = client->_bind( strict_layout )

                )->end(
            )->end(
            )->ele( `columns`
                )->ele( `Column`
                    )->a( n = `width`          v = `{WIDTH}`
                    )->a( n = `styleClass`     v = `{STYLECLASS}`
                    )->a( n = `demandPopin`    v = `{DEMANDPOPIN}`
                    )->a( n = `minScreenWidth` v = `{MINSCREENWIDTH}`
                    )->a( n = `popinDisplay`   v = `WithoutHeader`

                    )->tag( `Input`
                        )->a( n = `value`       v = `{WIDTH}`
                        )->a( n = `description` v = `{HEADER}`

                )->end(
            )->end(
            )->ele( `items`
                )->ele( `ColumnListItem`
                    )->a( n = `vAlign` v = `Middle`
                    )->a( n = `type`   v = `Navigation`

                    )->ele( `cells`
                        )->tag( `Text`
                            )->a( n = `text`     v = `{NAME}`
                            )->a( n = `wrapping` v = `false`
                        )->tag( `Text`
                            )->a( n = `text`     v = `{SUPPLIERNAME}`
                            )->a( n = `wrapping` v = `false`
                        )->tag( `Text`
                            )->a( n = `text`     v = `{DESCRIPTION}`
                            )->a( n = `wrapping` v = `false`

                    )->end(
                )->end(
            )->end(
        )->end(

        )->tag( `MessageStrip`
            )->a( n = `text`     v = `Do not try to give percent width to all columns even if it reaches 100% total column width.`
            )->a( n = `type`     v = `Error`
            )->a( n = `class`    v = `sapUiLargeMarginTop sapUiSmallMargin`
            )->a( n = `showIcon` v = `true`

        )->ele( `Table`
            )->a( n = `mode`    v = `MultiSelect`
            )->a( n = `items`   v = client->_bind( t_products )
            )->a( n = `columns` v = client->_bind( t_columns )

            )->ele( `headerToolbar`
                )->ele( `OverflowToolbar`
                    )->tag( `Title`
                        )->a( n = `text`  v = `Products (Wrong Usage)`
                        )->a( n = `level` v = `H2`

                )->end(
            )->end(
            )->ele( `columns`
                )->ele( `Column`
                    )->a( n = `width`          v = `{WIDTH}`
                    )->a( n = `styleClass`     v = `{STYLECLASS}`
                    )->a( n = `demandPopin`    v = `{DEMANDPOPIN}`
                    )->a( n = `minScreenWidth` v = `{MINSCREENWIDTH}`
                    )->a( n = `popinDisplay`   v = `WithoutHeader`

                    )->tag( `Input`
                        )->a( n = `value`       v = `{WIDTH}`
                        )->a( n = `description` v = `{HEADER}`

                )->end(
            )->end(
            )->ele( `items`
                )->ele( `ColumnListItem`
                    )->a( n = `vAlign` v = `Middle`
                    )->a( n = `type`   v = `Navigation`

                    )->ele( `cells`
                        )->tag( `Text`
                            )->a( n = `text`     v = `{NAME}`
                            )->a( n = `wrapping` v = `false`
                        )->tag( `Text`
                            )->a( n = `text`     v = `{SUPPLIERNAME}`
                            )->a( n = `wrapping` v = `false`
                        )->tag( `Text`
                            )->a( n = `text`     v = `{DESCRIPTION}`
                            )->a( n = `wrapping` v = `false` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " setSizeLimit(3) on the products model - only the first three rows render
    t_products = VALUE #(
      ( name = `Notebook Basic 15` suppliername = `Very Best Screens`
        description = `Notebook Basic 15 with 2,80 GHz quad core, 15" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro` )
      ( name = `Notebook Basic 17` suppliername = `Very Best Screens`
        description = `Notebook Basic 17 with 2,80 GHz quad core, 17" LCD, 4 GB DDR3 RAM, 500 GB Hard Disc, Windows 8 Pro` )
      ( name = `Notebook Basic 18` suppliername = `Very Best Screens`
        description = `Notebook Basic 18 with 2,80 GHz quad core, 18" LCD, 8 GB DDR3 RAM, 1000 GB Hard Disc, Windows 8 Pro` ) ).

    " the controller's oData, and the deepExtend clone whose first width is auto
    t_columns = VALUE #(
      ( width = `30%` header = `Product Name`  demandpopin = abap_false minscreenwidth = `` styleclass = `cellBorderLeft cellBorderRight` )
      ( width = `20%` header = `Supplier Name` demandpopin = abap_false minscreenwidth = `` styleclass = `cellBorderRight` )
      ( width = `50%` header = `Description`   demandpopin = abap_true  minscreenwidth = `Tablet` styleclass = `cellBorderRight` ) ).

    t_clone = t_columns.
    t_clone[ 1 ]-width = `auto`.

  ENDMETHOD.

ENDCLASS.
