"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.Page - PageListReportIconTabBar
"! https://sdk.openui5.org/entity/sap.m.Page/sample/sap.m.sample.PageListReportIconTabBar
CLASS z2ui5_cl_api_app_406 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_406 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page2) = view->page( title           = `Title`
                              enablescrolling = abap_true
                              class           = `sapUiResponsivePadding--header sapUiResponsivePadding--footer` ).

    DATA(vbox) = page2->content( )->vbox( fitcontainer = abap_true ).

    DATA(form) = vbox->simple_form( id         = `SimpleFormDisplay480`
                                    editable   = abap_false
                                    layout     = `ResponsiveGridLayout`
                                    title      = `Address`
                                    labelspanl = `4`
                                    labelspanm = `4`
                                    emptyspanl = `0`
                                    emptyspanm = `0`
                                    columnsl   = `2`
                                    columnsm   = `2` ).
    form->content( `form`
        )->title( ns   = `core`
                  text = `Office`
        )->label( `Name`
        )->text( `Red Point Stores`
        )->label( `Street/No.`
        )->text( `Main St 1618`
        )->label( `ZIP Code/City`
        )->text( `31415 Maintown`
        )->label( `Country`
        )->text( `Germany`
        )->title( ns   = `core`
                  text = `Online`
        )->label( `Web`
        )->text( `http://www.sap.com`
        )->label( `Twitter`
        )->text( `@sap` ).
    form->layout_data( `form`
        )->flex_item_data( shrinkfactor     = `0`
                           backgrounddesign = `Solid`
                           styleclass       = `sapContrastPlus` ).

    DATA(itb) = vbox->icon_tab_bar( uppercase            = abap_true
                                    expandable           = abap_false
                                    applycontentpadding  = abap_true
                                    stretchcontentheight = abap_true
                                    class                = `sapUiResponsiveContentPadding` ).
    itb->items(
       )->icon_tab_filter( key  = `balances`
                           text = `Balances` )->get_parent(
       )->icon_tab_filter( key  = `compare`
                           text = `Compare` ).

    " sap.ui.table.AnalyticalTable (deprecated) replaced by sap.ui.table.Table
    " rowMode with sap.ui.table.rowmodes.Auto (since 1.119) replaced by visibleRowCountMode/rowHeight
    DATA(tab) = itb->content(
                   )->ui_table( selectionmode       = `MultiToggle`
                                visiblerowcountmode = `Auto`
                                rowheight           = `32` ).
    tab->ui_extension(
       )->overflow_toolbar(
           )->toolbar_spacer(
           )->search_field( width = `12rem`
           )->toolbar_spacer( width = `1rem`
           )->segmented_button(
               )->items(
                   )->segmented_button_item( icon = `sap-icon://table-view`
                   )->segmented_button_item( icon = `sap-icon://bar-chart` )->get_parent( )->get_parent(
           )->toolbar_spacer( width = `1rem`
           )->button( icon = `sap-icon://group-2`
                      type = `Transparent`
           )->button( icon = `sap-icon://action-settings`
                      type = `Transparent` ).
    tab->ui_columns(
       )->ui_column( )->get_parent(
       )->ui_column( )->get_parent(
       )->ui_column( )->get_parent(
       )->ui_column( ).

    itb->layout_data(
       )->flex_item_data( growfactor = `1`
                          basesize   = `0%` ).

    page2->footer(
        )->overflow_toolbar(
            )->content(
                )->toolbar_spacer(
                )->button( text = `Grouped View`
                )->button( text = `Classical Table` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
