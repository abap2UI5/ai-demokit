CLASS z2ui5_cl_ai_app_086 DEFINITION PUBLIC.

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


CLASS z2ui5_cl_ai_app_086 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      model_init( ).
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ai_xml=>factory( ).

    view->open( n = `View` ns = `mvc`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns:core` v = `sap.ui.core`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:form` v = `sap.ui.layout.form`
        )->a( n = `xmlns`      v = `sap.m`

        )->open( `Page`
            )->a( n = `showHeader` v = `false`

            )->open( `content`
                )->open( n = `SimpleForm` ns = `form`
                    )->a( n = `editable` v = `true`
                    )->a( n = `width`    v = `320px`
                    )->a( n = `layout`   v = `ColumnLayout`

                    )->leaf( `Label`
                        )->a( n = `text` v = `Design`
                    )->open( `Select`
                        )->a( n = `selectedKey` v = client->_bind( design )
                        )->a( n = `items`       v = client->_bind( t_design_types )
                        )->leaf( n = `Item` ns = `core`
                            )->a( n = `key`  v = `{KEY}`
                            )->a( n = `text` v = `{KEY}`

                    )->shut(
                    )->leaf( `Label`
                        )->a( n = `text` v = `Style`
                    )->open( `Select`
                        )->a( n = `selectedKey` v = client->_bind( style )
                        )->a( n = `items`       v = client->_bind( t_style_types )
                        )->leaf( n = `Item` ns = `core`
                            )->a( n = `key`  v = `{KEY}`
                            )->a( n = `text` v = `{KEY}`

                    )->shut(
                )->shut(

                )->open( `OverflowToolbar`
                    )->a( n = `id`     v = `contentTb`
                    )->a( n = `class`  v = `sapUiSmallMarginTop`
                    " onSelectDesign/onSelectStyle setDesign/setStyle become two-way bound design/style
                    )->a( n = `design` v = client->_bind( design )
                    )->a( n = `style`  v = client->_bind( style )
                    )->leaf( `Label`
                        )->a( n = `text` v = `Toolbar content `
                    " bActionContext (selected design is not Info) is an expression over the bound design
                    )->leaf( `Button`
                        )->a( n = `text`    v = `Action1`
                        )->a( n = `visible` v = |\{= ${ client->_bind( design ) } !== 'Info' \}|
                    )->leaf( `Button`
                        )->a( n = `text`    v = `Action2`
                        )->a( n = `visible` v = |\{= ${ client->_bind( design ) } !== 'Info' \}|

                )->shut(
            )->shut(
        )->shut( ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD model_init.

    " keys of sap.m.ToolbarDesign / sap.m.ToolbarStyle (the original derives them from Object.keys)
    t_design_types = VALUE #( ( key = `Auto` ) ( key = `Transparent` ) ( key = `Solid` ) ( key = `Info` ) ).
    t_style_types  = VALUE #( ( key = `Standard` ) ( key = `Clear` ) ).
    design = `Auto`.
    style  = `Standard`.

  ENDMETHOD.

ENDCLASS.
