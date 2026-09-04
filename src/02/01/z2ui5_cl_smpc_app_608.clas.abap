" @keywords select sap.m select2columns title hbox label slider switch text listitem
" @summary Use the select dropdown list with two columns layout if you need to display additional information to your options, like e.g. currencies to countries or abbreviations to systems.
CLASS z2ui5_cl_smpc_app_608 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES: BEGIN OF ty_s_item,
             firstcolumntext  TYPE string,
             secondcolumntext TYPE string,
           END OF ty_s_item.
    TYPES ty_t_item TYPE STANDARD TABLE OF ty_s_item WITH DEFAULT KEY.

    DATA t_items1 TYPE ty_t_item.
    DATA t_items2 TYPE ty_t_item.

    DATA first_ratio     TYPE i VALUE 3.
    DATA second_ratio    TYPE i VALUE 2.
    DATA column_ratio    TYPE string.
    DATA ratio_text      TYPE string.
    DATA percentage_text TYPE string.
    DATA wrap_items      TYPE abap_bool.
    DATA separator       TYPE string.
    DATA editable        TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS on_event.
    METHODS ratio_apply.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_608 IMPLEMENTATION.

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
    DATA content TYPE REF TO z2ui5_cl_ui5_view_builder.
    view = z2ui5_cl_ui5_view_builder=>factory( ).

    
    content = view->ele( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`

        )->ele( `Page`
            )->a( n = `showHeader` v = `false`
            )->a( n = `class`      v = `sapUiResponsivePadding--content`
            )->ele( `content` ).

    content->ele( `VBox`
        )->a( n = `width` v = `300px`
        )->a( n = `class` v = `sapUiSmallMarginTop`

        )->tag( `Title`
            )->a( n = `text` v = `Basic configuration:`

        )->ele( `HBox`
            )->a( n = `alignItems` v = `Center`
            )->tag( `Label`
                )->a( n = `text`  v = `First column ratio:`
                )->a( n = `class` v = `sapUiTinyMarginEnd`
            " setCorrectData composes columnRatio and the two texts from the two
            " slider values; the sliders are bound and the change recomputes them
            )->tag( `Slider`
                )->a( n = `width`  v = `200px`
                )->a( n = `id`     v = `firstSlider`
                )->a( n = `value`  v = client->_bind( first_ratio )
                )->a( n = `change` v = client->_event( `RATIO` )
        )->end(

        )->ele( `HBox`
            )->a( n = `alignItems` v = `Center`
            )->tag( `Label`
                )->a( n = `text`  v = `Second column ratio:`
                )->a( n = `class` v = `sapUiTinyMarginEnd`
            )->tag( `Slider`
                )->a( n = `width`  v = `200px`
                )->a( n = `id`     v = `secondSlider`
                )->a( n = `value`  v = client->_bind( second_ratio )
                )->a( n = `change` v = client->_event( `RATIO` )
        )->end(

        )->ele( `HBox`
            )->a( n = `alignItems` v = `Center`
            )->tag( `Label`
                )->a( n = `text`  v = `Wrap items text:`
                )->a( n = `class` v = `sapUiTinyMarginEnd`
            " fnSwitch sets select.wrapItemsText( state ) - both are bindable, so
            " the Switch and the Select share one flag
            )->tag( `Switch`
                )->a( n = `type`  v = `AcceptReject`
                )->a( n = `state` v = client->_bind( wrap_items )
        )->end(

        )->tag( `Title`
            )->a( n = `text`  v = `Result:`
            )->a( n = `class` v = `sapUiSmallMarginTop`

        )->ele( `HBox`
            )->tag( `Label`
                )->a( n = `class` v = `sapUiTinyMarginEnd`
                )->a( n = `text`  v = `Current column ratio:`
            )->tag( `Text`
                )->a( n = `id`   v = `text1`
                )->a( n = `text` v = client->_bind( ratio_text )
        )->end(

        )->ele( `HBox`
            )->tag( `Label`
                )->a( n = `class` v = `sapUiTinyMarginEnd`
                )->a( n = `text`  v = `Current column ratio in percentages:`
            )->tag( `Text`
                )->a( n = `id`   v = `text2`
                )->a( n = `text` v = client->_bind( percentage_text )
        )->end(

        )->ele( `Select`
            )->a( n = `id`                   v = `select`
            )->a( n = `showSecondaryValues`  v = `true`
            )->a( n = `columnRatio`          v = client->_bind( column_ratio )
            )->a( n = `wrapItemsText`        v = client->_bind( wrap_items )
            )->a( n = `items`                v = client->_bind( t_items1 )
            )->ele( `items`
                )->tag( n = `ListItem` ns = `core`
                    )->a( n = `text`           v = `{FIRSTCOLUMNTEXT}`
                    )->a( n = `additionalText` v = `{SECONDCOLUMNTEXT}`
            )->end(
        )->end(
    )->end( ).

    content->ele( `VBox`
        )->a( n = `width` v = `300px`
        )->a( n = `class` v = `sapUiSmallMarginTop`

        )->tag( `Title`
            )->a( n = `text` v = `Separator configuration:`

        )->ele( `HBox`
            )->a( n = `alignItems` v = `Center`
            )->tag( `Label`
                )->a( n = `text`  v = `Two column separator:`
                )->a( n = `class` v = `sapUiTinyMarginEnd`
            " fnTwoColumnSeparatorChange copies the picked key onto select2's
            " twoColumnSeparator - both bindable, so they share one field
            )->ele( `Select`
                )->a( n = `id`          v = `selectSeparator`
                )->a( n = `selectedKey` v = client->_bind( separator )
                )->tag( n = `ListItem` ns = `core`
                    )->a( n = `key`  v = `Dash`
                    )->a( n = `text` v = `Dash`
                )->tag( n = `ListItem` ns = `core`
                    )->a( n = `key`  v = `Bullet`
                    )->a( n = `text` v = `Bullet`
                )->tag( n = `ListItem` ns = `core`
                    )->a( n = `key`  v = `VerticalLine`
                    )->a( n = `text` v = `VerticalLine`
            )->end(
        )->end(

        )->ele( `HBox`
            )->a( n = `alignItems` v = `Center`
            )->tag( `Label`
                )->a( n = `text`  v = `Editable:`
                )->a( n = `class` v = `sapUiTinyMarginEnd`
            " fnSwitchEditableChange sets select2.editable( state ) - one flag
            )->tag( `Switch`
                )->a( n = `id`    v = `switchEditable`
                )->a( n = `state` v = client->_bind( editable )
        )->end(

        )->tag( `Title`
            )->a( n = `text`  v = `Result:`
            )->a( n = `class` v = `sapUiSmallMarginTop`

        )->ele( `Select`
            )->a( n = `width`               v = `100%`
            )->a( n = `id`                  v = `select2`
            )->a( n = `showSecondaryValues` v = `true`
            )->a( n = `editable`            v = client->_bind( editable )
            )->a( n = `twoColumnSeparator`  v = client->_bind( separator )
            )->a( n = `items`               v = client->_bind( t_items2 )
            )->ele( `items`
                )->tag( n = `ListItem` ns = `core`
                    )->a( n = `text`           v = `{FIRSTCOLUMNTEXT}`
                    )->a( n = `additionalText` v = `{SECONDCOLUMNTEXT}`
            )->end(
        )->end(
    )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    IF client->get_event( ) = `RATIO`.
      ratio_apply( ).
    ENDIF.

  ENDMETHOD.


  METHOD ratio_apply.

    " setCorrectData: columnRatio "<a>:<b>", the ratio text and the percentages,
    " the second of which is 100 minus the rounded first
    DATA total TYPE i.
    DATA temp1 TYPE i.
    DATA first_pct LIKE temp1.
    total = first_ratio + second_ratio.
    IF total = 0.
      RETURN.
    ENDIF.

    
    temp1 = round( val = first_ratio * 100 / total dec = 0 ).
    
    first_pct = temp1.

    column_ratio    = |{ first_ratio }:{ second_ratio }|.
    ratio_text      = column_ratio.
    percentage_text = |{ first_pct }%:{ 100 - first_pct }%|.

  ENDMETHOD.


  METHOD model_init.

    " onInit builds ten items per Select: the first column's text repeated five
    " times plus the row number, and the same for the second column
    DATA temp2 TYPE z2ui5_cl_smpc_app_608=>ty_t_item.
    DATA temp3 LIKE LINE OF temp2.
    DATA temp4 TYPE z2ui5_cl_smpc_app_608=>ty_t_item.
    DATA temp5 LIKE LINE OF temp4.
    CLEAR temp2.
    
    temp3-firstcolumntext = `First column text First column text First column text First column text First column text  1`.
    temp3-secondcolumntext = `Second column text Second column text Second column text Second column text Second column text  1`.
    INSERT temp3 INTO TABLE temp2.
    temp3-firstcolumntext = `First column text First column text First column text First column text First column text  2`.
    temp3-secondcolumntext = `Second column text Second column text Second column text Second column text Second column text  2`.
    INSERT temp3 INTO TABLE temp2.
    temp3-firstcolumntext = `First column text First column text First column text First column text First column text  3`.
    temp3-secondcolumntext = `Second column text Second column text Second column text Second column text Second column text  3`.
    INSERT temp3 INTO TABLE temp2.
    temp3-firstcolumntext = `First column text First column text First column text First column text First column text  4`.
    temp3-secondcolumntext = `Second column text Second column text Second column text Second column text Second column text  4`.
    INSERT temp3 INTO TABLE temp2.
    temp3-firstcolumntext = `First column text First column text First column text First column text First column text  5`.
    temp3-secondcolumntext = `Second column text Second column text Second column text Second column text Second column text  5`.
    INSERT temp3 INTO TABLE temp2.
    temp3-firstcolumntext = `First column text First column text First column text First column text First column text  6`.
    temp3-secondcolumntext = `Second column text Second column text Second column text Second column text Second column text  6`.
    INSERT temp3 INTO TABLE temp2.
    temp3-firstcolumntext = `First column text First column text First column text First column text First column text  7`.
    temp3-secondcolumntext = `Second column text Second column text Second column text Second column text Second column text  7`.
    INSERT temp3 INTO TABLE temp2.
    temp3-firstcolumntext = `First column text First column text First column text First column text First column text  8`.
    temp3-secondcolumntext = `Second column text Second column text Second column text Second column text Second column text  8`.
    INSERT temp3 INTO TABLE temp2.
    temp3-firstcolumntext = `First column text First column text First column text First column text First column text  9`.
    temp3-secondcolumntext = `Second column text Second column text Second column text Second column text Second column text  9`.
    INSERT temp3 INTO TABLE temp2.
    temp3-firstcolumntext = `First column text First column text First column text First column text First column text  10`.
    temp3-secondcolumntext = `Second column text Second column text Second column text Second column text Second column text  10`.
    INSERT temp3 INTO TABLE temp2.
    t_items1 = temp2.

    
    CLEAR temp4.
    
    temp5-firstcolumntext = `First column text`.
    temp5-secondcolumntext = `Second column text`.
    INSERT temp5 INTO TABLE temp4.
    temp5-firstcolumntext = `First column text`.
    temp5-secondcolumntext = `Second column text`.
    INSERT temp5 INTO TABLE temp4.
    temp5-firstcolumntext = `First column text`.
    temp5-secondcolumntext = `Second column text`.
    INSERT temp5 INTO TABLE temp4.
    temp5-firstcolumntext = `First column text`.
    temp5-secondcolumntext = `Second column text`.
    INSERT temp5 INTO TABLE temp4.
    temp5-firstcolumntext = `First column text`.
    temp5-secondcolumntext = `Second column text`.
    INSERT temp5 INTO TABLE temp4.
    temp5-firstcolumntext = `First column text`.
    temp5-secondcolumntext = `Second column text`.
    INSERT temp5 INTO TABLE temp4.
    temp5-firstcolumntext = `First column text`.
    temp5-secondcolumntext = `Second column text`.
    INSERT temp5 INTO TABLE temp4.
    temp5-firstcolumntext = `First column text`.
    temp5-secondcolumntext = `Second column text`.
    INSERT temp5 INTO TABLE temp4.
    temp5-firstcolumntext = `First column text`.
    temp5-secondcolumntext = `Second column text`.
    INSERT temp5 INTO TABLE temp4.
    temp5-firstcolumntext = `First column text`.
    temp5-secondcolumntext = `Second column text`.
    INSERT temp5 INTO TABLE temp4.
    t_items2 = temp4.

    " the sliders' own initial values, and the state setCorrectData would leave
    first_ratio  = 3.
    second_ratio = 2.
    ratio_apply( ).

    " the separator Select has no selectedKey in the sample, so its first item
    " is the one that shows; select2 starts editable="false"
    separator = `Dash`.
    editable  = abap_false.

  ENDMETHOD.

ENDCLASS.
