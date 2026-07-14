"! GENERATED ABAP CODE BASED ON UI5 DEMO KIT SAMPLE
"! sap.m.StandardListItem - StandardListItemTitle
"! https://sdk.openui5.org/entity/sap.m.StandardListItem/sample/sap.m.sample.StandardListItemTitle
CLASS z2ui5_cl_api_app_480 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_api_app_480 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(base_url) = `https://sdk.openui5.org/test-resources/sap/ui/documentation/sdk/images/`.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(list) = view->list( headertext = `Products` ).

    list->_generic(
        name   = `StandardListItem`
        t_prop = VALUE #( ( n = `title`            v = `Notebook Basic 15` )
                          ( n = `description`      v = `HT-1000` )
                          ( n = `icon`             v = base_url && `HT-1000.jpg` )
                          ( n = `iconDensityAware` v = `false` )
                          ( n = `iconInset`        v = `false` )
                          ( n = `adaptTitleSize`   v = `false` ) ) ).

    " set this item's description be empty
    list->_generic(
        name   = `StandardListItem`
        t_prop = VALUE #( ( n = `title`            v = `Notebook Basic 17` )
                          ( n = `description`      v = `` )
                          ( n = `icon`             v = base_url && `HT-1001.jpg` )
                          ( n = `iconDensityAware` v = `false` )
                          ( n = `iconInset`        v = `false` )
                          ( n = `adaptTitleSize`   v = `false` ) ) ).

    list->_generic(
        name   = `StandardListItem`
        t_prop = VALUE #( ( n = `title`            v = `Notebook Basic 18` )
                          ( n = `description`      v = `HT-1002` )
                          ( n = `icon`             v = base_url && `HT-1002.jpg` )
                          ( n = `iconDensityAware` v = `false` )
                          ( n = `iconInset`        v = `false` )
                          ( n = `adaptTitleSize`   v = `false` ) ) ).

    " don't specify a description for this item
    list->_generic(
        name   = `StandardListItem`
        t_prop = VALUE #( ( n = `title`            v = `Notebook Basic 19` )
                          ( n = `icon`             v = base_url && `HT-1003.jpg` )
                          ( n = `iconDensityAware` v = `false` )
                          ( n = `iconInset`        v = `false` )
                          ( n = `adaptTitleSize`   v = `false` ) ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
