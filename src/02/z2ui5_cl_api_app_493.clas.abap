"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.ui.core.StandardMargins - StandardMarginsEnforceWidthAuto
"! https://sdk.openui5.org/entity/sap.ui.core.StandardMargins/sample/sap.m.sample.StandardMarginsEnforceWidthAuto
CLASS z2ui5_cl_api_app_493 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    METHODS view_display
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_493 IMPLEMENTATION.

  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( ).

    " the original binds the expanded property against the device model - here it is set directly
    DATA(tab_items) = page->icon_tab_bar(
                          expanded = abap_true
                          class    = `sapUiForceWidthAuto sapUiSmallMargin`
                          )->items( ).

    " the original defines the form title via a core:Title aggregation - here the title property is used
    tab_items->icon_tab_filter(
        key  = `info`
        text = `Info`
        )->simple_form(
            title  = `A Form`
            layout = `ResponsiveGridLayout`
            )->content( `form`
            )->label( `Label`
            )->text( `Value` ).

    tab_items->icon_tab_filter(
        key  = `attachments`
        text = `Attachments`
        )->list(
            headertext     = `A List`
            showseparators = `Inner` ).

    tab_items->icon_tab_filter(
        key  = `notes`
        text = `Notes`
        )->feed_input( ).

    DATA(info_text) = `The IconTabBar above does not have a width property and renders a default width of '100%'. ` &&
      `Therefore we use margin class 'sapUiForceWidthAuto' to set its width to 'auto'. ` &&
      `To clear a 16px (1rem) space all around, we use class 'sapUiSmallMargin'.`.
    page->text(
        text  = info_text
        class = `sapUiExploredNoMarginInfo` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      view_display( client ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
