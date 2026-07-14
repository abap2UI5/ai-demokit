"! Generated port of a UI5 demo kit sample - not yet manually reviewed
"! Rebuild of the UI5 demo kit sample: https://sdk.openui5.org/entity/sap.m.IconTabBar/sample/sap.m.sample.IconTabBarOverflowSelectList
"! In this example when there is not enough space for all tab items to fit on the screen, the rest
"! are displayed in an overflow select list for easier selection.
CLASS z2ui5_cl_api_app_432 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_432 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(page) = z2ui5_cl_xml_view=>factory( ).

    " the original adds the 30 tabs in the controller on init - they are created in a loop instead
    DATA(tab_items) = page->icon_tab_bar(
                          id    = `idIconTabBar`
                          class = `sapUiResponsiveContentPadding`
                          )->items( ).
    DO 30 TIMES.
      tab_items->icon_tab_filter(
          text = |Tab { sy-index }|
          key  = |{ sy-index }|
          )->text( |Content { sy-index }| ).
    ENDDO.

    client->view_display( page->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
