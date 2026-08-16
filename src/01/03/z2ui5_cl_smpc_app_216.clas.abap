" @keywords objectpageheadercontent object header content sap.uxap headercontent objectpageheaderlayoutdata
" @summary This is an example of an ObjectPageHeaderContent.
CLASS z2ui5_cl_smpc_app_216 DEFINITION PUBLIC.

  PUBLIC SECTION.
    INTERFACES z2ui5_if_app.

  PROTECTED SECTION.
    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display.

  PRIVATE SECTION.
ENDCLASS.


CLASS z2ui5_cl_smpc_app_216 IMPLEMENTATION.

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
        )->a( n = `xmlns`        v = `sap.uxap`
        )->a( n = `xmlns:mvc`    v = `sap.ui.core.mvc`
        )->a( n = `xmlns:layout` v = `sap.ui.layout`
        )->a( n = `xmlns:m`      v = `sap.m`
        )->a( n = `height`       v = `100%`

        )->ele( `ObjectPageHeaderContent`
            )->ele( `content`
                )->ele( n = `VerticalLayout` ns = `layout`
                    )->tag( n = `ObjectStatus` ns = `m`
                        )->a( n = `title` v = `User ID`
                        )->a( n = `text`  v = `12345678`
                    )->tag( n = `ObjectStatus` ns = `m`
                        )->a( n = `title` v = `Functional Area`
                        )->a( n = `text`  v = `Developement`
                    )->tag( n = `ObjectStatus` ns = `m`
                        )->a( n = `title` v = `Cost Center`
                        )->a( n = `text`  v = `PI DFA GD Programs and Product`
                    )->tag( n = `ObjectStatus` ns = `m`
                        )->a( n = `title` v = `Email`
                        )->a( n = `text`  v = `email@address.com`

                )->end(

                )->tag( n = `Text` ns = `m`
                    )->a( n = `width` v = `200px`
                    )->a( n = `text`  v = `Hi, I'm Denise. I am passionate about what I do and I'll go the extra mile to make the customer win.`
                )->tag( n = `ObjectStatus` ns = `m`
                    )->a( n = `text`  v = `In Stock`
                    )->a( n = `state` v = `Error`
                )->tag( n = `ObjectStatus` ns = `m`
                    )->a( n = `title` v = `Label`
                    )->a( n = `text`  v = `In Stock`
                    )->a( n = `state` v = `Warning`
                )->tag( n = `ObjectNumber` ns = `m`
                    )->a( n = `number`     v = `1000`
                    )->a( n = `unit`       v = `SOOK`
                    )->a( n = `emphasized` v = `false`
                    )->a( n = `state`      v = `Success`
                )->tag( n = `ProgressIndicator` ns = `m`
                    )->a( n = `percentValue` v = `30`
                    )->a( n = `displayValue` v = `30%`
                    )->a( n = `showValue`    v = `true`
                    )->a( n = `state`        v = `None`

                )->ele( n = `VerticalLayout` ns = `layout`
                    )->tag( n = `Label` ns = `m`
                        )->a( n = `text` v = `PC, Unrestricted-Use Stock`
                    )->tag( n = `ObjectNumber` ns = `m`
                        )->a( n = `class`  v = `sapMObjectNumberLarge`
                        )->a( n = `number` v = `219`
                        )->a( n = `unit`   v = `K`

                )->end(

                )->ele( n = `VerticalLayout` ns = `layout`
                    )->ele( n = `layoutData` ns = `layout`
                        )->tag( `ObjectPageHeaderLayoutData`
                            )->a( n = `visibleS` v = `false`

                    )->end(

                    )->tag( n = `Label` ns = `m`
                        )->a( n = `text` v = `PC, Not in Small Size`
                    )->tag( n = `ObjectNumber` ns = `m`
                        )->a( n = `class`  v = `sapMObjectNumberLarge`
                        )->a( n = `number` v = `220`
                        )->a( n = `unit`   v = `K`

                )->end(

                )->ele( n = `VerticalLayout` ns = `layout`
                    )->ele( n = `layoutData` ns = `layout`
                        )->tag( `ObjectPageHeaderLayoutData`
                            )->a( n = `visibleM` v = `false`

                    )->end(

                    )->tag( n = `Label` ns = `m`
                        )->a( n = `text` v = `PC, Not in Medium Size`
                    )->tag( n = `ObjectNumber` ns = `m`
                        )->a( n = `class`  v = `sapMObjectNumberLarge`
                        )->a( n = `number` v = `221`
                        )->a( n = `unit`   v = `K`

                )->end(

                )->ele( n = `VerticalLayout` ns = `layout`
                    )->ele( n = `layoutData` ns = `layout`
                        )->tag( `ObjectPageHeaderLayoutData`
                            )->a( n = `visibleL`           v = `false`
                            )->a( n = `showSeparatorAfter` v = `true`

                    )->end(

                    )->tag( n = `Label` ns = `m`
                        )->a( n = `text` v = `PC, Not in Large Size`
                    )->tag( n = `ObjectNumber` ns = `m`
                        )->a( n = `class`  v = `sapMObjectNumberLarge`
                        )->a( n = `number` v = `219`
                        )->a( n = `unit`   v = `K`

                )->end(

                )->tag( n = `ObjectAttribute` ns = `m`
                    )->a( n = `title` v = `Label`
                    )->a( n = `text`  v = `In Stock`
                )->tag( n = `Button` ns = `m`
                    )->a( n = `icon`    v = `sap-icon://nurse`
                    )->a( n = `tooltip` v = `nurse`

                )->ele( n = `Tokenizer` ns = `m`
                    )->tag( n = `Token` ns = `m`
                        )->a( n = `text` v = `Wayne Enterprises`
                    )->tag( n = `Token` ns = `m`
                        )->a( n = `text` v = `Big's Caramels` ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.

ENDCLASS.
