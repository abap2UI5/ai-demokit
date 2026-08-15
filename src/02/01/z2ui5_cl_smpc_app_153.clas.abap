CLASS z2ui5_cl_smpc_app_153 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

    DATA showclearicon TYPE abap_bool.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_153 IMPLEMENTATION.

  METHOD z2ui5_if_app~main.

    me->client = client.
    IF client->check_on_init( ).
      " the original binds {/showClearIcon} but sets no model - the binding
      " stays unresolved and the property keeps its default false
      showclearicon = abap_false.
      view_display( ).
    ENDIF.

  ENDMETHOD.


  METHOD view_display.

    DATA(view) = z2ui5_cl_ui5_view_builder=>factory( ).

    view->ele( n = `View` ns = `mvc`
        )->a( n = `xmlns:mvc`  v = `sap.ui.core.mvc`
        )->a( n = `xmlns:form` v = `sap.ui.layout.form`
        )->a( n = `height`     v = `100%`
        )->a( n = `xmlns`      v = `sap.m`

        )->ele( `App`
            )->ele( `Page`
                )->a( n = `showHeader` v = `false`

                )->ele( n = `SimpleForm` ns = `form`
                    )->a( n = `title`    v = `Generic Mask Input`
                    )->a( n = `editable` v = `true`
                    )->a( n = `layout`   v = `ColumnLayout`

                    )->tag( `Label`
                        )->a( n = `text` v = `Unique ID`
                    )->ele( `MaskInput`
                        )->a( n = `mask`             v = `~~~~~~~~~~`
                        )->a( n = `placeholderSymbol` v = `_`
                        )->a( n = `placeholder`      v = `All characters allowed`
                        )->ele( `rules`
                            )->tag( `MaskInputRule`
                                )->a( n = `maskFormatSymbol` v = `~`
                                )->a( n = `regex`            v = `[^_]`

                        )->end(
                    )->end(
                    )->tag( `Label`
                        )->a( n = `text` v = `Promo code`
                    )->ele( `MaskInput`
                        )->a( n = `mask`             v = `**********`
                        )->a( n = `placeholderSymbol` v = `_`
                        )->a( n = `placeholder`      v = `Latin characters (case insensitive) and numbers`
                        )->ele( `rules`
                            )->tag( `MaskInputRule`

                        )->end(
                    )->end(
                    )->tag( `Label`
                        )->a( n = `text` v = `Phone number`
                    )->tag( `MaskInput`
                        )->a( n = `mask`             v = `(999) 999 999999`
                        )->a( n = `placeholderSymbol` v = `_`
                        )->a( n = `placeholder`      v = `Enter twelve-digit number`
                        " showClearIcon is @since 1.96 - kept 1:1 (POST_171)
                        )->a( n = `showClearIcon`    v = `true`

                )->end(

                )->ele( n = `SimpleForm` ns = `form`
                    )->a( n = `title`    v = `Possible usages (may require additional coding)`
                    )->a( n = `editable` v = `true`
                    )->a( n = `layout`   v = `ColumnLayout`

                    )->tag( `Label`
                        )->a( n = `text` v = `Serial number`
                    )->ele( `MaskInput`
                        )->a( n = `mask`             v = `CCCC-CCCC-CCCC-CCCC-CCCC`
                        )->a( n = `placeholderSymbol` v = `_`
                        )->a( n = `placeholder`      v = `Enter digits and capital letters`
                        )->a( n = `showClearIcon`    v = client->_bind( showclearicon )
                        )->ele( `rules`
                            )->tag( `MaskInputRule`
                                )->a( n = `maskFormatSymbol` v = `C`
                                )->a( n = `regex`            v = `[A-Z0-9]`

                        )->end(
                    )->end(
                    )->tag( `Label`
                        )->a( n = `text` v = `Product activation key`
                    )->ele( `MaskInput`
                        )->a( n = `mask`             v = `SAP-CCCCC-CCCCC`
                        )->a( n = `placeholderSymbol` v = `_`
                        )->a( n = `placeholder`      v = `Starts with 'SAP' followed by digits and capital letters`
                        )->a( n = `showClearIcon`    v = client->_bind( showclearicon )
                        )->ele( `rules`
                            )->tag( `MaskInputRule`
                                )->a( n = `maskFormatSymbol` v = `C`
                                )->a( n = `regex`            v = `[A-Z0-9]`

                        )->end(
                    )->end(
                    )->tag( `Label`
                        )->a( n = `text` v = `ISBN`
                    )->tag( `MaskInput`
                        )->a( n = `mask`             v = `999-99-999-9999-9`
                        )->a( n = `placeholderSymbol` v = `_`
                        )->a( n = `placeholder`      v = `Enter thirteen-digit number`
                        )->a( n = `showClearIcon`    v = client->_bind( showclearicon ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
