CLASS z2ui5_cl_smpc_app_367 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_367 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      view_display( ).
    ELSEIF client->check_on_navigated( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns`      v = `sap.m`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:l`    v = `sap.ui.layout`

        )->ele( n = `VerticalLayout` ns = `l`
            )->a( n = `class` v = `sapUiContentPadding`
            )->a( n = `width` v = `100%`

            )->tag( `Input`
                )->a( n = `value`       v = `10`
                )->a( n = `description` v = `PC`
                )->a( n = `width`       v = `100px`
                )->a( n = `fieldWidth`  v = `60%`
                )->a( n = `class`       v = `sapUiSmallMarginBottom`
            )->tag( `Input`
                )->a( n = `value`       v = `220`
                )->a( n = `description` v = `EUR / 5 pieces`
                )->a( n = `width`       v = `200px`
                )->a( n = `fieldWidth`  v = `60px`
                )->a( n = `class`       v = `sapUiSmallMarginBottom`
            )->tag( `Input`
                )->a( n = `value`          v = `220.00`
                )->a( n = `description`    v = `EUR`
                )->a( n = `width`          v = `250px`
                )->a( n = `fieldWidth`     v = `80%`
                " showClearIcon is UI5 1.94 - kept for the 1:1 port (POST_171)
                )->a( n = `showClearIcon`  v = `true`
                )->a( n = `class`          v = `sapUiSmallMarginBottom`
            )->tag( `Input`
                )->a( n = `value`       v = `007`
                )->a( n = `description` v = `Bastian Schweinsteiger`
                )->a( n = `width`       v = `300px`
                )->a( n = `fieldWidth`  v = `50px`
                )->a( n = `class`       v = `sapUiSmallMarginBottom`
            )->tag( `Input`
                )->a( n = `value`           v = `EDP_LAPTOP`
                " ariaDescribedBy is UI5 1.90 on sap.m.Input - kept for the 1:1 port (POST_171)
                )->a( n = `ariaDescribedBy` v = `descriptionNodeId`
                )->a( n = `description`     v = `IT Laptops`
                )->a( n = `width`           v = `400px`
                )->a( n = `fieldWidth`      v = `75%`
                )->a( n = `class`           v = `sapUiSmallMarginBottom`
            )->tag( n = `InvisibleText` ns = `core`
                )->a( n = `id`   v = `descriptionNodeId`
                )->a( n = `text` v = `Additional input description refferenced by aria-describedby.` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
