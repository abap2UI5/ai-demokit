" @keywords overflowtoolbar overflow toolbar sap.m design style selection label select button
CLASS z2ui5_cl_smpc_app_086 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_s_key,
        key TYPE string,
      END OF ty_s_key.
    DATA t_design_types TYPE STANDARD TABLE OF ty_s_key WITH EMPTY KEY.
    DATA t_style_types  TYPE STANDARD TABLE OF ty_s_key WITH EMPTY KEY.
    DATA design         TYPE string.
    DATA style          TYPE string.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.
    METHODS model_init.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_086 IMPLEMENTATION.

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
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:form` v = `sap.ui.layout.form`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( `Page`
            )->a( n = `showHeader` v = `false`

            )->ele( `content`
                )->ele( n = `SimpleForm` ns = `form`
                    )->a( n = `editable` v = `true`
                    )->a( n = `width`    v = `320px`
                    )->a( n = `layout`   v = `ColumnLayout`

                    )->tag( `Label`
                        )->a( n = `text` v = `Design`
                    )->ele( `Select`
                        )->a( n = `selectedKey` v = client->_bind( design )
                        )->a( n = `items`       v = client->_bind( t_design_types )
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `{KEY}`
                            )->a( n = `text` v = `{KEY}`

                    )->end(
                    )->tag( `Label`
                        )->a( n = `text` v = `Style`
                    )->ele( `Select`
                        )->a( n = `selectedKey` v = client->_bind( style )
                        )->a( n = `items`       v = client->_bind( t_style_types )
                        )->tag( n = `Item` ns = `core`
                            )->a( n = `key`  v = `{KEY}`
                            )->a( n = `text` v = `{KEY}`

                    )->end(
                )->end(

                )->ele( `OverflowToolbar`
                    )->a( n = `id`     v = `contentTb`
                    )->a( n = `class`  v = `sapUiSmallMarginTop`
                    " onSelectDesign/onSelectStyle setDesign/setStyle become two-way bound design/style
                    )->a( n = `design` v = client->_bind( design )
                    )->a( n = `style`  v = client->_bind( style )
                    )->tag( `Label`
                        )->a( n = `text` v = `Toolbar content `
                    " bActionContext (selected design is not Info) is an expression over the bound design
                    )->tag( `Button`
                        )->a( n = `text`    v = `Action1`
                        )->a( n = `visible` v = |\{= ${ client->_bind( design ) } !== 'Info' \}|
                    )->tag( `Button`
                        )->a( n = `text`    v = `Action2`
                        )->a( n = `visible` v = |\{= ${ client->_bind( design ) } !== 'Info' \}|

                )->end(
            )->end(
        )->end( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " keys of sap.m.ToolbarDesign / sap.m.ToolbarStyle in Object.keys order (library.js declaration order)
    t_design_types = VALUE #( ( key = `Auto` ) ( key = `Transparent` ) ( key = `Info` ) ( key = `Solid` ) ).
    t_style_types  = VALUE #( ( key = `Standard` ) ( key = `Clear` ) ).
    design = `Auto`.
    style  = `Standard`.

  ENDMETHOD.

ENDCLASS.
